ServiceGuildCmdAutoProxy = class('ServiceGuildCmdAutoProxy', ServiceProxy)

ServiceGuildCmdAutoProxy.Instance = nil

ServiceGuildCmdAutoProxy.NAME = 'ServiceGuildCmdAutoProxy'

function ServiceGuildCmdAutoProxy:ctor(proxyName)
	if ServiceGuildCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceGuildCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceGuildCmdAutoProxy.Instance = self
	end
end

function ServiceGuildCmdAutoProxy:Init()
end

function ServiceGuildCmdAutoProxy:onRegister()
	self:Listen(50, 1, function (data)
		self:RecvQueryGuildListGuildCmd(data) 
	end)
	self:Listen(50, 2, function (data)
		self:RecvCreateGuildGuildCmd(data) 
	end)
	self:Listen(50, 3, function (data)
		self:RecvEnterGuildGuildCmd(data) 
	end)
	self:Listen(50, 4, function (data)
		self:RecvGuildMemberUpdateGuildCmd(data) 
	end)
	self:Listen(50, 5, function (data)
		self:RecvGuildApplyUpdateGuildCmd(data) 
	end)
	self:Listen(50, 6, function (data)
		self:RecvGuildDataUpdateGuildCmd(data) 
	end)
	self:Listen(50, 7, function (data)
		self:RecvGuildMemberDataUpdateGuildCmd(data) 
	end)
	self:Listen(50, 8, function (data)
		self:RecvApplyGuildGuildCmd(data) 
	end)
	self:Listen(50, 9, function (data)
		self:RecvProcessApplyGuildCmd(data) 
	end)
	self:Listen(50, 10, function (data)
		self:RecvInviteMemberGuildCmd(data) 
	end)
	self:Listen(50, 11, function (data)
		self:RecvProcessInviteGuildCmd(data) 
	end)
	self:Listen(50, 12, function (data)
		self:RecvSetGuildOptionGuildCmd(data) 
	end)
	self:Listen(50, 13, function (data)
		self:RecvKickMemberGuildCmd(data) 
	end)
	self:Listen(50, 14, function (data)
		self:RecvChangeJobGuildCmd(data) 
	end)
	self:Listen(50, 15, function (data)
		self:RecvExitGuildGuildCmd(data) 
	end)
	self:Listen(50, 16, function (data)
		self:RecvExchangeChairGuildCmd(data) 
	end)
	self:Listen(50, 17, function (data)
		self:RecvDismissGuildCmd(data) 
	end)
	self:Listen(50, 18, function (data)
		self:RecvLevelupGuildCmd(data) 
	end)
	self:Listen(50, 19, function (data)
		self:RecvDonateGuildCmd(data) 
	end)
	self:Listen(50, 25, function (data)
		self:RecvDonateListGuildCmd(data) 
	end)
	self:Listen(50, 26, function (data)
		self:RecvUpdateDonateItemGuildCmd(data) 
	end)
	self:Listen(50, 27, function (data)
		self:RecvDonateFrameGuildCmd(data) 
	end)
	self:Listen(50, 20, function (data)
		self:RecvEnterTerritoryGuildCmd(data) 
	end)
	self:Listen(50, 21, function (data)
		self:RecvPrayGuildCmd(data) 
	end)
	self:Listen(50, 22, function (data)
		self:RecvGuildInfoNtf(data) 
	end)
	self:Listen(50, 23, function (data)
		self:RecvGuildPrayNtfGuildCmd(data) 
	end)
	self:Listen(50, 24, function (data)
		self:RecvLevelupEffectGuildCmd(data) 
	end)
	self:Listen(50, 28, function (data)
		self:RecvQueryPackGuildCmd(data) 
	end)
	self:Listen(50, 32, function (data)
		self:RecvPackUpdateGuildCmd(data) 
	end)
	self:Listen(50, 29, function (data)
		self:RecvExchangeZoneGuildCmd(data) 
	end)
	self:Listen(50, 30, function (data)
		self:RecvExchangeZoneNtfGuildCmd(data) 
	end)
	self:Listen(50, 31, function (data)
		self:RecvExchangeZoneAnswerGuildCmd(data) 
	end)
	self:Listen(50, 33, function (data)
		self:RecvQueryEventListGuildCmd(data) 
	end)
	self:Listen(50, 34, function (data)
		self:RecvNewEventGuildCmd(data) 
	end)
	self:Listen(50, 35, function (data)
		self:RecvApplyRewardConGuildCmd(data) 
	end)
	self:Listen(50, 37, function (data)
		self:RecvFrameStatusGuildCmd(data) 
	end)
	self:Listen(50, 38, function (data)
		self:RecvModifyAuthGuildCmd(data) 
	end)
	self:Listen(50, 39, function (data)
		self:RecvJobUpdateGuildCmd(data) 
	end)
	self:Listen(50, 40, function (data)
		self:RecvRenameQueryGuildCmd(data) 
	end)
	self:Listen(50, 41, function (data)
		self:RecvQueryGuildCityInfoGuildCmd(data) 
	end)
	self:Listen(50, 42, function (data)
		self:RecvCityActionGuildCmd(data) 
	end)
	self:Listen(50, 43, function (data)
		self:RecvGuildIconSyncGuildCmd(data) 
	end)
	self:Listen(50, 44, function (data)
		self:RecvGuildIconAddGuildCmd(data) 
	end)
	self:Listen(50, 45, function (data)
		self:RecvGuildIconUploadGuildCmd(data) 
	end)
	self:Listen(50, 47, function (data)
		self:RecvOpenFunctionGuildCmd(data) 
	end)
	self:Listen(50, 48, function (data)
		self:RecvBuildGuildCmd(data) 
	end)
	self:Listen(50, 49, function (data)
		self:RecvSubmitMaterialGuildCmd(data) 
	end)
	self:Listen(50, 50, function (data)
		self:RecvBuildingNtfGuildCmd(data) 
	end)
	self:Listen(50, 51, function (data)
		self:RecvBuildingSubmitCountGuildCmd(data) 
	end)
	self:Listen(50, 52, function (data)
		self:RecvChallengeUpdateNtfGuildCmd(data) 
	end)
	self:Listen(50, 53, function (data)
		self:RecvWelfareNtfGuildCmd(data) 
	end)
	self:Listen(50, 54, function (data)
		self:RecvGetWelfareGuildCmd(data) 
	end)
	self:Listen(50, 55, function (data)
		self:RecvBuildingLvupEffGuildCmd(data) 
	end)
	self:Listen(50, 56, function (data)
		self:RecvArtifactUpdateNtfGuildCmd(data) 
	end)
	self:Listen(50, 57, function (data)
		self:RecvArtifactProduceGuildCmd(data) 
	end)
	self:Listen(50, 58, function (data)
		self:RecvArtifactOptGuildCmd(data) 
	end)
	self:Listen(50, 59, function (data)
		self:RecvQueryGQuestGuildCmd(data) 
	end)
	self:Listen(50, 60, function (data)
		self:RecvTreasureActionGuildCmd(data) 
	end)
	self:Listen(50, 61, function (data)
		self:RecvQueryBuildingRankGuildCmd(data) 
	end)
	self:Listen(50, 62, function (data)
		self:RecvQueryTreasureResultGuildCmd(data) 
	end)
	self:Listen(50, 63, function (data)
		self:RecvQueryGCityShowInfoGuildCmd(data) 
	end)
	self:Listen(50, 64, function (data)
		self:RecvGvgOpenFireGuildCmd(data) 
	end)
	self:Listen(50, 66, function (data)
		self:RecvEnterPunishTimeNtfGuildCmd(data) 
	end)
	self:Listen(50, 65, function (data)
		self:RecvOpenRealtimeVoiceGuildCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceGuildCmdAutoProxy:CallQueryGuildListGuildCmd(keyword, page, list) 
	local msg = GuildCmd_pb.QueryGuildListGuildCmd()
	if(keyword ~= nil )then
		msg.keyword = keyword
	end
	if(page ~= nil )then
		msg.page = page
	end
	if( list ~= nil )then
		for i=1,#list do 
			table.insert(msg.list, list[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallCreateGuildGuildCmd(name) 
	local msg = GuildCmd_pb.CreateGuildGuildCmd()
	if(name ~= nil )then
		msg.name = name
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallEnterGuildGuildCmd(data) 
	local msg = GuildCmd_pb.EnterGuildGuildCmd()
	if(data.summary ~= nil )then
		if(data.summary.guid ~= nil )then
			msg.data.summary.guid = data.summary.guid
		end
	end
	if(data.summary ~= nil )then
		if(data.summary.level ~= nil )then
			msg.data.summary.level = data.summary.level
		end
	end
	if(data.summary ~= nil )then
		if(data.summary.zoneid ~= nil )then
			msg.data.summary.zoneid = data.summary.zoneid
		end
	end
	if(data.summary ~= nil )then
		if(data.summary.curmember ~= nil )then
			msg.data.summary.curmember = data.summary.curmember
		end
	end
	if(data.summary ~= nil )then
		if(data.summary.maxmember ~= nil )then
			msg.data.summary.maxmember = data.summary.maxmember
		end
	end
	if(data.summary ~= nil )then
		if(data.summary.cityid ~= nil )then
			msg.data.summary.cityid = data.summary.cityid
		end
	end
	if(data.summary ~= nil )then
		if(data.summary.chairmangender ~= nil )then
			msg.data.summary.chairmangender = data.summary.chairmangender
		end
	end
	if(data.summary ~= nil )then
		if(data.summary.chairmanname ~= nil )then
			msg.data.summary.chairmanname = data.summary.chairmanname
		end
	end
	if(data.summary ~= nil )then
		if(data.summary.guildname ~= nil )then
			msg.data.summary.guildname = data.summary.guildname
		end
	end
	if(data.summary ~= nil )then
		if(data.summary.recruitinfo ~= nil )then
			msg.data.summary.recruitinfo = data.summary.recruitinfo
		end
	end
	if(data.summary ~= nil )then
		if(data.summary.portrait ~= nil )then
			msg.data.summary.portrait = data.summary.portrait
		end
	end
	if(data ~= nil )then
		if(data.questresettime ~= nil )then
			msg.data.questresettime = data.questresettime
		end
	end
	if(data ~= nil )then
		if(data.asset ~= nil )then
			msg.data.asset = data.asset
		end
	end
	if(data ~= nil )then
		if(data.dismisstime ~= nil )then
			msg.data.dismisstime = data.dismisstime
		end
	end
	if(data ~= nil )then
		if(data.zonetime ~= nil )then
			msg.data.zonetime = data.zonetime
		end
	end
	if(data ~= nil )then
		if(data.createtime ~= nil )then
			msg.data.createtime = data.createtime
		end
	end
	if(data ~= nil )then
		if(data.nextzone ~= nil )then
			msg.data.nextzone = data.nextzone
		end
	end
	if(data ~= nil )then
		if(data.donatetime1 ~= nil )then
			msg.data.donatetime1 = data.donatetime1
		end
	end
	if(data ~= nil )then
		if(data.donatetime2 ~= nil )then
			msg.data.donatetime2 = data.donatetime2
		end
	end
	if(data ~= nil )then
		if(data.name ~= nil )then
			msg.data.name = data.name
		end
	end
	if(data ~= nil )then
		if(data.boardinfo ~= nil )then
			msg.data.boardinfo = data.boardinfo
		end
	end
	if(data ~= nil )then
		if(data.recruitinfo ~= nil )then
			msg.data.recruitinfo = data.recruitinfo
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
	if(data ~= nil )then
		if(data.jobs ~= nil )then
			for i=1,#data.jobs do 
				table.insert(msg.data.jobs, data.jobs[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.assettoday ~= nil )then
			msg.data.assettoday = data.assettoday
		end
	end
	if(data ~= nil )then
		if(data.citygiveuptime ~= nil )then
			msg.data.citygiveuptime = data.citygiveuptime
		end
	end
	if(data ~= nil )then
		if(data.openfunction ~= nil )then
			msg.data.openfunction = data.openfunction
		end
	end
	if(data ~= nil )then
		if(data.challenges ~= nil )then
			for i=1,#data.challenges do 
				table.insert(msg.data.challenges, data.challenges[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.gvg_treasure_count ~= nil )then
			msg.data.gvg_treasure_count = data.gvg_treasure_count
		end
	end
	if(data ~= nil )then
		if(data.guild_treasure_count ~= nil )then
			msg.data.guild_treasure_count = data.guild_treasure_count
		end
	end
	if(data ~= nil )then
		if(data.bcoin_treasure_count ~= nil )then
			msg.data.bcoin_treasure_count = data.bcoin_treasure_count
		end
	end
	if(data ~= nil )then
		if(data.insupergvg ~= nil )then
			msg.data.insupergvg = data.insupergvg
		end
	end
	if(data ~= nil )then
		if(data.supergvg_lv ~= nil )then
			msg.data.supergvg_lv = data.supergvg_lv
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallGuildMemberUpdateGuildCmd(updates, dels) 
	local msg = GuildCmd_pb.GuildMemberUpdateGuildCmd()
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

function ServiceGuildCmdAutoProxy:CallGuildApplyUpdateGuildCmd(updates, dels) 
	local msg = GuildCmd_pb.GuildApplyUpdateGuildCmd()
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

function ServiceGuildCmdAutoProxy:CallGuildDataUpdateGuildCmd(updates) 
	local msg = GuildCmd_pb.GuildDataUpdateGuildCmd()
	if( updates ~= nil )then
		for i=1,#updates do 
			table.insert(msg.updates, updates[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallGuildMemberDataUpdateGuildCmd(type, charid, updates) 
	local msg = GuildCmd_pb.GuildMemberDataUpdateGuildCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	if( updates ~= nil )then
		for i=1,#updates do 
			table.insert(msg.updates, updates[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallApplyGuildGuildCmd(guid) 
	local msg = GuildCmd_pb.ApplyGuildGuildCmd()
	if(guid ~= nil )then
		msg.guid = guid
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallProcessApplyGuildCmd(action, charid) 
	local msg = GuildCmd_pb.ProcessApplyGuildCmd()
	if(action ~= nil )then
		msg.action = action
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallInviteMemberGuildCmd(charid, guildid, guildname, invitename) 
	local msg = GuildCmd_pb.InviteMemberGuildCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(guildid ~= nil )then
		msg.guildid = guildid
	end
	if(guildname ~= nil )then
		msg.guildname = guildname
	end
	if(invitename ~= nil )then
		msg.invitename = invitename
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallProcessInviteGuildCmd(action, guid) 
	local msg = GuildCmd_pb.ProcessInviteGuildCmd()
	if(action ~= nil )then
		msg.action = action
	end
	if(guid ~= nil )then
		msg.guid = guid
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallSetGuildOptionGuildCmd(board, recruit, portrait, jobs) 
	local msg = GuildCmd_pb.SetGuildOptionGuildCmd()
	if(board ~= nil )then
		msg.board = board
	end
	if(recruit ~= nil )then
		msg.recruit = recruit
	end
	if(portrait ~= nil )then
		msg.portrait = portrait
	end
	if( jobs ~= nil )then
		for i=1,#jobs do 
			table.insert(msg.jobs, jobs[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallKickMemberGuildCmd(charid) 
	local msg = GuildCmd_pb.KickMemberGuildCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallChangeJobGuildCmd(charid, job) 
	local msg = GuildCmd_pb.ChangeJobGuildCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(job ~= nil )then
		msg.job = job
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallExitGuildGuildCmd() 
	local msg = GuildCmd_pb.ExitGuildGuildCmd()
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallExchangeChairGuildCmd(newcharid) 
	local msg = GuildCmd_pb.ExchangeChairGuildCmd()
	if(newcharid ~= nil )then
		msg.newcharid = newcharid
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallDismissGuildCmd(set) 
	local msg = GuildCmd_pb.DismissGuildCmd()
	if(set ~= nil )then
		msg.set = set
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallLevelupGuildCmd() 
	local msg = GuildCmd_pb.LevelupGuildCmd()
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallDonateGuildCmd(configid, time) 
	local msg = GuildCmd_pb.DonateGuildCmd()
	if(configid ~= nil )then
		msg.configid = configid
	end
	if(time ~= nil )then
		msg.time = time
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallDonateListGuildCmd(items) 
	local msg = GuildCmd_pb.DonateListGuildCmd()
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallUpdateDonateItemGuildCmd(item, del) 
	local msg = GuildCmd_pb.UpdateDonateItemGuildCmd()
	if(item ~= nil )then
		if(item.configid ~= nil )then
			msg.item.configid = item.configid
		end
	end
	if(item ~= nil )then
		if(item.count ~= nil )then
			msg.item.count = item.count
		end
	end
	if(item ~= nil )then
		if(item.time ~= nil )then
			msg.item.time = item.time
		end
	end
	if(item ~= nil )then
		if(item.itemid ~= nil )then
			msg.item.itemid = item.itemid
		end
	end
	if(item ~= nil )then
		if(item.itemcount ~= nil )then
			msg.item.itemcount = item.itemcount
		end
	end
	if(item ~= nil )then
		if(item.contribute ~= nil )then
			msg.item.contribute = item.contribute
		end
	end
	if(item ~= nil )then
		if(item.medal ~= nil )then
			msg.item.medal = item.medal
		end
	end
	if(del ~= nil )then
		if(del.configid ~= nil )then
			msg.del.configid = del.configid
		end
	end
	if(del ~= nil )then
		if(del.count ~= nil )then
			msg.del.count = del.count
		end
	end
	if(del ~= nil )then
		if(del.time ~= nil )then
			msg.del.time = del.time
		end
	end
	if(del ~= nil )then
		if(del.itemid ~= nil )then
			msg.del.itemid = del.itemid
		end
	end
	if(del ~= nil )then
		if(del.itemcount ~= nil )then
			msg.del.itemcount = del.itemcount
		end
	end
	if(del ~= nil )then
		if(del.contribute ~= nil )then
			msg.del.contribute = del.contribute
		end
	end
	if(del ~= nil )then
		if(del.medal ~= nil )then
			msg.del.medal = del.medal
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallDonateFrameGuildCmd(open) 
	local msg = GuildCmd_pb.DonateFrameGuildCmd()
	if(open ~= nil )then
		msg.open = open
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallEnterTerritoryGuildCmd(handid) 
	local msg = GuildCmd_pb.EnterTerritoryGuildCmd()
	if(handid ~= nil )then
		msg.handid = handid
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallPrayGuildCmd(npcid, pray) 
	local msg = GuildCmd_pb.PrayGuildCmd()
	if(npcid ~= nil )then
		msg.npcid = npcid
	end
	if(pray ~= nil )then
		msg.pray = pray
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallGuildInfoNtf(charid, id, name, icon, job) 
	local msg = GuildCmd_pb.GuildInfoNtf()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(id ~= nil )then
		msg.id = id
	end
	if(name ~= nil )then
		msg.name = name
	end
	if(icon ~= nil )then
		msg.icon = icon
	end
	if(job ~= nil )then
		msg.job = job
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallGuildPrayNtfGuildCmd(prays) 
	local msg = GuildCmd_pb.GuildPrayNtfGuildCmd()
	if( prays ~= nil )then
		for i=1,#prays do 
			table.insert(msg.prays, prays[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallLevelupEffectGuildCmd() 
	local msg = GuildCmd_pb.LevelupEffectGuildCmd()
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallQueryPackGuildCmd(items) 
	local msg = GuildCmd_pb.QueryPackGuildCmd()
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallPackUpdateGuildCmd(updates, dels) 
	local msg = GuildCmd_pb.PackUpdateGuildCmd()
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

function ServiceGuildCmdAutoProxy:CallExchangeZoneGuildCmd(zoneid, set) 
	local msg = GuildCmd_pb.ExchangeZoneGuildCmd()
	if(zoneid ~= nil )then
		msg.zoneid = zoneid
	end
	if(set ~= nil )then
		msg.set = set
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallExchangeZoneNtfGuildCmd(nextzoneid, curzoneid) 
	local msg = GuildCmd_pb.ExchangeZoneNtfGuildCmd()
	if(nextzoneid ~= nil )then
		msg.nextzoneid = nextzoneid
	end
	if(curzoneid ~= nil )then
		msg.curzoneid = curzoneid
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallExchangeZoneAnswerGuildCmd(agree) 
	local msg = GuildCmd_pb.ExchangeZoneAnswerGuildCmd()
	if(agree ~= nil )then
		msg.agree = agree
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallQueryEventListGuildCmd(events) 
	local msg = GuildCmd_pb.QueryEventListGuildCmd()
	if( events ~= nil )then
		for i=1,#events do 
			table.insert(msg.events, events[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallNewEventGuildCmd(del, event) 
	local msg = GuildCmd_pb.NewEventGuildCmd()
	if(del ~= nil )then
		msg.del = del
	end
	if(event ~= nil )then
		if(event.guid ~= nil )then
			msg.event.guid = event.guid
		end
	end
	if(event ~= nil )then
		if(event.eventid ~= nil )then
			msg.event.eventid = event.eventid
		end
	end
	if(event ~= nil )then
		if(event.time ~= nil )then
			msg.event.time = event.time
		end
	end
	if(event ~= nil )then
		if(event.param ~= nil )then
			for i=1,#event.param do 
				table.insert(msg.event.param, event.param[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallApplyRewardConGuildCmd(configid, con, asset) 
	local msg = GuildCmd_pb.ApplyRewardConGuildCmd()
	if(configid ~= nil )then
		msg.configid = configid
	end
	if( con ~= nil )then
		for i=1,#con do 
			table.insert(msg.con, con[i])
		end
	end
	if( asset ~= nil )then
		for i=1,#asset do 
			table.insert(msg.asset, asset[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallFrameStatusGuildCmd(open) 
	local msg = GuildCmd_pb.FrameStatusGuildCmd()
	if(open ~= nil )then
		msg.open = open
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallModifyAuthGuildCmd(add, modify, job, auth) 
	local msg = GuildCmd_pb.ModifyAuthGuildCmd()
	if(add ~= nil )then
		msg.add = add
	end
	if(modify ~= nil )then
		msg.modify = modify
	end
	if(job ~= nil )then
		msg.job = job
	end
	if(auth ~= nil )then
		msg.auth = auth
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallJobUpdateGuildCmd(job) 
	local msg = GuildCmd_pb.JobUpdateGuildCmd()
	if(job ~= nil )then
		if(job.job ~= nil )then
			msg.job.job = job.job
		end
	end
	if(job ~= nil )then
		if(job.name ~= nil )then
			msg.job.name = job.name
		end
	end
	if(job ~= nil )then
		if(job.auth ~= nil )then
			msg.job.auth = job.auth
		end
	end
	if(job ~= nil )then
		if(job.editauth ~= nil )then
			msg.job.editauth = job.editauth
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallRenameQueryGuildCmd(name, code) 
	local msg = GuildCmd_pb.RenameQueryGuildCmd()
	if(name ~= nil )then
		msg.name = name
	end
	if(code ~= nil )then
		msg.code = code
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallQueryGuildCityInfoGuildCmd(infos) 
	local msg = GuildCmd_pb.QueryGuildCityInfoGuildCmd()
	if( infos ~= nil )then
		for i=1,#infos do 
			table.insert(msg.infos, infos[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallCityActionGuildCmd(action) 
	local msg = GuildCmd_pb.CityActionGuildCmd()
	if(action ~= nil )then
		msg.action = action
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallGuildIconSyncGuildCmd(infos, dels) 
	local msg = GuildCmd_pb.GuildIconSyncGuildCmd()
	if( infos ~= nil )then
		for i=1,#infos do 
			table.insert(msg.infos, infos[i])
		end
	end
	if( dels ~= nil )then
		for i=1,#dels do 
			table.insert(msg.dels, dels[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallGuildIconAddGuildCmd(index, state, createtime, isdelete, type) 
	local msg = GuildCmd_pb.GuildIconAddGuildCmd()
	if(index ~= nil )then
		msg.index = index
	end
	if(state ~= nil )then
		msg.state = state
	end
	if(createtime ~= nil )then
		msg.createtime = createtime
	end
	if(isdelete ~= nil )then
		msg.isdelete = isdelete
	end
	if(type ~= nil )then
		msg.type = type
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallGuildIconUploadGuildCmd(index, policy, signature, type) 
	local msg = GuildCmd_pb.GuildIconUploadGuildCmd()
	if(index ~= nil )then
		msg.index = index
	end
	if(policy ~= nil )then
		msg.policy = policy
	end
	if(signature ~= nil )then
		msg.signature = signature
	end
	if(type ~= nil )then
		msg.type = type
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallOpenFunctionGuildCmd(func) 
	local msg = GuildCmd_pb.OpenFunctionGuildCmd()
	if(func ~= nil )then
		msg.func = func
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallBuildGuildCmd(building) 
	local msg = GuildCmd_pb.BuildGuildCmd()
	if(building ~= nil )then
		msg.building = building
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallSubmitMaterialGuildCmd(building, materialid, materials) 
	local msg = GuildCmd_pb.SubmitMaterialGuildCmd()
	if(building ~= nil )then
		msg.building = building
	end
	if(materialid ~= nil )then
		msg.materialid = materialid
	end
	if( materials ~= nil )then
		for i=1,#materials do 
			table.insert(msg.materials, materials[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallBuildingNtfGuildCmd(buildings) 
	local msg = GuildCmd_pb.BuildingNtfGuildCmd()
	if( buildings ~= nil )then
		for i=1,#buildings do 
			table.insert(msg.buildings, buildings[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallBuildingSubmitCountGuildCmd(type, count) 
	local msg = GuildCmd_pb.BuildingSubmitCountGuildCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(count ~= nil )then
		msg.count = count
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallChallengeUpdateNtfGuildCmd(updates, dels, refreshtime) 
	local msg = GuildCmd_pb.ChallengeUpdateNtfGuildCmd()
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
	if(refreshtime ~= nil )then
		msg.refreshtime = refreshtime
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallWelfareNtfGuildCmd(welfare) 
	local msg = GuildCmd_pb.WelfareNtfGuildCmd()
	if(welfare ~= nil )then
		msg.welfare = welfare
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallGetWelfareGuildCmd() 
	local msg = GuildCmd_pb.GetWelfareGuildCmd()
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallBuildingLvupEffGuildCmd(effects) 
	local msg = GuildCmd_pb.BuildingLvupEffGuildCmd()
	if( effects ~= nil )then
		for i=1,#effects do 
			table.insert(msg.effects, effects[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallArtifactUpdateNtfGuildCmd(itemupdates, itemdels, dataupdates) 
	local msg = GuildCmd_pb.ArtifactUpdateNtfGuildCmd()
	if( itemupdates ~= nil )then
		for i=1,#itemupdates do 
			table.insert(msg.itemupdates, itemupdates[i])
		end
	end
	if( itemdels ~= nil )then
		for i=1,#itemdels do 
			table.insert(msg.itemdels, itemdels[i])
		end
	end
	if( dataupdates ~= nil )then
		for i=1,#dataupdates do 
			table.insert(msg.dataupdates, dataupdates[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallArtifactProduceGuildCmd(id) 
	local msg = GuildCmd_pb.ArtifactProduceGuildCmd()
	if(id ~= nil )then
		msg.id = id
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallArtifactOptGuildCmd(opt, guid, charid) 
	local msg = GuildCmd_pb.ArtifactOptGuildCmd()
	if(opt ~= nil )then
		msg.opt = opt
	end
	if( guid ~= nil )then
		for i=1,#guid do 
			table.insert(msg.guid, guid[i])
		end
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallQueryGQuestGuildCmd(submit_quests) 
	local msg = GuildCmd_pb.QueryGQuestGuildCmd()
	if( submit_quests ~= nil )then
		for i=1,#submit_quests do 
			table.insert(msg.submit_quests, submit_quests[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallTreasureActionGuildCmd(charid, guild_treasure_count, bcoin_treasure_count, action, point, treasure) 
	local msg = GuildCmd_pb.TreasureActionGuildCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(guild_treasure_count ~= nil )then
		msg.guild_treasure_count = guild_treasure_count
	end
	if(bcoin_treasure_count ~= nil )then
		msg.bcoin_treasure_count = bcoin_treasure_count
	end
	if(action ~= nil )then
		msg.action = action
	end
	if(point ~= nil )then
		msg.point = point
	end
	if(treasure ~= nil )then
		if(treasure.id ~= nil )then
			msg.treasure.id = treasure.id
		end
	end
	if(treasure ~= nil )then
		if(treasure.count ~= nil )then
			msg.treasure.count = treasure.count
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallQueryBuildingRankGuildCmd(type, items) 
	local msg = GuildCmd_pb.QueryBuildingRankGuildCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallQueryTreasureResultGuildCmd(eventguid, result) 
	local msg = GuildCmd_pb.QueryTreasureResultGuildCmd()
	if(eventguid ~= nil )then
		msg.eventguid = eventguid
	end
	if(result ~= nil )then
		if(result.ownerid ~= nil )then
			msg.result.ownerid = result.ownerid
		end
	end
	if(result ~= nil )then
		if(result.eventguid ~= nil )then
			msg.result.eventguid = result.eventguid
		end
	end
	if(result ~= nil )then
		if(result.treasureid ~= nil )then
			msg.result.treasureid = result.treasureid
		end
	end
	if(result ~= nil )then
		if(result.totalmember ~= nil )then
			msg.result.totalmember = result.totalmember
		end
	end
	if(result ~= nil )then
		if(result.state ~= nil )then
			msg.result.state = result.state
		end
	end
	if(result ~= nil )then
		if(result.items ~= nil )then
			for i=1,#result.items do 
				table.insert(msg.result.items, result.items[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallQueryGCityShowInfoGuildCmd(infos) 
	local msg = GuildCmd_pb.QueryGCityShowInfoGuildCmd()
	if( infos ~= nil )then
		for i=1,#infos do 
			table.insert(msg.infos, infos[i])
		end
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallGvgOpenFireGuildCmd(fire) 
	local msg = GuildCmd_pb.GvgOpenFireGuildCmd()
	if(fire ~= nil )then
		msg.fire = fire
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallEnterPunishTimeNtfGuildCmd(exittime) 
	local msg = GuildCmd_pb.EnterPunishTimeNtfGuildCmd()
	if(exittime ~= nil )then
		msg.exittime = exittime
	end
	self:SendProto(msg)
end

function ServiceGuildCmdAutoProxy:CallOpenRealtimeVoiceGuildCmd(charid, open) 
	local msg = GuildCmd_pb.OpenRealtimeVoiceGuildCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(open ~= nil )then
		msg.open = open
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceGuildCmdAutoProxy:RecvQueryGuildListGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdQueryGuildListGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvCreateGuildGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdCreateGuildGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvEnterGuildGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdEnterGuildGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildMemberUpdateGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildApplyUpdateGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGuildApplyUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildDataUpdateGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildMemberDataUpdateGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvApplyGuildGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdApplyGuildGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvProcessApplyGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdProcessApplyGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvInviteMemberGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdInviteMemberGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvProcessInviteGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdProcessInviteGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvSetGuildOptionGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdSetGuildOptionGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvKickMemberGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdKickMemberGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvChangeJobGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdChangeJobGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExitGuildGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdExitGuildGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExchangeChairGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdExchangeChairGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDismissGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdDismissGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvLevelupGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdLevelupGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDonateGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdDonateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDonateListGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdDonateListGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvUpdateDonateItemGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdUpdateDonateItemGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDonateFrameGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdDonateFrameGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvEnterTerritoryGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdEnterTerritoryGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvPrayGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdPrayGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildInfoNtf(data) 
	self:Notify(ServiceEvent.GuildCmdGuildInfoNtf, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildPrayNtfGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGuildPrayNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvLevelupEffectGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdLevelupEffectGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryPackGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdQueryPackGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvPackUpdateGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdPackUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExchangeZoneGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdExchangeZoneGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExchangeZoneNtfGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdExchangeZoneNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExchangeZoneAnswerGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdExchangeZoneAnswerGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryEventListGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdQueryEventListGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvNewEventGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdNewEventGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvApplyRewardConGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdApplyRewardConGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvFrameStatusGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdFrameStatusGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvModifyAuthGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdModifyAuthGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvJobUpdateGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdJobUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvRenameQueryGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdRenameQueryGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryGuildCityInfoGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdQueryGuildCityInfoGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvCityActionGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdCityActionGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildIconSyncGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGuildIconSyncGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildIconAddGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGuildIconAddGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildIconUploadGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGuildIconUploadGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvOpenFunctionGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdOpenFunctionGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvBuildGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdBuildGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvSubmitMaterialGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdSubmitMaterialGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvBuildingNtfGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdBuildingNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvBuildingSubmitCountGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdBuildingSubmitCountGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvChallengeUpdateNtfGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdChallengeUpdateNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvWelfareNtfGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdWelfareNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGetWelfareGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGetWelfareGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvBuildingLvupEffGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdBuildingLvupEffGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvArtifactUpdateNtfGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvArtifactProduceGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdArtifactProduceGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvArtifactOptGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdArtifactOptGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryGQuestGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdQueryGQuestGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvTreasureActionGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdTreasureActionGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryBuildingRankGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdQueryBuildingRankGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryTreasureResultGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdQueryTreasureResultGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryGCityShowInfoGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdQueryGCityShowInfoGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgOpenFireGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGvgOpenFireGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvEnterPunishTimeNtfGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdEnterPunishTimeNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvOpenRealtimeVoiceGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdOpenRealtimeVoiceGuildCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.GuildCmdQueryGuildListGuildCmd = "ServiceEvent_GuildCmdQueryGuildListGuildCmd"
ServiceEvent.GuildCmdCreateGuildGuildCmd = "ServiceEvent_GuildCmdCreateGuildGuildCmd"
ServiceEvent.GuildCmdEnterGuildGuildCmd = "ServiceEvent_GuildCmdEnterGuildGuildCmd"
ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd = "ServiceEvent_GuildCmdGuildMemberUpdateGuildCmd"
ServiceEvent.GuildCmdGuildApplyUpdateGuildCmd = "ServiceEvent_GuildCmdGuildApplyUpdateGuildCmd"
ServiceEvent.GuildCmdGuildDataUpdateGuildCmd = "ServiceEvent_GuildCmdGuildDataUpdateGuildCmd"
ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd = "ServiceEvent_GuildCmdGuildMemberDataUpdateGuildCmd"
ServiceEvent.GuildCmdApplyGuildGuildCmd = "ServiceEvent_GuildCmdApplyGuildGuildCmd"
ServiceEvent.GuildCmdProcessApplyGuildCmd = "ServiceEvent_GuildCmdProcessApplyGuildCmd"
ServiceEvent.GuildCmdInviteMemberGuildCmd = "ServiceEvent_GuildCmdInviteMemberGuildCmd"
ServiceEvent.GuildCmdProcessInviteGuildCmd = "ServiceEvent_GuildCmdProcessInviteGuildCmd"
ServiceEvent.GuildCmdSetGuildOptionGuildCmd = "ServiceEvent_GuildCmdSetGuildOptionGuildCmd"
ServiceEvent.GuildCmdKickMemberGuildCmd = "ServiceEvent_GuildCmdKickMemberGuildCmd"
ServiceEvent.GuildCmdChangeJobGuildCmd = "ServiceEvent_GuildCmdChangeJobGuildCmd"
ServiceEvent.GuildCmdExitGuildGuildCmd = "ServiceEvent_GuildCmdExitGuildGuildCmd"
ServiceEvent.GuildCmdExchangeChairGuildCmd = "ServiceEvent_GuildCmdExchangeChairGuildCmd"
ServiceEvent.GuildCmdDismissGuildCmd = "ServiceEvent_GuildCmdDismissGuildCmd"
ServiceEvent.GuildCmdLevelupGuildCmd = "ServiceEvent_GuildCmdLevelupGuildCmd"
ServiceEvent.GuildCmdDonateGuildCmd = "ServiceEvent_GuildCmdDonateGuildCmd"
ServiceEvent.GuildCmdDonateListGuildCmd = "ServiceEvent_GuildCmdDonateListGuildCmd"
ServiceEvent.GuildCmdUpdateDonateItemGuildCmd = "ServiceEvent_GuildCmdUpdateDonateItemGuildCmd"
ServiceEvent.GuildCmdDonateFrameGuildCmd = "ServiceEvent_GuildCmdDonateFrameGuildCmd"
ServiceEvent.GuildCmdEnterTerritoryGuildCmd = "ServiceEvent_GuildCmdEnterTerritoryGuildCmd"
ServiceEvent.GuildCmdPrayGuildCmd = "ServiceEvent_GuildCmdPrayGuildCmd"
ServiceEvent.GuildCmdGuildInfoNtf = "ServiceEvent_GuildCmdGuildInfoNtf"
ServiceEvent.GuildCmdGuildPrayNtfGuildCmd = "ServiceEvent_GuildCmdGuildPrayNtfGuildCmd"
ServiceEvent.GuildCmdLevelupEffectGuildCmd = "ServiceEvent_GuildCmdLevelupEffectGuildCmd"
ServiceEvent.GuildCmdQueryPackGuildCmd = "ServiceEvent_GuildCmdQueryPackGuildCmd"
ServiceEvent.GuildCmdPackUpdateGuildCmd = "ServiceEvent_GuildCmdPackUpdateGuildCmd"
ServiceEvent.GuildCmdExchangeZoneGuildCmd = "ServiceEvent_GuildCmdExchangeZoneGuildCmd"
ServiceEvent.GuildCmdExchangeZoneNtfGuildCmd = "ServiceEvent_GuildCmdExchangeZoneNtfGuildCmd"
ServiceEvent.GuildCmdExchangeZoneAnswerGuildCmd = "ServiceEvent_GuildCmdExchangeZoneAnswerGuildCmd"
ServiceEvent.GuildCmdQueryEventListGuildCmd = "ServiceEvent_GuildCmdQueryEventListGuildCmd"
ServiceEvent.GuildCmdNewEventGuildCmd = "ServiceEvent_GuildCmdNewEventGuildCmd"
ServiceEvent.GuildCmdApplyRewardConGuildCmd = "ServiceEvent_GuildCmdApplyRewardConGuildCmd"
ServiceEvent.GuildCmdFrameStatusGuildCmd = "ServiceEvent_GuildCmdFrameStatusGuildCmd"
ServiceEvent.GuildCmdModifyAuthGuildCmd = "ServiceEvent_GuildCmdModifyAuthGuildCmd"
ServiceEvent.GuildCmdJobUpdateGuildCmd = "ServiceEvent_GuildCmdJobUpdateGuildCmd"
ServiceEvent.GuildCmdRenameQueryGuildCmd = "ServiceEvent_GuildCmdRenameQueryGuildCmd"
ServiceEvent.GuildCmdQueryGuildCityInfoGuildCmd = "ServiceEvent_GuildCmdQueryGuildCityInfoGuildCmd"
ServiceEvent.GuildCmdCityActionGuildCmd = "ServiceEvent_GuildCmdCityActionGuildCmd"
ServiceEvent.GuildCmdGuildIconSyncGuildCmd = "ServiceEvent_GuildCmdGuildIconSyncGuildCmd"
ServiceEvent.GuildCmdGuildIconAddGuildCmd = "ServiceEvent_GuildCmdGuildIconAddGuildCmd"
ServiceEvent.GuildCmdGuildIconUploadGuildCmd = "ServiceEvent_GuildCmdGuildIconUploadGuildCmd"
ServiceEvent.GuildCmdOpenFunctionGuildCmd = "ServiceEvent_GuildCmdOpenFunctionGuildCmd"
ServiceEvent.GuildCmdBuildGuildCmd = "ServiceEvent_GuildCmdBuildGuildCmd"
ServiceEvent.GuildCmdSubmitMaterialGuildCmd = "ServiceEvent_GuildCmdSubmitMaterialGuildCmd"
ServiceEvent.GuildCmdBuildingNtfGuildCmd = "ServiceEvent_GuildCmdBuildingNtfGuildCmd"
ServiceEvent.GuildCmdBuildingSubmitCountGuildCmd = "ServiceEvent_GuildCmdBuildingSubmitCountGuildCmd"
ServiceEvent.GuildCmdChallengeUpdateNtfGuildCmd = "ServiceEvent_GuildCmdChallengeUpdateNtfGuildCmd"
ServiceEvent.GuildCmdWelfareNtfGuildCmd = "ServiceEvent_GuildCmdWelfareNtfGuildCmd"
ServiceEvent.GuildCmdGetWelfareGuildCmd = "ServiceEvent_GuildCmdGetWelfareGuildCmd"
ServiceEvent.GuildCmdBuildingLvupEffGuildCmd = "ServiceEvent_GuildCmdBuildingLvupEffGuildCmd"
ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd = "ServiceEvent_GuildCmdArtifactUpdateNtfGuildCmd"
ServiceEvent.GuildCmdArtifactProduceGuildCmd = "ServiceEvent_GuildCmdArtifactProduceGuildCmd"
ServiceEvent.GuildCmdArtifactOptGuildCmd = "ServiceEvent_GuildCmdArtifactOptGuildCmd"
ServiceEvent.GuildCmdQueryGQuestGuildCmd = "ServiceEvent_GuildCmdQueryGQuestGuildCmd"
ServiceEvent.GuildCmdTreasureActionGuildCmd = "ServiceEvent_GuildCmdTreasureActionGuildCmd"
ServiceEvent.GuildCmdQueryBuildingRankGuildCmd = "ServiceEvent_GuildCmdQueryBuildingRankGuildCmd"
ServiceEvent.GuildCmdQueryTreasureResultGuildCmd = "ServiceEvent_GuildCmdQueryTreasureResultGuildCmd"
ServiceEvent.GuildCmdQueryGCityShowInfoGuildCmd = "ServiceEvent_GuildCmdQueryGCityShowInfoGuildCmd"
ServiceEvent.GuildCmdGvgOpenFireGuildCmd = "ServiceEvent_GuildCmdGvgOpenFireGuildCmd"
ServiceEvent.GuildCmdEnterPunishTimeNtfGuildCmd = "ServiceEvent_GuildCmdEnterPunishTimeNtfGuildCmd"
ServiceEvent.GuildCmdOpenRealtimeVoiceGuildCmd = "ServiceEvent_GuildCmdOpenRealtimeVoiceGuildCmd"
