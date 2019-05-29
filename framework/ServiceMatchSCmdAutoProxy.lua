ServiceMatchSCmdAutoProxy = class("ServiceMatchSCmdAutoProxy", ServiceProxy)
ServiceMatchSCmdAutoProxy.Instance = nil
ServiceMatchSCmdAutoProxy.NAME = "ServiceMatchSCmdAutoProxy"
function ServiceMatchSCmdAutoProxy:ctor(proxyName)
  if ServiceMatchSCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMatchSCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMatchSCmdAutoProxy.Instance = self
  end
end
function ServiceMatchSCmdAutoProxy:Init()
end
function ServiceMatchSCmdAutoProxy:onRegister()
  self:Listen(212, 1, function(data)
    self:RecvSessionForwardCCmdMatch(data)
  end)
  self:Listen(212, 2, function(data)
    self:RecvSessionForwardSCmdMatch(data)
  end)
  self:Listen(212, 3, function(data)
    self:RecvSessionForwardMatchScene(data)
  end)
  self:Listen(212, 4, function(data)
    self:RecvSessionForwardMatchTeam(data)
  end)
  self:Listen(212, 5, function(data)
    self:RecvSessionForwardTeamMatch(data)
  end)
  self:Listen(212, 13, function(data)
    self:RecvRegPvpZoneMatch(data)
  end)
  self:Listen(212, 14, function(data)
    self:RecvEnterPvpMapSCmdMatch(data)
  end)
  self:Listen(212, 16, function(data)
    self:RecvLeavePvpMap(data)
  end)
  self:Listen(212, 17, function(data)
    self:RecvNtfJoinRoom(data)
  end)
  self:Listen(212, 18, function(data)
    self:RecvNtfLeaveRoom(data)
  end)
  self:Listen(212, 19, function(data)
    self:RecvCreateTeamMatchSCmd(data)
  end)
  self:Listen(212, 20, function(data)
    self:RecvPvpTeamMemberUpdateSCmd(data)
  end)
  self:Listen(212, 21, function(data)
    self:RecvPvpMemberDataUpdateSCmd(data)
  end)
  self:Listen(212, 22, function(data)
    self:RecvApplyTeamMatchSCmd(data)
  end)
  self:Listen(212, 23, function(data)
    self:RecvSyncTeamInfoMatchSCmd(data)
  end)
  self:Listen(212, 24, function(data)
    self:RecvSyncRaidSceneMatchSCmd(data)
  end)
  self:Listen(212, 33, function(data)
    self:RecvSyncRoomSceneMatchSCmd(data)
  end)
  self:Listen(212, 25, function(data)
    self:RecvKickTeamMatchSCmd(data)
  end)
  self:Listen(212, 26, function(data)
    self:RecvKickUserFromPvpMatchSCmd(data)
  end)
  self:Listen(212, 27, function(data)
    self:RecvResetPvpMatchSCmd(data)
  end)
  self:Listen(212, 28, function(data)
    self:RecvSwitchPvpMathcSCmd(data)
  end)
  self:Listen(212, 29, function(data)
    self:RecvActivityMatchSCmd(data)
  end)
  self:Listen(212, 30, function(data)
    self:RecvCheckCanBuyMatchSCmd(data)
  end)
  self:Listen(212, 31, function(data)
    self:RecvAddBuyCntMatchSCmd(data)
  end)
  self:Listen(212, 32, function(data)
    self:RecvQuerySoldCntMatchSCmd(data)
  end)
  self:Listen(212, 34, function(data)
    self:RecvJoinSuperGvgMatchSCmd(data)
  end)
  self:Listen(212, 35, function(data)
    self:RecvSuperGvgRetMatchSCmd(data)
  end)
  self:Listen(212, 36, function(data)
    self:RecvClearMvpCDMatchSCmd(data)
  end)
  self:Listen(212, 37, function(data)
    self:RecvTutorOptMatchSCmd(data)
  end)
  self:Listen(212, 40, function(data)
    self:RecvTutorBlackUpdateMatchSCmd(data)
  end)
  self:Listen(212, 38, function(data)
    self:RecvUserBoothReqMatchSCmd(data)
  end)
  self:Listen(212, 39, function(data)
    self:RecvUserBoothNTFMatchSCmd(data)
  end)
  self:Listen(212, 41, function(data)
    self:RecvJoinTeamPwsMatchSCmd(data)
  end)
  self:Listen(212, 42, function(data)
    self:RecvExitTeamPwsMatchSCmd(data)
  end)
  self:Listen(212, 43, function(data)
    self:RecvSceneGMTestMatchSCmd(data)
  end)
  self:Listen(212, 44, function(data)
    self:RecvUpdateScoreMatchSCmd(data)
  end)
  self:Listen(212, 45, function(data)
    self:RecvSyncUserScoreMatchSCmd(data)
  end)
  self:Listen(212, 46, function(data)
    self:RecvUserLeaveRaidMatchSCmd(data)
  end)
  self:Listen(212, 47, function(data)
    self:RecvConfirmTeamMatchSCmd(data)
  end)
  self:Listen(212, 48, function(data)
    self:RecvTeamPwsSeasonOverMatchSCmd(data)
  end)
  self:Listen(212, 51, function(data)
    self:RecvTeamPwsCheckUserMatchSCmd(data)
  end)
  self:Listen(212, 49, function(data)
    self:RecvSyncMenrocoRankInfoMatchSCmd(data)
  end)
  self:Listen(212, 50, function(data)
    self:RecvQueryMenrocoRankInfoMatchSCmd(data)
  end)
  self:Listen(212, 52, function(data)
    self:RecvEnterTeamRaidMatchSCmd(data)
  end)
