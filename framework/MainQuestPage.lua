MainQuestPage = class("MainQuestPage", SubView)
autoImport("PuzzleBlockCell")
autoImport("PuzzleAwardCell")
autoImport("QuestListCell")
autoImport("QuestTraceCell")
autoImport("DailyCoinCell")
local tempArray = {}
local Offset = 60
function MainQuestPage:Init()
  self:initView()
  self:addViewEventListener()
  self:AddListenerEvts()
  self:initData()
end
function MainQuestPage:initView()
  self.gameObject = self:FindGO("MainQuestPage")
  self.questName = self:FindComponent("QuestName", UILabel)
  self.psGo = self:FindGO("ProgressScrollView")
  self.progressScrollView = self.psGo:GetComponent(UIScrollView)
  self.questDescription = self:FindComponent("QuestDescription", UILabel)
  self.questProgress0 = self:FindComponent("QuestProgress0", UILabel)
  self.questProgress1 = self:FindComponent("QuestProgress1", UILabel)
  self.puzzleTexture = self:FindComponent("PuzzleTexture", UITexture)
  self.puzzleBlockGrid = self:FindGO("puzzleBlockGrid")
  self.uiGridOfPuzzleBlocks = self.puzzleBlockGrid:GetComponent(UIGrid)
  if self.listControllerOfPuzzleBlocks == nil then
    self.listControllerOfPuzzleBlocks = UIGridListCtrl.new(self.uiGridOfPuzzleBlocks, PuzzleBlockCell, "PuzzleBlockCell")
  end
  self.puzzleBoard = self:FindGO("Puzzle")
  self.puzzleBackBoard = self:FindGO("PuzzleBack")
  self.puzzleBackTypeLabelList = {}
  self.puzzleBackTypeLineList = {}
  for i = 1, 2 do
    local btnName = "PuzzleBackType" .. i
    local puzzleBackTypeGo = self:FindGO(btnName)
    self.puzzleBackTypeLineList[btnName] = self:FindGO("PuzzleBackTypeMark" .. i)
    self.puzzleBackTypeLabelList[btnName] = self:FindComponent("PuzzleBackTypeLabel" .. i, UILabel)
    self:AddButtonEvent(btnName, function()
      self:PuzzleBackTypeChangeHandler(puzzleBackTypeGo)
    end)
    break
  end
  self.puzzleAward = self:FindGO("PuzzleAward")
  self.mainQuestList = self:FindGO("MainQuestList")
  self.puzzleAwardGrid = self:FindGO("puzzleAwardGrid")
  self.uiGridOfPuzzleAward = self.puzzleAwardGrid:GetComponent(UIGrid)
  if self.listControllerOfPuzzleAward == nil then
    self.listControllerOfPuzzleAward = UIGridListCtrl.new(self.uiGridOfPuzzleAward, PuzzleAwardCell, "PuzzleAwardCell")
  end
  self.questscrollview = self:FindGO("ScrollView_QuestList"):GetComponent(UIScrollView)
  self.questListGrid = self:FindGO("questListGrid")
  self.uiGridOfQuestList = self.questListGrid:GetComponent(UIGrid)
  if self.listControllerOfQuestList == nil then
    self.listControllerOfQuestList = UIGridListCtrl.new(self.uiGridOfQuestList, QuestListCell, "QuestListCell")
  end
  self:AddButtonEvent("PuzzleBackTurnBtn1", function()
    self.puzzleBoard:SetActive(false)
    self.puzzleBackBoard:SetActive(true)
    local defaultBackType = self:FindGO("PuzzleBackType1")
    self:PuzzleBackTypeChangeHandler(defaultBackType)
  end)
  self:AddButtonEvent("PuzzleBackTurnBtn2", function()
    self.puzzleBoard:SetActive(true)
    self.puzzleBackBoard:SetActive(false)
    local versionData = QuestManualProxy.Instance:GetManualQuestDatas(self.currentVersion)
    self:UpdatePuzzleBoard(versionData.main)
  end)
  self.traceBoardSingle = self:FindGO("TraceBoardSingle")
  self.traceBoardSingleCell = QuestTraceCell.new(self.traceBoardSingle)
  self.traceBoardMulty = self:FindGO("TraceBoardMulty")
  self.traceBoardScrollView = self:FindGO("TraceBoardScrollView")
  self.traceBoardList = self:FindComponent("TraceBoardList", UISprite)
  self.collectTraceInfo = self:FindComponent("CollectTraceInfo", UILabel)
  self.traceBoardButtonDownArrow = self:FindGO("TraceBoardButtonDownArrow")
  self:AddButtonEvent("TraceBoardButtonDown", function()
    self:TriggerTraceBoardMultySize()
  end)
  self.traceBoardMultyCoinScrollView = self:FindComponent("DailyCoinScrollView", UIScrollView)
  self.dailyCountGrid = self:FindGO("DailyCoinGrid")
  self.uiGridOfDailyCount = self.dailyCountGrid:GetComponent(UIGrid)
  if self.listControllerOfDailyCount == nil then
    self.listControllerOfDailyCount = UIGridListCtrl.new(self.uiGridOfDailyCount, DailyCoinCell, "DailyCoinCell")
  end
  self.dailyCountGridLong = self:FindGO("DailyCoinGridLong")
  self.uiGridOfDailyCountLong = self.dailyCountGridLong:GetComponent(UIGrid)
  if self.listControllerOfDailyCountLong == nil then
    self.listControllerOfDailyCountLong = UIGridListCtrl.new(self.uiGridOfDailyCountLong, DailyCoinCell, "DailyCoinCell")
  end
  self.questTraceGrid = self:FindGO("questTraceGrid")
  self.uiGridOfQuestTrace = self.questTraceGrid:GetComponent(UIGrid)
  if self.listControllerOfQuestTrace == nil then
    self.listControllerOfQuestTrace = UIGridListCtrl.new(self.uiGridOfQuestTrace, QuestTraceCell, "QuestTraceCell")
  end
  self.mainQuestDetailDiv = self:FindGO("MainQuestDetailDiv")
  self.questDetail = self:FindGO("QuestDetail")
  self.noData = self:FindGO("NoData")
  self.itemTipStick = self:FindComponent("ItemTipStick", UIWidget)
