FunctionQuestDisChecker = class("FunctionQuestDisChecker")
function FunctionQuestDisChecker.Me()
  if nil == FunctionQuestDisChecker.me then
    FunctionQuestDisChecker.me = FunctionQuestDisChecker.new()
  end
  return FunctionQuestDisChecker.me
end
function FunctionQuestDisChecker:ctor()
  self.quests = {}
  self.teleportMap = {}
  self.gmCm = NGUIUtil:GetCameraByLayername("Default")
  TimeTickManager.Me():CreateTick(0, 1000, self.Update, self)
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(MyselfEvent.PlaceTo, self.SceneGoToUserCmd, self)
end
function FunctionQuestDisChecker:AddQuestCheck(argData)
  local id = argData.questData.id
  local data = self.quests[id]
  if data then
    ReusableTable.DestroyAndClearTable(data)
    self.quests[id] = nil
  end
  local map = self.teleportMap[id]
  if map then
    self.teleportMap[id] = nil
    local inner = map.inner
    if inner then
      WorldTeleport.DestroyInnerTeleportInfo(inner)
    end
    ReusableTable.DestroyAndClearTable(map)
  end
  data = ReusableTable.CreateTable()
  data.questData = argData.questData
  data.owner = argData.owner
  data.callback = argData.callback
  self.quests[id] = data
  self:initTeleportInfo(data)
  self:Update()
end
function FunctionQuestDisChecker.RemoveQuestCheck(id)
  if FunctionQuestDisChecker.me then
    FunctionQuestDisChecker.Me():RemoveQuestCheckById(id)
  end
end
function FunctionQuestDisChecker:RemoveQuestCheckById(id)
  local data = self.quests[id]
  if data then
    self.quests[id] = nil
    ReusableTable.DestroyAndClearTable(data)
  end
  local map = self.teleportMap[id]
  if map then
    self.teleportMap[id] = nil
    local inner = map.inner
    if inner then
      WorldTeleport.DestroyInnerTeleportInfo(inner)
    end
    ReusableTable.DestroyAndClearTable(map)
  end
  local count = 0
  for _ in pairs(self.quests) do
    count = count + 1
  end
  if count < 1 then
    self:stopChecker()
  end
end
function FunctionQuestDisChecker:stopChecker()
  TimeTickManager.Me():ClearTick(self)
  local eventManager = EventManager.Me()
  eventManager:RemoveEventListener(MyselfEvent.PlaceTo, self.SceneGoToUserCmd, self)
  FunctionQuestDisChecker.me = nil
end
function FunctionQuestDisChecker:handlePlayerMapChange(note)
  if note.type == LoadSceneEvent.StartLoad then
    return
  end
  self:SceneGoToUserCmd()
end
function FunctionQuestDisChecker:Update(deltaTime)
  if not SceneProxy.Instance:IsLoading() then
    if not self.gmCm or LuaGameObject.ObjectIsNull(self.gmCm) then
      self.gmCm = NGUIUtil:GetCameraByLayername("Default")
    end
    for _, argData in pairs(self.quests) do
      self:adjustQuestDisAndRota(argData)
    end
  end
end
function FunctionQuestDisChecker:SceneGoToUserCmd()
  for id, map in pairs(self.teleportMap) do
    local inner = map.inner
    local outter = map.outter
    if inner then
      WorldTeleport.DestroyInnerTeleportInfo(inner)
    end
    if outter then
      WorldTeleport.DestroyOutterTeleportInfo(outter)
    end
    ReusableTable.DestroyAndClearTable(map)
  end
  TableUtility.TableClear(self.teleportMap)
  for id, argData in pairs(self.quests) do
    self:initTeleportInfo(argData)
  end
  EventManager.Me():DispatchEvent(MyselfEvent.SceneGoToUserCmdHanded)
end
function FunctionQuestDisChecker:initTeleportInfo(argData)
  if not self:canTeleport(argData) then
    return
  end
  local quest = argData.questData
  local id = quest.id
  local targetPos = self:getDestPost(quest)
  local currentMapID = Game.MapManager:GetMapID()
  local tarMap = quest.map
  tarMap = tarMap or currentMapID
  if currentMapID == tarMap then
    if not targetPos then
      return
    end
    local innerTeleportInfo = WorldTeleport.CreateInnerTeleportInfo(Game.Myself:GetPosition(), targetPos)
    if nil == innerTeleportInfo then
    else
      local map = ReusableTable.CreateTable()
      map.inner = innerTeleportInfo
      self.teleportMap[id] = map
    end
  else
    local npcUID, npcMapID = WorldTeleport.GetTransitNPCInfo(currentMapID, tarMap)
    if nil ~= npcUID and nil ~= npcMapID then
      local pos = self:getDestPostByUniqueId(npcUID)
      if npcMapID ~= currentMapID then
        local outter, innerTeleportInfo = WorldTeleport.CreateOutterTeleportInfo(Game.Myself:GetPosition(), npcMapID, nil, pos)
        if nil == innerTeleportInfo then
        else
          local map = ReusableTable.CreateTable()
          map.inner = innerTeleportInfo
          self.teleportMap[id] = map
        end
        if outter then
          WorldTeleport.DestroyOutterTeleportInfo(outter)
        end
      else
        local innerTeleportInfo = WorldTeleport.CreateInnerTeleportInfo(Game.Myself:GetPosition(), pos)
        if nil == innerTeleportInfo then
        else
          local map = ReusableTable.CreateTable()
          map.inner = innerTeleportInfo
          self.teleportMap[id] = map
        end
      end
    else
      local outter, innerTeleportInfo = WorldTeleport.CreateOutterTeleportInfo(Game.Myself:GetPosition(), tarMap, nil, targetPos)
      if nil == innerTeleportInfo then
      else
        local map = ReusableTable.CreateTable()
        map.inner = innerTeleportInfo
        self.teleportMap[id] = map
      end
      if outter then
        WorldTeleport.DestroyOutterTeleportInfo(outter)
      end
    end
  end
