ServiceMatchCCmdAutoProxy = class('ServiceMatchCCmdAutoProxy', ServiceProxy)

ServiceMatchCCmdAutoProxy.Instance = nil

ServiceMatchCCmdAutoProxy.NAME = 'ServiceMatchCCmdAutoProxy'

function ServiceMatchCCmdAutoProxy:ctor(proxyName)
	if ServiceMatchCCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceMatchCCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceMatchCCmdAutoProxy.Instance = self
	end
end

function ServiceMatchCCmdAutoProxy:Init()
end

function ServiceMatchCCmdAutoProxy:onRegister()
	self:Listen(61, 1, function (data)
		self:RecvReqMyRoomMatchCCmd(data) 
	end)
	self:Listen(61, 2, function (data)
		self:RecvReqRoomListCCmd(data) 
	end)
	self:Listen(61, 3, function (data)
		self:RecvReqRoomDetailCCmd(data) 
	end)
	self:Listen(61, 4, function (data)
		self:RecvJoinRoomCCmd(data) 
	end)
	self:Listen(61, 5, function (data)
		self:RecvLeaveRoomCCmd(data) 
	end)
	self:Listen(61, 7, function (data)
		self:RecvNtfRoomStateCCmd(data) 
	end)
	self:Listen(61, 8, function (data)
		self:RecvNtfFightStatCCmd(data) 
	end)
	self:Listen(61, 9, function (data)
		self:RecvJoinFightingCCmd(data) 
	end)
	self:Listen(61, 10, function (data)
		self:RecvComboNotifyCCmd(data) 
	end)
	self:Listen(61, 11, function (data)
		self:RecvRevChallengeCCmd(data) 
	end)
	self:Listen(61, 12, function (data)
		self:RecvKickTeamCCmd(data) 
	end)
	self:Listen(61, 13, function (data)
		self:RecvFightConfirmCCmd(data) 
	end)
	self:Listen(61, 14, function (data)
		self:RecvPvpResultCCmd(data) 
	end)
	self:Listen(61, 15, function (data)
		self:RecvPvpTeamMemberUpdateCCmd(data) 
	end)
	self:Listen(61, 16, function (data)
		self:RecvPvpMemberDataUpdateCCmd(data) 
	end)
	self:Listen(61, 17, function (data)
		self:RecvNtfMatchInfoCCmd(data) 
	end)
	self:Listen(61, 18, function (data)
		self:RecvGodEndTimeCCmd(data) 
	end)
	self:Listen(61, 19, function (data)
		self:RecvNtfRankChangeCCmd(data) 
	end)
	self:Listen(61, 20, function (data)
		self:RecvOpenGlobalShopPanelCCmd(data) 
	end)
	self:Listen(61, 21, function (data)
		self:RecvTutorMatchResultNtfMatchCCmd(data) 
	end)
	self:Listen(61, 22, function (data)
		self:RecvTutorMatchResponseMatchCCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceMatchCCmdAutoProxy:CallReqMyRoomMatchCCmd(type, brief_info) 
	local msg = MatchCCmd_pb.ReqMyRoomMatchCCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(brief_info ~= nil )then
		if(brief_info.type ~= nil )then
			msg.brief_info.type = brief_info.type
		end
	end
	if(brief_info ~= nil )then
		if(brief_info.state ~= nil )then
			msg.brief_info.state = brief_info.state
		end
	end
	if(brief_info ~= nil )then
		if(brief_info.roomid ~= nil )then
			msg.brief_info.roomid = brief_info.roomid
		end
	end
	if(brief_info ~= nil )then
		if(brief_info.name ~= nil )then
			msg.brief_info.name = brief_info.name
		end
	end
	if(brief_info ~= nil )then
		if(brief_info.raidid ~= nil )then
			msg.brief_info.raidid = brief_info.raidid
		end
	end
	if(brief_info ~= nil )then
		if(brief_info.player_num ~= nil )then
			msg.brief_info.player_num = brief_info.player_num
		end
	end
	if(brief_info ~= nil )then
		if(brief_info.num1 ~= nil )then
			msg.brief_info.num1 = brief_info.num1
		end
	end
	if(brief_info ~= nil )then
		if(brief_info.num2 ~= nil )then
			msg.brief_info.num2 = brief_info.num2
		end
	end
	if(brief_info ~= nil )then
		if(brief_info.num3 ~= nil )then
			msg.brief_info.num3 = brief_info.num3
		end
	end
	if(brief_info ~= nil )then
		if(brief_info.zoneid ~= nil )then
			msg.brief_info.zoneid = brief_info.zoneid
		end
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallReqRoomListCCmd(type, roomids, room_lists) 
	local msg = MatchCCmd_pb.ReqRoomListCCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if( roomids ~= nil )then
		for i=1,#roomids do 
			table.insert(msg.roomids, roomids[i])
		end
	end
	if( room_lists ~= nil )then
		for i=1,#room_lists do 
			table.insert(msg.room_lists, room_lists[i])
		end
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallReqRoomDetailCCmd(type, roomid, datail_info) 
	local msg = MatchCCmd_pb.ReqRoomDetailCCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	if(datail_info ~= nil )then
		if(datail_info.type ~= nil )then
			msg.datail_info.type = datail_info.type
		end
	end
	if(datail_info ~= nil )then
		if(datail_info.state ~= nil )then
			msg.datail_info.state = datail_info.state
		end
	end
	if(datail_info ~= nil )then
		if(datail_info.roomid ~= nil )then
			msg.datail_info.roomid = datail_info.roomid
		end
	end
	if(datail_info ~= nil )then
		if(datail_info.name ~= nil )then
			msg.datail_info.name = datail_info.name
		end
	end
	if(datail_info ~= nil )then
		if(datail_info.team_datas ~= nil )then
			for i=1,#datail_info.team_datas do 
				table.insert(msg.datail_info.team_datas, datail_info.team_datas[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallJoinRoomCCmd(type, roomid, name, isquick, teamid, teammember, ret, guildid, users, matcher) 
	local msg = MatchCCmd_pb.JoinRoomCCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	if(name ~= nil )then
		msg.name = name
	end
	if(isquick ~= nil )then
		msg.isquick = isquick
	end
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	if( teammember ~= nil )then
		for i=1,#teammember do 
			table.insert(msg.teammember, teammember[i])
		end
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	if(guildid ~= nil )then
		msg.guildid = guildid
	end
	if( users ~= nil )then
		for i=1,#users do 
			table.insert(msg.users, users[i])
		end
	end
	if(matcher ~= nil )then
		if(matcher.charid ~= nil )then
			msg.matcher.charid = matcher.charid
		end
	end
	if(matcher ~= nil )then
		if(matcher.zoneid ~= nil )then
			msg.matcher.zoneid = matcher.zoneid
		end
	end
	if(matcher ~= nil )then
		if(matcher.findtutor ~= nil )then
			msg.matcher.findtutor = matcher.findtutor
		end
	end
	if(matcher ~= nil )then
		if(matcher.gender ~= nil )then
			msg.matcher.gender = matcher.gender
		end
	end
	if(matcher ~= nil )then
		if(matcher.selfgender ~= nil )then
			msg.matcher.selfgender = matcher.selfgender
		end
	end
	if(matcher ~= nil )then
		if(matcher.datas ~= nil )then
			for i=1,#matcher.datas do 
				table.insert(msg.matcher.datas, matcher.datas[i])
			end
		end
	end
	if(matcher ~= nil )then
		if(matcher.blackids ~= nil )then
			for i=1,#matcher.blackids do 
				table.insert(msg.matcher.blackids, matcher.blackids[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallLeaveRoomCCmd(type, roomid) 
	local msg = MatchCCmd_pb.LeaveRoomCCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallNtfRoomStateCCmd(pvp_type, roomid, state, endtime) 
	local msg = MatchCCmd_pb.NtfRoomStateCCmd()
	if(pvp_type ~= nil )then
		msg.pvp_type = pvp_type
	end
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	if(state ~= nil )then
		msg.state = state
	end
	if(endtime ~= nil )then
		msg.endtime = endtime
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallNtfFightStatCCmd(pvp_type, starttime, player_num, score, my_teamscore, enemy_teamscore, remain_hp, myrank) 
	local msg = MatchCCmd_pb.NtfFightStatCCmd()
	if(pvp_type ~= nil )then
		msg.pvp_type = pvp_type
	end
	if(starttime ~= nil )then
		msg.starttime = starttime
	end
	if(player_num ~= nil )then
		msg.player_num = player_num
	end
	if(score ~= nil )then
		msg.score = score
	end
	if(my_teamscore ~= nil )then
		msg.my_teamscore = my_teamscore
	end
	if(enemy_teamscore ~= nil )then
		msg.enemy_teamscore = enemy_teamscore
	end
	if(remain_hp ~= nil )then
		msg.remain_hp = remain_hp
	end
	if(myrank ~= nil )then
		msg.myrank = myrank
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallJoinFightingCCmd(type, roomid, ret) 
	local msg = MatchCCmd_pb.JoinFightingCCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallComboNotifyCCmd(comboNum) 
	local msg = MatchCCmd_pb.ComboNotifyCCmd()
	if(comboNum ~= nil )then
		msg.comboNum = comboNum
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallRevChallengeCCmd(type, roomid, challenger, challenger_zoneid, members, reply) 
	local msg = MatchCCmd_pb.RevChallengeCCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	if(challenger ~= nil )then
		msg.challenger = challenger
	end
	if(challenger_zoneid ~= nil )then
		msg.challenger_zoneid = challenger_zoneid
	end
	if( members ~= nil )then
		for i=1,#members do 
			table.insert(msg.members, members[i])
		end
	end
	if(reply ~= nil )then
		msg.reply = reply
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallKickTeamCCmd(type, roomid, zoneid, teamid) 
	local msg = MatchCCmd_pb.KickTeamCCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	if(zoneid ~= nil )then
		msg.zoneid = zoneid
	end
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallFightConfirmCCmd(type, roomid, teamid, reply, challenger) 
	local msg = MatchCCmd_pb.FightConfirmCCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	if(reply ~= nil )then
		msg.reply = reply
	end
	if(challenger ~= nil )then
		msg.challenger = challenger
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallPvpResultCCmd(type, result, rank, reward, apple) 
	local msg = MatchCCmd_pb.PvpResultCCmd()
	msg.type = type
	msg.result = result
	if( rank ~= nil )then
		for i=1,#rank do 
			table.insert(msg.rank, rank[i])
		end
	end
	if( reward ~= nil )then
		for i=1,#reward do 
			table.insert(msg.reward, reward[i])
		end
	end
	if(apple ~= nil )then
		msg.apple = apple
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallPvpTeamMemberUpdateCCmd(data) 
	local msg = MatchCCmd_pb.PvpTeamMemberUpdateCCmd()
	if(data ~= nil )then
		if(data.zoneid ~= nil )then
			msg.data.zoneid = data.zoneid
		end
	end
	if(data ~= nil )then
		if(data.teamid ~= nil )then
			msg.data.teamid = data.teamid
		end
	end
	if(data ~= nil )then
		if(data.roomid ~= nil )then
			msg.data.roomid = data.roomid
		end
	end
	if(data ~= nil )then
		if(data.isfirst ~= nil )then
			msg.data.isfirst = data.isfirst
		end
	end
	if(data ~= nil )then
		if(data.updates ~= nil )then
			for i=1,#data.updates do 
				table.insert(msg.data.updates, data.updates[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.deletes ~= nil )then
			for i=1,#data.deletes do 
				table.insert(msg.data.deletes, data.deletes[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.index ~= nil )then
			msg.data.index = data.index
		end
	end
	if(data ~= nil )then
		if(data.teamname ~= nil )then
			msg.data.teamname = data.teamname
		end
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallPvpMemberDataUpdateCCmd(data) 
	local msg = MatchCCmd_pb.PvpMemberDataUpdateCCmd()
	if(data ~= nil )then
		if(data.zoneid ~= nil )then
			msg.data.zoneid = data.zoneid
		end
	end
	if(data ~= nil )then
		if(data.teamid ~= nil )then
			msg.data.teamid = data.teamid
		end
	end
	if(data ~= nil )then
		if(data.charid ~= nil )then
			msg.data.charid = data.charid
		end
	end
	if(data ~= nil )then
		if(data.roomid ~= nil )then
			msg.data.roomid = data.roomid
		end
	end
	if(data ~= nil )then
		if(data.members ~= nil )then
			for i=1,#data.members do 
				table.insert(msg.data.members, data.members[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallNtfMatchInfoCCmd(etype, ismatch, isfight) 
	local msg = MatchCCmd_pb.NtfMatchInfoCCmd()
	if(etype ~= nil )then
		msg.etype = etype
	end
	if(ismatch ~= nil )then
		msg.ismatch = ismatch
	end
	if(isfight ~= nil )then
		msg.isfight = isfight
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallGodEndTimeCCmd(endtime) 
	local msg = MatchCCmd_pb.GodEndTimeCCmd()
	if(endtime ~= nil )then
		msg.endtime = endtime
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallNtfRankChangeCCmd(ranks) 
	local msg = MatchCCmd_pb.NtfRankChangeCCmd()
	if( ranks ~= nil )then
		for i=1,#ranks do 
			table.insert(msg.ranks, ranks[i])
		end
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallOpenGlobalShopPanelCCmd(open) 
	local msg = MatchCCmd_pb.OpenGlobalShopPanelCCmd()
	if(open ~= nil )then
		msg.open = open
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallTutorMatchResultNtfMatchCCmd(target, status) 
	local msg = MatchCCmd_pb.TutorMatchResultNtfMatchCCmd()
	if(target ~= nil )then
		if(target.charid ~= nil )then
			msg.target.charid = target.charid
		end
	end
	if(target ~= nil )then
		if(target.zoneid ~= nil )then
			msg.target.zoneid = target.zoneid
		end
	end
	if(target ~= nil )then
		if(target.findtutor ~= nil )then
			msg.target.findtutor = target.findtutor
		end
	end
	if(target ~= nil )then
		if(target.gender ~= nil )then
			msg.target.gender = target.gender
		end
	end
	if(target ~= nil )then
		if(target.selfgender ~= nil )then
			msg.target.selfgender = target.selfgender
		end
	end
	if(target ~= nil )then
		if(target.datas ~= nil )then
			for i=1,#target.datas do 
				table.insert(msg.target.datas, target.datas[i])
			end
		end
	end
	if(target ~= nil )then
		if(target.blackids ~= nil )then
			for i=1,#target.blackids do 
				table.insert(msg.target.blackids, target.blackids[i])
			end
		end
	end
	if(status ~= nil )then
		msg.status = status
	end
	self:SendProto(msg)
end

function ServiceMatchCCmdAutoProxy:CallTutorMatchResponseMatchCCmd(status) 
	local msg = MatchCCmd_pb.TutorMatchResponseMatchCCmd()
	if(status ~= nil )then
		msg.status = status
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceMatchCCmdAutoProxy:RecvReqMyRoomMatchCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdReqMyRoomMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReqRoomListCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdReqRoomListCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReqRoomDetailCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdReqRoomDetailCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvJoinRoomCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdJoinRoomCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvLeaveRoomCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdLeaveRoomCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvNtfRoomStateCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdNtfRoomStateCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvNtfFightStatCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdNtfFightStatCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvJoinFightingCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdJoinFightingCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvComboNotifyCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdComboNotifyCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvRevChallengeCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdRevChallengeCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvKickTeamCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdKickTeamCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvFightConfirmCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdFightConfirmCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvPvpResultCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdPvpResultCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvPvpTeamMemberUpdateCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdPvpTeamMemberUpdateCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvPvpMemberDataUpdateCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdPvpMemberDataUpdateCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvNtfMatchInfoCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvGodEndTimeCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdGodEndTimeCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvNtfRankChangeCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdNtfRankChangeCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvOpenGlobalShopPanelCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdOpenGlobalShopPanelCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTutorMatchResultNtfMatchCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdTutorMatchResultNtfMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTutorMatchResponseMatchCCmd(data) 
	self:Notify(ServiceEvent.MatchCCmdTutorMatchResponseMatchCCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.MatchCCmdReqMyRoomMatchCCmd = "ServiceEvent_MatchCCmdReqMyRoomMatchCCmd"
ServiceEvent.MatchCCmdReqRoomListCCmd = "ServiceEvent_MatchCCmdReqRoomListCCmd"
ServiceEvent.MatchCCmdReqRoomDetailCCmd = "ServiceEvent_MatchCCmdReqRoomDetailCCmd"
ServiceEvent.MatchCCmdJoinRoomCCmd = "ServiceEvent_MatchCCmdJoinRoomCCmd"
ServiceEvent.MatchCCmdLeaveRoomCCmd = "ServiceEvent_MatchCCmdLeaveRoomCCmd"
ServiceEvent.MatchCCmdNtfRoomStateCCmd = "ServiceEvent_MatchCCmdNtfRoomStateCCmd"
ServiceEvent.MatchCCmdNtfFightStatCCmd = "ServiceEvent_MatchCCmdNtfFightStatCCmd"
ServiceEvent.MatchCCmdJoinFightingCCmd = "ServiceEvent_MatchCCmdJoinFightingCCmd"
ServiceEvent.MatchCCmdComboNotifyCCmd = "ServiceEvent_MatchCCmdComboNotifyCCmd"
ServiceEvent.MatchCCmdRevChallengeCCmd = "ServiceEvent_MatchCCmdRevChallengeCCmd"
ServiceEvent.MatchCCmdKickTeamCCmd = "ServiceEvent_MatchCCmdKickTeamCCmd"
ServiceEvent.MatchCCmdFightConfirmCCmd = "ServiceEvent_MatchCCmdFightConfirmCCmd"
ServiceEvent.MatchCCmdPvpResultCCmd = "ServiceEvent_MatchCCmdPvpResultCCmd"
ServiceEvent.MatchCCmdPvpTeamMemberUpdateCCmd = "ServiceEvent_MatchCCmdPvpTeamMemberUpdateCCmd"
ServiceEvent.MatchCCmdPvpMemberDataUpdateCCmd = "ServiceEvent_MatchCCmdPvpMemberDataUpdateCCmd"
ServiceEvent.MatchCCmdNtfMatchInfoCCmd = "ServiceEvent_MatchCCmdNtfMatchInfoCCmd"
ServiceEvent.MatchCCmdGodEndTimeCCmd = "ServiceEvent_MatchCCmdGodEndTimeCCmd"
ServiceEvent.MatchCCmdNtfRankChangeCCmd = "ServiceEvent_MatchCCmdNtfRankChangeCCmd"
ServiceEvent.MatchCCmdOpenGlobalShopPanelCCmd = "ServiceEvent_MatchCCmdOpenGlobalShopPanelCCmd"
ServiceEvent.MatchCCmdTutorMatchResultNtfMatchCCmd = "ServiceEvent_MatchCCmdTutorMatchResultNtfMatchCCmd"
ServiceEvent.MatchCCmdTutorMatchResponseMatchCCmd = "ServiceEvent_MatchCCmdTutorMatchResponseMatchCCmd"
