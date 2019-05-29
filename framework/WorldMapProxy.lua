WorldMapProxy = class("WorldMapProxy", pm.Proxy)
WorldMapProxy.Instance = nil
WorldMapProxy.NAME = "WorldMapProxy"
autoImport("MapAreaData")
WorldMapCellSize = {x = 142, y = 142}
WorldMapOriPos = {73.6, -88}
WorldMapProxy.Size_X = 28
WorldMapProxy.Size_Y = 14
WorldMapProxy.Ori_X = 14
WorldMapProxy.Ori_Y = 7
function WorldMapProxy:ctor(proxyName, data)
  self.proxyName = proxyName or WorldMapProxy.NAME
  if WorldMapProxy.Instance == nil then
    WorldMapProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function WorldMapProxy:Init()
  self.worldQuestMap = {}
  self.tableMapDatas = {}
  self:InitMapDatas()
end
function WorldMapProxy:InitMapDatas()
  self.mapAreaDatas = {}
  for i = 1, self.Size_X do
    for j = 1, self.Size_Y do
      table.insert(self.mapAreaDatas, i * 10000 + j)
    end
  end
  local maxIndex = #self.mapAreaDatas
  local x, y, index
  for id, mapSData in pairs(Table_Map) do
    x = mapSData.Position[1]
    y = mapSData.Position[2]
    if x and y and id == mapSData.MapArea then
      x = x + self.Ori_X
      y = y + self.Ori_Y
      index = self.Size_X * (y - 1) + x
      if maxIndex >= index then
        self.mapAreaDatas[index] = MapAreaData.new(id, x, y)
      end
    end
  end
  self.deathTransferMapDatas = {}
  local mapID
  if Table_DeathTransferMap then
    for id, transferData in pairs(Table_DeathTransferMap) do
      mapID = transferData.MapID
      if not self.deathTransferMapDatas[mapID] then
        self.deathTransferMapDatas[mapID] = {}
      end
      self.deathTransferMapDatas[mapID][#self.deathTransferMapDatas[mapID] + 1] = transferData.Transfer
    end
  end
  self.activeMaps = {}
  self.activeDeathKingdomPoints = {}
end
function WorldMapProxy:GetMapAreaDatas()
  return self.mapAreaDatas
end
function WorldMapProxy:RecvGoToListUser(data)
  for i = 1, #data.mapid do
    self:AddActiveMap(data.mapid[i])
  end
end
function WorldMapProxy:AddActiveMap(mapID)
  if mapID == nil then
    return
  end
  self.activeMaps[mapID] = 1
end
function WorldMapProxy:RecvDeathTransferList(data)
  TableUtility.TableClear(self.activeDeathKingdomPoints)
  local npcIDs = data.npcId
  if npcIDs then
    for i = 1, #npcIDs do
      self.activeDeathKingdomPoints[npcIDs[i]] = 1
    end
  else
    helplog("npcIDs is null!")
  end
end
function WorldMapProxy:AddDeathTransferPoint(npcId)
  self.activeDeathKingdomPoints[npcId] = 1
end
function WorldMapProxy:GetMapAreaDataByMapId(mapid)
  local mapData = Table_Map[mapid]
  if mapData == nil then
    helplog(string.format("MapData Is Nil(id:%s)", mapid))
    return
  end
  local areaid = mapData.MapArea
  if areaid == nil then
    return
  end
  local areaSData = Table_Map[areaid]
  if areaSData == nil then
    return
  end
  local areaData, index = self:GetMapAreaDataByPos(areaSData.Position[1], areaSData.Position[2])
  if areaData ~= nil then
    return areaData, index
  end
  redlog("Not Find AreaData By Position.")
  for k, v in pairs(self.mapAreaDatas) do
    if type(v) == "table" and v.mapid == mapid then
      return v
    end
  end
end
function WorldMapProxy:GetMapAreaDataByPos(x, y)
  if x == nil or y == nil then
    return
  end
  x = x + self.Ori_X
  y = y + self.Ori_Y
  local index = self.Size_X * (y - 1) + x
  local d = self.mapAreaDatas[index]
  if type(d) == "number" then
    return
  end
  return d, index
end
function WorldMapProxy:ActiveMapAreaData(mapid, active, isNew)
  local areaData = self:GetMapAreaDataByMapId(mapid)
  if type(areaData) ~= "table" then
    return
  end
  if active == nil then
    active = true
  end
  areaData:SetActive(active)
  areaData:SetIsNew(isNew)
  FunctionGuide.Me():RemoveMapGuide(mapid)
end
function WorldMapProxy:SetWorldQuestInfo(server_quests)
  if server_quests == nil then
    return
  end
  TableUtility.TableClear(self.worldQuestMap)
  for i = 1, #server_quests do
    local server_quest = server_quests[i]
    if server_quest then
      local client_quest = self.worldQuestMap[server_quest.mapid]
      if client_quest == nil then
        client_quest = {}
        client_quest[1] = server_quest.type_main
        client_quest[2] = server_quest.type_branch
        client_quest[3] = server_quest.type_daily
        self.worldQuestMap[server_quest.mapid] = client_quest
      end
    end
  end
end
function WorldMapProxy:GetWorldQuestInfo(mapid)
  return self.worldQuestMap[mapid]
end
