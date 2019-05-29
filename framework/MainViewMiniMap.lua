MainViewMiniMap = class("MainViewMiniMap", SubView)
autoImport("WrapCellHelper")
autoImport("MiniMapWindow")
autoImport("NearlyCreatureCell")
autoImport("MiniMapData")
autoImport("MiniMapGuideAnim")
local MapManager = Game.MapManager
local miniMapDataDeleteFunc = function(data)
  data:Destroy()
end
function MainViewMiniMap:Init()
  self:InitData()
  self:InitUI()
  self:MapEvent()
end
local _NSceneNpcProxy, _TableClearByDeleter, _TableClear, _SuperGvgProxy, _TeamProxy
function MainViewMiniMap:InitData()
  _NSceneNpcProxy = NSceneNpcProxy.Instance
  _TableClearByDeleter = TableUtility.TableClearByDeleter
  _TableClear = TableUtility.TableClear
  _SuperGvgProxy = SuperGvgProxy.Instance
  _TeamProxy = TeamProxy.Instance
  self.questShowDatas = {}
  self.nearlyPlayers = {}
  self.npcRoles = {}
  self.monsterDataMap = {}
  self.teamMemberMapDatas = {}
  self.spotDatas = {}
  self.sealDatasMap = {}
  self.treeMapDatasMap = {}
  self.focusMap = {}
  self.playerMap = {}
  self.showNpcs = {}
  self.gvgDroiyanMap = {}
  self.poringFightDropMap = {}
  self.UseButterflyButtonInfo = {}
  self.UseFlyButtonInfo = {}
  self.teamPwsMapInfo = {}
end
local tempArgs = {}
local tempV3 = LuaVector3()
function MainViewMiniMap:InitUI()
  self.mapBord = self:FindGO("MapBord")
  self.container:RegisterChildPopObj(self.mapBord)
  self:InitBigMap()
  self.miniMapButton = self:FindGO("MiniMapButton")
  self:AddOrRemoveGuideId(self.miniMapButton, 107)
  self:AddClickEvent(self.miniMapButton, function(go)
    self:ActiveMapBord(not self.mapBord.activeInHierarchy)
  end)
  local miniMapWindowGO = self:FindGO("MiniMapWindow")
  self.minimapWindow = MiniMapWindow.new(miniMapWindowGO)
  self.mPanel = self:FindComponent("MiniMapScrollView", UIPanel)
  self.minimapWindow:ActiveFocusArrowUpdate(true)
  self.minimapWindow:SetUpdateEvent(self.CenterMiniMapWindow, self)
  local nearlyBord = self:FindGO("NearlyBord", self.mapBord)
  if nearlyBord then
    GameObject.Destroy(nearlyBord)
  end
  self.nearlyBord = self:LoadPreferb_ByFullPath("GUI/v1/part/NearlyBord", self.mapBord)
  self.nearlyPlayerTipStick = self:FindComponent("NearlyPlayerTipStick", UIWidget, self.nearlyBord)
  self.gvgFinalFightTip = self:FindGO("GvgFinalFightTip")
  local nearly_playerTog = self:FindGO("PlayerTog", self.nearlyBord)
  self.playerTog = nearly_playerTog:GetComponent(UIToggle)
  self:AddClickEvent(nearly_playerTog, function(go)
    self:UpdateNearlyCreature(1, true)
  end)
  local nearly_npcTog = self:FindGO("NPCTog", self.nearlyBord)
  self.npcTog = nearly_npcTog:GetComponent(UIToggle)
  self:AddClickEvent(nearly_npcTog, function(go)
    self:UpdateNearlyCreature(2, true)
  end)
  local nearly_mapTog = self:FindGO("MapTog", self.nearlyBord)
  if nearly_mapTog then
    self.mapTog = nearly_mapTog:GetComponent(UIToggle)
    self:AddClickEvent(nearly_mapTog, function(go)
      self:UpdateNearlyCreature(3, true)
    end)
  end
  local nearlyButton = self:FindGO("NearlyButton")
  self.nearlyButton_Symbol = self:FindComponent("Arrow", UISprite)
  self:AddClickEvent(nearlyButton, function(go)
    if Game.MapManager:IsPVPMode_PoringFight() then
      MsgManager.ShowMsgByIDTable(3606)
      return
    end
    if Game.MapManager:IsGvgMode_Droiyan() then
      self:ActiveGvgFinalFightTip(not self.gvgFinalFightTip.activeSelf)
      return
    end
    if not self.nearlyBord.activeSelf then
      self:ActiveNearlyBord(true)
    else
      self:ActiveNearlyBord(false)
    end
  end)
  local nearlyGrid = self:FindGO("NearlyGrid", self.nearlyBord)
  local wrapConfig = {
    wrapObj = nearlyGrid,
    cellName = "NearlyCreatureCell",
    control = NearlyCreatureCell,
    dir = 1
  }
  self.nearlyCreaturesCtl = WrapCellHelper.new(wrapConfig)
  self.nearlyCreaturesCtl:AddEventListener(MouseEvent.MouseClick, self.ClickNearlyCell, self)
  self.noPlayerTip = self:FindGO("PlayerNoneTip", self.nearlyBord)
  self.bubbleStick = self:FindComponent("BubbleStick", UIWidget)
  local closeMapGO = self:FindGO("CloseMap")
  self:AddClickEvent(closeMapGO, function()
    self:ActiveMapBord(false)
  end)
end
local IsNull = Slua.IsNull
local InverseTransformPointByTransform = LuaGameObject.InverseTransformPointByTransform
local GetLocalPosition = LuaGameObject.GetLocalPosition
local GetPosition = LuaGameObject.GetPosition
local S_World = Space.World
function MainViewMiniMap:CenterMiniMapWindow(window)
  if IsNull(window.mapTexture) then
    return
  end
  local mMap = window.mapTexture.transform
  tempV3[1], tempV3[2], tempV3[3] = InverseTransformPointByTransform(window.gameObject.transform, window.myTrans, S_World)
  local x, y, z = GetLocalPosition(mMap)
  tempV3[1], tempV3[2], tempV3[3] = x - tempV3[1], y - tempV3[2], z - tempV3[3]
  mMap.transform.localPosition = tempV3
  tempV3[1], tempV3[2], tempV3[3] = GetPosition(window.s_symbolParent)
  window.d_symbolParent.position = tempV3
end
function MainViewMiniMap:ClickNearlyCell(cellCtl)
  local id = cellCtl.id
  local creatureType = cellCtl.creatureType
  if cellCtl.isExitPoint then
    local p = cellCtl.pos
    local currentMapID = Game.MapManager:GetMapID()
    local disableInnerTeleport = Table_Map[currentMapID].MapNavigation
    if nil ~= disableInnerTeleport and 0 ~= disableInnerTeleport then
      MsgManager.ShowMsgByIDTable(50)
    else
      tempArgs.targetMapID = currentMapID
      tempArgs.targetPos = p
      tempArgs.showClickGround = true
      tempArgs.allowExitPoint = true
      local x, y, z = p[1], p[2], p[3]
      function tempArgs.callback(cmd, event)
        if MissionCommandMove.CallbackEvent.TeleportFailed == event then
          tempV3:Set(x, y, z)
          Game.Myself:Client_MoveTo(tempV3)
        end
      end
      local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove)
      if cmd then
        Game.Myself:Client_SetMissionCommand(cmd)
      end
      _TableClear(tempArgs)
      break
    end
    return
  end
  if creatureType == Creature_Type.Player then
    local creature = SceneCreatureProxy.FindCreature(id)
    if creature then
      local playerData = PlayerTipData.new()
      playerData:SetByCreature(creature)
      if creature ~= self.lastCreature then
        local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.nearlyPlayerTipStick, NGUIUtil.AnchorSide.Right, {-356, 0})
        local tipData = {playerData = playerData}
        tipData.funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(id)
        table.insert(tipData.funckeys, "Booth")
        playerTip:SetData(tipData)
        function playerTip.closecallback(go)
          self.lastCreature = nil
        end
        playerTip:AddIgnoreBound(cellCtl.gameObject)
        self.lastCreature = creature
      else
        FunctionPlayerTip.Me():CloseTip()
        self.lastCreature = nil
      end
    end
  elseif creatureType == Creature_Type.Npc then
    local pos = cellCtl.pos
    self.minimapWindow:SetTipPos(pos)
    self.bigmapWindow:SetTipPos(pos)
    local npcid, uniqueid = cellCtl.npcid, cellCtl.uniqueid
    tempArgs.targetMapID = MapManager:GetMapID()
    tempArgs.npcID = npcid
    tempArgs.npcUID = uniqueid
    local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandVisitNpc)
    Game.Myself:Client_SetMissionCommand(cmd)
    _TableClear(tempArgs)
  end
