ServiceSystemCmdAutoProxy = class("ServiceSystemCmdAutoProxy", ServiceProxy)
ServiceSystemCmdAutoProxy.Instance = nil
ServiceSystemCmdAutoProxy.NAME = "ServiceSystemCmdAutoProxy"
function ServiceSystemCmdAutoProxy:ctor(proxyName)
  if ServiceSystemCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSystemCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSystemCmdAutoProxy.Instance = self
  end
end
function ServiceSystemCmdAutoProxy:Init()
end
function ServiceSystemCmdAutoProxy:onRegister()
  self:Listen(255, 1, function(data)
    self:RecvHeartBeatSystemCmd(data)
  end)
  self:Listen(255, 2, function(data)
    self:RecvVerifyConnSystemCmd(data)
  end)
  self:Listen(255, 3, function(data)
    self:RecvServerListSystemCmd(data)
  end)
  self:Listen(255, 4, function(data)
    self:RecvServerInitOkConnSystemCmd(data)
  end)
  self:Listen(255, 5, function(data)
    self:RecvServerTimeSystemCmd(data)
  end)
  self:Listen(255, 6, function(data)
    self:RecvRegistRegionSystemCmd(data)
  end)
  self:Listen(255, 7, function(data)
    self:RecvCommonReloadSystemCmd(data)
  end)
  self:Listen(255, 8, function(data)
    self:RecvInfoProxySystemCmd(data)
  end)
  self:Listen(255, 9, function(data)
    self:RecvRegistProxySystemCmd(data)
  end)
  self:Listen(255, 10, function(data)
    self:RecvRegistTeamSystemCmd(data)
  end)
end
function ServiceSystemCmdAutoProxy:CallHeartBeatSystemCmd()
  local msg = SystemCmd_pb.HeartBeatSystemCmd()
  self:SendProto(msg)
end
function ServiceSystemCmdAutoProxy:CallVerifyConnSystemCmd(type, name, ret)
  local msg = SystemCmd_pb.VerifyConnSystemCmd()
  if type ~= nil then
    msg.type = type
  end
  if name ~= nil then
    msg.name = name
  end
  if ret ~= nil then
    msg.ret = ret
  end
  self:SendProto(msg)
