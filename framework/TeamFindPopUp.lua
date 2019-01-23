TeamFindPopUp = class("TeamFindPopUp", ContainerView)

TeamFindPopUp.ViewType = UIViewType.NormalLayer

autoImport("TeamCell");
autoImport("TeamGoalCombineCell");

function TeamFindPopUp:Init()
	self:InitUI();
	self:AddViewInerest();
end

function TeamFindPopUp:InitUI()

	local findPage = self:FindGO("TeamFind");

	-- Team levels begin
	local filter = self:FindComponent("LevelPopUpFilter", UIPopupList);

	local minlvOption = { 0 };
	local filterlvConfig = GameConfig.Team.filtratelevel;
	local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL);
	for i=1,#filterlvConfig do
		if(filterlvConfig[i] <= mylv)then
			table.insert(minlvOption, filterlvConfig[i]);
		end
	end
	for i=1,#minlvOption do
		local minlv = minlvOption[i];
		if(minlv == 0)then
			filter:AddItem(ZhString.TeamFindPopUp_NoneFilterLevel, 0);
		else
			filter:AddItem(string.format(ZhString.TeamFindPopUp_StartLevel, minlv), minlv);
		end
	end

	self.filterlevel = 0;
	EventDelegate.Add (filter.onChange, function()
		if(self.filterlevel ~= filter.data)then
			self.filterlevel = filter.data;
			self:CallTeamList(1, true);
		end
	end);
	-- Team levels end

	-- Team Goals begin
	local goalslist = self:FindComponent("GoalsTabel", UITable, findPage);
	self.goalListCtl = UIGridListCtrl.new(goalslist,TeamGoalCombineCell , "TeamGoalCombineCell");
	self.goalListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self);
	-- Team Goals end

	-- Team list begin
	local teamlistObj = self:FindGO("TeamList", findPage);
	local wrapConfig = {
		wrapObj = teamlistObj,
		cellName = "TeamCell",
		control = TeamCell,
	};
	self.teamListCtl = WrapCellHelper.new(wrapConfig);
	self.noteamtip = self:FindGO("NoTeamTip");
	--todo xde fix ui
	local Sprite = self:FindGO("Sprite",self.noteamtip):GetComponent(UISprite);
	local widget = self.noteamtip:GetComponent(UIWidget)
	widget.pivot = UIWidget.Pivot.Right;
	widget.transform.localPosition = Vector3(260,39,0)
	Sprite.pivot = UIWidget.Pivot.Left;
	Sprite.transform.localPosition = Vector3(0,6,0)
	OverseaHostHelper:FixAnchor(widget.rightAnchor,Sprite.transform,0,0)
	

	local scrollView = self:FindComponent("TeamsScroll", UIScrollView);
	scrollView.momentumAmount = 100;
	NGUIUtil.HelpChangePageByDrag(scrollView, function ()
		if(self.nowPage)then
			local page = math.max(self.nowPage - 1, 1);
			self:CallTeamList(page);
		end
	end, function ()
		if(self.nowPage)then
			local page = self.nowPage + 1;
			if(self.maxPage)then
				page = math.min(self.maxPage, page);
			end
			self:CallTeamList(page);
		end
	end, 120)
	-- Team list end

	self:AddButtonEvent("CreateTeamButton", function (go)
		self:CreateTeam();
	end);
	self:AddButtonEvent("RefreshButton", function (go)
		self:CallTeamList(1, true);
	end);
	self:AddButtonEvent("InviteMemberButton", function (go)
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamInvitePopUp}) 
	end);

	--todo xde
	local inviteMemberButton = self:FindGO("Label",self:FindGO("InviteMemberButton")):GetComponent(UILabel)
	inviteMemberButton.fontSize = 23
	OverseaHostHelper:FixLabelOverV1(inviteMemberButton,3,180)
	local createTeamButton = self:FindGO("Label",self:FindGO("CreateTeamButton")):GetComponent(UILabel)
	createTeamButton.fontSize = 23
	OverseaHostHelper:FixLabelOverV1(createTeamButton,3,180)
	local refreshButton = self:FindGO("Label",self:FindGO("RefreshButton")):GetComponent(UILabel)
	refreshButton.fontSize = 23
	OverseaHostHelper:FixLabelOverV1(refreshButton,3,180)

	-- Quick Enter begin
	self.quickEnterButton = self:FindGO("QuickEnterButton");
	self:AddClickEvent( self.quickEnterButton, function (go)
		local isEnter = TeamProxy.Instance:IsQuickEntering();
		ServiceSessionTeamProxy.Instance:CallQuickEnter(self.goal, nil, not isEnter);
	end );

	self.quickEntering = self:FindGO("Entering", self.quickEnterButton);
	self.quickNone = self:FindGO("None", self.quickEnterButton);
	-- Quick Enter end
end