end
function MainViewMiniMap:InitBigMap()
  self.mapName = self:FindComponent("MapName", UILabel, self.mapBord)
  self.bigmapWindow = MiniMapWindow.new(self:FindGO("BigMapWindow"))
  self.bigmapWindow:AddMapClick()
  self.bigmapWindow:ActiveFocusArrowUpdate(false)
  self:AddButtonEvent("ReturnHome", function(go)
    MsgManager.ConfirmMsgByID(7, function()
      ServiceNUserProxy.Instance:ReturnToHomeCity()
    end, nil)
  end)
  self.bigMapButton = self:FindGO("BigMapButton")
  self.bigMapLab = self:FindComponent("Label", UILabel, self.bigMapButton)
  self.bigMapLab.depth = 8
  OverseaHostHelper:FixLabelOverV1(self.bigMapLab, 3, 120)
  self:AddClickEvent(self.bigMapButton, function(go)
    if self.bigmapWindow.lock then
      return
    end
    local inRaid = MapManager:IsRaidMode()
    if inRaid then
      if MapManager:IsPVPMode_TeamPws() then
        MsgManager.ShowMsgByIDTable(25923)
        return
      end
      MsgManager.ConfirmMsgByID(7, function()
        ServiceNUserProxy.Instance:ReturnToHomeCity()
      end, nil)
    else
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.WorldMapView,
        viewdata = {}
      })
    end
    self:ActiveMapBord(false)
  end)
  self.frontMapInfo = self:FindGO("MapFrontInfo")
  self.enlargeSprite = self:FindComponent("EnLargeButton", UISprite, self.frontMapInfo)
  self:AddClickEvent(self.enlargeSprite.gameObject, function(go)
    self:EnLargeBigMap(not self.bigmaplarge)
  end)
  local activeComp = self.mapBord:GetComponent(RelateGameObjectActive)
  function activeComp.enable_Call()
    self:EnLargeBigMap(false)
  end
  self.moreBord = self:FindGO("MoreBord")
  self.container:RegisterChildPopObj(self.moreBord)
  local moreBtn = self:FindGO("MoreButton")
  local DoujinshiNode = self:FindGO("DoujinshiNode")
  self:AddClickEvent(moreBtn, function()
    if self.bigmapWindow.active and not self:ActiveMapBord(false) then
      return
    end
    self.moreBord:SetActive(not self.moreBord.activeSelf)
    if self.moreBord.activeSelf then
      DoujinshiNode.gameObject:SetActive(false)
    end
  end)
  self.UseButterflyButtonInfo.itemID = 50001
  self.UseButterflyButtonInfo.msgID = 25440
  self.UseButterflyButtonInfo.msgDoNotHaveID = 25444
  self.UseButterflyButtonInfo.base = self:FindComponent("UseButterflyWingsButton", UISprite, self.frontMapInfo)
  self.UseButterflyButtonInfo.icon = self:FindComponent("Icon", UISprite, self.UseButterflyButtonInfo.base.gameObject)
  IconManager:SetItemIcon("item_" .. self.UseButterflyButtonInfo.itemID, self.UseButterflyButtonInfo.icon)
  self:AddClickEvent(self.UseButterflyButtonInfo.base.gameObject, function(go)
    self:TryUseButterflyOrFly(self.UseButterflyButtonInfo)
  end)
  self.UseButterflyButtonInfo.base.gameObject:SetActive(GameConfig.MapIconShow.mapicon_butterfly_open ~= 0)
  self.UseFlyButtonInfo.itemID = 5024
  self.UseFlyButtonInfo.msgID = 25439
  self.UseFlyButtonInfo.msgDoNotHaveID = 25444
  self.UseFlyButtonInfo.base = self:FindComponent("UseFlyWingsButton", UISprite, self.frontMapInfo)
  self.UseFlyButtonInfo.icon = self:FindComponent("Icon", UISprite, self.UseFlyButtonInfo.base.gameObject)
  IconManager:SetItemIcon("item_" .. self.UseFlyButtonInfo.itemID, self.UseFlyButtonInfo.icon)
  self:AddClickEvent(self.UseFlyButtonInfo.base.gameObject, function(go)
    self:TryUseButterflyOrFly(self.UseFlyButtonInfo)
  end)
  self.UseFlyButtonInfo.base.gameObject:SetActive(GameConfig.MapIconShow.mapicon_fly_open ~= 0)
  self:RefreshButterflyAndFlyButtons()
end
function MainViewMiniMap:ActiveMapBord(b)
  if self.bigmapWindow.lock then
    return false
  end
  if b then
    self.mapBord:SetActive(true)
    self.bigmapWindow:Show()
    self.bigmapWindow:UpdateQuestNpcSymbol(self.questShowDatas, true)
    self.bigmapWindow:ResetMapPos()
    self:UpdateNearlyMonsters()
    if Game.MapManager:IsGvgMode_Droiyan() then
      self:ActiveGvgFinalFightTip(true)
    end
    self:ActiveNearlyBord(false)
    self:RefreshButterflyAndFlyButtons()
  else
    self.mapBord:SetActive(false)
    self.bigmapWindow:Hide()
    self:ActiveNearlyBord(false)
    if Game.MapManager:IsGvgMode_Droiyan() then
      self:ActiveGvgFinalFightTip(false)
    end
    self:ShutDownGuideAnim()
  end
  return true
end
function MainViewMiniMap:EnLargeBigMap(b, notCenterMyPos)
  if self.bigmapWindow.lock then
    return
  end
  if b then
    self.bigmaplarge = true
    self.bigmapWindow:SetMapScale(2.3)
    if notCenterMyPos == nil or notCenterMyPos == false then
      self.bigmapWindow:CenterOnMyPos(true)
    end
    self.bigmapWindow:EnableDrag(true)
    self.enlargeSprite.spriteName = "com_btn_narrow"
    self.bigmapWindow:ActiveNearlyMonsters(false)
  else
    self.bigmaplarge = false
    self.bigmapWindow:SetMapScale(1)
    self.bigmapWindow:ResetMapPos()
    self.bigmapWindow:EnableDrag(false)
    self.enlargeSprite.spriteName = "com_btn_enlarge"
    self.bigmapWindow:ActiveNearlyMonsters(true)
  end
end
function MainViewMiniMap:ActiveGvgFinalFightTip(isShow)
  self.gvgFinalFightTip:SetActive(isShow)
  if isShow then
    if not self.gvgFinalFightTipCtl then
      self.gvgFinalFightTipCtl = GvgFinalFightTip.new(self.gvgFinalFightTip)
    end
    self.gvgFinalFightTipCtl:OnShow()
  elseif self.gvgFinalFightTipCtl then
    self.gvgFinalFightTipCtl:OnHide()
  end
  self.nearlyButton_Symbol.flip = self.gvgFinalFightTip.activeSelf and 0 or 1
end
function MainViewMiniMap:OnShow()
  self:UpdateMyMapPos()
end
function MainViewMiniMap:OnEnter()
  MainViewMiniMap.super.OnEnter(self)
  self.minimapWindow:Show()
  self:ActiveMapBord(false)
  if Game.MapManager:IsPVPMode_PoringFight() then
    self:ShowPoringFightMapItems()
  end
  self:ActiveCheckMonstersPoses(true)
end
function MainViewMiniMap:OnExit()
  self.minimapWindow:Hide()
  self:ActiveCheckMonstersPoses(false)
  self:ClearPoringFightMapItems()
  MainViewMiniMap.super.OnExit(self)
end
function MainViewMiniMap:ActiveNearlyBord(b)
  if self.nearlyBord.activeSelf == b then
    return
  end
  self.nearlyButton_Symbol.flip = self.nearlyBord.activeSelf and 0 or 1
  if b then
    self.nearlyBord:SetActive(true)
    self.nowNearlyTog = 1
    self:UpdateNearlyCreature(1, true)
  else
    self.nearlyBord:SetActive(false)
  end
  self.minimapWindow:ShowOrHideExitInfo(false)
  self.bigmapWindow:ShowOrHideExitInfo(false)
