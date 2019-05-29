autoImport("SceneCreatureProxy")
NSceneNpcProxy = class("NSceneNpcProxy", SceneCreatureProxy)
NSceneNpcProxy.Instance = nil
NSceneNpcProxy.NAME = "NSceneNpcProxy"
local tmpArray = {}
function NSceneNpcProxy:ctor(proxyName, data)
  self:CountClear()
  self.cacheParts = {}
  self.userMap = {}
  self.npcMap = {}
  self.npcGroupMap = {}
  if NSceneNpcProxy.Instance == nil then
    NSceneNpcProxy.Instance = self
  end
  self.proxyName = proxyName or NSceneNpcProxy.NAME
  if Game and Game.LogicManager_Creature then
    Game.LogicManager_Creature:SetSceneNpcProxy(self)
  end
  self.delayRemoveDuration = {}
  self.delayRemoveDuration[NpcData.NpcDetailedType.MVP] = GameConfig.MonsterBodyDisappear.MVP
  self.delayRemoveDuration[NpcData.NpcDetailedType.MINI] = GameConfig.MonsterBodyDisappear.MINI
  self.delayRemoveDuration[NpcData.NpcDetailedType.NPC] = GameConfig.MonsterBodyDisappear.NPC
  self.delayRemoveDuration[NpcData.NpcDetailedType.Monster] = GameConfig.MonsterBodyDisappear.Monster
end
function NSceneNpcProxy:SyncMove(data)
  local npc = self:Find(data.charid)
  if nil ~= npc then
    npc:Server_MoveToXYZCmd(data.pos.x, data.pos.y, data.pos.z)
    local f_notifyMove = npc.data and npc.data.GetFeature_NotifyMove
    if f_notifyMove and f_notifyMove(npc.data) then
      GameFacade.Instance:sendNotification(SceneUserEvent.NpcSyncMove, npc.data.id)
    end
    return true
  end
  return false
end
local FUNC_GET_NPC_CLASSREF = function(data, classRef)
  if classRef then
    return classRef
  end
  local isStage
  for k, v in pairs(GameConfig.DressUp.stageid) do
    isStage = data.npcID == v
    if isStage then
      return NStageNpc
    end
  end
  return NNpc
end
function NSceneNpcProxy:Add(data, classRef, isTrap)
  local npc = self:Find(data.id)
  if npc ~= nil then
    return npc
  end
  classRef = FUNC_GET_NPC_CLASSREF(data, classRef)
  npc = classRef.CreateAsTable(data)
  if data.dest ~= nil and not PosUtil.IsZero(data.dest) then
    npc:Server_MoveToXYZCmd(data.dest.x, data.dest.y, data.dest.z, 1000)
  end
  self.userMap[data.id] = npc
  if classRef == NNpc or classRef == NStageNpc then
    if isTrap and data.owner ~= 0 then
      local creature = SceneCreatureProxy.FindCreature(data.owner)
      if creature and creature.data:GetCamp() == RoleDefines_Camp.ENEMY then
        npc:ShowWarnRingEffect()
      end
    end
    self:AddNpc(npc)
  end
  if 0 < data.searchrange then
    npc:ShowViewRange(data.searchrange)
  end
  self:CountPlus()
  if data.effect then
  end
  if npc.data and npc.data:IsMusicBox() then
    FunctionMusicBox.Me():AddMusicBox(npc)
  end
  local spEffectDatas = data.speffectdata
  if nil ~= spEffectDatas then
    for i = 1, #spEffectDatas do
      npc:Server_AddSpEffect(spEffectDatas[i])
    end
  end
  return npc
end
function NSceneNpcProxy:Remove(guid, delay, fadeout)
  if FunctionPurify.Me():MonsterNeedPurify(guid) then
    return nil
  end
  local npc = self:Find(guid)
  if nil ~= npc then
    if npc.data:IsMusicBox() then
      FunctionMusicBox.Me():RemoveMusicBox(npc)
    end
    self:RemoveNpc(npc)
    if npc:IsDead() and npc.data:IsMonster_Detail() then
      self:Die(guid, npc)
    elseif delay ~= nil and delay > 0 or fadeout ~= nil and fadeout > 0 then
      self:DelayRemove(npc, delay, fadeout)
    else
      self:RealRemove(guid, false)
    end
    return true
  end
  return false
end
function NSceneNpcProxy:SetSearchRange(data)
  local npc = self:Find(data.id)
  if npc ~= nil then
    npc:ShowViewRange(data.range)
  end
