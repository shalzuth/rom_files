autoImport("LotteryMonthData")
autoImport("LotteryRecoverData")

LotteryProxy = class('LotteryProxy', pm.Proxy)
LotteryProxy.Instance = nil
LotteryProxy.NAME = "LotteryProxy"

LotteryType = {
	Head = SceneItem_pb.ELotteryType_Head,
	Equip = SceneItem_pb.ELotteryType_Equip,
	Card = SceneItem_pb.ELotteryType_Card,
	CatLitterBox = SceneItem_pb.ELotteryType_CatLitterBox,
	Magic = SceneItem_pb.ELotteryType_Magic,
}

local EffectConfig = {
	[LotteryType.CatLitterBox] = {ActionId = 506, IdleActionId = 504},
}

local selfGetItemList = {}
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear

function LotteryProxy:ctor(proxyName, data)
	self.proxyName = proxyName or LotteryProxy.NAME
	if LotteryProxy.Instance == nil then
		LotteryProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function LotteryProxy:Init()
	self.callTime = {}
	self.infoMap = {}
	self.recoverMap = {}
	self.filterCardList = {}

	self:InitEquipLottery();
end

function LotteryProxy:CallQueryLotteryInfo(type)
	local currentTime = Time.unscaledTime
	local nextValidTime = self:_GetNextValidTime(type)
	if nextValidTime == nil or nextValidTime <= currentTime then
		self:SetNextValidTime(type, 5)

		--call		
		helplog("CallQueryLotteryInfo")
		ServiceItemProxy.Instance:CallQueryLotteryInfo(nil, type)
	end
end

function LotteryProxy:RecvQueryLotteryInfo(servicedata)
	helplog("RecvQueryLotteryInfo")
	local type = servicedata.type
	if type == LotteryType.Head then
		self:SetNextValidTime(type, 60)

		if self.infoMap[type] == nil then
			self.infoMap[type] = LotteryMonthData.new()
		end
		self.infoMap[type]:SetData(servicedata)
	end

	local info
	for i=1,#servicedata.infos do
		info = servicedata.infos[i]

		if type == LotteryType.Equip or type == LotteryType.CatLitterBox then
			local data = LotteryData.new(info)
			data:SortItemsByRate()
			self.infoMap[type] = data

		elseif type == LotteryType.Magic then
			local data = LotteryData.new(info)
			self.infoMap[type] = data
			
		elseif type == LotteryType.Card then
			local data = LotteryData.new(info)
			data:SortItemsByQuality()
			self.infoMap[type] = data
		end
	end

	self.infoMap[type]:SetTodayCount(servicedata.today_cnt, servicedata.max_cnt)
end