end
function MainViewMiniMap:UpdateNearlyCreature(tog, forceUpdate)
  local needUpdateList = true
  if not forceUpdate and not self.nearlyBord.activeSelf then
    needUpdateList = not self.nearlyBord.activeSelf
  end
  if not needUpdateList then
    return
  end
  self.nearlyCreaturesCtl:ResetPosition()
  self.minimapWindow:ShowOrHideExitInfo(false)
  self.bigmapWindow:ShowOrHideExitInfo(false)
  if tog == 1 then
    self.playerTog.value = true
    _TableClearByDeleter(self.nearlyPlayers, miniMapDataDeleteFunc)
    local allRole = NSceneUserProxy.Instance.userMap
    for _, role in pairs(allRole) do
      local playerMapData = MiniMapData.CreateAsTable(role.data.id)
      playerMapData:SetParama("creatureType", Creature_Type.Player)
      playerMapData:SetParama("name", role.data.name)
      local profession = role.data.userdata:Get(UDEnum.PROFESSION)
      playerMapData:SetParama("Profession", profession)
      local gender = role.data.userdata:Get(UDEnum.SEX)
      playerMapData:SetParama("gender", gender)
      local level = role.data.userdata:Get(UDEnum.ROLELEVEL)
      playerMapData:SetParama("level", level)
      table.insert(self.nearlyPlayers, playerMapData)
    end
    self.nearlyCreaturesCtl:ResetDatas(self.nearlyPlayers)
    self.noPlayerTip:SetActive(#self.nearlyPlayers == 0)
  elseif tog == 2 then
    self.npcTog.value = true
    _TableClearByDeleter(self.npcRoles, miniMapDataDeleteFunc)
    local npcRolesMap = {}
    local npcList = MapManager:GetNPCPointArray()
    if npcList then
      for i = 1, #npcList do
        local point = npcList[i]
        local npcData = Table_Npc[point.ID]
        if npcData and npcData.MapIcon ~= "" and npcData.NoShowMapIcon ~= 1 then
          local isUnlock = true
          if npcData.MenuId ~= nil then
            isUnlock = FunctionUnLockFunc.Me():CheckCanOpen(npcData.MenuId)
          end
          if isUnlock then
            local combineId = QuestDataStepType.QuestDataStepType_VISIT .. point.ID .. point.uniqueID
            local npcMapData = npcRolesMap[combineId]
            if npcMapData == nil then
              npcMapData = MiniMapData.CreateAsTable(combineId)
            end
            npcMapData:SetParama("creatureType", Creature_Type.Npc)
            npcMapData:SetParama("npcid", npcData.id)
            npcMapData:SetParama("uniqueid", point.uniqueID)
            npcMapData:SetParama("name", npcData.NameZh)
            npcMapData:SetParama("icon", npcData.MapIcon)
            npcMapData:SetParama("PositionTip", npcData.Position)
            npcMapData:SetPos(point.position[1], point.position[2], point.position[3])
            npcRolesMap[combineId] = npcMapData
            table.insert(self.npcRoles, npcMapData)
          end
        end
      end
    end
    table.sort(self.npcRoles, function(qa, qb)
      return qa:GetParama("npcid") < qb:GetParama("npcid")
    end)
    self.nearlyCreaturesCtl:ResetDatas(self.npcRoles)
    self.noPlayerTip:SetActive(false)
  elseif tog == 3 then
    self.mapTog.value = true
    if self.exitPoints == nil then
      self.exitPoints = {}
    else
      _TableClearByDeleter(self.exitPoints, miniMapDataDeleteFunc)
    end
    local exitPointArray = MapManager:GetExitPointArray()
    if exitPointArray then
      for i = 1, #exitPointArray do
        local edata = exitPointArray[i]
        if edata and edata.nextSceneID and edata.nextSceneID ~= 0 then
          local data = MiniMapData.CreateAsTable(exitPointArray[i].ID)
          data:SetParama("isExitPoint", true)
          data:SetParama("nextSceneID", edata.nextSceneID)
          data:SetParama("index", i)
          data:SetPos(edata.position[1], edata.position[2], edata.position[3])
          table.insert(self.exitPoints, data)
        end
      end
    end
    self.nearlyCreaturesCtl:ResetDatas(self.exitPoints)
    self.minimapWindow:ShowOrHideExitInfo(true)
    self.bigmapWindow:ShowOrHideExitInfo(true)
    self.noPlayerTip:SetActive(false)
  end
  self.nowNearlyTog = tog
end
function MainViewMiniMap:ActiveCheckMonstersPoses(open)
  if open then
    TimeTickManager.Me():CreateTick(0, 1000, self.UpdateNearlyMonsters, self, 1)
  else
    TimeTickManager.Me():ClearTick(self, 1)
  end
end
function MainViewMiniMap:UpdateNearlyMonsters()
  if not self.minimapWindow:IsActive() then
    return
  end
  local isMvpFight = MapManager:IsPVPMode_MvpFight()
  local monsterIdMap = FunctionMonster.Me():FilterMonster(isMvpFight)
  _TableClearByDeleter(self.monsterDataMap, miniMapDataDeleteFunc)
  local rolelv = MyselfProxy.Instance:RoleLevel()
  local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
  local isRaid = MapManager:IsRaidMode() or curImageId > 0
  for _, monsterId in pairs(monsterIdMap) do
    local monster = _NSceneNpcProxy:Find(monsterId)
    if monster and monster.data and RoleDefines_Camp.ENEMY == monster.data:GetCamp() then
      local pos = monster:GetPosition()
      if pos then
        local monsterMapData = MiniMapData.CreateAsTable(monster.id)
        monsterMapData:SetPos(pos[1], pos[2], pos[3])
        local sdata = monster.data.staticData
        local symbolName, depth
        local bdata = Table_Boss[sdata.id]
        if monster:GetBossType() == 3 then
          if isMvpFight then
            monsterMapData:SetParama("monster_icon", sdata.Icon)
          end
          symbolName = "ui_mvp_dead11_JM"
          depth = 2
        elseif sdata.Type == "MVP" then
          if isMvpFight then
            monsterMapData:SetParama("monster_icon", sdata.Icon)
          end
          symbolName = "map_mvpboss"
          depth = 3
        elseif sdata.Type == "MINI" then
          if isMvpFight then
            monsterMapData:SetParama("monster_icon", sdata.Icon)
          end
          symbolName = "map_miniboss"
          depth = 2
        else
          if isRaid then
            symbolName = "map_dot"
          else
            local search = monster.data.search or 0
            local searchrange = monster.data.searchrange or 0
            if search > 0 or searchrange > 0 then
              local mdata = monster.data.staticData
              if mdata.PassiveLv and rolelv >= mdata.PassiveLv then
                symbolName = "map_dot"
              else
                symbolName = "map_green"
              end
            else
              symbolName = "map_green"
            end
          end
          depth = 1
        end
        monsterMapData:SetParama("Symbol", symbolName)
        monsterMapData:SetParama("depth", depth)
        table.insert(self.monsterDataMap, monsterMapData)
      end
    end
  end
  if self.minimapWindow:IsActive() then
    self.minimapWindow:UpdateMonstersPoses(self.monsterDataMap, true)
  end
  if self.bigmapWindow:IsActive() then
    self.bigmapWindow:UpdateMonstersPoses(self.monsterDataMap, true)
  end
end
function MainViewMiniMap:GetMapNpcPointByNpcId(npcid)
  local npcList = MapManager:GetNPCPointArray()
  if npcList then
    for i = 1, #npcList do
      local npcPoint = npcList[i]
      if npcPoint and npcPoint.ID == npcid then
        return npcPoint
      end
    end
  end
end
function MainViewMiniMap:UpdateQuestMapSymbol()
  local nowMapId = MapManager:GetMapID()
  local questlst = QuestProxy.Instance:getQuestListByMapAndSymbol(nowMapId)
  _TableClearByDeleter(self.questShowDatas, miniMapDataDeleteFunc)
  for _, q in pairs(questlst) do
    local params = q.staticData and q.staticData.Params
    if params.ShowSymbol ~= 2 and params.ShowSymbol ~= 3 then
      local symbolType = QuestSymbolCheck.GetQuestSymbolByQuest(q)
      if symbolType then
        local combineId, npcPoint
        local uniqueid, npcid = params.uniqueid, params.npc
        if type(npcid) == "table" then
          npcid = npcid[1] or npcid
        end
        if uniqueid then
          npcPoint = MapManager:FindNPCPoint(uniqueid)
        elseif npcid then
          npcPoint = self:GetMapNpcPointByNpcId(npcid)
          uniqueid = npcPoint and npcPoint.uniqueID or 0
        else
          combineId = q.questDataStepType .. q.id
        end
        if nil == combineId then
          if npcid == nil and uniqueid == nil then
            errorLog("Not Find Npc (questId:%s)", q.id)
          end
          combineId = QuestDataStepType.QuestDataStepType_VISIT .. tostring(npcid) .. tostring(uniqueid)
        end
        local miniMapData = self.questShowDatas[combineId]
        if not miniMapData then
          local pos = params.pos
          if not pos and npcPoint then
            pos = npcPoint.position
          end
          if pos then
            miniMapData = self.questShowDatas[combineId]
            if miniMapData == nil then
              miniMapData = MiniMapData.CreateAsTable(combineId)
            end
            miniMapData:SetPos(pos[1], pos[2], pos[3])
            miniMapData:SetParama("questId", q.id)
            miniMapData:SetParama("npcid", npcid)
            miniMapData:SetParama("uniqueid", uniqueid)
            miniMapData:SetParama("SymbolType", symbolType)
            miniMapData:SetParama("combineId", combineId)
            self.questShowDatas[combineId] = miniMapData
          end
        else
          local cacheSymbolType = miniMapData:GetParama("SymbolType")
          if symbolType < cacheSymbolType then
            miniMapData:SetParama("SymbolType", symbolType)
          end
        end
      end
    end
  end
  local npcList = MapManager:GetNPCPointArray()
  if npcList then
    for i = 1, #npcList do
      local npcPoint = npcList[i]
      local npcid, uniqueid = npcPoint.ID, npcPoint.uniqueID
      local combineId = QuestDataStepType.QuestDataStepType_VISIT .. npcPoint.ID .. npcPoint.uniqueID
      local miniMapData = self.questShowDatas[combineId]
      if not miniMapData then
        local npcSData = Table_Npc[npcid]
        if QuestSymbolCheck.HasDailySymbol(npcSData) then
          miniMapData = self.questShowDatas[combineId]
          if miniMapData == nil then
            miniMapData = MiniMapData.CreateAsTable(combineId)
            self.questShowDatas[combineId] = miniMapData
          end
          local pos = npcPoint.position
          miniMapData:SetPos(pos[1], pos[2], pos[3])
          miniMapData:SetParama("npcid", npcid)
          miniMapData:SetParama("uniqueid", uniqueid)
          miniMapData:SetParama("SymbolType", QuestSymbolType.Daily)
        end
      end
    end
  end
  self.minimapWindow:UpdateQuestNpcSymbol(self.questShowDatas, true)
  self.bigmapWindow:UpdateQuestNpcSymbol(self.questShowDatas, true)
  self:UpdateNpcPointState()
end
function MainViewMiniMap:UpdateNpcPointState()
  local config = GameConfig.NpcMapIconShowCondition
  if config then
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    for npcid, config in pairs(config) do
      local isNowMap = config.mapid == nil or config.mapid == MapManager:GetMapID()
      local islvReach = config.level == nil or mylv >= config.level
      local isCompelete = QuestProxy.Instance:isQuestComplete(config.questId)
      self.minimapWindow:UpdateNpcPointState(npcid, isNowMap and (islvReach or isCompelete))
      self.bigmapWindow:UpdateNpcPointState(npcid, isNowMap and (islvReach or isCompelete))
    end
  end
end
function MainViewMiniMap:UpdateTeamMembersPos(refreshSymbol)
  local nowMapid = MapManager:GetMapID()
  local restirct = Table_MapRaid[nowMapid] and Table_MapRaid[nowMapid].Restrict
  if restirct and restirct == 1 then
    self:ClearTeamMemberPos()
    return
  end
  if _TeamProxy:IHaveTeam() then
    local myTeam = _TeamProxy.myTeam
    local memberMap = myTeam:GetMemberMap()
    for id, member in pairs(memberMap) do
      self:UpdateTeamMemberPos(member.id, refreshSymbol)
    end
    for id, data in pairs(self.teamMemberMapDatas) do
      if not myTeam:GetMemberByGuid(id) then
        self:RemoveTeamMemberPos(id)
      end
    end
  else
    self:ClearTeamMemberPos()
  end
end
local BuffToBallMap
local Init_BuffToBallMap = function()
  if BuffToBallMap ~= nil then
    return
  end
  BuffToBallMap = {}
  local _PvpTeamRaid = GameConfig.PvpTeamRaid
  for raidId, config in pairs(_PvpTeamRaid) do
    BuffToBallMap[raidId] = {}
    local npcsID = config.ElementNpcsID
    for k, v in pairs(npcsID) do
      BuffToBallMap[raidId][v.buffid] = v
    end
  end
end
local Func_GetTeamPwsBallSymbol = function(creature)
  if not MapManager:IsPVPMode_TeamPws() then
    return
  end
  local buffs = creature.buffs
  if buffs == nil then
    return
  end
  Init_BuffToBallMap()
  local nowRaid = Game.MapManager:GetRaidID()
  local map = BuffToBallMap[nowRaid] or next(BuffToBallMap)
  for buffid, _ in pairs(buffs) do
    if map[buffid] then
      return map[buffid].mapicon
    end
  end
end
local Player_Symbol_Name_Map = {
  [1] = "map_red",
  [2] = "map_blue",
  [3] = "map_yellow"
}
local GvgDroiyan_Player_Symbol_Name_Map = {
  [1] = "map_red",
  [2] = "map_blue",
  [3] = "map_purple",
  [4] = "map_green"
}
function MainViewMiniMap:UpdateTeamMemberPos(id, refreshSymbol)
  if not id or Game.Myself and id == Game.Myself.data.id then
    return
  end
  if _TeamProxy:IHaveTeam() then
    local myTeam = _TeamProxy.myTeam
    local memData = myTeam:GetMemberByGuid(id)
    local nowMapid = MapManager:GetMapID()
    if not memData or memData.mapid ~= nowMapid and memData.raid ~= nowMapid or memData.offline == 1 or MyselfProxy.Instance:GetZoneId() ~= memData.zoneid then
      self:RemoveTeamMemberPos(id)
      return
    end
    if Game.DungeonManager:IsInGuildArea() and GuildProxy.Instance:IHaveGuild() and GuildProxy.Instance.myGuildData.guid ~= memData.guildid then
      self:RemoveTeamMemberPos(id)
      return
    end
    local symbolMap = MapManager:IsGvgMode_Droiyan() and _EmptyTable or Player_Symbol_Name_Map
    local miniMapData = self.teamMemberMapDatas[id]
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable(id)
      self.teamMemberMapDatas[id] = miniMapData
      refreshSymbol = true
    end
    local isTeamPws = MapManager:IsPVPMode_TeamPws()
    if isTeamPws then
      refreshSymbol = true
    end
    if refreshSymbol then
      local tag = Game.Myself.data.userdata:Get(UDEnum.PVP_COLOR)
      if tag ~= nil and symbolMap[tag] then
        miniMapData:SetParama("Symbol", symbolMap[tag])
      else
        miniMapData:SetParama("Symbol", "map_teammate")
      end
      if isTeamPws then
        local playerPwsSymbol
        local player = NSceneUserProxy.Instance:Find(id)
        if player then
          playerPwsSymbol = Func_GetTeamPwsBallSymbol(player)
          if playerPwsSymbol then
            miniMapData:SetParama("Symbol", playerPwsSymbol)
          end
        end
      end
    end
    local pos = memData.pos
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    local k, v = next(self.teamMemberMapDatas)
    self.minimapWindow:UpdateTeamMemberSymbol(self.teamMemberMapDatas)
    self.bigmapWindow:UpdateTeamMemberSymbol(self.teamMemberMapDatas)
  end
end
function MainViewMiniMap:RemoveTeamMemberPos(id)
  if not id then
    return
  end
  local miniMapData = self.teamMemberMapDatas[id]
  if miniMapData then
    miniMapData:Destroy()
  end
  self.teamMemberMapDatas[id] = nil
  self.minimapWindow:RemoveTeamMemberSymbol(id)
  self.bigmapWindow:RemoveTeamMemberSymbol(id)
end
function MainViewMiniMap:ClearTeamMemberPos()
  for id, teamMemberData in pairs(self.teamMemberMapDatas) do
    self.minimapWindow:RemoveTeamMemberSymbol(id)
    self.bigmapWindow:RemoveTeamMemberSymbol(id)
  end
  _TableClear(self.teamMemberMapDatas, miniMapDataDeleteFunc)
end
local lastMapId, cache_servershowNpcMap
function MainViewMiniMap:UpdateMapAllInfo(map2d)
  self.mapInited = true
  map2d = map2d or Game.Map2DManager:GetMap2D()
  local nowMapId = MapManager:GetMapID()
  local mapIdChanged = false
  if nowMapId ~= lastMapId then
    lastMapId = nowMapId
    mapIdChanged = true
  end
  self.mapdata = Table_Map[nowMapId]
  self.mapName.text = self.mapdata.NameZh
  if MapManager:IsRaidMode() then
    self.bigMapLab.text = ZhString.MainViewMiniMap_ReturnHome
  else
    self.bigMapLab.text = ZhString.MainViewMiniMap_WorldMap
  end
  self.minimapWindow:Reset()
  self.bigmapWindow:Reset()
  if map2d then
    tempV3:Set(375, 375, 0)
    self.bigmapWindow:UpdateMapTexture(self.mapdata, tempV3, map2d)
    if self.mapdata.MapScale then
      local maxline = math.max(map2d.size.x, map2d.size.y)
      maxline = maxline * (150 / self.mapdata.MapScale)
      tempV3:Set(maxline, maxline, 0)
      self.minimapWindow:UpdateMapTexture(self.mapdata, tempV3, map2d)
    end
    self:UpdateQuestMapSymbol()
    self:UpdateMapSealPoint()
    self:RefreshScenicSpots()
    self:UpdateTeamMembersPos(true)
    self:UpdateGvgDroiyanInfos()
    self:UpdateTeamPwsMapInfo()
    self.bigmapWindow:UpdateQuestFocuses(self.focusMap)
    self.minimapWindow:UpdateQuestFocuses(self.focusMap)
    if mapIdChanged then
      _TableClear(self.showNpcs, miniMapDataDeleteFunc)
      if cache_servershowNpcMap ~= nil then
        for k, v in pairs(cache_servershowNpcMap) do
          self.showNpcs[k] = v
          cache_servershowNpcMap[k] = nil
        end
        cache_servershowNpcMap = nil
      end
    end
    self.minimapWindow:UpdateServerNpcPointMap(self.showNpcs, true)
    self.bigmapWindow:UpdateServerNpcPointMap(self.showNpcs, true)
  end
  self:ActiveNearlyBord(false)
end
function MainViewMiniMap:MapEvent()
  self:AddListenEvt(MyselfEvent.TargetPositionChange, self.HandleUpdateDestPos)
  self:AddListenEvt(MyselfEvent.PlaceTo, self.UpdateMyMapPos)
  self:AddListenEvt(ServiceEvent.SceneGoToUserCmd, self.UpdateMyMapPos)
  self:AddListenEvt(GuideEvent.ShowBubble, self.HandleMiniMapGuide)
  self:AddListenEvt(GuideEvent.MiniMapAnim, self.HandleMiniMapGuideAnim)
  self:AddListenEvt(MiniMapEvent.ExitPointStateChange, self.HandleChangeExitPointState)
  self:AddListenEvt(MiniMapEvent.ExitPointReInit, self.HandleExitPointReInit)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberPosUpdate, self.HandleTeamMemberPosUpdate)
  self:AddListenEvt(TeamEvent.MemberChangeMap, self.HandleTeamMemberUpdate)
  self:AddListenEvt(TeamEvent.MemberOffline, self.HandleTeamMemberUpdate)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.HandleTeamMemberUpdate)
  self:AddListenEvt(ServiceEvent.BossCmdBossPosUserCmd, self.HanldBossPosUpdate)
  self:AddListenEvt(FunctionScenicSpot.Event.StateChanged, self.UpdateScenicSpotSymbol)
  self:AddListenEvt(AdventureDataEvent.SceneItemsUpdate, self.HandleScenicSpotUpdate)
  self:AddListenEvt(SceneGlobalEvent.Map2DChanged, self.HandleUpdateMap2d)
  self:AddListenEvt(ServiceEvent.SceneSealUpdateSeal, self.UpdateMapSealPoint)
  self:AddListenEvt(ServiceEvent.SceneSealQuerySeal, self.UpdateMapSealPoint)
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.HandleQuesUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.HandleQuesUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.HandleQuesUpdate)
  self:AddListenEvt(SystemUnLockEvent.NUserNewMenu, self.HandleQuesUpdate)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleQuesUpdate)
  self:AddListenEvt(QuestEvent.RemoveGuildQuestList, self.HandleQuesUpdate)
  self:AddListenEvt(MainViewEvent.AddQuestFocus, self.HandleAddQuestFocus)
  self:AddListenEvt(MainViewEvent.RemoveQuestFocus, self.HandleRemoveQuestFocus)
  self:AddListenEvt(MiniMapEvent.ShowMiniMapDirEffect, self.HandlePlayQuestDirEffect)
  self:AddListenEvt(ServiceEvent.NUserNtfVisibleNpcUserCmd, self.HandleShowNpcPos)
  self:AddListenEvt(SceneUserEvent.SceneAddRoles, self.HandleAddRoles)
  self:AddListenEvt(SceneUserEvent.SceneRemoveRoles, self.HandleRemoveRoles)
  self:AddListenEvt(ServiceEvent.NUserTreeListUserCmd, self.HandleTreeListUpdate)
  self:AddListenEvt(ServiceEvent.NUserBCatActivityStartUserCmd, self.HandleUpdateBCatPos)
  self:AddListenEvt(ServiceEvent.ActivityCmdBCatUFOPosActCmd, self.HandleUpdateBCatPos)
  self:AddListenEvt(MiniMapEvent.CreatureScenicChange, self.HandleCreatureScenicChange)
  self:AddListenEvt(MiniMapEvent.CreatureScenicAdd, self.HandleCreatureScenicAdd)
  self:AddListenEvt(MiniMapEvent.CreatureScenicRemove, self.HandleCreatureScenicRemove)
  self:AddListenEvt(GuideEvent.MapGuide_Change, self.HandleMapGuide_Change)
  self:AddDispatcherEvt(CreatureEvent.Player_CampChange, self.HandlePlayerCampChange)
  self:AddDispatcherEvt(CreatureEvent.Hiding_Change, self.HandlePlayerHidingChange)
  self:AddDispatcherEvt(PlayerEvent.DeathStatusChange, self.HandlePlayerStatusChange)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgMetalDieFubenCmd, self.UpdateGvgDroiyanInfos)
  self:AddListenEvt(ServiceEvent.FuBenCmdSuperGvgSyncFubenCmd, self.UpdateGvgDroiyanInfos)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, self.UpdateGvgDroiyanInfos)
  self:AddListenEvt(GVGEvent.GVG_FinalFightLaunch, self.UpdateGvgDroiyanInfos)
  self:AddListenEvt(GVGEvent.GVG_FinalFightShutDown, self.ClearGvgDroiyanInfos)
  self:AddListenEvt(PVPEvent.PVP_PoringFightLaunch, self.ShowPoringFightMapItems)
  self:AddListenEvt(PVPEvent.PVP_PoringFightShutdown, self.ClearPoringFightMapItems)
  self:AddListenEvt(ServiceEvent.MapAddMapItem, self.HandleAddMapItem)
  self:AddListenEvt(ServiceEvent.MapPickupItem, self.HandelPickupItem)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.RefreshButterflyAndFlyButtons)
  self:AddListenEvt(HotKeyEvent.OpenMap, self.HandleOpenMap)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.UpdateTeamPwsMapInfo)
  self:AddListenEvt(PVPEvent.TeamPws_ShutDown, self.ClearAllTeamPwsMapInfo)
  self:AddListenEvt(PVPEvent.TeamPws_PlayerBuffBallChange, self.HandleTeamPwsBallChange)
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpcs)
end
function MainViewMiniMap:HandleUpdateMap2d(note)
  self:UpdateMapAllInfo(note.body)
