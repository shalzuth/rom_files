ServiceTeamCmdAutoProxy = class("ServiceTeamCmdAutoProxy", ServiceProxy)
ServiceTeamCmdAutoProxy.Instance = nil
ServiceTeamCmdAutoProxy.NAME = "ServiceTeamCmdAutoProxy"
function ServiceTeamCmdAutoProxy:ctor(proxyName)
  if ServiceTeamCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceTeamCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceTeamCmdAutoProxy.Instance = self
  end
end
function ServiceTeamCmdAutoProxy:Init()
end
function ServiceTeamCmdAutoProxy:onRegister()
  self:Listen(209, 1, function(data)
    self:RecvForwardAllServerTeamCmd(data)
  end)
  self:Listen(209, 2, function(data)
    self:RecvUpdateGuildServerTeamCmd(data)
  end)
  self:Listen(209, 4, function(data)
    self:RecvAddRelationTeamCmd(data)
  end)
  self:Listen(209, 5, function(data)
    self:RecvLoadLuaTeamCmd(data)
  end)
  self:Listen(209, 8, function(data)
    self:RecvTeamDataSyncTeamCmd(data)
  end)
  self:Listen(209, 9, function(data)
    self:RecvTeamDataUpdateTeamCmd(data)
  end)
  self:Listen(209, 10, function(data)
    self:RecvTeamMemberUpdateTeamCmd(data)
  end)
  self:Listen(209, 11, function(data)
    self:RecvMemberDataUpdateTeamCmd(data)
  end)
  self:Listen(209, 12, function(data)
    self:RecvBroadcastCmdTeamCmd(data)
  end)
  self:Listen(209, 13, function(data)
    self:RecvCatEnterTeamCmd(data)
  end)
  self:Listen(209, 14, function(data)
    self:RecvCatExitTeamCmd(data)
  end)
  self:Listen(209, 15, function(data)
    self:RecvCatFireTeamCmd(data)
  end)
  self:Listen(209, 16, function(data)
    self:RecvCatCallTeamCmd(data)
  end)
  self:Listen(209, 17, function(data)
    self:RecvBeLeaderTeamCmd(data)
  end)
  self:Listen(209, 18, function(data)
    self:RecvCatEnterOwnTeamCmd(data)
  end)
  self:Listen(209, 19, function(data)
    self:RecvTeamInfoSyncTeamCmd(data)
  end)
  self:Listen(209, 20, function(data)
    self:RecvSyncOnlineUserTeamCmd(data)
  end)
  self:Listen(209, 21, function(data)
    self:RecvRemoveApplyTeamCmd(data)
  end)
