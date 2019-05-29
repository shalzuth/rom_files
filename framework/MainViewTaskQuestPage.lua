autoImport("TaskQuestCell")
autoImport("DeathPopView")
autoImport("QuestDetailTip")
MainViewTaskQuestPage = class("MainViewTaskQuestPage", SubView)
local tempVector3 = LuaVector3.zero
function MainViewTaskQuestPage:Init()
  self:AddViewEvts()
  self:initView()
  self:initData()
  self:initQusetList()
  self.currentMapId = 0
  self.isInFuben = false
  self.isInHand = false
end
function MainViewTaskQuestPage:initData()
  self.appearAmMap = {}
  self.onGoingQuestId = nil
end
function MainViewTaskQuestPage:initView()
  self.gameObject = self:FindGO("TaskQuestBord")
  self.foldSymbol = self:FindGO("taskCellFoldSymbol")
  self.taskBordFoldSymbol = self:FindGO("taskBordFoldSymbol")
  local taskCellFoldSymbolSp = self:FindComponent("taskCellFoldSymbol", UISprite)
  self:AddClickEvent(self.taskBordFoldSymbol, function()
    TipManager.Instance:ShowTaskQuestTip(taskCellFoldSymbolSp, NGUIUtil.AnchorSide.Left, {-450, 0})
  end)
  self:AddClickEvent(self.foldSymbol)
  self.playTweens = self.foldSymbol:GetComponents(UIPlayTween)
  self.rotationTwn = self.foldSymbol:GetComponent(TweenRotation)
  self.scrollview = self:FindGO("taskQuestScrollView"):GetComponent(UIScrollView)
  self.EffectPanel = self:FindGO("EffectPanel")
  self.taskBord = self:FindChild("taskBord")
  self.taskQuestTable = self.taskBord:GetComponent(UITable)
  self.questList = UIGridListCtrl.new(self.taskQuestTable, TaskQuestCell, "TaskQuestCell")
  self.questList:AddEventListener(MouseEvent.MouseClick, self.questCellClick, self)
  local objLua = self.gameObject:GetComponent(GameObjectForLua)
  function objLua.onEnable()
    LeanTween.delayedCall(0.8, function()
      self:adjustScrollView()
    end)
  end
end
function MainViewTaskQuestPage:adjustScrollView()
  self.questList:Layout()
  self.scrollview:RestrictWithinBounds(true)
end
function MainViewTaskQuestPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.QuestQuestUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.setQuestData)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.QuestQuestStepUpdate)
  self:AddListenEvt(ServiceEvent.QuestQueryOtherData, self.QuestQueryOtherData)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.ItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.ItemUpdate)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.handlePlayerMapChange)
  self:AddListenEvt(QuestEvent.QuestDelete, self.questDelete)
  self:AddListenEvt(MyselfEvent.DeathBegin, self.handleDeathStatus)
  self:AddListenEvt(ServiceEvent.FuBenCmdTrackFuBenUserCmd, self.FuBenCmdTrackFuBenUserCmd)
  self:AddListenEvt(QuestEvent.ProcessChange, self.ProcessChange)
  self:AddListenEvt(QuestEvent.RemoveHelpQuest, self.RemoveHelpQuest)
  self:AddListenEvt(QuestEvent.UpdateAnnounceQuestList, self.UpdateAnnounceQuestList)
  self:AddListenEvt(QuestEvent.RemoveGuildQuestList, self.RemoveGuildQuestList)
  self:AddListenEvt(QuestEvent.UpdateGuildQuestList, self.UpdateGuildQuestList)
  self:AddListenEvt(QuestEvent.ShowManualGoEffect, self.HandleManualGoEffect)
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(MyselfEvent.SceneGoToUserCmdHanded, self.SceneGoToUserCmd, self)
  eventManager:AddEventListener(FunctionQuest.UpdateTraceInfo, self.updateTraceInfo, self)
  eventManager:AddEventListener(FunctionQuest.RemoveTraceInfo, self.RemoveTraceInfo, self)
  eventManager:AddEventListener(FunctionQuest.AddTraceInfo, self.AddTraceInfo, self)
  eventManager:AddEventListener(HandEvent.MyStartHandInHand, self.MyStartHandInHand, self)
  eventManager:AddEventListener(HandEvent.MyStopHandInHand, self.MyStopHandInHand, self)
  eventManager:AddEventListener(MyselfEvent.MissionCommandChanged, self.handleMissionCommand, self)
