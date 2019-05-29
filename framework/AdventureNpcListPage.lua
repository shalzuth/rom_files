autoImport("AdventureCombineNpcCell")
autoImport("AdventureTagItemList")
AdventureNpcListPage = class("AdventureNpcListPage", SubView)
AdventureNpcListPage.ClickReward = "AdventureNpcListPage_ClickReward"
function AdventureNpcListPage:Init()
  self:initView()
  self:AddEvents()
end
function AdventureNpcListPage:initView()
  self.gameObject = self:FindGO("AdventureNpcListPage")
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  local tipHolder = self:FindGO("tipHolder")
  local listObj = self:FindGO("normalList")
  self.tagItemList = AdventureTagItemList.new(listObj, tipHolder, AdventureCombineNpcCell)
  self.tagItemList:AddEventListener(AdventureNormalList.UpdateCellRedTip, self.updateCellTip, self)
  self.OneItemTabs = self:FindComponent("OneItemTabs", UILabel)
  self.itemTabs = self:FindGO("ItemTabs"):GetComponent(UIPopupList)
  self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
  EventDelegate.Add(self.itemTabs.onChange, function()
    if self.selectTabData ~= self.itemTabs.data then
      self.selectTabData = self.itemTabs.data
      self:tabClick(self.selectTabData)
      self.tagItemList:SetPropData(nil, nil)
    end
  end)
  self:AddClickEvent(self:FindGO("btnHelp"), function()
    self:OnClickBtnHelp()
  end)
end
function AdventureNpcListPage:AddEvents()
  self:AddListenEvt(ServiceEvent.SceneManualManualUpdate, self.HandleManualUpdate)
  self:AddListenEvt(ServiceEvent.SceneManualNpcZoneDataManualCmd, self.RefreshZoneTags)
  self:AddListenEvt(ServiceEvent.SceneManualNpcZoneRewardManualCmd, self.RefreshZoneTags)
  self.tagItemList:AddListEventListener(AdventureNpcListPage.ClickReward, self.ClickZoneReward, self)
end
local listPopUpItems = {}
function AdventureNpcListPage:setCategoryData(data)
  self.data = data
  if self.tagItemList then
    self.tagItemList:SetPropData(nil, nil)
    self.tagItemList:Reset()
  end
  if not data or not data.childs then
    return
  end
  if self.tagItemList then
    self.tagItemList:removeTip()
  end
  self.OneItemTabs.text = string.format(ZhString.AdventurePanel_Row, data.staticData.Name)
  TableUtility.ArrayClear(listPopUpItems)
  for k, v in pairs(data.childs) do
    table.insert(listPopUpItems, v.staticData)
  end
  table.sort(listPopUpItems, function(l, r)
    return l.Order < r.Order
  end)
  self.itemTabs:Clear()
  if #listPopUpItems < 2 then
    self:Hide(self.itemTabs.gameObject)
    self:tabClick()
  else
    self:Show(self.itemTabs.gameObject)
    local tmpData = {
      id = AdventureItemNormalListPage.MaxCategory.id,
      Name = string.format(ZhString.AdventurePanel_AllTab, data.staticData.Name)
    }
    table.insert(listPopUpItems, 1, tmpData)
    for i = 1, #listPopUpItems do
      local single = listPopUpItems[i]
      if single.id then
        self.itemTabs:AddItem(single.Name, single)
      end
    end
    self.itemTabs.value = listPopUpItems[1].Name
  end
end
function AdventureNpcListPage:checkSelect()
  if self.itemTabs.isOpen then
    self:Show(self.ItemTabsBgSelect)
  else
    self:Hide(self.ItemTabsBgSelect)
  end
end
function AdventureNpcListPage:tabClick(selectTabData, noResetPos)
  if self.tagItemList then
    self.tagItemList:removeTip()
  end
  self.selectTabData = selectTabData
  if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
    self.tagItemList:setCategoryAndTab(self.data, selectTabData)
  else
    self.tagItemList:setCategoryAndTab(self.data, nil)
  end
  self:UpdateList(noResetPos)
end
function AdventureNpcListPage:UpdateList(noResetPos)
  self.tagItemList:UpdateList(noResetPos)
end
function AdventureNpcListPage:HandleManualUpdate(note)
  local data = note.body
  local type = data.update.type
  if self.data and self.gameObject.activeSelf and self.data.staticData.id == type then
    if self.selectTabData and self.selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
      self.tagItemList:setCategoryAndTab(self.data, self.selectTabData)
    else
      self.tagItemList:setCategoryAndTab(self.data, nil)
    end
    self:UpdateList(true)
  end
end
function AdventureNpcListPage:updateCellTip(data)
  local cellCtl = data.ctrl
  local ret = data.ret
  if ret and cellCtl and cellCtl.data and cellCtl.data.staticData.RedTip then
    self:RegisterRedTipCheck(cellCtl.data.staticData.RedTip, cellCtl.bg, nil, {-15, -15})
  elseif ret or not cellCtl.data or not cellCtl.data.staticData or cellCtl.data.staticData.RedTip then
  end
end
function AdventureNpcListPage:RefreshZoneTags(note)
  self.tagItemList:RefreshTags()
end
function AdventureNpcListPage:ClickZoneReward(cell)
  if not cell.isTag then
    return
  end
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AdventureZoneRewardPopUp,
    viewdata = cell.data
  })
end
function AdventureNpcListPage:OnClickBtnHelp()
  local helpData = Table_Help[721]
  if helpData then
    self:OpenHelpView(helpData)
  end
end
function AdventureNpcListPage:OnEnter()
  TimeTickManager.Me():CreateTick(0, 100, self.checkSelect, self)
  self.tagItemList:OnEnter()
end
function AdventureNpcListPage:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self.tagItemList:OnExit()
end