function LotteryProxy:RecvLotteryCmd(data)
	self.npcid = data.npcid
	local lotteryType = data.type
	local npcRole = SceneCreatureProxy.FindCreature(data.npcid)
	local isSelf = data.charid == Game.Myself.data.id
	local effectConfig = EffectConfig[lotteryType]

	--????????????
	if isSelf then
		--????????? ???????????????
		if data.ticket == 0 and data.guid == "" then
			local info = self.infoMap[lotteryType]
			if info ~= nil then
				info:SetTodayCount(data.today_cnt)
			end
		end

		--????????????
		local skipType = self:GetSkipType(lotteryType)
		if self:IsSkipGetEffect(skipType) then
			self:ShowFloatAward(data.items)
			return
		end
	else
		--???????????? ?????????????????? ????????????
		if self.isOpenView then
			return
		end
	end

	--???????????????
	if isSelf then
		_ArrayClear(selfGetItemList)
		for i=1,#data.items do
			local item = data.items[i]
			local itemData = ItemData.new(item.guid, item.id)
			_ArrayPushBack(selfGetItemList, itemData)
		end
	end
	if npcRole then
		--??????
		local actionId = 200
		if effectConfig ~= nil and effectConfig.ActionId ~= nil then
			actionId = effectConfig.ActionId
		end
		self:PlayAction(npcRole, actionId)
		--??????
		local effectName = EffectMap.Maps.Lottery
		if effectConfig ~= nil and effectConfig.Effect ~= nil then
			effectName = effectConfig.Effect
		end
		if self.effect then
			self.effect:Destroy()
			self.effect = nil
		end
		self.effect = npcRole:PlayEffect(nil, effectName, 0, nil, nil, true)
		self.effect:RegisterWeakObserver(self)
		--??????
		local audioName = AudioMap.Maps.LotteryMech
		if effectConfig ~= nil and effectConfig.Audio ~= nil then
			audioName = effectConfig.Audio
		end
		npcRole:PlayAudio(audioName)

		if isSelf then
			self:sendNotification(LotteryEvent.EffectStart)

			--??????????????????
			LeanTween.delayedCall(GameConfig.Delay.lottery / 1000, function ()
				FloatAwardView.addItemDatasToShow(selfGetItemList, nil, nil, true)
				_ArrayClear(selfGetItemList)

				--??????????????????
				self:PlayIdleAction(npcRole, effectConfig)

				self:sendNotification(LotteryEvent.EffectEnd)
			end)
		else
			self:RemoveOtherLT()
			self.otherLT = LeanTween.delayedCall(GameConfig.Delay.lottery / 1000, function ()
				--??????????????????
				self:PlayIdleAction(npcRole, effectConfig)

				self:RemoveOtherLT()
			end)
		end
	else
		--?????????npc,????????????????????????
		if isSelf then
			self:ShowFloatAward(data.items)
		end
	end
end

function LotteryProxy:ObserverDestroyed(obj)
	if obj == self.effect then
		self.effect = nil
	end
end

function LotteryProxy:PlayAction(npc, actionId)
	if npc ~= nil and actionId ~= nil then
		local actionName
		local config = Table_ActionAnime[actionId]
		if config ~= nil then
			actionName = config.Name
		end
		if actionName ~= nil then
			npc:Client_PlayAction(actionName, nil, false)
		end
	end
end

function LotteryProxy:SetLotteryBuyCnt(c,t)
	self.today_cnt=c
	self.max_cnt=t
end

function LotteryProxy:GetLotteryBuyCnt()
	if(not self.today_cnt)then
		return 0,0
	end
	return self.today_cnt,self.max_cnt
end

function LotteryProxy:PlayIdleAction(npcRole, effectConfig)
	local idleActionId
	if effectConfig ~= nil and effectConfig.IdleActionId ~= nil then
		idleActionId = effectConfig.IdleActionId
	end
	if idleActionId ~= nil then
		self:PlayAction(npcRole, idleActionId)
	end
end

function LotteryProxy:ShowFloatAward(items)
	local list = ReusableTable.CreateArray()
	for i=1,#items do
		local itemData = ItemData.new(items[i].guid, items[i].id)
		_ArrayPushBack(list, itemData)
	end
	
	FloatAwardView.addItemDatasToShow(list, nil, nil, true)
	ReusableTable.DestroyAndClearArray(list)
end

function LotteryProxy:RemoveOtherLT()
	if self.otherLT ~= nil then
		self.otherLT:cancel()
		self.otherLT = nil
	end
end

function LotteryProxy:SetNextValidTime(type, time)
	type = type or 1
	self.callTime[type] = Time.unscaledTime + time
end

function LotteryProxy:_GetNextValidTime(type)
	type = type or 1
	return self.callTime[type]
end

function LotteryProxy:GetInfo(type)
	return self.infoMap[type]
end

function LotteryProxy:GetMonthGroupId(year, month)
	if year and month then
		local id
		if month >= 1 and month <= 6 then
			id = 1
		elseif month >= 7 and month <= 12 then
			id = 2
		end
		return year * 10 + id
	end

	return nil
end

function LotteryProxy:GetHeadwearMonthGroupById(groupId)
	local info = self.infoMap[LotteryType.Head]
	if info ~= nil then
		return info:GetMonthGroupById()
	end

	return nil
end

