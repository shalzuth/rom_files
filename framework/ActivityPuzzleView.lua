ActivityPuzzleView = class("ActivityPuzzleView", ContainerView)
ActivityPuzzleView.ViewType = UIViewType.NormalLayer
autoImport("ActivityGoalListCell")
autoImport("ActivityPuzzleCell")
autoImport("ActivityPuzzleGiftCell")
autoImport("ActivityPuzzleBlockCell")
autoImport("ItemCell")
autoImport("ColliderItemCell")
ActivityPuzzleView.ColorTheme = {
  [1] = {
    color = LuaColor.New(1, 1, 1, 1)
  },
  [2] = {
    color = LuaColor.New(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
  },
  [3] = {
    color = LuaColor.New(0, 0, 0, 1)
  },
  [4] = {
    color = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
  },
  [5] = {
    color = LuaColor.New(0.2549019607843137, 0.34901960784313724, 0.6666666666666666, 1)
  }
}
local GetAvaliableActivityList = function()
  local avaliableActivityList = {}
  local serverTime = ServerTime.CurServerTime() / 1000
  for i, v in ipairs(Table_ActivityInfo) do
    if serverTime > v.StartTimeStamp and serverTime < v.EndTimeStamp then
      table.insert(avaliableActivityList, v)
    end
  end
  return avaliableActivityList
end
local GetActivityPuzzleList = function(activityId)
  local activityPuzzleList = {}
  for i, v in ipairs(Table_ActivityPuzzle) do
    if v.ActivityID == activityId and v.UnlockType ~= 100 then
      table.insert(activityPuzzleList, v)
    end
  end
  return activityPuzzleList
end
local GetActivityPuzzleGiftList = function(activityId)
  local activityPuzzleList = {}
  for i, v in ipairs(Table_ActivityPuzzle) do
    if v.ActivityID == activityId and v.UnlockType == 100 then
      table.insert(activityPuzzleList, v)
    end
  end
  return activityPuzzleList
end
function ActivityPuzzleView:Init()
  self:GetGameObjects()
  self:addListEventListener()
  self:InitData()
  if self.defaultActivity then
    self:TabChangeHandler(self.defaultActivity)
  end
  self:StartActivityValidation()
end
function ActivityPuzzleView:InitData()
  local activityPuzzleDataList = ActivityPuzzleProxy.Instance:GetActivityPuzzleDataList()
  self.listControllerOfVersions:ResetDatas(activityPuzzleDataList)
  local cells = self.listControllerOfVersions:GetCells()
  for i = 1, #cells do
    local singleCell = cells[i]
    if i == 1 then
      self.defaultActivity = singleCell
    end
    self:AddTabChangeEvent(singleCell.gameObject, nil, singleCell)
  end
end
function ActivityPuzzleView:GetGameObjects()
  self.activityGrid = self:FindGO("activityGrid", self.gameObject)
  self.uiGridOfVersions = self.activityGrid:GetComponent(UIGrid)
  if self.listControllerOfVersions == nil then
    self.listControllerOfVersions = UIGridListCtrl.new(self.uiGridOfVersions, ActivityPuzzleCell, "ActivityPuzzleCell")
  end
  self.activityName = self:FindComponent("ActivityName", UILabel)
  self.puzzleBlockGrid = self:FindGO("puzzleBlockGrid")
  self.uiGridOfPuzzleBlocks = self.puzzleBlockGrid:GetComponent(UIGrid)
  if self.listControllerOfPuzzleBlocks == nil then
    self.listControllerOfPuzzleBlocks = UIGridListCtrl.new(self.uiGridOfPuzzleBlocks, ActivityPuzzleBlockCell, "PuzzleBlockCell")
  end
  self.goalListGrid = self:FindGO("GoalListGrid")
  self.goalScollview = self:FindGO("GoalListScrollView"):GetComponent(UIScrollView)
  self.uiGridOfGoalList = self.goalListGrid:GetComponent(UIGrid)
  if self.listControllerOfGoalList == nil then
    self.listControllerOfGoalList = UIGridListCtrl.new(self.uiGridOfGoalList, ActivityGoalListCell, "ActivityGoalListCell")
    self.listControllerOfGoalList:AddEventListener(MouseEvent.MouseClick, self.ShowReward, self)
    self.listControllerOfGoalList:AddEventListener(ActivityPuzzleGoEvent.MouseClick, self.ClickGoal, self)
  end
  self.giftGrid = self:FindComponent("giftGrid", UIGrid)
  self.giftListCtl = UIGridListCtrl.new(self.giftGrid, ActivityPuzzleGiftCell, "ImproveGiftCell")
  self.giftListCtl:AddEventListener(MouseEvent.MouseClick, self.ShowReward, self)
  self.puzzleRewardProgressBack = self:FindComponent("PuzzleRewardProgressBack", UISprite)
  self.puzzleRewardProgress = self:FindComponent("PuzzleRewardProgress", UISprite)
  self.activityPuzzleTitle = self:FindComponent("ActivityName", UILabel)
  self:AddButtonEvent("CloseButton", function()
    if self.activitytimeTick then
      self.activitytimeTick:ClearTick(self)
      self.activitytimeTick = nil
    end
    self:CloseSelf()
  end)
  self.rewardListPanel = self:FindGO("PanelRewardList", self.gameObject)
  self.rewardScrollView = self:FindComponent("RewardScrollView", UIScrollView)
  self.rewardGrid = self:FindComponent("RewardListGrid", UIGrid)
  if self.listControllerOfReward == nil then
    self.listControllerOfReward = UIGridListCtrl.new(self.rewardGrid, ColliderItemCell, "ColliderItemCell")
    self.listControllerOfReward:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  end
  self:AddButtonEvent("RewardListButtonClose", function()
    self.rewardListPanel:SetActive(false)
  end)
  self:AddButtonEvent("RewardListMaskClose", function()
    self.rewardListPanel:SetActive(false)
  end)
  self.puzzleHelpButton = self:FindGO("puzzleHelpButton")
  self:AddClickEvent(self.puzzleHelpButton, function(go)
    if self.currentActivityCell then
      local helpData = Table_Help[self.currentActivityCell.staticData.HelpID]
      if helpData then
        TipsView.Me():ShowGeneralHelp(helpData.Desc, helpData.Title)
      end
    end
  end)
  self.bg = self:FindGO("PuzzleTexture"):GetComponent(UITexture)
  self.tipstick = self:FindGO("BackTypeGoal"):GetComponent(UISprite)
end
function ActivityPuzzleView:addListEventListener()
  self:AddListenEvt(ServiceEvent.PuzzleCmdPuzzleItemNtf, self.RefreshAllData)
  self:AddListenEvt(ServiceEvent.PuzzleCmdActUpdatePuzzleCmd, self.InitData)
  self:AddListenEvt(ServiceEvent.PuzzleCmdActivePuzzleCmd, self.PlayEffect, self)
end
function ActivityPuzzleView:ClickItem(cell)
  local data = cell.data
  if data == nil then
    self:ShowItemTip()
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {},
    ignoreBounds = ignoreBounds,
    callback = callback,
    hideGetPath = true
  }
  self:ShowItemTip(sdata, self.tipstick, NGUIUtil.AnchorSide.Left, {-212, 0})
