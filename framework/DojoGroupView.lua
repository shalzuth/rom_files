autoImport("DojoGroupCell")

DojoGroupView = class("DojoGroupView",ContainerView)

DojoGroupView.ViewType = UIViewType.NormalLayer

function DojoGroupView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function DojoGroupView:FindObjs()
	self.groupContainer = self:FindGO("GroupContainer")
end

function DojoGroupView:AddEvts()
	-- body
end

function DojoGroupView:AddViewEvts()
	self:AddListenEvt(DojoEvent.EnterSuccess , self.CloseSelf)
end

function DojoGroupView:InitShow()
	local wrapConfig = {
		wrapObj = self.groupContainer, 
		pfbNum = 5, 
		cellName = "DojoGroupCell", 
		control = DojoGroupCell, 
		dir = 2,
	}
	self.wrapHelper = WrapCellHelper.new(wrapConfig)	
	self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickGroup, self)

	self:UpdataGroup()
end

function DojoGroupView:ClickGroup(cellctr)
	if cellctr.data and cellctr.canOpen then
		if MyselfProxy.Instance:RoleLevel() < cellctr.data.lvreq then
			MsgManager.ShowMsgByID(2950)
			return
		end

		ServiceDojoProxy.Instance:CallDojoPrivateInfoCmd(cellctr.data.DojoGroupId)
		print("CallDojoPrivateInfoCmd : "..cellctr.data.DojoGroupId)
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.DojoMainView ,  viewdata = cellctr.data.DojoGroupId })		
	end
end

function DojoGroupView:UpdataGroup()
	local data = DojoProxy.Instance:GetGroupData()
	self.wrapHelper:UpdateInfo(data)
end

function DojoGroupView:OnEnter()
	DojoGroupView.super.OnEnter(self);
end

function DojoGroupView:OnExit()
	PictureManager.Instance:UnLoadUI()
	DojoGroupView.super.OnExit(self);
end



