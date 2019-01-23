local BaseCell = autoImport("BaseCell");
TeamGoalCombineCell = class("TeamGoalCombineCell", BaseCell);

autoImport("TeamGoalCell");

function TeamGoalCombineCell:Init()
	local fahterObj = self:FindGO("FatherGoal");
	self.tweenScale = self:FindComponent("ChildContainer", TweenScale);
	self.arrow = self:FindGO("Arrow");

	self.fatherTog = fahterObj:GetComponent(UIToggle);
	self.fatherSprite = self:FindComponent("FatherGoal", UIMultiSprite);
	self.fatherLabel = self:FindComponent("Label", UILabel, self.fatherSprite.gameObject);
	self.fatherSymbol = self:FindGO("Symbol", fahterObj);

	self.fatherCell = TeamGoalCell.new(fahterObj);
	self.fatherCell:AddEventListener(MouseEvent.MouseClick, self.ClickFather, self);

	local grid = self:FindComponent("ChildGoals", UIGrid);
	self.childCtl = UIGridListCtrl.new(grid, TeamGoalCell, "TeamGoalCell");
	self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self);

	self.childSpace = grid.cellHeight;
	self.childBg = self:FindComponent("ChildBg", UISprite);

	self:SetFolderState(false);
end

function TeamGoalCombineCell:ClickFather(cellCtl)
	cellCtl = cellCtl or self.fatherCell;
	self:SetChoose(true);
	self:PassEvent(MouseEvent.MouseClick, {type = "Father", combine = self, father = cellCtl});
end

function TeamGoalCombineCell:ClickChild(cellCtl)
	if(cellCtl~=self.nowChild)then
		if(self.nowChild)then
			self.nowChild:SetChoose(false);
		end
		cellCtl:SetChoose(true);
		self.nowChild = cellCtl;
	else
		self.nowChild:SetChoose(false);
		self.nowChild = nil;
	end
	self:PassEvent(MouseEvent.MouseClick, {type = "Child", combine = self, child = self.nowChild});
end

function TeamGoalCombineCell:SetData(data)
	self.data = data;
	if(data.fatherGoal)then
		self.fatherCell:SetData(data.fatherGoal);
		self.childCtl:ResetDatas(data.childGoals);

		if(#data.childGoals>0)then
			self:Show(self.childBg);
			self:Show(self.fatherSymbol);
			
			self.childBg.height = 88 + self.childSpace * #data.childGoals;
		else
			self:Hide(self.childBg);
			self:Hide(self.fatherSymbol);
		end
	end
end

function TeamGoalCombineCell:SetChoose(choose)
	-- self.fatherCheckMark:SetActive(choose);
	self.fatherSprite.CurrentState = choose and 1 or 0;
	self.fatherLabel.effectColor = choose and Color(159/255, 79/255, 9/255) or Color(29/255, 45/255, 118/255)
	if(self.nowChild)then
		self.nowChild:SetChoose(false);
		self.nowChild = nil;
	end
end

function TeamGoalCombineCell:GetFolderState()
	return self.folderState == true;
end

local tempV3 = LuaVector3();
local tempRot = LuaQuaternion.Euler(0, 0, 0, 0)
function TeamGoalCombineCell:SetFolderState(isOpen)
	if(self.folderState ~= isOpen)then
		self.folderState = isOpen;

		if(isOpen)then
			tempV3:Set(0,0,-90);
			self.tweenScale:PlayForward();
		else
			tempV3:Set(0,0,90);
			self.tweenScale:PlayReverse();
		end
		tempRot.eulerAngles = tempV3;
		self.arrow.transform.rotation = tempRot;
	end
end











