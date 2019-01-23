local SelfClass = {}
setmetatable(SelfClass, {__index = SkillLogic_TargetPoint})

local SuperClass = SkillLogic_TargetPoint

local tempVector2 = LuaVector2.zero
local tempVector2_1 = LuaVector2.zero

function SelfClass.GetPointEffectSize(skillInfo, creature)
	skillInfo:GetTargetRect(creature, tempVector2, tempVector2_1)
	return math.max(tempVector2_1[1], tempVector2_1[2])
end

-- override begin
function SelfClass.Client_DoDeterminTargets(self, creature, creatureArray, maxCount)
	SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)

	local skillInfo = self.info
	skillInfo:GetTargetRect(creature, tempVector2, tempVector2_1)
	local p = self.phaseData:GetPosition()
	local angleY = self.phaseData:GetAngleY()

	SkillLogic_Base.SearchTargetInRect(
		creatureArray, p, tempVector2, tempVector2_1, angleY, skillInfo, creature)
end
-- override end

return SelfClass