end
local tempVector3 = LuaVector3.zero
local LuaVector2Up = LuaVector2.up
function FunctionQuestDisChecker:getDestPost(quest)
  local pos = quest.pos
  if pos then
    return pos
  end
  local tarMap = quest.map
  tarMap = tarMap or Game.MapManager:GetMapID()
  local currentMap = SceneProxy.Instance.currentScene
  if currentMap and currentMap:IsSameMapOrRaid(tarMap) then
    local uniqueid = quest.params.uniqueid
    pos = self:getDestPostByUniqueId(uniqueid)
    return pos
  end
end
function FunctionQuestDisChecker:getDestPostByUniqueId(uniqueid)
  if uniqueid then
    local npcPoint = Game.MapManager:FindNPCPoint(uniqueid)
    if npcPoint then
      local pos = npcPoint.position
      tempVector3:Set(pos[1], pos[2], pos[3])
      return tempVector3
    end
  end
end
function FunctionQuestDisChecker:getTargetPos(id)
  local temp = self.teleportMap[id]
  if not temp or not temp.inner then
    local innerTeleportInfo
  end
  if nil ~= innerTeleportInfo then
    local targetPos, epId
    if nil ~= innerTeleportInfo.ep then
      targetPos = innerTeleportInfo.ep.position
      epId = innerTeleportInfo.ep.ID
    else
      targetPos = innerTeleportInfo.targetPos
    end
    local argData = self.quests[id]
    if argData and argData.questData and self:checkNotInRaidCd(argData.questData) then
      return targetPos, epId
    end
  end
end
function FunctionQuestDisChecker:canTeleport(argData)
  local currentMapID = Game.MapManager:GetMapID()
  local tarMap = argData.questData.map
  tarMap = tarMap or currentMapID
  if tarMap == currentMapID then
    return true
  end
  local disableInnerTeleport = Table_Map[currentMapID].MapNavigation
  if nil ~= disableInnerTeleport and 0 ~= disableInnerTeleport then
    return false
  end
  local disableOutterTeleport = Table_Map[currentMapID].LeapsMapNavigation
  if nil ~= disableOutterTeleport and 0 ~= disableOutterTeleport then
    return false
  end
  if not Table_Map[tarMap] then
    return false
  end
  disableOutterTeleport = Table_Map[tarMap].LeapsMapNavigation
  if nil ~= disableOutterTeleport and 0 ~= disableOutterTeleport then
    return false
  end
  if nil == MapOutterTeleport[currentMapID] then
    return false
  end
  if nil == MapOutterTeleport[currentMapID][tarMap] then
    return false
  end
  return true
end
function FunctionQuestDisChecker:checkNotInRaidCd(questData)
  return true
end
function FunctionQuestDisChecker:adjustQuestDisAndRota(argData)
  local cell = argData.owner
  local quest = argData.questData
  local teleMap = self.teleportMap[quest.id]
  if not teleMap then
    self:initTeleportInfo(argData)
  end
  local callback = argData.callback
  local currentMap = SceneProxy.Instance.currentScene
  local tarMap = quest.map
  tarMap = tarMap or Game.MapManager:GetMapID()
  local teleData = ReusableTable.CreateTable()
  if currentMap and currentMap:IsSameMapOrRaid(tarMap) then
    local indicatorPos = self:getTargetPos(quest.id)
    local targetPos = self:getDestPost(quest)
    teleData.indicatorPos = indicatorPos
    if targetPos and self:checkNotInRaidCd(quest) then
      local currentDis = VectorUtility.DistanceXZ(Game.Myself:GetPosition(), targetPos)
      currentDis = math.floor(currentDis)
      teleData.distance = currentDis
    else
      local mapData = Table_Map[tarMap]
      if mapData then
        teleData.toMap = mapData.CallZh
      end
      teleData.distance = nil
    end
  else
    local mapData = Table_Map[tarMap]
    if mapData then
      teleData.toMap = mapData.CallZh
    end
  end
  if callback then
    callback(cell, teleData)
    ReusableTable.DestroyAndClearTable(teleData)
    teleData = nil
  end
end
function FunctionQuestDisChecker:getRotationByIconPosAndTarPos(iconObj, worldTarPos)
  if not GameObjectUtil.Instance:ObjectIsNULL(iconObj) and self.gmCm then
    LuaVector3.Better_Sub(worldTarPos, Game.Myself:GetPosition(), tempVector3)
    tempVector3:Set(LuaGameObject.InverseTransformVector(self.gmCm.transform, tempVector3))
    local float = LuaVector2.Angle(tempVector3, LuaVector2Up)
    if tempVector3.x > 0 then
      float = -float
    end
    return float
  end
end
