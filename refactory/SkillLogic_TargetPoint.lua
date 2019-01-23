SkillLogic_TargetPoint = {
	TargetType = SkillTargetType.Point
}
setmetatable(SkillLogic_TargetPoint, {__index = SkillLogic_Base})

local SuperClass = SkillLogic_Base

local function AdjustPointEffectSize(effectHandle, size)
	ModelUtils.AdjustSize(effectHandle.gameObject, size)
end

local function EmitPoint(self, creature, phaseData, assetRole, skillInfo, fireEP, emitParams)
	local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(
			self, 
			creature, 
			phaseData, 
			assetRole, 
			skillInfo)
		hitWorker:AddRef()
	SkillLogic_Base.EmitFire(creature, nil, phaseData:GetPosition(), fireEP, emitParams, hitWorker, false, 1, 1)
	hitWorker:SubRef()
end

-- override begin
function SkillLogic_TargetPoint.Cast(self, creature)
	if SuperClass.Cast(self, creature) then
		local p = self.phaseData:GetPosition()
		creature.logicTransform:LookAt(p)
		-- play point effect
		local skillInfo = self.info
		local effectPath, isMagicCircle = skillInfo:GetCastPointEffectPath(creature)
		if nil ~= effectPath then
			local effect = nil
			if isMagicCircle then
				local effectSize = skillInfo:GetPointEffectSize(creature)
				effect = Asset_Effect.PlayAt(effectPath, p, AdjustPointEffectSize, effectSize)
			else
				effect = Asset_Effect.PlayAt(effectPath, p)
			end
			effect:ResetLocalEulerAnglesXYZ(0, self.phaseData:GetAngleY(), 0)
			self:AddEffect(effect)
		end
		return true
	end
	return false
end

function SkillLogic_TargetPoint.Attack(self, creature)
	local p = self.phaseData:GetPosition()
	creature.logicTransform:LookAt(p)
	return SuperClass.Attack(self, creature)
end

function SkillLogic_TargetPoint.Fire(self, creature)
	local skillInfo = self.info
	local emitParams = skillInfo:GetEmitParams(creature)
	if nil ~= emitParams then
		local assetRole = creature.assetRole

		local fireIndex = self.fireIndex
		local fireCount = self.fireCount

		local skillInfo = self.info

		local fireEP = skillInfo:GetFireEP(creature)
		-- 1. play effect
		local effectPath = skillInfo:GetFireEffectPath(creature)
		if nil ~= effectPath then
			local effect = assetRole:PlayEffectOneShotAt( effectPath, fireEP )
			effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
		end

		-- 2. play SE
		local sePath = skillInfo:GetFireSEPath(creature)
		if nil ~= sePath then
			assetRole:PlaySEOneShotAt(sePath, fireEP)
		end

		-- 3.
		EmitPoint(
			self, 
			creature, 
			self.phaseData, 
			assetRole, 
			skillInfo,
			fireEP, 
			emitParams)
		return
	end

	local effectPath = self.info:GetFirePointEffectPath(creature)
	if nil ~= effectPath then
		local p = self.phaseData:GetPosition()
		local effect = Asset_Effect.PlayOneShotAt(effectPath, p)
		effect:ResetLocalEulerAnglesXYZ(0, self.phaseData:GetAngleY(), 0)
	end
	return SuperClass.Fire(self, creature)
end
-- override end