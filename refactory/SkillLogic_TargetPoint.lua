SkillLogic_TargetPoint = {
  TargetType = SkillTargetType.Point
}
setmetatable(SkillLogic_TargetPoint, {
  __index = SkillLogic_Base
})
local SuperClass = SkillLogic_Base
local AdjustPointEffectSize = function(effectHandle, size)
  ModelUtils.AdjustSize(effectHandle.gameObject, size)
end
local EmitPoint = function(self, creature, phaseData, assetRole, skillInfo, fireEP, emitParams)
  local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(self, creature, phaseData, assetRole, skillInfo)
  hitWorker:AddRef()
  SkillLogic_Base.EmitFire(creature, nil, phaseData:GetPosition(), fireEP, emitParams, hitWorker, false, 1, 1)
  hitWorker:SubRef()
end
function SkillLogic_TargetPoint:Cast(creature)
  if SuperClass.Cast(self, creature) then
    local p = self.phaseData:GetPosition()
    creature.logicTransform:LookAt(p)
    local skillInfo = self.info
    local effectPath, isMagicCircle = skillInfo:GetCastPointEffectPath(creature)
    if nil ~= effectPath then
      local effect
      if isMagicCircle then
        local effectSize = skillInfo:GetPointEffectSize(creature)
        effect = Asset_Effect.PlayAt(effectPath, p, AdjustPointEffectSize, effectSize)
      else
        effect = Asset_Effect.PlayAt(effectPath, p)
      end
      if creature.data:GetCamp() == RoleDefines_Camp.ENEMY and skillInfo:IsTrap() then
        local size = ReusableTable.CreateTable()
        local warnRingEffect = Asset_Effect.CreateWarnRingAt(p, skillInfo:GetWarnRingSize(creature, size), self.phaseData:GetAngleY())
        ReusableTable.DestroyAndClearTable(size)
        self:AddEffect(warnRingEffect)
      end
      effect:ResetLocalEulerAnglesXYZ(0, self.phaseData:GetAngleY(), 0)
      self:AddEffect(effect)
    end
    return true
  end
  return false
end
function SkillLogic_TargetPoint:FreeCast(creature)
  return SkillLogic_TargetPoint.Cast(self, creature)
end
function SkillLogic_TargetPoint:Attack(creature)
  local p = self.phaseData:GetPosition()
  creature.logicTransform:LookAt(p)
  return SuperClass.Attack(self, creature)
end
function SkillLogic_TargetPoint:Fire(creature)
  local skillInfo = self.info
  local emitParams = skillInfo:GetEmitParams(creature)
  if nil ~= emitParams then
    local assetRole = creature.assetRole
    local fireIndex = self.fireIndex
    local fireCount = self.fireCount
    local skillInfo = self.info
    local fireEP = skillInfo:GetFireEP(creature)
    local effectPath = skillInfo:GetFireEffectPath(creature)
    if nil ~= effectPath then
      local effect = assetRole:PlayEffectOneShotAt(effectPath, fireEP)
      effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
    end
    local sePath = skillInfo:GetFireSEPath(creature)
    if nil ~= sePath then
      assetRole:PlaySEOneShotAt(sePath, fireEP)
    end
    EmitPoint(self, creature, self.phaseData, assetRole, skillInfo, fireEP, emitParams)
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
function SkillLogic_TargetPoint:Client_PreUpdate_FreeCast(time, deltaTime, creature)
  local p = self.phaseData:GetPosition()
  return self:CheckTargetPosition(creature, p)
end
