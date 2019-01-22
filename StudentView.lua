autoImport("TutorCell")

StudentView = class("StudentView",SubView)

local viewName = "view/StudentView"
local studentFunkey = {
	"InviteMember",
	"SendMessage",
	"AddFriend",
	"ShowDetail",
	"Tutor_DeleteStudent",
	"InviteEnterGuild",
}
local recentStudentFunkey = {
	"InviteMember",
	"SendMessage",
	"AddFriend",
	"ShowDetail",
	"InviteEnterGuild",
}
local tipData = {}

function StudentView:FindObj()
	self.myStudent = self:FindGO("MyStudent")
	self.addStudent = self:FindGO("OpenAddStudent")
	self.recentStudent = self:FindGO("RecentStudent")
	self.applyBtn = self:FindGO("ApplyBtn")
	self.table = self:FindGO("Table"):GetComponent(UITable)

	--todo xde fix ui
	local lb1 = self:FindGO("Label1",self.addStudent):GetComponent(UILabel)
	lb1.transform.localPosition = Vector3(220,-20,0)
	OverseaHostHelper:FixLabelOver(lb1,360)

	local lb2 = self:FindGO("Title",self.myStudent):GetComponent(UILabel)
	OverseaHostHelper:ShrinkFixLabelOver(lb2,100)
end

function StudentView:AddButtonEvt()
	self:AddClickEvent(self.applyBtn, function ()
		self:Apply()
	end)

	local shopBtn = self:FindGO("ShopBtn")
	self:AddClickEvent(shopBtn, function ()
		self:Shop()
	end)

	local addBtn = self:FindGO("AddBtn")
	self:AddClickEvent(addBtn, function ()
		self:Add()
	end)

	self:AddHelpButtonEvent()
end

function StudentView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateView)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.UpdateView)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.UpdateView)
end

function StudentView:InitShow()
	--????????????
	local studentGrid = self:FindGO("StudentGrid"):GetComponent(UIGrid)
	self.studentCtl = UIGridListCtrl.new(studentGrid, TutorCell, "StudentCell")
	self.studentCtl:AddEventListener(FriendEvent.SelectHead, self.ClickStudent, self)

	--???????????????
	local recentStudentGrid = self:FindGO("RecentStudentGrid"):GetComponent(UIGrid)
	self.recentStudentCtl = UIGridListCtrl.new(recentStudentGrid, TutorCell, "TutorCell")
	self.recentStudentCtl:AddEventListener(FriendEvent.SelectHead, self.ClickRecentStudent, self)

	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_APPLY, self.applyBtn, 6, {-5,-5})

	self:UpdateView()
end

function StudentView:Apply()
	local data = TutorProxy.Instance:GetApplyList()
	if #data > 0 then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TutorApplyView})
	else
		RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_TUTOR_APPLY)
		MsgManager.ShowMsgByID(3232)
	end
end

function StudentView:Shop()
	FuncShortCutFunc.Me():CallByID(972)
end

function StudentView:Add()
	-- TutorProxy.Instance:TryFind(TutorType.Student)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TutorMatchView, viewdata = TutorType.Student})
	self.container:CloseSelf()
end

function StudentView:UpdateStudent()
	local _TutorProxy = TutorProxy.Instance
	local data = _TutorProxy:GetStudentList()
	local studentCount = #data
	if studentCount > 0 then
		self.studentCtl:ResetDatas(data)
	end

	self.addStudent:SetActive(not _TutorProxy:CheckStudentFull())
end

function StudentView:UpdateRecentStudent()
	local data = TutorProxy.Instance:GetRecentStudentList()
	local isShow = #data > 0
	if isShow then
		self.recentStudentCtl:ResetDatas(data)
	end

	self.recentStudent:SetActive(isShow)
end

function StudentView:UpdateView()
	self:UpdateStudent()
	self:UpdateRecentStudent()

	self.table:Reposition()
end

function StudentView:ClickStudent(cell)
	local data = cell.data
	if data then
		local playerData = PlayerTipData.new()
		playerData:SetByFriendData(data)

		FunctionPlayerTip.Me():CloseTip()

		local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380,60})

		tipData.playerData = playerData
		tipData.funckeys = studentFunkey

		playerTip:SetData(tipData)
	end
end

function StudentView:ClickRecentStudent(cell)
	local data = cell.data
	if data then
		local playerData = PlayerTipData.new()
		playerData:SetByFriendData(data)

		FunctionPlayerTip.Me():CloseTip()

		local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380,60})

		tipData.playerData = playerData
		tipData.funckeys = recentStudentFunkey

		playerTip:SetData(tipData)
	end
end

function StudentView:ChangeView()
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
end