function LotteryProxy:GetRecover(type)
	if self.recoverMap[type] == nil then
		self.recoverMap[type] = {}
	else
		_ArrayClear(self.recoverMap[type])
	end

	local lotteryData = self.infoMap[type]
	if lotteryData ~= nil then
		local items = BagProxy.Instance:GetMainBag():GetItems()
		for i=1,#items do
			local bagData = items[i]
			local lotteryItemData
			if type == LotteryType.Head then
				lotteryItemData = self:GetLotteryItemDataFromList(bagData.staticData.id, lotteryData:GetMonthGroupList())
			else
				lotteryItemData = lotteryData:GetLotteryItemData(bagData.staticData.id)
			end
			if lotteryItemData ~= nil and lotteryItemData.recoverPrice ~= 0 then
				local data = LotteryRecoverData.new( bagData:Clone() )
				data:SetInfo(lotteryItemData, type)
				_ArrayPushBack(self.recoverMap[type], data)
			end
		end
	end

	return self.recoverMap[type]
end

function LotteryProxy:GetLotteryItemDataFromList(itemid, list)
	for i=1,#list do
		local data = list[i]:GetLotteryItemData(itemid)
		if data ~= nil then
			return data
		end
	end

	return nil
end

--????????????????????????????????????????????????
function LotteryProxy:GetRecoverTotalPrice(selectList, type)
	local total = 0
	local recoverList = self.recoverMap[type]
	if recoverList then
		for i=1,#selectList do
			for j=1,#recoverList do
				local recover = recoverList[j]
				if selectList[i] == recover.itemData.id then
					total = total + recover.cost
					break
				end
			end
		end
	end

	return total
end

--?????????????????????????????????????????????
function LotteryProxy:GetRecoverTotalCost(selectList, type)
	local total = 0
	local recoverList = self.recoverMap[type]
	if recoverList then
		for i=1,#selectList do
			for j=1,#recoverList do
				local recover = recoverList[j]
				if selectList[i] == recover.itemData.id then
					total = total + recover.totalCost
					break
				end
			end
		end
	end

	return total
end

function LotteryProxy:FilterCard(quality)
	local info = self.infoMap[LotteryType.Card]
	if info then
		if quality == 0 then
			return info.items
		end

		_ArrayClear(self.filterCardList)

		for i=1,#info.items do
			local data = info.items[i]
			local item = data:GetItemData()
			if item.staticData and item.staticData.Quality == quality then 
				_ArrayPushBack(self.filterCardList, data)
			end
		end

		table.sort(self.filterCardList, LotteryData.SortItemByQuality)

		return self.filterCardList
	end
end

function LotteryProxy:GetSkipType(lotteryType)
	if lotteryType == LotteryType.Head then
		return SKIPTYPE.LotteryHeadwear
	elseif lotteryType == LotteryType.Equip then
		return SKIPTYPE.LotteryEquip
	elseif lotteryType == LotteryType.Card then
		return SKIPTYPE.LotteryCard
	elseif lotteryType == LotteryType.Magic then
		return SKIPTYPE.LotteryMagic
	elseif lotteryType == LotteryType.CatLitterBox then
		return SKIPTYPE.LotteryCatLitter
	end

	return nil
end

function LotteryProxy:IsSkipGetEffect(type)
	if type ~= nil then
		return LocalSaveProxy.Instance:GetSkipAnimation(type)
	end
end

function LotteryProxy:SetIsOpenView(isOpen)
	self.isOpenView = isOpen
end

function LotteryProxy:GetSpecialEquipCount(selectList, type)
	local isExist = false
	local totalTicket = 0
	local recoverList = self.recoverMap[type]
	if recoverList then
		for i=1,#selectList do
			for j=1,#recoverList do
				local recover = recoverList[j]
				if selectList[i] == recover.itemData.id and ShopMallProxy.Instance:JudgeSpecialEquip(recover.itemData) then
					isExist = true
					totalTicket = totalTicket + recover.specialCost
					break
				end
			end
		end
	end

	return isExist, totalTicket
end

function LotteryProxy:CheckTodayCanBuy(type)
	local info = self.infoMap[type]
	if info ~= nil then
		if info.maxCount == 0 then
			return true
		end

		return info.todayCount < info.maxCount
	end

	return true
