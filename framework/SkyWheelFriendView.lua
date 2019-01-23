autoImport("SkyWheelFriendCell")

SkyWheelFriendView = class("SkyWheelFriendView",ContainerView)

SkyWheelFriendView.ViewType = UIViewType.PopUpLayer

function SkyWheelFriendView:OnEnter()
	self.super.OnEnter(self)
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
end

function SkyWheelFriendView:OnExit()
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
	self.super.OnExit(self)
end

function SkyWheelFriendView:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:InitShow()
end

function SkyWheelFriendView:FindObj()
	self.go = self:FindGO("FriendView")
	self.ContentContainer = self:FindGO("ContentContainer" , self.go)
	self.ListTip = self:FindGO("ListTip" , self.go):GetComponent(UILabel)
end

function SkyWheelFriendView:AddButtonEvt()

end

function SkyWheelFriendView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData,self.UpdateFriendData)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate,self.UpdateFriendData)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate,self.UpdateSocialData)
end

function SkyWheelFriendView:InitShow()
	self.ListTip.text = ZhString.Friend_ListTip

	local wrapConfig = {
		wrapObj = self.ContentContainer, 
		pfbNum = 10, 
		cellName = "SkyWheelFriendCell", 
		control = SkyWheelFriendCell, 
		dir = 1,
		disableDragIfFit = true,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.itemWrapHelper:AddEventListener(SkyWheel.Select, self.HandleClickSelect , self)

	self:UpdateFriendData()
end

function SkyWheelFriendView:HandleClickSelect(cellctl)
	local data = cellctl.data
	if data then
		-- self.container:SetData(data)
		self:sendNotification(SkyWheel.ChangeTarget , data)
		self:CloseSelf()
	end
end

function SkyWheelFriendView:UpdateFriendData()
	local datas = FriendProxy.Instance:GetFriendData()
	
	if #datas > 0 then
		self.ListTip.gameObject:SetActive(false)
	else
		self.ListTip.gameObject:SetActive(true)
	end

	self.itemWrapHelper:UpdateInfo(datas)
end

function SkyWheelFriendView:UpdateSocialData(data)
	self:UpdateFriendData()

	local itemList = self.itemWrapHelper:GetCellCtls()
	for i=1,#itemList do
		local cellctl = itemList[i]
		if cellctl.data and cellctl.data.guid == data.body.guid and 
			data.body.type == SessionSociality_pb.ESOCIALDATA_OFFLINETIME then
			cellctl:RefreshOfflinetime()
		end
	end
end