ResolveEquipProxy = class("ResolveEquipProxy", pm.Proxy)
ResolveEquipProxy.Instance = nil
ResolveEquipProxy.NAME = "ResolveEquipProxy"
function ResolveEquipProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ResolveEquipProxy.NAME
  if ResolveEquipProxy.Instance == nil then
    ResolveEquipProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function ResolveEquipProxy:Init()
end
function ResolveEquipProxy:UpdateQueryEquipData(data)
  if data then
    self.QueryEquipData = data
  else
  end
end
function ResolveEquipProxy:CalculateResolveEquip()
end
