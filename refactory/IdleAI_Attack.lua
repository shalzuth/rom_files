IdleAI_Attack = class("IdleAI_Attack")

function IdleAI_Attack:ctor()
end

function IdleAI_Attack:Clear(idleElapsed, time, deltaTime, creature)
	
end

function IdleAI_Attack:Prepare(idleElapsed, time, deltaTime, creature)
	if nil ~= creature.ai.parent then
		return false
	end
	local attackTarget = creature:Logic_GetAttackTarget()
	if nil ~= attackTarget and attackTarget.data:NoAccessable() then
		creature:Logic_SetAttackTarget(nil)
		return false
	end
	return nil ~= attackTarget and not attackTarget:IsDead()
end

function IdleAI_Attack:Start(idleElapsed, time, deltaTime, creature)
	local attackTarget = creature:Logic_GetAttackTarget()
	creature:Client_AttackTarget(attackTarget)
end

function IdleAI_Attack:End(idleElapsed, time, deltaTime, creature)
end

function IdleAI_Attack:Update(idleElapsed, time, deltaTime, creature)
	return false
end