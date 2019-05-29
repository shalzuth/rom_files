AdventureItemNormalListPage = class("AdventureItemNormalListPage", SubView)
autoImport("AdventureNormalList")
autoImport("AdventureCombineItemCell")
autoImport("AdventureSceneList")
AdventureItemNormalListPage.MaxCategory = {
  id = 99999999,
  value = {}
}
function AdventureItemNormalListPage:Init()
  self:AddViewEvts()
  self:initView()
  self.cureTab = nil
end
function AdventureItemNormalListPage:initView()
  self.gameObject = self:FindGO("SceneryNormalListPage")
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  local tipHolder = self:FindGO("tipHolder")
  local listObj = self:FindGO("normalList")
  self.normalList = AdventureNormalList.new(listObj, tipHolder, AdventureCombineItemCell)
  self.normalList:AddEventListener(AdventureNormalList.UpdateCellRedTip, self.updateCellTip, self)
  listObj = self:FindGO("sceneryList")
  self.sceneList = AdventureSceneList.new(listObj)
  self.sceneList:AddEventListener(PersonalPicturePanel.GetPersonPicThumbnail, self.GetPersonPicThumbnail, self)
  self.itemlist = self.normalList
  self.OneItemTabs = self:FindGO("OneItemTabs"):GetComponent(UILabel)
  self.itemTabs = self:FindGO("ItemTabs"):GetComponent(UIPopupList)
  self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
  EventDelegate.Add(self.itemTabs.onChange, function()
    if self.selectTabData ~= self.itemTabs.data then
      self.selectTabData = self.itemTabs.data
      self:tabClick(self.selectTabData)
      self.itemlist:SetPropData(nil, nil)
    end
  end)
  self.PropTypeBtn = self:FindGO("PropTypeBtn")
  local propTypeName = self:FindComponent("Label", UILabel, self.PropTypeBtn)
  propTypeName.text = ZhString.AdventureFoodPage_FilterDesc
  local selectbg = self:FindComponent("PropTypeBtnSelectBg", UISprite, self.PropTypeBtn)
  self:AddClickEvent(self.PropTypeBtn, function()
    TipManager.Instance:ShowPropTypeTip({
      callback = self.filterPropCallback,
      param = self
    }, selectbg, NGUIUtil.AnchorSide.AnchorSide, {-90, -50})
  end)
end
function AdventureItemNormalListPage:filterPropCallback(propData, keys)
  self.itemlist:SetPropData(propData, keys)
  self:UpdateList()
end
function AdventureItemNormalListPage:updateCellTip(data)
  local cellCtl = data.ctrl
  local ret = data.ret
  if ret and cellCtl and cellCtl.data and cellCtl.data.staticData.RedTip then
    self:RegisterRedTipCheck(cellCtl.data.staticData.RedTip, cellCtl.bg, nil, {-15, -15})
  elseif ret or not cellCtl.data or not cellCtl.data.staticData or cellCtl.data.staticData.RedTip then
  end
end
function AdventureItemNormalListPage:checkSelect()
  if self.itemTabs.isOpen then
    self:Show(self.ItemTabsBgSelect)
  else
    self:Hide(self.ItemTabsBgSelect)
  end
end
function AdventureItemNormalListPage:tabClick(selectTabData, noResetPos)
  if self.itemlist then
    self.itemlist:removeTip()
  end
  self.selectTabData = selectTabData
  if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
    self.itemlist:setCategoryAndTab(self.data, selectTabData)
  else
    self.itemlist:setCategoryAndTab(self.data, nil)
  end
  self:UpdateList(noResetPos)
end
function AdventureItemNormalListPage:setCurTabNameAndScore(data)
  local bagData = AdventureDataProxy.Instance.bagMap[self.data.id]
  local total, curScore
  if data.id then
    local tab = bagData:GetTab(data.id)
    total = tab.totalCount
    curScore = tab.curUnlockCount
    if data.icon == "" then
    end
  else
    total = bagData.totalCount
    curScore = bagData.curUnlockCount
  end
