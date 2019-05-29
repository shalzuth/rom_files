autoImport("ItemData")
autoImport("BagTabData")
autoImport("BagMainTab")
autoImport("BagData")
FashionBagData = class("FashionBagData", BagData)
function FashionBagData:ctor(tabs, tabClass, type)
  self.ownedNum = 0
  FashionBagData.super.ctor(self, tabs, tabClass, type)
  self.wholeTab = BagFashionTab.new()
  self.InitGuidProfix = "Local_Init_"
  self:InitFashionBag()
end
function FashionBagData:GetOwnedNum()
  return self.ownedNum or 0
end
function FashionBagData:InitFashionBag()
  local tt = os.clock()
  local fashions = GameConfig.ItemFashion
  local typeMap = {}
  for _, o in pairs(fashions) do
    local typeIDs = o.types
    for i = 1, #typeIDs do
      typeMap[typeIDs[i]] = typeIDs[i]
    end
  end
end
function FashionBagData:RemoveItemByGuid(itemId)
  local item = self:GetItemByGuid(itemId)
  if item ~= nil then
    self.ownedNum = self.ownedNum - 1
    item.id = self.InitGuidProfix .. item.staticData.id
    item.equiped = 0
    item.num = 0
    self:ChangeGuid(itemId, item.id)
  end
end
function FashionBagData:ChangeGuid(itemOldID, itemNewID)
  local item = self:GetItemByGuid(itemOldID)
  if item ~= nil then
    self.wholeTab:ChangeGuid(itemOldID, itemNewID)
    local tab = self.itemMapTab[item.staticData.Type]
    if tab ~= nil then
      tab:ChangeGuid(itemOldID, itemNewID)
    end
  end
end
function FashionBagData:UpdateItems(serverItems)
  self.wholeTab:SetDirty()
  for i = 1, #serverItems do
    local sItem = serverItems[i]
    local sItemData = sItem.base
    local item = self:GetItemByGuid(sItemData.guid)
    if item ~= nil then
      local tab = self.itemMapTab[item.staticData.Type]
      if tab ~= nil then
        tab:SetDirty()
      end
      self:UpdateItem(item, sItem)
    else
      item = self:GetItemByGuid(self.InitGuidProfix .. sItemData.id)
      if item ~= nil then
        self.ownedNum = self.ownedNum + 1
        self:UpdateItem(item, sItem)
        self:ChangeGuid(self.InitGuidProfix .. sItemData.id, item.id)
      elseif sItemData.id ~= 0 then
        error("\232\131\140\229\140\133\228\184\173\230\156\170\230\137\190\229\136\176\231\137\169\229\147\129" .. sItemData.id)
      end
    end
  end
end
function FashionBagData:Reset()
end
function FashionBagData:GetItems(tabType)
  if tabType ~= nil then
    local tab = self.tabs[tabType]
    if tab ~= nil then
      return tab:GetItems()
    end
  end
  return self.wholeTab:GetItems()
end
function FashionBagData:GetMount()
  local mountSite = 13
  local items = self:GetItems()
  for i = 1, #items do
    if items[i].index == mountSite and items[i]:IsMount() then
      return items[i]
    end
  end
  return nil
end
