SkillLogic_TargetNone = {
  TargetType = SkillTargetType.None
}
setmetatable(SkillLogic_TargetNone, {
  __index = SkillLogic_Base
})
function SkillLogic_TargetNone:Client_DoDeterminTargets(creature, creatureArray, maxCount)
  local skillInfo = self.info
  if not skillInfo:SelectLockedTarget(creature) then
    return
  end
  local lockedCreature = creature:GetLockTarget()
  if nil == lockedCreature or not skillInfo:CheckTarget(creature, lockedCreature) then
    return
  end
  local range = skillInfo:GetLaunchRange(creature)
  if range > 0 then
    local distance = VectorUtility.DistanceXZ(creature:GetPosition(), lockedCreature:GetPosition())
    if range < distance then
      return
    end
  end
  if 1 == maxCount then
    TableUtility.ArrayPushFront(creatureArray, lockedCreature)
  else
    TableUtility.ArrayPushBack(creatureArray, lockedCreature)
  end
end
