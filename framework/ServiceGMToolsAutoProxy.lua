ServiceGMToolsAutoProxy = class("ServiceGMToolsAutoProxy", ServiceProxy)
ServiceGMToolsAutoProxy.Instance = nil
ServiceGMToolsAutoProxy.NAME = "ServiceGMToolsAutoProxy"
function ServiceGMToolsAutoProxy:ctor(proxyName)
  if ServiceGMToolsAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGMToolsAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGMToolsAutoProxy.Instance = self
  end
end
function ServiceGMToolsAutoProxy:Init()
end
function ServiceGMToolsAutoProxy:onRegister()
  self:Listen(203, 2, function(data)
    self:RecvRetExecGMCmd(data)
  end)
  self:Listen(203, 3, function(data)
    self:RecvSessionGMCmd(data)
  end)
end
function ServiceGMToolsAutoProxy:CallRetExecGMCmd(ret, data, conid)
  local msg = GMTools_pb.RetExecGMCmd()
  if ret ~= nil then
    msg.ret = ret
  end
  if data ~= nil then
    msg.data = data
  end
  if conid ~= nil then
    msg.conid = conid
  end
  self:SendProto(msg)
end
function ServiceGMToolsAutoProxy:CallSessionGMCmd(charid, mapid, data)
  local msg = GMTools_pb.SessionGMCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if data ~= nil then
    msg.data = data
  end
  self:SendProto(msg)
end
function ServiceGMToolsAutoProxy:RecvRetExecGMCmd(data)
  self:Notify(ServiceEvent.GMToolsRetExecGMCmd, data)
end
function ServiceGMToolsAutoProxy:RecvSessionGMCmd(data)
  self:Notify(ServiceEvent.GMToolsSessionGMCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.GMToolsRetExecGMCmd = "ServiceEvent_GMToolsRetExecGMCmd"
ServiceEvent.GMToolsSessionGMCmd = "ServiceEvent_GMToolsSessionGMCmd"
