local SelfClass = {}
setmetatable(SelfClass, {__index = SkillLogic_TargetPoint})

local SuperClass = SkillLogic_TargetPoint

function SelfClass.GetPointEffectSize(skillInfo, creature)
	return skillInfo:GetTargetRange(creature)*2
end

-- override begin
function SelfClass.Client_DoDeterminTargets(self, creature, creatureArray, maxCount)
	SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)
	local skillInfo = self.info
	local range = skillInfo:GetTargetRange(creature)
	if 0 < range then
		local p = self.phaseData:GetPosition()
		SkillLogic_Base.SearchTargetInRange(
			creatureArray, p, range, skillInfo, creature)
	end
end
-- override end

return SelfClass