local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetNone
})
local SuperClass = SkillLogic_TargetNone
function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount)
  SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)
  local skillInfo = self.info
  local range = skillInfo:GetTargetRange(creature)
  if range > 0 then
    local p = creature:GetPosition()
    SkillLogic_Base.SearchTargetInRange(creatureArray, p, range, skillInfo, creature)
  end
end
return SelfClass
