WorldMapMenuPopUp = class("WorldMapMenuPopUp", BaseView)
WorldMapMenuPopUp.ViewType = UIViewType.PopUpLayer
autoImport("WorldMapCell")
autoImport("MapInfoCell")
autoImport("MonsterHeadCell")
local tempArray = {}
function WorldMapMenuPopUp:Init()
  self:InitUI()
  self:AddListenEvt()
end
function WorldMapMenuPopUp:InitUI()
  self.title = self:FindComponent("Title", UILabel)
  local mapGrid = self:FindComponent("MapGrid", UIGrid)
  self.mapList = UIGridListCtrl.new(mapGrid, WorldMapCell, "WorldMapCell")
  self.mapList:AddEventListener(MouseEvent.MouseClick, self.ClickMapCell, self)
  local rightBord = self:FindGO("RightBord")
  self.menuScrollView = self:FindComponent("MenuScrollView", UIScrollView, rightBord)
  self.mapname = self:FindComponent("MapName", UILabel, rightBord)
  self.lvname = self:FindComponent("LvName", UILabel, rightBord)
  self.table = self:FindComponent("MenuInfoTable", UITable, rightBord)
  local infoGrid = self:FindComponent("InfoGrid", UIGrid, rightBord)
  self.infoCtl = UIGridListCtrl.new(infoGrid, MapInfoCell, "MapInfoCell")
  self.infoCtl:AddEventListener(MouseEvent.MouseClick, self.clickMapInfo, self)
  local monsterGrid = self:FindComponent("MonsterGrid", UIGrid, rightBord)
  self.monsterCtl = UIGridListCtrl.new(monsterGrid, MonsterHeadCell, "MonsterHeadCell")
  self.monsterCtl:AddEventListener(MouseEvent.MouseClick, self.clickMonsterCell, self)
  local qsGO = self:FindGO("QuestGrid", rightBord)
  self.questSymbolGrid = qsGO:GetComponent(UIGrid)
  self.questSymbol1 = self:FindGO("Symbol1", qsGO)
  self.questSymbol2 = self:FindGO("Symbol2", qsGO)
  self.questSymbol3 = self:FindGO("Symbol3", qsGO)
  self.sealSymbol = self:FindComponent("SealSymbol", UISprite)
  self.questSymbol = self:FindGO("QuestSymbol")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.goBtn = self:FindGO("GoBtn")
  self:AddClickEvent(self.goBtn, function(go)
    if self.chooseData == nil then
      return
    end
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByIDTable(2500)
      return
    end
    TableUtility.TableClear(tempArray)
    tempArray.targetMapID = self.chooseData.id
    local cmd = MissionCommandFactory.CreateCommand(tempArray, MissionCommandMove)
    if cmd then
      Game.Myself:Client_SetMissionCommand(cmd)
    end
    self:sendNotification(WorldMapEvent.StartTrace)
    self:CloseSelf()
  end)
  local contentBord = self:FindGO("ContentBord")
  self.closeComp = contentBord:GetComponent(CloseWhenClickOtherPlace)
  function self.closeComp.callBack(go)
    self:CloseSelf()
  end
end
function WorldMapMenuPopUp:ClickMapCell(cell)
  self:UpdateChooseData(cell.data)
  cell:SetChoose(self.chooseSymbol)
end
function WorldMapMenuPopUp:clickMapInfo(mapInfo)
  local data = mapInfo.data
  if not data then
    return
  end
  local cmd
  if data.type == MapInfoType.Npc then
    local cmdArgs = {
      targetMapID = self.chooseData.id,
      npcID = data.id,
      npcUID = data.uid
    }
    cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandVisitNpc)
  elseif data.type == MapInfoType.ExitPoint then
    local cmdArgs = {
      targetMapID = self.chooseData.id
    }
    cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
  end
  if cmd then
    Game.Myself:Client_SetMissionCommand(cmd)
    self:sendNotification(WorldMapEvent.StartTrace)
    self:CloseSelf()
  end
