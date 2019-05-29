autoImport("ItemData")
AdventureTab = class("AdventureTab")
function AdventureTab:ctor(tab)
  self:Reset()
  self.tab = tab
  self.dirty = false
  self.totalScore = 0
  self.totalCount = 0
  self.curUnlockCount = 0
  if self.tab then
    self:setBagTypeData(tab.type)
  end
end
function AdventureTab:setBagTypeData(type)
  self.bagTypeData = Table_ItemTypeAdventureLog[type]
  self.type = type
  self.isDivideByZone = self.type == SceneManual_pb.EMANUALTYPE_MONSTER or self.type == SceneManual_pb.EMANUALTYPE_NPC
end
function AdventureTab:SetDirty(val)
  self.dirty = val or true
end
function AdventureTab:AddItems(items)
  if items ~= nil then
    for i = 1, #items do
      self:AddItem(items[i])
    end
  end
end
function AdventureTab:AddItem(item)
  if item ~= nil then
    self.dirty = true
    if self.isDivideByZone then
      local mapID = item.staticData.ManualMap or GameConfig.AdventureDefaultTag.id
      if not self.itemsMap[mapID] then
        self.itemsMap[mapID] = {}
      end
      if not self.items[mapID] then
        self.items[mapID] = {}
      end
      self.itemsMap[mapID][item.staticId] = item
      self.items[mapID][#self.items[mapID] + 1] = item
    else
      self.itemsMap[item.staticId] = item
      self.items[#self.items + 1] = item
    end
  end
end
function AdventureTab:RemoveItems(itemIds)
end
function AdventureTab:GetItems()
  self.parsedItems = {}
  if self.isDivideByZone then
    for mapID, listItem in pairs(self.items) do
      for i = 1, #listItem do
        local single = listItem[i]
        if single:IsValid() then
          self.parsedItems[#self.parsedItems + 1] = single
        end
      end
    end
  else
    for i = 1, #self.items do
      local single = self.items[i]
      if single:IsValid() then
        self.parsedItems[#self.parsedItems + 1] = single
      end
    end
  end
  table.sort(self.parsedItems, function(l, r)
    return self:sortFunc(l, r)
  end)
  return self.parsedItems
end
function AdventureTab:GetItemsByMapID(mapID)
  if not self.isDivideByZone then
    redlog("Not Divide By Zone", self.type, SceneManual_pb.EMANUALTYPE_MONSTER, SceneManual_pb.EMANUALTYPE_NPC)
    return nil
  end
  self.parsedItems = {}
  for id, listItem in pairs(self.items) do
    if id == mapID then
      for i = 1, #listItem do
        local single = listItem[i]
        if single:IsValid() then
          self.parsedItems[#self.parsedItems + 1] = single
        end
      end
      table.sort(self.parsedItems, function(l, r)
        return self:sortFunc(l, r)
      end)
      break
    end
  end
  return self.parsedItems
end
function AdventureTab:sortFunc(left, right)
  local lAdSort = left.staticData.AdventureSort
  local rAdSort = right.staticData.AdventureSort
  if lAdSort == rAdSort then
    return left.staticId < right.staticId
  elseif lAdSort == nil then
    return false
  elseif rAdSort == nil then
    return true
  else
    return lAdSort < rAdSort
  end
end
function AdventureTab:GetItemByStaticID(staticID)
  if self.isDivideByZone then
    for mapID, listItem in pairs(self.items) do
      for _, o in pairs(listItem) do
        if o.staticData ~= nil and o.staticData.id == staticID and o:IsValid() then
          return o
        end
      end
    end
    return nil
  end
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID and o:IsValid() then
      return o
    end
  end
  return nil
end
function AdventureTab:GetItemNumByStaticID(staticID)
  local num = 0
  if self.isDivideByZone then
    for mapID, listItem in pairs(self.items) do
      for _, o in pairs(listItem) do
        if o.staticData ~= nil and o.staticData.id == staticID and o:IsValid() then
          num = num + o.num
        end
      end
    end
    return num
  end
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID and o:IsValid() then
      num = num + o.num
    end
  end
  return num
end
function AdventureTab:GetItemNumByStaticIDs(staticIDs)
  local numMap = {}
  for i = 1, #staticIDs do
    numMap[staticIDs[i]] = 0
  end
  local num
  if self.isDivideByZone then
    for mapID, listItem in pairs(self.items) do
      for _, o in pairs(listItem) do
        if o.staticData ~= nil and o:IsValid() then
          num = numMap[o.staticData.id]
          if num ~= nil then
            num = num + o.num
            numMap[o.staticData.id] = num
          end
        end
      end
    end
    return numMap
  end
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o:IsValid() then
      num = numMap[o.staticData.id]
      if num ~= nil then
        num = num + o.num
        numMap[o.staticData.id] = num
      end
    end
  end
  return numMap
end
function AdventureTab:GetItemsByType(typeID, sortFunc)
  local res = {}
  if self.isDivideByZone then
    for mapID, listItem in pairs(self.items) do
      for _, o in pairs(listItem) do
        if o.staticData ~= nil and o.staticData.Type == typeID and o:IsValid() then
          res[#res + 1] = o
        end
      end
    end
  else
    for _, o in pairs(self.items) do
      if o.staticData ~= nil and o.staticData.Type == typeID and o:IsValid() then
        res[#res + 1] = o
      end
    end
  end
  if sortFunc ~= nil then
    table.sort(res, function(l, r)
      return sortFunc(self, l, r)
    end)
  end
  return res
end
function AdventureTab:Reset()
  self.items = {}
  self.itemsMap = {}
  self.parsedItems = {}
end
