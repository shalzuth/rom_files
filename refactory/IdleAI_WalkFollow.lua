IdleAI_WalkFollow = class("IdleAI_WalkFollow")

local Phase_None = 0
local Phase_Follow = 1
local Phase_Idle = 2

local InnerRange = 0.5
local OutterRange = 3

function IdleAI_WalkFollow:ctor()
	self.phase = Phase_None
	self.prevTargetPosition = nil
end

function IdleAI_WalkFollow:Clear(idleElapsed, time, deltaTime, creature)
	self.phase = Phase_None
	if nil ~= self.prevTargetPosition then
		self.prevTargetPosition:Destroy()
		self.prevTargetPosition = nil
	end
end

function IdleAI_WalkFollow:Prepare(idleElapsed, time, deltaTime, creature)
	if nil ~= creature.ai.parent then
		return false
	end
	return true
end

function IdleAI_WalkFollow:Start(idleElapsed, time, deltaTime, creature)
	self:_Follow(idleElapsed, time, deltaTime, creature)
end

function IdleAI_WalkFollow:End(idleElapsed, time, deltaTime, creature)
	self.phase = Phase_None
end

function IdleAI_WalkFollow:Update(idleElapsed, time, deltaTime, creature)

	local currentPosition = creature:GetPosition()
	if nil == currentPosition then
		self:_Idle(idleElapsed, time, deltaTime, creature)
		return true
	end

	local targetCreature = creature:Logic_GetFollowTarget()
	if nil == targetCreature then
		self:_Idle(idleElapsed, time, deltaTime, creature)
		return true
	end

	local targetPosition = targetCreature:GetPosition()
	if nil == targetPosition then
		self:_Idle(idleElapsed, time, deltaTime, creature)
		return true
	end

	if nil ~= self.prevTargetPosition then
		local targetChangedDistance = VectorUtility.DistanceXZ(
			self.prevTargetPosition, 
			targetPosition)
		if InnerRange > targetChangedDistance then
			self:_Idle(idleElapsed, time, deltaTime, creature)
			return true
		end
	end

	local distance = VectorUtility.DistanceXZ(currentPosition, targetPosition)
	if InnerRange > distance then
		self:_Idle(idleElapsed, time, deltaTime, creature)
		return true
	end

	if OutterRange < distance then
		self:_Follow(idleElapsed, time, deltaTime, creature)
	end

	if Phase_Follow == self.phase then
		local logicTransform = creature.logicTransform
		local prevTargetPosition = logicTransform.targetPosition
		if nil == prevTargetPosition 
			or VectorUtility.DistanceXZ(prevTargetPosition, targetPosition) > InnerRange then
			if creature:Logic_NavMeshMoveTo(targetPosition) then
				if nil ~= self.prevTargetPosition then
					self.prevTargetPosition:Destroy()
					self.prevTargetPosition = nil
				end
			else
				self.prevTargetPosition = VectorUtility.Asign_3(self.prevTargetPosition, targetPosition)
				self:_Idle(idleElapsed, time, deltaTime, creature)
			end
		else
			creature:Logic_SamplePosition(time)
		end
	end
	return true
end

function IdleAI_WalkFollow:_Follow(idleElapsed, time, deltaTime, creature)
	if Phase_Follow == self.phase then
		return
	end

	self.phase = Phase_Follow
	creature:Logic_PlayAction_Move()
end

function IdleAI_WalkFollow:_Idle(idleElapsed, time, deltaTime, creature)
	if Phase_Idle == self.phase then
		return
	end

	self.phase = Phase_Idle
	creature:Logic_StopMove()
	creature:Logic_SamplePosition(time)
	creature:Logic_PlayAction_Idle()
end