IdleAI_AutoBattle = class("IdleAI_AutoBattle")
local UpdateInterval = 0.1
local TableClear = TableUtility.TableClear
local FindCreature = SceneCreatureProxy.FindCreature
function IdleAI_AutoBattle:ctor()
  self.autoBattle = AutoBattle.new()
  self.skillInfo = nil
  self.skillNoTarget = false
  self.skillLaunchRange = 0
  function self.targetFilter(target)
    if nil ~= target then
      if nil ~= self.skillInfo and not self.skillNoTarget then
        if self.skillInfo:CheckTarget(Game.Myself, target) then
          if self.standing and 0 < self.skillLaunchRange then
            local dist = VectorUtility.DistanceXZ(target:GetPosition(), Game.Myself:GetPosition())
            if dist > self.skillLaunchRange then
              return false
            end
          end
          return true
        end
      elseif not target:IsDead() and not target.data:NoAccessable() then
        return true
      end
    end
    return false
  end
  self.on = false
  self.requestOn = nil
  self.lockIDs = {}
  self.protectTeam = false
  self.standing = false
  self.currentTargetGUID = 0
  self.nextUpdateTime = 0
end
function IdleAI_AutoBattle:Clear(idleElapsed, time, deltaTime, creature)
  self.autoBattle:Reset()
  self.nextUpdateTime = 0
end
function IdleAI_AutoBattle:Prepare(idleElapsed, time, deltaTime, creature)
  if nil ~= creature.ai.parent then
    return false
  end
  if nil ~= self.requestOn then
    local on = self.requestOn
    self.requestOn = nil
    self:_Set(on)
  end
  return self.on
end
function IdleAI_AutoBattle:Start(idleElapsed, time, deltaTime, creature)
end
function IdleAI_AutoBattle:End(idleElapsed, time, deltaTime, creature)
end
function IdleAI_AutoBattle:Update(idleElapsed, time, deltaTime, creature)
  if time < self.nextUpdateTime then
    return true
  end
  self.nextUpdateTime = time + UpdateInterval
  if next(self.lockIDs) then
    if creature.data:NoAttack() then
      return true
    end
    local ret, skillIDAndLevel, noTarget, forceLockCreature, skillInfo = self.autoBattle:Attack_Step1(creature)
    if not ret then
      return true
    end
    if nil ~= forceLockCreature then
      self.autoBattle:Attack_Step2(creature, nil, skillIDAndLevel, noTarget, forceLockCreature, skillInfo, false, true)
      return true
    end
    local targetCreature = self:GetLockTarget(creature, skillInfo, noTarget)
    if nil ~= targetCreature then
      self.autoBattle:Attack_Step2(creature, targetCreature, skillIDAndLevel, noTarget, forceLockCreature, skillInfo, false, true)
    elseif skillInfo:NoTargetAutoCast(creature) then
      self.autoBattle:Attack_Step2(creature, targetCreature, skillIDAndLevel, noTarget, forceLockCreature, skillInfo, true, true)
    end
  else
    self.autoBattle:Update(creature, nil, nil, true)
  end
  return true
end
function IdleAI_AutoBattle:_Set(on)
  self.on = on
  if self.on then
    self.ignoreAutoBattle = true
    Game.AutoBattleManager:SetController(self)
    self.ignoreAutoBattle = nil
    if Game.AutoBattleManager.on then
      local eventManager = EventManager.Me()
      eventManager:DispatchEvent(AutoBattleManagerEvent.StateChanged, Game.AutoBattleManager)
    else
      Game.AutoBattleManager:AutoBattleOn()
    end
  else
    TableClear(self.lockIDs)
    self.currentTargetGUID = 0
    self.protectTeam = false
    self.standing = false
    Game.AutoBattleManager:ClearController(self, true)
  end
end
function IdleAI_AutoBattle:_GetNearestNpc(creature, randomRange)
  local minDis = 999999
  local finalcreature
  for id, _ in pairs(self.lockIDs) do
    local creature, dis = NSceneNpcProxy.Instance:FindNearestNpc(creature:GetPosition(), id, self.targetFilter, randomRange, true)
    if creature and dis and minDis > dis then
      minDis = dis
      finalcreature = creature
    end
  end
  return finalcreature
