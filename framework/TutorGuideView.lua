TutorGuideView = class("TutorGuideView",SubView)

local viewName = "view/TutorGuideView"

local  _TutorMatchStatus = TutorProxy.TutorMatchStatus
function TutorGuideView:FindObj()
	self.studentDesc = self:FindGO("StudentDesc"):GetComponent(UILabel)
	self.tutorDesc = self:FindGO("TutorDesc"):GetComponent(UILabel)
	self.asTutorLabel = self:FindGO("AsTutorLabel"):GetComponent(UILabel)
	self.requestBtn = self:FindGO("TutorRequestBtn")
end

function TutorGuideView:AddButtonEvt()
	local findTutorBtn = self:FindGO("FindTutorBtn")
	self:AddClickEvent(findTutorBtn, function ()
		self:FindTutor()
	end)

	local findStudentBtn = self:FindGO("FindStudentBtn")
	self:AddClickEvent(findStudentBtn, function ()
		self:FindStudent()
	end)

	self:AddClickEvent(self.requestBtn, function ()

		local tutorMatchStatus = TutorProxy.Instance:GetTutorMatStatus()
		local check = not tutorMatchStatus or _TutorMatchStatus.Stop == tutorMatchStatus or _TutorMatchStatus.Restart == tutorMatchStatus
		local isFindTutor =	TutorProxy.Instance:CanAsStudent()
		if  not check then
			MsgManager.ShowMsgByID(25446)
			return
		end

		self:UpdateApply()
	end)
end

function TutorGuideView:AddViewEvt()
	
end

function TutorGuideView:InitShow()
	self.studentDesc.text = GameConfig.Tutor.student_desc
	self.tutorDesc.text = GameConfig.Tutor.tutor_desc

	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_APPLY, self.requestBtn, 6, {-5,-5})

	self:UpdateAsTutor()
end

function TutorGuideView:UpdateAsTutor()
	self.CheckOpenTutor = FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.Tutor.tutor_menuid)
	if self.CheckOpenTutor then
		self.asTutorLabel.text = ZhString.Tutor_Guide_FindStudent
	else
		self.asTutorLabel.text = ZhString.Tutor_Guide_AsTutor
	end
end

function TutorGuideView:FindTutor()
	if TutorProxy.Instance:CheckAsTutorLevel() then
		MsgManager.ShowMsgByID(3202, GameConfig.Tutor.tutor_baselv_req)
	elseif not TutorProxy.Instance:CanAsStudent() then
		MsgManager.ShowMsgByID(3200)
	else
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TutorMatchView, viewdata = TutorType.Tutor})
		self.container:CloseSelf()
	end
end

function TutorGuideView:FindStudent()
	if TutorProxy.Instance:CheckAsTutorLevel() then
		if self.CheckOpenTutor then
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TutorMatchView, viewdata = TutorType.Student})
		self.container:CloseSelf()
		else
			FuncShortCutFunc.Me():CallByID(970)
		end
	else
		MsgManager.ShowMsgByID(3201, GameConfig.Tutor.tutor_baselv_req)
	end
end

function TutorGuideView:UpdateApply()
	local data = TutorProxy.Instance:GetApplyList()
	if #data > 0 then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TutorApplyView})
	else
		RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_TUTOR_APPLY)
		MsgManager.ShowMsgByID(3232)
	end
end

function TutorGuideView:ChangeView()
	if self.init == nil then
		local preferb = self:LoadPreferb(viewName)
		preferb.transform:SetParent(self.container.tutorRoot.transform, false)
		self.trans = preferb.transform
		self.gameObject = preferb

		local panel = self.container.gameObject:GetComponent(UIPanel)
		local uipanels = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
		for i=1,#uipanels do
			uipanels[i].depth = uipanels[i].depth + panel.depth
		end

		self:FindObj()
		self:AddButtonEvt()
		self:AddViewEvt()
		self:InitShow()

		self.init = true
	end
end