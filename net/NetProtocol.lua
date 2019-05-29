NetProtocol = {}
local listeners = {}
NetProtocol.noSendProtcol = false
NetProtocol.CachingSomeReceives = false
function NetProtocol.AddListener(id1, id2, func)
  local key = id1 .. "_" .. id2
  if listeners[key] == nil then
    listeners[key] = {}
  else
    NetProtocol.InfoFormat("NetProtocol::AddListener Error id1:{0}  id2:{1}", id1, id2)
  end
  table.insert(listeners[key], func)
end
function NetProtocol.RemoveListener(id1, id2, func)
  local key = id1 .. "_" .. id2
  if listeners[key] == nil then
    return
  end
  for i, value in ipairs(listeners[key]) do
    if value == func then
      table.remove(listeners[key], i)
      return
    end
  end
end
function NetProtocol.DispatchListener(id1, id2, data)
  local key = id1 .. "_" .. id2
  if listeners[key] == nil then
    NetProtocol.InfoFormat("NetProtocol::DispatchListener Error id1:{0},id2:{1}", id1, id2)
    return
  end
  for i, value in ipairs(listeners[key]) do
    if value ~= nil then
      value(id1, id2, data)
      ServiceConnProxy.Instance:RecvHeart()
    end
  end
end
function NetProtocol.TableToString(t)
  return ""
end
function NetProtocol.Pack(id1, id2, data)
  local dataUp = _G[string.format("Data_Up_%d_%d", id1, id2)]
  if dataUp == nil then
    return nil
  end
  local start = 0
  return NetProtocol.PackStruct(dataUp, data)
end
function NetProtocol.PackStruct(struct, data)
  local dataBytes = NetUtil.GetNewBytes()
  for key, value in ipairs(struct) do
    local name = value.name
    local t = value.type
    local lenFrom = value.lenFrom
    if name ~= nil and t ~= nil then
      if lenFrom ~= nil then
        local number
        if type(lenFrom) == "number" then
          number = lenFrom
        elseif data[lenFrom] ~= nil then
          number = data[lenFrom]
        end
        for i = 1, number do
          dataBytes = NetUtil.Append(dataBytes, NetProtocol.PackValue(t, data[name][i]))
        end
      else
        dataBytes = NetUtil.Append(dataBytes, NetProtocol.PackValue(t, data[name]))
      end
    end
  end
  return dataBytes
end
function NetProtocol.PackValue(t, value)
  function PackArray(t, array)
    local dataBytes = NetUtil.GetNewBytes()
    for i = 1, #array do
      if array[i] ~= nil then
        if type(array[i]) ~= "table" then
          dataBytes = NetUtil.Append(dataBytes, NetProtocol.PackValue(t, array[i]))
        else
          dataBytes = NetUtil.Append(dataBytes, PackArray(t, array[i]))
        end
      end
    end
    return dataBytes
  end
  if type(t) ~= "table" and type(value) == "table" then
    return PackArray(t, value)
  end
  if type(t) == "table" then
    return NetProtocol.PackStruct(t, value)
  end
  if t == "char" then
    return NetUtil.CharTo1Bytes(value)
  end
  if t == "char32" then
    return NetUtil.CharsToBytes(value, 32)
  end
  if t == "uint2" then
    return NetUtil.UintTo2Bytes(value)
  end
  if t == "uint4" then
    return NetUtil.UintTo4Bytes(value)
  end
  if t == "uint8" then
    return NetUtil.UintTo8Bytes(tostring(value))
  end
  if t == "int2" then
    return NetUtil.IntTo2Bytes(value)
  end
  if t == "int4" then
    return NetUtil.IntTo4Bytes(value)
  end
  return nil
end
local ProtobufPool_Get = ProtobufPool.Get
function NetProtocol.Unpack(id1, id2, dataStr)
  local cmd = Proto_Include[id1]
  if cmd == nil then
    return nil
  end
  local param = cmd[id2]
  if param == nil then
    return nil
  end
  local msg = ProtobufPool_Get(param)
  if not NetConfig.IsHeart(id1, id2) then
  end
  local memSample = Debug_LuaMemotry.SampleBegin("NetProtocolParseFromString")
  msg:ParseFromString(dataStr)
  Debug_LuaMemotry.SampleEnd(memSample)
  return msg, param
end
function NetProtocol.UnpackStruct(struct, bytes, start)
  local data = {}
  local length = start
  for key, value in ipairs(struct) do
    local name = value.name
    local t = value.type
    local lenFrom = value.lenFrom
    if name ~= nil and t ~= nil then
      if lenFrom ~= nil then
        local number
        if type(lenFrom) == "number" then
          number = lenFrom
        elseif data[lenFrom] ~= nil then
          number = data[lenFrom]
        end
        data[name] = {}
        for i = 1, number do
          local len, value = NetProtocol.UnpackValue(t, bytes, start)
          start = start + len
          data[name][i] = value
        end
      else
        local len, value = NetProtocol.UnpackValue(t, bytes, start)
        start = start + len
        data[name] = value
      end
    end
  end
  return start - length, data
