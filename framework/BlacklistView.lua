autoImport("BlacklistCell")

BlacklistView = class("BlacklistView",ContainerView)

BlacklistView.ViewType = UIViewType.ChatroomLayer

function BlacklistView:OnEnter()
	BlacklistView.super.OnEnter(self)
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
end

function BlacklistView:OnExit()
	if not self.isFromMatcherView then
		ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
	end
	BlacklistView.super.OnExit(self)
end

function BlacklistView:Init()
	self:FindObj()
	self:InitShow()
	self:AddButtonEvt()
	self:AddViewEvt()
end

function  BlacklistView:FindObj()
	self.ListTip = self:FindGO("ListTip"):GetComponent(UILabel)
end

function BlacklistView:InitShow()
	self.ListTip.text = ZhString.Blacklist_ListTip

	self.funkey = {
		"ForeverBlacklist",
		"RemoveFromBlacklist"
	}
	self.foreverFunkey = {
		"RemoveFromForeverBlacklist"
	}
	self.tipData = {}

	local contentContainer = self:FindGO("ContentContainer")
	local wrapConfig = {
		wrapObj = contentContainer, 
		pfbNum = 10, 
		cellName = "BlacklistCell", 
		control = BlacklistCell, 
		dir = 1,
		disableDragIfFit = true,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.itemWrapHelper:AddEventListener(BlacklistEvent.SelectHead, self.HandleClickItem, self)

	self:UpdateBlacklistData()
	self.isFromMatcherView = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.isFromMatcherView
end

function BlacklistView:HandleClickItem(cellctl)
	local data = cellctl.data

	local playerData = PlayerTipData.new()
	playerData:SetByFriendData(cellctl.data)

	FunctionPlayerTip.Me():CloseTip()

	TableUtility.TableClear(self.tipData)
	self.tipData.playerData = playerData
	if data:IsForeverBlack() then
		self.tipData.funckeys = self.foreverFunkey
	else
		self.tipData.funckeys = self.funkey
	end

	FunctionPlayerTip.Me():GetPlayerTip( cellctl.headIcon.clickObj , NGUIUtil.AnchorSide.Left, {-380,60},self.tipData)
end

function BlacklistView:AddButtonEvt()
	local CloseButton = self:FindGO("CloseButton")
	self:AddClickEvent(CloseButton,function (g)
		if not self.isFromMatcherView then
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.FriendMainView})
		end
		self:CloseSelf()
	end)
end

function BlacklistView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData,self.UpdateBlacklistData)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate,self.UpdateBlacklistData)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate,self.UpdateBlacklistData)
end

function BlacklistView:UpdateBlacklistData()
	local datas = FriendProxy.Instance:GetBlacklist(true)
	
	if #datas > 0 then
		self.ListTip.gameObject:SetActive(false)
	else
		self.ListTip.gameObject:SetActive(true)
	end

	self.itemWrapHelper:UpdateInfo(datas)
end