end
function MainViewTaskQuestPage:UpdateGuildQuestList(note)
  local upQuests = note.body
  for k, v in pairs(upQuests) do
    local cell, index = self:getTraceCellByQuestId(k)
    if cell then
      resetPos = true
      cell:SetData(cell.data)
    end
  end
  if resetPos then
    self.questList:Layout()
  end
  self:selectShowDirQuest(self.onGoingQuestId, true)
end
function MainViewTaskQuestPage:RemoveGuildQuestList(note)
  local rmQuests = note.body
  for k, v in pairs(rmQuests) do
    local cell, index = self:getTraceCellByQuestId(k)
    if cell then
      resetPos = true
      self.questList:RemoveCell(index)
    end
  end
  if resetPos then
    self.questList:Layout()
    self.scrollview:InvalidateBounds()
    self.scrollview:RestrictWithinBounds(true)
  end
end
function MainViewTaskQuestPage:RemoveHelpQuest(note)
  local ids = note.body
  if type(ids) == "number" then
    ids = {ids}
  end
  for i = 1, #ids do
    ServiceSessionTeamProxy.Instance:CallAcceptHelpWantedTeamCmd(ids[i], true)
  end
end
function MainViewTaskQuestPage:UpdateAnnounceQuestList(note)
  local questId = note.body
  local cell = self:getTraceCellByQuestId(questId)
  local data = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  if cell and data then
    cell:SetData(data)
    local updateList = cell.bgSizeChanged
    if updateList then
      self.taskQuestTable.repositionNow = true
    end
  end
  self:selectShowDirQuest(self.onGoingQuestId, true)
end
function MainViewTaskQuestPage:removeAppearAnm(id)
  self.appearAmMap[id] = nil
end
function MainViewTaskQuestPage:checkCellIsVisible(widget)
  local panel = self.scrollview.panel
  if panel then
    return panel:IsVisible(widget)
  end
end
function MainViewTaskQuestPage.effectLoaded(effectObj, pos)
  if not LuaGameObject.ObjectIsNull(effectObj) then
    effectObj.transform.localPosition = pos
  end
end
function MainViewTaskQuestPage:playTaskAppearAnm(cell)
  if cell.data.getIfShowAppearAnm and cell.data:getIfShowAppearAnm() and not self.appearAmMap[cell.data.id] and self:checkCellIsVisible(cell.title) then
    self.appearAmMap[cell.data.id] = true
    tempVector3:Set(LuaGameObject.InverseTransformPointByTransform(self.EffectPanel.transform, cell.title.transform, Space.World))
    self:PlayUIEffect(EffectMap.UI.Refresh, self.EffectPanel, true, MainViewTaskQuestPage.effectLoaded, tempVector3)
    LeanTween.delayedCall(0.5, function()
      self:removeAppearAnm(cell.data.id)
      cell.data:setIfShowAppearAnm(false)
    end)
  else
  end
end
function MainViewTaskQuestPage:ItemUpdate()
  local cells = self.questList:GetCells()
  for j = 1, #cells do
    local cell = cells[j]
    local data = cell.data
    if QuestProxy.Instance:checkUpdateWithItemUpdate(data) then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(data.id, SceneQuest_pb.EQUESTLIST_ACCEPT)
      if questData then
        cell:SetData(questData)
      end
    end
  end
  self:selectShowDirQuest(self.onGoingQuestId, true)
