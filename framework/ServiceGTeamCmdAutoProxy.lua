ServiceGTeamCmdAutoProxy = class("ServiceGTeamCmdAutoProxy", ServiceProxy)
ServiceGTeamCmdAutoProxy.Instance = nil
ServiceGTeamCmdAutoProxy.NAME = "ServiceGTeamCmdAutoProxy"
function ServiceGTeamCmdAutoProxy:ctor(proxyName)
  if ServiceGTeamCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGTeamCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGTeamCmdAutoProxy.Instance = self
  end
end
function ServiceGTeamCmdAutoProxy:Init()
end
function ServiceGTeamCmdAutoProxy:onRegister()
  self:Listen(215, 21, function(data)
    self:RecvSyncTeamGTeamCmd(data)
  end)
  self:Listen(215, 22, function(data)
    self:RecvInitTeamGTeamCmd(data)
  end)
  self:Listen(215, 23, function(data)
    self:RecvJoinTeamGTeamCmd(data)
  end)
  self:Listen(215, 24, function(data)
    self:RecvLoadTeamGTeamCmd(data)
  end)
  self:Listen(215, 25, function(data)
    self:RecvRemoveMemberGTeamCmd(data)
  end)
end
function ServiceGTeamCmdAutoProxy:CallSyncTeamGTeamCmd()
  local msg = GTeamCmd_pb.SyncTeamGTeamCmd()
  self:SendProto(msg)
end
function ServiceGTeamCmdAutoProxy:CallInitTeamGTeamCmd()
  local msg = GTeamCmd_pb.InitTeamGTeamCmd()
  self:SendProto(msg)
end
function ServiceGTeamCmdAutoProxy:CallJoinTeamGTeamCmd(charid, user, teamid, action)
  local msg = GTeamCmd_pb.JoinTeamGTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if user.user ~= nil and user.user.accid ~= nil then
    msg.user.user.accid = user.user.accid
  end
  if user.user ~= nil and user.user.charid ~= nil then
    msg.user.user.charid = user.user.charid
  end
  if user.user ~= nil and user.user.zoneid ~= nil then
    msg.user.user.zoneid = user.user.zoneid
  end
  if user.user ~= nil and user.user.mapid ~= nil then
    msg.user.user.mapid = user.user.mapid
  end
  if user.user ~= nil and user.user.baselv ~= nil then
    msg.user.user.baselv = user.user.baselv
  end
  if user.user ~= nil and user.user.profession ~= nil then
    msg.user.user.profession = user.user.profession
  end
  if user.user ~= nil and user.user.name ~= nil then
    msg.user.user.name = user.user.name
  end
  if user.user ~= nil and user.user.guildid ~= nil then
    msg.user.user.guildid = user.user.guildid
  end
  if user ~= nil and user.datas ~= nil then
    for i = 1, #user.datas do
      table.insert(msg.user.datas, user.datas[i])
    end
  end
  if user ~= nil and user.attrs ~= nil then
    for i = 1, #user.attrs do
      table.insert(msg.user.attrs, user.attrs[i])
    end
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if action ~= nil then
    msg.action = action
  end
  self:SendProto(msg)
end
function ServiceGTeamCmdAutoProxy:CallLoadTeamGTeamCmd(teamids)
  local msg = GTeamCmd_pb.LoadTeamGTeamCmd()
  if teamids ~= nil then
    for i = 1, #teamids do
      table.insert(msg.teamids, teamids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGTeamCmdAutoProxy:CallRemoveMemberGTeamCmd(teamid, charid)
  local msg = GTeamCmd_pb.RemoveMemberGTeamCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceGTeamCmdAutoProxy:RecvSyncTeamGTeamCmd(data)
  self:Notify(ServiceEvent.GTeamCmdSyncTeamGTeamCmd, data)
end
function ServiceGTeamCmdAutoProxy:RecvInitTeamGTeamCmd(data)
  self:Notify(ServiceEvent.GTeamCmdInitTeamGTeamCmd, data)
end
function ServiceGTeamCmdAutoProxy:RecvJoinTeamGTeamCmd(data)
  self:Notify(ServiceEvent.GTeamCmdJoinTeamGTeamCmd, data)
end
function ServiceGTeamCmdAutoProxy:RecvLoadTeamGTeamCmd(data)
  self:Notify(ServiceEvent.GTeamCmdLoadTeamGTeamCmd, data)
end
function ServiceGTeamCmdAutoProxy:RecvRemoveMemberGTeamCmd(data)
  self:Notify(ServiceEvent.GTeamCmdRemoveMemberGTeamCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.GTeamCmdSyncTeamGTeamCmd = "ServiceEvent_GTeamCmdSyncTeamGTeamCmd"
ServiceEvent.GTeamCmdInitTeamGTeamCmd = "ServiceEvent_GTeamCmdInitTeamGTeamCmd"
ServiceEvent.GTeamCmdJoinTeamGTeamCmd = "ServiceEvent_GTeamCmdJoinTeamGTeamCmd"
ServiceEvent.GTeamCmdLoadTeamGTeamCmd = "ServiceEvent_GTeamCmdLoadTeamGTeamCmd"
ServiceEvent.GTeamCmdRemoveMemberGTeamCmd = "ServiceEvent_GTeamCmdRemoveMemberGTeamCmd"