end
function ActivityPuzzleView:TabChangeHandler(cell)
  if self.currentActivityCell ~= cell then
    ActivityPuzzleView.super.TabChangeHandler(self, cell)
    self.currentActivityCell = cell
    self:handleCategoryClick(cell)
  end
end
function ActivityPuzzleView:handleCategoryClick(cell)
  self:handleCategorySelect(cell.data)
  local cells = self.listControllerOfVersions:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single == cell then
      single:setIsSelected(true)
    else
      single:setIsSelected(false)
    end
  end
  local currentPic = Table_ActivityInfo[cell.data.actid].PuzzlePic
  if currentPic and currentPic ~= "" then
    PictureManager.Instance:SetPuzzleBG(currentPic, self.bg)
  end
end
function ActivityPuzzleView:handleCategorySelect(data)
  self.activityPuzzleTitle.text = self.currentActivityCell.staticData.ActivityTitle
  self:RefreshAllData()
  self.goalScollview:ResetPosition()
end
function ActivityPuzzleView:RefreshAllData()
  self:UpdateGoalList()
  self:UpdateGiftProgress()
  self:UpdatePuzzleBoard()
end
function ActivityPuzzleView:UpdatePuzzleBoard()
  local puzzleActiveList = GetActivityPuzzleList(self.currentActivityCell.staticData.id)
  if puzzleActiveList and #puzzleActiveList > 0 then
    table.sort(puzzleActiveList, function(x, y)
      return x.PuzzleID < y.PuzzleID
    end)
    local lineCount = math.sqrt(self.currentActivityCell.staticData.Size)
    self.uiGridOfPuzzleBlocks.maxPerLine = lineCount
    self.uiGridOfPuzzleBlocks.cellWidth = 428 / lineCount
    self.uiGridOfPuzzleBlocks.cellHeight = 560 / lineCount
    self.listControllerOfPuzzleBlocks:ResetDatas(puzzleActiveList)
  end