end
function MainViewMiniMap:HandleAddRoles(note)
  if self.nowNearlyTog == 1 then
    self:UpdateNearlyCreature(1)
  end
  local players = note.body
  if players then
    for _, player in pairs(players) do
      self:_UpdatePlayerSymbolData(player)
    end
  end
  self:UpdatePlayerSymbolsPos()
end
function MainViewMiniMap:ClearPlayerMap()
  _TableClearByDeleter(self.playerMap, miniMapDataDeleteFunc)
  self.minimapWindow:UpdatePlayerPoses(self.playerMap, true)
  self.bigmapWindow:UpdatePlayerPoses(self.playerMap, true)
end
function MainViewMiniMap:HandleRemoveRoles(note)
  if self.nowNearlyTog == 1 then
    self:UpdateNearlyCreature(1)
  end
  local playerids = note.body
  if playerids then
    for _, playerid in pairs(playerids) do
      local miniMapData = self.playerMap[playerid]
      if miniMapData then
        miniMapData:Destroy()
      end
      self.playerMap[playerid] = nil
    end
  end
  self:UpdatePlayerSymbolsPos()
end
function MainViewMiniMap:HandleUpdateDestPos(note)
  local destPos = note.body
  self.bigmapWindow:UpdateDestPos(destPos)
  self.minimapWindow:UpdateDestPos(destPos)
