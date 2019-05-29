AdventureResearchPage = class("AdventureResearchPage", SubView)
autoImport("AdventureResearchCategoryCell")
autoImport("AdventureResearchDescriptionCell")
autoImport("AdventureResearchCombineItemCell")
AdventureResearchPage.ShowFilterConditionId = 10001
AdventureResearchPage.DataFromMenuId = 10004
function AdventureResearchPage:Init()
  self:AddViewEvts()
  self:initView()
  self:initData()
  self.cureTab = nil
  self.LRUTextureCache = {}
  self.maxCache = 100
  self.selectData = nil
  self.professionSelected = false
end
function AdventureResearchPage:initData()
  local categorys = AdventureDataProxy.Instance:getTabsByCategory(SceneManual_pb.EMANUALTYPE_RESEARCH)
  local list = {}
  for k, v in pairs(categorys.childs) do
    table.insert(list, v)
  end
  table.sort(list, function(l, r)
    return l.staticData.Order < r.staticData.Order
  end)
  self.researchCategoryGrid:ResetDatas(list)
end
function AdventureResearchPage:initView()
  self.gameObject = self:FindGO("AdventureResearchPage")
  self.categoryScrollView = self:FindComponent("ResearchCategoryScrollView", UIScrollView)
  local ResearchTabTitle = self:FindComponent("ResearchTabTitle", UILabel)
  ResearchTabTitle.text = ZhString.AdventurePanel_ResearchTabTitle
  self.FilterCondition = self:FindComponent("FilterCondition", UIToggle)
  self.FilterConditionLabel = self:FindComponent("Label", UILabel, self.FilterCondition.gameObject)
  self.FilterConditionLabel.text = ZhString.AdventurePanel_FilterConditionLabel
  self:AddClickEvent(self.FilterCondition.gameObject, function(obj)
    self.professionSelected = self.FilterCondition.value
    self:tabClick(self.selectTabData)
  end)
  local ResearchCategoryGrid = self:FindComponent("ResearchCategoryGrid", UIGrid)
  self.researchCategoryGrid = UIGridListCtrl.new(ResearchCategoryGrid, AdventureResearchCategoryCell, "AdventureResearchCategoryCell")
  self.researchCategoryGrid:AddEventListener(MouseEvent.MouseClick, self.categoryCellClick, self)
  self.ResearchDescriptionList = self:FindGO("ResearchDescriptionList")
  self.ResearchDescScrollView = self:FindComponent("ItemScrollView", ROUIScrollView, self.ResearchDescriptionList)
  local descGrid = self:FindComponent("ResearchDescriptionGrid", UIGrid)
  self.descriptionGrid = UIGridListCtrl.new(descGrid, AdventureResearchDescriptionCell, "AdventureResearchDescriptionCell")
  self.descriptionGrid:AddEventListener(MouseEvent.MouseClick, self.descCellClick, self)
  self.OneItemTabs = self:FindGO("OneItemTabs"):GetComponent(UILabel)
  self.itemTabs = self:FindGO("ItemTabs"):GetComponent(UIPopupList)
  self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
  EventDelegate.Add(self.itemTabs.onChange, function()
    if self.selectTabData ~= self.itemTabs.data then
      self.selectTabData = self.itemTabs.data
      self:tabClick(self.selectTabData)
    end
  end)
  self:initItemWraperView()
end
function AdventureResearchPage:initItemWraperView()
  self.ResearchItemList = self:FindGO("ResearchItemList")
  local itemContainer = self:FindGO("bag_itemContainer")
  local pfbNum = 6
  local rt = Screen.height / Screen.width
  if rt > 0.5625 then
    pfbNum = 10
  end
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = pfbNum,
    cellName = "AdventureBagCombineItemCell",
    control = AdventureResearchCombineItemCell,
    dir = 1
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.ItemWraperScrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  function self.ItemWraperScrollView.OnStop()
    self.ItemWraperScrollView:Revert()
  end
  self.tipHolder = self:FindComponent("ScrollBg", UIWidget, self.ResearchItemList)
