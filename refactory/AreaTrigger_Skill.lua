AreaTrigger_Skill = reusableClass("AreaTrigger_Skill")
local UpdateInterval = 0.07
local Resume_skilltransport_time = 2
AreaTrigger_Skill.Transport = 1
function AreaTrigger_Skill:DoConstruct(asArray, data)
  self.skill_transport_resumeSyncMoveFlag = 0
  self:CreateWeakData()
  self.triggers = {}
  self.nextUpdateTime = 0
  self.triggerEnterCall = {}
  self.triggerEnterCall[AreaTrigger_Skill.Transport] = self.EnterSkillTransport
  self.triggerLeaveCall = {}
  self.triggerRemoveCall = {}
end
function AreaTrigger_Skill:Launch()
  if self.running then
    return
  end
  self.running = true
end
function AreaTrigger_Skill:Shutdown()
  if not self.running then
    return
  end
  self.running = false
end
local distanceFunc = VectorUtility.DistanceXZ
function AreaTrigger_Skill:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time < self.nextUpdateTime then
    return
  end
  self.nextUpdateTime = time + UpdateInterval
  local myselfPosition = Game.Myself:GetPosition()
  for id, trigger in pairs(self.triggers) do
    if distanceFunc(myselfPosition, trigger:GetPosition()) <= trigger.reachDis then
      self:EnterArea(trigger)
    else
      self:ExitArea(trigger)
    end
  end
  if self.skill_transport_resumeSyncMoveFlag > 0 and time >= self.skill_transport_resumeSyncMoveFlag then
    self:SkillTransport_ResumeSyncMove()
  end
end
function AreaTrigger_Skill:SkillTransport_ResumeSyncMove(nextFrame)
  if nextFrame then
    self.skill_transport_resumeSyncMoveFlag = Time.time + 0.05
  else
    self.skill_transport_resumeSyncMoveFlag = 0
    FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.Skill_Transport, true)
  end
end
function AreaTrigger_Skill:EnterSkillTransport(trigger)
  FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.Skill_Transport, false)
  self.skill_transport_resumeSyncMoveFlag = Time.time + Resume_skilltransport_time
  ServiceSkillProxy.Instance:CallTriggerSkillNpcSkillCmd(trigger.id, SceneSkill_pb.ETRIGTSKILL_BTRANS)
end
function AreaTrigger_Skill:EnterArea(trigger)
  if trigger.reached == false then
    trigger.reached = true
    local call = self.triggerEnterCall[trigger.type]
    if call then
      call(self, trigger)
    end
  end
end
function AreaTrigger_Skill:ExitArea(trigger)
  if trigger.reached == true then
    trigger.reached = false
    local call = self.triggerLeaveCall[trigger.type]
    if call then
      call(self, trigger)
    end
  end
end
function AreaTrigger_Skill:_RemoveCall(trigger)
  local call = self.triggerRemoveCall[trigger.type]
  if call then
    call(self, trigger)
  end
end
function AreaTrigger_Skill:AddCheck(trigger)
  if self.triggers[trigger.id] == nil then
    self.triggers[trigger.id] = trigger
    if trigger.creature then
      self:SetWeakData(trigger.id, trigger.creature)
    end
    trigger.reached = false
  end
end
function AreaTrigger_Skill:RemoveCheck(id)
  local trigger = self.triggers[id]
  if trigger ~= nil then
    self:_RemoveCall(trigger)
    trigger:Destroy()
  end
  self.triggers[id] = nil
  return trigger
end
function AreaTrigger_Skill:OnObserverDestroyed(id, obj)
  self:RemoveCheck(id)
end
SkillAreaTrigger = reusableClass("SkillAreaTrigger")
SkillAreaTrigger.PoolSize = 20
function SkillAreaTrigger:GetPosition()
  if self.creature then
    return self.creature:GetPosition()
  end
  return self.pos
end
function SkillAreaTrigger:DoConstruct(asArray, data)
  self.id = data.id
  self.type = data.type
  self.creature = data.creature
  self.pos = data.pos
  self.reachDis = data.reachDis
end
function SkillAreaTrigger:DoDeconstruct(asArray)
  self.creature = nil
end