end
function NetProtocol.UnpackValue(t, bytes, start)
  local len
  if type(t) == "table" then
    return NetProtocol.UnpackStruct(t, bytes, start)
  end
  if t == "int4" then
    len = 4
    return len, NetUtil.BytesToInt4(NetUtil.GetBytes(bytes, start, len))
  end
  if t == "uint2" then
    len = 2
    return len, NetUtil.BytesToUInt2(NetUtil.GetBytes(bytes, start, len))
  end
  if t == "uint4" then
    len = 4
    return len, NetUtil.BytesToUInt4(NetUtil.GetBytes(bytes, start, len))
  end
  if t == "uint8" then
    len = 8
    return len, NetUtil.BytesToUInt8(NetUtil.GetBytes(bytes, start, len))
  end
  if t == "char" then
    len = 1
    return len, tonumber(NetUtil.BytesToChar(NetUtil.GetBytes(bytes, start, len)))
  end
  if t == "char32" then
    len = 32
    return len, NetUtil.BytesToChars(NetUtil.GetBytes(bytes, start, len))
  end
  NetProtocol.InfoFormat("NetProtocol.UnpackValue Error type:{0}", t)
  return nil, nil
end
function NetProtocol.Send(id1, id2, data)
  if id1 ~= 2 and id2 ~= 22 then
    NetProtocol.InfoFormat("NetProtocol::<color=yellow>Send Request</color> id1:{0}  id2:{1}", id1, id2)
  end
  local dataBytes = NetProtocol.Pack(id1, id2, data)
  if dataBytes == nil then
    NetProtocol.InfoFormat("NetProtocol::Send Error Pack Error: id1:{0} id2:{1}", id1, id2)
    return
  end
  if not NetConfig.IsHeart(id1, id2) then
    NetProtocol.InfoFormat("NetProtocol::<color=yellow>Send Success</color> id1:{0} id2:{1}", id1, id2)
  end
  NetManager.GameSend(id1, id2, dataBytes)
end
local currentIndex = 1
local currentTime = 0
function NetProtocol.SendProto(data)
  if NetProtocol.noSendProtcol then
    return
  end
  ServiceConnProxy.Instance:UpdateSendHeartTime()
  local id1 = data.cmd
  local id2 = data.param
  if not NetConfig.IsHeart(id1, id2) and not NetConfig.IsCare(id1, id2) then
    NetProtocol.InfoFormat("NetProtocol::<color=yellow>SendProto</color> id1:{0} id2:{1}", id1, id2)
  end
  local str = data:SerializeToString()
  local now = ServerTime.ServerTime
  if now then
    now = math.floor(now / 1000)
  else
    now = 0
  end
  local delta = now - currentTime
  if delta > 0 then
    currentIndex = 1
  elseif delta < 0 then
    now = currentTime + 1
    currentIndex = 1
  else
    currentIndex = currentIndex + 1
  end
  local nonce = xCmd_pb.Nonce()
  currentTime = now
  local sign = currentTime .. "_" .. currentIndex .. "_!^ro&"
  nonce.index = currentIndex
  nonce.timestamp = currentTime
  sign = NetUtil.getSha1(sign)
  if #sign ~= 40 then
    LogUtility.ErrorFormat("sign error \231\156\139\229\136\176\230\173\164\233\148\153\232\175\175\232\175\183\232\180\180\231\187\153\229\188\160\229\155\189\229\133\181\239\188\129\239\188\129\239\188\129sign:{0},sign size:{1}", sign, #sign)
    return
  end
  nonce.sign = sign
  local nonceStr = nonce:SerializeToString()
  if Game.NetConnectionManager and Game.NetConnectionManager.EnableNonce then
    NetManagerHelper.GameSend(id1, id2, nonceStr, str)
  else
    NetManagerHelper.GameSend(id1, id2, str)
  end
end
local ProtobufPool_Add = ProtobufPool.Add
local _Receive = function(id1, id2, data)
  local dataClass
  if not NetConfig.IsNoPbUnpack(id1, id2) then
    data, dataClass = NetProtocol.Unpack(id1, id2, data)
  end
  if data == nil then
    return
  end
  if NetConfig.IsHeart(id1, id2) or not NetConfig.IsCare(id1, id2) then
  end
  NetProtocol.DispatchListener(id1, id2, data)
  ProtobufPool_Add(dataClass, data)
end
local cachedReceives = {}
local _CacheReceive = function(id1, id2, str)
  local cache = ReusableTable.CreateArray()
  cache[1], cache[2], cache[3] = id1, id2, str
  cachedReceives[#cachedReceives + 1] = cache
end
local cacheIDMap = {}
function NetProtocol.NeedCacheReceive(id1, id2)
  local map = cacheIDMap[id1]
  if map == nil then
    map = {}
    cacheIDMap[id1] = map
  end
  map[id2] = true
end
function NetProtocol.Receive(id1, id2, str)
  NetProtocol.InfoFormat("NetProtocol::<color=yellow>Receive</color> id1:{0} id2:{1}", id1, id2)
  if NetProtocol.CachingSomeReceives then
    local map = cacheIDMap[id1]
    if map and map[id2] then
      _CacheReceive(id1, id2, str)
      return
    end
  end
  local memSample = Debug_LuaMemotry.SampleBegin("NetProtocolReceive")
  _Receive(id1, id2, str)
  Debug_LuaMemotry.SampleEnd(memSample)
end
function NetProtocol.CallCachedReceives()
  local cache
  for i = 1, #cachedReceives do
    cache = cachedReceives[i]
    _Receive(cache[1], cache[2], cache[3])
    ReusableTable.DestroyAndClearArray(cache)
  end
  TableUtility.ArrayClear(cachedReceives)
end
function NetProtocol.InfoFormat(fmt, ...)
  if Game.NetConnectionManager and Game.NetConnectionManager.EnableLog then
    LogUtility.InfoFormat(fmt, ...)
  end
end
function NetProtocol.Info(text)
  if Game.NetConnectionManager and Game.NetConnectionManager.EnableLog then
    LogUtility.Info(text)
  end
end
