TeamInfoOptionGoalPage = class("TeamInfoOptionGoalPage", SubView);

autoImport("TeamOptionGComCell");

TeamInfoOptionGoalPage.ChangeGoal = "TeamInfoOptionGoal_ChangeGoal";

function TeamInfoOptionGoalPage:Init()
	self.page = self:FindGO("TeamOptionGoalPage");

	self:InitUI();
end

function TeamInfoOptionGoalPage:InitUI()
	self.goalName = self:FindComponent("Target", UILabel);
	local table = self:FindComponent("TargetGrid", UITable);
	self.targetCtl = UIGridListCtrl.new(table, TeamOptionGComCell, "TeamOptionGComCell");
	self.targetCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self);
	
	self:AddButtonEvent("CloseSelectTargetPage", function ()
		self.page:SetActive(false);
	end);
	
	--todo xde
	table.transform.localPosition = Vector3(0,210,0)
end

function TeamInfoOptionGoalPage:ClickGoal(parama)
	local type,cellCtl,data = parama.type,parama.ctl,parama.data;
	if(type == "father")then
		if(self.nowCell~=cellCtl)then
			if(self.nowCell)then
				self.nowCell:SetChoose(false);
				if(self.nowCell.tweenDir)then
					self.nowCell:PlayTween(false);
				end
			end
			self.nowCell = cellCtl;
		end
	end
	self.goalId = data.id;

	self:PassEvent(TeamInfoOptionGoalPage.ChangeGoal, self.goalId);
end

function TeamInfoOptionGoalPage:Show()
	self.page:SetActive(true);

	self:UpdataGoalInfo();
	self:InitChoose();
end

function TeamInfoOptionGoalPage:Hide()
	if(not self.page.activeSelf)then
		return;
	end

	self.page:SetActive(false);

	self.nowCell = nil;
	local goalId = self.goalId;
	self:PassEvent(TeamInfoOptionGoalPage.ChangeGoal, goalId);

	self.goalId = nil;
	self.targetCtl:RemoveAll();
end

function TeamInfoOptionGoalPage:InitChoose()
	-- 初始化选择
	local nowId = TeamProxy.Instance.myTeam.type;
	local cells = self.targetCtl:GetCells();
	for k,v in pairs(cells)do
		if(v:InitChoose(nowId))then
			break;
		end
	end
end

function TeamInfoOptionGoalPage:UpdataGoalInfo()
	local goals = TeamProxy.Instance:GetTeamGoals();
	self.targetCtl:ResetDatas(goals);
end