end
function AdventureItemNormalListPage:setCategoryData(data)
  self.data = data
  local list = {}
  if self.itemlist then
    self.itemlist:SetPropData(nil, nil)
  end
  if data and data.childs then
    if self.itemlist then
      self.itemlist:removeTip()
    end
    if self.data and self.data.staticData.id == SceneManual_pb.EMANUALTYPE_SCENERY then
      self.sceneList:Show()
      self.normalList:Hide()
      self.itemlist = self.sceneList
    else
      self.sceneList:Hide()
      self.normalList:Show()
      self.itemlist = self.normalList
    end
    if self.data and (self.data.staticData.id == SceneManual_pb.EMANUALTYPE_FASHION or self.data.staticData.id == SceneManual_pb.EMANUALTYPE_CARD or self.data.staticData.id == SceneManual_pb.EMANUALTYPE_COLLECTION) then
      self:Show(self.PropTypeBtn)
    else
      self:Hide(self.PropTypeBtn)
    end
    for k, v in pairs(data.childs) do
      table.insert(list, v.staticData)
    end
    table.sort(list, function(l, r)
      return l.Order < r.Order
    end)
    if #list < 2 then
      list = {}
      self:Hide(self.itemTabs.gameObject)
      self.OneItemTabs.text = string.format(ZhString.AdventurePanel_Row, data.staticData.Name)
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
  end
end
function AdventureItemNormalListPage:UpdateList(noResetPos)
  self.itemlist:UpdateList(noResetPos)
end
function AdventureItemNormalListPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneManualManualUpdate, self.HandleManualUpdate)
  self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadProgressCallback, self.SceneryThumbnailPhDlPgCallback)
  self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadCompleteCallback, self.SceneryThumbnailPhDlCpCallback)
  self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadErrorCallback, self.SceneryThumbnailPhDlErCallback)
end
function AdventureItemNormalListPage:SceneryThumbnailPhDlPgCallback(note)
  local data = note.body
  local cell = self:getCellBySceneryId(data.index)
  MySceneryPictureManager.Instance():log("SceneryThumbnailPhDlPgCallback:", data.index, data.progress)
  if cell and cell.data.roleId == data.roleId then
    cell:setDownloadProgress(data.progress)
  end
end
function AdventureItemNormalListPage:SceneryThumbnailPhDlCpCallback(note)
  local data = note.body
  local cell = self:getCellBySceneryId(data.index)
  if cell and cell.data.roleId == data.roleId then
    self:GetPersonPicThumbnail(cell)
  end
end
function AdventureItemNormalListPage:GetPersonPicThumbnail(cellCtl)
  MySceneryPictureManager.Instance():log("GetPersonPicThumbnail")
  if cellCtl and cellCtl.data then
    MySceneryPictureManager.Instance():GetAdventureSceneryPicThumbnail(cellCtl)
  end
end
function AdventureItemNormalListPage:SceneryThumbnailPhDlErCallback(note)
  local data = note.body
  local cell = self:getCellBySceneryId(data.index)
  if cell and cell.data.roleId == data.roleId then
    cell:setDownloadFailure()
  end
end
function AdventureItemNormalListPage:getCellBySceneryId(sceneryId)
  local cells = self.sceneList:GetItemCells()
  for i = 1, #cells do
    local single = cells[i]
    if single.data and single.data.staticId == sceneryId then
      return single
    end
  end
end
function AdventureItemNormalListPage:HandleManualUpdate(note)
  local selectTabData = self.selectTabData
  local data = note.body
  local type = data.update.type
  if self.data and self.gameObject.activeSelf and self.data.staticData.id == type then
    if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
      self.itemlist:setCategoryAndTab(self.data, selectTabData)
    else
      self.itemlist:setCategoryAndTab(self.data, nil)
    end
    self:UpdateList(true)
  end
end
function AdventureItemNormalListPage:OnEnter()
  TimeTickManager.Me():CreateTick(0, 100, self.checkSelect, self)
  self.sceneList:OnEnter()
  self.normalList:OnEnter()
end
function AdventureItemNormalListPage:ShowSelf()
  self:Show()
end
function AdventureItemNormalListPage:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self.sceneList:OnExit()
  self.normalList:OnExit()
end
