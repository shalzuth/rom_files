local CannotUseSkillProp = {
  NoAct = 1,
  NoAttack = 1,
  NoSkill = 1,
  FearRun = 1,
  Freeze = 1,
  NoMagicSkill = 1
}
function NMyselfPlayer:Logic_SamplePosition(time)
  self.logicTransform:SamplePosition()
end
function NMyselfPlayer:Logic_Hit(action, stiff)
  GameFacade.Instance:sendNotification(MyselfEvent.BeHited, self)
  self.ai:PushCommand(FactoryAICMD.Me_GetHitCmd(false, action, stiff), self)
end
function NMyselfPlayer:Logic_DeathBegin()
  GameFacade.Instance:sendNotification(MyselfEvent.DeathBegin, self)
  EventManager.Me():DispatchEvent(MyselfEvent.DeathBegin, self)
end
function NMyselfPlayer:Logic_DeathEnd()
  GameFacade.Instance:sendNotification(MyselfEvent.DeathEnd, self)
end
local superCastBegin = NMyselfPlayer.super.Logic_CastBegin
function NMyselfPlayer:Logic_CastBegin()
  local skillInfo = self.skill.info
  if skillInfo and skillInfo:IsGuideCast() then
    EventManager.Me():PassEvent(MyselfEvent.SkillGuideBegin, skillInfo)
  else
    superCastBegin(self)
  end
end
local superCastEnd = NMyselfPlayer.super.Logic_CastEnd
function NMyselfPlayer:Logic_CastEnd()
  local skillInfo = self.skill.info
  if skillInfo and skillInfo:IsGuideCast() then
    EventManager.Me():PassEvent(MyselfEvent.SkillGuideEnd, skillInfo)
    SkillProxy.Instance:startCdTimeBySkillId(skillInfo:GetSkillID())
    EventManager.Me():PassEvent(MyselfEvent.UsedSkill, skillInfo:GetSkillID())
  else
    superCastEnd(self)
  end
end
function NMyselfPlayer:Logic_AddSkillFreeCast(skillInfo)
  if self.skillFreeCast ~= nil then
    self.skillFreeCast:Destroy()
  end
  local args = SkillFreeCast.GetArgs(self, skillInfo)
  self.skillFreeCast = SkillFreeCast_Client.Create(args)
  EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
end
function NMyselfPlayer:Logic_OnSkillLaunch(skillID)
  local leadType = Table_Skill[skillID].Lead_Type
  if leadType ~= nil and leadType.type == SkillCastType.Lead then
    SkillProxy.Instance:startCdTimeBySkillId(skillID)
    EventManager.Me():PassEvent(MyselfEvent.UsedSkill, skillID)
  end
end
function NMyselfPlayer:Logic_OnSkillAttack(skillID)
  local skill = Table_Skill[skillID]
  local leadType = skill.Lead_Type
  local skillType = skill.SkillType
  if leadType == nil or leadType.type ~= SkillCastType.Lead then
    if skillType ~= SkillType.FakeDead then
      SkillProxy.Instance:startCdTimeBySkillId(skillID)
    end
    EventManager.Me():PassEvent(MyselfEvent.UsedSkill, skillID)
  end
end
function NMyselfPlayer:Logic_SetAttackTarget(targetCreature)
  self:SetWeakData(NMyselfPlayer.WeakKey_AttackTarget, targetCreature)
end
function NMyselfPlayer:Logic_GetAttackTarget()
  return self:GetWeakData(NMyselfPlayer.WeakKey_AttackTarget)
end
function NMyselfPlayer:Logic_MoveTo(p)
  NMyselfPlayer.super.Logic_MoveTo(self, p)
  self:Client_MoveHandler(p)
end
function NMyselfPlayer:Logic_OnMoveToNextCorner(nextCorner)
  self:Client_MoveHandler(nextCorner)
end
function NMyselfPlayer:Logic_StopMove()
  NMyselfPlayer.super.Logic_StopMove(self)
  self:Client_MoveHandler(self:GetPosition())
end
function NMyselfPlayer:Logic_SetSkillState(lockTargetGUID)
  self.ai:SetSkillLockTarget(lockTargetGUID, self)
end
function NMyselfPlayer:Logic_SetHandInHandState(masterID, running)
  redlog("Call-->HandStatusUserCmd", masterID, running)
  ServiceNUserProxy.Instance:CallHandStatusUserCmd(running, masterID, nil, 0)
