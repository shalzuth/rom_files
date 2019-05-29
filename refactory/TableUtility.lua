TableUtility = class("TableUtility")
local tempTable = {}
local tempArray = {}
function TableUtility.ArrayShallowCopy(target, source)
  for i = 1, #source do
    target[i] = source[i]
  end
end
function TableUtility.ArrayShallowCopyWithCount(target, source, count)
  for i = 1, count do
    target[i] = source[i]
  end
end
function TableUtility.ArrayClear(array)
  for i = #array, 1, -1 do
    array[i] = nil
  end
end
function TableUtility.ArrayClearWithCount(array, count)
  for i = count, 1, -1 do
    array[i] = nil
  end
end
function TableUtility.ArrayClearByDeleter(array, deleter)
  for i = 1, #array do
    deleter(array[i])
    array[i] = nil
  end
end
function TableUtility.ArrayPushBack(array, obj)
  array[#array + 1] = obj
end
function TableUtility.ArrayPopBack(array)
  local len = #array
  if len <= 0 then
    return nil
  end
  local obj = array[len]
  array[len] = nil
  return obj
end
function TableUtility.ArrayPushFront(array, obj)
  table.insert(array, 1, obj)
end
function TableUtility.ArrayPopFront(array)
  if #array <= 0 then
    return nil
  end
  local obj = array[1]
  table.remove(array, 1)
  return obj
end
function TableUtility.ArrayFindIndex(array, obj)
  for i = 1, #array do
    if array[i] == obj then
      return i
    end
  end
  return 0
end
function TableUtility.ArrayFindByPredicate(array, predicate, args)
  for i = 1, #array do
    if predicate(array[i], args) then
      return array[i], i
    end
  end
  return nil, 0
end
function TableUtility.ArrayRemove(array, obj)
  for i = 1, #array do
    if array[i] == obj then
      table.remove(array, i)
      return i
    end
  end
  return 0
end
function TableUtility.ArrayRemoveByPredicate(array, predicate, args)
  for i = 1, #array do
    if predicate(array[i], args) then
      table.remove(array, i)
      return i
    end
  end
  return 0
end
function TableUtility.ArrayUnique(array)
  for i = 1, #array do
    if nil ~= tempTable[array[i]] then
      tempArray[#tempArray + 1] = i
    else
      tempTable[array[i]] = 1
    end
  end
  for i = #tempArray, 1, -1 do
    table.remove(array, tempArray[i])
    tempArray[i] = nil
  end
  TableUtility.TableClear(tempTable)
  return 0
end
function TableUtility.TableShallowCopy(target, source)
  for k, v in pairs(source) do
    target[k] = v
  end
end
function TableUtility.TableClear(t)
  for k, _ in pairs(t) do
    t[k] = nil
  end
end
function TableUtility.TableClearByDeleter(t, deleter)
  for k, v in pairs(t) do
    deleter(v)
    t[k] = nil
  end
end
function TableUtility.TableFindKey(t, obj)
  for k, v in pairs(t) do
    if v == obj then
      return k
    end
  end
end
function TableUtility.TableFindByPredicate(t, predicate, args)
  for k, v in pairs(t) do
    if predicate(k, v, args) then
      return v, k
    end
  end
end
function TableUtility.TableRemove(t, obj)
  for k, v in pairs(t) do
    if v == obj then
      t[k] = nil
      return k
    end
  end
  return nil
end
function TableUtility.TableRemoveByPredicate(t, predicate, args)
  for k, v in pairs(t) do
    if predicate(k, v, args) then
      t[k] = nil
      return k
    end
  end
  return nil
end
function TableUtility.InsertSort(t, v, sortFunc)
  if #t == 0 then
    t[1] = v
    return 1
  end
  local inserted, index
  for i = 1, #t do
    if sortFunc(t[i], v) then
      table.insert(t, i, v)
      return i
    end
  end
  table.insert(t, v)
  return #t
end
