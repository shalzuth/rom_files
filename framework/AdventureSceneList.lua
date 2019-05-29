autoImport("AdventureNormalList")
AdventureSceneList = class("AdventureSceneList", AdventureNormalList)
autoImport("WrapCellHelper")
autoImport("AdventureIndicatorCell")
autoImport("AdventureSceneCell")
AdventureSceneList.ViewPageDrag = "AdventureSceneList_ViewPageDrag"
function AdventureSceneList:ctor(go, control, isAddMouseClickEvent)
  if go then
    self.gameObject = go
    self.ItemTabLst = {}
    self.NewTagLst = {}
    self:Init()
    self:addViewEventListener()
  else
    error("can not find itemListObj")
  end
  self.toBeUnlock = nil
  self.delta = 0
end
local tempArray = {}
function AdventureSceneList:Init()
  local itemBord = self:FindGO("ItemBord"):GetComponent(UIGrid)
  self.itemBord = UIGridListCtrl.new(itemBord, AdventureSceneCell, "AdventureSceneCell")
  self.itemBord:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.itemBord:AddEventListener(PersonalPicturePanel.GetPersonPicThumbnail, self.GetPersonPicThumbnail, self)
  self.sceneryZhName = self:FindGO("sceneryZhName"):GetComponent(UILabel)
  self.sceneryEnName = self:FindGO("sceneryEnName"):GetComponent(UILabel)
  self.rightAction = self:FindGO("rightAction")
  self.leftAction = self:FindGO("leftAction")
  self.indicatorGrid = self:FindGO("indicatorGrid"):GetComponent(UIGrid)
  self.indicatorGrid = UIGridListCtrl.new(self.indicatorGrid, AdventureIndicatorCell, "AdventureIndicatorCell")
  self.indicatorGridObj = self:FindGO("curStateCt")
  self.curStateBg = self:FindGO("curStateBg"):GetComponent(UISprite)
  local dragCollider = self:FindGO("dragCollider")
  self:AddDragEvent(dragCollider, function(obj, delta)
    if math.abs(delta.x) > 20 then
      self.delta = delta.x
    end
  end)
  UIEventListener.Get(dragCollider).onDragEnd = function(obj)
    if math.abs(self.delta) > 20 then
      self:handDrag(self.delta)
    end
  end
  local lL = self:FindGO("Label", self.leftAction)
  lL.transform.localPosition = Vector3(36, 0, 0)
  local rL = self:FindGO("Label", self.rightAction)
  rL.transform.localPosition = Vector3(-16, -8, 0)
end
function AdventureSceneList:SetPropData(propData, keys)
end
function AdventureSceneList:GetPersonPicThumbnail(cellCtl)
  self:PassEvent(PersonalPicturePanel.GetPersonPicThumbnail, cellCtl)
end
function AdventureSceneList:removeTip()
end
function AdventureSceneList:getStartIndexByQuestId()
  if self.toBeUnlock and self.itemDatas then
    for i = 1, #self.itemDatas do
      local single = self.itemDatas[i]
      if single.staticId == self.toBeUnlock.staticId then
        return i
      end
    end
  elseif self.startIndex then
    return self.startIndex
  end
  return 1
end
function AdventureSceneList:SetData(datas, noResetPos)
  self.itemDatas = datas
  local index = self:getStartIndexByQuestId()
  if index then
    self.startIndex = math.floor((index - 1) / 4) * 4 + 1
  else
    self.startIndex = 1
  end
  if not noResetPos then
    self.startIndex = 1
  end
  if self.itemDatas and #self.itemDatas > 0 then
    local start = self.startIndex
    local endIndex = math.min(self.startIndex + 3, #self.itemDatas)
    local list = {
      unpack(self.itemDatas, start, endIndex)
    }
    self:setItemList(list)
  else
    self.itemBord:RemoveAll()
  end
  if not self:ObjIsNil(self.effect) then
    GameObject.DestroyImmediate(self.effect)
    self.effect = nil
  end
  self:checkBtnEnabled()
  self.toBeUnlock = nil
end
function AdventureSceneList:setCategoryAndTab(category, tab)
  AdventureSceneList.super.setCategoryAndTab(self, category, tab)
  self.tab = tab
  if tab and tab.id ~= AdventureItemNormalListPage.MaxCategory.id then
    self.sceneryZhName.text = tab.Name
    self.sceneryEnName.text = tab.NameEn
    self:Show(self.indicatorGridObj)
  else
    self:Hide(self.indicatorGridObj)
    self.sceneryZhName.text = string.format(ZhString.AdventurePanel_AllTab, self.category.staticData.Name)
    self.sceneryEnName.text = "All"
  end
end
function AdventureSceneList:GetItemCells()
  return self.itemBord:GetCells()
end
function AdventureSceneList:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    local data = cellCtl.data
    if data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
      ServiceSceneManualProxy.Instance:CallUnlock(data.type, data.staticId)
      self.toBeUnlock = data
      return
    elseif data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK then
      if cellCtl.occurError then
        MsgManager.ShowMsgByIDTable(555)
        return
      elseif not cellCtl.loadFinish then
        return
      end
      local viewData = {
        viewname = "ScenerytDetailPanel",
        scenicSpotData = cellCtl.data
      }
      self:sendNotification(UIEvent.ShowUI, viewData)
    elseif data:canBeClick() then
      local appendData = data:getCompleteNoRewardAppend()
      appendData = appendData[1]
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.AdventureAppendRewardPanel,
        viewdata = appendData
      })
      self.toBeUnlock = data
      return
    end
  end