end
function AdventureResearchPage:categoryCellClick(cellCtl)
  self:setCategoryData(cellCtl.data)
  local cells = self.researchCategoryGrid:GetCells()
  if cells and #cells > 0 then
    for i = 1, #cells do
      local cell = cells[i]
      if cell == cellCtl then
        cell:setSelected(true)
      else
        cell:setSelected(false)
      end
    end
  end
end
function AdventureResearchPage:descCellClick(cellCtl)
  local data = cellCtl.data
  if data then
    local GotoMode = data.GotoMode
    FuncShortCutFunc.Me():CallByID(GotoMode)
  end
end
function AdventureResearchPage:setCategoryData(data)
  self.data = data
  local list = {}
  if data and data.classifys and #data.classifys > 0 then
    for i = 1, #data.classifys do
      local single = data.classifys[i]
      table.insert(list, single)
    end
    table.sort(list, function(l, r)
      return l.Order < r.Order
    end)
    if #list < 2 then
      list = {}
      self:Hide(self.itemTabs.gameObject)
      self.OneItemTabs.text = data.staticData.Name
      self:Show(self.OneItemTabs.gameObject)
      self:tabClick()
    else
      self:Hide(self.OneItemTabs)
      self:Show(self.itemTabs.gameObject)
      local tmpData = {}
      tmpData.id = AdventureItemNormalListPage.MaxCategory.id
      tmpData.Name = string.format(ZhString.AdventurePanel_AllTab, data.staticData.Name)
      table.insert(list, 1, tmpData)
    end
    self.itemTabs:Clear()
    for i = 1, #list do
      local single = list[i]
      if single.id then
        self.itemTabs:AddItem(single.Name, single)
      end
    end
    if #list > 1 then
      self.itemTabs.value = list[1].Name
    end
    if data.staticData.id == AdventureResearchPage.ShowFilterConditionId then
      self:Show(self.FilterCondition.gameObject)
    else
      self:Hide(self.FilterCondition.gameObject)
    end
  else
    self:Hide(self.FilterCondition.gameObject)
    self:Hide(self.itemTabs.gameObject)
    self:Hide(self.OneItemTabs)
    self:tabClick()
  end
end
function AdventureResearchPage:checkSelect()
  if self.itemTabs.isOpen then
    self:Show(self.ItemTabsBgSelect)
  else
    self:Hide(self.ItemTabsBgSelect)
  end
end
function AdventureResearchPage:tabClick(selectTabData, noResetPos)
  if not self.data then
    return
  end
  self.selectTabData = selectTabData
  if self.data.staticData.id == AdventureResearchPage.DataFromMenuId then
    self:Hide(self.ResearchItemList)
    self:Show(self.ResearchDescriptionList)
    local descDatas = {}
    for k, v in pairs(Table_GameFunction) do
      table.insert(descDatas, v)
    end
    table.sort(descDatas, function(l, r)
      return l.Order < r.Order
    end)
    table.sort(descDatas, function(l, r)
      if FunctionUnLockFunc.Me():CheckCanOpen(l.MenuID) and FunctionUnLockFunc.Me():CheckCanOpen(r.MenuID) then
        return l.Order < r.Order
      elseif FunctionUnLockFunc.Me():CheckCanOpen(l.MenuID) then
        return true
      else
        return false
      end
    end)
    self.descriptionGrid:ResetDatas(descDatas)
  else
    self:Hide(self.ResearchDescriptionList)
    self:Show(self.ResearchItemList)
    local datas
    if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
      datas = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(self.data.staticData.id, self.professionSelected, selectTabData.id)
    else
      datas = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(self.data.staticData.id, self.professionSelected, nil)
    end
    self:SetData(datas, noResetPos)
  end