end
function ServiceTeamCmdAutoProxy:CallForwardAllServerTeamCmd(charid, data, len)
  local msg = TeamCmd_pb.ForwardAllServerTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallUpdateGuildServerTeamCmd(charid, guildid, guildname)
  local msg = TeamCmd_pb.UpdateGuildServerTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if guildname ~= nil then
    msg.guildname = guildname
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallAddRelationTeamCmd(charid, targetid)
  local msg = TeamCmd_pb.AddRelationTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if targetid ~= nil then
    msg.targetid = targetid
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallLoadLuaTeamCmd(table, lua, log)
  local msg = TeamCmd_pb.LoadLuaTeamCmd()
  if table ~= nil then
    msg.table = table
  end
  if lua ~= nil then
    msg.lua = lua
  end
  if log ~= nil then
    msg.log = log
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallTeamDataSyncTeamCmd(charid, info, online)
  local msg = TeamCmd_pb.TeamDataSyncTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if info ~= nil and info.teamid ~= nil then
    msg.info.teamid = info.teamid
  end
  if info ~= nil and info.leaderid ~= nil then
    msg.info.leaderid = info.leaderid
  end
  if info ~= nil and info.pickupmode ~= nil then
    msg.info.pickupmode = info.pickupmode
  end
  if info ~= nil and info.member ~= nil then
    for i = 1, #info.member do
      table.insert(msg.info.member, info.member[i])
    end
  end
  if info ~= nil and info.name ~= nil then
    msg.info.name = info.name
  end
  if info ~= nil and info.minlv ~= nil then
    msg.info.minlv = info.minlv
  end
  if info ~= nil and info.maxlv ~= nil then
    msg.info.maxlv = info.maxlv
  end
  if info ~= nil and info.type ~= nil then
    msg.info.type = info.type
  end
  if info ~= nil and info.autoaccept ~= nil then
    msg.info.autoaccept = info.autoaccept
  end
  if info ~= nil and info.teamsvrid ~= nil then
    msg.info.teamsvrid = info.teamsvrid
  end
  if info ~= nil and info.state ~= nil then
    msg.info.state = info.state
  end
  if info ~= nil and info.desc ~= nil then
    msg.info.desc = info.desc
  end
  if online ~= nil then
    msg.online = online
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallTeamDataUpdateTeamCmd(charid, datas, teamid)
  local msg = TeamCmd_pb.TeamDataUpdateTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallTeamMemberUpdateTeamCmd(charid, updates, dels, teamid)
  local msg = TeamCmd_pb.TeamMemberUpdateTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  if dels ~= nil then
    for i = 1, #dels do
      table.insert(msg.dels, dels[i])
    end
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallMemberDataUpdateTeamCmd(charid, updatecharid, updates)
  local msg = TeamCmd_pb.MemberDataUpdateTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if updatecharid ~= nil then
    msg.updatecharid = updatecharid
  end
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallBroadcastCmdTeamCmd(type, id, data, len)
  local msg = TeamCmd_pb.BroadcastCmdTeamCmd()
  if type ~= nil then
    msg.type = type
  end
  if id ~= nil then
    msg.id = id
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallCatEnterTeamCmd(charid, cats)
  local msg = TeamCmd_pb.CatEnterTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if cats ~= nil then
    for i = 1, #cats do
      table.insert(msg.cats, cats[i])
    end
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallCatExitTeamCmd(charid, catid, enterfail)
  local msg = TeamCmd_pb.CatExitTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if catid ~= nil then
    msg.catid = catid
  end
  if enterfail ~= nil then
    msg.enterfail = enterfail
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallCatFireTeamCmd(charid, npcid, catid)
  local msg = TeamCmd_pb.CatFireTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if catid ~= nil then
    msg.catid = catid
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallCatCallTeamCmd(charid)
  local msg = TeamCmd_pb.CatCallTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallBeLeaderTeamCmd(charid, teamjob)
  local msg = TeamCmd_pb.BeLeaderTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if teamjob ~= nil then
    msg.teamjob = teamjob
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallCatEnterOwnTeamCmd(charid, data, zoneid)
  local msg = TeamCmd_pb.CatEnterOwnTeamCmd()
  msg.charid = charid
  if data ~= nil and data.guid ~= nil then
    msg.data.guid = data.guid
  end
  if data ~= nil and data.zoneid ~= nil then
    msg.data.zoneid = data.zoneid
  end
  if data ~= nil and data.name ~= nil then
    msg.data.name = data.name
  end
  if data ~= nil and data.items ~= nil then
    for i = 1, #data.items do
      table.insert(msg.data.items, data.items[i])
    end
  end
  if data ~= nil and data.members ~= nil then
    for i = 1, #data.members do
      table.insert(msg.data.members, data.members[i])
    end
  end
  if data ~= nil and data.applys ~= nil then
    for i = 1, #data.applys do
      table.insert(msg.data.applys, data.applys[i])
    end
  end
  if data.seal ~= nil and data.seal.seal ~= nil then
    msg.data.seal.seal = data.seal.seal
  end
  if data.seal ~= nil and data.seal.zoneid ~= nil then
    msg.data.seal.zoneid = data.seal.zoneid
  end
  if data.seal.pos ~= nil and data.seal.pos.x ~= nil then
    msg.data.seal.pos.x = data.seal.pos.x
  end
  if data.seal.pos ~= nil and data.seal.pos.y ~= nil then
    msg.data.seal.pos.y = data.seal.pos.y
  end
  if data.seal.pos ~= nil and data.seal.pos.z ~= nil then
    msg.data.seal.pos.z = data.seal.pos.z
  end
  if data.seal ~= nil and data.seal.teamid ~= nil then
    msg.data.seal.teamid = data.seal.teamid
  end
  if data.seal ~= nil and data.seal.lastonlinetime ~= nil then
    msg.data.seal.lastonlinetime = data.seal.lastonlinetime
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallTeamInfoSyncTeamCmd(adds, dels)
  local msg = TeamCmd_pb.TeamInfoSyncTeamCmd()
  if adds ~= nil then
    for i = 1, #adds do
      table.insert(msg.adds, adds[i])
    end
  end
  if dels ~= nil then
    for i = 1, #dels do
      table.insert(msg.dels, dels[i])
    end
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallSyncOnlineUserTeamCmd(teamsvrid, users)
  local msg = TeamCmd_pb.SyncOnlineUserTeamCmd()
  if teamsvrid ~= nil then
    msg.teamsvrid = teamsvrid
  end
  if users ~= nil then
    for i = 1, #users do
      table.insert(msg.users, users[i])
    end
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:CallRemoveApplyTeamCmd(charid)
  local msg = TeamCmd_pb.RemoveApplyTeamCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceTeamCmdAutoProxy:RecvForwardAllServerTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdForwardAllServerTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvUpdateGuildServerTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdUpdateGuildServerTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvAddRelationTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdAddRelationTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvLoadLuaTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdLoadLuaTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvTeamDataSyncTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdTeamDataSyncTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvTeamDataUpdateTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdTeamDataUpdateTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvTeamMemberUpdateTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdTeamMemberUpdateTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvMemberDataUpdateTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdMemberDataUpdateTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvBroadcastCmdTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdBroadcastCmdTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvCatEnterTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdCatEnterTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvCatExitTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdCatExitTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvCatFireTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdCatFireTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvCatCallTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdCatCallTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvBeLeaderTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdBeLeaderTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvCatEnterOwnTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdCatEnterOwnTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvTeamInfoSyncTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdTeamInfoSyncTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvSyncOnlineUserTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdSyncOnlineUserTeamCmd, data)
