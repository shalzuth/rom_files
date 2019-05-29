ServiceGZoneCmdAutoProxy = class("ServiceGZoneCmdAutoProxy", ServiceProxy)
ServiceGZoneCmdAutoProxy.Instance = nil
ServiceGZoneCmdAutoProxy.NAME = "ServiceGZoneCmdAutoProxy"
function ServiceGZoneCmdAutoProxy:ctor(proxyName)
  if ServiceGZoneCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGZoneCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGZoneCmdAutoProxy.Instance = self
  end
end
function ServiceGZoneCmdAutoProxy:Init()
end
function ServiceGZoneCmdAutoProxy:onRegister()
  self:Listen(211, 1, function(data)
    self:RecvUpdateActiveOnlineGZoneCmd(data)
  end)
end
function ServiceGZoneCmdAutoProxy:CallUpdateActiveOnlineGZoneCmd(zoneid, active, online)
  local msg = GZoneCmd_pb.UpdateActiveOnlineGZoneCmd()
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if active ~= nil then
    msg.active = active
  end
  if online ~= nil then
    msg.online = online
  end
  self:SendProto(msg)
end
function ServiceGZoneCmdAutoProxy:RecvUpdateActiveOnlineGZoneCmd(data)
  self:Notify(ServiceEvent.GZoneCmdUpdateActiveOnlineGZoneCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.GZoneCmdUpdateActiveOnlineGZoneCmd = "ServiceEvent_GZoneCmdUpdateActiveOnlineGZoneCmd"
