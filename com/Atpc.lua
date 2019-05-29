autoImport("Bat")
Atpc = class("Atpc", Bat)
local cMap, tMap, sArray
function Atpc:ctor(interval, map)
  tMap = map
  sArray = {}
  Atpc.super.ctor(self, interval, function(self)
    if self:MakeSArray() then
      self:Send()
    end
    self:Clear()
  end, self)
end
function Atpc:Init()
  cMap = {}
  if tMap then
    for enum, _ in pairs(tMap) do
      cMap[enum] = {}
    end
  else
    tMap = {}
  end
end
function Atpc:Record(enum, x, y)
  if not tMap or not tMap[enum] then
    return
  end
  local countMap = cMap[enum]
  if not countMap then
    countMap = {}
    cMap[enum] = countMap
  end
  local inte = AAAManager.MakeInteger(x, y)
  if countMap[inte] then
    countMap[inte] = countMap[inte] + 1
  else
    countMap[inte] = 1
  end
end
function Atpc:MakeSArray()
  for enum, _ in pairs(cMap) do
    if not tMap[enum] then
      TableUtility.TableClear(cMap[enum])
      cMap[enum] = nil
    end
  end
  local maxCount, c, t
  for enum, countMap in pairs(cMap) do
    maxCount, c, t = 0, 0, tMap[enum]
    for inte, count in pairs(countMap) do
      if count > t and count > maxCount then
        maxCount = count
        c = inte
      end
    end
    if c ~= 0 then
      local item = ReusableTable.CreateTable()
      item.button = enum
      item.pos = c
      item.count = maxCount
      TableUtility.ArrayPushBack(sArray, item)
    end
  end
  table.sort(sArray, function(l, r)
    return l.button < r.button
  end)
  return sArray
end
function Atpc:Send()
  if sArray == nil or next(sArray) == nil then
    return
  end
  ServiceNUserProxy.Instance:CallClickPosList(sArray)
end
function Atpc:Clear()
  self:ClearSArray()
  local hasC
  for enum, countMap in pairs(cMap) do
    for inte, count in pairs(countMap) do
      if count < 4 then
        countMap[inte] = nil
      else
        countMap[inte] = 0
      end
    end
    hasC = false
    for inte, count in pairs(countMap) do
      hasC = true
      break
    end
    if not hasC and not tMap[enum] then
      cMap[enum] = nil
    end
  end
end
function Atpc:ClearSArray()
  for i = 1, #sArray do
    ReusableTable.DestroyAndClearTable(sArray[i])
  end
  TableUtility.ArrayClear(sArray)
end
function Atpc:SetTMap(newT)
  TableUtility.TableClear(tMap)
  local enum
  for i = 1, #newT do
    enum = newT[i].button
    if enum then
      tMap[enum] = newT[i].threshold
      if not cMap[enum] then
        cMap[enum] = {}
      end
    end
  end
end