end
function AdventureSceneList:checkBtnEnabled()
  if self.itemDatas and #self.itemDatas > 0 then
    if #self.itemDatas - self.startIndex > 3 then
      self:Show(self.rightAction)
    else
      self:Hide(self.rightAction)
    end
    if self.startIndex > 4 then
      self:Show(self.leftAction)
    else
      self:Hide(self.leftAction)
    end
    local count = #self.itemDatas % 4 == 0 and #self.itemDatas / 4 or math.floor(#self.itemDatas / 4) + 1
    local list = {}
    for i = 1, count do
      local data = {}
      local cur = math.floor(self.startIndex / 4) + 1
      if i == cur then
        data.cur = true
      end
      table.insert(list, data)
    end
    if self.tab and self.tab.id ~= AdventureItemNormalListPage.MaxCategory.id then
      self:Show(self.indicatorGridObj)
    end
    self.indicatorGrid:ResetDatas(list)
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.indicatorGrid.layoutCtrl.transform, true)
    self.curStateBg.width = bound.size.x + 200
  else
    self:Hide(self.rightAction)
    self:Hide(self.leftAction)
    self:Hide(self.indicatorGridObj)
  end
end
function AdventureSceneList:addViewEventListener()
  self:AddButtonEvent("rightAction", function(obj)
    self:turnRight()
  end)
  self:AddButtonEvent("leftAction", function(obj)
    self:turnLeft()
  end)
end
function AdventureSceneList:turnLeft()
  if self.itemDatas and #self.itemDatas > 0 then
    do
      local start = self.startIndex - 4
      if start > 0 then
        self.startIndex = start
        local endIndex = math.min(self.startIndex + 3, #self.itemDatas)
        local list = {
          unpack(self.itemDatas, self.startIndex, endIndex)
        }
        self:setItemList(list)
      end
    end
  else
  end
  self:checkBtnEnabled()
end
function AdventureSceneList:turnRight()
  if self.itemDatas and #self.itemDatas > 0 then
    local start = self.startIndex + 4
    if start > #self.itemDatas then
    else
      self.startIndex = start
      local endIndex = math.min(self.startIndex + 3, #self.itemDatas)
      local list = {
        unpack(self.itemDatas, self.startIndex, endIndex)
      }
      self:setItemList(list)
    end
  end
  self:checkBtnEnabled()
end
function AdventureSceneList:handDrag(data)
  if data < 0 then
    self:turnRight()
  else
    self:turnLeft()
  end
end
function AdventureSceneList:setItemList(list)
  self.itemBord:ResetDatas(list)
end
function AdventureSceneList:OnExit()
  EventManager.Me():RemoveEventListener(AdventureSceneList.ViewPageDrag, self.handDrag, self)
end
function AdventureSceneList:OnEnter()
  EventManager.Me():AddEventListener(AdventureSceneList.ViewPageDrag, self.handDrag, self)
end
function AdventureSceneList:GetTabDatas()
  if self.category then
    local type = self.category.staticData.id
    if not self.tab or not self.tab.id then
      local tab
    end
    local bag = AdventureDataProxy.Instance.bagMap[type]
    if bag then
      local items = bag:GetItems(tab)
      items = AdventureDataProxy.Instance:getItemsByFilterData(type, items, self.propData, self.keys)
      TableUtility.ArrayClear(tempArray)
      for i = 1, #items do
        local single = items[i]
        if 5 ~= single.staticData.Type or SceneManual_pb.EMANUALSTATUS_DISPLAY ~= single.status then
          tempArray[#tempArray + 1] = single
        end
      end
      return tempArray
    end
  else
    printRed("category is nil")
  end
end
