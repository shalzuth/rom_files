TeamOptionPopUp = class("TeamOptionPopUp", ContainerView)

TeamOptionPopUp.ViewType = UIViewType.PopUpLayer

autoImport("TeamInfoOptionGoalPage");

local teamProxy;

function TeamOptionPopUp:Init()
	teamProxy = TeamProxy.Instance;

	self.page2Ctl = self:AddSubView("TeamInfoOptionGoalPage", TeamInfoOptionGoalPage);
	self:InitUI();
	self:AddViewInterests();
end

function TeamOptionPopUp.ServerProxy()
	return ServiceSessionTeamProxy.Instance;
end

function TeamOptionPopUp:InitUI()
	self.optionPage = self:FindGO("OptionPage");
	self.nameInput = self:FindComponent("TeamNameInput", UIInput);

	self.filterType = FunctionMaskWord.MaskWordType.SpecialSymbol | FunctionMaskWord.MaskWordType.Chat

	UIUtil.LimitInputCharacter(self.nameInput, 12, function (str)
		local resultStr = string.gsub(str, " ", "");
		if(StringUtil.ChLength(resultStr)<2)then
			resultStr = teamProxy.myTeam.name;
			
			MsgManager.ShowMsgByIDTable(883);
		end
		return resultStr;
	end);

	self.goalName = self:FindComponent("TeamTargetName", UILabel);
	self.page2Ctl:AddEventListener(TeamInfoOptionGoalPage.ChangeGoal, self.ChangeGoal, self);
	self:AddButtonEvent("ConfirmButton", function (go)
		self:ConfirmButton();
	end);

	local targetButton = self:FindGO("TeamTargetButton");
	self.minlvPopUp = self:FindComponent("MinLvPopUp", UIPopupList);
	self.maxlvPopUp = self:FindComponent("MaxLvPopUp", UIPopupList);
	local filtratelevel = GameConfig.Team.filtratelevel;
	for i=1,#filtratelevel do
		self.minlvPopUp:AddItem(filtratelevel[i]);
		self.maxlvPopUp:AddItem(filtratelevel[i]);
	end

	self.teamTargetTog = targetButton:GetComponentInChildren(UIToggle);
	self.minLvTog = self.minlvPopUp:GetComponentInChildren(UIToggle);
	self.maxLvTog = self.maxlvPopUp:GetComponentInChildren(UIToggle);

	self:AddClickEvent(self.minlvPopUp.gameObject, function (go) self:ControlTogEvt(self.minLvTog) end);
	self:AddClickEvent(self.maxlvPopUp.gameObject, function (go) self:ControlTogEvt(self.maxLvTog) end);
	EventDelegate.Add(self.minlvPopUp.onChange, function () 
		if(self.minlvPopUp.isOpen)then
			self:ControlTogEvt(self.minLvTog) 
		end
	end);
	EventDelegate.Add(self.maxlvPopUp.onChange, function () 
		if(self.maxlvPopUp.isOpen)then
			self:ControlTogEvt(self.maxLvTog) 
		end
	end);

	EventDelegate.Set(self.teamTargetTog.onChange, function () 
		self:ControlTogEvt(self.maxLvTog) 
	end);

	self:AddClickEvent(targetButton, function (go) self:ControlTogEvt(self.teamTargetTog) end);
	local teamTargetSymbol = self:FindComponent("Symbol", TweenRotation, targetButton);
	EventDelegate.Set(self.teamTargetTog.onChange, function () 
		local value = self.teamTargetTog.value;
		if(value)then
			self.page2Ctl:Show();
			teamTargetSymbol:PlayForward();
		else
			self.page2Ctl:Hide();
			teamTargetSymbol:PlayReverse();
		end
	end);

	local minLvSymbol = self:FindComponent("Symbol", TweenRotation, self.minlvPopUp.gameObject);
	EventDelegate.Set(self.minLvTog.onChange, function () 
		local value = self.minLvTog.value;
		if(value)then
			minLvSymbol:PlayForward();
		else
			minLvSymbol:PlayReverse();
		end
	end);
	local maxLvSymbol = self:FindComponent("Symbol", TweenRotation, self.maxlvPopUp.gameObject);
	EventDelegate.Set(self.maxLvTog.onChange, function () 
		local value = self.maxLvTog.value;
		if(value)then
			maxLvSymbol:PlayForward();
		else
			maxLvSymbol:PlayReverse();
		end
	end);

	self.pickUpModeTog_1 = self:FindComponent("PickUpMode_1", UIToggle);
	self.pickUpModeTog_2 = self:FindComponent("PickUpMode_2", UIToggle);
	self:AddClickEvent(self.pickUpModeTog_1.gameObject, function ()
		self.pickUpMode = 0;
	end);
	self:AddClickEvent(self.pickUpModeTog_2.gameObject, function ()
		self.pickUpMode = 1;
	end);

	-- ????????????
	self.autoApplyTip = {
		[0] = ZhString.TeamOptionPopUp_AutoApplyTip1,
		[1] = ZhString.TeamOptionPopUp_AutoApplyTip2,
		[2] = ZhString.TeamOptionPopUp_AutoApplyTip3,
	};
	self.autoApplyPopup = self:FindComponent("AutoApplyPopUp", UIPopupList);
	for i=0,2 do
		self.autoApplyPopup:AddItem(self.autoApplyTip[i], i);
	end
