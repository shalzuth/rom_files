local SelfClass = {}
setmetatable(SelfClass, {__index = SkillLogic_TargetPoint})

local SuperClass = SkillLogic_TargetPoint

function SelfClass.GetPointEffectSize(skillInfo, creature)
	return skillInfo:GetTargetRange(creature)*2
end

-- override begin
function SelfClass.Client_DoDeterminTargets(self, creature, creatureArray, maxCount)
	-- no targets(server select)
end
-- override end

return SelfClass