end
function AdventureResearchPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneManualManualUpdate, self.HandleManualUpdate)
  self:AddListenEvt(ServiceEvent.NUserNewMenu, self.HandleNUserNewMenu)
end
function AdventureResearchPage:HandleManualUpdate(note)
  self:tabClick(self.selectTabData, true)
end
function AdventureResearchPage:HandleNUserNewMenu(note)
  self:Log("HandleNUserNewMenu")
end
function AdventureResearchPage:OnEnter()
  TimeTickManager.Me():CreateTick(0, 500, self.checkSelect, self)
  self:ClearSelectData()
end
function AdventureResearchPage:resetSelectState(datas, noResetPos)
  if not noResetPos and self.gameObject.activeSelf then
    self.wraplist:ResetPosition()
    if self.chooseItem and self.chooseItemData then
      self.chooseItemData:setIsSelected(false)
      self.chooseItem:setIsSelected(false)
    end
    self:ClearSelectData()
  end
end
function AdventureResearchPage:ShowSelf(obj)
  self:Show()
  local cells = self.researchCategoryGrid:GetCells()
  if cells and #cells > 0 then
    local cell = cells[1]
    self:categoryCellClick(cell)
  end
  self.categoryScrollView:ResetPosition()
  self:initData()
end
function AdventureResearchPage:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self:ClearSelectData()
end
function AdventureResearchPage:SetData(datas, noResetPos)
  datas = datas or {}
  self:resetSelectState(datas, noResetPos)
  local newdata = self:ReUnitData(datas, 5)
  self.wraplist:UpdateInfo(newdata)
  self.selectData = nil
  local defaultItem = self:getDefaultSelectedItemData()
  if not noResetPos then
    self.wraplist:ResetPosition()
  end
end
function AdventureResearchPage:getDefaultSelectedItemData()
  local cells = self:GetItemCells() or {}
  if #cells > 0 then
    if self.chooseItemData then
      for i = 1, #cells do
        local single = cells[i]
        if single.data then
          return single
        end
      end
    else
      for i = 1, #cells do
        local cell = cells[i]
        if cell.data then
          return cell
        end
      end
    end
  end
end
function AdventureResearchPage:ReUnitData(datas, rowNum)
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
function AdventureResearchPage:HandleClickItem(cellCtl, noClickSound)
  if cellCtl and cellCtl.data then
    local data = cellCtl.data
    if self.chooseItem ~= cellCtl or data ~= self.chooseItemData then
      if self.chooseItemData then
        self.chooseItemData:setIsSelected(false)
      end
      if self.chooseItem then
        self.chooseItem:setIsSelected(false)
      end
      if not noClickSound then
        self:PlayUISound(AudioMap.UI.Click)
      end
      data:setIsSelected(true)
      cellCtl:setIsSelected(true)
      self:ShowItemTip(data)
      self.chooseItem = cellCtl
      self.chooseItemData = data
    elseif self.chooseItem == cellCtl or data == self.chooseItemData then
      self:ClearSelectData()
    end
  end
end
function AdventureResearchPage:ShowItemTip(data)
  if data.type == SceneManual_pb.EMANUALTYPE_MATE then
    TipManager.Instance:ShowCatTipById(data:getCatId(), self.tipHolder, NGUIUtil.AnchorSide.Right, {200, 0})
  else
    local item = ItemData.new(data.id, data.staticId)
    TipManager.Instance:ShowFormulaTip(item, self.tipHolder, NGUIUtil.AnchorSide.Right, {200, 347})
  end
end
function AdventureResearchPage:ClearSelectData()
  if self.chooseItemData then
    self.chooseItemData:setIsSelected(false)
  end
  if self.chooseItem then
    self.chooseItem:setIsSelected(false)
  end
  self.chooseItem = nil
  self.chooseItemData = nil
  TipManager.Instance:HideCatTip()
end
function AdventureResearchPage:GetItemCells()
  local combineCells = self.wraplist:GetCellCtls()
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
