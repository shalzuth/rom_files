autoImport('ServiceFuBenCmdAutoProxy')
ServiceFuBenCmdProxy = class('ServiceFuBenCmdProxy', ServiceFuBenCmdAutoProxy)
ServiceFuBenCmdProxy.Instance = nil
ServiceFuBenCmdProxy.NAME = 'ServiceFuBenCmdProxy'

function ServiceFuBenCmdProxy:ctor(proxyName)
	if ServiceFuBenCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceFuBenCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceFuBenCmdProxy.Instance = self
	end
end

function ServiceFuBenCmdProxy:CallStartStageUserCmd(subStageData)
	
	local msg = FuBenCmd_pb.StartStageUserCmd()
	if(subStageData ~= nil )then
		msg.stageid = subStageData.mainStage.id
		msg.stepid = subStageData.staticData.Step
		msg.type = subStageData.type
	end
	self:SendProto(msg)
end

function ServiceFuBenCmdProxy:RecvWorldStageUserCmd(data) 
	DungeonProxy.Instance:InitMainStageInfo(data.list)
	local info = nil
	for i=1,#data.curinfo do
		info = data.curinfo[i]
		if(info.type==SubStageData.NormalType) then
			DungeonProxy.Instance:SetNormalStageProgress(info.stageid,info.stepid)
		end
	end
	self:Notify(ServiceEvent.FuBenCmdWorldStageUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvStageStepUserCmd(data) 
	DungeonProxy.Instance:UpdateMainStageSubs(data)
	self:Notify(ServiceEvent.FuBenCmdStageStepUserCmd, DungeonProxy.Instance:GetMainStage(data.stageid))
end

function ServiceFuBenCmdProxy:RecvStageStepStarUserCmd(data)
	DungeonProxy.Instance:UpdateMainStageInfo(data)
	self:Notify(ServiceEvent.FuBenCmdStageStepStarUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvGetRewardStageUserCmd(data) 
	-- print("get fuben reward.."..data.stageid.." "..data.stageid)
	DungeonProxy.Instance:GetReward(data.stageid,data.starid)
	self:Notify(ServiceEvent.FuBenCmdGetRewardStageUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvMonsterCountUserCmd(data) 
	-- printGreen("RecvMonsterCountUserCmd --> "..tostring(data.num));
	self:Notify(ServiceEvent.FuBenCmdMonsterCountUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvSuccessFuBenUserCmd(data) 
	helplog("Recv-->SuccessFuBenUserCmd", data.param1, data.param2, data.param3, data.param4);
	FunctionDungen.Me():DungenBattleSuccess( data )
	self:Notify(ServiceEvent.FuBenCmdSuccessFuBenUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvCountdownUserCmd(data)
	-- printRed("RecvCountdownUserCmd~~~~~~~~~~~~")
	DojoProxy.Instance:RecvCountdownUserCmd(data)
	self:Notify(ServiceEvent.FuBenCmdCountdownUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvFubenStepSyncCmd(data)
	-- helplog("Recv-->FubenStepSyncCmd", data.id, tostring(data.del));
	QuestProxy.Instance:updateFubenQuestData( data.id, data.del, data.config )
	self:Notify(ServiceEvent.FuBenCmdFubenStepSyncCmd, data)
end

function ServiceFuBenCmdProxy:RecvFuBenClearInfoCmd(data) 
	-- helplog("Recv-->FuBenClearInfoCmd");
	QuestProxy.Instance:clearFubenQuestData();
	self:Notify(ServiceEvent.RecvFuBenClearInfoCmd, data)
end

function ServiceFuBenCmdProxy:CallGuildGateOptCmd(gatenpcid, opt, uplocklevel)
	helplog("ServiceFuBenCmdProxy Call-->GuildGateOptCmd", gatenpcid, opt, uplocklevel);
	ServiceFuBenCmdProxy.super.CallGuildGateOptCmd(self, gatenpcid, opt, uplocklevel);
end

function ServiceFuBenCmdProxy:RecvUserGuildRaidFubenCmd(data) 
	helplog("ServiceFuBenCmdProxy Recv-->UserGuildRaidFubenCmd");
	GuildProxy.Instance:SetGuildGateInfo(data.gatedata);
	self:Notify(ServiceEvent.FuBenCmdUserGuildRaidFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireInfoFubenCmd(data)
	local currentDungeon = Game.DungeonManager.currentDungeon
	if(currentDungeon ~= nil and currentDungeon.SetCalmDown ~= nil) then
		if(data.fire == false) then
			currentDungeon:SetCalmDown(true)
		else
			currentDungeon:SetCalmDown(data.calmdown)
		end
	end
	GvgProxy.Instance:RecvGuildFireInfoFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGuildFireInfoFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireCalmFubenCmd(data)
	local currentDungeon = Game.DungeonManager.currentDungeon
	if(currentDungeon ~= nil and currentDungeon.SetCalmDown ~= nil) then
		currentDungeon:SetCalmDown(data.calm)
	end
	self:Notify(ServiceEvent.FuBenCmdGuildFireCalmFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireRestartFubenCmd(data)
	GvgProxy.Instance:RecvGuildFireRestartFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGuildFireRestartFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireStopFubenCmd(data)
	GvgProxy.Instance:RecvGuildFireStopFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGuildFireStopFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireDangerFubenCmd(data)
	GvgProxy.Instance:RecvGuildFireDangerFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGuildFireDangerFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireMetalHpFubenCmd(data)
	GvgProxy.Instance:RecvGuildFireMetalHpFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGuildFireMetalHpFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireNewDefFubenCmd(data)
	GvgProxy.Instance:RecvGuildFireNewDefFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGuildFireNewDefFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireStatusFubenCmd(data)
	GvgProxy.Instance:SetGvgOpenTime(data.open, data.starttime);
	self:Notify(ServiceEvent.FuBenCmdGuildFireStatusFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgDataSyncCmd(data) 
	GvgProxy.Instance:RecvGvgDataSyncCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGvgDataSyncCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgDataUpdateCmd(data) 
	GvgProxy.Instance:RecvGvgDataUpdateCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGvgDataUpdateCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgDefNameChangeFubenCmd(data)
	GvgProxy.Instance:RecvGvgDefNameChangeFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGvgDefNameChangeFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvBossDieFubenCmd(data) 
	PvpProxy.Instance:RecvBossDieFubenCmd(data);
	self:Notify(ServiceEvent.FuBenCmdBossDieFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvUpdateUserNumFubenCmd(data) 
	PvpProxy.Instance:RecvUpdateUserNumFubenCmd(data);
	self:Notify(ServiceEvent.FuBenCmdUpdateUserNumFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncMvpInfoFubenCmd(data) 
	PvpProxy.Instance:RecvSyncMvpInfoFubenCmd(data);
	self:Notify(ServiceEvent.FuBenCmdSyncMvpInfoFubenCmd, data)
end

--superGvg
function ServiceFuBenCmdProxy:RecvSuperGvgSyncFubenCmd(data) 
	-- helplog("===RecvSuperGvgSyncFubenCmd===>>>")
	-- TableUtil.Print(data)
	SuperGvgProxy.Instance:HandleRecvSuperGvgSyncFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdSuperGvgSyncFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgTowerUpdateFubenCmd(data) 
	-- helplog("===RecvGvgTowerUpdateFubenCmd===>>>")
	-- TableUtil.Print(data)
	SuperGvgProxy.Instance:HandleRecvGvgTowerUpdateFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, data)
	EventManager.Me():DispatchEvent(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgMetalDieFubenCmd(data) 
	-- helplog("===RecvGvgMetalDieFubenCmd===>>>")
	-- TableUtil.Print(data)
	SuperGvgProxy.Instance:HandleRecvGvgMetalDieFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGvgMetalDieFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgCrystalUpdateFubenCmd(data) 
	-- helplog("===RecvGvgCrystalUpdateFubenCmd===>>>")
	-- TableUtil.Print(data)
	SuperGvgProxy.Instance:HandleRecvGvgCrystalUpdateFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, data)
	EventManager.Me():DispatchEvent(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvQueryGvgTowerInfoFubenCmd(data) 
	-- helplog("===RecvQueryGvgTowerInfoFubenCmd===>>>")
	-- TableUtil.Print(data)
	SuperGvgProxy.Instance:HandleRecvQueryGvgTowerInfoFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdQueryGvgTowerInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSuperGvgRewardInfoFubenCmd(data) 
	-- helplog("===RecvSuperGvgRewardInfoFubenCmd===>>>")
	-- TableUtil.Print(data)
	GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "GVGResultView", rewardInfo = data.rewardinfo})
end

function ServiceFuBenCmdAutoProxy:RecvSuperGvgQueryUserDataFubenCmd(data) 
	-- helplog("===RecvSuperGvgQueryUserDataFubenCmd===>>>")
	-- TableUtil.Print(data)
	SuperGvgProxy.Instance:HandleRecvGvgUserDetailFubenCmd(data)
	self:Notify(ServiceEvent.FuBenCmdSuperGvgQueryUserDataFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvMvpBattleReportFubenCmd(data) 
	PvpProxy.Instance:RecvMvpBattleReportFubenCmd(data)
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.MVPResultView})
	self:Notify(ServiceEvent.FuBenCmdMvpBattleReportFubenCmd, data)
end