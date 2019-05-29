autoImport("SceneObjectProxy")
SceneCreatureProxy = class("SceneCreatureProxy", SceneObjectProxy)
SceneCreatureProxy.Instance = nil
SceneCreatureProxy.NAME = "SceneCreatureProxy"
SceneCreatureProxy.FADE_IN_OUT_DURATION = 1
SceneCreatureProxy.SampleInterval = 0
function SceneCreatureProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SceneCreatureProxy.NAME
  self:CountClear()
  self.userMap = {}
  self.addMode = SceneObjectProxy.AddMode.Normal
  if SceneCreatureProxy.Instance == nil then
    SceneCreatureProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
end
function SceneCreatureProxy.FindCreature(guid)
  local target = NSceneUserProxy.Instance:Find(guid)
  if target == nil then
    target = NSceneNpcProxy.Instance:Find(guid)
    if target == nil then
      target = NScenePetProxy.Instance:Find(guid)
      if target == nil then
        target = SceneAINpcProxy.Instance:Find(guid)
      end
    end
  end
  return target
end
function SceneCreatureProxy.FindOtherCreature(guid)
  local myself = Game.Myself
  if myself and myself.data and guid == myself.data.id then
    return nil
  end
  local target = NSceneUserProxy.Instance:Find(guid)
  if target == nil then
    target = NSceneNpcProxy.Instance:Find(guid)
    if target == nil then
      target = NScenePetProxy.Instance:Find(guid)
    end
  end
  return target
end
function SceneCreatureProxy.ResetPos(guid, pos, isgomap)
  if guid == 0 then
    guid = Game.Myself.data.id
  end
  if SceneCarrierProxy.Instance:CreatureIsInCarrier(guid) then
    errorLog(string.format("\231\142\169\229\174\182%s\229\183\178\229\156\168\232\189\189\229\133\183\228\184\173\239\188\140\230\156\141\229\138\161\229\153\168\233\128\154\231\159\165\233\135\141\232\174\190\228\189\141\231\189\174", guid))
  elseif guid == Game.Myself.data.id then
    MyselfProxy.Instance:ResetMyPos(pos.x, pos.y, pos.z, isgomap)
  else
    local creature = SceneCreatureProxy.FindCreature(guid)
    if creature then
      creature:Server_SetPosXYZCmd(pos.x, pos.y, pos.z, 1000)
    end
  end
end
function SceneCreatureProxy.ForEachCreature(func, args)
  if NSceneUserProxy.Instance:ForEach(func, args) then
    return
  end
  if NSceneNpcProxy.Instance:ForEach(func, args) then
    return
  end
  if nil ~= Game.Myself then
    func(Game.Myself, args)
  end
end
function SceneCreatureProxy:Add(data)
  return nil
end
function SceneCreatureProxy:SetProps(guid, attrs, update)
  local creature = self:Find(guid)
  if creature ~= nil then
    creature:SetProps(attrs, update)
  end
