local setmetatable = setmetatable
local table = table
local rawset = rawset
local tostring = tostring
local error = error
local errorLog = errorLog
local ProtobufPool = ProtobufPool
local ProtobufPool_Get = ProtobufPool.Get
local ProtobufPool_GetArray = ProtobufPool.GetArray
local LogUtility = LogUtility
module("containers")
local _RCFC_meta = {
  add = function(self)
    local value = ProtobufPool_Get(self._message_descriptor._concrete_class)
    local listener = self._listener
    rawset(self, #self + 1, value)
    value:_SetListener(listener)
    if listener.dirty == false then
      listener:Modified()
    end
    return value
  end,
  remove = function(self, key)
    local listener = self._listener
    table.remove(self, key)
    listener:Modified()
  end,
  __newindex = function(self, key, value)
    if not self._isActive then
      LogUtility.Info("<color=red>\230\148\190\229\155\158\230\177\160\229\173\144\231\154\132pb array \232\162\171\228\186\186\230\140\129\230\156\137\229\188\149\231\148\168\229\185\182\232\176\131\231\148\168</color>")
      errorLog("\230\148\190\229\155\158\230\177\160\229\173\144\231\154\132pb array \232\162\171\228\186\186\230\140\129\230\156\137\229\188\149\231\148\168\229\185\182\232\176\131\231\148\168")
    end
    local listener = self._listener
    rawset(self, #self + 1, value)
    value:_SetListener(listener)
    if listener.dirty == false then
      listener:Modified()
    end
    return value
  end
}
_RCFC_meta.__index = _RCFC_meta
function RepeatedCompositeFieldContainer(listener, message_descriptor)
  local array = ProtobufPool_GetArray(1)
  if array == nil then
    local o = {
      _isActive = true,
      _listener = listener,
      _message_descriptor = message_descriptor
    }
    return setmetatable(o, _RCFC_meta)
  else
    array._isActive = true
    array._listener = listener
    array._message_descriptor = message_descriptor
  end
  return array
end
local _RSFC_meta = {
  append = function(self, value)
    self._type_checker(value)
    rawset(self, #self + 1, value)
    self._listener:Modified()
  end,
  remove = function(self, key)
    table.remove(self, key)
    self._listener:Modified()
  end,
  __newindex = function(self, key, value)
    self._type_checker(value)
    rawset(self, #self + 1, value)
    self._listener:Modified()
    return value
  end
}
_RSFC_meta.__index = _RSFC_meta
function RepeatedScalarFieldContainer(listener, type_checker)
  local o = {}
  o._listener = listener
  o._type_checker = type_checker
  return setmetatable(o, _RSFC_meta)
end
