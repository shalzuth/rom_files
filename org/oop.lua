function class(classname, super)
  local superType = type(super)
  local cls
  if superType ~= "function" and superType ~= "table" then
    super, superType = nil, nil
  end
  if superType == "function" or super and super.__ctype == 1 then
    cls = {}
    if superType == "table" then
      for k, v in pairs(super) do
        cls[k] = v
      end
      cls.__create = super.__create
      cls.super = super
    else
      cls.__create = super
      function cls.ctor()
      end
    end
    cls.__cname = classname
    cls.__ctype = 1
    function cls.new(...)
      local instance = cls.__create(...)
      for k, v in pairs(cls) do
        instance[k] = v
      end
      instance.class = cls
      instance:ctor(...)
      return instance
    end
  else
    if super then
      cls = {}
      setmetatable(cls, {__index = super})
      cls.super = super
    else
      cls = {
        ctor = function()
        end
      }
    end
    cls.__cname = classname
    cls.__ctype = 2
    cls.__index = cls
    function cls.new(...)
      local instance = setmetatable({}, cls)
      instance.class = cls
      instance:ctor(...)
      return instance
    end
  end
  return cls
end
function reusableClass(classname, super)
  local cls = class(classname, super or ReusableObject)
  function cls.CreateAsArray(args)
    return ReusableObject.Create(cls, true, args)
  end
  function cls.CreateAsTable(args)
    return ReusableObject.Create(cls, false, args)
  end
  return cls
end
function ArrayPropClass(classname, super, props)
  local cls
  if super then
    cls = {}
    setmetatable(cls, {__index = super})
    cls.super = super
  else
    cls = {
      ctor = function()
      end
    }
    cls.PDATA = {}
    cls.PDATAIndex = 1
  end
  cls.__cname = classname
  local set, get = {}, {}
  if props == nil then
    props = ReusableTable.CreateArray()
    props[1] = "class"
  else
    table.insert(props, 1, "class")
  end
  local f
  function cls.__index(t, k)
    f = rawget(cls, k)
    if f then
      return f
    end
    f = rawget(get, k)
    if f then
      return f(t)
    end
    if super then
      return super.__index(t, k)
    end
    error("Not found " .. k)
  end
  function cls.__newindex(t, k, v)
    local f = rawget(set, k)
    if f then
      return f(t, v)
    end
    if super then
      return super.__newindex(t, k, v)
    end
    error("Not found " .. k)
  end
  local p
  for i = 1, #props do
    p = props[i]
    local index
    if cls.PDATA[p] == nil then
      index = cls.PDATAIndex
      set[p] = function(self, v)
        rawset(self, index, v)
      end
      get[p] = function(self)
        return rawget(self, index)
      end
      cls.PDATA[p] = index
      cls.PDATAIndex = index + 1
    else
    end
  end
  function cls.new(...)
    local instance = setmetatable({}, cls)
    instance.class = cls
    instance:ctor(...)
    return instance
  end
  ReusableTable.DestroyAndClearArray(props)
  return cls
end
function string.split(str, delimiter)
  str = tostring(str)
  delimiter = tostring(delimiter)
  if delimiter == "" then
    return false
  end
  local pos, arr = 0, {}
  for st, sp in function()
    return string.find(str, delimiter, pos, true)
  end, nil, nil do
    table.insert(arr, string.sub(str, pos, st - 1))
    pos = sp + 1
  end
  table.insert(arr, string.sub(str, pos))
  return arr
end
function import(moduleName, currentModuleName)
  local currentModuleNameParts
  local moduleFullName = moduleName
  local offset = 1
  while true do
    if string.byte(moduleName, offset) ~= 46 then
      moduleFullName = string.sub(moduleName, offset)
      if currentModuleNameParts and #currentModuleNameParts > 0 then
        moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
      end
      break
    end
    offset = offset + 1
    if not currentModuleNameParts then
      if not currentModuleName then
        local n, v = debug.getlocal(3, 1)
        currentModuleName = v
      end
      currentModuleNameParts = string.split(currentModuleName, ".")
    end
    table.remove(currentModuleNameParts, #currentModuleNameParts)
  end
  return require(moduleFullName)
end
local property_getter = function(message_meta, super)
  return function(self, property)
    local f = rawget(message_meta, property)
    if f ~= nil then
      return f
    end
    f = self._fields[property]
    if f ~= nil then
      if self.Alive and not self:Alive() then
        LogUtility.InfoFormat("<color=red>class :{0} \229\183\178\231\187\143\232\162\171\230\148\190\229\155\158\230\177\160\229\173\144\228\186\134\239\188\140\228\189\134\230\152\175\232\142\183\229\143\150\229\177\158\230\128\167 key:{1}</color>", message_meta.__cname, tostring(property))
      end
      return f
    end
    if super then
      return super.__index(self, property)
    end
  end
end
local property_setter = function(message_meta, super)
  return function(self, property, value)
    if self.Alive and not self:Alive() then
      LogUtility.InfoFormat("<color=red>class :{0} \229\183\178\231\187\143\232\162\171\230\148\190\229\155\158\230\177\160\229\173\144\228\186\134\239\188\140\228\189\134\230\152\175\229\141\180\229\156\168\232\174\190\231\189\174\229\177\158\230\128\167 key:{1} value:{2}</color>", message_meta.__cname, tostring(property), tostring(value))
    end
    self._fields[property] = value
  end
end
local getSetMeta = {}
getSetMeta.__index = property_getter(getSetMeta)
getSetMeta.__newindex = property_setter(getSetMeta)
function getmetaWithGetSet()
  return getSetMeta
end
function getsetclass(classname, super)
  local superType = type(super)
  local cls
  if superType ~= "function" and superType ~= "table" then
    super, superType = nil, nil
  end
  if superType == "function" or super and super.__ctype == 1 then
    cls = {}
    if superType == "table" then
      for k, v in pairs(super) do
        cls[k] = v
      end
      cls.__create = super.__create
      cls.super = super
    else
      cls.__create = super
      function cls.ctor()
      end
    end
    cls.__cname = classname
    cls.__ctype = 1
    function cls.new(...)
      local instance = cls.__create(...)
      for k, v in pairs(cls) do
        instance[k] = v
      end
      instance.class = cls
      instance:ctor(...)
      return instance
    end
  else
    if super then
      cls = {}
      setmetatable(cls, {__index = super})
      cls.super = super
    else
      cls = {
        ctor = function()
        end
      }
    end
    cls.__cname = classname
    cls.__ctype = 2
    cls.__index = property_getter(cls, super)
    cls.__newindex = property_setter(cls)
    function cls.new(...)
      local t = {}
      t._fields = {}
      t.class = cls
      t.instanceID = 0
      t._alive = true
      local instance = setmetatable(t, cls)
      instance:ctor(...)
      return instance
    end
  end
  return cls
end
ClassNeedGetSet = false
if ClassNeedGetSet then
  class = getsetclass
end
