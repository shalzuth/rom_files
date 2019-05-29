ServentEquipProxy = class("ServentEquipProxy", pm.Proxy)
ServentEquipProxy.Instance = nil
ServentEquipProxy.NAME = "ServentEquipProxy"
function ServentEquipProxy:DebugLog(msg)
  if false then
    LogUtility.Info("-------ServentEquipProxy-----------:::" .. msg)
  end
end
function ServentEquipProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ServentEquipProxy.NAME
  if ServentEquipProxy.Instance == nil then
    ServentEquipProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self:AddEvts()
end
function ServentEquipProxy:Init()
end
function ServentEquipProxy:AddEvts()
end
function ServentEquipProxy:OnPause(note)
end
return ServentEquipProxy
