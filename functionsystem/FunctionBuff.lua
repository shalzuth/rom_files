autoImport("Buff")
autoImport("BuffGroup")
FunctionBuff = class("FunctionBuff")
function FunctionBuff.Me()
  if nil == FunctionBuff.me then
    FunctionBuff.me = FunctionBuff.new()
  end
  return FunctionBuff.me
end
function FunctionBuff:ctor()
  self.cache_mybuff = {}
end
function FunctionBuff:ServerSyncBuff(serverData)
  local creatureID = serverData.guid
  local creature = SceneCreatureProxy.FindCreature(creatureID)
  local isMine = Game.Myself == creature
  if creature then
    self:_ServerSyncAddBuff(creature, serverData.updates, isMine)
    self:_ServerSyncRemoveBuff(creature, serverData.dels, isMine)
    if isMine then
      GameFacade.Instance:sendNotification(MyselfEvent.SyncBuffs)
      EventManager.Me():PassEvent(MyselfEvent.BuffChange)
    end
  end
end
function FunctionBuff:_ServerSyncAddBuff(creature, ids, isMine)
  local buff
  for i = 1, #ids do
    buff = ids[i]
    creature:AddBuff(buff.id, false, nil, buff.fromid, buff.layer, buff.level, buff.active)
    NSceneUserProxy.Instance:AddScenicBuff(creature.data.id, buff.id)
    if isMine then
      self.cache_mybuff[buff.id] = 1
    end
  end
  if isMine then
    GameFacade.Instance:sendNotification(MyselfEvent.AddBuffs, ids)
    EventManager.Me():PassEvent(MyselfEvent.BuffChange)
  end
end
function FunctionBuff:_ServerSyncRemoveBuff(creature, ids, isMine)
  for i = 1, #ids do
    creature:RemoveBuff(ids[i])
    NSceneUserProxy.Instance:RemoveScenicBuff(creature.data.id, ids[i])
    if isMine then
      self.cache_mybuff[ids[i]] = nil
    end
  end
  if isMine then
    GameFacade.Instance:sendNotification(MyselfEvent.RemoveBuffs, ids)
    EventManager.Me():PassEvent(MyselfEvent.BuffChange)
  end
end
local temp_t = {}
function FunctionBuff:ClearMyBuffs()
  for id, _ in pairs(self.cache_mybuff) do
    table.insert(temp_t, id)
  end
  if #temp_t == 0 then
    return
  end
  self:_ServerSyncRemoveBuff(Game.Myself, temp_t, true)
  TableUtility.ArrayClear(temp_t)
end
local OffEquip_BuffId = 106200
local ProtectEquip_BuffId = 104140
local BreakEquip_BuffId = 104160
local EquipBuffs = {}
function FunctionBuff:UpdateOffingEquipBuff()
  local offPoses = MyselfProxy.Instance:GetOffingEquipPoses()
  if offPoses and #offPoses > 0 then
    local maxtime
    for _, site in pairs(offPoses) do
      local stateTime = MyselfProxy.Instance:GetEquipPos_StateTime(site)
      if stateTime.offendtime and stateTime.offendtime ~= 0 and (maxtime == nil or maxtime < stateTime.offendtime) then
        maxtime = stateTime.offendtime
      end
    end
    if self.offEquipBuff == nil then
      self.offEquipBuff = {}
    else
      TableUtility.TableClear(self.offEquipBuff)
    end
    self.offEquipBuff.isEquipBuff = true
    self.offEquipBuff.id = OffEquip_BuffId
    self.offEquipBuff.time = maxtime * 1000
    table.insert(EquipBuffs, self.offEquipBuff)
    GameFacade.Instance:sendNotification(MyselfEvent.AddBuffs, EquipBuffs)
  else
    GameFacade.Instance:sendNotification(MyselfEvent.RemoveBuffs, {OffEquip_BuffId})
  end
  TableUtility.ArrayClear(EquipBuffs)
end
function FunctionBuff:UpdateProtectEquipBuff()
  local protectPoses = MyselfProxy.Instance:GetProtectEquipPoses()
  if protectPoses and #protectPoses > 0 then
    local maxtime
    local protectalways = false
    for _, site in pairs(protectPoses) do
      local stateTime = MyselfProxy.Instance:GetEquipPos_StateTime(site)
      if stateTime.protecttime and stateTime.protecttime ~= 0 then
        if maxtime == nil or maxtime < stateTime.protecttime then
          maxtime = stateTime.protecttime
        end
        if 0 < stateTime.protectalways then
          protectalways = true
        end
      end
    end
    if self.protectEquipBuff == nil then
      self.protectEquipBuff = {}
    else
      TableUtility.TableClear(self.protectEquipBuff)
    end
    self.protectEquipBuff.isEquipBuff = true
    self.protectEquipBuff.id = ProtectEquip_BuffId
    if protectalways == true then
      self.protectEquipBuff.isalways = true
    else
      self.protectEquipBuff.isalways = false
      if maxtime then
        self.protectEquipBuff.time = maxtime * 1000
      end
    end
    table.insert(EquipBuffs, self.protectEquipBuff)
    GameFacade.Instance:sendNotification(MyselfEvent.AddBuffs, EquipBuffs)
  else
    table.insert(EquipBuffs, ProtectEquip_BuffId)
    GameFacade.Instance:sendNotification(MyselfEvent.RemoveBuffs, EquipBuffs)
  end
  TableUtility.ArrayClear(EquipBuffs)
end
function FunctionBuff:UpdateBreakEquipBuff()
  local breakInfos = BagProxy.Instance.roleEquip:GetBreakEquipSiteInfo()
  if breakInfos and #breakInfos > 0 then
    local maxtime
    for k, v in pairs(breakInfos) do
      if maxtime == nil or maxtime < v.breakendtime then
        maxtime = v.breakendtime
      end
    end
    if self.breakEquipBuff == nil then
      self.breakEquipBuff = {}
    else
      TableUtility.TableClear(self.breakEquipBuff)
    end
    self.breakEquipBuff.isEquipBuff = true
    self.breakEquipBuff.id = BreakEquip_BuffId
    self.breakEquipBuff.time = maxtime * 1000
    table.insert(EquipBuffs, self.breakEquipBuff)
    GameFacade.Instance:sendNotification(MyselfEvent.AddBuffs, EquipBuffs)
  else
    GameFacade.Instance:sendNotification(MyselfEvent.RemoveBuffs, {BreakEquip_BuffId})
  end
  TableUtility.ArrayClear(EquipBuffs)
end