end
local tmpNpcs = {}
function NSceneNpcProxy:PureAddSome(datas)
  local data
  for i = 1, #datas do
    data = datas[i]
    if data ~= nil then
      local isTrap = false
      for _, trapId in pairs(GameConfig.TrapNpcID) do
        if data.npcID == trapId then
          isTrap = true
          break
        end
      end
      if data.owner == 0 or isTrap then
        tmpNpcs[#tmpNpcs + 1] = self:Add(data, nil, isTrap)
      else
        tmpArray[#tmpArray + 1] = data
      end
    end
  end
  if #tmpNpcs > 0 then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneAddNpcs, tmpNpcs)
    EventManager.Me():PassEvent(SceneUserEvent.SceneAddNpcs, tmpNpcs)
    TableUtility.ArrayClear(tmpNpcs)
  end
  if tmpArray and #tmpArray > 0 then
    NScenePetProxy.Instance:PureAddSome(tmpArray)
    TableUtility.ArrayClear(tmpArray)
  end
end
function NSceneNpcProxy:RemoveSome(guids, delay, fadeout)
  local npcs = NSceneNpcProxy.super.RemoveSome(self, guids, delay, fadeout)
  if npcs and #npcs > 0 then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveNpcs, npcs)
    EventManager.Me():PassEvent(SceneUserEvent.SceneRemoveNpcs, npcs)
  end
end
function NSceneNpcProxy:Die(guid, npc)
  if npc == nil then
    npc = self:Find(guid)
  end
  if npc then
    local delay = self.delayRemoveDuration[npc.data.detailedType]
    if delay == nil then
      delay = 2000
    end
    npc:SetDelayRemove(delay / 1000)
  end
  return npc
end
function NSceneNpcProxy:DelayRemove(npc, delay, duration)
  if npc then
    delay = delay or 0
    npc:SetDelayRemove(delay / 1000, duration and duration / 1000)
  end
end
function NSceneNpcProxy:DieWithoutDelayRemove(guid)
  return NSceneNpcProxy.super.Die(self, guid)
end
function NSceneNpcProxy:RealRemove(guid, fade)
  return NSceneNpcProxy.super.Remove(self, guid, fade)
end
local clearArr = {}
function NSceneNpcProxy:Clear()
  self:ChangeAddMode(SceneCreatureProxy.AddMode.Normal)
  self:ClearNpc()
  local npcs = NSceneNpcProxy.super.Clear(self)
  if npcs and #npcs > 0 then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveNpcs, npcs)
    EventManager.Me():PassEvent(SceneUserEvent.SceneRemoveNpcs, npcs)
  end
  self:ClearPartsCache()
end
function NSceneNpcProxy:GetOrCreatePartsFromStaticData(staticData)
  local parts = self.cacheParts[staticData.id]
  if parts == nil then
    parts = Asset_Role.CreatePartArray()
    Asset_RoleUtility.SetRoleParts(staticData, parts)
    self.cacheParts[staticData.id] = parts
  end
  return parts
end
local emptyParts
function NSceneNpcProxy:GetNpcEmptyParts()
  if emptyParts == nil then
    emptyParts = Asset_Role.CreatePartArray()
  end
  return emptyParts
end
function NSceneNpcProxy:ClearPartsCache()
  if self.cacheParts then
    for k, v in pairs(self.cacheParts) do
      Asset_Role.DestroyPartArray(v)
      self.cacheParts[k] = nil
    end
  else
    self.cacheParts = {}
  end
end
function NSceneNpcProxy:AddNpcIntoMap(npc)
  local npcID = npc.data.staticData.id
  local npcList = self.npcMap[npcID]
  if nil == npcList then
    npcList = {}
    self.npcMap[npcID] = npcList
  elseif 1 <= TableUtil.ArrayIndexOf(npcList, npc) then
    return
  end
  npcList[#npcList + 1] = npc
end
function NSceneNpcProxy:AddNpcIntoGroupMap(npc)
  local npcGroupID = npc.data:GetGroupID()
  if nil == npcGroupID then
    return
  end
  local npcList = self.npcGroupMap[npcGroupID]
  if nil == npcList then
    npcList = {}
    self.npcGroupMap[npcGroupID] = npcList
  elseif 1 <= TableUtil.ArrayIndexOf(npcList, npc) then
    return
  end
  npcList[#npcList + 1] = npc
end
function NSceneNpcProxy:AddNpc(npc)
  self:AddNpcIntoMap(npc)
  self:AddNpcIntoGroupMap(npc)
end
function NSceneNpcProxy:RemoveNpcFromMap(npc)
  local npcID = npc.data.staticData.id
  local npcList = self.npcMap[npcID]
  if nil ~= npcList then
    TableUtil.Remove(npcList, npc)
  end
end
function NSceneNpcProxy:RemoveNpcFromGroupMap(npc)
  local npcGroupID = npc.data:GetGroupID()
  if nil == npcGroupID then
    return
  end
  local npcList = self.npcGroupMap[npcGroupID]
  if nil ~= npcList then
    TableUtil.Remove(npcList, npc)
  end
end
function NSceneNpcProxy:RemoveNpc(npc)
  if nil == npc then
    return
  end
  self:RemoveNpcFromMap(npc)
  self:RemoveNpcFromGroupMap(npc)
end
function NSceneNpcProxy:ClearNpc()
  self.npcMap = {}
  self.npcGroupMap = {}
end
function NSceneNpcProxy:FindNpcs(npcID)
  return self.npcMap[npcID]
end
function NSceneNpcProxy:FindNpcsByGroupID(npcGroupID)
  return self.npcGroupMap[npcGroupID]
end
local tempPos = LuaVector3.zero
function NSceneNpcProxy:_FindNearestNpc(npcs, position, filter, randomDistance)
  tempPos:Set(position[1], position[2], position[3])
  local nearestNpc
  local minDist = 9999
  if nil == randomDistance then
    randomDistance = 0
  end
  for i = 1, #npcs do
    local npc = npcs[i]
    if nil == filter or filter(npc) then
      local npcPosition = npc:GetPosition()
      local dist = LuaVector3.Distance(npcPosition, tempPos)
      if randomDistance > 0 and randomDistance > dist then
        return npc, dist
      end
      if minDist > dist then
        local canArrive = NavMeshUtils.CanArrived(tempPos, npcPosition, WorldTeleport.DESTINATION_VALID_RANGE, true)
        if canArrive then
          minDist = dist
          nearestNpc = npc
        end
      end
    else
    end
  end
  return nearestNpc, minDist
end
local templist
function NSceneNpcProxy:_FindNearestNpcByNavmesh(npcs, position, filter, randomDistance)
  tempPos:Set(position[1], position[2], position[3])
  if templist == nil then
    templist = {}
  end
  local limitNum, insertCount = 3, 0
  local inserted
  for i = 1, #npcs do
    local npc = npcs[i]
    if nil == filter or filter(npc) then
      local npcPosition = npc:GetPosition()
      local dist = LuaVector3.Distance(npcPosition, tempPos)
      if randomDistance > 0 and randomDistance > dist then
        return npc, dist
      end
      inserted = false
      if limitNum > insertCount then
        for j = 1, insertCount do
          if dist < templist[j][3] then
            inserted = true
            table.insert(templist, j, {
              npc,
              npcPosition,
              dist
            })
          end
        end
        if not inserted then
          table.insert(templist, {
            npc,
            npcPosition,
            dist
          })
        end
        insertCount = insertCount + 1
      else
        for j = 1, insertCount do
          if dist < templist[j][3] then
            inserted = true
            table.insert(templist, j, {
              npc,
              npcPosition,
              dist
            })
          end
        end
        if inserted then
          table.remove(templist)
        end
      end
    end
  end
  local minDist, nearestNpc = math.huge, nil
  for i = 1, #templist do
    local npcPosition = templist[i][2]
    local suc, path
    suc, path = NavMeshUtils.CanArrived(tempPos, npcPosition, WorldTeleport.DESTINATION_VALID_RANGE, true, nil)
    if suc then
      local dist = NavMeshUtils.GetPathDistance(path)
      if minDist > dist then
        minDist = dist
        nearestNpc = templist[i][1]
      end
    end
  end
  TableUtility.ArrayClear(templist)
  return nearestNpc, minDist
end
function NSceneNpcProxy:FindNearestNpc(position, npcID, filter, randomDistance, useNavmesh)
  local npcs = self:FindNpcs(npcID)
  if nil == npcs then
    return nil
  end
  if useNavmesh then
    return self:_FindNearestNpcByNavmesh(npcs, position, filter, randomDistance)
  else
    return self:_FindNearestNpc(npcs, position, filter, randomDistance)
  end
end
function NSceneNpcProxy:FindNearestNpcByGroupID(position, npcGroupID, filter, randomDistance)
  local npcs = self:FindNpcsByGroupID(npcGroupID)
  if nil == npcs then
    return nil
  end
  return self:_FindNearestNpc(npcs, position, filter, randomDistance)
end
function NSceneNpcProxy:FindNearNpcs(position, distance, filter)
  tempPos:Set(position[1], position[2], position[3])
  local list = {}
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      local npc = v[i]
      if nil == filter or filter(npc) then
        local dist = LuaVector3.Distance(npc:GetPosition(), tempPos)
        if distance >= dist then
          table.insert(list, npc)
        end
      end
    end
  end
  return list
end
function NSceneNpcProxy:FindNpcByUniqueId(uniqueId, filter)
  local list = {}
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      local npc = v[i]
      if (nil == filter or filter(npc)) and uniqueId == npc.data.uniqueid then
        table.insert(list, npc)
      end
    end
  end
  return list
end
function NSceneNpcProxy:PickNpcs(filter)
  local list = {}
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      local npc = v[i]
      if nil == filter or filter(npc) then
        table.insert(list, npc)
      end
    end
  end
  return list
end
