autoImport("AEFreeTransferData")
autoImport("AERewardData")
autoImport("AEResetData")
autoImport("AERewardItemData")
autoImport("AELotteryData")
autoImport("AEGuildBuildingData")

ActivityEventProxy = class('ActivityEventProxy', pm.Proxy)
ActivityEventProxy.Instance = nil;
ActivityEventProxy.NAME = "ActivityEventProxy"

ActivityEventType = {
	FreeTransfer = ActivityEvent_pb.EACTIVITYEVENTTYPE_FREE_TRANSFER,	--免费地图传送
	Reward = ActivityEvent_pb.EACTIVITYEVENTTYPE_REWARD,				--额外/翻倍奖励
	ResetTime = ActivityEvent_pb.EACTIVITYEVENTTYPE_RESETTIME,			--重置
	LotteryDiscount = ActivityEvent_pb.EACTIVITYEVENTTYPE_LOTTERY_DISCOUNT,	--扭蛋折扣
	LotteryBanner = ActivityEvent_pb.EACTIVITYEVENTTYPE_LOTTERY_BANNER,	--扭蛋Banner
	GuildBuildingSubmit = ActivityEvent_pb.EACTIVITYEVENTTYPE_GUILD_BUILDING_SUBMIT, -- 公会建筑提交材料效果提升类型
	Shop = ActivityEvent_pb.EACTIVITYEVENTTYPE_SHOP,					-- 商店
}

AERewardType = {
	Laboratory = ActivityEvent_pb.EAEREWARDMODE_LABORATORY,				--训练场
	WantedQuest = ActivityEvent_pb.EAEREWARDMODE_WANTEDQUEST,			--看板
	Seal = ActivityEvent_pb.EAEREWARDMODE_SEAL,							--裂隙
	GuildDonate = ActivityEvent_pb.EAEREWARDMODE_GUILD_DONATE,			--公会捐赠
	Tower = ActivityEvent_pb.EAEREWARDMODE_TOWER,						--无限塔
	GuildRaid = ActivityEvent_pb.EAEREWARDMODE_GUILDRAID,				--公会副本
	GuildDojo = ActivityEvent_pb.EAEREWARDMODE_GUILDDOJO,				--公会道场
	PveCard = ActivityEvent_pb.EAEREWARDMODE_PVECARD,					-- 卡牌副本
}

function ActivityEventProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ActivityEventProxy.NAME
	if ActivityEventProxy.Instance == nil then
		ActivityEventProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function ActivityEventProxy:Init()
	self.eventMap = {}
	self.userDataMap = {}
	self.bannerMap = {}
end

function ActivityEventProxy:RecvActivityEventNtf(servicedata)
	TableUtility.TableClear(self.eventMap)
	for i=1,#servicedata.events do
		local event = servicedata.events[i]
		local eventType = event.type
		if eventType == ActivityEventType.FreeTransfer then
			if self.eventMap[eventType] == nil then
				self.eventMap[eventType] = {}
			end
			local data = AEFreeTransferData.new(event.freetransfer)
			data:SetTime(event)
			table.insert(self.eventMap[eventType],data)
		elseif eventType == ActivityEventType.Reward then
			if self.eventMap[eventType] == nil then
				self.eventMap[eventType] = AERewardData.new()
			end
			self.eventMap[eventType]:SetReward(event)
		elseif eventType == ActivityEventType.ResetTime then
			if self.eventMap[eventType] == nil then
				self.eventMap[eventType] = {}
			end
			local data = AEResetData.new()
			table.insert(self.eventMap[eventType],data)

			for j=1,#event.resetinfo do
				data:SetData(event.resetinfo[j])
			end

		elseif eventType == ActivityEventType.LotteryDiscount then
			if self.eventMap[eventType] == nil then
				self.eventMap[eventType] = {} 
			end
			local data = AELotteryData.new()
			table.insert(self.eventMap[eventType],data)
			data:SetDiscount(event)
		elseif eventType == ActivityEventType.LotteryBanner then
			local lotterytype = event.lotterybanner.lotterytype
			if self.bannerMap[lotterytype] == nil then
				self.bannerMap[lotterytype] = {}
			end
			local data = AELotteryBannerData.new()
			table.insert(self.bannerMap[lotterytype],data)
			data:SetData(event)
		elseif eventType == ActivityEventType.GuildBuildingSubmit then
			if self.eventMap[eventType] == nil then
				self.eventMap[eventType] = {}
			end				
			local gData = AEGuildBuildingData.new(event.gbuildingsubmit)
			gData:SetTime(event)
			table.insert(self.eventMap[eventType],gData)
		end
	end
