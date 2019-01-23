autoImport("PetEggInfo")
PetWorkSpaceItemData = class("PetWorkSpaceItemData")

local CONST_GIFT_ID , CONST_GIFT_NUM = 700108, 1
local MONTHCARD = 3

function PetWorkSpaceItemData:ctor(id)
	self.id = id
	self.staticData = Table_Pet_WorkSpace[id]
	self.petEggs={}
	self.startTime = 0
	self:InitRewardArray()
end

function PetWorkSpaceItemData:SetServiceData(data)
	self.unlock = data.unlock
	self.state = data.state
	-- helplog("state: ",self.state,"id: ",self.id)
	self.startTime = data.starttime
	self.lastRewardTime = data.lastrewardtime or 0
	-- helplog("self.id : ",self.id,"self.lastrewardtime: ",self.lastRewardTime)
	self.curCounts = data.counts
	self.lastCounts = data.last_counts
	local serviceEggs = data.datas
	if(serviceEggs)then
		for i=1,#serviceEggs do
			local itemInfo = serviceEggs[i].base
			if(itemInfo and itemInfo.guid and ''~=itemInfo.guid)then
				local item = ItemData.new(itemInfo.guid,itemInfo.id)
				local PetInfo = PetEggInfo.new(item.staticData)
				PetInfo:Server_SetData(serviceEggs[i].egg)
				PetInfo.guid=itemInfo.guid
				self.petEggs[#self.petEggs+1]=PetInfo
			end
		end
	end
end

function PetWorkSpaceItemData:IsOpen()
	return self.unlock~=nil
end

function PetWorkSpaceItemData:IsUnlock()
	return self.unlock==true
end

function PetWorkSpaceItemData:_GetSinglePetByIndex(index)
	return self.petEggs[index]
end

function PetWorkSpaceItemData:GetPetNameByIndex(index)
	local petEgg = self:_GetSinglePetByIndex(index)
	if(petEgg)then
		return petEgg.name
	end
	return ""
end

function PetWorkSpaceItemData:GetPetIDByIndex(index)
	local petEgg = self:_GetSinglePetByIndex(index)
	if(petEgg)then
		return petEgg:GetPartsId()
	end
	return 0
end

function PetWorkSpaceItemData:GetPetEquips(index)
	local petEgg = self:_GetSinglePetByIndex(index)
	if(petEgg and petEgg.equips)then
		return petEgg.equips
	end
	return nil
end

local function IsRandomReward(teamId)
	local team_cfg = Game.Config_RewardTeam[teamId]
	if(team_cfg)then
		for k,v in pairs(team_cfg) do
			if(v.rewardType==2)then
				return true
			end
		end
	end
	return false
end

function PetWorkSpaceItemData:IsWorking()
	if(self.state)then
		return self.state ==PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_WORKING
	end
	return false
end

function PetWorkSpaceItemData:IsResting()
	if(self.state)then
		return self.state == PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_REST
	end
end

function PetWorkSpaceItemData:Unused()
	if(self.state)then
		return self.state ==PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_UNUSED
	end
	return false
end

local MONTHCARDID = 3
function PetWorkSpaceItemData:GetMultiCount(pet)
	local min_multi = self:GetDuringMinuteMulti()
	local fre = self:GetFrequency(pet)
	if 0==min_multi then
		return 0
	end
	if(fre<=0)then
		-- 不合法
		return 0
	end
	local endTime = self:GetEndTime()
	local lastCounts = self.lastCounts and #self.lastCounts>0 and self.lastCounts[1] or 0
	local count = PetFun.calcPetWorkRewardCount(self.startTime,endTime,fre,self.staticData.Max_reward,lastCounts)
	local maxReward = PetFun.calcPetWorkMaxReward(self.startTime,endTime,self.staticData.Max_reward)
	local curCount = self.curCounts and #self.curCounts>0 and self.curCounts[1] or 0
	count = math.min(count,maxReward)
	count = count - curCount
	return math.floor(count)
end

-- 公式里不考虑月卡
local cfgLimit = GameConfig.PetWorkSpace.pet_work_continue_day
function PetWorkSpaceItemData:GetEndTime()
	local curServerTime = ServerTime.CurServerTime() / 1000
	local endTime = self.startTime + cfgLimit * 86400   -- 三天的时间戳
	local monthCardExpireTime = PetWorkSpaceProxy.Instance:GetCardExpireTime()
	if(self.id~=MONTHCARDID)then  -- 不是月卡的场所
		endTime = math.min(endTime,curServerTime)
	else
		if(monthCardExpireTime)then
			endTime = math.min(endTime,curServerTime)
			endTime = math.min(endTime,monthCardExpireTime)
		end
	end
	return endTime
end

function PetWorkSpaceItemData:GetDuringTime()
	if(not self.startTime or 0==self.startTime)then
		return 0 
	end
	if(not self.lastRewardTime or 0==self.lastRewardTime)then
		return 0 
	end
	local curTime = ServerTime.CurServerTime() / 1000
	if(curTime<self.lastRewardTime)then
		helplog("异常,服务器时间被改了 上一次领奖时间 ",self.lastRewardTime,"当前服务器时间: ",curTime)
		return 0
	end
	local expireTime = PetWorkSpaceProxy:GetCardExpireTime()
	
	if(self.id==MONTHCARD and expireTime and expireTime<curTime and expireTime>self.lastRewardTime)then
		return expireTime - self.lastRewardTime
	end
	return curTime-self.startTime
end

function PetWorkSpaceItemData:GetDuringMinuteMulti()
	local duringTime = self:GetDuringTime()
	if(0==duringTime)then
		return 0
	end
	return ClientTimeUtil.GetFormatSecTimeStr(duringTime) 
end

function PetWorkSpaceItemData:IsOverCfgTime()
	local time = self:GetDuringTime()
	local isOver = ClientTimeUtil.FormatTimeBySec(time)>=GameConfig.PetWorkSpace.pet_work_continue_day
	if(isOver)then
		-- helplog("IsOverCfgTime 当前天数 ：",ClientTimeUtil.FormatTimeBySec(time))
	end
	return isOver
end

function PetWorkSpaceItemData:MaxRewardLimited()
	-- 先不考虑气泡 中公式算出来的奖励
	local maxReward = self:GetMaxRewardMulti()
	local curCount = self.curCounts and #self.curCounts>0 and self.curCounts[1] or 0
	local lastCount = self.lastCounts and #self.lastCounts>0 and self.lastCounts[1] or 0

	if(lastCount>=maxReward)then
		return true
	end
	if(curCount>=maxReward)then
		return true
	end
	-- 考虑公式
	local reachedCount 
	if(self.petEggs and #self.petEggs>0)then
		local getCount = self:GetMultiCount(self.petEggs[1])
		reachedCount = getCount + curCount
		if(reachedCount>=maxReward)then
			return true
		end
		reachedCount = getCount + lastCount
		if(reachedCount>=maxReward)then
			return true
		end
		reachedCount = curCount+lastCount
		if(reachedCount>=maxReward)then
			return true
		end
		reachedCount = reachedCount + getCount
		if(reachedCount>=maxReward)then
			return true
		end
	end
	return false
end

function PetWorkSpaceItemData:GetFrequency(pet)
	if(pet)then
		-- helplog("petWorkSkillID: ",self.petWorkSkillID)
		local result = PetFun.calcPetWorkFrequency(pet.petid,pet.lv,pet.friendlv,self.id,pet.petWorkSkillID)
		return math.floor(result)
	else
		return self.staticData.Frequency
	end
end

function PetWorkSpaceItemData:GetMaxRewardMulti()
	local max_continue_day = GameConfig.PetWorkSpace.pet_work_continue_day
	local curServerTime = ServerTime.CurServerTime() / 1000
	local DAY_SEC = 86400
	local starttime = self.startTime
	if(starttime==0)then
		return self.staticData.Max_reward
	end
	local startRefreshTime = self:_startTimeRefreshTime()
	local curRefreshTime = self:_curDayRefreshTime()
	local multiple = (curRefreshTime - startRefreshTime) / DAY_SEC 
	multiple = starttime < startRefreshTime and multiple+1 or multiple
	multiple = curServerTime > curRefreshTime and multiple+1 or multiple
	-- 不超过连续打工天数上限
	multiple = math.min(max_continue_day,multiple)
	-- helplog("奖励上限： ",multiple)
	return math.floor(multiple) * self.staticData.Max_reward 
end

-- 当天重置时间
function PetWorkSpaceItemData:_curDayRefreshTime()
	local curServerTime = ServerTime.CurServerTime() / 1000
	local curDay = os.date('*t', curServerTime)
	local t = os.time({year=curDay.year, month=curDay.month, day=curDay.day, hour=5})
	return t
end

-- 开始打工的当天重置时间
function PetWorkSpaceItemData:_startTimeRefreshTime()
	local starttime = self.startTime
	if(starttime==0)then
		return nil
	end
	local startDate = os.date("*t", starttime)
	local startRefreshTime = os.time({year=startDate.year, month=startDate.month, day=startDate.day, hour=5})
	return startRefreshTime
end

function PetWorkSpaceItemData:GetCurDayDuringTime()
	local curServerTime = ServerTime.CurServerTime() / 1000
	local refresTime = self:_curDayRefreshTime()
	refresTime = math.max(self.lastRewardTime,refresTime)
	local t = ClientTimeUtil.GetFormatSecTimeStr(curServerTime-refresTime) 
	return t
end

function PetWorkSpaceItemData:GetUIReward()
	if(0==startTime)then
		return nil
	end
	local pet = self.petEggs[1]
	local multiple = self:GetMultiCount(pet)
	local maxReward = self:GetMaxRewardMulti()
	local multiple_limit = math.min(multiple,maxReward)
	if(self.curCounts==nil or #self.curCounts==0)then
		if(multiple > 0  and #self.rewardArray>0)then
			local item = {}
			item.id = self.rewardArray[1].id
			-- helplog("一次都没领过 self.rewardArray[1].num: ",self.rewardArray[1].num,"当前可领次数: ",multiple)
			item.num = self.rewardArray[1].num * multiple_limit
			return item
		end
	end
	for i=1,#self.rewardArray do
		local getCount = self.curCounts and self.curCounts[i]
		local nilCount = (getCount==nil or getCount==0)
		if(not getCount)then
			-- helplog("已经领的次数：",getCount,"可领次数：",multiple)
		end
		-- helplog("已经过去的次数：",multiple,"getCount: ",getCount)
		local curMulti
		if(nilCount)then
			curMulti = multiple_limit
		else
			local total = multiple+getCount
			curMulti = total>maxReward and maxReward - getCount or multiple
		end

		if(curMulti>0)then
			local item = {}
			item.id = self.rewardArray[i].id
			-- helplog("之前领过的次数： ",getCount)
			-- helplog("之前领过奖励。self.rewardArray[i].num: ",self.rewardArray[i].num,"curMulti: ",curMulti)
			item.num = self.rewardArray[i].num * curMulti
			return item
		end
	end
	return nil
end

-- 随机礼包 礼包icon
-- 固定奖励：多个则礼包显示，单个则itemid、num
function PetWorkSpaceItemData:InitRewardArray()
	self.rewardArray={}
	local cfg = self.staticData.Reward
	if(cfg)then	
		for i=1,#cfg do
			local singleTeam = cfg[i]
			local item = {}
			if(IsRandomReward(singleTeam))then
				item.num = CONST_GIFT_NUM
				item.id = CONST_GIFT_ID
			else
				local rewards = ItemUtil.GetRewardItemIdsByTeamId(singleTeam);
				if(rewards)then
					if(#rewards==1)then
						item.num = rewards[1].num
						item.id = rewards[1].id
					elseif(#rewards>1)then
						item.num = CONST_GIFT_NUM
						item.id = CONST_GIFT_ID
					end
				end
			end
			local desc = self.staticData.Reward_desc
			item.helpDesc = desc and desc[singleTeam]
			TableUtility.ArrayPushBack(self.rewardArray, item)
		end
	end
end

function PetWorkSpaceItemData:GetRewardArray()
	return self.rewardArray
end

function PetWorkSpaceItemData:IsSpacePetRejected(petID)
	local limitedCsv = self.staticData.Work_limit
	if(limitedCsv and type(limitedCsv)=='table')then
		for i=1,#limitedCsv do
			if(petID==limitedCsv[i])then
				return true
			end
		end
	end
	return false
end

function PetWorkSpaceItemData:GetMenuID()
	local menu = self.staticData.UnlockMenu
	if(menu and menu.type=="menu")then
		local params = menu.params
		if(params and #params>0)then
			return params[1]
		end
	end
	return nil
end


