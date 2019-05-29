local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetPoint
})
local SuperClass = SkillLogic_TargetPoint
function SelfClass.GetPointEffectSize(skillInfo, creature)
  return skillInfo:GetTargetRange(creature) * 2
end
function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount)
  SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)
  local skillInfo = self.info
  local range = skillInfo:GetTargetRange(creature)
  if range > 0 then
    local p = self.phaseData:GetPosition()
    SkillLogic_Base.SearchTargetInRange(creatureArray, p, range, skillInfo, creature)
  end
end
return SelfClass
