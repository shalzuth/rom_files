RaidTaskBord = class("RaidTaskBord", CoreView);

RaidTaskBord.ResPath = ResourcePathHelper.UICell("RaidTaskBord");

local raidBordPos = LuaVector3(-120, -348);

function RaidTaskBord:ctor( parent )
	self.parent = parent;
	self:CreatePerferb();
end

function RaidTaskBord:CreatePerferb()
	self.gameObject = self:LoadPreferb_ByFullPath(RaidTaskBord.ResPath, self.parent, true);
	self.gameObject.transform.localPosition = raidBordPos;
	
	self.title = self:FindComponent("Title", UILabel);	
	self.score = self:FindComponent("Score", UILabel);

	self.taskName = self:FindComponent("TaskName", UILabel);
	self.taskNum = self:FindComponent("TaskNum", UILabel);

	self.progress = self:FindComponent("Progress", UISlider);
end

function RaidTaskBord:SetTarget(taskName, taskNum)
	self.taskName.text = taskName;

	if(taskNum)then
		self.taskNum.text = taskNum;
	else
		self.taskNum.text = "";
	end
end

function RaidTaskBord:SetScore(score)
	self.score.text = tostring(score);
end

function RaidTaskBord:SetProgress(progress)
	self.progress.value = progress;
end
	
function RaidTaskBord:Destroy()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end
	self.gameObject = nil;
end