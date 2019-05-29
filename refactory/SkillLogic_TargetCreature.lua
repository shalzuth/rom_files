SkillLogic_TargetCreature = {
  TargetType = SkillTargetType.Creature
}
setmetatable(SkillLogic_TargetCreature, {
  __index = SkillLogic_Base
})
local SuperClass = SkillLogic_Base
local FindCreature = SceneCreatureProxy.FindCreature
function SkillLogic_TargetCreature:Cast(creature)
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
    if SkillType.Collect ~= skillType and SkillType.Eat ~= skillType and SkillType.TouchPet ~= skillType then
      local effectPath = self.info:GetCastLockEffectPath(creature)
      if nil ~= effectPath then
        local effect = targetCreature.assetRole:PlayEffectOn(effectPath, 0)
        self:AddEffect(effect)
      end
      local lockEffectPath = self.info:GetCastLockConfigEffectPath(creature)
      if lockEffectPath ~= nil then
        local lockEP = self.info:GetCastLockEP()
        local effect = targetCreature.assetRole:PlayEffectOn(lockEffectPath, lockEP)
        self:AddEffect(effect)
      end
      if creature.data:GetCamp() == RoleDefines_Camp.ENEMY and skillInfo:IsTrap() then
        local size = ReusableTable.CreateTable()
        local warnRingEffect = Asset_Effect.CreateWarnRingAt(p, skillInfo:GetWarnRingSize(creature, size), self.phaseData:GetAngleY())
        ReusableTable.DestroyAndClearTable(size)
        self:AddEffect(warnRingEffect)
      end
    end
    return true
  end
  return false
end
function SkillLogic_TargetCreature:FreeCast(creature)
  return SkillLogic_TargetCreature.Cast(self, creature)
end
function SkillLogic_TargetCreature:Attack(creature)
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
function SkillLogic_TargetCreature:Client_PreUpdate_Cast(time, deltaTime, creature)
  return self:CheckTargetCreature(creature)
end
function SkillLogic_TargetCreature:Client_PreUpdate_FreeCast(time, deltaTime, creature)
  return SkillLogic_TargetCreature.Client_PreUpdate_Cast(self, time, deltaTime, creature)
end
function SkillLogic_TargetCreature:Client_DoDeterminTargets(creature, creatureArray, maxCount)
  local targetCreature = FindCreature(self.targetCreatureGUID)
  if nil == targetCreature then
    return
  end
  local skillInfo = self.info
  if not skillInfo:CheckTarget(creature, targetCreature) then
    return
  end
  TableUtility.ArrayPushBack(creatureArray, targetCreature)
  local range = skillInfo:GetTargetRange(creature)
  if range > 0 then
    local p = targetCreature:GetPosition()
    SkillLogic_Base.SearchTargetInRange(creatureArray, p, range, skillInfo, creature)
  end
end