end
function IdleAI_AutoBattle:GetLockTarget(creature, skillInfo, noTarget)
  self.skillInfo = skillInfo
  if nil ~= skillInfo then
    if SkillTargetType.Creature == skillInfo:GetTargetType(self) then
      self.skillNoTarget = false
    else
      self.skillNoTarget = noTarget or false
    end
    self.skillLaunchRange = skillInfo:GetLaunchRange(creature)
  else
    self.skillNoTarget = false
    self.skillLaunchRange = 0
  end
  local lockedTarget = creature:GetLockTarget()
  if nil ~= lockedTarget and nil ~= lockedTarget.data and nil ~= lockedTarget.data.staticData and self.lockIDs[lockedTarget.data.staticData.id] and self.targetFilter(lockedTarget) then
    self.currentTargetGUID = 0
    self.skillInfo = nil
    self.skillNoTarget = false
    self.skillLaunchRange = 0
    return lockedTarget
  end
  local targetCreature
  if 0 ~= self.currentTargetGUID then
    targetCreature = FindCreature(self.currentTargetGUID)
    if nil ~= targetCreature then
      if self.targetFilter(targetCreature) then
        self.skillInfo = nil
        self.skillNoTarget = false
        self.skillLaunchRange = 0
        return targetCreature
      else
        targetCreature = nil
      end
    else
      self.currentTargetGUID = 0
    end
  end
  local randomRange
  if nil ~= skillInfo then
    randomRange = skillInfo:GetLaunchRange(creature)
    if randomRange <= 0 then
      randomRange = AutoBattle.SearchRandomDistance
    end
  else
    randomRange = AutoBattle.SearchRandomDistance
  end
  targetCreature = self:_GetNearestNpc(creature, randomRange)
  if nil ~= targetCreature then
    if targetCreature.data == nil then
      LogUtility.DebugInfoFormat(targetCreature.assetRole.complete, "<color=red>GetLockTarget: </color>{0}, in range {1}", targetCreature.data and targetCreature.data:GetName(), randomRange)
    else
      self.currentTargetGUID = targetCreature.data.id
    end
  end
  self.skillInfo = nil
  self.skillNoTarget = false
  self.skillLaunchRange = 0
  return targetCreature
end
function IdleAI_AutoBattle:SearchLockTarget(creature, skillInfo, noTarget)
  self.skillInfo = skillInfo
  if nil ~= skillInfo then
    if SkillTargetType.Creature == skillInfo:GetTargetType(self) then
      self.skillNoTarget = false
    else
      self.skillNoTarget = noTarget or false
    end
    self.skillLaunchRange = skillInfo:GetLaunchRange(creature)
  else
    self.skillNoTarget = false
    self.skillLaunchRange = 0
  end
  local randomRange
  if nil ~= skillInfo then
    randomRange = skillInfo:GetLaunchRange(creature)
    if randomRange <= 0 then
      randomRange = AutoBattle.SearchRandomDistance
    end
  else
    randomRange = AutoBattle.SearchRandomDistance
  end
  targetCreature = self:_GetNearestNpc(creature, randomRange)
  if nil ~= targetCreature then
    self.currentTargetGUID = targetCreature.data.id
  else
    self.currentTargetGUID = 0
  end
  self.skillInfo = nil
  self.skillNoTarget = false
  self.skillLaunchRange = 0
  return targetCreature
end
function IdleAI_AutoBattle:IsProtectingTeam(creature)
  return self.on and self.protectTeam
end
function IdleAI_AutoBattle:IsStanding(creature)
  return self.on and self.standing
end
function IdleAI_AutoBattle:Request_ClearCurrentTarget()
  self.currentTargetGUID = 0
end
function IdleAI_AutoBattle:Request_SetLockID(lockID)
  helplog("Request_SetLockID", lockID)
  self.lockIDs[lockID] = 1
  if lockID == 0 then
    self.currentTargetGUID = 0
  end
end
function IdleAI_AutoBattle:Request_UnSetLockID(lockID)
  helplog("Request_UnSetLockID", lockID)
  self.lockIDs[lockID] = nil
  if not next(self.lockIDs) then
    self:_Set(false)
  end
end
function IdleAI_AutoBattle:Request_SetProtectTeam(on)
  self.protectTeam = on
end
function IdleAI_AutoBattle:Request_SetStanding(on)
  self.standing = on
end
function IdleAI_AutoBattle:Request_Set(on)
  helplog("Request_Set", on)
  self.requestOn = on
end
function IdleAI_AutoBattle:AutoBattleOn()
  if self.ignoreAutoBattle then
    return
  end
  if nil ~= self.requestOn then
    if self.requestOn then
      return
    end
  elseif self.on then
    return
  end
  Game.Myself.ai:SetAuto_Battle(true, Game.Myself)
end
function IdleAI_AutoBattle:AutoBattleOff()
  if self.ignoreAutoBattle then
    return
  end
  if nil ~= self.requestOn then
    if not self.requestOn then
      return
    end
  elseif not self.on then
    return
  end
  local myself = Game.Myself
  local myAI = myself.ai
  myAI:SetAuto_Battle(false, myself)
end
function IdleAI_AutoBattle:AutoBattleLost()
  if self.on then
    self:_Set(false)
  end
end