end
function MainQuestPage:Show(target)
  MainQuestPage.super.Show(self, target)
end
function MainQuestPage:initData()
end
function MainQuestPage:PuzzleBackTypeChangeHandler(go)
  local typeName = go.name
  if self.currentPuzzleBackType ~= go then
    if self.currentPuzzleBackType then
      self.puzzleBackTypeLineList[self.currentPuzzleBackType.name]:SetActive(false)
      self.puzzleBackTypeLabelList[self.currentPuzzleBackType.name].color = QuestManualView.ColorTheme[2].color
    end
    self.currentPuzzleBackType = go
    self.puzzleBackTypeLineList[typeName]:SetActive(true)
    self.puzzleBackTypeLabelList[typeName].color = QuestManualView.ColorTheme[4].color
  end
  self:LoadPuzzleBackTypeContent(typeName)
end
function MainQuestPage:LoadPuzzleBackTypeContent(typeName)
  if typeName == "PuzzleBackType1" then
    self.puzzleAward:SetActive(true)
    self.mainQuestList:SetActive(false)
  elseif typeName == "PuzzleBackType2" then
    self.puzzleAward:SetActive(false)
    self.mainQuestList:SetActive(true)
  end
  self:UpdatePuzzleBackBoard()
end
function MainQuestPage:SetData(version)
  self.traceBoardSingle:SetActive(false)
  self.traceBoardMulty:SetActive(false)
  self:ResizeScrollview(true)
  self.currentVersion = version
  local versionData = QuestManualProxy.Instance:GetManualQuestDatas(version)
  if versionData then
    local data = versionData.main
    local questVersion
    for i = 1, #Table_QuestVersion do
      local ven = Table_QuestVersion[i]
      if ven.version == version then
        questVersion = ven
        break
      end
    end
    local mainStoryDescription = ZhString.QuestManual_TwoSpace
    if questVersion then
      mainStoryDescription = mainStoryDescription .. questVersion.VersionStory
      self.questName.text = questVersion.StoryName
    end
    if questVersion.VersionPic then
      PictureManager.Instance:SetPuzzleBG(questVersion.VersionPic, self.puzzleTexture)
    end
    local mainIdList = self:GetAllUnlockedMainStoryID(version, data.mainstoryid)
    for i = 1, #mainIdList do
      local mainstoryData = Table_MainStory[mainIdList[i]]
      if mainstoryData then
        local dialogData = DialogUtil.GetDialogData(mainstoryData.Mstory[1])
        mainStoryDescription = mainStoryDescription .. "\n" .. ZhString.QuestManual_TwoSpace .. dialogData.Text
      end
    end
    self.questDescription.text = mainStoryDescription
    self.progressScrollView:ResetPosition()
    local s, m = self:GetQuestProgress(data.questPreviewList)
    self.questProgress0.text = s
    self.questProgress1.text = "/" .. m
    self.mainQuestDetailDiv:SetActive(true)
    if #data.questList > 0 then
      local firstAcceptQuest
      for i = 1, #data.questList do
        local quest = data.questList[i]
        if quest.type == SceneQuest_pb.EQUESTLIST_ACCEPT or quest.type == SceneQuest_pb.EQUESTLIST_CANACCEPT then
          firstAcceptQuest = quest
          break
        end
      end
      if firstAcceptQuest then
        local isSingle = self:UpdateTraceBoardMulty(firstAcceptQuest)
        if isSingle then
          self.traceBoardSingle:SetActive(true)
          self:ResizeScrollview(false)
          self.traceBoardMulty:SetActive(false)
          self.traceBoardSingleCell:SetData(firstAcceptQuest)
        end
      end
    end
    if self.puzzleBoard.activeSelf then
      self:UpdatePuzzleBoard(data)
    elseif self.puzzleBackBoard.activeSelf then
      self:UpdatePuzzleBackBoard()
    end
  elseif self.puzzleBoard.activeSelf then
    self:UpdatePuzzleBoard(nil)
  elseif self.puzzleBackBoard.activeSelf then
    self:UpdatePuzzleBackBoard()
  end
