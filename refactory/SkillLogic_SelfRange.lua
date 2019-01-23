local SelfClass = {}
setmetatable(SelfClass, {__index = SkillLogic_TargetNone})

local SuperClass = SkillLogic_TargetNone

-- override begin
function SelfClass.Client_DoDeterminTargets(self, creature, creatureArray, maxCount)
	SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)
	local skillInfo = self.info
	local range = skillInfo:GetTargetRange(creature)
	if 0 < range then
		local p = creature:GetPosition()
		SkillLogic_Base.SearchTargetInRange(
			creatureArray, p, range, skillInfo, creature)
	end
end
-- override end

return SelfClass