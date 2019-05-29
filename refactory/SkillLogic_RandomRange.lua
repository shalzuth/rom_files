local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetPoint
})
local SuperClass = SkillLogic_TargetPoint
function SelfClass.GetPointEffectSize(skillInfo, creature)
  return skillInfo:GetTargetRange(creature) * 2
end
function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount)
end
return SelfClass