end
function ServiceSystemCmdAutoProxy:CallServerListSystemCmd(type, name, ip, port, list)
  local msg = SystemCmd_pb.ServerListSystemCmd()
  if type ~= nil then
    msg.type = type
  end
  if name ~= nil then
    msg.name = name
  end
  if ip ~= nil then
    msg.ip = ip
  end
  if port ~= nil then
    msg.port = port
  end
  if list ~= nil then
    for i = 1, #list do
      table.insert(msg.list, list[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSystemCmdAutoProxy:CallServerInitOkConnSystemCmd(name)
  local msg = SystemCmd_pb.ServerInitOkConnSystemCmd()
  if name ~= nil then
    msg.name = name
  end
  self:SendProto(msg)
end
function ServiceSystemCmdAutoProxy:CallServerTimeSystemCmd(adjust)
  local msg = SystemCmd_pb.ServerTimeSystemCmd()
  if adjust ~= nil then
    msg.adjust = adjust
  end
  self:SendProto(msg)
end
function ServiceSystemCmdAutoProxy:CallRegistRegionSystemCmd(zoneid, regiontype, servertype, client)
  local msg = SystemCmd_pb.RegistRegionSystemCmd()
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if regiontype ~= nil then
    msg.regiontype = regiontype
  end
  if servertype ~= nil then
    msg.servertype = servertype
  end
  if client ~= nil then
    msg.client = client
  end
  self:SendProto(msg)
end
function ServiceSystemCmdAutoProxy:CallCommonReloadSystemCmd(type)
  local msg = SystemCmd_pb.CommonReloadSystemCmd()
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceSystemCmdAutoProxy:CallInfoProxySystemCmd(proxyid, tasknum)
  local msg = SystemCmd_pb.InfoProxySystemCmd()
  if proxyid ~= nil then
    msg.proxyid = proxyid
  end
  if tasknum ~= nil then
    msg.tasknum = tasknum
  end
  self:SendProto(msg)
end
function ServiceSystemCmdAutoProxy:CallRegistProxySystemCmd(proxyid)
  local msg = SystemCmd_pb.RegistProxySystemCmd()
  if proxyid ~= nil then
    msg.proxyid = proxyid
  end
  self:SendProto(msg)
end
function ServiceSystemCmdAutoProxy:CallRegistTeamSystemCmd(teamsvrid)
  local msg = SystemCmd_pb.RegistTeamSystemCmd()
  if teamsvrid ~= nil then
    msg.teamsvrid = teamsvrid
  end
  self:SendProto(msg)
end
function ServiceSystemCmdAutoProxy:RecvHeartBeatSystemCmd(data)
  self:Notify(ServiceEvent.SystemCmdHeartBeatSystemCmd, data)
end
function ServiceSystemCmdAutoProxy:RecvVerifyConnSystemCmd(data)
  self:Notify(ServiceEvent.SystemCmdVerifyConnSystemCmd, data)
end
function ServiceSystemCmdAutoProxy:RecvServerListSystemCmd(data)
  self:Notify(ServiceEvent.SystemCmdServerListSystemCmd, data)
end
function ServiceSystemCmdAutoProxy:RecvServerInitOkConnSystemCmd(data)
  self:Notify(ServiceEvent.SystemCmdServerInitOkConnSystemCmd, data)
end
function ServiceSystemCmdAutoProxy:RecvServerTimeSystemCmd(data)
  self:Notify(ServiceEvent.SystemCmdServerTimeSystemCmd, data)
end
function ServiceSystemCmdAutoProxy:RecvRegistRegionSystemCmd(data)
  self:Notify(ServiceEvent.SystemCmdRegistRegionSystemCmd, data)
end
function ServiceSystemCmdAutoProxy:RecvCommonReloadSystemCmd(data)
  self:Notify(ServiceEvent.SystemCmdCommonReloadSystemCmd, data)
end
function ServiceSystemCmdAutoProxy:RecvInfoProxySystemCmd(data)
  self:Notify(ServiceEvent.SystemCmdInfoProxySystemCmd, data)
end
function ServiceSystemCmdAutoProxy:RecvRegistProxySystemCmd(data)
  self:Notify(ServiceEvent.SystemCmdRegistProxySystemCmd, data)
end
function ServiceSystemCmdAutoProxy:RecvRegistTeamSystemCmd(data)
  self:Notify(ServiceEvent.SystemCmdRegistTeamSystemCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SystemCmdHeartBeatSystemCmd = "ServiceEvent_SystemCmdHeartBeatSystemCmd"
ServiceEvent.SystemCmdVerifyConnSystemCmd = "ServiceEvent_SystemCmdVerifyConnSystemCmd"
ServiceEvent.SystemCmdServerListSystemCmd = "ServiceEvent_SystemCmdServerListSystemCmd"
ServiceEvent.SystemCmdServerInitOkConnSystemCmd = "ServiceEvent_SystemCmdServerInitOkConnSystemCmd"
ServiceEvent.SystemCmdServerTimeSystemCmd = "ServiceEvent_SystemCmdServerTimeSystemCmd"
ServiceEvent.SystemCmdRegistRegionSystemCmd = "ServiceEvent_SystemCmdRegistRegionSystemCmd"
ServiceEvent.SystemCmdCommonReloadSystemCmd = "ServiceEvent_SystemCmdCommonReloadSystemCmd"
ServiceEvent.SystemCmdInfoProxySystemCmd = "ServiceEvent_SystemCmdInfoProxySystemCmd"
ServiceEvent.SystemCmdRegistProxySystemCmd = "ServiceEvent_SystemCmdRegistProxySystemCmd"
ServiceEvent.SystemCmdRegistTeamSystemCmd = "ServiceEvent_SystemCmdRegistTeamSystemCmd"
