local tempVector3 = LuaVector3.zero
function NCreature:Logic_PlayAction(params)
  if self.data and self.data:Freeze() then
    return false
  end
  if nil == params[3] then
    params[3] = 1
  end
  if nil == params[2] then
    params[2] = self:GetIdleAction()
  end
  self.assetRole:PlayAction(params)
  return true
end
function NCreature:Logic_PlayAction_Simple(name, defaultName, speed)
  if self.data and self.data:Freeze() then
    return false
  end
  if nil == speed then
    speed = 1
  end
  if nil == defaultName then
    defaultName = self:GetIdleAction()
  end
  self.assetRole:PlayAction_Simple(name, defaultName, speed)
  return true
end
function NCreature:Logic_PlayAction_Idle()
  return self:Logic_PlayAction_Simple(self:GetIdleAction())
end
function NCreature:Logic_PlayAction_Move()
  if self.data and self.data:Freeze() then
    return false
  end
  local name = self:GetMoveAction()
  local moveActionScale = 1
  local staticData = self.data.staticData
  if nil ~= staticData and nil ~= staticData.MoveSpdRate then
    moveActionScale = staticData.MoveSpdRate
  end
  local moveSpeed = self.data.props.MoveSpd:GetValue()
  local actionSpeed = moveActionScale * moveSpeed
  self.assetRole:PlayAction_Simple(name, nil, actionSpeed)
  return true
end
function NCreature:Logic_PlaceXYZTo(x, y, z)
  tempVector3:Set(x, y, z)
  self:Logic_PlaceTo(tempVector3)
end
function NCreature:Logic_PlaceTo(p)
  self.logicTransform:PlaceTo(p)
end
function NCreature:Logic_NavMeshPlaceXYZTo(x, y, z)
  tempVector3:Set(x, y, z)
  self:Logic_NavMeshPlaceTo(tempVector3)
end
function NCreature:Logic_NavMeshPlaceTo(p)
  self.logicTransform:NavMeshPlaceTo(p)
end
function NCreature:Logic_MoveTo(p)
  self.logicTransform:MoveTo(p)
end
function NCreature:Logic_NavMeshMoveTo(p)
  return self.logicTransform:NavMeshMoveTo(p)
end
function NCreature:Logic_StopMove()
  self.logicTransform:StopMove()
end
function NCreature:Logic_SamplePosition(time)
  self.logicTransform:SamplePosition()
end
function NCreature:Logic_SetAngleY(v)
  self.logicTransform:SetAngleY(v)
end
function NCreature:Logic_Hit(action, stiff)
  self.ai:PushCommand(FactoryAICMD.GetHitCmd(false, action, stiff), self)
end
function NCreature:Logic_DeathBegin()
end
function NCreature:Logic_CastBegin()
  EventManager.Me():DispatchEvent(SkillEvent.SkillCastBegin, self)
end
function NCreature:Logic_CastEnd()
  EventManager.Me():DispatchEvent(SkillEvent.SkillCastEnd, self)
end
function NCreature:Logic_FreeCastBegin()
  EventManager.Me():DispatchEvent(SkillEvent.SkillFreeCastBegin, self)
end
function NCreature:Logic_FreeCastEnd()
  EventManager.Me():DispatchEvent(SkillEvent.SkillFreeCastEnd, self)
end
function NCreature:Logic_Freeze(on)
  on = on or self.data:WeakFreeze()
  if on then
    self.assetRole:SetActionSpeed(0)
  else
    self.assetRole:SetActionSpeed(1)
  end
end
function NCreature:Logic_NoAct(on)
  if on and not self.data:Freeze() then
    self:Logic_PlayAction_Idle()
  end
end
function NCreature:Logic_FearRun(on)
end
local CreatureFollowTarget = "CreatureFollowTarget"
function NCreature:Logic_GetFollowTarget()
  return self:GetWeakData(CreatureFollowTarget)
end
function NCreature:Logic_CanUseSkill()
  return true
end
function NCreature:Logic_ForceRideAction(forceValue)
  if self.forceRideAction == nil then
    self.forceRideAction = 0
  end
  local value = self.forceRideAction + forceValue
  if value == 0 then
    self.forceRideAction = nil
  else
    self.forceRideAction = value
  end
  self:Logic_RideAction()
end
function NCreature:Logic_RideAction()
  if self.assetRole then
    if self.forceRideAction == nil then
      local profess = self.data:GetProfesstion()
      if profess then
        local classData = Table_Class[profess]
        if classData then
          self.assetRole:SetNoRideAction(classData.RideAction ~= 1)
        end
      end
    else
      self.assetRole:SetNoRideAction(false)
    end
  end
end
function NCreature:Logic_AddSkillFreeCast(skillInfo)
  if self.skillFreeCast ~= nil then
    self.skillFreeCast:Destroy()
  end
  local args = SkillFreeCast.GetArgs(self, skillInfo)
  self.skillFreeCast = SkillFreeCast.Create(args)
  EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
end
function NCreature:Logic_RemoveSkillFreeCast()
  if self.skillFreeCast ~= nil then
    self.skillFreeCast:Destroy()
    self.skillFreeCast = nil
    EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
  end
end
function NCreature:Logic_IsFreeCast()
  return self.skillFreeCast ~= nil
end
