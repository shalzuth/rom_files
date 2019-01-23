FunctionMapEnd = class("FunctionMapEnd")

function FunctionMapEnd.Me()
	if nil == FunctionMapEnd.me then
		FunctionMapEnd.me = FunctionMapEnd.new()
	end
	return FunctionMapEnd.me
end

function FunctionMapEnd:ctor()
end

function FunctionMapEnd:Reset()
	self:ResetDelayCall()
	self.isRunning = false
end

function FunctionMapEnd:ResetDelayCall()
	if(self.delayed ~= nil) then
		self.delayed:cancel()
		self.delayed = nil
	end
end

function FunctionMapEnd:TempSetDurationToTimeLine()
	-- if(TimeLineController.Instance ~= nil) then
	-- 	TimeLineController.Instance.crossFadeDuration = 0
	-- 	TimeLineController.Instance.switchSkyCrossFadeDuration = 0
	-- end
end

function FunctionMapEnd:SetBackDurationToTimeLine()
	-- if(TimeLineController.Instance ~= nil) then
	-- 	TimeLineController.Instance.crossFadeDuration = 1
	-- 	TimeLineController.Instance.switchSkyCrossFadeDuration = 3
	-- end
end

function FunctionMapEnd:BeginIgnoreAreaTrigger()
	if self.areaTriggerIgnored then
		return
	end
	self.areaTriggerIgnored = true
	Game.AreaTriggerManager:SetIgnore(true)
end

function FunctionMapEnd:EndIgnoreAreaTrigger()
	if not self.areaTriggerIgnored then
		return
	end
	self.areaTriggerIgnored = false
	Game.AreaTriggerManager:SetIgnore(false)
end

function FunctionMapEnd:Launch()
	if(self.isRunning) then return end
	self:ResetDelayCall()
	self.isRunning = true
	self:SetBackDurationToTimeLine()
	self.delayed = LeanTween.delayedCall(2,function ()
		self.isRunning = false
		self.delayed = nil
    	GameFacade.Instance:sendNotification(LoadingSceneView.ServerReceiveLoaded)
		self:EndIgnoreAreaTrigger()
		FunctionChangeScene.Me():GC()
	end):setUseFrames(true)
end