end
function WorldMapMenuPopUp:clickMonsterCell(monsterCell)
  local data = monsterCell.data
  if data then
    local oriMonster = Table_MonsterOrigin[data.id] or {}
    local oriPos
    for i = 1, #oriMonster do
      if oriMonster[i].mapID == self.chooseData.id then
        oriPos = oriMonster[i].pos
      end
    end
    local cmdArgs = {
      targetMapID = self.chooseData.id,
      npcID = data.id
    }
    if oriPos then
      cmdArgs.targetPos = TableUtil.Array2Vector3(oriPos)
    end
    local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
    if cmd then
      Game.Myself:Client_SetMissionCommand(cmd)
      self:sendNotification(WorldMapEvent.StartTrace)
      self:CloseSelf()
    end
  end
end
function WorldMapMenuPopUp:UpdateMapList(data)
  self.data = data
  if data == nil then
    return
  end
  self.chooseSymbol.transform:SetParent(nil)
  self.mapList:ResetDatas(data.childMaps)
  self.title.text = data.staticData.NameZh
end
function WorldMapMenuPopUp:UpdateChooseData(data)
  self.chooseData = data
  self.mapname.text = data.NameZh
  if data.LvRange and data.LvRange[2] then
    self.lvname.text = string.format(ZhString.WorldMapMenuCell_LvTip, data.LvRange[1], data.LvRange[2])
    self:Show(self.lvname)
    self.table.transform.localPosition = Vector3(7.4, 77.5, 0)
  else
    self:Hide(self.lvname)
    self.table.transform.localPosition = Vector3(7.4, 99.5, 0)
  end
  local nowScene = SceneProxy.Instance.currentScene
  local nowMapId = nowScene.mapID
  self.goBtn:SetActive(nowMapId ~= data.id)
  self:UpdateMapInfo()
  self:UpdateQuestSymbol()
  self:UpdateSealSymbol()
  self.table:Reposition()
  self.menuScrollView:DisableSpring()
  self.menuScrollView:ResetPosition()
end
function WorldMapMenuPopUp:UpdateQuestSymbol()
  local hasMain, hasBranch, hasDaily = false, false, false
  if self.chooseData then
    local list = QuestProxy.Instance:getQuestListByMapAndSymbol(self.chooseData.id) or {}
    for i = 1, #list do
      local quest = list[i]
      if quest.type == QuestDataType.QuestDataType_MAIN then
        hasMain = true
      elseif quest.type == QuestDataType.QuestDataType_DAILY then
        hasDaily = true
      else
        hasBranch = true
      end
      if not hasMain or not hasBranch or not hasDaily then
      end
    end
  end
  if hasMain == false or hasBranch == false or hasDaily == false then
    local questMapInfo = WorldMapProxy.Instance:GetWorldQuestInfo(self.chooseData.id)
    if questMapInfo then
      hasMain = questMapInfo[1] == true
      hasBranch = questMapInfo[2] == true
      hasDaily = questMapInfo[3] == true
    end
  end
  if hasDaily == false then
    hasDaily = self.hasDailyFunc == true
  end
  self.questSymbol1:SetActive(hasMain)
  self.questSymbol2:SetActive(hasBranch)
  self.questSymbol3:SetActive(hasDaily)
  self.questSymbolGrid:Reposition()
end
local CheckHasSealByMapId = function(mapid)
  local hasSeal, issealing
  local sealData = SealProxy.Instance:GetSealData(mapid)
  if sealData then
    for _, item in pairs(sealData.itemMap) do
      hasSeal = true
      if item.issealing then
        issealing = true
        break
      end
    end
  end
  return hasSeal, issealing
