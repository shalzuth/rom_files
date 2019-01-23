SkillLogic_TargetCreature = {
	TargetType = SkillTargetType.Creature
}
setmetatable(SkillLogic_TargetCreature, {__index = SkillLogic_Base})

local SuperClass = SkillLogic_Base
local FindCreature = SceneCreatureProxy.FindCreature

-- override begin
function SkillLogic_TargetCreature.Cast(self, creature)
	local targetCreatureGUID = 0
	if nil ~= self.targetCreatureGUID and 0 ~= self.targetCreatureGUID then
		targetCreatureGUID = self.targetCreatureGUID
	else
		targetCreatureGUID = self.phaseData:GetTarget(1)
	end
	local targetCreature = FindCreature(targetCreatureGUID)
	if nil == targetCreature then
		return false
	end
	local skillInfo = self.info
	if not skillInfo:CheckTarget(creature, targetCreature) then
		return false
	end
	if SuperClass.Cast(self, creature) then
		creature.logicTransform:LookAt(targetCreature:GetPosition())
		local skillType = self.info:GetSkillType(creature)
		if SkillType.Collect ~= skillType
			and SkillType.Eat ~= skillType
			and SkillType.TouchPet ~= skillType then
			-- play lock effect
			-- default
			local effectPath = self.info:GetCastLockEffectPath(creature)
			if nil ~= effectPath then
				local effect = targetCreature.assetRole:PlayEffectOn(effectPath, 0)
				self:AddEffect(effect)
			end
			-- config
			local lockEffectPath = self.info:GetCastLockConfigEffectPath(creature)
			if lockEffectPath ~= nil then
				local lockEP = self.info:GetCastLockEP()
				local effect = targetCreature.assetRole:PlayEffectOn(lockEffectPath, lockEP)
				self:AddEffect(effect)
			end
		end
		return true
	end
	return false
end

function SkillLogic_TargetCreature.Attack(self, creature)
	if 0 >= self.phaseData:GetTargetCount() then
		return false, false
	end
	local targetCreatureGUID = 0
	if nil ~= self.targetCreatureGUID and 0 ~= self.targetCreatureGUID then
		targetCreatureGUID = self.targetCreatureGUID
	else
		targetCreatureGUID = self.phaseData:GetTarget(1)
	end
	local targetCreature = FindCreature(targetCreatureGUID)
	if nil ~= targetCreature then
		creature.logicTransform:LookAt(targetCreature:GetPosition())
	end
	return SuperClass.Attack(self, creature)
end

-- for client begin
function SkillLogic_TargetCreature.Client_PreUpdate_Cast(self, time, deltaTime, creature)
	return self:CheckTargetCreature(creature)
end
function SkillLogic_TargetCreature.Client_DoDeterminTargets(self, creature, creatureArray, maxCount)
	local targetCreature = FindCreature(self.targetCreatureGUID)
	if nil == targetCreature then
		return
	end
	local skillInfo = self.info
	if not skillInfo:CheckTarget(creature, targetCreature) then
		return
	end
	TableUtility.ArrayPushBack(creatureArray, targetCreature)

	-- use range
	local range = skillInfo:GetTargetRange(creature)
	if 0 < range then
		local p = targetCreature:GetPosition()
		SkillLogic_Base.SearchTargetInRange(creatureArray, p, range, skillInfo, creature)
	end
end
-- for client end
-- override end