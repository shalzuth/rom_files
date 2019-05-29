AnnounceQuestPanel = class("AnnounceQuestPanel", ContainerView)
autoImport("AnnounceQuestPanelCell")
AnnounceQuestPanel.ViewType = UIViewType.NormalLayer
AnnounceQuestPanel.skillid = 50040001
AnnounceQuestPanel.ExitTag = false
function AnnounceQuestPanel:Init()
  self:initView()
  self:initData()
  self:addListEventListener()
  AnnounceQuestPanel.ExitTag = false
  EventManager.Me():AddEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  local lSprite = self:FindGO("Label", self:FindGO("panelTitle")):GetComponent(UISprite)
  lSprite.width = 154
  lSprite.height = 38
end
local tempArray = {}
function AnnounceQuestPanel:OnEnter()
  self.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  if viewdata and viewdata.npcTarget then
    local func = function()
      if AnnounceQuestPanel.ExitTag then
        return
      end
      self:Show()
      local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
      manager_Camera:ActiveMainCamera(false)
      ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
    end
    local trans = viewdata.npcTarget.assetRole.completeTransform
    self.announceGuid = viewdata.npcTarget.data:GetGuid()
    local viewPort = CameraConfig.Ann_ViewPort
    local rotation = CameraController.singletonInstance.targetRotationEuler
    rotation = Vector3(CameraConfig.Ann_ViewRotationX, rotation.y, rotation.z)
    self:CameraFaceTo(trans, viewPort, rotation, nil, nil, func)
  end
  self:SetUpTextures()
end
function AnnounceQuestPanel:OnExit()
  AnnounceQuestPanel.ExitTag = true
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(true)
  self.super.OnExit(self)
  self:CameraReset()
  self.questListCtl:ResetDatas()
  LeanTween.cancel(self.gameObject)
  TimeTickManager.Me():ClearTick(self)
  self:UnloadTextures()
  MsgManager.CloseConfirmMsgByID(903)
  EventManager.Me():RemoveEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
end
function AnnounceQuestPanel:initView()
  self.refreshTimeLabel = self:FindGO("refreshTimeLabel"):GetComponent(UILabel)
  self.currentRateLabel = self:FindGO("currentRateLabel"):GetComponent(UILabel)
  self.currentRateLabelValue = self:FindGO("currentRateLabelValue"):GetComponent(UILabel)
  self:Hide()
  self.leftAction = self:FindGO("leftAction")
  self.rightAction = self:FindGO("rightAction")
  self.panelMask = self:FindGO("panelMask")
  self:Hide(self.panelMask)
  self.ScrollView = self:FindComponent("ScrollView", UIScrollView)
  function self.ScrollView.onStoppedMoving()
    self:checkBtnEnabled()
  end
  self.contentContainer = self:FindComponent("ContentContainer", UIGrid)
  function self.contentContainer.onReposition()
    self.contentContainer.gameObject:SetActive(false)
    self.contentContainer.gameObject:SetActive(true)
  end
  local isInWantedQuestActivity = QuestProxy.Instance:isInWantedQuestInActivity()
  if isInWantedQuestActivity then
    self.questListCtl = UIGridListCtrl.new(self.contentContainer, AnnounceQuestPanelCell, "AnnounceQuestActivityPanelCell")
  else
    self.questListCtl = UIGridListCtrl.new(self.contentContainer, AnnounceQuestPanelCell, "AnnounceQuestPanelCell")
  end
  self.questListCtl:AddEventListener(MouseEvent.MouseClick, self.questClick, self)
  self.bgTexture = self:FindComponent("bgTexture", UITexture)
  self.bgCt = self:FindGO("bgCt")
  self.frameTexPrefix = "Rewardtask_bg_"
  self.frameTextures = {}
  self.frameTextures[self.frameTexPrefix .. "left"] = self:FindComponent("left", UITexture, self.bgCt)
  self.frameTextures[self.frameTexPrefix .. "up"] = self:FindComponent("up", UITexture, self.bgCt)
  self.frameTextures[self.frameTexPrefix .. "right"] = self:FindComponent("right", UITexture, self.bgCt)
  self.frameTextures[self.frameTexPrefix .. "down"] = self:FindComponent("down", UITexture, self.bgCt)
