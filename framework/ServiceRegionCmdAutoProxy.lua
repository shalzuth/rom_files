ServiceRegionCmdAutoProxy = class("ServiceRegionCmdAutoProxy", ServiceProxy)
ServiceRegionCmdAutoProxy.Instance = nil
ServiceRegionCmdAutoProxy.NAME = "ServiceRegionCmdAutoProxy"
function ServiceRegionCmdAutoProxy:ctor(proxyName)
  if ServiceRegionCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRegionCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRegionCmdAutoProxy.Instance = self
  end
end
function ServiceRegionCmdAutoProxy:Init()
end
function ServiceRegionCmdAutoProxy:onRegister()
  self:Listen(206, 1, function(data)
    self:RecvRegistRegionCmd(data)
  end)
end
function ServiceRegionCmdAutoProxy:CallRegistRegionCmd(zoneid)
  local msg = RegionCmd_pb.RegistRegionCmd()
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceRegionCmdAutoProxy:RecvRegistRegionCmd(data)
  self:Notify(ServiceEvent.RegionCmdRegistRegionCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.RegionCmdRegistRegionCmd = "ServiceEvent_RegionCmdRegistRegionCmd"
