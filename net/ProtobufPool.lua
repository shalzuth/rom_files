ProtobufPool = {}
local ArrayPopBack = TableUtility.ArrayPopBack
local ArrayPushBack = TableUtility.ArrayPushBack
local pool = {}
local poolNum = 100
function ProtobufPool.Get(pb_class)
  local dataPool = pool[pb_class]
  if dataPool ~= nil then
    local data = ArrayPopBack(dataPool)
    if data ~= nil then
      return data
    end
  end
  return pb_class()
end
function ProtobufPool.GetArray(arrayIndex)
  local dataPool = pool[arrayIndex]
  if dataPool ~= nil then
    local data = ArrayPopBack(dataPool)
    if data ~= nil then
      return data
    end
  end
  return nil
end
function ProtobufPool.Add(pb_class, data, num)
  num = num or poolNum
  local dataPool = pool[pb_class]
  if dataPool == nil then
    dataPool = {}
    pool[pb_class] = dataPool
  elseif num <= #dataPool then
    return
  end
  ArrayPushBack(dataPool, data)
end
