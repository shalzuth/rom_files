autoImport("EventDispatcher")
autoImport("ConditionCheck")
FunctionCheck = class("FunctionCheck",EventDispatcher)

FunctionCheck.CannotSyncMoveReason = {
	OnCarrier = 1,
	LoadingScene = 2,
	Skill_Transport = 3,
}

function FunctionCheck.Me()
	if nil == FunctionCheck.me then
		FunctionCheck.me = FunctionCheck.new()
	end
	return FunctionCheck.me
end

function FunctionCheck:ctor()
	self.cannotSyncMoveChecker = ConditionCheck.new()
	-- self.cannotUseSkillChecker = ConditionCheck.new()
	self.canOpenFuncChecker = ConditionCheck.new();
end

function FunctionCheck:Reset()
	self.cannotSyncMoveChecker:Reset()
	-- self.cannotUseSkillChecker:Reset()
end

function FunctionCheck:SetSyncMove(reason,value)
	if(value) then
		self.cannotSyncMoveChecker:RemoveReason(reason)
	else
		self.cannotSyncMoveChecker:SetReason(reason)
	end
end

function FunctionCheck:CanSyncMove()
	return not self.cannotSyncMoveChecker:HasReason()
end

-- function FunctionCheck:CanUseSkill()
-- 	return not self.cannotUseSkillChecker:HasReason()
-- end

function FunctionCheck:CheckProp(p)
	self:CheckFucOpen(p)
	self:PassEvent(MyselfEvent.MyPropChange,p)
end

function FunctionCheck:CheckFucOpen(p)
	FunctionUnLockFunc.Me():CheckProp(p)
end