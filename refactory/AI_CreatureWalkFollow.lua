AI_CreatureWalkFollow = class("AI_CreatureWalkFollow", AI_Creature)

function AI_CreatureWalkFollow:_InitIdleAI(idleAIManager)
	idleAIManager:PushAI(IdleAI_WalkFollow.new())
end

function AI_CreatureWalkFollow:_Idle(time, deltaTime, creature)
	if not self.idle then
		self.idle = true
		self.idleElapsed = 0
	else
		self.idleElapsed = self.idleElapsed + deltaTime
	end
	self:_IdleAIUpdate(time, deltaTime, creature)
	return true
end