end
function MainViewTaskQuestPage:QuestQueryOtherData()
  local cells = self.questList:GetCells()
  for j = 1, #cells do
    local cell = cells[j]
    local data = cell.data
    if QuestDataType.QuestDataType_DAILY == data.type then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(data.id, SceneQuest_pb.EQUESTLIST_ACCEPT)
      if questData then
        cell:SetData(questData)
      end
    end
  end
  self:selectShowDirQuest(self.onGoingQuestId, true)
end
function MainViewTaskQuestPage:QuestQuestUpdate(note)
  self:setQuestData()
  local data = note.body
  local items = data.items
  if items then
    local topIndex = 99999
    local topCell
    for i = 1, #items do
      local item = items[i]
      local del = item.del
      local update = item.update
      local type = item.type
      if type == SceneQuest_pb.EQUESTLIST_ACCEPT then
        if update then
          for i = 1, #update do
            local single = update[i]
            local cell, index = self:getTraceCellByQuestId(single.id)
            if cell and QuestProxy.Instance:checkIsShowDirAndDis(cell.data) and topIndex > index then
              topIndex = index
              topCell = cell
            end
          end
        end
        break
      end
    end
    if topCell then
      self:stopShowDirAndDis(self.onGoingQuestId)
      self:ShowDirAndDis(topCell)
      return
    end
  end
  self:selectShowDirQuest(self.onGoingQuestId)
end
function MainViewTaskQuestPage:QuestQuestStepUpdate(note)
  self:setQuestData()
  local data = note.body
  local questId = data.id
  if questId ~= self.onGoingQuestId then
    local cell = self:getTraceCellByQuestId(questId)
    if cell and QuestProxy.Instance:checkIsShowDirAndDis(cell.data) then
      self:stopShowDirAndDis(self.onGoingQuestId)
      self:ShowDirAndDis(cell)
      return
    end
  end
  self:selectShowDirQuest(self.onGoingQuestId)
end
function MainViewTaskQuestPage:ProcessChange(note)
  local data = note.body
  local questId = data.id
  local cell = self:getTraceCellByQuestId(questId)
  if cell then
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId, SceneQuest_pb.EQUESTLIST_ACCEPT)
    if questData then
      cell:SetData(questData)
      local updateList = cell.bgSizeChanged
      if updateList then
        self.taskQuestTable.repositionNow = true
      end
    end
  end
  if questId ~= self.onGoingQuestId and cell and QuestProxy.Instance:checkIsShowDirAndDis(cell.data) then
    self:stopShowDirAndDis(self.onGoingQuestId)
    self:ShowDirAndDis(cell)
    return
  end
  self:selectShowDirQuest(self.onGoingQuestId, true)
end
function MainViewTaskQuestPage:initQusetList()
  self:setQuestData(true)
  local id = LocalSaveProxy.Instance:getLastTraceQuestId()
  self:selectShowDirQuest(id)
end
function MainViewTaskQuestPage:selectShowDirQuest(id, noMove)
  local result = self:ShowDirAndDisByQuestId(id, noMove)
  if result then
    return
  end
  local cells = self.questList:GetCells()
  for j = 1, #cells do
    local cell = cells[j]
    local data = cell.data
    local isShowDirAndDis = QuestProxy.Instance:checkIsShowDirAndDis(data)
    if isShowDirAndDis then
      self:ShowDirAndDis(cell, noMove)
      break
    end
  end
end
function MainViewTaskQuestPage:RemoveTraceInfo(traceData)
  if traceData then
    local id = traceData.id
    local type = traceData.type
    local cell, index = self:getTraceCellByQuestId(id, type)
    local resetPos = false
    if cell then
      resetPos = true
      self.questList:RemoveCell(index)
    end
    if resetPos then
      self.questList:Layout()
      self.scrollview:InvalidateBounds()
      self.scrollview:RestrictWithinBounds(true)
    end
  end
