autoImport("UITableListCtrl")
autoImport("DojoCell")
autoImport("DojoMsgCell")

DojoMainView = class("DojoMainView",ContainerView)

DojoMainView.ViewType = UIViewType.NormalLayer

function DojoMainView:OnExit()
	self:SetChooseDojoData(false)
	DojoMainView.super.OnExit(self)
end

function DojoMainView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function DojoMainView:FindObjs()
	self.dojoContainer = self:FindGO("DojoContainer")
	self.contentTable = self:FindGO("ContentTable")
	self.contentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
	self.sendMesBtn = self:FindGO("SendMesBtn")
	self.enterBtn = self:FindGO("EnterBtn")
	self.closeButton = self:FindGO("CloseButton")
	self.chatScrollView = self:FindGO("ChatScrollView"):GetComponent(UIScrollView)

	UIUtil.LimitInputCharacter(self.contentInput, 20)
end

function DojoMainView:AddEvts()
	self:AddClickEvent(self.sendMesBtn,function (g)
		self:ClickSendMesBtn()
	end)
	self:AddClickEvent(self.enterBtn,function (g)
		self:ClickEnterBtn()
	end)
	self:AddClickEvent(self.closeButton,function (g)
		self:ClickClose()
	end)
end

function DojoMainView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.DojoDojoPrivateInfoCmd , self.RecvPrivateInfo)
	self:AddListenEvt(ServiceEvent.DojoDojoPublicInfoCmd , self.UpdateMsg)
	self:AddListenEvt(ServiceEvent.DojoDojoAddMsg , self.RecvAddMsg)
	self:AddListenEvt(DojoEvent.EnterSuccess , self.CloseSelf)
	self:AddListenEvt(ServiceEvent.DojoDojoSponsorCmd , self.HandleInvite)
end

function DojoMainView:InitShow()

	local wrapConfig = {
		wrapObj = self.dojoContainer, 
		pfbNum = 6, 
		cellName = "DojoCell", 
		control = DojoCell, 
		dir = 1,
	}
	self.wrapHelper = WrapCellHelper.new(wrapConfig)	
	self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDojo, self)

	self.msgTableContent = UITableListCtrl.new(self.contentTable , "UI" , 1)
	local config = {
		cellType = DojoCellType,
		cellName = "DojoMsgCell",
		control = DojoMsgCell
	}
	self.msgTableContent:SetType(config)

	if self.viewdata.viewdata then
		self.groupId = self.viewdata.viewdata
	end

	self:UpdateDojo()
end

function DojoMainView:ClickDojo(cellCtr)
	if cellCtr.data then
		local id = cellCtr.data.id
		if id ~= self.dojoid then
			local dojoData = Table_Guild_Dojo[id]
			if dojoData and dojoData.DojoOpen == 0 then
				MsgManager.ShowMsgByID(2952)
				return
			end

			if cellCtr.data:GetLock() then
				MsgManager.ShowMsgByID(2951)
				return
			end

			self:SetChooseDojoData(false)
			self:SetChooseCell(false)
			
			self.dojoid = id

			self:SetChooseDojoData(true)
			cellCtr:SetChoose(true)
			
			ServiceDojoProxy.Instance:CallDojoPublicInfoCmd(self.dojoid)
			print("CallDojoPublicInfoCmd : "..self.dojoid)
		end
	end
end

function DojoMainView:UpdateDojo()
	local data = DojoProxy.Instance:GetDojoData(self.groupId)
	self.wrapHelper:UpdateInfo(data)
end

function DojoMainView:UpdateMsg()
	local data = DojoProxy.Instance:GetMsgData(self.dojoid)
	self.msgTableContent:UpdateInfo(data)
end

function DojoMainView:RecvPrivateInfo()
	self:UpdateDojo()
	self:ChooseDojoCell(1)
end

function DojoMainView:RecvAddMsg()
	self.chatScrollView:ResetPosition()
	self:UpdateMsg()
end

function DojoMainView:ChooseDojoCell(index)
	local cells = self.wrapHelper:GetCellCtls()
	if #cells >= index then
		self:ClickDojo(cells[index])
	end
end

function DojoMainView:ClickSendMesBtn()
	local content = self.contentInput.value
	-- content = FunctionMaskWord.Me():ReplaceMaskWord(content , FunctionMaskWord.MaskWordType.Chat)
	if content and #content>0 then
		local msg = {}
		msg.conent = content
		ServiceDojoProxy.Instance:CallDojoAddMsg(self.dojoid , msg)
		print("CallDojoAddMsg: "..content)
		self.contentInput.value = ""	
	end
end

function DojoMainView:ClickEnterBtn()
	if TeamProxy.Instance:IHaveTeam() then
		ServiceDojoProxy.Instance:CallDojoSponsorCmd(self.dojoid)
		LogUtility.InfoFormat("CallDojoSponsorCmd: {0}",self.dojoid)
	else
		MsgManager.ShowMsgByIDTable(324)
	end
end

function DojoMainView:ClickClose()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.DojoGroupView})
	ServiceDojoProxy.Instance:CallDojoPanelOper()
	self:CloseSelf()
end

function DojoMainView:HandleInvite(note)
	LogUtility.Info("RecvDojoSponsorCmd~~~~~~~~~")
	local data = note.body
	if data then
		if data.ret then
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.DojoWaitView ,  viewdata = self.dojoid })
		else
			MsgManager.ConfirmMsgByID(2903,function ()
				self:sendNotification(FollowEvent.Follow, data.sponsorid)
				self:CloseSelf()
			end , nil , nil , data.sponsorname)
		end
	end
end

function DojoMainView:SetChooseDojoData(isChoose)
	local data = DojoProxy.Instance:GetDojoData(self.groupId)
	for i=1,#data do
		if data[i].id == self.dojoid then
			data[i]:SetChoose(isChoose)
			break
		end
	end
end

function DojoMainView:SetChooseCell(isChoose)
	local cells = self.wrapHelper:GetCellCtls()
	for i=1,#cells do
		if cells[i].data.id == self.dojoid then
			cells[i]:SetChoose(isChoose)
			break
		end
	end
end