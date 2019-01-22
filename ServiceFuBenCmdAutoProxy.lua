ServiceFuBenCmdAutoProxy = class('ServiceFuBenCmdAutoProxy', ServiceProxy)

ServiceFuBenCmdAutoProxy.Instance = nil

ServiceFuBenCmdAutoProxy.NAME = 'ServiceFuBenCmdAutoProxy'

function ServiceFuBenCmdAutoProxy:ctor(proxyName)
	if ServiceFuBenCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceFuBenCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceFuBenCmdAutoProxy.Instance = self
	end
end

function ServiceFuBenCmdAutoProxy:Init()
end

function ServiceFuBenCmdAutoProxy:onRegister()
	self:Listen(11, 1, function (data)
		self:RecvTrackFuBenUserCmd(data) 
	end)
	self:Listen(11, 2, function (data)
		self:RecvFailFuBenUserCmd(data) 
	end)
	self:Listen(11, 3, function (data)
		self:RecvLeaveFuBenUserCmd(data) 
	end)
	self:Listen(11, 4, function (data)
		self:RecvSuccessFuBenUserCmd(data) 
	end)
	self:Listen(11, 5, function (data)
		self:RecvWorldStageUserCmd(data) 
	end)
	self:Listen(11, 6, function (data)
		self:RecvStageStepUserCmd(data) 
	end)
	self:Listen(11, 7, function (data)
		self:RecvStartStageUserCmd(data) 
	end)
	self:Listen(11, 8, function (data)
		self:RecvGetRewardStageUserCmd(data) 
	end)
	self:Listen(11, 9, function (data)
		self:RecvStageStepStarUserCmd(data) 
	end)
	self:Listen(11, 11, function (data)
		self:RecvMonsterCountUserCmd(data) 
	end)
	self:Listen(11, 12, function (data)
		self:RecvFubenStepSyncCmd(data) 
	end)
	self:Listen(11, 13, function (data)
		self:RecvFuBenProgressSyncCmd(data) 
	end)
	self:Listen(11, 15, function (data)
		self:RecvFuBenClearInfoCmd(data) 
	end)
	self:Listen(11, 16, function (data)
		self:RecvUserGuildRaidFubenCmd(data) 
	end)
	self:Listen(11, 17, function (data)
		self:RecvGuildGateOptCmd(data) 
	end)
	self:Listen(11, 18, function (data)
		self:RecvGuildFireInfoFubenCmd(data) 
	end)
	self:Listen(11, 19, function (data)
		self:RecvGuildFireStopFubenCmd(data) 
	end)
	self:Listen(11, 20, function (data)
		self:RecvGuildFireDangerFubenCmd(data) 
	end)
	self:Listen(11, 21, function (data)
		self:RecvGuildFireMetalHpFubenCmd(data) 
	end)
	self:Listen(11, 22, function (data)
		self:RecvGuildFireCalmFubenCmd(data) 
	end)
	self:Listen(11, 23, function (data)
		self:RecvGuildFireNewDefFubenCmd(data) 
	end)
	self:Listen(11, 24, function (data)
		self:RecvGuildFireRestartFubenCmd(data) 
	end)
	self:Listen(11, 25, function (data)
		self:RecvGuildFireStatusFubenCmd(data) 
	end)
	self:Listen(11, 26, function (data)
		self:RecvGvgDataSyncCmd(data) 
	end)
	self:Listen(11, 27, function (data)
		self:RecvGvgDataUpdateCmd(data) 
	end)
	self:Listen(11, 28, function (data)
		self:RecvGvgDefNameChangeFubenCmd(data) 
	end)
	self:Listen(11, 29, function (data)
		self:RecvSyncMvpInfoFubenCmd(data) 
	end)
	self:Listen(11, 30, function (data)
		self:RecvBossDieFubenCmd(data) 
	end)
	self:Listen(11, 31, function (data)
		self:RecvUpdateUserNumFubenCmd(data) 
	end)
	self:Listen(11, 32, function (data)
		self:RecvSuperGvgSyncFubenCmd(data) 
	end)
	self:Listen(11, 33, function (data)
		self:RecvGvgTowerUpdateFubenCmd(data) 
	end)
	self:Listen(11, 39, function (data)
		self:RecvGvgMetalDieFubenCmd(data) 
	end)
	self:Listen(11, 34, function (data)
		self:RecvGvgCrystalUpdateFubenCmd(data) 
	end)
	self:Listen(11, 35, function (data)
		self:RecvQueryGvgTowerInfoFubenCmd(data) 
	end)
	self:Listen(11, 36, function (data)
		self:RecvSuperGvgRewardInfoFubenCmd(data) 
	end)
	self:Listen(11, 37, function (data)
		self:RecvSuperGvgQueryUserDataFubenCmd(data) 
	end)
	self:Listen(11, 38, function (data)
		self:RecvMvpBattleReportFubenCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceFuBenCmdAutoProxy:CallTrackFuBenUserCmd(data, dmapid, endtime) 
	local msg = FuBenCmd_pb.TrackFuBenUserCmd()
	if( data ~= nil )then
		for i=1,#data do 
			table.insert(msg.data, data[i])
		end
	end
	if(dmapid ~= nil )then
		msg.dmapid = dmapid
	end
	if(endtime ~= nil )then
		msg.endtime = endtime
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallFailFuBenUserCmd() 
	local msg = FuBenCmd_pb.FailFuBenUserCmd()
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallLeaveFuBenUserCmd(mapid) 
	local msg = FuBenCmd_pb.LeaveFuBenUserCmd()
	if(mapid ~= nil )then
		msg.mapid = mapid
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallSuccessFuBenUserCmd(type, param1, param2, param3, param4) 
	local msg = FuBenCmd_pb.SuccessFuBenUserCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(param1 ~= nil )then
		msg.param1 = param1
	end
	if(param2 ~= nil )then
		msg.param2 = param2
	end
	if(param3 ~= nil )then
		msg.param3 = param3
	end
	if(param4 ~= nil )then
		msg.param4 = param4
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallWorldStageUserCmd(list, curinfo) 
	local msg = FuBenCmd_pb.WorldStageUserCmd()
	if( list ~= nil )then
		for i=1,#list do 
			table.insert(msg.list, list[i])
		end
	end
	if( curinfo ~= nil )then
		for i=1,#curinfo do 
			table.insert(msg.curinfo, curinfo[i])
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallStageStepUserCmd(stageid, normalist, hardlist) 
	local msg = FuBenCmd_pb.StageStepUserCmd()
	if(stageid ~= nil )then
		msg.stageid = stageid
	end
	if( normalist ~= nil )then
		for i=1,#normalist do 
			table.insert(msg.normalist, normalist[i])
		end
	end
	if( hardlist ~= nil )then
		for i=1,#hardlist do 
			table.insert(msg.hardlist, hardlist[i])
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallStartStageUserCmd(stageid, stepid, type) 
	local msg = FuBenCmd_pb.StartStageUserCmd()
	if(stageid ~= nil )then
		msg.stageid = stageid
	end
	if(stepid ~= nil )then
		msg.stepid = stepid
	end
	if(type ~= nil )then
		msg.type = type
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGetRewardStageUserCmd(stageid, starid) 
	local msg = FuBenCmd_pb.GetRewardStageUserCmd()
	if(stageid ~= nil )then
		msg.stageid = stageid
	end
	if(starid ~= nil )then
		msg.starid = starid
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallStageStepStarUserCmd(stageid, stepid, star, type) 
	local msg = FuBenCmd_pb.StageStepStarUserCmd()
	if(stageid ~= nil )then
		msg.stageid = stageid
	end
	if(stepid ~= nil )then
		msg.stepid = stepid
	end
	if(star ~= nil )then
		msg.star = star
	end
	if(type ~= nil )then
		msg.type = type
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallMonsterCountUserCmd(num) 
	local msg = FuBenCmd_pb.MonsterCountUserCmd()
	if(num ~= nil )then
		msg.num = num
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallFubenStepSyncCmd(id, del, config) 
	local msg = FuBenCmd_pb.FubenStepSyncCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(del ~= nil )then
		msg.del = del
	end
	if(config ~= nil )then
		if(config.RaidID ~= nil )then
			msg.config.RaidID = config.RaidID
		end
	end
	if(config ~= nil )then
		if(config.starID ~= nil )then
			msg.config.starID = config.starID
		end
	end
	if(config ~= nil )then
		if(config.Auto ~= nil )then
			msg.config.Auto = config.Auto
		end
	end
	if(config ~= nil )then
		if(config.WhetherTrace ~= nil )then
			msg.config.WhetherTrace = config.WhetherTrace
		end
	end
	if(config ~= nil )then
		if(config.DescInfo ~= nil )then
			msg.config.DescInfo = config.DescInfo
		end
	end
	if(config ~= nil )then
		if(config.Content ~= nil )then
			msg.config.Content = config.Content
		end
	end
	if(config ~= nil )then
		if(config.TraceInfo ~= nil )then
			msg.config.TraceInfo = config.TraceInfo
		end
	end
	if(config ~= nil )then
		if(config.params.params ~= nil )then
			for i=1,#config.params.params do 
				table.insert(msg.config.params.params, config.params.params[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallFuBenProgressSyncCmd(id, progress) 
	local msg = FuBenCmd_pb.FuBenProgressSyncCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(progress ~= nil )then
		msg.progress = progress
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallFuBenClearInfoCmd() 
	local msg = FuBenCmd_pb.FuBenClearInfoCmd()
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallUserGuildRaidFubenCmd(gatedata) 
	local msg = FuBenCmd_pb.UserGuildRaidFubenCmd()
	if( gatedata ~= nil )then
		for i=1,#gatedata do 
			table.insert(msg.gatedata, gatedata[i])
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGuildGateOptCmd(gatenpcid, opt, uplocklevel) 
	local msg = FuBenCmd_pb.GuildGateOptCmd()
	if(gatenpcid ~= nil )then
		msg.gatenpcid = gatenpcid
	end
	if(opt ~= nil )then
		msg.opt = opt
	end
	if(uplocklevel ~= nil )then
		msg.uplocklevel = uplocklevel
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGuildFireInfoFubenCmd(fire, def_guildid, endfire_time, danger, danger_time, metal_hpper, calmdown, calm_time, def_guildname, def_perfect) 
	local msg = FuBenCmd_pb.GuildFireInfoFubenCmd()
	if(fire ~= nil )then
		msg.fire = fire
	end
	if(def_guildid ~= nil )then
		msg.def_guildid = def_guildid
	end
	if(endfire_time ~= nil )then
		msg.endfire_time = endfire_time
	end
	if(danger ~= nil )then
		msg.danger = danger
	end
	if(danger_time ~= nil )then
		msg.danger_time = danger_time
	end
	if(metal_hpper ~= nil )then
		msg.metal_hpper = metal_hpper
	end
	if(calmdown ~= nil )then
		msg.calmdown = calmdown
	end
	if(calm_time ~= nil )then
		msg.calm_time = calm_time
	end
	if(def_guildname ~= nil )then
		msg.def_guildname = def_guildname
	end
	if(def_perfect ~= nil )then
		msg.def_perfect = def_perfect
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGuildFireStopFubenCmd(result) 
	local msg = FuBenCmd_pb.GuildFireStopFubenCmd()
	msg.result = result
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGuildFireDangerFubenCmd(danger, danger_time) 
	local msg = FuBenCmd_pb.GuildFireDangerFubenCmd()
	if(danger ~= nil )then
		msg.danger = danger
	end
	if(danger_time ~= nil )then
		msg.danger_time = danger_time
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGuildFireMetalHpFubenCmd(hpper) 
	local msg = FuBenCmd_pb.GuildFireMetalHpFubenCmd()
	if(hpper ~= nil )then
		msg.hpper = hpper
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGuildFireCalmFubenCmd(calm) 
	local msg = FuBenCmd_pb.GuildFireCalmFubenCmd()
	if(calm ~= nil )then
		msg.calm = calm
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGuildFireNewDefFubenCmd(guildid, guildname) 
	local msg = FuBenCmd_pb.GuildFireNewDefFubenCmd()
	if(guildid ~= nil )then
		msg.guildid = guildid
	end
	if(guildname ~= nil )then
		msg.guildname = guildname
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGuildFireRestartFubenCmd() 
	local msg = FuBenCmd_pb.GuildFireRestartFubenCmd()
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGuildFireStatusFubenCmd(open, starttime, cityid, cityopen) 
	local msg = FuBenCmd_pb.GuildFireStatusFubenCmd()
	if(open ~= nil )then
		msg.open = open
	end
	if(starttime ~= nil )then
		msg.starttime = starttime
	end
	msg.cityid = cityid
	if(cityopen ~= nil )then
		msg.cityopen = cityopen
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGvgDataSyncCmd(datas) 
	local msg = FuBenCmd_pb.GvgDataSyncCmd()
	if( datas ~= nil )then
		for i=1,#datas do 
			table.insert(msg.datas, datas[i])
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGvgDataUpdateCmd(data) 
	local msg = FuBenCmd_pb.GvgDataUpdateCmd()
	if(data ~= nil )then
		if(data.type ~= nil )then
			msg.data.type = data.type
		end
	end
	if(data ~= nil )then
		if(data.value ~= nil )then
			msg.data.value = data.value
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGvgDefNameChangeFubenCmd(newname) 
	local msg = FuBenCmd_pb.GvgDefNameChangeFubenCmd()
	msg.newname = newname
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallSyncMvpInfoFubenCmd(usernum, liveboss, dieboss) 
	local msg = FuBenCmd_pb.SyncMvpInfoFubenCmd()
	if(usernum ~= nil )then
		msg.usernum = usernum
	end
	if( liveboss ~= nil )then
		for i=1,#liveboss do 
			table.insert(msg.liveboss, liveboss[i])
		end
	end
	if( dieboss ~= nil )then
		for i=1,#dieboss do 
			table.insert(msg.dieboss, dieboss[i])
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallBossDieFubenCmd(npcid) 
	local msg = FuBenCmd_pb.BossDieFubenCmd()
	msg.npcid = npcid
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallUpdateUserNumFubenCmd(usernum) 
	local msg = FuBenCmd_pb.UpdateUserNumFubenCmd()
	if(usernum ~= nil )then
		msg.usernum = usernum
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallSuperGvgSyncFubenCmd(towers, guildinfo, firebegintime) 
	local msg = FuBenCmd_pb.SuperGvgSyncFubenCmd()
	if( towers ~= nil )then
		for i=1,#towers do 
			table.insert(msg.towers, towers[i])
		end
	end
	if( guildinfo ~= nil )then
		for i=1,#guildinfo do 
			table.insert(msg.guildinfo, guildinfo[i])
		end
	end
	if(firebegintime ~= nil )then
		msg.firebegintime = firebegintime
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGvgTowerUpdateFubenCmd(towers) 
	local msg = FuBenCmd_pb.GvgTowerUpdateFubenCmd()
	if( towers ~= nil )then
		for i=1,#towers do 
			table.insert(msg.towers, towers[i])
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGvgMetalDieFubenCmd(index) 
	local msg = FuBenCmd_pb.GvgMetalDieFubenCmd()
	if(index ~= nil )then
		msg.index = index
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallGvgCrystalUpdateFubenCmd(crystals) 
	local msg = FuBenCmd_pb.GvgCrystalUpdateFubenCmd()
	if( crystals ~= nil )then
		for i=1,#crystals do 
			table.insert(msg.crystals, crystals[i])
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallQueryGvgTowerInfoFubenCmd(etype, open) 
	local msg = FuBenCmd_pb.QueryGvgTowerInfoFubenCmd()
	msg.etype = etype
	if(open ~= nil )then
		msg.open = open
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallSuperGvgRewardInfoFubenCmd(rewardinfo) 
	local msg = FuBenCmd_pb.SuperGvgRewardInfoFubenCmd()
	if( rewardinfo ~= nil )then
		for i=1,#rewardinfo do 
			table.insert(msg.rewardinfo, rewardinfo[i])
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallSuperGvgQueryUserDataFubenCmd(guilduserdata) 
	local msg = FuBenCmd_pb.SuperGvgQueryUserDataFubenCmd()
	if( guilduserdata ~= nil )then
		for i=1,#guilduserdata do 
			table.insert(msg.guilduserdata, guilduserdata[i])
		end
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdAutoProxy:CallMvpBattleReportFubenCmd(datas) 
	local msg = FuBenCmd_pb.MvpBattleReportFubenCmd()
	if( datas ~= nil )then
		for i=1,#datas do 
			table.insert(msg.datas, datas[i])
		end
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceFuBenCmdAutoProxy:RecvTrackFuBenUserCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdTrackFuBenUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFailFuBenUserCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdFailFuBenUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvLeaveFuBenUserCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdLeaveFuBenUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSuccessFuBenUserCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdSuccessFuBenUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvWorldStageUserCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdWorldStageUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvStageStepUserCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdStageStepUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvStartStageUserCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdStartStageUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGetRewardStageUserCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGetRewardStageUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvStageStepStarUserCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdStageStepStarUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvMonsterCountUserCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdMonsterCountUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFubenStepSyncCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdFubenStepSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFuBenProgressSyncCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdFuBenProgressSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFuBenClearInfoCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdFuBenClearInfoCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvUserGuildRaidFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdUserGuildRaidFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildGateOptCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGuildGateOptCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireInfoFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGuildFireInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireStopFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGuildFireStopFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireDangerFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGuildFireDangerFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireMetalHpFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGuildFireMetalHpFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireCalmFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGuildFireCalmFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireNewDefFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGuildFireNewDefFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireRestartFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGuildFireRestartFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireStatusFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGuildFireStatusFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgDataSyncCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGvgDataSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgDataUpdateCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGvgDataUpdateCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgDefNameChangeFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGvgDefNameChangeFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncMvpInfoFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdSyncMvpInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvBossDieFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdBossDieFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvUpdateUserNumFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdUpdateUserNumFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSuperGvgSyncFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdSuperGvgSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgTowerUpdateFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgMetalDieFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGvgMetalDieFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgCrystalUpdateFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvQueryGvgTowerInfoFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdQueryGvgTowerInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSuperGvgRewardInfoFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdSuperGvgRewardInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSuperGvgQueryUserDataFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdSuperGvgQueryUserDataFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvMvpBattleReportFubenCmd(data) 
	self:Notify(ServiceEvent.FuBenCmdMvpBattleReportFubenCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.FuBenCmdTrackFuBenUserCmd = "ServiceEvent_FuBenCmdTrackFuBenUserCmd"
ServiceEvent.FuBenCmdFailFuBenUserCmd = "ServiceEvent_FuBenCmdFailFuBenUserCmd"
ServiceEvent.FuBenCmdLeaveFuBenUserCmd = "ServiceEvent_FuBenCmdLeaveFuBenUserCmd"
ServiceEvent.FuBenCmdSuccessFuBenUserCmd = "ServiceEvent_FuBenCmdSuccessFuBenUserCmd"
ServiceEvent.FuBenCmdWorldStageUserCmd = "ServiceEvent_FuBenCmdWorldStageUserCmd"
ServiceEvent.FuBenCmdStageStepUserCmd = "ServiceEvent_FuBenCmdStageStepUserCmd"
ServiceEvent.FuBenCmdStartStageUserCmd = "ServiceEvent_FuBenCmdStartStageUserCmd"
ServiceEvent.FuBenCmdGetRewardStageUserCmd = "ServiceEvent_FuBenCmdGetRewardStageUserCmd"
ServiceEvent.FuBenCmdStageStepStarUserCmd = "ServiceEvent_FuBenCmdStageStepStarUserCmd"
ServiceEvent.FuBenCmdMonsterCountUserCmd = "ServiceEvent_FuBenCmdMonsterCountUserCmd"
ServiceEvent.FuBenCmdFubenStepSyncCmd = "ServiceEvent_FuBenCmdFubenStepSyncCmd"
ServiceEvent.FuBenCmdFuBenProgressSyncCmd = "ServiceEvent_FuBenCmdFuBenProgressSyncCmd"
ServiceEvent.FuBenCmdFuBenClearInfoCmd = "ServiceEvent_FuBenCmdFuBenClearInfoCmd"
ServiceEvent.FuBenCmdUserGuildRaidFubenCmd = "ServiceEvent_FuBenCmdUserGuildRaidFubenCmd"
ServiceEvent.FuBenCmdGuildGateOptCmd = "ServiceEvent_FuBenCmdGuildGateOptCmd"
ServiceEvent.FuBenCmdGuildFireInfoFubenCmd = "ServiceEvent_FuBenCmdGuildFireInfoFubenCmd"
ServiceEvent.FuBenCmdGuildFireStopFubenCmd = "ServiceEvent_FuBenCmdGuildFireStopFubenCmd"
ServiceEvent.FuBenCmdGuildFireDangerFubenCmd = "ServiceEvent_FuBenCmdGuildFireDangerFubenCmd"
ServiceEvent.FuBenCmdGuildFireMetalHpFubenCmd = "ServiceEvent_FuBenCmdGuildFireMetalHpFubenCmd"
ServiceEvent.FuBenCmdGuildFireCalmFubenCmd = "ServiceEvent_FuBenCmdGuildFireCalmFubenCmd"
ServiceEvent.FuBenCmdGuildFireNewDefFubenCmd = "ServiceEvent_FuBenCmdGuildFireNewDefFubenCmd"
ServiceEvent.FuBenCmdGuildFireRestartFubenCmd = "ServiceEvent_FuBenCmdGuildFireRestartFubenCmd"
ServiceEvent.FuBenCmdGuildFireStatusFubenCmd = "ServiceEvent_FuBenCmdGuildFireStatusFubenCmd"
ServiceEvent.FuBenCmdGvgDataSyncCmd = "ServiceEvent_FuBenCmdGvgDataSyncCmd"
ServiceEvent.FuBenCmdGvgDataUpdateCmd = "ServiceEvent_FuBenCmdGvgDataUpdateCmd"
ServiceEvent.FuBenCmdGvgDefNameChangeFubenCmd = "ServiceEvent_FuBenCmdGvgDefNameChangeFubenCmd"
ServiceEvent.FuBenCmdSyncMvpInfoFubenCmd = "ServiceEvent_FuBenCmdSyncMvpInfoFubenCmd"
ServiceEvent.FuBenCmdBossDieFubenCmd = "ServiceEvent_FuBenCmdBossDieFubenCmd"
ServiceEvent.FuBenCmdUpdateUserNumFubenCmd = "ServiceEvent_FuBenCmdUpdateUserNumFubenCmd"
ServiceEvent.FuBenCmdSuperGvgSyncFubenCmd = "ServiceEvent_FuBenCmdSuperGvgSyncFubenCmd"
ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd = "ServiceEvent_FuBenCmdGvgTowerUpdateFubenCmd"
ServiceEvent.FuBenCmdGvgMetalDieFubenCmd = "ServiceEvent_FuBenCmdGvgMetalDieFubenCmd"
ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd = "ServiceEvent_FuBenCmdGvgCrystalUpdateFubenCmd"
ServiceEvent.FuBenCmdQueryGvgTowerInfoFubenCmd = "ServiceEvent_FuBenCmdQueryGvgTowerInfoFubenCmd"
ServiceEvent.FuBenCmdSuperGvgRewardInfoFubenCmd = "ServiceEvent_FuBenCmdSuperGvgRewardInfoFubenCmd"
ServiceEvent.FuBenCmdSuperGvgQueryUserDataFubenCmd = "ServiceEvent_FuBenCmdSuperGvgQueryUserDataFubenCmd"
ServiceEvent.FuBenCmdMvpBattleReportFubenCmd = "ServiceEvent_FuBenCmdMvpBattleReportFubenCmd"
