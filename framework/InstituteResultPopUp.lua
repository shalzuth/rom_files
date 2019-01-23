InstituteResultPopUp = class("InstituteResultPopUp", ContainerView)

InstituteResultPopUp.ViewType = UIViewType.NormalLayer

function InstituteResultPopUp:Init()
	self.resultData = self.viewdata.viewdata.resultData;
	if(self.resultData)then
		self:InitView();
	end
	self:MapEvent();
end

function InstituteResultPopUp:InitView()
	self.rewardInfo = self:FindGO("RewardInfo");
	self.scroeInfo = self:FindGO("ScroeInfo");

	self.getScore = self:FindComponent("GetScore", UILabel);
	self.currentScore = self:FindComponent("CurrentScore", UILabel);
	self.gardenNum = self:FindComponent("Garden", UILabel);
	self.robNum = self:FindComponent("ROB", UILabel);

	self.anim1 = self:FindGO("Anim1");
	self.anim2 = self:FindGO("Anim2");
	self.anim3 = self:FindGO("Anim3");

	self:UpdateInfo();
end

function InstituteResultPopUp:MapEvent()
	self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange);
end

function InstituteResultPopUp:HandleMapChange(note)
    if(note.type == LoadSceneEvent.StartLoad) then
    	self:CloseSelf();
	end
end

function InstituteResultPopUp:UpdateInfo()
	local rdata = self.resultData;
	if(rdata.getScore>0)then
		self.rewardInfo:SetActive(true);

		self.gardenNum.text = self.resultData.garden;
		self.robNum.text = self.resultData.rob;
		local multiple = self.resultData.multiple;
		if(multiple and multiple ~= 1)then
			self.gardenNum.text = self.resultData.garden .. ZhString.InstituteResultPopUp_Multiple .. multiple;
			self.robNum.text = self.resultData.rob .. ZhString.InstituteResultPopUp_Multiple .. multiple;
		end

		self.getScore.text = string.format(ZhString.InstituteResultPopUp_RewardScore, rdata.getScore);
		if(rdata.todayScore>0)then
			self.currentScore.text = ZhString.InstituteResultPopUp_DailyScore..string.format("[FC7508]%s[-]/%s", tostring(rdata.currentScore), tostring(rdata.todayScore));
		else
			self.currentScore.text = ZhString.InstituteResultPopUp_DailyScore..string.format("[FC7508]%s[-]", tostring(rdata.currentScore));
		end
	else
		self.rewardInfo:SetActive(false);
		
		self.getScore.text = ZhString.InstituteResultPopUp_FailScore;
		self.currentScore.text = ZhString.InstituteResultPopUp_DailyScore..string.format("%s/%s", tostring(rdata.currentScore), tostring(rdata.todayScore));
	end
end

function InstituteResultPopUp:PlayInstituteAnim()
	self.anim1:SetActive(false);
	self.anim2:SetActive(false);
	self.anim3:SetActive(false);

	if(self.lt)then
		self.lt:cancel();
		self.lt = nil;
	end
	self.lt = LeanTween.delayedCall(1.5, function ()
		self.anim1:SetActive(true);
		self.lt = LeanTween.delayedCall(0.3, function ()
			self.anim2:SetActive(true);
			self.lt = LeanTween.delayedCall(0.3, function ()
				self.anim3:SetActive(true);
			end);
		end);
	end);
end

function InstituteResultPopUp:OnEnter()
	InstituteResultPopUp.super.OnEnter(self);
	self:CameraRotateToMe();

	self:PlayInstituteAnim();
end

function InstituteResultPopUp:OnExit()
	if(self.lt)then
		self.lt:cancel();
		self.lt = nil;
	end

	InstituteResultPopUp.super.OnExit(self);
	self:CameraReset();

	-- 改变队伍目标
	FunctionTeam.Me():ChangeTeamGoal( TeamGoalType.Around );
end