end
function ServiceMatchSCmdAutoProxy:CallSessionForwardCCmdMatch(charid, zoneid, data, len)
  local msg = MatchSCmd_pb.SessionForwardCCmdMatch()
  if charid ~= nil then
    msg.charid = charid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSessionForwardSCmdMatch(charid, zoneid, name, data, len)
  local msg = MatchSCmd_pb.SessionForwardSCmdMatch()
  if charid ~= nil then
    msg.charid = charid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if name ~= nil then
    msg.name = name
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSessionForwardMatchScene(charid, data, len)
  local msg = MatchSCmd_pb.SessionForwardMatchScene()
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
function ServiceMatchSCmdAutoProxy:CallSessionForwardMatchTeam(data, len)
  local msg = MatchSCmd_pb.SessionForwardMatchTeam()
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSessionForwardTeamMatch(data, len)
  local msg = MatchSCmd_pb.SessionForwardTeamMatch()
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallRegPvpZoneMatch(category, zoneid)
  local msg = MatchSCmd_pb.RegPvpZoneMatch()
  if category ~= nil then
    msg.category = category
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallEnterPvpMapSCmdMatch(dest_zoneid, raidid, room_guid, charid, colorindex)
  local msg = MatchSCmd_pb.EnterPvpMapSCmdMatch()
  if dest_zoneid ~= nil then
    msg.dest_zoneid = dest_zoneid
  end
  if raidid ~= nil then
    msg.raidid = raidid
  end
  if room_guid ~= nil then
    msg.room_guid = room_guid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if colorindex ~= nil then
    msg.colorindex = colorindex
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallLeavePvpMap(roomid, charid, originzoneid)
  local msg = MatchSCmd_pb.LeavePvpMap()
  if roomid ~= nil then
    msg.roomid = roomid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if originzoneid ~= nil then
    msg.originzoneid = originzoneid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallNtfJoinRoom(roomid, charid, teamid, success)
  local msg = MatchSCmd_pb.NtfJoinRoom()
  if roomid ~= nil then
    msg.roomid = roomid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if success ~= nil then
    msg.success = success
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallNtfLeaveRoom(roomid, teamid)
  local msg = MatchSCmd_pb.NtfLeaveRoom()
  if roomid ~= nil then
    msg.roomid = roomid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallCreateTeamMatchSCmd(teamid, roomid, charid, name, zoneid, new_teamid, pvptype)
  local msg = MatchSCmd_pb.CreateTeamMatchSCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if roomid ~= nil then
    msg.roomid = roomid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if name ~= nil then
    msg.name = name
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if new_teamid ~= nil then
    msg.new_teamid = new_teamid
  end
  if pvptype ~= nil then
    msg.pvptype = pvptype
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallPvpTeamMemberUpdateSCmd(data)
  local msg = MatchSCmd_pb.PvpTeamMemberUpdateSCmd()
  if data ~= nil and data.zoneid ~= nil then
    msg.data.zoneid = data.zoneid
  end
  if data ~= nil and data.teamid ~= nil then
    msg.data.teamid = data.teamid
  end
  if data ~= nil and data.roomid ~= nil then
    msg.data.roomid = data.roomid
  end
  if data ~= nil and data.isfirst ~= nil then
    msg.data.isfirst = data.isfirst
  end
  if data ~= nil and data.updates ~= nil then
    for i = 1, #data.updates do
      table.insert(msg.data.updates, data.updates[i])
    end
  end
  if data ~= nil and data.deletes ~= nil then
    for i = 1, #data.deletes do
      table.insert(msg.data.deletes, data.deletes[i])
    end
  end
  if data ~= nil and data.index ~= nil then
    msg.data.index = data.index
  end
  if data ~= nil and data.teamname ~= nil then
    msg.data.teamname = data.teamname
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallPvpMemberDataUpdateSCmd(data)
  local msg = MatchSCmd_pb.PvpMemberDataUpdateSCmd()
  if data ~= nil and data.zoneid ~= nil then
    msg.data.zoneid = data.zoneid
  end
  if data ~= nil and data.teamid ~= nil then
    msg.data.teamid = data.teamid
  end
  if data ~= nil and data.charid ~= nil then
    msg.data.charid = data.charid
  end
  if data ~= nil and data.roomid ~= nil then
    msg.data.roomid = data.roomid
  end
  if data ~= nil and data.members ~= nil then
    for i = 1, #data.members do
      table.insert(msg.data.members, data.members[i])
    end
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallApplyTeamMatchSCmd(teamid, charid, zoneid, exitteam, carrytype, carrydata, carrylen)
  local msg = MatchSCmd_pb.ApplyTeamMatchSCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if exitteam ~= nil then
    msg.exitteam = exitteam
  end
  if carrytype ~= nil then
    msg.carrytype = carrytype
  end
  if carrydata ~= nil then
    msg.carrydata = carrydata
  end
  if carrylen ~= nil then
    msg.carrylen = carrylen
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSyncTeamInfoMatchSCmd(teamid, charid, index)
  local msg = MatchSCmd_pb.SyncTeamInfoMatchSCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if index ~= nil then
    msg.index = index
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSyncRaidSceneMatchSCmd(roomid, open, sceneid, count, zoneid)
  local msg = MatchSCmd_pb.SyncRaidSceneMatchSCmd()
  if roomid ~= nil then
    msg.roomid = roomid
  end
  if open ~= nil then
    msg.open = open
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if count ~= nil then
    msg.count = count
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSyncRoomSceneMatchSCmd(roomid, sceneid, zoneid, roomsize, sugvgdata, level, raidtime, pwsdata, pvptype, users)
  local msg = MatchSCmd_pb.SyncRoomSceneMatchSCmd()
  if roomid ~= nil then
    msg.roomid = roomid
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if roomsize ~= nil then
    msg.roomsize = roomsize
  end
  if sugvgdata ~= nil then
    for i = 1, #sugvgdata do
      table.insert(msg.sugvgdata, sugvgdata[i])
    end
  end
  if level ~= nil then
    msg.level = level
  end
  if raidtime ~= nil then
    msg.raidtime = raidtime
  end
  if pwsdata ~= nil then
    for i = 1, #pwsdata do
      table.insert(msg.pwsdata, pwsdata[i])
    end
  end
  if pvptype ~= nil then
    msg.pvptype = pvptype
  end
  if users ~= nil then
    for i = 1, #users do
      table.insert(msg.users, users[i])
    end
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallKickTeamMatchSCmd(teamid, charid, roomid, zoneid)
  local msg = MatchSCmd_pb.KickTeamMatchSCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if roomid ~= nil then
    msg.roomid = roomid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallKickUserFromPvpMatchSCmd(charid, zoneid)
  local msg = MatchSCmd_pb.KickUserFromPvpMatchSCmd()
  msg.charid = charid
  msg.zoneid = zoneid
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallResetPvpMatchSCmd()
  local msg = MatchSCmd_pb.ResetPvpMatchSCmd()
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSwitchPvpMathcSCmd(open, etype)
  local msg = MatchSCmd_pb.SwitchPvpMathcSCmd()
  if open ~= nil then
    msg.open = open
  end
  msg.etype = etype
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallActivityMatchSCmd(open, etype, server_restart)
  local msg = MatchSCmd_pb.ActivityMatchSCmd()
  if open ~= nil then
    msg.open = open
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if server_restart ~= nil then
    msg.server_restart = server_restart
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallCheckCanBuyMatchSCmd(id, count, price, price2, success, charid, zoneid)
  local msg = MatchSCmd_pb.CheckCanBuyMatchSCmd()
  if id ~= nil then
    msg.id = id
  end
  if count ~= nil then
    msg.count = count
  end
  if price ~= nil then
    msg.price = price
  end
  if price2 ~= nil then
    msg.price2 = price2
  end
  if success ~= nil then
    msg.success = success
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallAddBuyCntMatchSCmd(id, count, charid, zoneid)
  local msg = MatchSCmd_pb.AddBuyCntMatchSCmd()
  if id ~= nil then
    msg.id = id
  end
  if count ~= nil then
    msg.count = count
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallQuerySoldCntMatchSCmd(charid, zoneid)
  local msg = MatchSCmd_pb.QuerySoldCntMatchSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallJoinSuperGvgMatchSCmd(guildid, zoneid, guildname, guildicon, firecount, firescore, begintime)
  local msg = MatchSCmd_pb.JoinSuperGvgMatchSCmd()
  msg.guildid = guildid
  msg.zoneid = zoneid
  if guildname ~= nil then
    msg.guildname = guildname
  end
  if guildicon ~= nil then
    msg.guildicon = guildicon
  end
  if firecount ~= nil then
    msg.firecount = firecount
  end
  if firescore ~= nil then
    msg.firescore = firescore
  end
  if begintime ~= nil then
    msg.begintime = begintime
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSuperGvgRetMatchSCmd(ret, guildid)
  local msg = MatchSCmd_pb.SuperGvgRetMatchSCmd()
  if ret ~= nil then
    msg.ret = ret
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallClearMvpCDMatchSCmd(roomid, teamid)
  local msg = MatchSCmd_pb.ClearMvpCDMatchSCmd()
  msg.roomid = roomid
  msg.teamid = teamid
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallTutorOptMatchSCmd(tutorid, studentid, opt, ret, result)
  local msg = MatchSCmd_pb.TutorOptMatchSCmd()
  if tutorid ~= nil then
    msg.tutorid = tutorid
  end
  if studentid ~= nil then
    msg.studentid = studentid
  end
  if opt ~= nil then
    msg.opt = opt
  end
  if ret ~= nil then
    msg.ret = ret
  end
  if result ~= nil then
    msg.result = result
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallTutorBlackUpdateMatchSCmd(charid, blackids)
  local msg = MatchSCmd_pb.TutorBlackUpdateMatchSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if blackids ~= nil then
    for i = 1, #blackids do
      table.insert(msg.blackids, blackids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallUserBoothReqMatchSCmd(zoneid, sceneid, user, oper)
  local msg = MatchSCmd_pb.UserBoothReqMatchSCmd()
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if user ~= nil and user.guid ~= nil then
    msg.user.guid = user.guid
  end
  if user ~= nil and user.name ~= nil then
    msg.user.name = user.name
  end
  if user ~= nil and user.gender ~= nil then
    msg.user.gender = user.gender
  end
  if user.pos ~= nil and user.pos.x ~= nil then
    msg.user.pos.x = user.pos.x
  end
  if user.pos ~= nil and user.pos.y ~= nil then
    msg.user.pos.y = user.pos.y
  end
  if user.pos ~= nil and user.pos.z ~= nil then
    msg.user.pos.z = user.pos.z
  end
  if user.dest ~= nil and user.dest.x ~= nil then
    msg.user.dest.x = user.dest.x
  end
  if user.dest ~= nil and user.dest.y ~= nil then
    msg.user.dest.y = user.dest.y
  end
  if user.dest ~= nil and user.dest.z ~= nil then
    msg.user.dest.z = user.dest.z
  end
  if user ~= nil and user.attrs ~= nil then
    for i = 1, #user.attrs do
      table.insert(msg.user.attrs, user.attrs[i])
    end
  end
  if user ~= nil and user.datas ~= nil then
    for i = 1, #user.datas do
      table.insert(msg.user.datas, user.datas[i])
    end
  end
  if user ~= nil and user.buffs ~= nil then
    for i = 1, #user.buffs do
      table.insert(msg.user.buffs, user.buffs[i])
    end
  end
  if user ~= nil and user.skillid ~= nil then
    msg.user.skillid = user.skillid
  end
  if user ~= nil and user.teamid ~= nil then
    msg.user.teamid = user.teamid
  end
  if user ~= nil and user.teamname ~= nil then
    msg.user.teamname = user.teamname
  end
  if user.carrier ~= nil and user.carrier.id ~= nil then
    msg.user.carrier.id = user.carrier.id
  end
  if user.carrier ~= nil and user.carrier.masterid ~= nil then
    msg.user.carrier.masterid = user.carrier.masterid
  end
  if user.carrier ~= nil and user.carrier.index ~= nil then
    msg.user.carrier.index = user.carrier.index
  end
  if user.carrier ~= nil and user.carrier.progress ~= nil then
    msg.user.carrier.progress = user.carrier.progress
  end
  if user.carrier ~= nil and user.carrier.line ~= nil then
    msg.user.carrier.line = user.carrier.line
  end
  if user.carrier ~= nil and user.carrier.assemble ~= nil then
    msg.user.carrier.assemble = user.carrier.assemble
  end
  if user.chatroom ~= nil and user.chatroom.ownerid ~= nil then
    msg.user.chatroom.ownerid = user.chatroom.ownerid
  end
  if user.chatroom ~= nil and user.chatroom.roomid ~= nil then
    msg.user.chatroom.roomid = user.chatroom.roomid
  end
  if user.chatroom ~= nil and user.chatroom.name ~= nil then
    msg.user.chatroom.name = user.chatroom.name
  end
  if user.chatroom ~= nil and user.chatroom.roomtype ~= nil then
    msg.user.chatroom.roomtype = user.chatroom.roomtype
  end
  if user.chatroom ~= nil and user.chatroom.maxnum ~= nil then
    msg.user.chatroom.maxnum = user.chatroom.maxnum
  end
  if user.chatroom ~= nil and user.chatroom.curnum ~= nil then
    msg.user.chatroom.curnum = user.chatroom.curnum
  end
  if user.chatroom ~= nil and user.chatroom.pswd ~= nil then
    msg.user.chatroom.pswd = user.chatroom.pswd
  end
  if user ~= nil and user.handsmaster ~= nil then
    msg.user.handsmaster = user.handsmaster
  end
  if user ~= nil and user.speffectdata ~= nil then
    for i = 1, #user.speffectdata do
      table.insert(msg.user.speffectdata, user.speffectdata[i])
    end
  end
  if user ~= nil and user.guildid ~= nil then
    msg.user.guildid = user.guildid
  end
  if user ~= nil and user.guildname ~= nil then
    msg.user.guildname = user.guildname
  end
  if user ~= nil and user.guildicon ~= nil then
    msg.user.guildicon = user.guildicon
  end
  if user ~= nil and user.guildjob ~= nil then
    msg.user.guildjob = user.guildjob
  end
  if user.handnpc ~= nil and user.handnpc.body ~= nil then
    msg.user.handnpc.body = user.handnpc.body
  end
  if user.handnpc ~= nil and user.handnpc.head ~= nil then
    msg.user.handnpc.head = user.handnpc.head
  end
  if user.handnpc ~= nil and user.handnpc.hair ~= nil then
    msg.user.handnpc.hair = user.handnpc.hair
  end
  if user.handnpc ~= nil and user.handnpc.haircolor ~= nil then
    msg.user.handnpc.haircolor = user.handnpc.haircolor
  end
  if user.handnpc ~= nil and user.handnpc.guid ~= nil then
    msg.user.handnpc.guid = user.handnpc.guid
  end
  if user.handnpc ~= nil and user.handnpc.speffect ~= nil then
    msg.user.handnpc.speffect = user.handnpc.speffect
  end
  if user.handnpc ~= nil and user.handnpc.name ~= nil then
    msg.user.handnpc.name = user.handnpc.name
  end
  if user.handnpc ~= nil and user.handnpc.eye ~= nil then
    msg.user.handnpc.eye = user.handnpc.eye
  end
  if user ~= nil and user.motionactionid ~= nil then
    msg.user.motionactionid = user.motionactionid
  end
  if user ~= nil and user.seatid ~= nil then
    msg.user.seatid = user.seatid
  end
  if user ~= nil and user.givenpcdatas ~= nil then
    for i = 1, #user.givenpcdatas do
      table.insert(msg.user.givenpcdatas, user.givenpcdatas[i])
    end
  end
  if user ~= nil and user.achievetitle ~= nil then
    msg.user.achievetitle = user.achievetitle
  end
  if user.cookstate ~= nil and user.cookstate.state ~= nil then
    msg.user.cookstate.state = user.cookstate.state
  end
  if user.cookstate ~= nil and user.cookstate.cooktype ~= nil then
    msg.user.cookstate.cooktype = user.cookstate.cooktype
  end
  if user.cookstate ~= nil and user.cookstate.progress ~= nil then
    msg.user.cookstate.progress = user.cookstate.progress
  end
  if user.cookstate ~= nil and user.cookstate.success ~= nil then
    msg.user.cookstate.success = user.cookstate.success
  end
  if user ~= nil and user.cookstate.foodid ~= nil then
    for i = 1, #user.cookstate.foodid do
      table.insert(msg.user.cookstate.foodid, user.cookstate.foodid[i])
    end
  end
  if user.info ~= nil and user.info.name ~= nil then
    msg.user.info.name = user.info.name
  end
  if user.info ~= nil and user.info.sign ~= nil then
    msg.user.info.sign = user.info.sign
  end
  if user ~= nil and user.mountnpcguid ~= nil then
    msg.user.mountnpcguid = user.mountnpcguid
  end
  if user ~= nil and user.mountid ~= nil then
    msg.user.mountid = user.mountid
  end
  if oper ~= nil then
    msg.oper = oper
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallUserBoothNTFMatchSCmd(zoneid, sceneid, user, oper)
  local msg = MatchSCmd_pb.UserBoothNTFMatchSCmd()
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if user ~= nil and user.guid ~= nil then
    msg.user.guid = user.guid
  end
  if user ~= nil and user.name ~= nil then
    msg.user.name = user.name
  end
  if user ~= nil and user.gender ~= nil then
    msg.user.gender = user.gender
  end
  if user.pos ~= nil and user.pos.x ~= nil then
    msg.user.pos.x = user.pos.x
  end
  if user.pos ~= nil and user.pos.y ~= nil then
    msg.user.pos.y = user.pos.y
  end
  if user.pos ~= nil and user.pos.z ~= nil then
    msg.user.pos.z = user.pos.z
  end
  if user.dest ~= nil and user.dest.x ~= nil then
    msg.user.dest.x = user.dest.x
  end
  if user.dest ~= nil and user.dest.y ~= nil then
    msg.user.dest.y = user.dest.y
  end
  if user.dest ~= nil and user.dest.z ~= nil then
    msg.user.dest.z = user.dest.z
  end
  if user ~= nil and user.attrs ~= nil then
    for i = 1, #user.attrs do
      table.insert(msg.user.attrs, user.attrs[i])
    end
  end
  if user ~= nil and user.datas ~= nil then
    for i = 1, #user.datas do
      table.insert(msg.user.datas, user.datas[i])
    end
  end
  if user ~= nil and user.buffs ~= nil then
    for i = 1, #user.buffs do
      table.insert(msg.user.buffs, user.buffs[i])
    end
  end
  if user ~= nil and user.skillid ~= nil then
    msg.user.skillid = user.skillid
  end
  if user ~= nil and user.teamid ~= nil then
    msg.user.teamid = user.teamid
  end
  if user ~= nil and user.teamname ~= nil then
    msg.user.teamname = user.teamname
  end
  if user.carrier ~= nil and user.carrier.id ~= nil then
    msg.user.carrier.id = user.carrier.id
  end
  if user.carrier ~= nil and user.carrier.masterid ~= nil then
    msg.user.carrier.masterid = user.carrier.masterid
  end
  if user.carrier ~= nil and user.carrier.index ~= nil then
    msg.user.carrier.index = user.carrier.index
  end
  if user.carrier ~= nil and user.carrier.progress ~= nil then
    msg.user.carrier.progress = user.carrier.progress
  end
  if user.carrier ~= nil and user.carrier.line ~= nil then
    msg.user.carrier.line = user.carrier.line
  end
  if user.carrier ~= nil and user.carrier.assemble ~= nil then
    msg.user.carrier.assemble = user.carrier.assemble
  end
  if user.chatroom ~= nil and user.chatroom.ownerid ~= nil then
    msg.user.chatroom.ownerid = user.chatroom.ownerid
  end
  if user.chatroom ~= nil and user.chatroom.roomid ~= nil then
    msg.user.chatroom.roomid = user.chatroom.roomid
  end
  if user.chatroom ~= nil and user.chatroom.name ~= nil then
    msg.user.chatroom.name = user.chatroom.name
  end
  if user.chatroom ~= nil and user.chatroom.roomtype ~= nil then
    msg.user.chatroom.roomtype = user.chatroom.roomtype
  end
  if user.chatroom ~= nil and user.chatroom.maxnum ~= nil then
    msg.user.chatroom.maxnum = user.chatroom.maxnum
  end
  if user.chatroom ~= nil and user.chatroom.curnum ~= nil then
    msg.user.chatroom.curnum = user.chatroom.curnum
  end
  if user.chatroom ~= nil and user.chatroom.pswd ~= nil then
    msg.user.chatroom.pswd = user.chatroom.pswd
  end
  if user ~= nil and user.handsmaster ~= nil then
    msg.user.handsmaster = user.handsmaster
  end
  if user ~= nil and user.speffectdata ~= nil then
    for i = 1, #user.speffectdata do
      table.insert(msg.user.speffectdata, user.speffectdata[i])
    end
  end
  if user ~= nil and user.guildid ~= nil then
    msg.user.guildid = user.guildid
  end
  if user ~= nil and user.guildname ~= nil then
    msg.user.guildname = user.guildname
  end
  if user ~= nil and user.guildicon ~= nil then
    msg.user.guildicon = user.guildicon
  end
  if user ~= nil and user.guildjob ~= nil then
    msg.user.guildjob = user.guildjob
  end
  if user.handnpc ~= nil and user.handnpc.body ~= nil then
    msg.user.handnpc.body = user.handnpc.body
  end
  if user.handnpc ~= nil and user.handnpc.head ~= nil then
    msg.user.handnpc.head = user.handnpc.head
  end
  if user.handnpc ~= nil and user.handnpc.hair ~= nil then
    msg.user.handnpc.hair = user.handnpc.hair
  end
  if user.handnpc ~= nil and user.handnpc.haircolor ~= nil then
    msg.user.handnpc.haircolor = user.handnpc.haircolor
  end
  if user.handnpc ~= nil and user.handnpc.guid ~= nil then
    msg.user.handnpc.guid = user.handnpc.guid
  end
  if user.handnpc ~= nil and user.handnpc.speffect ~= nil then
    msg.user.handnpc.speffect = user.handnpc.speffect
  end
  if user.handnpc ~= nil and user.handnpc.name ~= nil then
    msg.user.handnpc.name = user.handnpc.name
  end
  if user.handnpc ~= nil and user.handnpc.eye ~= nil then
    msg.user.handnpc.eye = user.handnpc.eye
  end
  if user ~= nil and user.motionactionid ~= nil then
    msg.user.motionactionid = user.motionactionid
  end
  if user ~= nil and user.seatid ~= nil then
    msg.user.seatid = user.seatid
  end
  if user ~= nil and user.givenpcdatas ~= nil then
    for i = 1, #user.givenpcdatas do
      table.insert(msg.user.givenpcdatas, user.givenpcdatas[i])
    end
  end
  if user ~= nil and user.achievetitle ~= nil then
    msg.user.achievetitle = user.achievetitle
  end
  if user.cookstate ~= nil and user.cookstate.state ~= nil then
    msg.user.cookstate.state = user.cookstate.state
  end
  if user.cookstate ~= nil and user.cookstate.cooktype ~= nil then
    msg.user.cookstate.cooktype = user.cookstate.cooktype
  end
  if user.cookstate ~= nil and user.cookstate.progress ~= nil then
    msg.user.cookstate.progress = user.cookstate.progress
  end
  if user.cookstate ~= nil and user.cookstate.success ~= nil then
    msg.user.cookstate.success = user.cookstate.success
  end
  if user ~= nil and user.cookstate.foodid ~= nil then
    for i = 1, #user.cookstate.foodid do
      table.insert(msg.user.cookstate.foodid, user.cookstate.foodid[i])
    end
  end
  if user.info ~= nil and user.info.name ~= nil then
    msg.user.info.name = user.info.name
  end
  if user.info ~= nil and user.info.sign ~= nil then
    msg.user.info.sign = user.info.sign
  end
  if user ~= nil and user.mountnpcguid ~= nil then
    msg.user.mountnpcguid = user.mountnpcguid
  end
  if user ~= nil and user.mountid ~= nil then
    msg.user.mountid = user.mountid
  end
  if oper ~= nil then
    msg.oper = oper
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallJoinTeamPwsMatchSCmd(teamid, zoneid, leaderid, members, avescore, etype, roomid, userinfo, checkmembers, roomguid, users)
  local msg = MatchSCmd_pb.JoinTeamPwsMatchSCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if leaderid ~= nil then
    msg.leaderid = leaderid
  end
  if members ~= nil then
    for i = 1, #members do
      table.insert(msg.members, members[i])
    end
  end
  if avescore ~= nil then
    msg.avescore = avescore
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if roomid ~= nil then
    msg.roomid = roomid
  end
  if userinfo.user ~= nil and userinfo.user.accid ~= nil then
    msg.userinfo.user.accid = userinfo.user.accid
  end
  if userinfo.user ~= nil and userinfo.user.charid ~= nil then
    msg.userinfo.user.charid = userinfo.user.charid
  end
  if userinfo.user ~= nil and userinfo.user.zoneid ~= nil then
    msg.userinfo.user.zoneid = userinfo.user.zoneid
  end
  if userinfo.user ~= nil and userinfo.user.mapid ~= nil then
    msg.userinfo.user.mapid = userinfo.user.mapid
  end
  if userinfo.user ~= nil and userinfo.user.baselv ~= nil then
    msg.userinfo.user.baselv = userinfo.user.baselv
  end
  if userinfo.user ~= nil and userinfo.user.profession ~= nil then
    msg.userinfo.user.profession = userinfo.user.profession
  end
  if userinfo.user ~= nil and userinfo.user.name ~= nil then
    msg.userinfo.user.name = userinfo.user.name
  end
  if userinfo.user ~= nil and userinfo.user.guildid ~= nil then
    msg.userinfo.user.guildid = userinfo.user.guildid
  end
  if userinfo ~= nil and userinfo.datas ~= nil then
    for i = 1, #userinfo.datas do
      table.insert(msg.userinfo.datas, userinfo.datas[i])
    end
  end
  if userinfo ~= nil and userinfo.attrs ~= nil then
    for i = 1, #userinfo.attrs do
      table.insert(msg.userinfo.attrs, userinfo.attrs[i])
    end
  end
  if checkmembers ~= nil then
    for i = 1, #checkmembers do
      table.insert(msg.checkmembers, checkmembers[i])
    end
  end
  if roomguid ~= nil then
    msg.roomguid = roomguid
  end
  if users ~= nil then
    for i = 1, #users do
      table.insert(msg.users, users[i])
    end
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallExitTeamPwsMatchSCmd(teamid, zoneid, etype, charid)
  local msg = MatchSCmd_pb.ExitTeamPwsMatchSCmd()
  msg.teamid = teamid
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSceneGMTestMatchSCmd(etype, frequency, interval, lasttime, params)
  local msg = MatchSCmd_pb.SceneGMTestMatchSCmd()
  if etype ~= nil then
    msg.etype = etype
  end
  if frequency ~= nil then
    msg.frequency = frequency
  end
  if interval ~= nil then
    msg.interval = interval
  end
  if lasttime ~= nil then
    msg.lasttime = lasttime
  end
  if params ~= nil then
    for i = 1, #params do
      table.insert(msg.params, params[i])
    end
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallUpdateScoreMatchSCmd(etype, userscores, zoneid)
  local msg = MatchSCmd_pb.UpdateScoreMatchSCmd()
  if etype ~= nil then
    msg.etype = etype
  end
  if userscores ~= nil then
    for i = 1, #userscores do
      table.insert(msg.userscores, userscores[i])
    end
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSyncUserScoreMatchSCmd(etype, charid, score, season)
  local msg = MatchSCmd_pb.SyncUserScoreMatchSCmd()
  if etype ~= nil then
    msg.etype = etype
  end
  msg.charid = charid
  msg.score = score
  if season ~= nil then
    msg.season = season
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallUserLeaveRaidMatchSCmd(charid, etype, zoneid, roomid, needmatch)
  local msg = MatchSCmd_pb.UserLeaveRaidMatchSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if roomid ~= nil then
    msg.roomid = roomid
  end
  if needmatch ~= nil then
    msg.needmatch = needmatch
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallConfirmTeamMatchSCmd(teamid, etype)
  local msg = MatchSCmd_pb.ConfirmTeamMatchSCmd()
  msg.teamid = teamid
  if etype ~= nil then
    msg.etype = etype
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallTeamPwsSeasonOverMatchSCmd()
  local msg = MatchSCmd_pb.TeamPwsSeasonOverMatchSCmd()
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallTeamPwsCheckUserMatchSCmd(checkid, teamid, etype, charids, result, msgid)
  local msg = MatchSCmd_pb.TeamPwsCheckUserMatchSCmd()
  if checkid ~= nil then
    msg.checkid = checkid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if charids ~= nil then
    for i = 1, #charids do
      table.insert(msg.charids, charids[i])
    end
  end
  if result ~= nil then
    msg.result = result
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallSyncMenrocoRankInfoMatchSCmd(data)
  local msg = MatchSCmd_pb.SyncMenrocoRankInfoMatchSCmd()
  if data ~= nil and data.charid ~= nil then
    msg.data.charid = data.charid
  end
  if data ~= nil and data.score ~= nil then
    msg.data.score = data.score
  end
  if data ~= nil and data.level ~= nil then
    msg.data.level = data.level
  end
  if data ~= nil and data.profession ~= nil then
    msg.data.profession = data.profession
  end
  if data ~= nil and data.name ~= nil then
    msg.data.name = data.name
  end
  if data ~= nil and data.guildname ~= nil then
    msg.data.guildname = data.guildname
  end
  if data ~= nil and data.time ~= nil then
    msg.data.time = data.time
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallQueryMenrocoRankInfoMatchSCmd(zoneid, datas)
  local msg = MatchSCmd_pb.QueryMenrocoRankInfoMatchSCmd()
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:CallEnterTeamRaidMatchSCmd(etype, configid, teamid, userids)
  local msg = MatchSCmd_pb.EnterTeamRaidMatchSCmd()
  if etype ~= nil then
    msg.etype = etype
  end
  if configid ~= nil then
    msg.configid = configid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if userids ~= nil then
    for i = 1, #userids do
      table.insert(msg.userids, userids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceMatchSCmdAutoProxy:RecvSessionForwardCCmdMatch(data)
  self:Notify(ServiceEvent.MatchSCmdSessionForwardCCmdMatch, data)
end
function ServiceMatchSCmdAutoProxy:RecvSessionForwardSCmdMatch(data)
  self:Notify(ServiceEvent.MatchSCmdSessionForwardSCmdMatch, data)
end
function ServiceMatchSCmdAutoProxy:RecvSessionForwardMatchScene(data)
  self:Notify(ServiceEvent.MatchSCmdSessionForwardMatchScene, data)
end
function ServiceMatchSCmdAutoProxy:RecvSessionForwardMatchTeam(data)
  self:Notify(ServiceEvent.MatchSCmdSessionForwardMatchTeam, data)
end
function ServiceMatchSCmdAutoProxy:RecvSessionForwardTeamMatch(data)
  self:Notify(ServiceEvent.MatchSCmdSessionForwardTeamMatch, data)
end
function ServiceMatchSCmdAutoProxy:RecvRegPvpZoneMatch(data)
  self:Notify(ServiceEvent.MatchSCmdRegPvpZoneMatch, data)
end
function ServiceMatchSCmdAutoProxy:RecvEnterPvpMapSCmdMatch(data)
  self:Notify(ServiceEvent.MatchSCmdEnterPvpMapSCmdMatch, data)
end
function ServiceMatchSCmdAutoProxy:RecvLeavePvpMap(data)
  self:Notify(ServiceEvent.MatchSCmdLeavePvpMap, data)
end
function ServiceMatchSCmdAutoProxy:RecvNtfJoinRoom(data)
  self:Notify(ServiceEvent.MatchSCmdNtfJoinRoom, data)
end
function ServiceMatchSCmdAutoProxy:RecvNtfLeaveRoom(data)
  self:Notify(ServiceEvent.MatchSCmdNtfLeaveRoom, data)
end
function ServiceMatchSCmdAutoProxy:RecvCreateTeamMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdCreateTeamMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvPvpTeamMemberUpdateSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdPvpTeamMemberUpdateSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvPvpMemberDataUpdateSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdPvpMemberDataUpdateSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvApplyTeamMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdApplyTeamMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvSyncTeamInfoMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdSyncTeamInfoMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvSyncRaidSceneMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdSyncRaidSceneMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvSyncRoomSceneMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdSyncRoomSceneMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvKickTeamMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdKickTeamMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvKickUserFromPvpMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdKickUserFromPvpMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvResetPvpMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdResetPvpMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvSwitchPvpMathcSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdSwitchPvpMathcSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvActivityMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdActivityMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvCheckCanBuyMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdCheckCanBuyMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvAddBuyCntMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdAddBuyCntMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvQuerySoldCntMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdQuerySoldCntMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvJoinSuperGvgMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdJoinSuperGvgMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvSuperGvgRetMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdSuperGvgRetMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvClearMvpCDMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdClearMvpCDMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvTutorOptMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdTutorOptMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvTutorBlackUpdateMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdTutorBlackUpdateMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvUserBoothReqMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdUserBoothReqMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvUserBoothNTFMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdUserBoothNTFMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvJoinTeamPwsMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdJoinTeamPwsMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvExitTeamPwsMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdExitTeamPwsMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvSceneGMTestMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdSceneGMTestMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvUpdateScoreMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdUpdateScoreMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvSyncUserScoreMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdSyncUserScoreMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvUserLeaveRaidMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdUserLeaveRaidMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvConfirmTeamMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdConfirmTeamMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvTeamPwsSeasonOverMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdTeamPwsSeasonOverMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvTeamPwsCheckUserMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdTeamPwsCheckUserMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvSyncMenrocoRankInfoMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdSyncMenrocoRankInfoMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvQueryMenrocoRankInfoMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdQueryMenrocoRankInfoMatchSCmd, data)
end
function ServiceMatchSCmdAutoProxy:RecvEnterTeamRaidMatchSCmd(data)
  self:Notify(ServiceEvent.MatchSCmdEnterTeamRaidMatchSCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.MatchSCmdSessionForwardCCmdMatch = "ServiceEvent_MatchSCmdSessionForwardCCmdMatch"
ServiceEvent.MatchSCmdSessionForwardSCmdMatch = "ServiceEvent_MatchSCmdSessionForwardSCmdMatch"
ServiceEvent.MatchSCmdSessionForwardMatchScene = "ServiceEvent_MatchSCmdSessionForwardMatchScene"
ServiceEvent.MatchSCmdSessionForwardMatchTeam = "ServiceEvent_MatchSCmdSessionForwardMatchTeam"
ServiceEvent.MatchSCmdSessionForwardTeamMatch = "ServiceEvent_MatchSCmdSessionForwardTeamMatch"
ServiceEvent.MatchSCmdRegPvpZoneMatch = "ServiceEvent_MatchSCmdRegPvpZoneMatch"
ServiceEvent.MatchSCmdEnterPvpMapSCmdMatch = "ServiceEvent_MatchSCmdEnterPvpMapSCmdMatch"
ServiceEvent.MatchSCmdLeavePvpMap = "ServiceEvent_MatchSCmdLeavePvpMap"
ServiceEvent.MatchSCmdNtfJoinRoom = "ServiceEvent_MatchSCmdNtfJoinRoom"
ServiceEvent.MatchSCmdNtfLeaveRoom = "ServiceEvent_MatchSCmdNtfLeaveRoom"
ServiceEvent.MatchSCmdCreateTeamMatchSCmd = "ServiceEvent_MatchSCmdCreateTeamMatchSCmd"
ServiceEvent.MatchSCmdPvpTeamMemberUpdateSCmd = "ServiceEvent_MatchSCmdPvpTeamMemberUpdateSCmd"
ServiceEvent.MatchSCmdPvpMemberDataUpdateSCmd = "ServiceEvent_MatchSCmdPvpMemberDataUpdateSCmd"
ServiceEvent.MatchSCmdApplyTeamMatchSCmd = "ServiceEvent_MatchSCmdApplyTeamMatchSCmd"
ServiceEvent.MatchSCmdSyncTeamInfoMatchSCmd = "ServiceEvent_MatchSCmdSyncTeamInfoMatchSCmd"
ServiceEvent.MatchSCmdSyncRaidSceneMatchSCmd = "ServiceEvent_MatchSCmdSyncRaidSceneMatchSCmd"
ServiceEvent.MatchSCmdSyncRoomSceneMatchSCmd = "ServiceEvent_MatchSCmdSyncRoomSceneMatchSCmd"
ServiceEvent.MatchSCmdKickTeamMatchSCmd = "ServiceEvent_MatchSCmdKickTeamMatchSCmd"
ServiceEvent.MatchSCmdKickUserFromPvpMatchSCmd = "ServiceEvent_MatchSCmdKickUserFromPvpMatchSCmd"
ServiceEvent.MatchSCmdResetPvpMatchSCmd = "ServiceEvent_MatchSCmdResetPvpMatchSCmd"
ServiceEvent.MatchSCmdSwitchPvpMathcSCmd = "ServiceEvent_MatchSCmdSwitchPvpMathcSCmd"
ServiceEvent.MatchSCmdActivityMatchSCmd = "ServiceEvent_MatchSCmdActivityMatchSCmd"
ServiceEvent.MatchSCmdCheckCanBuyMatchSCmd = "ServiceEvent_MatchSCmdCheckCanBuyMatchSCmd"
ServiceEvent.MatchSCmdAddBuyCntMatchSCmd = "ServiceEvent_MatchSCmdAddBuyCntMatchSCmd"
ServiceEvent.MatchSCmdQuerySoldCntMatchSCmd = "ServiceEvent_MatchSCmdQuerySoldCntMatchSCmd"
ServiceEvent.MatchSCmdJoinSuperGvgMatchSCmd = "ServiceEvent_MatchSCmdJoinSuperGvgMatchSCmd"
ServiceEvent.MatchSCmdSuperGvgRetMatchSCmd = "ServiceEvent_MatchSCmdSuperGvgRetMatchSCmd"
ServiceEvent.MatchSCmdClearMvpCDMatchSCmd = "ServiceEvent_MatchSCmdClearMvpCDMatchSCmd"
ServiceEvent.MatchSCmdTutorOptMatchSCmd = "ServiceEvent_MatchSCmdTutorOptMatchSCmd"
ServiceEvent.MatchSCmdTutorBlackUpdateMatchSCmd = "ServiceEvent_MatchSCmdTutorBlackUpdateMatchSCmd"
ServiceEvent.MatchSCmdUserBoothReqMatchSCmd = "ServiceEvent_MatchSCmdUserBoothReqMatchSCmd"
ServiceEvent.MatchSCmdUserBoothNTFMatchSCmd = "ServiceEvent_MatchSCmdUserBoothNTFMatchSCmd"
ServiceEvent.MatchSCmdJoinTeamPwsMatchSCmd = "ServiceEvent_MatchSCmdJoinTeamPwsMatchSCmd"
ServiceEvent.MatchSCmdExitTeamPwsMatchSCmd = "ServiceEvent_MatchSCmdExitTeamPwsMatchSCmd"
ServiceEvent.MatchSCmdSceneGMTestMatchSCmd = "ServiceEvent_MatchSCmdSceneGMTestMatchSCmd"
ServiceEvent.MatchSCmdUpdateScoreMatchSCmd = "ServiceEvent_MatchSCmdUpdateScoreMatchSCmd"
ServiceEvent.MatchSCmdSyncUserScoreMatchSCmd = "ServiceEvent_MatchSCmdSyncUserScoreMatchSCmd"
ServiceEvent.MatchSCmdUserLeaveRaidMatchSCmd = "ServiceEvent_MatchSCmdUserLeaveRaidMatchSCmd"
ServiceEvent.MatchSCmdConfirmTeamMatchSCmd = "ServiceEvent_MatchSCmdConfirmTeamMatchSCmd"
ServiceEvent.MatchSCmdTeamPwsSeasonOverMatchSCmd = "ServiceEvent_MatchSCmdTeamPwsSeasonOverMatchSCmd"
ServiceEvent.MatchSCmdTeamPwsCheckUserMatchSCmd = "ServiceEvent_MatchSCmdTeamPwsCheckUserMatchSCmd"
ServiceEvent.MatchSCmdSyncMenrocoRankInfoMatchSCmd = "ServiceEvent_MatchSCmdSyncMenrocoRankInfoMatchSCmd"
ServiceEvent.MatchSCmdQueryMenrocoRankInfoMatchSCmd = "ServiceEvent_MatchSCmdQueryMenrocoRankInfoMatchSCmd"
ServiceEvent.MatchSCmdEnterTeamRaidMatchSCmd = "ServiceEvent_MatchSCmdEnterTeamRaidMatchSCmd"
