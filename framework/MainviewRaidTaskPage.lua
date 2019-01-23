MainviewRaidTaskPage = class("MainviewRaidTaskPage",SubView)

autoImport("RaidTaskBord");

function MainviewRaidTaskPage:Init()		 
	self.top_right = self:FindGO("Anchor_TopRight");
	self.taskQuestBord = self:FindGO("TaskQuestBord");

	self:MapEvent();
end

function MainviewRaidTaskPage:DestroyRaidTaskBord()
	if(self.raidTaskBord)then
		self.raidTaskBord:Destroy();
	end
	self.raidTaskBord = nil;

	self.taskQuestBord:SetActive(true);
end
	
function MainviewRaidTaskPage:UpdateRaidTask()
	local raidTaskData = QuestProxy.Instance:getTraceFubenQuestData();
	if(raidTaskData)then
		if(not self.midMsg)then
			self.midMsg = FloatingPanel.Instance:GetMidMsg();
			self.midMsg:SetLocalPos(0, 200, 0);
			self.midMsg:SetExitCall(self.MidMsgExitCall, self);
		end

		local msgData = { text = raidTaskData:parseTranceInfo() };
		self.midMsg:SetData(msgData);
	else
		if(self.midMsg)then
			FloatingPanel.Instance:RemoveMidMsg();
		end
		self.midMsg = nil;
	end
end

function MainviewRaidTaskPage:MidMsgExitCall(msg)
	self.midMsg = nil;
end

function MainviewRaidTaskPage:UpdateRaidScore(score)
	if(score and self.raidTaskBord)then
		self.raidTaskBord:SetScore(score);
	end
end

function MainviewRaidTaskPage:UpdateRaidProgress(progress)
	if(progress and self.raidTaskBord)then
		progress = progress/1000;
		self.raidTaskBord:SetProgress(progress);
	end
end
	
function MainviewRaidTaskPage:MapEvent()
	self:AddListenEvt(ServiceEvent.FuBenCmdFuBenScoreSyncCmd, self.HandleScoreChange);
	self:AddListenEvt(ServiceEvent.FuBenCmdFubenStepSyncCmd, self.UpdateRaidTask);
	
	self:AddListenEvt(ServiceEvent.FuBenCmdFuBenGoalSyncCmd, self.HandleFubenGoalSync);

	self:AddListenEvt(ServiceEvent.FuBenCmdFuBenClearInfoCmd, self.UpdateRaidTask);
end

function MainviewRaidTaskPage:HandleScoreChange(note)
	self:UpdateRaidScore(note.body.score);
end

function MainviewRaidTaskPage:HandleFubenGoalSync(note)
	local data = note.body;

	self:UpdateRaidTask();
	self:UpdateRaidProgress(note.body.progress);
end




