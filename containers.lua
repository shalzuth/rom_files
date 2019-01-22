--
--------------------------------------------------------------------------------
--  FILE:  containers.lua
--  DESCRIPTION:  protoc-gen-lua
--      Google's Protocol Buffers project, ported to lua.
--      https://code.google.com/p/protoc-gen-lua/
--
--      Copyright (c) 2010 , ????????? (Zhuoyi Lin) netsnail@gmail.com
--      All rights reserved.
--
--      Use, modification and distribution are subject to the "New BSD License"
--      as listed at <url: http://www.opensource.org/licenses/bsd-license.php >.
--
--  COMPANY:  NetEase
--  CREATED:  2010???08???02??? 16???15???42??? CST
--------------------------------------------------------------------------------
--
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

module "containers"

local _RCFC_meta = {
    add = function(self)
        -- local value = self._message_descriptor._concrete_class()
        local value = ProtobufPool_Get(self._message_descriptor._concrete_class)
        -- LogUtility.InfoFormat("_RCFC_meta.Add {0}",self._message_descriptor._concrete_class.name)
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
        if(not self._isActive) then
            LogUtility.Info("<color=red>???????????????pb array ???????????????????????????</color>")
            errorLog("???????????????pb array ???????????????????????????")
        end
        local listener = self._listener
        rawset(self, #self + 1, value)
        value:_SetListener(listener)
        if listener.dirty == false then
            listener:Modified()
        end
        return value
        -- error("RepeatedCompositeFieldContainer Can't set value directly")
    end
}
_RCFC_meta.__index = _RCFC_meta

function RepeatedCompositeFieldContainer(listener, message_descriptor)
    local array = ProtobufPool_GetArray(1)
    if(array==nil) then
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
        -- error("RepeatedCompositeFieldContainer Can't set value directly")
    end
}
_RSFC_meta.__index = _RSFC_meta

function RepeatedScalarFieldContainer(listener, type_checker)
    local o = {}
    o._listener = listener
    o._type_checker = type_checker
    return setmetatable(o, _RSFC_meta)
end