end
function WorldMapMenuPopUp:UpdateSealSymbol()
  local hasSeal, issealing = false, false
  if type(self.chooseData) ~= "table" then
    return
  end
  local mapid = self.chooseData and self.chooseData.id
  if mapid then
    hasSeal, issealing = CheckHasSealByMapId(mapid)
  end
  if hasSeal then
    self.sealSymbol.gameObject:SetActive(true)
    if issealing then
      self.sealSymbol.spriteName = "seal_icon_02"
    else
      self.sealSymbol.spriteName = "seal_icon_01"
    end
    self.questSymbolGrid:Reposition()
  else
    self.sealSymbol.gameObject:SetActive(false)
  end
end
local GetEventInfos = function(mapid)
  TableUtility.ArrayClear(tempArray)
  local events = FunctionActivity.Me():GetMapEvents(mapid)
  for i = 1, #events do
    if events[i].running then
      local mapInfo = events[i]:GetMapInfo()
      if mapInfo then
        local info = {
          type = MapInfoType.Event,
          id = events[i].id,
          icon = mapInfo.icon,
          label = mapInfo.label,
          iconScale = mapInfo.iconScale
        }
        table.insert(tempArray, info)
      end
    end
  end
  return tempArray
end
function WorldMapMenuPopUp:UpdateMapInfo()
  local id = self.chooseData.id
  if not id or not Table_MapInfo then
    return
  end
  local upInfos, monsters = {}, {}
  local eventInfos = GetEventInfos(id)
  if eventInfos then
    for i = 1, #eventInfos do
      table.insert(upInfos, eventInfos[i])
    end
  end
  local mapInfo = Table_MapInfo[id]
  if mapInfo then
    local units = mapInfo.units
    if units == nil then
      helplog("Mapid:" .. id .. " Not Find AreaData.")
      return
    end
    self.hasDailyFunc = false
    local monsterIDMap = {}
    for id, unit in pairs(units) do
      local idShadow = unit[1]
      local npcdata = id and Table_Npc[id]
      if npcdata then
        if not self.hasDailyFunc then
          self.hasDailyFunc = QuestSymbolCheck.HasDailySymbol(npcdata)
        end
        if npcdata.MapIcon ~= "" and npcdata.NoShowMapIcon ~= 1 then
          local isUnlock = true
          if npcdata.MenuId ~= nil then
            isUnlock = FunctionUnLockFunc.Me():CheckCanOpen(npcdata.MenuId)
          end
          if isUnlock then
            local temp = {
              id = id,
              uid = idShadow,
              type = MapInfoType.Npc,
              icon = npcdata.MapIcon,
              label = npcdata.NameZh
            }
            table.insert(upInfos, temp)
          end
        end
      else
        local monsterdata = id and Table_Monster[id]
        if monsterdata and monsterdata.Hide ~= 1 and monsterdata.WmapHide ~= 1 and not monsterIDMap[id] then
          monsterIDMap[id] = 1
          table.insert(monsters, monsterdata)
        end
      end
    end
    local exitPoints = mapInfo.exitPoints
    if exitPoints then
      for i = 1, #exitPoints do
        if exitPoints[i] ~= id then
          local mapdata = Table_Map[exitPoints[i]]
          if mapdata then
            local temp = {
              id = exitPoints[i],
              type = MapInfoType.ExitPoint,
              icon = "map_portal",
              label = mapdata.NameZh
            }
            table.insert(upInfos, temp)
          end
        end
      end
    end
  end
  self.infoCtl:ResetDatas(upInfos)
  self.monsterCtl:ResetDatas(monsters)
end
function WorldMapMenuPopUp:AddListenEvt()
end
function WorldMapMenuPopUp:OnEnter()
  WorldMapMenuPopUp.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  self:UpdateMapList(viewdata.data)
  local cells = self.mapList:GetCells()
  self:ClickMapCell(cells[1])
end
function WorldMapMenuPopUp:OnExit()
  WorldMapMenuPopUp.super.OnExit(self)
  self.mapList:ResetDatas(tempArray)
end