function TeamFindPopUp:CallTeamList(page, init)
	if(init)then
		self.prePage = nil;
		self.nowPage = 1;
	else
		self.prePage = self.nowPage;
		self.nowPage = page;
	end

	ServiceSessionTeamProxy.Instance:CallTeamList(self.goal, self.nowPage, self.filterlevel);
end

function TeamFindPopUp:OnEnter()
	TeamFindPopUp.super.OnEnter(self);

	if(self.viewdata and self.viewdata.viewdata)then
		self.startGoal = self.viewdata.viewdata.goalid;
		self.accept = self.viewdata.viewdata.accept;
	else
		self.startGoal = GameConfig.Team.defaulttype;
	end

	self:ResetTeamGoals();
	self:UpdateQuickEnterState();
end

function TeamFindPopUp:ResetTeamGoals()
	local goals = TeamProxy.Instance:GetTeamGoals();
	table.sort(goals, function (a,b)
		return a.fatherGoal.id<b.fatherGoal.id;
	end);
	self.goalListCtl:ResetDatas(goals);

	local goalCells = self.goalListCtl:GetCells();
	if(goalCells and #goalCells>0)then
		for i=1,#goalCells do
			local goalData = goalCells[i].data;
			if(goalData and goalData.fatherGoal.id == self.startGoal)then
				goalCells[i]:ClickFather();
				break;
			end
		end
	end
end

function TeamFindPopUp:UpdateQuickEnterState( )
	local isEntering = TeamProxy.Instance:IsQuickEntering();
	self.quickEntering:SetActive(isEntering);
	self.quickNone:SetActive(not isEntering);
end

function TeamFindPopUp:CreateTeam()
	local defaultname = Game.Myself.data.name..GameConfig.Team.teamname;
	local filterType = FunctionMaskWord.MaskWordType.SpecialSymbol | FunctionMaskWord.MaskWordType.Chat
	local accept = self.accept or GameConfig.Team.defaultauto;
	if(FunctionMaskWord.Me():CheckMaskWord(defaultname , filterType))then
		defaultname = Game.Myself.data.name.."_"..GameConfig.Team.teamname;
	end
	
	local filtratelevel = GameConfig.Team.filtratelevel;
	local defaultMinlv, defaultMaxlv = filtratelevel[1], filtratelevel[#filtratelevel];

	local goal = self.goal;
	if(goal)then
		local goalData = Table_TeamGoals[goal];
		if(goalData and goalData.SetShow == 0)then
			if(goalData.Filter == 10)then
				goal = 10010;
			elseif(goalData.SetShow == 0)then
				goal = goalData.type;
			end
		end
	end
	----[[ todo xde 强制删掉空格
	defaultname = defaultname:gsub(" ", "")
	--]]
	ServiceSessionTeamProxy.Instance:CallCreateTeam(defaultMinlv, defaultMaxlv, goal, accept, defaultname);
end

function TeamFindPopUp:ClickGoal(parama)
	if(parama.type == "Father")then
		local combine = parama.combine;
		if(combine and combine~=self.combineGoal)then
			if(self.combineGoal)then
				self.combineGoal:SetChoose(false);
				self.combineGoal:SetFolderState(false);
			end
			combine:SetChoose(true);
			self.combineGoal = combine;
		end
		local folderState = combine:GetFolderState();
		combine:SetFolderState(not folderState);
		
		self.fatherGoalId = combine.data.fatherGoal.id;

		self.goal = self.fatherGoalId;
		self:CallTeamList(1, true);

	elseif(parama.type == "Child")then
		local child = parama.child;
		if(child and child.data)then
			self.goal = child.data.id;
			self:CallTeamList(1, true);
		else
			self.goal = self.fatherGoalId;
			self:CallTeamList(1, true);
		end
	end
end

function TeamFindPopUp:AddViewInerest()
	self:AddListenEvt(ServiceEvent.SessionTeamTeamList, self.HandleUpdateTeamList);
	self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.HandleEnterTeam);
	self:AddListenEvt(ServiceEvent.SessionTeamQuickEnter, self.UpdateQuickEnterState);
end

function TeamFindPopUp:HandleEnterTeam(note)
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamMemberListPopUp});
end

function TeamFindPopUp:HandleUpdateTeamList()
	local datas = TeamProxy.Instance:GetAroundTeamList() or {};

	if(self.prePage)then
		if(#datas > 0)then
			if(self.nowPage < self.prePage)then
				for i=#datas, 1, -1 do
					self.teamListCtl:InsertData(datas[i], 1);
				end
			elseif(self.prePage < self.nowPage)then
				for i=1,#datas do
					self.teamListCtl:InsertData(datas[i]);
				end
			end
		else
			self.nowPage = self.prePage;
			self.maxPage = self.nowPage;
		end
	elseif(self.nowPage)then
		self.teamListCtl:ResetDatas(datas);
		self.teamListCtl:ResetPosition();
	end

	local datas = self.teamListCtl:GetDatas();
	self.noteamtip:SetActive(#datas == 0);
end



