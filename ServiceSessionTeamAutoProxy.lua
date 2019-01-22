ServiceSessionTeamAutoProxy = class('ServiceSessionTeamAutoProxy', ServiceProxy)

ServiceSessionTeamAutoProxy.Instance = nil

ServiceSessionTeamAutoProxy.NAME = 'ServiceSessionTeamAutoProxy'

function ServiceSessionTeamAutoProxy:ctor(proxyName)
	if ServiceSessionTeamAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSessionTeamAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSessionTeamAutoProxy.Instance = self
	end
end

function ServiceSessionTeamAutoProxy:Init()
end

function ServiceSessionTeamAutoProxy:onRegister()
	self:Listen(51, 1, function (data)
		self:RecvTeamList(data) 
	end)
	self:Listen(51, 2, function (data)
		self:RecvTeamDataUpdate(data) 
	end)
	self:Listen(51, 3, function (data)
		self:RecvTeamMemberUpdate(data) 
	end)
	self:Listen(51, 4, function (data)
		self:RecvTeamApplyUpdate(data) 
	end)
	self:Listen(51, 5, function (data)
		self:RecvCreateTeam(data) 
	end)
	self:Listen(51, 6, function (data)
		self:RecvInviteMember(data) 
	end)
	self:Listen(51, 7, function (data)
		self:RecvProcessTeamInvite(data) 
	end)
	self:Listen(51, 8, function (data)
		self:RecvTeamMemberApply(data) 
	end)
	self:Listen(51, 9, function (data)
		self:RecvProcessTeamApply(data) 
	end)
	self:Listen(51, 10, function (data)
		self:RecvKickMember(data) 
	end)
	self:Listen(51, 11, function (data)
		self:RecvExchangeLeader(data) 
	end)
	self:Listen(51, 12, function (data)
		self:RecvExitTeam(data) 
	end)
	self:Listen(51, 13, function (data)
		self:RecvEnterTeam(data) 
	end)
	self:Listen(51, 14, function (data)
		self:RecvMemberPosUpdate(data) 
	end)
	self:Listen(51, 15, function (data)
		self:RecvMemberDataUpdate(data) 
	end)
	self:Listen(51, 16, function (data)
		self:RecvLockTarget(data) 
	end)
	self:Listen(51, 17, function (data)
		self:RecvTeamSummon(data) 
	end)
	self:Listen(51, 18, function (data)
		self:RecvClearApplyList(data) 
	end)
	self:Listen(51, 19, function (data)
		self:RecvQuickEnter(data) 
	end)
	self:Listen(51, 20, function (data)
		self:RecvSetTeamOption(data) 
	end)
	self:Listen(51, 21, function (data)
		self:RecvQueryUserTeamInfoTeamCmd(data) 
	end)
	self:Listen(51, 22, function (data)
		self:RecvSetMemberOptionTeamCmd(data) 
	end)
	self:Listen(51, 23, function (data)
		self:RecvQuestWantedQuestTeamCmd(data) 
	end)
	self:Listen(51, 24, function (data)
		self:RecvUpdateWantedQuestTeamCmd(data) 
	end)
	self:Listen(51, 25, function (data)
		self:RecvAcceptHelpWantedTeamCmd(data) 
	end)
	self:Listen(51, 26, function (data)
		self:RecvUpdateHelpWantedTeamCmd(data) 
	end)
	self:Listen(51, 27, function (data)
		self:RecvQueryHelpWantedTeamCmd(data) 
	end)
	self:Listen(51, 28, function (data)
		self:RecvQueryMemberCatTeamCmd(data) 
	end)
	self:Listen(51, 29, function (data)
		self:RecvMemberCatUpdateTeam(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSessionTeamAutoProxy:CallTeamList(type, page, lv, list) 
	local msg = SessionTeam_pb.TeamList()
	if(type ~= nil )then
		msg.type = type
	end
	if(page ~= nil )then
		msg.page = page
	end
	if(lv ~= nil )then
		msg.lv = lv
	end
	if( list ~= nil )then
		for i=1,#list do 
			table.insert(msg.list, list[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallTeamDataUpdate(name, datas) 
	local msg = SessionTeam_pb.TeamDataUpdate()
	if(name ~= nil )then
		msg.name = name
	end
	if( datas ~= nil )then
		for i=1,#datas do 
			table.insert(msg.datas, datas[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallTeamMemberUpdate(updates, deletes) 
	local msg = SessionTeam_pb.TeamMemberUpdate()
	if( updates ~= nil )then
		for i=1,#updates do 
			table.insert(msg.updates, updates[i])
		end
	end
	if( deletes ~= nil )then
		for i=1,#deletes do 
			table.insert(msg.deletes, deletes[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallTeamApplyUpdate(updates, deletes) 
	local msg = SessionTeam_pb.TeamApplyUpdate()
	if( updates ~= nil )then
		for i=1,#updates do 
			table.insert(msg.updates, updates[i])
		end
	end
	if( deletes ~= nil )then
		for i=1,#deletes do 
			table.insert(msg.deletes, deletes[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallCreateTeam(minlv, maxlv, type, autoaccept, name) 
	local msg = SessionTeam_pb.CreateTeam()
	if(minlv ~= nil )then
		msg.minlv = minlv
	end
	if(maxlv ~= nil )then
		msg.maxlv = maxlv
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(autoaccept ~= nil )then
		msg.autoaccept = autoaccept
	end
	if(name ~= nil )then
		msg.name = name
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallInviteMember(userguid, catid, teamname, username) 
	local msg = SessionTeam_pb.InviteMember()
	if(userguid ~= nil )then
		msg.userguid = userguid
	end
	if(catid ~= nil )then
		msg.catid = catid
	end
	if(teamname ~= nil )then
		msg.teamname = teamname
	end
	if(username ~= nil )then
		msg.username = username
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallProcessTeamInvite(type, userguid) 
	local msg = SessionTeam_pb.ProcessTeamInvite()
	if(type ~= nil )then
		msg.type = type
	end
	if(userguid ~= nil )then
		msg.userguid = userguid
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallTeamMemberApply(guid) 
	local msg = SessionTeam_pb.TeamMemberApply()
	if(guid ~= nil )then
		msg.guid = guid
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallProcessTeamApply(type, userguid) 
	local msg = SessionTeam_pb.ProcessTeamApply()
	if(type ~= nil )then
		msg.type = type
	end
	if(userguid ~= nil )then
		msg.userguid = userguid
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallKickMember(userid, catid) 
	local msg = SessionTeam_pb.KickMember()
	if(userid ~= nil )then
		msg.userid = userid
	end
	if(catid ~= nil )then
		msg.catid = catid
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallExchangeLeader(userid) 
	local msg = SessionTeam_pb.ExchangeLeader()
	if(userid ~= nil )then
		msg.userid = userid
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallExitTeam(teamid) 
	local msg = SessionTeam_pb.ExitTeam()
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallEnterTeam(data) 
	local msg = SessionTeam_pb.EnterTeam()
	if(data ~= nil )then
		if(data.guid ~= nil )then
			msg.data.guid = data.guid
		end
	end
	if(data ~= nil )then
		if(data.zoneid ~= nil )then
			msg.data.zoneid = data.zoneid
		end
	end
	if(data ~= nil )then
		if(data.name ~= nil )then
			msg.data.name = data.name
		end
	end
	if(data ~= nil )then
		if(data.items ~= nil )then
			for i=1,#data.items do 
				table.insert(msg.data.items, data.items[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.members ~= nil )then
			for i=1,#data.members do 
				table.insert(msg.data.members, data.members[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.applys ~= nil )then
			for i=1,#data.applys do 
				table.insert(msg.data.applys, data.applys[i])
			end
		end
	end
	if(data.seal ~= nil )then
		if(data.seal.seal ~= nil )then
			msg.data.seal.seal = data.seal.seal
		end
	end
	if(data.seal ~= nil )then
		if(data.seal.zoneid ~= nil )then
			msg.data.seal.zoneid = data.seal.zoneid
		end
	end
	if(data.seal.pos ~= nil )then
		if(data.seal.pos.x ~= nil )then
			msg.data.seal.pos.x = data.seal.pos.x
		end
	end
	if(data.seal.pos ~= nil )then
		if(data.seal.pos.y ~= nil )then
			msg.data.seal.pos.y = data.seal.pos.y
		end
	end
	if(data.seal.pos ~= nil )then
		if(data.seal.pos.z ~= nil )then
			msg.data.seal.pos.z = data.seal.pos.z
		end
	end
	if(data.seal ~= nil )then
		if(data.seal.teamid ~= nil )then
			msg.data.seal.teamid = data.seal.teamid
		end
	end
	if(data.seal ~= nil )then
		if(data.seal.lastonlinetime ~= nil )then
			msg.data.seal.lastonlinetime = data.seal.lastonlinetime
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallMemberPosUpdate(id, pos) 
	local msg = SessionTeam_pb.MemberPosUpdate()
	if(id ~= nil )then
		msg.id = id
	end
	if(pos ~= nil )then
		if(pos.x ~= nil )then
			msg.pos.x = pos.x
		end
	end
	if(pos ~= nil )then
		if(pos.y ~= nil )then
			msg.pos.y = pos.y
		end
	end
	if(pos ~= nil )then
		if(pos.z ~= nil )then
			msg.pos.z = pos.z
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallMemberDataUpdate(id, members) 
	local msg = SessionTeam_pb.MemberDataUpdate()
	if(id ~= nil )then
		msg.id = id
	end
	if( members ~= nil )then
		for i=1,#members do 
			table.insert(msg.members, members[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallLockTarget(targetid) 
	local msg = SessionTeam_pb.LockTarget()
	if(targetid ~= nil )then
		msg.targetid = targetid
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallTeamSummon(raidid) 
	local msg = SessionTeam_pb.TeamSummon()
	if(raidid ~= nil )then
		msg.raidid = raidid
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallClearApplyList() 
	local msg = SessionTeam_pb.ClearApplyList()
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallQuickEnter(type, time, set) 
	local msg = SessionTeam_pb.QuickEnter()
	if(type ~= nil )then
		msg.type = type
	end
	if(time ~= nil )then
		msg.time = time
	end
	if(set ~= nil )then
		msg.set = set
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallSetTeamOption(name, items) 
	local msg = SessionTeam_pb.SetTeamOption()
	if(name ~= nil )then
		msg.name = name
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallQueryUserTeamInfoTeamCmd(charid, teamid) 
	local msg = SessionTeam_pb.QueryUserTeamInfoTeamCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallSetMemberOptionTeamCmd(autofollow) 
	local msg = SessionTeam_pb.SetMemberOptionTeamCmd()
	if(autofollow ~= nil )then
		msg.autofollow = autofollow
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallQuestWantedQuestTeamCmd(quests) 
	local msg = SessionTeam_pb.QuestWantedQuestTeamCmd()
	if( quests ~= nil )then
		for i=1,#quests do 
			table.insert(msg.quests, quests[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallUpdateWantedQuestTeamCmd(quest) 
	local msg = SessionTeam_pb.UpdateWantedQuestTeamCmd()
	if(quest ~= nil )then
		if(quest.charid ~= nil )then
			msg.quest.charid = quest.charid
		end
	end
	if(quest ~= nil )then
		if(quest.questid ~= nil )then
			msg.quest.questid = quest.questid
		end
	end
	if(quest ~= nil )then
		if(quest.action ~= nil )then
			msg.quest.action = quest.action
		end
	end
	if(quest ~= nil )then
		if(quest.step ~= nil )then
			msg.quest.step = quest.step
		end
	end
	if(quest.questdata ~= nil )then
		if(quest.questdata.process ~= nil )then
			msg.quest.questdata.process = quest.questdata.process
		end
	end
	if(quest ~= nil )then
		if(quest.questdata.params ~= nil )then
			for i=1,#quest.questdata.params do 
				table.insert(msg.quest.questdata.params, quest.questdata.params[i])
			end
		end
	end
	if(quest ~= nil )then
		if(quest.questdata.names ~= nil )then
			for i=1,#quest.questdata.names do 
				table.insert(msg.quest.questdata.names, quest.questdata.names[i])
			end
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.RewardGroup ~= nil )then
			msg.quest.questdata.config.RewardGroup = quest.questdata.config.RewardGroup
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.SubGroup ~= nil )then
			msg.quest.questdata.config.SubGroup = quest.questdata.config.SubGroup
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.FinishJump ~= nil )then
			msg.quest.questdata.config.FinishJump = quest.questdata.config.FinishJump
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.FailJump ~= nil )then
			msg.quest.questdata.config.FailJump = quest.questdata.config.FailJump
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Map ~= nil )then
			msg.quest.questdata.config.Map = quest.questdata.config.Map
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.WhetherTrace ~= nil )then
			msg.quest.questdata.config.WhetherTrace = quest.questdata.config.WhetherTrace
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Auto ~= nil )then
			msg.quest.questdata.config.Auto = quest.questdata.config.Auto
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.FirstClass ~= nil )then
			msg.quest.questdata.config.FirstClass = quest.questdata.config.FirstClass
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Class ~= nil )then
			msg.quest.questdata.config.Class = quest.questdata.config.Class
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Level ~= nil )then
			msg.quest.questdata.config.Level = quest.questdata.config.Level
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.QuestName ~= nil )then
			msg.quest.questdata.config.QuestName = quest.questdata.config.QuestName
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Name ~= nil )then
			msg.quest.questdata.config.Name = quest.questdata.config.Name
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Type ~= nil )then
			msg.quest.questdata.config.Type = quest.questdata.config.Type
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Content ~= nil )then
			msg.quest.questdata.config.Content = quest.questdata.config.Content
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.TraceInfo ~= nil )then
			msg.quest.questdata.config.TraceInfo = quest.questdata.config.TraceInfo
		end
	end
	if(quest ~= nil )then
		if(quest.questdata.config.params.params ~= nil )then
			for i=1,#quest.questdata.config.params.params do 
				table.insert(msg.quest.questdata.config.params.params, quest.questdata.config.params.params[i])
			end
		end
	end
	if(quest ~= nil )then
		if(quest.questdata.config.allrewardid ~= nil )then
			for i=1,#quest.questdata.config.allrewardid do 
				table.insert(msg.quest.questdata.config.allrewardid, quest.questdata.config.allrewardid[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallAcceptHelpWantedTeamCmd(questid, isabandon) 
	local msg = SessionTeam_pb.AcceptHelpWantedTeamCmd()
	if(questid ~= nil )then
		msg.questid = questid
	end
	if(isabandon ~= nil )then
		msg.isabandon = isabandon
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallUpdateHelpWantedTeamCmd(addlist, dellist) 
	local msg = SessionTeam_pb.UpdateHelpWantedTeamCmd()
	if( addlist ~= nil )then
		for i=1,#addlist do 
			table.insert(msg.addlist, addlist[i])
		end
	end
	if( dellist ~= nil )then
		for i=1,#dellist do 
			table.insert(msg.dellist, dellist[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallQueryHelpWantedTeamCmd(questids) 
	local msg = SessionTeam_pb.QueryHelpWantedTeamCmd()
	if( questids ~= nil )then
		for i=1,#questids do 
			table.insert(msg.questids, questids[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallQueryMemberCatTeamCmd() 
	local msg = SessionTeam_pb.QueryMemberCatTeamCmd()
	self:SendProto(msg)
end

function ServiceSessionTeamAutoProxy:CallMemberCatUpdateTeam(updates, dels) 
	local msg = SessionTeam_pb.MemberCatUpdateTeam()
	if( updates ~= nil )then
		for i=1,#updates do 
			table.insert(msg.updates, updates[i])
		end
	end
	if( dels ~= nil )then
		for i=1,#dels do 
			table.insert(msg.dels, dels[i])
		end
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSessionTeamAutoProxy:RecvTeamList(data) 
	self:Notify(ServiceEvent.SessionTeamTeamList, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamDataUpdate(data) 
	self:Notify(ServiceEvent.SessionTeamTeamDataUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamMemberUpdate(data) 
	self:Notify(ServiceEvent.SessionTeamTeamMemberUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamApplyUpdate(data) 
	self:Notify(ServiceEvent.SessionTeamTeamApplyUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvCreateTeam(data) 
	self:Notify(ServiceEvent.SessionTeamCreateTeam, data)
end

function ServiceSessionTeamAutoProxy:RecvInviteMember(data) 
	self:Notify(ServiceEvent.SessionTeamInviteMember, data)
end

function ServiceSessionTeamAutoProxy:RecvProcessTeamInvite(data) 
	self:Notify(ServiceEvent.SessionTeamProcessTeamInvite, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamMemberApply(data) 
	self:Notify(ServiceEvent.SessionTeamTeamMemberApply, data)
end

function ServiceSessionTeamAutoProxy:RecvProcessTeamApply(data) 
	self:Notify(ServiceEvent.SessionTeamProcessTeamApply, data)
end

function ServiceSessionTeamAutoProxy:RecvKickMember(data) 
	self:Notify(ServiceEvent.SessionTeamKickMember, data)
end

function ServiceSessionTeamAutoProxy:RecvExchangeLeader(data) 
	self:Notify(ServiceEvent.SessionTeamExchangeLeader, data)
end

function ServiceSessionTeamAutoProxy:RecvExitTeam(data) 
	self:Notify(ServiceEvent.SessionTeamExitTeam, data)
end

function ServiceSessionTeamAutoProxy:RecvEnterTeam(data) 
	self:Notify(ServiceEvent.SessionTeamEnterTeam, data)
end

function ServiceSessionTeamAutoProxy:RecvMemberPosUpdate(data) 
	self:Notify(ServiceEvent.SessionTeamMemberPosUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvMemberDataUpdate(data) 
	self:Notify(ServiceEvent.SessionTeamMemberDataUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvLockTarget(data) 
	self:Notify(ServiceEvent.SessionTeamLockTarget, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamSummon(data) 
	self:Notify(ServiceEvent.SessionTeamTeamSummon, data)
end

function ServiceSessionTeamAutoProxy:RecvClearApplyList(data) 
	self:Notify(ServiceEvent.SessionTeamClearApplyList, data)
end

function ServiceSessionTeamAutoProxy:RecvQuickEnter(data) 
	self:Notify(ServiceEvent.SessionTeamQuickEnter, data)
end

function ServiceSessionTeamAutoProxy:RecvSetTeamOption(data) 
	self:Notify(ServiceEvent.SessionTeamSetTeamOption, data)
end

function ServiceSessionTeamAutoProxy:RecvQueryUserTeamInfoTeamCmd(data) 
	self:Notify(ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvSetMemberOptionTeamCmd(data) 
	self:Notify(ServiceEvent.SessionTeamSetMemberOptionTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvQuestWantedQuestTeamCmd(data) 
	self:Notify(ServiceEvent.SessionTeamQuestWantedQuestTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvUpdateWantedQuestTeamCmd(data) 
	self:Notify(ServiceEvent.SessionTeamUpdateWantedQuestTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvAcceptHelpWantedTeamCmd(data) 
	self:Notify(ServiceEvent.SessionTeamAcceptHelpWantedTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvUpdateHelpWantedTeamCmd(data) 
	self:Notify(ServiceEvent.SessionTeamUpdateHelpWantedTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvQueryHelpWantedTeamCmd(data) 
	self:Notify(ServiceEvent.SessionTeamQueryHelpWantedTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvQueryMemberCatTeamCmd(data) 
	self:Notify(ServiceEvent.SessionTeamQueryMemberCatTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvMemberCatUpdateTeam(data) 
	self:Notify(ServiceEvent.SessionTeamMemberCatUpdateTeam, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SessionTeamTeamList = "ServiceEvent_SessionTeamTeamList"
ServiceEvent.SessionTeamTeamDataUpdate = "ServiceEvent_SessionTeamTeamDataUpdate"
ServiceEvent.SessionTeamTeamMemberUpdate = "ServiceEvent_SessionTeamTeamMemberUpdate"
ServiceEvent.SessionTeamTeamApplyUpdate = "ServiceEvent_SessionTeamTeamApplyUpdate"
ServiceEvent.SessionTeamCreateTeam = "ServiceEvent_SessionTeamCreateTeam"
ServiceEvent.SessionTeamInviteMember = "ServiceEvent_SessionTeamInviteMember"
ServiceEvent.SessionTeamProcessTeamInvite = "ServiceEvent_SessionTeamProcessTeamInvite"
ServiceEvent.SessionTeamTeamMemberApply = "ServiceEvent_SessionTeamTeamMemberApply"
ServiceEvent.SessionTeamProcessTeamApply = "ServiceEvent_SessionTeamProcessTeamApply"
ServiceEvent.SessionTeamKickMember = "ServiceEvent_SessionTeamKickMember"
ServiceEvent.SessionTeamExchangeLeader = "ServiceEvent_SessionTeamExchangeLeader"
ServiceEvent.SessionTeamExitTeam = "ServiceEvent_SessionTeamExitTeam"
ServiceEvent.SessionTeamEnterTeam = "ServiceEvent_SessionTeamEnterTeam"
ServiceEvent.SessionTeamMemberPosUpdate = "ServiceEvent_SessionTeamMemberPosUpdate"
ServiceEvent.SessionTeamMemberDataUpdate = "ServiceEvent_SessionTeamMemberDataUpdate"
ServiceEvent.SessionTeamLockTarget = "ServiceEvent_SessionTeamLockTarget"
ServiceEvent.SessionTeamTeamSummon = "ServiceEvent_SessionTeamTeamSummon"
ServiceEvent.SessionTeamClearApplyList = "ServiceEvent_SessionTeamClearApplyList"
ServiceEvent.SessionTeamQuickEnter = "ServiceEvent_SessionTeamQuickEnter"
ServiceEvent.SessionTeamSetTeamOption = "ServiceEvent_SessionTeamSetTeamOption"
ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd = "ServiceEvent_SessionTeamQueryUserTeamInfoTeamCmd"
ServiceEvent.SessionTeamSetMemberOptionTeamCmd = "ServiceEvent_SessionTeamSetMemberOptionTeamCmd"
ServiceEvent.SessionTeamQuestWantedQuestTeamCmd = "ServiceEvent_SessionTeamQuestWantedQuestTeamCmd"
ServiceEvent.SessionTeamUpdateWantedQuestTeamCmd = "ServiceEvent_SessionTeamUpdateWantedQuestTeamCmd"
ServiceEvent.SessionTeamAcceptHelpWantedTeamCmd = "ServiceEvent_SessionTeamAcceptHelpWantedTeamCmd"
ServiceEvent.SessionTeamUpdateHelpWantedTeamCmd = "ServiceEvent_SessionTeamUpdateHelpWantedTeamCmd"
ServiceEvent.SessionTeamQueryHelpWantedTeamCmd = "ServiceEvent_SessionTeamQueryHelpWantedTeamCmd"
ServiceEvent.SessionTeamQueryMemberCatTeamCmd = "ServiceEvent_SessionTeamQueryMemberCatTeamCmd"
ServiceEvent.SessionTeamMemberCatUpdateTeam = "ServiceEvent_SessionTeamMemberCatUpdateTeam"
