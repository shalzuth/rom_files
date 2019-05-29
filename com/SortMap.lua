SortMap = class("SortMap")
local tableClear = TableUtility.TableClear
local insertSort = TableUtility.InsertSort
function SortMap:ctor(dir)
  self.map = {}
  self.keyArray = {}
  self.keyArray_Map = {}
  self:SetCustomSortFunc(function(iN, iInsert)
    return self.map[iN] > self.map[iInsert]
  end)
end
function SortMap:SetCustomSortFunc(customSortFunc)
  self.sortFunc = customSortFunc
end
function SortMap:IsEmpty()
  return #self.keyArray == 0
end
function SortMap:Set(key, value)
  if self.map[key] then
    self:Remove(key)
  end
  self.map[key] = value
  self.keyArray_Map[key] = insertSort(self.keyArray, key, self.sortFunc)
end
function SortMap:Remove(key)
  self.map[key] = nil
  local keyIndex = self.keyArray_Map[key]
  self.keyArray_Map[key] = nil
  table.remove(self.keyArray, keyIndex)
end
function SortMap:TakeMin()
  return self:TakeByIndex(1)
end
function SortMap:TakeMax()
  return self:TakeByIndex(#self.keyArray)
end
function SortMap:TakeByIndex(index)
  local key = table.remove(self.keyArray, index)
  self.keyArray_Map[key] = nil
  local v = self.map[key]
  self.map[key] = nil
  return key, v
end
function SortMap:Clear()
  tableClear(self.map)
  tableClear(self.keyArray)
  tableClear(self.keyArray_Map)
end