end
function MainViewTaskQuestPage:AddTraceInfo(traceData)
  if traceData then
    local id = traceData.id
    local type = traceData.type
    local list = QuestProxy.Instance:getValidAcceptQuestList(true)
    local traceDatas = QuestProxy.Instance:getTraceDatas()
    if traceDatas then
      for i = 1, #traceDatas do
        local single = traceDatas[i]
        table.insert(list, single)
      end
    end
    QuestProxy.Instance:SetTraceCellCount(#list)
    self:sortTraceDatas(list)
    local index = 1
    for j = 1, #list do
      local data = list[j]
      if id == data.id and type == data.type then
        index = j
        break
      end
    end
    local cell = self.questList:AddCell(traceData, index)
    cell.gameObject.transform:SetSiblingIndex(index - 1)
    self.questList:Layout()
    self.scrollview:InvalidateBounds()
    self.scrollview:RestrictWithinBounds(true)
  end
end
function MainViewTaskQuestPage:updateTraceInfo(traceData)
  if traceData then
    local id = traceData.id
    local type = traceData.type
    local cell = self:getTraceCellByQuestId(id, type)
    local resetPos = false
    if cell then
      cell:SetData(traceData)
      resetPos = cell.bgSizeChanged
    end
    if resetPos then
      self.questList:Layout()
    end
  end
end
function MainViewTaskQuestPage:MyStartHandInHand(isSelf)
  local handed, handowner = Game.Myself:IsHandInHand()
  self.isInHand = true
  if handed and not handowner then
    self:folderSymbol(false)
  end
end
function MainViewTaskQuestPage:MyStopHandInHand(isSelf)
  self.isInHand = false
  if not self.isInFuben then
    local handed, handowner = Game.Myself:IsHandInHand()
    if handed and not handowner then
      self:folderSymbol(true)
    end
  end
end
function MainViewTaskQuestPage:questCellClick(cellCtrl)
  if cellCtrl and cellCtrl.data then
    local isShowDirAndDis = QuestProxy.Instance:checkIsShowDirAndDis(cellCtrl.data)
    if isShowDirAndDis then
      if cellCtrl.data.id ~= self.onGoingQuestId then
        self:stopShowDirAndDis(self.onGoingQuestId)
        self:ShowDirAndDis(cellCtrl)
        Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(cellCtrl.data.id)
      else
        self:ShowDirAndDis(cellCtrl)
        Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(cellCtrl.data.id)
      end
    else
      FunctionQuest.Me():executeQuest(cellCtrl.data)
    end
  end
end
function MainViewTaskQuestPage:ShowDirAndDis(cellCtrl, noMove)
  local args = ReusableTable.CreateTable()
  local questData = cellCtrl.data
  args.questData = questData
  args.owner = cellCtrl
  args.callback = cellCtrl.Update
  FunctionQuestDisChecker.Me():AddQuestCheck(args)
  ReusableTable.DestroyAndClearTable(args)
  FunctionQuest.Me():addQuestMiniShow(questData)
  FunctionQuest.Me():addMonsterNamePre(questData)
  cellCtrl:setISShowDir(true)
  self.onGoingQuestId = cellCtrl.data.id
  LocalSaveProxy.Instance:setLastTraceQuestId(self.onGoingQuestId)
  if noMove or self:ObjIsNil(cellCtrl.gameObject) then
    return
  end
  local panel = self.scrollview.panel
  local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
  local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.scrollview:MoveRelative(offset)
end
function MainViewTaskQuestPage:getTraceCellByQuestId(id, type)
  if not id then
    return
  end
  local cells = self.questList:GetCells()
  for j = 1, #cells do
    local cell = cells[j]
    local data = cell.data
    if data and id == data.id and not type then
      return cell, j
    elseif data and id == data.id and type == data.type then
      return cell, j
    end
  end
end
function MainViewTaskQuestPage:ShowDirAndDisByQuestId(id, noMove)
  if not id then
    return
  end
  local cellCtrl = self:getTraceCellByQuestId(id)
  if cellCtrl and QuestProxy.Instance:checkIsShowDirAndDis(cellCtrl.data) then
    self:ShowDirAndDis(cellCtrl, noMove)
    return true
  end
  self.onGoingQuestId = nil
  return false
end
function MainViewTaskQuestPage:stopShowDirAndDis(id)
  if not id then
    return
  end
  FunctionQuest.Me():stopQuestMiniShow(id)
  local cells = self.questList:GetCells()
  for j = 1, #cells do
    local cell = cells[j]
    local data = cell.data
    if data and id == data.id then
      FunctionQuestDisChecker.RemoveQuestCheck(id)
      cell:setISShowDir(false)
      break
    end
  end
end
function MainViewTaskQuestPage:handleMissionCommand(note)
  local data = note.data
  local oldCmd = data[1]
  local newCmd = data[2]
  local oldQuestId, newQuestId
  if oldCmd then
    oldQuestId = oldCmd.args.custom
  end
  if newCmd then
    newQuestId = newCmd.args.custom
  end
  if oldQuestId and oldQuestId ~= newQuestId then
    local cell = self:getTraceCellByQuestId(oldQuestId)
    if cell then
      cell:setIsOngoing(false)
    end
  end
  if newQuestId and oldQuestId ~= newQuestId then
    local cell = self:getTraceCellByQuestId(newQuestId)
    if cell then
      cell:setIsOngoing(true)
    end
  end
end
function MainViewTaskQuestPage:setQuestData(resetPos, noAppearAm)
  local list = QuestProxy.Instance:getValidAcceptQuestList(true)
  local myself = Game.Myself
  local currentProfession = MyselfProxy.Instance:GetMyProfession()
  local destProfession = myself.data.userdata:Get(UDEnum.DESTPROFESSION)
  if not myself or not myself.data then
    self.questList:RemoveAll()
    return
  end
  local traceDatas = QuestProxy.Instance:getTraceDatas()
  if traceDatas then
    for i = 1, #traceDatas do
      local single = traceDatas[i]
      table.insert(list, single)
    end
  end
  QuestProxy.Instance:SetTraceCellCount(#list)
  if not list or #list == 0 then
    self.questList:RemoveAll()
    return
  end
  self:sortTraceDatas(list)
  self.questList:ResetDatas(list)
  self.taskQuestTable.repositionNow = true
  QuestProxy.Instance:checkIfNeedStopMissionTrigger()
  QuestProxy.Instance:checkIfNeedRemoveGuideView()
  self.scrollview:RestrictWithinBounds(true)
  if resetPos then
    self.scrollview:ResetPosition()
  end
  local curCmdData = FunctionQuest.Me():getCurCmdData()
  if curCmdData then
    self:setQuestIsOngoing(curCmdData, true)
  end
  if not noAppearAm then
    self:playAppearAnm()
  end
end
function MainViewTaskQuestPage:playAppearAnm()
  local cells = self.questList:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    local data = single.data
    if data then
      self:playTaskAppearAnm(single)
    end
  end
end
local func = function(t1, t2)
  if t1.type == t2.type then
    if t1.staticData and t1.staticData.IconFromServer == 6 or t2.staticData and t2.staticData.IconFromServer == 6 then
      local leftWeight = 90
      if t1.staticData and t1.staticData.IconFromServer == 6 then
        leftWeight = 90
      else
        leftWeight = 0
      end
      local rightWeight = 90
      if t2.staticData and t2.staticData.IconFromServer == 6 then
        rightWeight = 90
      else
        rightWeight = 0
      end
      if leftWeight == 0 and rightWeight == 0 then
        return t1.orderId < t2.orderId
      elseif leftWeight == 90 and rightWeight == 90 then
        return t1.orderId < t2.orderId
      else
        return leftWeight > rightWeight
      end
    elseif t1.staticData and t1.staticData.IconFromServer == 6 then
      leftWeight = 90
    elseif t1.type == QuestDataType.QuestDataType_WANTED then
      return t1.time > t2.time
    else
      return t1.orderId < t2.orderId
    end
  elseif t1.type ~= t2.type then
    local leftWeight = 200
    if t1.staticData and t1.staticData.IconFromServer == 6 then
      leftWeight = 90
    elseif t1.staticData and t1.staticData.IconFromServer == 5 then
      leftWeight = 70
    elseif t1.staticData and t1.staticData.IconFromServer == 1 then
      leftWeight = 60
    elseif t1.staticData and t1.staticData.IconFromServer == 2 then
      leftWeight = 30
    elseif t1.staticData and t1.staticData.IconFromServer == 3 then
      leftWeight = 10
    elseif t1.staticData and t1.staticData.IconFromServer == 4 then
      leftWeight = 20
    elseif t1.type == QuestDataType.QuestDataType_INVADE then
      leftWeight = 200
    elseif t1.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
      leftWeight = 180
    elseif t1.type == QuestDataType.QuestDataType_MAIN then
      leftWeight = 60
    elseif t1.type == QuestDataType.QuestDataType_WANTED then
      leftWeight = 50
    elseif t1.type == QuestDataType.QuestDataType_SEALTR then
      leftWeight = 40
    elseif t1.type == QuestDataType.QuestDataType_DAILY then
      leftWeight = 30
    elseif t1.type == QuestDataType.QuestDataType_ELITE then
      leftWeight = 20
    elseif t1.type == QuestDataType.QuestDataType_BRANCH then
      leftWeight = 10
    else
      leftWeight = 0
    end
    local rightWeight = 200
    if t2.staticData and t2.staticData.IconFromServer == 6 then
      rightWeight = 90
    elseif t2.staticData and t2.staticData.IconFromServer == 5 then
      rightWeight = 70
    elseif t2.staticData and t2.staticData.IconFromServer == 1 then
      rightWeight = 60
    elseif t2.staticData and t2.staticData.IconFromServer == 2 then
      rightWeight = 30
    elseif t2.staticData and t2.staticData.IconFromServer == 3 then
      rightWeight = 10
    elseif t2.staticData and t2.staticData.IconFromServer == 4 then
      rightWeight = 20
    elseif t2.type == QuestDataType.QuestDataType_INVADE then
      rightWeight = 200
    elseif t2.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
      rightWeight = 180
    elseif t2.type == QuestDataType.QuestDataType_MAIN then
      rightWeight = 60
    elseif t2.type == QuestDataType.QuestDataType_WANTED then
      rightWeight = 50
    elseif t2.type == QuestDataType.QuestDataType_SEALTR then
      rightWeight = 40
    elseif t2.type == QuestDataType.QuestDataType_DAILY then
      rightWeight = 30
    elseif t2.type == QuestDataType.QuestDataType_ELITE then
      rightWeight = 20
    elseif t2.type == QuestDataType.QuestDataType_BRANCH then
      rightWeight = 10
    else
      rightWeight = 0
    end
    if leftWeight == 0 and rightWeight == 0 then
      return t1.orderId < t2.orderId
    else
      return leftWeight > rightWeight
    end
  end
end
function MainViewTaskQuestPage:sortTraceDatas(questList)
  if questList ~= nil and #questList ~= 0 then
    table.sort(questList, func)
  end
end
function MainViewTaskQuestPage:addItemTraces(list, itemTrs)
  if itemTrs then
    for i = 1, #itemTrs do
      local single = itemTrs[i]
      table.insert(list, single)
    end
  end
end
function MainViewTaskQuestPage:questDelete(note)
  local data = note.body
  for i = 1, #data do
    local single = data[i]
    self:removeAppearAnm(single.id)
  end
end
function MainViewTaskQuestPage:handleDeathStatus(note)
end
function MainViewTaskQuestPage:FuBenCmdTrackFuBenUserCmd(note)
  self.isInFuben = true
  self:folderSymbol(false)
end
function MainViewTaskQuestPage:folderSymbol(state)
  if self.playTweens then
    if not state and self.rotationTwn.tweenFactor == 0 then
      for i = 1, #self.playTweens do
        local single = self.playTweens[i]
        single:Play(true)
      end
    elseif state and self.rotationTwn.tweenFactor == 1 then
      for i = 1, #self.playTweens do
        local single = self.playTweens[i]
        single:Play(true)
      end
    end
  end
end
function MainViewTaskQuestPage:OnExit()
  MainViewTaskQuestPage.super.OnExit(self)
  EventManager.Me():RemoveEventListener(FunctionQuest.UpdateTraceInfo, self.updateTraceInfo, self)
  EventManager.Me():RemoveEventListener(FunctionQuest.RemoveTraceInfo, self.RemoveTraceInfo, self)
  EventManager.Me():RemoveEventListener(FunctionQuest.AddTraceInfo, self.AddTraceInfo, self)
  EventManager.Me():RemoveEventListener(HandEvent.MyStartHandInHand, self.MyStartHandInHand, self)
  EventManager.Me():RemoveEventListener(HandEvent.MyStopHandInHand, self.MyStopHandInHand, self)
  EventManager.Me():RemoveEventListener(HandEvent.SceneGoToUserCmdHanded, self.SceneGoToUserCmd, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.MissionCommandChanged, self.handleMissionCommand, self)
  TimeTickManager.Me():ClearTick(self)
end
function MainViewTaskQuestPage:handlePlayerMapChange(note)
  if note.type == LoadSceneEvent.StartLoad then
    return
  end
  self:MapChange()
  local data = note.body
  if self.currentMapId ~= 0 and data.dmapID == 0 then
    if not self.isInHand then
      self:folderSymbol(true)
    end
    self.isInFuben = false
    self:sendNotification(UIEvent.CloseUI, DeathPopView.ViewType)
  end
  self.currentMapId = data.dmapID
  if note.type == LoadSceneEvent.StartLoad then
    local cells = self.questList:GetCells()
    for i = 1, #cells do
      cells[i]:setIsSelected(false)
    end
  end
end
function MainViewTaskQuestPage:HandleManualGoEffect(note)
  local body = note.body
  if not body or not body.questid then
    return
  end
  local questId = body.questid
  local cellCtrl = self:getTraceCellByQuestId(questId)
  if not cellCtrl then
    return
  end
  self:stopShowDirAndDis(self.onGoingQuestId)
  local args = ReusableTable.CreateTable()
  local questData = cellCtrl.data
  args.questData = questData
  args.owner = cellCtrl
  args.callback = cellCtrl.Update
  FunctionQuestDisChecker.Me():AddQuestCheck(args)
  ReusableTable.DestroyAndClearTable(args)
  cellCtrl:setISShowDir(true)
  self.onGoingQuestId = cellCtrl.data.id
  LocalSaveProxy.Instance:setLastTraceQuestId(self.onGoingQuestId)
  if not self:ObjIsNil(cellCtrl.gameObject) then
    local panel = self.scrollview.panel
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.scrollview:MoveRelative(offset)
    cellCtrl:ShowAnimSp()
    LeanTween.cancel(cellCtrl.gameObject)
    LeanTween.delayedCall(cellCtrl.gameObject, 3, function()
      cellCtrl:HideAnimSp()
    end)
  end
end
function MainViewTaskQuestPage:MapChange()
  local cellCtrl = self:getTraceCellByQuestId(self.onGoingQuestId)
  if cellCtrl and cellCtrl.data then
    FunctionQuest.Me():addQuestMiniShow(cellCtrl.data)
  end
end
function MainViewTaskQuestPage:SceneGoToUserCmd()
  self:MapChange()
end
