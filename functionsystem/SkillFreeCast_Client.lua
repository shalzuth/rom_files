SkillFreeCast_Client = class("SkillFreeCast_Client", SkillFreeCast)
local FindCreature = SceneCreatureProxy.FindCreature
function SkillFreeCast_Client.Create(args)
  return ReusableObject.Create(SkillFreeCast_Client, true, args)
end
function SkillFreeCast_Client:Update_FreeCast(time, deltaTime, creature)
  if not self.info.LogicClass.Client_PreUpdate_FreeCast(self, time, deltaTime, creature) then
    self:_SwitchToNone(creature)
    return false
  end
  return SkillFreeCast_Client.super.Update_FreeCast(self, time, deltaTime, creature)
end
function SkillFreeCast_Client:CheckTargetCreature(creature)
  local targetCreature = FindCreature(self.targetCreatureGUID)
  if nil == targetCreature then
    return false
  end
  if not self:CheckTargetPosition(creature, targetCreature:GetPosition()) then
    return false
  end
  return self.info:CheckTarget(creature, targetCreature)
end
function SkillFreeCast_Client:CheckTargetPosition(creature, targetPosition)
  local launchRange = self.info:GetLaunchRange(creature)
  if launchRange > 0 then
    local testRange = launchRange * 1.5
    local currentPosition = creature:GetPosition()
    if testRange < VectorUtility.DistanceXZ(currentPosition, targetPosition) then
      return false
    end
  end
  return true
end
function SkillFreeCast_Client:_SwitchToAttack(creature)
  SkillFreeCast_Client.super._SwitchToAttack(self, creature)
  local targetCreature
  if self.targetCreatureGUID ~= 0 then
    targetCreature = FindCreature(self.targetCreatureGUID)
  end
  creature:Client_UseSkill(self.info:GetSkillID(creature), targetCreature, self.phaseData:GetPosition(), nil, nil, nil, nil, true, true)
end
function SkillFreeCast_Client:_SwitchToNone(creature)
  local phase = self.phaseData:GetSkillPhase()
  SkillFreeCast_Client.super._SwitchToNone(self, creature)
  if phase == SkillPhase.FreeCast then
    self:_NotifyServer(creature)
  end
end
function SkillFreeCast_Client:_NotifyServer(creature)
  creature:Client_UseSkillHandler(self.random, self.phaseData, self.targetCreatureGUID)
end
