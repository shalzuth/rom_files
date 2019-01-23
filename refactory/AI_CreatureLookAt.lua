AI_CreatureLookAt = class("AI_CreatureLookAt", AI_Creature)

local Super_InitIdleAI = AI_CreatureLookAt.super._InitIdleAI
function AI_CreatureLookAt:_InitIdleAI(idleAIManager)
	self.ai_LookAt = IdleAI_LookAt.new()
	Super_InitIdleAI(self,idleAIManager)
	idleAIManager:PushAI(self.ai_LookAt)
end

function AI_CreatureLookAt:LookAt(creatureGUID)
	self.ai_LookAt:Request_Set(creatureGUID)
end