end

function LotteryProxy:DownloadMagicPicFromUrl(picUrl)
	local urlFileName = string.match(picUrl, ".+/([^/]*%.%w+)$")

	local sb = LuaStringBuilder.CreateAsTable()
	sb:Append(IOPathConfig.Paths.PUBLICPIC.LotteryPicture)
	sb:Append("/")
	sb:Append(urlFileName)
	local localPath = sb:ToString()
	if localPath then
		local currentTime = math.floor(ServerTime.CurServerTime() / 1000)
		local bytes = DiskFileManager.Instance:LoadFile(localPath, currentTime)
		if bytes then
			local localMd5 = MyMD5.HashBytes(bytes)
			local urlMd5 = string.match(picUrl, ".+/([^/]*)%.%w+$")
			if urlMd5 == localMd5 then
				return bytes
			end
		end

		sb:Clear()
		sb:Append(Application.persistentDataPath)
		sb:Append("/TempDownloadLottery/")
		sb:Append(urlFileName)
		local tempPath = sb:ToString()
		sb:Destroy()
		if tempPath then
			if FileHelper.ExistFile(tempPath) then
				FileHelper.DeleteFile(tempPath)
			end

			if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
				local taskRecordID = CloudFile.CloudFileManager.Ins:Download(picUrl, tempPath, false,
				function (progress)

				end,
				function ()
					local bytes = FileHelper.LoadFile(tempPath)
					local currentTime = math.floor(ServerTime.CurServerTime() / 1000)
					DiskFileManager.Instance:SaveFile(localPath, bytes, currentTime)

					FileHelper.DeleteFile(tempPath)

					self:sendNotification(LotteryEvent.MagicPictureComplete, {picUrl = picUrl, bytes = bytes})
				end,
				function (errorMessage)
					if FileHelper.ExistFile(tempPath) then
						FileHelper.DeleteFile(tempPath)
					end
				end, nil)
			else
				local taskRecordID = CloudFile.CloudFileManager.Ins:Download(picUrl, tempPath, false,
				function (progress)

				end,
				function ()
					local bytes = FileHelper.LoadFile(tempPath)
					local currentTime = math.floor(ServerTime.CurServerTime() / 1000)
					DiskFileManager.Instance:SaveFile(localPath, bytes, currentTime)

					FileHelper.DeleteFile(tempPath)

					self:sendNotification(LotteryEvent.MagicPictureComplete, {picUrl = picUrl, bytes = bytes})
				end,
				function (errorMessage)
					if FileHelper.ExistFile(tempPath) then
						FileHelper.DeleteFile(tempPath)
					end
				end)
			end
		end
	end
end

function LotteryProxy.SortEquipLottery(a, b)
	local alevel, blevel = a.Level, b.Level;
	return alevel[1] < b.Level[1];
end
function LotteryProxy:InitEquipLottery()
	if(not Table_EquipLottery)then
		return;
	end

	self.equipLottery_Map = {};
	for _, data in pairs(Table_EquipLottery)do
		local itemid = data.ItemId;
		if(not self.equipLottery_Map[itemid])then
			self.equipLottery_Map[itemid] = {};
		end

		table.insert(self.equipLottery_Map[itemid], data);
	end

	for _,datas in pairs(self.equipLottery_Map)do
		table.sort(datas, LotteryProxy.SortEquipLottery);
	end
end

function LotteryProxy:GetEquipLotteryShowDatas(itemid)
	if(self.equipLottery_Map == nil)then
		return;
	end

	local config = self.equipLottery_Map[itemid];
	if(config)then
		local mylevel = MyselfProxy.Instance:RoleLevel();

		local index;
		for i=1,#config do
			local level_regin = config[i].Level;
			if(mylevel >= level_regin[1] and mylevel <= level_regin[2])then
				index = i;
				break;
			end
		end
		if(index)then
			return config[index], config[index+1];
		end
	end
end

function LotteryProxy:IsLotteryEquip(itemid)
	if(self.equipLottery_Map == nil)then
		return false;
	end
	return self.equipLottery_Map[itemid] ~= nil;
end