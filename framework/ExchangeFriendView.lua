autoImport("ExchangeFriendCell")

ExchangeFriendView = class("ExchangeFriendView",ContainerView)

ExchangeFriendView.ViewType = UIViewType.TipLayer

function ExchangeFriendView:OnEnter()
	ExchangeFriendView.super.OnEnter(self)
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
end

function ExchangeFriendView:OnExit()
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
	ExchangeFriendView.super.OnExit(self)
end

function ExchangeFriendView:Init()
	self:FindObj()
	self:AddViewEvt()
	self:InitShow()
end

function ExchangeFriendView:FindObj()
	self.empty = self:FindGO("Empty")
	self.loading = self:FindGO("Loading")
end

function ExchangeFriendView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateFriend)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.UpdateFriend)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.UpdateFriend)
	self:AddListenEvt(ShopMallEvent.ExchangeSelectFriend, self.CloseSelf)
end

function ExchangeFriendView:InitShow()
	local listContainer = self:FindGO("ListContainer")
	local wrapConfig = {
		wrapObj = listContainer, 
		pfbNum = 6, 
		cellName = "ExchangeFriendCell", 
		control = ExchangeFriendCell, 
		dir = 1,
		disableDragIfFit = true,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)

	self:UpdateFriend()
end

function ExchangeFriendView:UpdateFriend()
	local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData()
	local datas = FriendProxy.Instance:GetFriendData()
	if isQuerySocialData then
		self.empty:SetActive(#datas == 0)
		self.itemWrapHelper:UpdateInfo(datas)
	else
		self.empty:SetActive(false)
	end

	self.loading:SetActive(not isQuerySocialData)
end