end
function NMyselfPlayer:Logic_SetDoubleActionState(masterID, running)
  if not running then
    if self:IsDoubleActionBuild() then
      redlog("Call-->HandStatusUserCmd", masterID, false)
      ServiceNUserProxy.Instance:CallHandStatusUserCmd(false, nil, nil, 1)
    end
  elseif not self:IsDoubleActionBuild() then
    helplog("Call-->HandStatusUserCmd", masterID, true)
    ServiceNUserProxy.Instance:CallHandStatusUserCmd(true, masterID, nil, 1)
  end
end
function NMyselfPlayer:Logic_Freeze(on)
  if on then
    FunctionSystem.InterruptMyself()
  end
  NMyselfPlayer.super.Logic_Freeze(self, on)
end
function NMyselfPlayer:Logic_BreakWeakFreeze()
  self.data:ForceClearWeakFreezeSkillBuff()
  if 0 == self.data.props.Freeze:GetValue() then
    self:Logic_Freeze(false)
  end
end
function NMyselfPlayer:Logic_NoAct(on)
  if on then
    FunctionSystem.InterruptMyself()
  end
  NMyselfPlayer.super.Logic_NoAct(self, on)
end
function NMyselfPlayer:Logic_FearRun(on)
  if on then
    FunctionSystem.InterruptMyself()
  else
    self:Client_DirMoveEnd()
  end
  NMyselfPlayer.super.Logic_FearRun(self, on)
end
function NMyselfPlayer:Logic_CheckCanUseSkill(p)
  local propName = p.propVO.name
  local isRelatedProp = CannotUseSkillProp[propName] ~= nil
  if isRelatedProp then
    local reasonCount = self.cannotUseSkillChecker.reasonCount
    if p:GetValue() > 0 then
      self.cannotUseSkillChecker:SetReason(propName)
    else
      self.cannotUseSkillChecker:RemoveReason(propName)
    end
    if reasonCount ~= self.cannotUseSkillChecker.reasonCount then
      EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
    end
  end
end
function NMyselfPlayer:Logic_CanUseSkill()
  return not self.cannotUseSkillChecker:HasReason()
end
function NMyselfPlayer:Logic_CheckSkillCanUseByID(skillID)
  if self:Logic_IsFreeCast() then
    return false
  end
  return self:Logic_CheckSkillCanUseBySkillInfo(Game.LogicManager_Skill:GetSkillInfo(skillID))
end
function NMyselfPlayer:Logic_CheckSkillCanUseBySkillInfo(skillInfo)
  local superUse
  if skillInfo then
    superUse = skillInfo.staticData.SuperUse
  else
    return false
  end
  if superUse == nil then
    if self.data:NoMagicSkill() then
      return not skillInfo:IsMagicType()
    end
    if self:Logic_CanUseSkill() then
      if self.data:HasLimitSkill() then
        if self.data:GetLimitSkillTarget(skillInfo:GetSkillID() or 0) == nil then
          return false
        end
      elseif self.data:HasLimitNotSkill() then
        if self.data:GetLimitNotSkill(skillInfo:GetSkillID() or 0) ~= nil then
          return false
        end
      end
      return true
    else
      return false
    end
  end
  local SkillSuperUse = SkillSuperUse
  local reasons = self.cannotUseSkillChecker.reasons
  local res = true
  for k, v in pairs(reasons) do
    if SkillSuperUse[k] == nil or superUse & SkillSuperUse[k] == 0 then
      return false
    end
  end
  local stateEffect = skillInfo.staticData.SuperUseEffect
  if stateEffect then
    local propStateEffect = self.data.props.StateEffect:GetValue()
    if stateEffect ~= propStateEffect and stateEffect & propStateEffect ~= propStateEffect then
      return false
    end
  end
  return res
end
function NMyselfPlayer:Logic_CanUseEnsembleSkill(skillInfo)
  if skillInfo == nil then
    return false
  end
  local _TeamProxy = TeamProxy.Instance
  if not _TeamProxy:IHaveTeam() then
    return false
  end
  local list = _TeamProxy.myTeam:GetPlayerMemberList(false, true)
  local _NSceneUserProxy = NSceneUserProxy.Instance
  local can, memberCreature
  for i = 1, #list do
    memberCreature = _NSceneUserProxy:Find(list[i].id)
    if memberCreature ~= nil then
      can = skillInfo:CheckEnsembleSkill(self, memberCreature)
      if can == true then
        return true
      end
    end
  end
  return false
end
function NMyselfPlayer:Logic_PeakEffect()
  local peak = self.data.userdata:Get(UDEnum.PEAK_EFFECT) or 0
  if peak ~= 1 then
    return false
  end
  local selfPeak = FunctionPerformanceSetting.Me():GetSetting().selfPeak
  if selfPeak == false then
    return false
  end
  return true
end