end
function MainViewMiniMap:UpdateMyMapPos(note)
  self.bigmapWindow:UpdateMyPos(true)
  self.minimapWindow:UpdateMyPos(true)
end
function MainViewMiniMap:ShutDownGuideAnim()
  if self.miniMapGuideAnim then
    self.miniMapGuideAnim:ShutDown()
    self.miniMapGuideAnim = nil
  end
end
function MainViewMiniMap:HandleMiniMapGuideAnim(note)
  if note.body then
    if not self.mapBord.activeInHierarchy then
      self:ActiveMapBord(true)
    end
    self:ShutDownGuideAnim()
    local questData, bubbleId = note.body.questData, note.body.bubbleId
    self.miniMapGuideAnim = MiniMapGuideAnim.new(self.bigmapWindow)
    self.enlargeSprite.spriteName = "com_btn_narrow"
    self.miniMapGuideAnim:Launch(questData, bubbleId, self.bubbleStick)
    self.miniMapGuideAnim:SetEndCall(MainViewMiniMap._MiniMapAnimEndCall, self)
    self.miniMapGuideAnim:SetShutDownCall(MainViewMiniMap._MiniMapAnimShutDownCall, self)
  end
end
function MainViewMiniMap:_MiniMapAnimEndCall(miniMapGuideAnim)
  if not miniMapGuideAnim then
    return
  end
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(miniMapGuideAnim.questId)
  if questData then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
  end
end
function MainViewMiniMap:_MiniMapAnimShutDownCall(miniMapGuideAnim)
  if not miniMapGuideAnim then
    return
  end
  self:EnLargeBigMap(true, true)
  if not miniMapGuideAnim.isEnd then
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(miniMapGuideAnim.questId)
    if questData then
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
    end
  end
  self.miniMapGuideAnim = nil
end
function MainViewMiniMap:HandleMiniMapGuide(note)
  local bubbleid = note.body
  if not self.bubbleStick then
  end
  if bubbleid == BubbleID.MapBubbleID then
    self:ActiveMapBord(true)
    tempV3:Set(-236.8, -365)
    self.bubbleStick.transform.localPosition = tempV3
    TipManager.Instance:ShowBubbleTipById(bubbleid, self.bubbleStick, NGUIUtil.AnchorSide.Center, {50, 10})
  elseif bubbleid == BubbleID.MapQuestId or bubbleid == BubbleID.MapQuestGuideId1 or bubbleid == BubbleID.MapQuestGuideId2 then
    tempV3:Set(-236.8, -365)
    self.bubbleStick.transform.localPosition = tempV3
    TipManager.Instance:ShowBubbleTipById(bubbleid, self.bubbleStick, NGUIUtil.AnchorSide.Center, {50, 10})
  end
end
function MainViewMiniMap:HandleQuesUpdate(note)
  self:UpdateQuestMapSymbol()
end
function MainViewMiniMap:HandleChangeExitPointState(note)
  local id = note.body.id
  local state = note.body.state
  self.minimapWindow:UpdateExitPointMapState(id, state)
  self.bigmapWindow:UpdateExitPointMapState(id, state)
end
function MainViewMiniMap:HandleExitPointReInit(note)
  self.minimapWindow:UpdateExitPoints()
  self.bigmapWindow:UpdateExitPoints()
end
function MainViewMiniMap:HandleTeamMemberUpdate(note)
  local nowMapid = MapManager:GetMapID()
  local restirct = Table_MapRaid[nowMapid] and Table_MapRaid[nowMapid].Restrict
  if restirct and restirct == 1 then
    return
  end
  local member = note.body
  if member then
    self:UpdateTeamMemberPos(member.id, true)
    self:HandlePlayerHidingChange(member.id)
  end