end
function ActivityPuzzleView:UpdateGoalList()
  self.listControllerOfGoalList:ResetDatas(GetActivityPuzzleList(self.currentActivityCell.staticData.id))
end
function ActivityPuzzleView:HandleGiftLongPress(param)
  local state, cellCtl = param[1], param[2]
  if state then
    self.currentPressCell = cellCtl
    self.startPressTime = ServerTime.CurServerTime()
    if self.tickMg then
      self.tickMg:ClearTick(self)
    else
      self.tickMg = TimeTickManager.Me()
    end
    self.tickMg:CreateTick(0, 100, self.updatePressItemCount, self)
  elseif self.tickMg then
    self.tickMg:ClearTick(self)
    self.tickMg = nil
  end
end
function ActivityPuzzleView:updatePressItemCount()
  local holdTime = ServerTime.CurServerTime() - self.startPressTime
  local changeCount = 1
  if holdTime > 200 then
    local cellData = {
      rewardid = self.currentPressCell.data.RewardID
    }
    TipManager.Instance:ShowRewardListTip(cellData, self.currentPressCell.stick, NGUIUtil.AnchorSide.DownRight, {35, 35})
  end
end
function ActivityPuzzleView:UpdateGiftProgress()
  local totalGrowthValue = self.currentActivityCell.staticData.Size
  local currentProgress = ActivityPuzzleProxy.Instance:GetActivityPuzzleProgress(self.currentActivityCell.staticData.id)
  local unitWidth = 550 / totalGrowthValue
  self.puzzleRewardProgress.width = currentProgress * unitWidth
  self.puzzleRewardProgress.gameObject:SetActive(currentProgress ~= 0)
  self.giftListCtl:ResetDatas(GetActivityPuzzleGiftList(self.currentActivityCell.staticData.id))
  local cells = self.giftListCtl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateGiftState(currentProgress, unitWidth)
  end
  self.giftListCtl:Layout()
end
function ActivityPuzzleView:ShowReward(cell)
  self.rewardListPanel:SetActive(true)
  local itemList = ItemUtil.GetRewardItemIdsByTeamId(cell.data.RewardID)
  local itemDataList = {}
  if itemList and #itemList > 0 then
    for i = 1, #itemList do
      local itemInfo = itemList[i]
      local tempItem = ItemData.new("", itemInfo.id)
      tempItem.num = itemInfo.num
      itemDataList[#itemDataList + 1] = tempItem
    end
    self.listControllerOfReward:ResetDatas(itemDataList)
  end
  self.rewardScrollView:ResetPosition()
end
function ActivityPuzzleView:ClickGoal(cell)
  FuncShortCutFunc.Me():CallByID(cell.data.GotoMode)
  self:CloseSelf()
end
function ActivityPuzzleView:StartActivityValidation()
  if not self.activitytimeTick then
    self.activitytimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateValidationTick, self, 22)
  end
end
function ActivityPuzzleView:UpdateValidationTick()
  local serverTime = ServerTime.CurServerTime() / 1000
  for k, v in pairs(Table_ActivityInfo) do
    if serverTime > v.StartTimeStamp and serverTime < v.EndTimeStamp then
      if ActivityPuzzleProxy.Instance:AddToActivityPuzzleDataMap(k) then
        self:InitData()
      end
    else
      ActivityPuzzleProxy.Instance:RemoveFromActivityPuzzleDataMap(k)
      self:InitData()
    end
  end
end
function ActivityPuzzleView:PlayEffect(msg)
  local pCells = self.listControllerOfPuzzleBlocks:GetCells()
  for k, v in pairs(pCells) do
    if v.data and v.data.PuzzleID == msg.body.puzzleid then
      v:PlayEffect()
      break
    end
  end
end
function ActivityPuzzleView:OnDestroy()
  PictureManager.Instance:UnLoadPuzzleBG()
end
function ActivityPuzzleView:OnExit()
  if self.activitytimeTick then
    self.activitytimeTick:ClearTick(self)
    self.activitytimeTick = nil
  end
end
