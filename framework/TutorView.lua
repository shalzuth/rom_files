autoImport("TutorCell")
autoImport("StudentView")

TutorView = class("TutorView",SubView)

local viewName = "view/TutorView"
local myTutorFunkey = {
	"InviteMember",
	"SendMessage",
	"AddFriend",
	"ShowDetail",
	"Tutor_DeleteTutor",
}
local classmateFunkey = {
	"InviteMember",
	"SendMessage",
	"AddFriend",
	"ShowDetail",
}
local tipData = {}

function TutorView:OnExit()
	if self.myTutorCell ~= nil then
		self.myTutorCell:OnDestroy()
		self.myTutorCell = nil
	end
	TutorView.super.OnExit(self)
end

function TutorView:FindObj()
	self.table = self:FindGO("Table")
	self.myTutor = self:FindGO("MyTutor")
	self.myClassmate = self:FindGO("MyClassmate")
	self.table = self:FindGO("Table"):GetComponent(UITable)
end

function TutorView:AddButtonEvt()
	local taskBtn = self:FindGO("TaskBtn")
	self:AddClickEvent(taskBtn, function ()
		self:Task()
	end)

	local graduationBtn = self:FindGO("GraduationBtn")
	self:AddClickEvent(graduationBtn, function ()
		self:Graduation()
	end)

	self:AddHelpButtonEvent()
end

function TutorView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateView)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.UpdateView)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.UpdateView)	
end

function TutorView:InitShow()
	--我的导师
	local myTutor = TutorProxy.Instance:GetMyTutor()
	if myTutor then
		local tutorContainer = self:FindGO("TutorContainer")
		local preferb = self:LoadPreferb("cell/TutorCell")
		preferb.transform:SetParent(tutorContainer.transform, false)

		local multiSp = preferb:GetComponent(UIMultiSprite)
		multiSp.CurrentState = 0

		self.myTutorCell = TutorCell.new(preferb)
		self.myTutorCell:AddEventListener(FriendEvent.SelectHead, self.ClickMyTutor, self)

		local graduationBtn = self:FindGO("GraduationBtn")
		self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_GROW_REWARD,graduationBtn, 4)
	end

	--我的同学
	local classmateGrid = self:FindGO("ClassmateGrid"):GetComponent(UIGrid)
	self.classmateCtl = UIGridListCtrl.new(classmateGrid, TutorCell, "TutorCell")
	self.classmateCtl:AddEventListener(FriendEvent.SelectHead, self.ClickClassmate, self)

	self:UpdateView()
end

function TutorView:UpdateMyTutor()
	local data = TutorProxy.Instance:GetMyTutor()
	if data and self.myTutorCell then
		self.myTutorCell:SetData(data)
	else
		self.myTutor:SetActive(false)
	end
end

function TutorView:UpdateMyClassmate()
	local data = TutorProxy.Instance:GetClassmateList()
	local isShow = #data > 0
	if isShow then
		self.classmateCtl:ResetDatas(data)
	end

	self.myClassmate:SetActive(isShow)
end

function TutorView:UpdateView()
	self:UpdateMyTutor()
	self:UpdateMyClassmate()

	self.table:Reposition()
end

function TutorView:Task()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TutorTaskView})
end

function TutorView:Graduation()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TutorGraduationView})
end

function TutorView:ClickMyTutor(cell)
	local data = cell.data
	if data then
		local playerData = PlayerTipData.new()
		playerData:SetByFriendData(data)

		FunctionPlayerTip.Me():CloseTip()

		local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380,60})

		tipData.playerData = playerData
		tipData.funckeys = myTutorFunkey

		playerTip:SetData(tipData)
	end
end

function TutorView:ClickClassmate(cell)
	local data = cell.data
	if data then
		local playerData = PlayerTipData.new()
		playerData:SetByFriendData(data)

		FunctionPlayerTip.Me():CloseTip()

		local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380,60})

		tipData.playerData = playerData
		tipData.funckeys = classmateFunkey

		playerTip:SetData(tipData)
	end
end

function TutorView:ChangeView()
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