end
function AnnounceQuestPanel:initData()
  self.currentQuestData = nil
  self.firstInit = true
  if self.viewdata.viewdata then
    self.wantedId = self.viewdata.viewdata.wanted
  else
    printRed("can't find wantedId in viewdata!")
  end
  self.hasGoingQuest = false
  self.startIndex = 1
  self.listTime = {}
  local currentTime = ServerTime.CurServerTime() / 1000
  local nextDayTime
  local timeTab = os.date("*t", currentTime)
  for i = 1, #GameConfig.Quest.refresh do
    local tmp = TableUtil.split(GameConfig.Quest.refresh[i], ":")
    local tb = {
      year = timeTab.year,
      month = timeTab.month,
      day = timeTab.day,
      hour = tmp[1],
      min = tmp[2],
      sec = 0,
      isdst = false
    }
    table.insert(self.listTime, os.time(tb))
    if i == 1 then
      tb = {
        year = timeTab.year,
        month = timeTab.month,
        day = timeTab.day + 1,
        hour = tmp[1],
        min = tmp[2],
        sec = 0,
        isdst = false
      }
      nextDayTime = os.time(tb)
    end
  end
  table.insert(self.listTime, nextDayTime)
  self.currentRatio = 0
  self.hasPlayAudio = false
end
function AnnounceQuestPanel:checkBtnEnabled()
  if self.questListData and #self.questListData > 0 then
    local cells = self.questListCtl:GetCells()
    local panel = self.ScrollView.panel
    if panel then
      local cell = cells[1]
      if panel:IsVisible(cell.baseExp) then
        self:Hide(self.leftAction)
      else
        self:Show(self.leftAction)
      end
      local index = #cells
      cell = cells[index]
      if panel:IsVisible(cell.jobExp) then
        self:Hide(self.rightAction)
      else
        self:Show(self.rightAction)
      end
    end
  else
    self:Hide(self.rightAction)
    self:Hide(self.leftAction)
  end
end
function AnnounceQuestPanel:getStartIndexByQuestId()
  local questId = self.questId
  if self.questListData and #self.questListData > 0 then
    if questId then
      for i = 1, #self.questListData do
        local single = self.questListData[i]
        if single.id == questId then
          return i
        end
      end
    else
      return 1
    end
  end
  self.questId = nil
end
function AnnounceQuestPanel:addListEventListener()
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.setQuestData)
  self:AddListenEvt(ServiceEvent.SessionTeamQuestWantedQuestTeamCmd, self.SessionTeamQuestWantedQuestTeamCmd)
  self:AddListenEvt(ServiceEvent.SessionTeamUpdateWantedQuestTeamCmd, self.SessionTeamUpdateWantedQuestTeamCmd)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.setQuestData)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.setQuestData)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.VarUpdateHandler)
  self:AddListenEvt(ServiceEvent.QuestQuestCanAcceptListChange, function()
    ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
  end)
  self:AddListenEvt(SceneUserEvent.LevelUp, function()
    ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
  end)
  self:AddListenEvt(QuestEvent.UpdateAnnounceQuest, self.setQuestData)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.removeNpcHandle)
end
function AnnounceQuestPanel:removeNpcHandle(note)
  local body = note.body
  if body and #body > 0 then
    for i = 1, #body do
      if self.announceGuid == body[i] then
        self:CloseSelf()
        break
      end
    end
  end
end
function AnnounceQuestPanel:VarUpdateHandler()
  self.varupdated = true
  local submitCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_QUEST_WANTED)
  LeanTween.delayedCall(self.gameObject, 0.5, function()
    if self.varupdated then
      self:setQuestData()
    end
  end)
end
function AnnounceQuestPanel:SessionTeamQuestWantedQuestTeamCmd()
  self:Log("AnnounceQuestPanel:SessionTeamQuestWantedQuestTeamCmd()")
  self:setQuestData()
end
function AnnounceQuestPanel:SessionTeamUpdateWantedQuestTeamCmd()
  self:Log("AnnounceQuestPanel:SessionTeamUpdateWantedQuestTeamCmd()")
  self:setQuestData()
end
function AnnounceQuestPanel:checkQuestCanAccept()
end
function AnnounceQuestPanel:setQuestData(note)
  self.varupdated = false
  self.hasGoingQuest = false
  self.questListData = QuestProxy.Instance:getWantedQuest()
  local index = self:getStartIndexByQuestId()
  local unAccept = false
  for i = 1, #self.questListData do
    local single = self.questListData[i]:getQuestListType()
    if single == SceneQuest_pb.EQUESTLIST_ACCEPT or single == SceneQuest_pb.EQUESTLIST_COMPLETE then
      self.hasGoingQuest = true
      if self.firstInit then
        index = i
      end
      break
    elseif single == SceneQuest_pb.EQUESTLIST_CANACCEPT then
      unAccept = true
    end
  end
  QuestProxy.Instance:setGoingWantedQuest(self.hasGoingQuest)
  local extraCount = self:setQuestList(index)
  self.submitCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_QUEST_WANTED)
  if not self.submitCount then
    self.submitCount = 0
  end
  self.nextTime = self:getNextRefreshTime()
  TimeTickManager.Me():CreateTick(0, 1000, self.refreshTime, self, 1)
  local ratio = QuestProxy.Instance:getWantedQuestRatio(self.submitCount)
  self.currentRatio = ratio * 100
  if not self.hasPlayAudio then
    self.hasPlayAudio = true
    if unAccept or self.hasGoingQuest then
      AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Normal)
    else
      AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_AllCommit)
    end
  end
