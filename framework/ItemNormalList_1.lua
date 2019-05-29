ItemNormalList = class("ItemNormalList", CoreView)
ItemNormalList.TabType = {
  ItemPage = 1,
  FashionPage = 3,
  Temp = 8,
  Quest = 10,
  FoodPage = 11
}
local FoodPackPage = GameConfig.FoodPackPage
ItemNormalList.TabConfig = {
  [1] = {Config = nil},
  [2] = {
    Config = GameConfig.ItemPage[1]
  },
  [3] = {
    Config = GameConfig.ItemPage[2]
  },
  [4] = {
    Config = GameConfig.ItemPage[3]
  },
  [5] = {
    Config = GameConfig.ItemPage[4]
  },
  [6] = {
    Config = FoodPackPage[1]
  },
  [7] = {
    Config = FoodPackPage[2]
  },
  [8] = {
    config = GameConfig.ItemPage[5]
  }
}
local Func_IsFoodPackageConfig = function(tabConfig)
  for i = 1, #FoodPackPage do
    if tabConfig == FoodPackPage[i] then
      return true
    end
  end
  return false
end
autoImport("ItemTabCell")
autoImport("WrapListCtrl")
autoImport("BagCombineItemCell")
ItemNormalList.PullRefreshTip = ZhString.ItemNormalList_PullRefresh
ItemNormalList.BackRefreshTip = ZhString.ItemNormalList_CanRefresh
ItemNormalList.RefreshingTip = ZhString.ItemNormalList_Refreshing
function ItemNormalList:ctor(go, control, isAddMouseClickEvent, scrollType, isShowFavoriteTab)
  if go then
    self.scrollType = scrollType or ROUIScrollView
    ItemNormalList.super.ctor(self, go)
    self.control = control or BagCombineItemCell
    if isAddMouseClickEvent == true or isAddMouseClickEvent == nil then
      self.isAddMouseClickEvent = true
    else
      self.isAddMouseClickEvent = false
    end
    if isShowFavoriteTab then
      self.isShowFavoriteTab = true
    end
    self:Init()
  else
    error("can not find itemListObj")
  end
end
function ItemNormalList:Init()
  self.tabScrollView = self:FindComponent("ItemTabsScrollView", UIScrollView)
  self.itemTabs = self:FindComponent("ItemTabs", UIGrid)
  self.tabCtl = UIGridListCtrl.new(self.itemTabs, ItemTabCell, "ItemTabCell")
  self.tabCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItemTab, self)
  self:UpdateTabList()
  local itemContainer = self:FindGO("bag_itemContainer")
  self.wraplist = WrapListCtrl.new(itemContainer, self.control, "BagCombineItemCell", WrapListCtrl_Dir.Vertical)
  if self.isAddMouseClickEvent then
    self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
    self.wraplist:AddEventListener(MouseEvent.DoubleClick, self.HandleDClickItem, self)
  end
  self.waitting = self:FindComponent("Waitting", UILabel)
  self.scrollView = self:FindComponent("ItemScrollView", self.scrollType)
  self.panel = self.scrollView.gameObject:GetComponent(UIPanel)
  function self.scrollView.OnBackToStop()
    if not self.waitting then
      return
    end
    self.waitting.text = self.RefreshingTip
  end
  function self.scrollView.OnStop()
    self:ScrollViewRevert()
  end
  function self.scrollView.OnPulling(offsetY, triggerY)
    if not self.waitting then
      return
    end
    self.waitting.text = offsetY < triggerY and self.PullRefreshTip or self.BackRefreshTip
  end
  function self.scrollView.OnRevertFinished()
    if not self.waitting then
      return
    end
    self.waitting.text = self.PullRefreshTip
    if self.revertCallBack then
      self.revertCallBack()
    end
  end
  function self.scrollView.onDragStarted()
    if self.initPanelClipMove == nil then
      self:AddPanelClipMove()
      self.initPanelClipMove = true
    end
    if self.scrollView.canMoveVertically then
      self.panelClipOffset = self.panel.clipOffset.y
    elseif self.scrollView.canMoveHorizontally then
      self.panelClipOffset = self.panel.clipOffset.x
    end
  end
  function self.scrollView.onDragFinished()
    self.panelClipOffset = nil
    self.isDrag = false
    self:SetCellScrollView(false)
  end
end
function ItemNormalList:ClickItemTab(cell)
  local data = cell.data
  if data == nil then
    return
  end
  self.nowTabData = data
  local noResetPos
  if self.isShowFavoriteTab and self.isMarkingFavorite then
    noResetPos = true
  end
  self:UpdateList(noResetPos)
  GuideMaskView.getInstance():showGuideByQuestDataRepeat()
  self:PassEvent(ItemEvent.ClickItemTab, cell)