end
function MainViewMiniMap:HandleTeamMemberPosUpdate(note)
  local id = note.body.id
  self:UpdateTeamMemberPos(id)
end
function MainViewMiniMap:HanldBossPosUpdate(note)
  local pos = note.body
  if pos then
    local x, y, z = pos.z or pos.x or 0, pos.y or 0, 0
    pos = Vector3(x, y, z)
    self.minimapWindow:UpdateBossSymbol(pos)
    self.bigmapWindow:UpdateBossSymbol(pos)
  end
end
function MainViewMiniMap:HandleShowNpcPos(note)
  local showNpcs = note.body
  local data = note.body
  if data then
    local cacheMap
    if self.mapInited then
      cacheMap = self.showNpcs
    else
      cache_servershowNpcMap = {}
      cacheMap = cache_servershowNpcMap
    end
    local showNpcs, type = data.npcs, data.type
    if type == 1 then
      local npc, scenePos
      for i = 1, #showNpcs do
        npc = showNpcs[i]
        local npcData = Table_Npc[npc.npcid]
        if npcData and npcData.MapIcon then
          local createNpcID = "Server_ShowNpc_" .. npc.npcid .. "_" .. tostring(npc.uniqueid)
          local miniMapData = cacheMap[createNpcID]
          if miniMapData == nil then
            miniMapData = MiniMapData.CreateAsTable(createNpcID)
            cacheMap[createNpcID] = miniMapData
            scenePos = npc.pos
            miniMapData:SetPos(scenePos.x / 1000, scenePos.y / 1000, scenePos.z / 1000)
            miniMapData:SetParama("Symbol", npcData.MapIcon)
          end
        end
      end
      self.minimapWindow:UpdateServerNpcPointMap(cacheMap, false)
      self.bigmapWindow:UpdateServerNpcPointMap(cacheMap, false)
    elseif type == 0 then
      for i = 1, #showNpcs do
        local createNpcID = "Server_ShowNpc_" .. showNpcs[i].npcid .. "_" .. tostring(showNpcs[i].uniqueid)
        local miniMapData = cacheMap[createNpcID]
        if miniMapData then
          miniMapData:Destroy()
          cacheMap[createNpcID] = nil
          self.minimapWindow:RemoveServerNpcPointMap(createNpcID)
          self.bigmapWindow:RemoveServerNpcPointMap(createNpcID)
        end
      end
    end
  end
end
function MainViewMiniMap:RefreshScenicSpots()
  self:UpdateSceneSpots(FunctionScenicSpot.Me():GetAllScenicSpot())
end
function MainViewMiniMap:UpdateSceneSpots(validScenicSpots)
  _TableClearByDeleter(self.spotDatas, miniMapDataDeleteFunc)
  if MapManager:IsPVPMode_TeamPws() or validScenicSpots == nil then
    self.minimapWindow:UpdateScenicSpotSymbol(self.spotDatas)
    self.bigmapWindow:UpdateScenicSpotSymbol(self.spotDatas)
    return
  end
  for k, v in pairs(validScenicSpots) do
    if v.ID then
      self:_UpdateSceneSpot(v)
    else
      for i = 1, #v do
        if v[i].ID then
          self:_UpdateSceneSpot(v[i])
        end
      end
    end
  end
  self.minimapWindow:UpdateScenicSpotSymbol(self.spotDatas)
  self.bigmapWindow:UpdateScenicSpotSymbol(self.spotDatas)
end
function MainViewMiniMap:_UpdateSceneSpot(scenicSpot, forceUpdate)
  if MapManager:IsPVPMode_TeamPws() then
    return
  end
  local isDiaplay, mapStr = AdventureDataProxy.Instance:IsSceneryHasTakePic(scenicSpot.ID)
  if isDiaplay then
    mapStr = "map_Lookout"
  else
    mapStr = "map_Lookout_lock"
  end
  local spotConfig = Table_Viewspot[scenicSpot.ID]
  if spotConfig and (spotConfig.Type == 1 or spotConfig.Type == 3) then
    local p = scenicSpot.position
    if p ~= nil then
      local guid = scenicSpot.ID
      if scenicSpot.guid then
        guid = scenicSpot.ID .. "_" .. scenicSpot.guid
      end
      local spotData = self.spotDatas[guid]
      if spotData == nil then
        spotData = MiniMapData.CreateAsTable(guid)
        self.spotDatas[guid] = spotData
      end
      spotData:SetPos(p[1], p[2], p[3])
      spotData:SetParama("Symbol", mapStr)
    end
  end
  if forceUpdate then
    self.minimapWindow:UpdateScenicSpotSymbol(self.spotDatas)
    self.bigmapWindow:UpdateScenicSpotSymbol(self.spotDatas)
  end
end
function MainViewMiniMap:_RemoveSceneSpot(scenicSpot, forceUpdate)
  local ID, guid = scenicSpot.ID, scenicSpot.guid
  guid = guid and ID .. "_" .. guid
  local spotData = self.spotDatas[guid]
  if spotData ~= nil then
    spotData:Destroy()
  end
  self.spotDatas[guid] = nil
  if forceUpdate then
    self.minimapWindow:UpdateScenicSpotSymbol(self.spotDatas)
    self.bigmapWindow:UpdateScenicSpotSymbol(self.spotDatas)
  end
end
function MainViewMiniMap:HandleCreatureScenicChange(note)
  local spotDatas = note.body
  if spotDatas then
    for i = 1, #spotDatas do
      self:_UpdateSceneSpot(spotDatas[i])
    end
    self.minimapWindow:UpdateScenicSpotSymbol(self.spotDatas)
    self.bigmapWindow:UpdateScenicSpotSymbol(self.spotDatas)
  end
end
function MainViewMiniMap:HandleCreatureScenicAdd(note)
  local sceneSpots = note.body
  for i = 1, #sceneSpots do
    self:_UpdateSceneSpot(sceneSpots[i])
  end
  self.minimapWindow:UpdateScenicSpotSymbol(self.spotDatas)
  self.bigmapWindow:UpdateScenicSpotSymbol(self.spotDatas)
end
function MainViewMiniMap:HandleCreatureScenicRemove(note)
  self:_RemoveSceneSpot(note.body, true)
end
function MainViewMiniMap:UpdateScenicSpotSymbol(note)
  self:UpdateSceneSpots(note.body.validScenicSpots)
end
function MainViewMiniMap:HandleScenicSpotUpdate(note)
  local updateSceneIds = note.body
  for i = 1, #updateSceneIds do
    local id = updateSceneIds[i]
    if id and self.spotDatas[id] then
      self.spotDatas[id]:SetParama("Symbol", "map_Lookout")
    end
  end
  self.minimapWindow:UpdateScenicSpotSymbol(self.spotDatas)
  self.bigmapWindow:UpdateScenicSpotSymbol(self.spotDatas)
end
function MainViewMiniMap:UpdateMapSealPoint()
  local nowMapId = MapManager:GetMapID()
  local data = SealProxy.Instance:GetSealData(nowMapId)
  if data then
    if not self.sealDatasMap then
      self.sealDatasMap = {}
    else
      _TableClearByDeleter(self.sealDatasMap, miniMapDataDeleteFunc)
    end
    for k, v in pairs(data.itemMap) do
      local symbol = v.issealing and "map_whirlpool2" or "map_whirlpool"
      local sealMapData = self.sealDatasMap[k]
      if sealMapData == nil then
        sealMapData = MiniMapData.CreateAsTable(k)
        self.sealDatasMap[k] = sealMapData
      end
      sealMapData:SetPos(v.pos[1], v.pos[2], v.pos[3])
      sealMapData:SetParama("Symbol", symbol)
    end
    self.minimapWindow:UpdateSealSymbol(self.sealDatasMap, true)
    self.bigmapWindow:UpdateSealSymbol(self.sealDatasMap, true)
  end
end
function MainViewMiniMap:HandleTreeListUpdate(note)
  local treePoints = note.body.updates
  local dels = note.body.dels
  if treePoints ~= nil then
    if not self.treeMapDatasMap then
      self.treeMapDatasMap = {}
    else
      _TableClearByDeleter(self.treeMapDatasMap, miniMapDataDeleteFunc)
    end
    for i = 1, #treePoints do
      local single = treePoints[i]
      local treeMapData = self.treeMapDatasMap[single.id]
      if treeMapData == nil then
        treeMapData = MiniMapData.CreateAsTable(single.id)
        self.treeMapDatasMap[single.id] = treeMapData
      end
      treeMapData:SetPos(single.pos.x / 1000, single.pos.y / 1000, single.pos.z / 1000)
      treeMapData:SetParama("Symbol", "map_plant")
    end
    self.bigmapWindow:UpdateTreePoints(self.treeMapDatasMap, false)
    self.minimapWindow:UpdateTreePoints(self.treeMapDatasMap, false)
  end
  if dels ~= nil then
    for i = 1, #dels do
      self.bigmapWindow:RemoveTreePoint(dels[i])
      self.minimapWindow:RemoveTreePoint(dels[i])
    end
  end
