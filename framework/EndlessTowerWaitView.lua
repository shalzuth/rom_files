autoImport("ListCtrl")
autoImport("CarrierWaitListCell")

EndlessTowerWaitView = class("EndlessTowerWaitView",ContainerView)

EndlessTowerWaitView.ViewType = UIViewType.PopUpLayer

function EndlessTowerWaitView:Init()
	self.waitCell = self:LoadPreferb("cell/WaitCell", self.gameObject)
	self.waitCell.transform.localPosition = Vector3.zero

 	self:FindObjs()
 	self:AddBtnEvents()
 	self:AddViewEvts()
 	self:InitShow()
end

function EndlessTowerWaitView:FindObjs()
	self.startBtn = self:FindGO("StartBtn")
	self.cancelBtn = self:FindGO("CancelBtn")
	self.waitGrid = self:FindGO("WaitList"):GetComponent(UIGrid)
	self.waitList = ListCtrl.new(self.waitGrid,CarrierWaitListCell,"CarrierWaitListCell")
end

function EndlessTowerWaitView:AddBtnEvents()
	self:AddClickEvent(self.startBtn,function(go)
		ServiceInfiniteTowerProxy.Instance:CallEnterTower(self.towerid,Game.Myself.data.id)			

		self:CloseSelf()
	end)

	self:AddClickEvent(self.cancelBtn,function(go)
		ServiceInfiniteTowerProxy.Instance:CallTeamTowerInviteCmd(true)

		self:CloseSelf()
	end)
end

function EndlessTowerWaitView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd, self.HandleFollowStateChange)
end

function EndlessTowerWaitView:InitShow()
	if self.viewdata.viewdata then
		self.towerid = self.viewdata.viewdata
	end
	self:UpdateWait()
end

function EndlessTowerWaitView:UpdateWait()
	local members = EndlessTowerProxy.Instance:GetWaitData()
	self.waitList:ResetDatas(members)
end

function EndlessTowerWaitView:HandleFollowStateChange(note)
	local data = note.body
	if data then
		local cells = self.waitList:GetCells()
		for i=1,#cells do
			local cell = cells[i]
			if cell.data.id == data.userid and cell.data:CanIn() then
				cell:Agree( data.eType ~= SceneUser2_pb.EFOLLOWTYPE_BREAK )
				break
			end
		end	
	end
end