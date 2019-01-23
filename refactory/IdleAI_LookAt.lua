IdleAI_LookAt = class("IdleAI_LookAt")

local LookInterval = 0.5

function IdleAI_LookAt:ctor()
	self.targetGUID = 0
	self.requestTargetGUID = nil
	self.nextLookTime = 0
end

function IdleAI_LookAt:Request_Set(guid)
	self.requestTargetGUID = guid
end

function IdleAI_LookAt:Clear(idleElapsed, time, deltaTime, creature)
	self.targetGUID = 0
	self.requestTargetGUID = nil
	self.nextLookTime = 0
end

function IdleAI_LookAt:Prepare(idleElapsed, time, deltaTime, creature)
	if nil ~= self.requestTargetGUID then
		self.targetGUID = self.requestTargetGUID
		self.requestTargetGUID = nil
	end
	if 0 == self.targetGUID then
		return false
	end
	if time < self.nextLookTime then
		return false
	end
	return true
end

function IdleAI_LookAt:Start(idleElapsed, time, deltaTime, creature)
	creature:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.LookAtCreature, self.targetGUID)
	self.nextLookTime = time + LookInterval
end

function IdleAI_LookAt:End(idleElapsed, time, deltaTime, creature)
end

function IdleAI_LookAt:Update(idleElapsed, time, deltaTime, creature)
	return false
end