end
function SceneCreatureProxy:PureAddSome(datas)
  local roles = {}
  for i = 1, #datas do
    if datas[i] ~= nil then
      local role = self:Add(datas[i])
      if role ~= nil then
        roles[#roles + 1] = role
      end
    end
  end
  return roles
end
local S2C_Number = ProtolUtility.S2C_Number
function SceneCreatureProxy:ParsePhaseData(serverSkillBroadCastData)
  if self.phasedata == nil then
    self.phasedata = SkillPhaseData.Create(serverSkillBroadCastData.skillID)
  else
    self.phasedata:Reset(serverSkillBroadCastData.skillID)
  end
  self.phasedata:ParseFromServer(serverSkillBroadCastData)
end
function SceneCreatureProxy:SyncServerSkill(data)
  self:ParsePhaseData(data)
  if SkillPhase.Hit == self.phasedata:GetSkillPhase() then
    SkillLogic_Base.HitTargetByPhaseData(self.phasedata, data.charid)
    return true
  else
    local role = self:Find(data.charid)
    if nil ~= role and Game.Myself ~= role then
      role:Server_SyncSkill(self.phasedata)
      return true
    end
  end
  return false
end
function SceneCreatureProxy:NotifyUseSkill(data)
  local creature = self:Find(data.charid)
  if nil ~= creature and creature == Game.Myself and nil ~= data.petid and data.petid < 0 then
    if SkillPhase.None == data.data.number then
      creature:Server_BreakSkill(data.skillID)
      return true
    end
    local phaseDataCustom = data.data
    local targetID, targetCreature, targetPosition
    if phaseDataCustom.hitedTargets and 0 < #phaseDataCustom.hitedTargets then
      targetID = phaseDataCustom.hitedTargets[1].charid
      targetCreature = SceneCreatureProxy.FindCreature(targetID)
    else
      targetPosition = ProtolUtility.S2C_Vector3(phaseDataCustom.pos)
    end
    creature:Server_UseSkill(data.skillID, targetCreature, targetPosition)
    if targetPosition then
      targetPosition:Destroy()
    end
    return true
  end
  return false
end
function SceneCreatureProxy:SyncServerPetSkill(data)
  local role = self:Find(data.charid)
  if nil ~= role and nil ~= role.partner then
    self:ParsePhaseData(data)
    role.partner:Server_SyncSkill(self.phasedata)
    return true
  end
  return false
end
function SceneCreatureProxy:Die(guid, creature)
  local role = creature
  if nil == creature then
    role = self:Find(guid)
  end
  if role ~= nil then
    if Creature_Type.Me == role.creatureType then
      role.roleAgent:Die()
    else
      RoleControllerInterface.ServerDie(role.roleAgent)
    end
  end
  return role
end
function SceneCreatureProxy:DieWithoutAction(guid, creature)
  local role = creature
  if nil == creature then
    role = self:Find(guid)
  end
  if role ~= nil then
    if Creature_Type.Me == role.creatureType then
      role.roleAgent:DieWithoutAction()
    else
      RoleControllerInterface.ServerDieWithoutAction(role.roleAgent)
    end
  end
  return role
end
function SceneCreatureProxy:reLive(guid)
  local role = self:Find(guid)
  if role ~= nil then
    if Creature_Type.Me == role.creatureType then
      role.roleAgent:Revive()
    else
      RoleControllerInterface.ServerRevive(role.roleAgent)
    end
  end
end
function SceneCreatureProxy:Remove(guid, fade)
  local creature = self.userMap[guid]
  if creature ~= nil then
    self.userMap[guid] = nil
    creature:Destroy()
    self:CountMinus()
    EventManager.Me():DispatchEvent(SceneCreatureEvent.CreatureRemove, guid)
    return true
  end
  return false
end
function SceneCreatureProxy:Clear()
  self.removeSomes = self.removeSomes and self.removeSomes or {}
  TableUtility.ArrayClear(self.removeSomes)
  self:ChangeAddMode(SceneCreatureProxy.AddMode.Normal)
  for id, o in pairs(self.userMap) do
    EventManager.Me():DispatchEvent(SceneCreatureEvent.CreatureRemove, id)
    self.removeSomes[#self.removeSomes + 1] = id
    self.userMap[id] = nil
    o:Destroy()
  end
  return self.removeSomes
end
function SceneCreatureProxy:CountPlus(num)
  if not num or not num then
    num = 1
  end
  self.currentCount = self.currentCount + num
  self:OnCountChanged()
end
function SceneCreatureProxy:CountMinus(num)
  if not num or not num then
    num = 1
  end
  self.currentCount = math.max(0, self.currentCount - num)
  self:OnCountChanged()
end
function SceneCreatureProxy:CountClear()
  self.currentCount = 0
  self:OnCountChanged()
end
function SceneCreatureProxy:GetCount()
  return self.currentCount
end
function SceneCreatureProxy:OnCountChanged()
end
function SceneCreatureProxy:ForEach(func, args)
  if nil ~= self.userMap then
    for k, v in pairs(self.userMap) do
      if func(v, args) then
        return true
      end
    end
  end
  return false
end