end

function TeamOptionPopUp:ChangeGoal(goalid)
	self.goal = goalid;
	if(Table_TeamGoals[goalid])then
		self.goalName.text = Table_TeamGoals[goalid].NameZh;
	end
end

function TeamOptionPopUp:ConfirmButton()
	-- ????????????????????????
	local name;
	if(self.nameInput)then
		name = self.nameInput.value;
	end
	local changeOption = {};

	local level1, level2 = tonumber(self.minlvPopUp.value) or 0, tonumber(self.maxlvPopUp.value) or 0;
	local minlv, maxlv = math.min(level1, level2), math.max(level1, level2);
	local myminlv, mymaxlv = teamProxy.myTeam.minlv, teamProxy.myTeam.maxlv;
	if(minlv~=myminlv)then
		local minlvOption = {
			type = SessionTeam_pb.ETEAMDATA_MINLV,
			value = minlv,
		};
		table.insert(changeOption, minlvOption);
	end
	if(maxlv~=mymaxlv)then
		local maxlvOption = {
			type = SessionTeam_pb.ETEAMDATA_MAXLV,
			value = maxlv;
		};
		table.insert(changeOption, maxlvOption);
	end

	if(self.goal and self.goal~=teamProxy.myTeam.type)then
		local goalOption = {
			type = SessionTeam_pb.ETEAMDATA_TYPE,
			value = self.goal,
		};
		table.insert(changeOption, goalOption);
	end
	if(self.pickUpMode ~= teamProxy.myTeam.pickupmode)then
		local pickUpOption = {
			type = SessionTeam_pb.ETEAMDATA_PICKUP_MODE,
			value = self.pickUpMode,
		};
		table.insert(changeOption, pickUpOption);
	end
	local nowAcceptChoose = math.floor(self.autoApplyPopup.data)
	if(nowAcceptChoose ~= self.autoAccept)then
		local autoacceptOption = {
			type = SessionTeam_pb.ETEAMDATA_AUTOACCEPT,
			value = nowAcceptChoose,
		};
		table.insert(changeOption, autoacceptOption);
	end


	if(not FunctionMaskWord.Me():CheckMaskWord(name, self.filterType))then
		self.ServerProxy():CallSetTeamOption(name, changeOption);
	else
		MsgManager.ShowMsgByIDTable(2604);
	end

	self.optionPage:SetActive(false);

	self:CloseSelf();
end

function TeamOptionPopUp:ControlTogEvt(tog)
	if(not tog.value)then
		if(self.nowCtlTog)then
			self.nowCtlTog.value = false;
			if(self.nowCtlTog == self.teamTargetTog)then
				self.page2Ctl:Hide();
			end
		end
		self.nowCtlTog = tog;
		tog.value = true;
	else
		tog.value = false;
		self.nowCtlTog = nil;
	end
	return tog.value;
end

function TeamOptionPopUp:ClickTarget(cellCtl)
	cellCtl:SetChoose(true);
	self.nowTarget = cellCtl.data;
end

function TeamOptionPopUp:UpdateOption()
	-- ??????
	if(not teamProxy:IHaveTeam())then
		return;
	end

	local myTeam = teamProxy.myTeam;
	self.nameInput.value = myTeam.name;

	if(myTeam.type and Table_TeamGoals[myTeam.type])then
		self.goalName.text = Table_TeamGoals[myTeam.type].NameZh;
	end

	self.minlvPopUp.value = tostring(myTeam.minlv);
	self.maxlvPopUp.value = tostring(myTeam.maxlv);
	
	self.pickUpMode = myTeam.pickupmode;
	self.pickUpModeTog_1.value = myTeam.pickupmode==0;
	self.pickUpModeTog_2.value = myTeam.pickupmode==1;

	self.autoAccept = myTeam.autoaccept or 0;
	self.autoApplyPopup.value = self.autoApplyTip[ self.autoAccept ];
end

function TeamOptionPopUp:AddViewInterests()
end

function TeamOptionPopUp:OnEnter()
	TeamOptionPopUp.super.OnEnter(self);

	self:UpdateOption();
end