end
function MainViewMiniMap:HandleUpdateBCatPos(note)
  local bigCatActivityData = FunctionActivity.Me():GetActivityData(ACTIVITYTYPE.EACTIVITYTYPE_BCAT)
  local mapId = bigCatActivityData and bigCatActivityData.mapid
  local serverPos = note.body.pos
  if serverPos and MapManager:GetMapID() == mapId then
    tempV3:Set(serverPos.x / 1000, serverPos.y / 1000, serverPos.z / 1000)
    self.bigmapWindow:UpdateBigCatSymbol(tempV3)
    self.minimapWindow:UpdateBigCatSymbol(tempV3)
  else
    self.bigmapWindow:UpdateBigCatSymbol()
    self.minimapWindow:UpdateBigCatSymbol()
  end
end
function MainViewMiniMap:HandleAddQuestFocus(note)
  if not self.focusMap then
    self.focusMap = {}
  end
  local questId, pos = note.body[1], note.body[2]
  local focusData = self.focusMap[questId]
  if not focusData then
    focusData = MiniMapData.CreateAsTable(questId)
    focusData:SetParama("questId", questId)
    self.focusMap[questId] = focusData
  end
  focusData:SetPos(pos[1], pos[2], pos[3])
  self.bigmapWindow:UpdateQuestFocuses(self.focusMap)
  self.minimapWindow:UpdateQuestFocuses(self.focusMap)
end
function MainViewMiniMap:HandleRemoveQuestFocus(note)
  local questId = note.body
  if questId and self.focusMap then
    local focusData = self.focusMap[questId]
    if focusData then
      focusData:Destroy()
    end
    self.focusMap[questId] = nil
    self.bigmapWindow:RemoveQuestFocusByQuestId(questId)
    self.minimapWindow:RemoveQuestFocusByQuestId(questId)
  end
end
function MainViewMiniMap:HandlePlayQuestDirEffect(note)
  local questId = note.body
  if questId then
    self.minimapWindow:PlayFocusFrameEffect(questId)
  end
end
function MainViewMiniMap:HandlePlayerCampChange(player)
  if player then
    self:_UpdatePlayerSymbolData(player)
    self:UpdatePlayerSymbolsPos()
  end
end
function MainViewMiniMap:HandlePlayerHidingChange(playerid)
  local player = NSceneUserProxy.Instance:Find(playerid)
  if player then
    self:_UpdatePlayerSymbolData(player)
    self:UpdatePlayerSymbolsPos()
  end
end
function MainViewMiniMap:HandlePlayerStatusChange(note)
  local player = note.body
  if player then
    self:_UpdatePlayerSymbolData(player)
    self:UpdatePlayerSymbolsPos()
    self:UpdateTeamMemberPos(player.data.id, true)
  end
end
function MainViewMiniMap:_GetScenePlayerSymbolName(player)
  local playerid = player.data.id
  local playerSymbolName
  if player ~= Game.Myself and not _TeamProxy:IsInMyTeam(playerid) then
    local tag = player.data.userdata:Get(UDEnum.PVP_COLOR)
    local symbolMap = MapManager:IsGvgMode_Droiyan() and GvgDroiyan_Player_Symbol_Name_Map or Player_Symbol_Name_Map
    if Game.MapManager:IsPVPMode_PoringFight() then
      playerSymbolName = "map_green"
    elseif tag ~= nil and symbolMap[tag] then
      local myTeam = _TeamProxy.myTeam
      if myTeam == nil or myTeam:GetMemberByGuid(player.data.id) == nil then
        playerSymbolName = symbolMap[tag]
      end
    else
      local camp = player.data:GetCamp()
      if camp == RoleDefines_Camp.ENEMY then
        playerSymbolName = "map_dot"
      end
    end
  end
  local pwsSymbol = Func_GetTeamPwsBallSymbol(player)
  if pwsSymbol then
    playerSymbolName = pwsSymbol
  end
  local hideValue = player.data.props.Hiding:GetValue()
  if hideValue > 0 then
    playerSymbolName = nil
  end
  return playerSymbolName
end
function MainViewMiniMap:_UpdatePlayerSymbolData(player)
  if player == nil then
    return
  end
  if _TeamProxy:IsInMyTeam(player.data.id) then
    return
  end
  local playerid = player.data.id
  local playerSymbolName = self:_GetScenePlayerSymbolName(player)
  local miniMapData = self.playerMap[playerid]
  if playerSymbolName ~= nil then
    if miniMapData == nil then
      miniMapData = MiniMapData.CreateAsTable(playerid)
      self.playerMap[playerid] = miniMapData
    end
    local pos = player:GetPosition()
    if pos then
      miniMapData:SetPos(pos[1], pos[2], pos[3])
    end
    miniMapData:SetParama("Symbol", playerSymbolName)
    miniMapData:SetParama("depth", 4)
  elseif miniMapData ~= nil then
    miniMapData:Destroy()
    self.playerMap[playerid] = nil
  end
end
function MainViewMiniMap:UpdatePlayerSymbolsPos()
  local hasPlayer = false
  for playerid, miniMapData in pairs(self.playerMap) do
    local player = NSceneUserProxy.Instance:Find(playerid)
    if player ~= nil then
      local pos = player:GetPosition()
      if pos then
        miniMapData:SetPos(pos[1], pos[2], pos[3])
      end
    else
      local miniMapData = self.playerMap[playerid]
      self.playerMap[playerid] = nil
      if miniMapData then
        miniMapData:Destroy()
      end
    end
    hasPlayer = true
  end
  self.minimapWindow:UpdatePlayerPoses(self.playerMap, true)
  self.bigmapWindow:UpdatePlayerPoses(self.playerMap, true)
  if hasPlayer == true then
    if self.playerPosCheck == nil then
      self.playerPosCheck = TimeTickManager.Me():CreateTick(0, 1000, self.UpdatePlayerSymbolsPos, self, 2)
    end
  elseif self.playerPosCheck then
    TimeTickManager.Me():ClearTick(self, 2)
    self.playerPosCheck = nil
  end
end
function MainViewMiniMap:HandleMapGuide_Change(note)
  FunctionGuide.Me():AttachGuideEffect(self.bigMapButton, Guild_RemoveType.Click)
  FunctionGuide.Me():AttachGuideEffect(self.miniMapButton, Guild_RemoveType.Time | Guild_RemoveType.Click)
end
local GameConfig_GvgDroiyan = GameConfig.GvgDroiyan
local RobPlatformId_Prefix = "RobPlatform_"
local BornGorgeousMetalId_Prefix = "BornGorgeousMetal_"
local GvgDroiyan_SymbolMap = {
  [0] = "gvg_bg_gray",
  [1] = "gvg_bg_red",
  [2] = "gvg_bg_blue",
  [3] = "gvg_bg_purple",
  [4] = "gvg_bg_green"
}
function MainViewMiniMap:UpdateGvgDroiyanInfos(note)
  if not Game.MapManager:IsGvgMode_Droiyan() then
    self:ClearGvgDroiyanInfos()
    return
  end
  _TableClearByDeleter(self.gvgDroiyanMap, miniMapDataDeleteFunc)
  local robPlatform = GameConfig_GvgDroiyan and GameConfig_GvgDroiyan.RobPlatform
  for index, v in pairs(robPlatform) do
    local pos = v.pos
    local map_guid = RobPlatformId_Prefix .. index
    local miniMapData = MiniMapData.CreateAsTable(map_guid)
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", GvgDroiyan_SymbolMap[0])
    self.gvgDroiyanMap[map_guid] = miniMapData
  end
  local towersMap = _SuperGvgProxy:GetTowersMap() or _EmptyTable
  for k, clientGvgTowerData in pairs(towersMap) do
    local index = _SuperGvgProxy:GetIndexByGuildId(clientGvgTowerData.owner_guild)
    if index and index ~= 0 then
      local map_guid = RobPlatformId_Prefix .. tostring(clientGvgTowerData.etype)
      local miniMapData = self.gvgDroiyanMap[map_guid]
      if miniMapData ~= nil then
        miniMapData:SetParama("Symbol", GvgDroiyan_SymbolMap[index])
      end
    end
  end
  local bornGorgeousMetal = GameConfig_GvgDroiyan and GameConfig_GvgDroiyan.BornGorgeousMetal
  for index, v in pairs(bornGorgeousMetal) do
    local pos = v.pos
    local map_guid = BornGorgeousMetalId_Prefix .. index
    local miniMapData = MiniMapData.CreateAsTable(map_guid)
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", GvgDroiyan_SymbolMap[index])
    self.gvgDroiyanMap[map_guid] = miniMapData
  end
  local guildsMap = _SuperGvgProxy:GetGuildsMap()
  for k, clientGvgGuildInfo in pairs(guildsMap) do
    local map_guid = BornGorgeousMetalId_Prefix .. clientGvgGuildInfo.index
    local miniMapData = self.gvgDroiyanMap[map_guid]
    if miniMapData ~= nil then
      miniMapData:SetParama("metal_live", clientGvgGuildInfo.metal_live and 1 or 0)
    end
  end
  self.minimapWindow:UpdateGvgDroiyanInfos(self.gvgDroiyanMap, true)
  self.bigmapWindow:UpdateGvgDroiyanInfos(self.gvgDroiyanMap, true)
end
function MainViewMiniMap:ClearGvgDroiyanInfos()
  _TableClearByDeleter(self.gvgDroiyanMap, miniMapDataDeleteFunc)
  self.minimapWindow:UpdateGvgDroiyanInfos(self.gvgDroiyanMap, true)
  self.bigmapWindow:UpdateGvgDroiyanInfos(self.gvgDroiyanMap, true)
  self:ActiveGvgFinalFightTip(false)
