AI_CreatureFlyFollow = class("AI_CreatureFlyFollow", AI_Creature)

function AI_CreatureFlyFollow:_InitIdleAI(idleAIManager)
	idleAIManager:PushAI(IdleAI_FlyFollow.new())
end

function AI_CreatureFlyFollow:_Idle(time, deltaTime, creature)
	if not self.idle then
		self.idle = true
		self.idleElapsed = 0
	else
		self.idleElapsed = self.idleElapsed + deltaTime
	end
	self:_IdleAIUpdate(time, deltaTime, creature)
	return true
end