end
function AnnounceQuestPanel:checkIfNeedExtraQuest(questId)
  if self.questListData and #self.questListData > 0 then
    for i = 1, #self.questListData do
      local single = self.questListData[i]
      local result = single.id == questId and single:getQuestListType() ~= SceneQuest_pb.EQUESTLIST_SUBMIT
      if result then
        return false
      end
    end
  end
  return true
end
function AnnounceQuestPanel:checkIsAllQuestCommited()
  if self.questListData and #self.questListData > 0 then
    for i = 1, #self.questListData do
      local single = self.questListData[i]
      if single.id == questId and single:getQuestListType() ~= SceneQuest_pb.EQUESTLIST_SUBMIT then
        return false
      end
    end
  end
  return true
end
function AnnounceQuestPanel:checkIfHasExsit(questId, array)
  if array and #array > 0 then
    for i = 1, #array do
      local single = array[i]
      if single.id == questId then
        return true
      end
    end
  end
  return false
end
function AnnounceQuestPanel:setQuestList(index)
  local extraCount = 0
  local extraQuests = ShareAnnounceQuestProxy.Instance:getAllMembersQuest()
  local tempArray = {}
  for i = 1, #extraQuests do
    local single = extraQuests[i]
    local totalMember = ShareAnnounceQuestProxy.Instance:getTotalCountMenber(single.questId)
    local bRet = totalMember > 0 and self:checkIfNeedExtraQuest(single.questId) and not self:checkIfHasExsit(single.questId, tempArray)
    local params = single.questData.params
    local isComplete = params.mark_team_wanted == 1
    bRet = bRet and not isComplete
    if bRet then
      table.insert(tempArray, single.questData)
      extraCount = extraCount + 1
    end
  end
  if self.questListData and 0 < #self.questListData then
    for i = 1, #self.questListData do
      table.insert(tempArray, self.questListData[i])
    end
  end
  if not index then
    self.startIndex = 1 + extraCount
  else
    self.startIndex = index + extraCount
  end
  if tempArray and #tempArray > 0 then
    self.questListCtl:ResetDatas(tempArray)
    self:moveScrView()
    if self.ifNeedPlayRatioUp then
      local cells = self.questListCtl:GetCells()
      for i = 1, #cells do
        local single = cells[i]
        local panel = self.ScrollView.panel
        if panel and panel:IsVisible(single.publishName) then
          single:playRatioUpAnm()
        end
      end
      self.ifNeedPlayRatioUp = false
    end
  else
    self.questListCtl:ResetDatas()
  end
end
function AnnounceQuestPanel:moveScrView()
  if self.startIndex and self.startIndex ~= 1 then
    local cells = self.questListCtl:GetCells()
    local cell = cells[self.startIndex]
    if cell then
      LeanTween.delayedCall(self.gameObject, 1, function()
        local panel = self.ScrollView.panel
        if panel then
          local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cell.gameObject.transform)
          local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
          offset = Vector3(offset.x, 0, 0)
          self.ScrollView:MoveRelative(offset)
        end
      end)
    else
    end
  else
    self.questListCtl:Layout()
  end
end
function AnnounceQuestPanel:refreshTime()
  local deltaTime = math.abs(self.nextTime - ServerTime.CurServerTime() / 1000)
  local hour = math.floor(deltaTime / 3600)
  local timeStr
  if hour == 0 then
    timeStr = "00"
  elseif hour < 10 then
    timeStr = "0" .. hour
  else
    timeStr = hour
  end
  timeStr = timeStr .. ":"
  local minute = math.floor((deltaTime - hour * 3600) / 60)
  if minute == 0 then
    timeStr = timeStr .. "00"
  elseif minute < 10 then
    timeStr = timeStr .. "0" .. minute
  else
    timeStr = timeStr .. minute
  end
  timeStr = timeStr .. ":"
  local second = math.floor(deltaTime - hour * 3600 - minute * 60)
  if second == 0 then
    timeStr = timeStr .. "00"
  elseif second < 10 then
    timeStr = timeStr .. "0" .. second
  else
    timeStr = timeStr .. second
  end
  local curSmit = self.submitCount and self.submitCount or 0
  local str = curSmit .. "/" .. QuestProxy.Instance:getMaxWanted()
  self.refreshTimeLabel.text = string.format(ZhString.AnnounceQuestPanel_BottomLabel, self.currentRatio, str, timeStr)