end

function ActivityEventProxy:RecvActivityEventUserDataNtf(servicedata)
	for i=1,#servicedata.rewarditems do
		local rewarditem = servicedata.rewarditems[i]
		self.userDataMap[rewarditem.mode] = AERewardItemData.new(rewarditem)
	end
end

function ActivityEventProxy:RecvActivityEventNtfEventCntCmd(servicedata)
	for i=1,#servicedata.cnt do
		local countdata = servicedata.cnt[i]
		local eventType = countdata.type
		local datas = self.eventMap[eventType]
		local data
		for i=1,#datas do
			data = datas[i]
			if data ~= nil then
				if eventType == ActivityEventType.LotteryDiscount then
					local discount = data:GetDiscountDataById(countdata.id)
					if discount ~= nil then
						discount:SetUsedCount(countdata.count)
					end
				end
			end
		end
	end
end

function ActivityEventProxy:IsFreeTransferMap(mapid,Ftype)
	local datas = self.eventMap[ActivityEventType.FreeTransfer]
	local data
	if(datas == nil)then
		return false
	end
	for i=1,#datas do
		data = datas[i]
		if data ~= nil then
			if data:IsFreeTransferMap(mapid,Ftype) then
				return true
			end
		end
	end

	return false
end

function ActivityEventProxy:IsStorageFree()
	local datas = self.eventMap[ActivityEventType.FreeTransfer]
	if(datas == nil)then
		return false
	end
	local data
	for i=1,#datas do
		data = datas[i]
		if data ~= nil then
			if data:IsStorageFree() then
				return true
			end
		end		
	end
	return false
end

function ActivityEventProxy:GetUserDataByType(rewardType)
	return self.userDataMap[rewardType]
end

function ActivityEventProxy:GetRewardByType(rewardType)
	local event = self.eventMap[ActivityEventType.Reward]
	if event ~= nil then
		return event:GetRewardByType(rewardType)
	end
end

function ActivityEventProxy:GetPveCardRewardByDif(difficulty)
	local event = self.eventMap[ActivityEventType.Reward]
	if event ~= nil then
		local reward = event:GetRewardByType(AERewardType.PveCard)
		return reward:GetRewardByDifficulty(difficulty)
	end
end

function ActivityEventProxy:GetResetTimeByType(rewardType)
	local events = self.eventMap[ActivityEventType.ResetTime]
	if not events then return nil end
	local event
	for i=1,#events do
		event = events[i]
		if event ~= nil then
			return event:GetDataByType(rewardType)
		end
	end
end

function ActivityEventProxy:GetLotteryDiscount(lotterytype)
	local events = self.eventMap[ActivityEventType.LotteryDiscount]
	if not events then return nil end
	local event
	for i=1,#events do
		event = events[i]
		if event ~= nil then
			return event:GetDiscount(lotterytype)
		end
	end
end

function ActivityEventProxy:GetLotteryDiscountByCoinType(lotterytype, cointype, year, month)
	local events = self.eventMap[ActivityEventType.LotteryDiscount]
	if not events then return nil end
	local event
	for i=1,#events do
		event = events[i]
		if event ~= nil then
			return event:GetDiscountByCoinType(lotterytype, cointype, year, month)
		end
	end
end

function ActivityEventProxy:GetLotteryBanner(lotterytype)
	if self.bannerMap then
		return self.bannerMap[lotterytype]
	end
end

function ActivityEventProxy:GetGuildBuildingEventData()
	local events = self.eventMap[ActivityEventType.GuildBuildingSubmit]
	if not events then return nil end
	local event
	for i=1,#events do
		event = events[i]
		if event then
			return event
		end
	end
end
