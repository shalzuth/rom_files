autoImport("TutorGuideView")
autoImport("TutorView")
autoImport("StudentView")

TutorMainView = class("TutorMainView",SubView)

function TutorMainView:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:InitShow()
end

function TutorMainView:FindObj()
	
end

function TutorMainView:AddButtonEvt()
	
end

function TutorMainView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateView)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.UpdateView)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.UpdateView)	
end

function TutorMainView:InitShow()
	self.tutorGuideView = self.container:AddSubView("TutorGuideView", TutorGuideView)
	self.tutorView = self.container:AddSubView("TutorView", TutorView, nil, PanelConfig.TutorView)
	self.studentView = self.container:AddSubView("StudentView", StudentView, nil, PanelConfig.TutorView)
end

--点击时处理
function TutorMainView:ChangeView()
	local _RedTipProxy = RedTipProxy.Instance
	_RedTipProxy:SeenNew(SceneTip_pb.EREDSYS_TUTOR_TUTOR_UNLOCK)
	_RedTipProxy:SeenNew(SceneTip_pb.EREDSYS_TUTOR_STUDENT_UNLOCK)

	self:UpdateView()
end

function TutorMainView:UpdateView()
	local _TutorProxy = TutorProxy.Instance
	local view
	if _TutorProxy:CheckAsStudentLevel() and _TutorProxy:GetMyTutor() ~= nil then
		view = self.tutorView
	elseif _TutorProxy:CanAsTutor() and #_TutorProxy:GetStudentList() > 0 then
		view = self.studentView
	else
		view = self.tutorGuideView
	end

	if self.lastView == nil or self.lastView ~= view then
		if self.lastView ~= nil then
			self.lastView.gameObject:SetActive(false)
		end

		view:ChangeView()
		self.lastView = view

		view.gameObject:SetActive(true)
	end
end