end
function AnnounceQuestPanel:getNextRefreshTime()
  local currentTime = ServerTime.CurServerTime() / 1000
  for i = 1, #self.listTime do
    if currentTime < self.listTime[i] then
      return self.listTime[i]
    end
  end
end
function AnnounceQuestPanel:playQuestCompleteAnim(cell)
  local ratio = QuestProxy.Instance:getWantedQuestRatio(self.submitCount)
  local nextRatio = QuestProxy.Instance:getWantedQuestRatio(self.submitCount + 1)
  if ratio ~= nextRatio then
    self.ifNeedPlayRatioUp = true
  end
  self:PlayUISound(AudioMap.UI.stamp)
  self:Show(self.panelMask)
  cell:playAnim()
  LeanTween.delayedCall(self.gameObject, 3, function()
    if not self:ObjIsNil(self.panelMask) then
      self:Hide(self.panelMask)
    end
  end)
  ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_SUBMIT, cell.data.id)
end
function AnnounceQuestPanel:checkLevelCross(qMinLv, qMaxLv, rMinLv, rMaxLv)
  if rMinLv <= qMaxLv and qMinLv <= rMaxLv then
    return true
  end
end
function AnnounceQuestPanel:checkWantedTick(data)
  if not data or not data.wantedData or data.wantedData.IsActivity == 1 then
    return
  end
  local questConfig = GameConfig.Quest.quick_finish_board_quest or {}
  local wantedData = data.wantedData
  local questMinLimit, questMaxLimit = wantedData.LevelRange[1], wantedData.LevelRange[2]
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(55)
  local single, itemId, minLv, maxLv
  if dont == nil then
    for i = 1, #questConfig do
      single = questConfig[i]
      itemId = single[1] or nil
      minLv = single[2] or 1
      maxLv = single[3] or 999999
      itemData = BagProxy.Instance:GetItemByStaticID(itemId)
      if self:checkLevelCross(questMinLimit, questMaxLimit, minLv, maxLv) and itemData then
        MsgManager.DontAgainConfirmMsgByID(55, function()
          AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
          ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD, self.questId)
        end, function()
          AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
          ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT, self.questId)
        end, nil, itemData:GetName(true, true))
        return true
      end
    end
  else
    for i = 1, #questConfig do
      single = questConfig[i]
      itemId = single[1] or nil
      minLv = single[2] or 1
      maxLv = single[3] or 999999
      itemData = BagProxy.Instance:GetItemByStaticID(itemId)
      if self:checkLevelCross(questMinLimit, questMaxLimit, minLv, maxLv) and itemData then
        AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
        ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD, self.questId)
        return true
      end
    end
  end
end
function AnnounceQuestPanel:start(obj)
end
function AnnounceQuestPanel:questClick(obj)
  if obj then
    self.questId = obj.data.id
  end
  if obj.data.notMine then
    helplog("MainViewTaskQuestPage:CallAcceptHelpWantedTeamCmd(  ):", obj.data.id)
    ServiceSessionTeamProxy.Instance:CallAcceptHelpWantedTeamCmd(obj.data.id, false)
  elseif obj and obj.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_COMPLETE then
    self:playQuestCompleteAnim(obj)
    AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Commit)
  elseif obj and obj.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    if self.submitCount >= QuestProxy.Instance:getMaxWanted() then
      MsgManager.ShowMsgByIDTable(901)
      return
    elseif self.hasGoingQuest then
      MsgManager.ShowMsgByIDTable(900)
      return
    elseif self:checkWantedTick(obj.data) then
      return
    end
    AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT, self.questId)
  elseif self.questId then
    MsgManager.ConfirmMsgByID(903, function()
      local npcs = NSceneNpcProxy.Instance:FindNpcs(1016)
      if npcs and #npcs > 0 then
        ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ABANDON_GROUP, self.questId)
        ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
      end
    end, nil)
  end
end
function AnnounceQuestPanel:HandleOrientationChange(note)
  if note.data == nil then
    return
  end
  self.contentContainer:Reposition()
end
function AnnounceQuestPanel:SetUpTextures()
  self.bgTexName = "bg_view_2"
  if self.bgTexture then
    PictureManager.Instance:SetUI(self.bgTexName, self.bgTexture)
    PictureManager.ReFitFullScreen(self.bgTexture, 1)
  end
  for k, v in pairs(self.frameTextures) do
    PictureManager.Instance:SetUI(k, v)
  end
end
function AnnounceQuestPanel:UnloadTextures()
  if self.bgTexture then
    PictureManager.Instance:UnLoadUI(self.bgTexName, self.bgTexture)
  end
  for k, v in pairs(self.frameTextures) do
    PictureManager.Instance:UnLoadUI(k, v)
  end
end