end
function ServiceTeamCmdAutoProxy:RecvRemoveApplyTeamCmd(data)
  self:Notify(ServiceEvent.TeamCmdRemoveApplyTeamCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.TeamCmdForwardAllServerTeamCmd = "ServiceEvent_TeamCmdForwardAllServerTeamCmd"
ServiceEvent.TeamCmdUpdateGuildServerTeamCmd = "ServiceEvent_TeamCmdUpdateGuildServerTeamCmd"
ServiceEvent.TeamCmdAddRelationTeamCmd = "ServiceEvent_TeamCmdAddRelationTeamCmd"
ServiceEvent.TeamCmdLoadLuaTeamCmd = "ServiceEvent_TeamCmdLoadLuaTeamCmd"
ServiceEvent.TeamCmdTeamDataSyncTeamCmd = "ServiceEvent_TeamCmdTeamDataSyncTeamCmd"
ServiceEvent.TeamCmdTeamDataUpdateTeamCmd = "ServiceEvent_TeamCmdTeamDataUpdateTeamCmd"
ServiceEvent.TeamCmdTeamMemberUpdateTeamCmd = "ServiceEvent_TeamCmdTeamMemberUpdateTeamCmd"
ServiceEvent.TeamCmdMemberDataUpdateTeamCmd = "ServiceEvent_TeamCmdMemberDataUpdateTeamCmd"
ServiceEvent.TeamCmdBroadcastCmdTeamCmd = "ServiceEvent_TeamCmdBroadcastCmdTeamCmd"
ServiceEvent.TeamCmdCatEnterTeamCmd = "ServiceEvent_TeamCmdCatEnterTeamCmd"
ServiceEvent.TeamCmdCatExitTeamCmd = "ServiceEvent_TeamCmdCatExitTeamCmd"
ServiceEvent.TeamCmdCatFireTeamCmd = "ServiceEvent_TeamCmdCatFireTeamCmd"
ServiceEvent.TeamCmdCatCallTeamCmd = "ServiceEvent_TeamCmdCatCallTeamCmd"
ServiceEvent.TeamCmdBeLeaderTeamCmd = "ServiceEvent_TeamCmdBeLeaderTeamCmd"
ServiceEvent.TeamCmdCatEnterOwnTeamCmd = "ServiceEvent_TeamCmdCatEnterOwnTeamCmd"
ServiceEvent.TeamCmdTeamInfoSyncTeamCmd = "ServiceEvent_TeamCmdTeamInfoSyncTeamCmd"
ServiceEvent.TeamCmdSyncOnlineUserTeamCmd = "ServiceEvent_TeamCmdSyncOnlineUserTeamCmd"
ServiceEvent.TeamCmdRemoveApplyTeamCmd = "ServiceEvent_TeamCmdRemoveApplyTeamCmd"