end
function MainQuestPage:UpdateTraceBoardMulty(quest)
  local questData = quest.questData
  if questData.questDataStepType == QuestDataStepType.QuestDataStepType_ITEM then
    local relatedQuestList = quest.questSubs
    if relatedQuestList and #relatedQuestList > 0 then
      self.traceBoardSingle:SetActive(false)
      self.traceBoardMulty:SetActive(true)
      self:ResizeScrollview(false)
      local paramData = questData.params
      local item = paramData.item and paramData.item[1]
      local itemId = item and item.id or 0
      local totalNum = item and item.num or 0
      local itemIdNum = tonumber(itemId)
      local infoTable = Table_Item[itemIdNum]
      if infoTable and infoTable.Type == 160 then
        process = BagProxy.Instance:GetItemNumByStaticID(itemId, BagProxy.BagType.Quest) or 0
      else
        process = BagProxy.Instance:GetItemNumByStaticID(itemId) or 0
      end
      itemName = infoTable and infoTable.NameZh or nil
      self.collectTraceInfo.text = string.format(ZhString.QuestManual_GetDaily, itemName, process, totalNum)
      local tempTable = {}
      for i = 1, totalNum do
        if i <= process then
          tempTable[#tempTable + 1] = {Id = itemIdNum, isShow = true}
        else
          tempTable[#tempTable + 1] = {Id = itemIdNum, isShow = false}
        end
      end
      if #tempTable <= 10 then
        self.dailyCountGrid:SetActive(true)
        self.traceBoardMultyCoinScrollView.gameObject:SetActive(false)
        self.listControllerOfDailyCount:ResetDatas(tempTable)
      else
        self.dailyCountGrid:SetActive(false)
        self.traceBoardMultyCoinScrollView.gameObject:SetActive(true)
        self.listControllerOfDailyCountLong:ResetDatas(tempTable)
        self.traceBoardMultyCoinScrollView:ResetPosition()
      end
      self.listControllerOfQuestTrace:ResetDatas(relatedQuestList)
      return false
    end
    return true
  end
  return true
end
local tempV3, tempRot = LuaVector3(), LuaQuaternion()
function MainQuestPage:TriggerTraceBoardMultySize()
  if self.traceBoardScrollView.activeSelf then
    tempV3:Set(0, 0, 270)
    tempRot.eulerAngles = tempV3
    self.traceBoardButtonDownArrow.transform.localRotation = tempRot
    self.traceBoardList.height = 128
    self.traceBoardScrollView:SetActive(false)
  else
    tempV3:Set(0, 0, 90)
    tempRot.eulerAngles = tempV3
    self.traceBoardButtonDownArrow.transform.localRotation = tempRot
    self.traceBoardList.height = 336
    self.traceBoardScrollView:SetActive(true)
  end
end
function MainQuestPage:UpdatePuzzleBoard(mainData)
  local puzzleActiveList = self:GetQuestPuzzleActiveListByVersion(self.currentVersion)
  if puzzleActiveList and #puzzleActiveList > 0 then
    table.sort(puzzleActiveList, function(x, y)
      return x.indexss < y.indexss
    end)
    self.listControllerOfPuzzleBlocks:ResetDatas(puzzleActiveList)
    if mainData then
      local puzzleData = mainData.puzzle
      if puzzleData then
        local cells = self.listControllerOfPuzzleBlocks:GetCells()
        local openPuzzleList = puzzleData.open_puzzles
        local unlockPuzzleList = puzzleData.unlock_puzzles
        for i = 1, #cells do
          local cell = cells[i]
          local cellIndex = cell.data.indexss
          local isOpen = false
          for j = 1, #openPuzzleList do
            if cellIndex == openPuzzleList[j] then
              cell:OpenPuzze()
              isOpen = true
              break
            end
          end
          if not isOpen and self:GetPuzzleLightState(mainData.questList, cell.data.QuestIDs) then
            cell:UnlockPuzze()
          end
        end
      end
    end
  end
end
function MainQuestPage:UpdatePuzzleBackBoard()
  if self.puzzleAward.activeSelf then
    self:UpdatePuzzleAward()
  elseif self.mainQuestList.activeSelf then
    self:UpdateMainQuestList()
  end
end
function MainQuestPage:UpdatePuzzleAward()
  local puzzleCollectList = QuestManualProxy.Instance:GetQuestPuzzleCollectListByVersion(self.currentVersion)
  self.listControllerOfPuzzleAward:ResetDatas(puzzleCollectList)
end
function MainQuestPage:UpdateMainQuestList()
  local versionData = QuestManualProxy.Instance:GetManualQuestDatas(self.currentVersion)
  if versionData then
    self.listControllerOfQuestList:ResetDatas(versionData.main.questPreviewList)
    self.questscrollview:ResetPosition()
  end
end
function MainQuestPage:OnEnter()
end
function MainQuestPage:OnExit()
end
function MainQuestPage:addViewEventListener()
end
function MainQuestPage:AddListenerEvts()
  self:AddListenEvt(ServiceEvent.QuestOpenPuzzleQuestCmd, self.OpenPuzzle)
  self.listControllerOfPuzzleAward:AddEventListener(QuestManualEvent.ItemCellClick, self.ShowAwardItemTip, self)
end
function MainQuestPage:OpenPuzzle(data)
  local puzzleData = data and data.body
  local cells = self.listControllerOfPuzzleBlocks:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if cell.data.version == puzzleData.version and cell.data.indexss == puzzleData.id then
      cell:OpenPuzze()
      QuestManualProxy.Instance:OpenPuzzle(puzzleData.version, puzzleData.id)
      break
    end
  end
end
function MainQuestPage:GetQuestPuzzleActiveListByVersion(version)
  local puzzleList = {}
  for k, v in pairs(Table_QuestPuzzle) do
    if v.version == version and v.type == "active" then
      puzzleList[#puzzleList + 1] = v
    end
  end
  return puzzleList
end
function MainQuestPage:GetQuestProgress(questList)
  local finishCount = 0
  local totalCount = #questList
  for i = 1, #questList do
    if questList[i].complete then
      finishCount = finishCount + 1
    end
  end
  return finishCount, totalCount
end
function MainQuestPage:GetPuzzleLightState(mainQuestList, puzzleQuestIdList)
  local isUnlock = true
  if mainQuestList and #mainQuestList > 0 and puzzleQuestIdList and #puzzleQuestIdList > 0 then
    for i = 1, #puzzleQuestIdList do
      local puzzleQuestId = puzzleQuestIdList[i]
      local isQuestExist = false
      for j = 1, #mainQuestList do
        local mainQuest = mainQuestList[j]
        if mainQuest.questData.id == puzzleQuestId then
          isQuestExist = true
          if mainQuest.type ~= SceneQuest_pb.EQUESTLIST_SUBMIT then
            isUnlock = false
            break
          end
        end
      end
      if not isQuestExist then
        return false
      end
      if isUnlock then
      end
    end
  else
    return false
  end
  return isUnlock
end
function MainQuestPage:ShowAwardItemTip(cell)
  if cell.itemId then
    local itemData = ItemData.new("", cell.itemId)
    local data = {
      itemdata = itemData,
      funcConfig = {},
      noSelfClose = false
    }
    self:ShowItemTip(data, self.itemTipStick, NGUIUtil.AnchorSide.Right)
  end
end
function MainQuestPage:GetAllUnlockedMainStoryID(currentVersion, currentId)
  local mainIdList = {}
  for k, v in pairs(Table_MainStory) do
    if v.version == currentVersion and k <= currentId then
      mainIdList[#mainIdList + 1] = k
    end
  end
  return mainIdList
end
function MainQuestPage:ResizeScrollview(isExtended)
  if self.progressScrollView.panel then
    if isExtended then
      self.progressScrollView.panel.baseClipRegion = Vector4(0, -65, 546, 326 + Offset * 2)
    else
      self.progressScrollView.panel.baseClipRegion = Vector4(0, 0, 546, 326)
    end
  end
end
function MainQuestPage:OnDestroy()
  PictureManager.Instance:UnLoadPuzzleBG()
end
