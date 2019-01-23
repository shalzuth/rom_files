autoImport("SelectFriendCell")

SelectFriendView = class("SelectFriendView",ContainerView)

SelectFriendView.ViewType = UIViewType.PopUpLayer

function SelectFriendView:OnEnter()
	SelectFriendView.super.OnEnter(self)
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
end

function SelectFriendView:OnExit()
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
	SelectFriendView.super.OnExit(self)
end

function SelectFriendView:Init()
	self:FindObj()
	self:AddEvt()
	self:AddViewEvt()
	self:InitShow()
end

function SelectFriendView:FindObj()
	self.loading = self:FindGO("Loading")
	self.empty = self:FindGO("Empty")
end

function SelectFriendView:AddEvt()
	
end

function SelectFriendView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateView)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.UpdateView)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.UpdateView)	
end

function SelectFriendView:InitShow()
	local container = self:FindGO("Container")
	local wrapConfig = ReusableTable.CreateTable()
	wrapConfig.wrapObj = container
	wrapConfig.pfbNum = 7
	wrapConfig.cellName = "SelectFriendCell"
	wrapConfig.control = SelectFriendCell
	wrapConfig.dir = 1
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
	self.itemWrapHelper:AddEventListener(SelectFriendEvent.Select, self.HandleSelect, self)
	ReusableTable.DestroyTable(wrapConfig)

	self:UpdateView()
end

function SelectFriendView:UpdateView()
	local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData()
	local data = FriendProxy.Instance:GetFriendData()
	if isQuerySocialData then
		self.itemWrapHelper:UpdateInfo(data)
		self.empty:SetActive(#data == 0)
	else
		self.empty:SetActive(false)
	end

	self.loading:SetActive(not isQuerySocialData)	
end

function SelectFriendView:HandleSelect(cell)
	local data = cell.data
	if data ~= nil then
		self:sendNotification(SelectFriendEvent.Select, data)
		self:CloseSelf()
	end
end