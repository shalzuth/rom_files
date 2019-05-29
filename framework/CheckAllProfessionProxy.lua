CheckAllProfessionProxy = class("CheckAllProfessionProxy", pm.Proxy)
CheckAllProfessionProxy.Instance = nil
CheckAllProfessionProxy.NAME = "CheckAllProfessionProxy"
local tempTable = {}
function CheckAllProfessionProxy:ctor(proxyName, data)
  self.proxyName = proxyName or CheckAllProfessionProxy.NAME
  if CheckAllProfessionProxy.Instance == nil then
    CheckAllProfessionProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self:AddEvts()
end
function CheckAllProfessionProxy:Init()
end
function CheckAllProfessionProxy:AddEvts()
end
function CheckAllProfessionProxy:IsSelfTest()
  return true
end
function CheckAllProfessionProxy:GetCellFirstRowTable()
  tempTable = {}
  for k, v in pairs(Table_Class) do
    if v.id ~= 1 and v.id % 10 == 1 then
      table.insert(tempTable, v)
    end
  end
  if Table_Class[143] then
    table.insert(tempTable, Table_Class[143])
  else
    helplog("\229\189\147\229\137\141\231\173\150\229\136\146\232\161\168\228\184\173\230\151\160143\239\188\129\239\188\129")
  end
  table.sort(tempTable, function(a, b)
    return a.id < b.id
  end)
  return tempTable
end
return CheckAllProfessionProxy
