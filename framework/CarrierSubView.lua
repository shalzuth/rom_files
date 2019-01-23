autoImport("ListCtrl")
autoImport("CarrierWaitListCell")
CarrierSubView = class("CarrierSubView",SubView)

function CarrierSubView:Init()
 	self:FindObjs()
 	self:AddBtnEvents()

 	self:Hide()

 	self:AddViewEvts()
end

function CarrierSubView:FindObjs()
	self.gameObject = self:FindGO("CarrierSubView")
	self.carrierStartBtn = self:FindGO("CarrierStart",self.gameObject):GetComponent(UIButton)
	self.carrierStartLabel = self:FindGO("Label",self.carrierStartBtn.gameObject):GetComponent(UILabel)
	self.carrierCancelBtn = self:FindGO("CarrierCancel",self.gameObject)
	self.carrierCancelLabel = self:FindGO("Label",self.carrierCancelBtn.gameObject):GetComponent(UILabel)
	self.waitGrid = self:FindGO("WaitList"):GetComponent(UIGrid)
	self.waitList = ListCtrl.new(self.waitGrid,CarrierWaitListCell,"CarrierWaitListCell")
end

function CarrierSubView:AddBtnEvents()
	self:AddClickEvent(self.carrierStartBtn.gameObject,function(go)
		-- local carrier = SceneCarrierProxy.Instance:GetMyCarrier()
		print("client->server 载具出发!")
		ServiceCarrierCmdProxy.Instance:CallCarrierStartUserCmd()
	end)

	self:AddClickEvent(self.carrierCancelBtn,function(go)
		-- local carrier = SceneCarrierProxy.Instance:GetMyCarrier()
		print("client->server 载具取消!")
		ServiceCarrierCmdProxy.Instance:CallLeaveCarrierUserCmd()
	end)
end

function CarrierSubView:AddViewEvts()
	self:AddListenEvt(CarrierEvent.ShowUI,self.ShowMe)
	self:AddListenEvt(CarrierEvent.MyCarrierStart,self.MyCarrierStartHandler)
	self:AddListenEvt(CarrierEvent.MyCarrierLeaveMember,self.MyCarrierLeaveMemberHandler)
	self:AddListenEvt(ServiceEvent.CarrierCmdCarrierWaitListUserCmd,self.InitWaitingMembers)
	self:AddListenEvt(ServiceEvent.CarrierCmdRetJoinCarrierUserCmd,self.MemberAgree)
end

function CarrierSubView:MyCarrierStartHandler(note)
	self:Hide()
end

function CarrierSubView:ShowMe(note)
	local carrier = SceneCarrierProxy.Instance:GetMyCarrier()
	if(carrier and carrier:IsWaiting() and carrier.isMine) then
		if(self:CheckNeedAutoLauch()==false) then
			self:Show()
			self:InitWaitingMembers()
			if(not carrier.iAmMaster) then
				self.carrierStartBtn.gameObject:SetActive(false)
				self.carrierCancelLabel.text = ZhString.CarrierSubView_Leave
			end
		end
	end
end

function CarrierSubView:InitWaitingMembers(note)
	local members = SceneCarrierProxy.Instance:GetMyWaitMembers()
	if(members) then
		self.waitList:ResetDatas(members)
	end
end

function CarrierSubView:MyCarrierLeaveMemberHandler(note)
	local id = note.body
	local cells = self.waitList:GetCells()
	for i=1,#cells do
		if(cells[i].data.id == id) then
			cells[i]:Leave()
			break
		end
	end
end

function CarrierSubView:MemberAgree(note)
	local member = note.body
	local cells = self.waitList:GetCells()
	for i=1,#cells do
		if(cells[i].data.name == member.membername) then
			cells[i]:Agree(member.agree)
			break
		end
	end
end

function CarrierSubView:CheckNeedAutoLauch()
	local members = SceneCarrierProxy.Instance:GetMyWaitMembers()
	if(members==nil or #members==0) then
		print("client->server 载具出发!（载具等待列表中没有其他人）")
		ServiceCarrierCmdProxy.Instance:CallCarrierStartUserCmd()
		return true
	end
	return false
end