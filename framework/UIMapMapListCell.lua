autoImport('UIModelKaplaTransmit')
autoImport('ActivityEventProxy')

local baseCell = autoImport("BaseCell")
UIMapMapListCell = class("UIMapMapListCell", baseCell)

function UIMapMapListCell:Init()
	self.labName = self:FindGO("Name"):GetComponent(UILabel)
	self.goCurrency = self:FindGO("Currency")
	self.labCurrencyCount = self:FindGO("Count", self.goCurrency):GetComponent(UILabel)
	self.goTransfer = self:FindGO("Transfer")
	self.spTransferBG = self:FindGO("BG", self.goTransfer):GetComponent(UISprite)
	self.labTransferTitle = self:FindGO("Title", self.goTransfer):GetComponent(UILabel)
	self:AddClickEvent(self.gameObject, function (go)
		self:OnClick(go)
	end)
	----[[ todo xde 0002151: 泰语下选择传送区域界面，传送按钮字体模糊，能否优化
	if(AppBundleConfig.GetSDKLang() == 'th') then
		local title = self:FindGO("Title", self.goTransfer):GetComponent(UILabel)
		title.width = 72
		title.overflowMethod = 3
		title.fontSize = 18
	else
		redlog('ztm')
		printData('dd', AppBundleConfig.GetSDKLang())
	end
	--]]
end

function UIMapMapListCell:SetData(data)
	self.mapInfo = data
	if self.mapInfo then
		self.labName.text = self.mapInfo.NameZh
		-- self.currencyCount = self:IsCurrentMap() and 0 or self.mapInfo.Money
		local isFree = ActivityEventProxy.Instance:IsFreeTransferMap(self.mapInfo.id,UIMapMapList.transmitType)
		self.currencyCount = isFree and 0 or self.mapInfo.Money
		if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Single then
			local handInHandPlayerID = UIModelKaplaTransmit.Ins():GetHandInHandPlayerID_Teammate_NotCat()
			if handInHandPlayerID ~= nil then
				self.currencyCount = self.currencyCount * GameConfig.MapTrans.HandRate
			end
		elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
			local followingTeammatesID = UIModelKaplaTransmit.Ins():GetFollowingTeammates()
			if followingTeammatesID ~= nil then
				local followingTeammateCount = #followingTeammatesID
				self.currencyCount = (1 + followingTeammateCount) * self.currencyCount
			end
		end
		if self.currencyCount then
			self.currencyCount = math.floor(self.currencyCount)
			self.labCurrencyCount.text = self.currencyCount
		end
	end

	if self:IsActive() then
		self:AddClickEvent(self.goTransfer, function (go)
			self:OnButtonTransferClick(go)
		end)
	else
		self.spTransferBG.spriteName = "com_btn_13"
		self.labTransferTitle.applyGradient = false
		self.labTransferTitle.effectColor = Color.gray
	end
end

function UIMapMapListCell:OnClick(go)

end

function UIMapMapListCell:OnButtonTransferClick(go)
	local ticketCount = 0
	local ticketCount1 = BagProxy.Instance:GetItemNumByStaticID(5040, BagProxy.BagType.MainBag)
	if ticketCount1 ~= nil then
		ticketCount = ticketCount + ticketCount1
	end
	ticketCount1 = BagProxy.Instance:GetItemNumByStaticID(5040, BagProxy.BagType.Storage)
	if ticketCount1 ~= nil then
		ticketCount = ticketCount + ticketCount1
	end
	ticketCount1 = BagProxy.Instance:GetItemNumByStaticID(5040, BagProxy.BagType.PersonalStorage)
	if ticketCount1 ~= nil then
		ticketCount = ticketCount + ticketCount1
	end

	local isROBEnough = false
	if self.mapInfo.Money == nil then
		isROBEnough = true
	else
		isROBEnough = CostUtil.CheckROB(self.currencyCount or self.mapInfo.Money)
	end

	if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Single then
		local handInHandPlayerID = UIModelKaplaTransmit.Ins():GetHandInHandPlayerID_Teammate_NotCat()
		if handInHandPlayerID ~= nil then
			if isROBEnough then
				ServiceNUserProxy.Instance:CallGoToGearUserCmd(self.mapInfo.id, SceneUser2_pb.EGoToGearType_Hand, {handInHandPlayerID})
				self:Notify("UIMapMapList.CloseSelf", {})
			else
				MsgManager.ShowMsgByIDTable(1)
			end
		else
			if ticketCount > 0 then
				ServiceNUserProxy.Instance:CallGoToGearUserCmd(self.mapInfo.id, SceneUser2_pb.EGoToGearType_Single, nil)
				self:Notify("UIMapMapList.CloseSelf", {})
			elseif isROBEnough then
				ServiceNUserProxy.Instance:CallGoToGearUserCmd(self.mapInfo.id, SceneUser2_pb.EGoToGearType_Single, nil)
				self:Notify("UIMapMapList.CloseSelf", {})
			else
				MsgManager.ShowMsgByIDTable(1)
			end
		end
	elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
		if isROBEnough then
			local followingTeammatesID = UIModelKaplaTransmit.Ins():GetFollowingTeammates()
			ServiceNUserProxy.Instance:CallGoToGearUserCmd(self.mapInfo.id, SceneUser2_pb.EGoToGearType_Team, followingTeammatesID)
			self:Notify("UIMapMapList.CloseSelf", {})
		else
			MsgManager.ShowMsgByIDTable(1)
		end
	end
end

function UIMapMapListCell:IsActive()
	if self.isActive == nil then
		local activeMaps = WorldMapProxy.Instance.activeMaps
		if activeMaps == nil then
			self.isActive = false
		else
			self.isActive = activeMaps[self.mapInfo.id] == 1;
		end
	end
	return self.isActive
end

function UIMapMapListCell:IsCurrentMap()
	if self.mapInfo == nil then return false end
	return self.mapInfo.id == Game.MapManager:GetMapID()
end