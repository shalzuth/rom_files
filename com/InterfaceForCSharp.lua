using("UnityEngine")
using("RO")
require("Script.Main.Import")
autoImport("oop")
autoImport("LuaGameObject_Sample")
local InterfaceForCSharp = {}
function InterfaceForCSharp.Command(cmd)
end
function InterfaceForCSharp.RegisterGameObject(obj)
  local pStr = "Empty"
  local properties = obj.properties
  if nil ~= properties and #properties > 0 then
    pStr = "{" .. properties[1]
    for i = 2, #properties do
      pStr = pStr .. ", " .. properties[i]
    end
    pStr = pStr .. "}"
  end
  if LuaGameObject_Sample.Type == obj.type then
    return LuaGameObject_Sample.Me():Add(obj)
  end
  return true
end
function InterfaceForCSharp.UnregisterGameObject(obj)
  if LuaGameObject_Sample.Type == obj.type then
    return LuaGameObject_Sample.Me():Remove(obj)
  end
  return true
end
return InterfaceForCSharp