end
function MainViewMiniMap:ShowPoringFightMapItems()
  _TableClearByDeleter(self.poringFightDropMap, miniMapDataDeleteFunc)
  if SceneItemProxy.Instance ~= nil then
    for id, data in pairs(SceneItemProxy.Instance.userMap) do
      if data.staticData.id == 157 then
        local miniMapData = MiniMapData.CreateAsTable(id)
        local pos = data.pos
        miniMapData:SetPos(pos.x, pos.y, pos.z)
        miniMapData:SetParama("Symbol", "map_apple")
        self.poringFightDropMap[id] = miniMapData
      end
    end
  end
  self.minimapWindow:UpdatePoringFightMapItems(self.poringFightDropMap, true)
  self.bigmapWindow:UpdatePoringFightMapItems(self.poringFightDropMap, true)
end
function MainViewMiniMap:ClearPoringFightMapItems()
  _TableClearByDeleter(self.poringFightDropMap, miniMapDataDeleteFunc)
  self.minimapWindow:UpdatePoringFightMapItems(self.poringFightDropMap, true)
  self.bigmapWindow:UpdatePoringFightMapItems(self.poringFightDropMap, true)
end
function MainViewMiniMap:HandleAddMapItem(note)
  if not Game.MapManager:IsPVPMode_PoringFight() or not SceneItemProxy.Instance then
    return
  end
  local items = note.body and note.body.items
  if not items then
    return
  end
  for i = 1, #items do
    local item = SceneItemProxy.Instance.userMap[items[i].guid]
    if item and item.staticData.id == 157 and not self.poringFightDropMap[item.id] then
      local miniMapData = MiniMapData.CreateAsTable(item.id)
      local pos = item.pos
      miniMapData:SetPos(pos.x, pos.y, pos.z)
      miniMapData:SetParama("Symbol", "map_apple")
      self.poringFightDropMap[item.id] = miniMapData
    end
  end
  self.minimapWindow:UpdatePoringFightMapItems(self.poringFightDropMap, true)
  self.bigmapWindow:UpdatePoringFightMapItems(self.poringFightDropMap, true)
end
function MainViewMiniMap:HandelPickupItem(note)
  if not Game.MapManager:IsPVPMode_PoringFight() or not SceneItemProxy.Instance then
    return
  end
  local id = note.body and note.body.itemguid
  if self.poringFightDropMap[id] then
    self.poringFightDropMap[id]:Destroy()
    self.poringFightDropMap[id] = nil
    self.minimapWindow:UpdatePoringFightMapItems(self.poringFightDropMap, true)
    self.bigmapWindow:UpdatePoringFightMapItems(self.poringFightDropMap, true)
  end
end
function MainViewMiniMap:RefreshButterflyAndFlyButtons()
  self:RefreshButtonStatus(self.UseButterflyButtonInfo)
  self:RefreshButtonStatus(self.UseFlyButtonInfo)
end
function MainViewMiniMap:RefreshButtonStatus(go)
  local item = BagProxy.Instance:GetItemByStaticID(go.itemID, BagProxy.BagType.MainBag)
  if nil == item then
    item = BagProxy.Instance:GetItemByStaticID(go.itemID, BagProxy.BagType.Temp)
  end
  if nil == item then
    self:SetTextureGrey(go.base)
    self:SetTextureGrey(go.icon)
  else
    self:SetTextureWhite(go.base)
    self:SetTextureWhite(go.icon)
  end
end
function MainViewMiniMap:TryUseButterflyOrFly(go)
  local item = BagProxy.Instance:GetItemByStaticID(go.itemID, BagProxy.BagType.MainBag)
  if nil == item then
    item = BagProxy.Instance:GetItemByStaticID(go.itemID, BagProxy.BagType.Temp)
  end
  if nil ~= item then
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(go.msgID)
    if nil == dont then
      MsgManager.DontAgainConfirmMsgByID(go.msgID, function()
        FunctionItemFunc.TryUseItem(item)
      end)
    else
      FunctionItemFunc.TryUseItem(item)
    end
  else
    item = Table_Item[go.itemID]
    if nil ~= item then
      MsgManager.ShowMsgByID(go.msgDoNotHaveID, item.NameZh)
    else
      redlog("Cannot Find Item Data: " .. go.itemID)
    end
  end
  self:RefreshButtonStatus(go)
end
function MainViewMiniMap:HandleOpenMap(note)
  local t = note.body
  if t == "forward" then
    self:ActiveMapBord(true)
  elseif t == "reverse" then
    self:ActiveMapBord(false)
  else
    self:ActiveMapBord(not self.mapBord.activeInHierarchy)
  end
end
function MainViewMiniMap:UpdatePlayersSymbolData(note)
  local nSceneUserProxy = NSceneUserProxy.Instance
  for id, _ in pairs(self.playerMap) do
    self:_UpdatePlayerSymbolData(nSceneUserProxy:Find(id))
  end
end
local GetBallBornPosSID = function(id)
  return "Born_" .. id
end
local GetBallBallPosSID = function(id)
  return "Ball_" .. id
end
function MainViewMiniMap:UpdateTeamPwsMapInfo(note)
  if not MapManager:IsPVPMode_TeamPws() then
    return
  end
  local _PvpTeamRaid = DungeonProxy.Instance:GetConfigPvpTeamRaid()
  local ballBornPos = _PvpTeamRaid.ElementBornPosition
  local sid
  for id, pos in pairs(ballBornPos) do
    sid = GetBallBornPosSID(id)
    local miniMapData = self.teamPwsMapInfo[sid]
    if miniMapData == nil then
      miniMapData = MiniMapData.CreateAsTable(sid)
      self.teamPwsMapInfo[sid] = miniMapData
    end
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", "map_tpvppt")
    miniMapData:SetParama("depth", 10)
  end
  self.minimapWindow:UpdateTeamPwsInfo(self.teamPwsMapInfo, true)
  self.bigmapWindow:UpdateTeamPwsInfo(self.teamPwsMapInfo, true)
end
function MainViewMiniMap:UpdateTeamBallInfos(updates)
  if not MapManager:IsPVPMode_TeamPws() then
    return
  end
  if updates == nil or #updates == 0 then
    return
  end
  for i = 1, #updates do
    self:UpdateTeamPwsBallInfoData(updates[i])
  end
  self.minimapWindow:UpdateTeamPwsInfo(self.teamPwsMapInfo, true)
  self.bigmapWindow:UpdateTeamPwsInfo(self.teamPwsMapInfo, true)
  self:UpdatePlayersSymbolData()
end
local tempBallMap
function MainViewMiniMap:UpdateTeamPwsBallInfoData(ballNpc)
  if not MapManager:IsPVPMode_TeamPws() then
    return
  end
  local _PvpTeamRaid = DungeonProxy.Instance:GetConfigPvpTeamRaid()
  if tempBallMap == nil then
    tempBallMap = {}
    local ballConfig = _PvpTeamRaid.ElementNpcsID
    for id, config in pairs(ballConfig) do
      tempBallMap[config.npcid] = {id, config}
    end
  end
  local npcid = ballNpc.data.staticData and ballNpc.data.staticData.id
  local tempConfig = npcid and tempBallMap[npcid]
  if tempConfig == nil then
    return
  end
  local sid = GetBallBallPosSID(ballNpc.data.id)
  local miniMapData = self.teamPwsMapInfo[sid]
  if miniMapData == nil then
    miniMapData = MiniMapData.CreateAsTable(sid)
    self.teamPwsMapInfo[sid] = miniMapData
  end
  miniMapData:SetParama("Symbol", tempConfig[2].mapicon)
  local x, y, z = ballNpc:GetServerPos()
  miniMapData:SetPos(x, y, z)
  miniMapData:SetParama("depth", 11)
end
function MainViewMiniMap:RemoveTeamPwsBallInfo(dels)
  if not MapManager:IsPVPMode_TeamPws() then
    return
  end
  local dirty = false
  for i = 1, #dels do
    local ncpid = dels[i]
    local sid = GetBallBallPosSID(ncpid)
    local miniMapData = self.teamPwsMapInfo[sid]
    if miniMapData then
      miniMapData:Destroy()
      self.teamPwsMapInfo[sid] = nil
      dirty = true
    end
  end
  if dirty then
    self.minimapWindow:UpdateTeamPwsInfo(self.teamPwsMapInfo, true)
    self.bigmapWindow:UpdateTeamPwsInfo(self.teamPwsMapInfo, true)
  end
end
function MainViewMiniMap:ClearAllTeamPwsMapInfo()
  _TableClearByDeleter(self.teamPwsMapInfo, miniMapDataDeleteFunc)
  self.minimapWindow:UpdateTeamPwsInfo(self.teamPwsMapInfo, true)
  self.bigmapWindow:UpdateTeamPwsInfo(self.teamPwsMapInfo, true)
  self:UpdateTeamMembersPos(true)
  self:ClearPlayerMap()
end
function MainViewMiniMap:HandleAddNpcs(note)
  self:UpdateTeamBallInfos(note.body)
end
function MainViewMiniMap:HandleRemoveNpcs(note)
  self:RemoveTeamPwsBallInfo(note.body)
end
function MainViewMiniMap:HandleTeamPwsBallChange(note)
  self:UpdateTeamMembersPos(true)
  self:UpdatePlayersSymbolData()
end
