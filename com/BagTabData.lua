autoImport("ItemData")
BagTabData = class("BagTabData")
function BagTabData:ctor(tab)
  self:Reset()
  self.tab = tab
  self.dirty = false
end
function BagTabData:SetDirty(val)
  self.dirty = val or true
end
function BagTabData:IsDirty()
  return self.dirty
end
function BagTabData:AddItems(items)
  if items ~= nil then
    for i = 1, #items do
      self:AddItem(items[i])
    end
  end
end
function BagTabData:AddItem(item)
  if item ~= nil then
    self.itemsMap[item.id] = item
    self.dirty = true
    self.items[#self.items + 1] = item
  end
end
function BagTabData:RemoveItems(itemIds)
end
function BagTabData:RemoveItemByGuid(itemId)
  local item = self.itemsMap[itemId]
  self.itemsMap[itemId] = nil
  if item ~= nil then
    self.dirty = true
    for _, o in pairs(self.items) do
      if o.id == itemId then
        table.remove(self.items, _)
        return o
      end
    end
  end
end
function BagTabData:ChangeGuid(oldID, newID)
  local item = self.itemsMap[oldID]
  if item ~= nil then
    self.dirty = true
    self.itemsMap[oldID] = nil
    self.itemsMap[newID] = item
    item.id = newID
  end
end
function BagTabData:UpdateItems()
end
function BagTabData:UpdateItem()
end
function BagTabData:GetItems()
  if self.dirty == true then
    if not self.parsedItems then
      self.parsedItems = {}
    else
      TableUtility.ArrayClear(self.parsedItems)
    end
    for i = 1, #self.items do
      table.insert(self.parsedItems, self.items[i])
    end
    table.sort(self.parsedItems, BagTabData.sortFunc)
    self.dirty = false
  end
  return self.parsedItems
end
function BagTabData.sortFunc(left, right)
  if left == nil then
    return false
  elseif right == nil then
    return true
  end
  local leftOrder = left.staticData.ItemSort or 0
  local rightOrder = right.staticData.ItemSort or 0
  if leftOrder ~= rightOrder then
    return leftOrder > rightOrder
  end
  if left.staticData.Type ~= right.staticData.Type then
    return left.staticData.Type < right.staticData.Type
  end
  if left.staticData.Quality ~= right.staticData.Quality then
    return left.staticData.Quality > right.staticData.Quality
  end
  return left.staticData.id > right.staticData.id
end
function BagTabData:SortByQualityAscend(left, right)
  if left == nil then
    return false
  elseif right == nil then
    return true
  end
  if left.staticData.Quality < right.staticData.Quality then
    return true
  elseif left.staticData.Quality > right.staticData.Quality then
    return false
  elseif left.staticData.id > right.staticData.id then
    return true
  elseif left.staticData.id < right.staticData.id then
    return false
  else
    return false
  end
end
function BagTabData:GetItemByGuid(guid)
  return self.itemsMap[guid]
end
function BagTabData:GetItemByStaticID(staticID)
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID then
      return o
    end
  end
  return nil
end
function BagTabData:GetItemsByStaticID(staticID)
  local items
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID then
      items = items or {}
      items[#items + 1] = o
    end
  end
  return items
end
function BagTabData:GetItemNumByStaticID(staticID)
  local num = 0
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID then
      num = num + o.num
    end
  end
  return num
end
function BagTabData:GetItemNumByStaticIDs(staticIDs)
  local numMap = {}
  for i = 1, #staticIDs do
    numMap[staticIDs[i]] = 0
  end
  local num
  for _, o in pairs(self.items) do
    if o.staticData ~= nil then
      num = numMap[o.staticData.id]
      if num ~= nil then
        num = num + o.num
        numMap[o.staticData.id] = num
      end
    end
  end
  return numMap
end
function BagTabData:GetItemsByType(typeID, sortFunc)
  local res = {}
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.Type == typeID then
      res[#res + 1] = o
    end
  end
  if sortFunc ~= nil then
    table.sort(res, function(l, r)
      return sortFunc(self, l, r)
    end)
  end
  return res
end
function BagTabData:Reset()
  self.items = {}
  self.itemsMap = {}
  self.parsedItems = {}
end
function BagTabData:Print()
  local t = os.clock()
  local items1 = self:GetItems()
  if items1 ~= nil then
    local count = table.maxn(items1)
    for i = 1, count do
      if items1[i] ~= nil then
      else
      end
    end
  end
end
function BagTabData:PrintTest()
  local t = os.clock()
  local items1 = self:GetItems()
  if items1 ~= nil then
    local count = table.maxn(items1)
    for i = 1, count do
      if items1[i] ~= nil then
      else
      end
    end
  end
end
