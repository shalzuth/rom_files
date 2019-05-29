autoImport("AdventureNormalList")
AdventureTagItemList = class("AdventureTagItemList", AdventureNormalList)
AdventureTagItemList.ClickFoldTag = "AdventureTagItemList_ClickFoldTag"
function AdventureTagItemList:Init()
  local itemContainer = self:FindGO("bag_itemContainer")
  local control = self.control
  local pfbNum = 6
  local rt = Screen.height / Screen.width
  if rt > 0.5625 then
    pfbNum = 10
  end
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = pfbNum,
    cellName = "AdventureNpcCombineItemCell",
    control = control,
    dir = 1
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  if self.isAddMouseClickEvent then
    self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
    self.wraplist:AddEventListener(AdventureNormalList.UpdateCellRedTip, self.updateCellTip, self)
    self.wraplist:AddEventListener(AdventureTagItemList.ClickFoldTag, self.HandleClickFoldTag, self)
  end
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  function self.scrollView.OnStop()
    self:ScrollViewRevert()
  end
  self.normalListSp = self:FindGO("normalListSp")
  self.listTags = {}
  for mapID, zoneData in pairs(Table_ManualZone) do
    self.listTags[mapID] = {
      id = mapID,
      isTag = true,
      zoneStaticData = zoneData
    }
  end
  self.defaultTag = {
    id = GameConfig.AdventureDefaultTag.id,
    isTag = true,
    isDefaultTag = true
  }
  self.listTagStatus = {}
end
function AdventureTagItemList:HandleClickFoldTag(cell)
  if not cell.isTag then
    redlog("Cell is not a tag!")
    return
  end
  self:SetTagOpen(cell.id, not cell.data.isOpen)
end
function AdventureTagItemList:AddListEventListener(eventType, handler, handlerOwner)
  self.wraplist:AddEventListener(eventType, handler, handlerOwner)
end
function AdventureTagItemList:Reset()
  self:ClearSelectData()
  for mapID, tagData in pairs(self.listTags) do
    tagData.isOpen = true
  end
  self.defaultTag.isOpen = true
end
function AdventureTagItemList:IsTagOpen(id)
  local tagStatus = self.listTagStatus[self.category and self.category.staticData.id]
  if not tagStatus then
    return true
  end
  local isOpen = tagStatus[id]
  return isOpen == nil and true or isOpen
end
function AdventureTagItemList:SetTagOpen(id, isOpen)
  if not self.category then
    return
  end
  if self:IsTagOpen(id) ~= isOpen then
    local type = self.category.staticData.id
    if not self.listTagStatus[type] then
      self.listTagStatus[type] = {}
    end
    self.listTagStatus[self.category.staticData.id][id] = isOpen
    self:UpdateList(true)
  end
end
function AdventureTagItemList:RefreshTags()
  local cells = self.wraplist:GetCellCtls()
  for i = 1, #cells do
    if cells[i].isTag then
      cells[i]:ReloadTagData()
    end
  end
end
function AdventureTagItemList:SetData(datas, noResetPos)
  AdventureTagItemList.super.SetData(self, datas, noResetPos)
  if not noResetPos then
    self.scrollView:MoveRelative(-LuaVector3.up)
  end
end
function AdventureTagItemList:ReUnitData(datas, rowNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      if datas[i].isTag then
        self.unitData[#self.unitData + 1] = datas[i]
      else
        local list = self.unitData[#self.unitData]
        if list.isTag or rowNum <= #list then
          list = {}
          self.unitData[#self.unitData + 1] = list
        end
        list[#list + 1] = datas[i]
      end
    end
  end
  return self.unitData
end
local itemList = {}
function AdventureTagItemList:GetTabDatas()
  if not self.category then
    redlog("category is nil")
    return
  end
  local type = self.category.staticData.id
  local bag = AdventureDataProxy.Instance.bagMap[type]
  if not bag then
    return
  end
  TableUtility.ArrayClear(itemList)
  for mapID, tagData in pairs(self.listTags) do
    tagData.type = type
    self:AddBagItems(itemList, bag, mapID, tagData)
  end
  self:AddBagItems(itemList, bag, self.defaultTag.id, self.defaultTag)
  return itemList
end
function AdventureTagItemList:AddBagItems(targatList, bag, mapID, tagData)
  local itemsInBag = bag:GetItemsByMapID(self.tab and self.tab.id or nil, mapID)
  if itemsInBag and #itemsInBag > 0 then
    tagData.isOpen = self:IsTagOpen(mapID)
    targatList[#targatList + 1] = tagData
    if tagData.isOpen then
      for i = 1, #itemsInBag do
        targatList[#targatList + 1] = itemsInBag[i]
      end
    end
  end
end
local cellResult = {}
function AdventureTagItemList:GetItemCells()
  local combineCells = self.wraplist:GetCellCtls()
  TableUtility.ArrayClear(cellResult)
  for i = 1, #combineCells do
    local v = combineCells[i]
    if not v.isTag and v.isActive then
      local childs = v:GetCells()
      for i = 1, #childs do
        table.insert(cellResult, childs[i])
      end
    end
  end
  return cellResult
end