end
function ItemNormalList:UpdateTabList(tabType)
  tabType = tabType or ItemNormalList.TabType.ItemPage
  if self.tabDatas == nil then
    self.tabDatas = {}
  else
    TableUtility.ArrayClear(self.tabDatas)
  end
  local tabDataDefault = {
    index = 0,
    Config = nil,
    tabType = tabType
  }
  if tabType == ItemNormalList.TabType.ItemPage or tabType == ItemNormalList.TabType.Temp then
    table.insert(self.tabDatas, tabDataDefault)
    for i = 1, 4 do
      local data = {
        index = i,
        tabType = tabType,
        Config = GameConfig.ItemPage[i]
      }
      table.insert(self.tabDatas, data)
    end
    if self.isShowFavoriteTab then
      local data = {index = -1, tabType = tabType}
      table.insert(self.tabDatas, 2, data)
      self.itemTabs.cellWidth = 71.7
    end
  elseif tabType == ItemNormalList.TabType.FashionPage then
    for i = 1, 8 do
      local data = {index = i, tabType = tabType}
      table.insert(self.tabDatas, data)
    end
  elseif tabType == ItemNormalList.TabType.FoodPage then
    table.insert(self.tabDatas, tabDataDefault)
    for i = 1, #GameConfig.FoodPackPage do
      local data = {
        index = i,
        tabType = tabType,
        Config = GameConfig.FoodPackPage[i]
      }
      table.insert(self.tabDatas, data)
    end
  elseif tabType == ItemNormalList.TabType.Quest then
    local data = {
      index = 0,
      tabType = tabType,
      Config = GameConfig.ItemPage[5]
    }
    table.insert(self.tabDatas, data)
  else
    table.insert(self.tabDatas, tabDataDefault)
  end
  self:SetTabDatas(self.tabDatas)
end
function ItemNormalList:SetTabDatas(datas)
  self.tabCtl:ResetDatas(datas)
  if self.tabScrollView then
    self.tabScrollView:ResetPosition()
  end
end
function ItemNormalList:AddPanelClipMove()
  self.panel.onClipMove = {
    "+=",
    function(panel)
      if self.panelClipOffset and not self.isDrag then
        local clipOffset
        if self.scrollView.canMoveVertically then
          clipOffset = self.panel.clipOffset.y
        elseif self.scrollView.canMoveHorizontally then
          clipOffset = self.panel.clipOffset.x
        end
        if math.abs(self.panelClipOffset - clipOffset) > 1 then
          self.isDrag = true
          self:SetCellScrollView(true)
        end
      end
    end
  }
end
function ItemNormalList:SetCellScrollView(isDrag)
  local combineCells = self.wraplist:GetCells()
  for i = 1, #combineCells do
    local cell = combineCells[i]
    for j = 1, #cell:GetCells() do
      local childCell = cell:GetCells()[j]
      if childCell.data then
        if childCell.dragDrop then
          childCell.dragDrop:SetScrollView(isDrag)
        else
          break
        end
      end
    end
  end
end
function ItemNormalList:HandleClickItem(cellCtl)
  self:PassEvent(ItemEvent.ClickItem, cellCtl)
end
function ItemNormalList:HandleDClickItem(cellCtl)
  self:PassEvent(ItemEvent.DoubleClickItem, cellCtl)
end
function ItemNormalList:ChooseTab(tab)
  local cells = self.tabCtl:GetCells()
  if cells == nil then
    return
  end
  local cell = cells[tab]
  if cell == nil then
    return
  end
  cell:SetTog(true)
  self:ClickItemTab(cell)
end
function ItemNormalList:SetTabToggleGroup(g)
  g = g or 12
  local cells = self.tabCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetGroup(g)
  end
end
function ItemNormalList:UpdateList(noResetPos)
  if self.nowTabData == nil then
    self:SetData(_EmptyTable, true)
    return
  end
  local datas = self.GetTabDatas(self.nowTabData.Config, self.nowTabData)
  self:SetData(datas, noResetPos)
end
function ItemNormalList:SetData(datas, noResetPos)
  if not noResetPos then
    self:ResetPosition()
  end
  self.wraplist:ResetDatas(self:ReUnitData(datas, 5))
end
function ItemNormalList:ResetPosition()
  if self.wraplist == nil then
    return
  end
  self.wraplist:ResetPosition()
end
function ItemNormalList:ReUnitData(datas, rowNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / rowNum) + 1
      local i2 = math.floor((i - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      if datas[i] == nil then
        self.unitData[i1][i2] = nil
      else
        self.unitData[i1][i2] = datas[i]
      end
    end
  end
  return self.unitData
end
function ItemNormalList:SetScrollPullDownEvent(evt, evtParam)
  function self.scrollView.OnStop()
    if type(evt) == "function" then
      evt(evtParam)
    end
  end
end
function ItemNormalList:ScrollViewRevert(callback)
  self.revertCallBack = callback
  self.scrollView:Revert()
end
local tabDatas = {}
function ItemNormalList.GetTabDatas(tabConfig, tabData)
  TableUtility.ArrayClear(tabDatas)
  local datas
  if Func_IsFoodPackageConfig(tabConfig) then
    datas = BagProxy.Instance.foodBagData:GetItems(tabConfig)
  elseif tabconfig == GameConfig.ItemPage[5] then
    datas = BagProxy.Instance.questBagData:GetItems(tabConfig)
  else
    datas = BagProxy.Instance.bagData:GetItems(tabConfig)
  end
  for i = 1, #datas do
    table.insert(tabDatas, datas[i])
  end
  return tabDatas
end
function ItemNormalList:AddCellEventListener(eventType, handler, handlerOwner)
  self.wraplist:AddEventListener(eventType, handler, handlerOwner)
end
function ItemNormalList:GetItemCells()
  local combineCells = self.wraplist:GetCells()
  local result = {}
  for i = 1, #combineCells do
    local v = combineCells[i]
    local childs = v:GetCells()
    for i = 1, #childs do
      table.insert(result, childs[i])
    end
  end
  return result
end
