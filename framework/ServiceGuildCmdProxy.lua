autoImport('ServiceGuildCmdAutoProxy')
ServiceGuildCmdProxy = class('ServiceGuildCmdProxy', ServiceGuildCmdAutoProxy)
ServiceGuildCmdProxy.Instance = nil
ServiceGuildCmdProxy.NAME = 'ServiceGuildCmdProxy'

function ServiceGuildCmdProxy:ctor(proxyName)
	if ServiceGuildCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceGuildCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceGuildCmdProxy.Instance = self
	end
end

function ServiceGuildCmdProxy:CallQueryGuildListGuildCmd(keyword, page, list) 
	-- printGreen("Call-->QueryGuildListGuildCmd", keyword, page);
	ServiceGuildCmdProxy.super.CallQueryGuildListGuildCmd(self, keyword, page, list);
end

function ServiceGuildCmdProxy:CallCreateGuildGuildCmd(name)
	-- printGreen("Call-->CreateGuildGuildCmd", name);
	ServiceGuildCmdProxy.super.CallCreateGuildGuildCmd(self, name);
end

function ServiceGuildCmdProxy:CallApplyGuildGuildCmd(guid) 
	ServiceGuildCmdProxy.super.CallApplyGuildGuildCmd(self, guid);
end

function ServiceGuildCmdProxy:CallInviteMemberGuildCmd(charid, guildid, guildname) 
	ServiceGuildCmdProxy.super.CallInviteMemberGuildCmd(self, charid, guildid, guildname);
end

function ServiceGuildCmdProxy:CallProcessApplyGuildCmd(agree, charid) 
	-- printGreen(string.format("Call-->ProcessApplyGuildCmd(agree:%s charid:%s)", tostring(agree), tostring(charid)));
	local opt = agree and GuildCmd_pb.EGUILDACTION_AGREE or GuildCmd_pb.EGUILDACTION_DISAGREE;
	ServiceGuildCmdProxy.super.CallProcessApplyGuildCmd(self, opt, charid);
end

function ServiceGuildCmdProxy:CallProcessInviteGuildCmd(action, guid) 
	ServiceGuildCmdProxy.super.CallProcessInviteGuildCmd(self, action, guid);
end

function ServiceGuildCmdProxy:CallKickMemberGuildCmd(charid) 
	FunctionSecurity.Me():GuildControl(function ()
		ServiceGuildCmdProxy.super.CallKickMemberGuildCmd(self, charid);
	end);
end

function ServiceGuildCmdProxy:CallChangeJobGuildCmd(charid, job) 
	-- printGreen(string.format("Call-->ChangeJobGuildCmd(charid:%s, job:%s)", tostring(charid), tostring(job)));
	ServiceGuildCmdProxy.super.CallChangeJobGuildCmd(self, charid, job);
end

function ServiceGuildCmdProxy:CallExchangeChairGuildCmd(newcharid) 
	ServiceGuildCmdProxy.super.CallExchangeChairGuildCmd(self, newcharid);
end

function ServiceGuildCmdProxy:CallLevelupGuildCmd() 
	-- printGreen("Call-->LevelupGuildCmd");
	ServiceGuildCmdProxy.super.CallLevelupGuildCmd(self);
end

function ServiceGuildCmdProxy:CallDonateContributeGuildCmd(contribute) 
	ServiceGuildCmdProxy.super.CallDonateContributeGuildCmd(self, contribute);
end

function ServiceGuildCmdProxy:CallEnterTerritoryGuildCmd() 
	if(Game.MapManager:IsPVPMode())then
		MsgManager.ShowMsgByIDTable(984);
	else
		ServiceGuildCmdProxy.super.CallEnterTerritoryGuildCmd(self);
	end
end

function ServiceGuildCmdProxy:CallDismissGuildCmd(set) 
	ServiceGuildCmdProxy.super.CallDismissGuildCmd(self, set);
end

function ServiceGuildCmdProxy:CallExitGuildGuildCmd() 
	-- printGreen("Call-->ExitGuildGuildCmd");
	FunctionSecurity.Me():GuildControl(function()
		ServiceGuildCmdProxy.super.CallExitGuildGuildCmd(self);
	end);
end

function ServiceGuildCmdProxy:CallPrayGuildCmd(npcid, pray) 
	-- printGreen("Call-->PrayGuildCmd", npcid, pray);
	ServiceGuildCmdProxy.super.CallPrayGuildCmd(self, npcid, pray);
end

-------------------------- Recv --------------------------
function ServiceGuildCmdProxy:RecvQueryGuildListGuildCmd(data) 
	-- printGreen(string.format("Recv-->QueryGuildListGuildCmd(listNum:%s page:%s keyword:%s)", 
	-- 	tostring(#data.list), tostring(data.page), tostring(data.keyword))); 
	GuildProxy.Instance:UpdateGuildList(data.list);

	self:Notify(ServiceEvent.GuildCmdQueryGuildListGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvEnterGuildGuildCmd(data) 
	FunctionGuild.Me():ResetGuildItemQueryState()
	FunctionGuild.Me():ResetGuildEventQueryState()
	GuildProxy.Instance:InitMyGuildData(data.data)

	self:Notify(ServiceEvent.GuildCmdEnterGuildGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildDataUpdateGuildCmd(data) 
	-- printGreen("Recv-->GuildDataUpdateGuildCmd"); 
	GuildProxy.Instance:UpdateMyGuildData(data.updates)
	
	self:Notify(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildMemberUpdateGuildCmd(data) 
	helplog("========================================语音消息同步===================================")
	GuildProxy.Instance:UpdateMyMembers(data.updates, data.dels)
	self:Notify(ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildMemberDataUpdateGuildCmd(data) 

	if(data.type == GuildCmd_pb.EGUILDLIST_MEMBER)then
		helplog("========================================语音消息同步===================1================")

		GuildProxy.Instance:UpdateMyGuildMemberData(data.charid, data.updates)
	elseif(data.type == GuildCmd_pb.EGUILDLIST_APPLY)then
		helplog("========================================语音消息同步===================2================")
		GuildProxy.Instance:UpdateMyGuildApplyData(data.charid, data.updates)
	end
	GVoiceProxy.Instance:RecvGuildMemberDataUpdateGuildCmd(data)
	self:Notify(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildApplyUpdateGuildCmd(data) 
	GuildProxy.Instance:UpdateMyApplys(data.updates, data.dels);
	self:Notify(ServiceEvent.GuildCmdGuildApplyUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvInviteMemberGuildCmd(data) 
	-- printGreen("Recv-->InviteMemberGuildCmd"); 
	self:Notify(ServiceEvent.GuildCmdInviteMemberGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvExitGuildGuildCmd(data) 
	-- printGreen("Recv-->ExitGuildGuildCmd"); 
	GuildProxy.Instance:ExitGuild();
	self:Notify(ServiceEvent.GuildCmdExitGuildGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQueryGQuestGuildCmd(data) 
	ArtifactProxy.Instance:HandleQuestUnlock(data.submit_quests)
	self:Notify(ServiceEvent.GuildCmdQueryGQuestGuildCmd, data)
end

local tempArray = {};
function ServiceGuildCmdProxy:RecvGuildInfoNtf(data) 
	-- LogUtility.Info(string.format("Recv-->GuildInfoNtf charid:%s, id:%s, name:%s, icon:%s, job:%s", 
	-- 	tostring(data.charid), tostring(data.id), tostring(data.name), tostring(data.icon), tostring(data.job)));
	local player = NSceneUserProxy.Instance:Find(data.charid)
	if(player)then
		TableUtility.ArrayClear(tempArray);
		tempArray[1] = data.id;
		tempArray[2] = data.name;
		tempArray[3] = data.icon;
		tempArray[4] = data.job;

		player.data:SetGuildData(tempArray);

		-- 公会界面关闭状态 服务器不会通知玩家公会职位变化 所以客户端临时监听场景里玩家自己的职位变化来处理玩家自己公会职位发生变化的逻辑
		local myId = Game.Myself.data.id;
		if(data.charid == myId)then
			-- helplog(data.id, data.name, data.icon, data.job);
			local myGuildData = GuildProxy.Instance.myGuildData;
			if(myGuildData)then
				local myGuildMemberData = myGuildData:GetMemberByGuid(myId);
				if(myGuildMemberData and myGuildMemberData:GetJobName() ~= data.job)then
					local old,new = myGuildMemberData.job;
					local jobMap = myGuildData:GetJobMap();
					for id, jdata in pairs(jobMap)do
						if(jdata.name == data.job)then
							new = id;
							break;
						end
					end
					FunctionGuild.Me():MyGuildJobChange(old, new);
				end
			end
		else
			local guildData = player.data:GetGuildData()
			local myselfGuildData = Game.Myself.data:GetGuildData()
			if(myselfGuildData~=nil and guildData~=nil) then
				player.data:Camp_SetIsInMyGuild(myselfGuildData.id == guildData.id)
			else
				player.data:Camp_SetIsInMyGuild(false)
			end
		end
	end
	self:Notify(ServiceEvent.GuildCmdGuildInfoNtf, data)
end

function ServiceGuildCmdProxy:RecvGuildPrayNtfGuildCmd(data) 
	-- printGreen("Recv-->GuildPrayNtfGuildCmd");
	Game.Myself.data:SetGuildPray(data.prays);
	self:Notify(ServiceEvent.GuildCmdGuildPrayNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:CallDonateListGuildCmd(items) 
	GuildProxy.Instance:ClearGuildDonateItems();
	ServiceGuildCmdProxy.super.CallDonateListGuildCmd(self, items);
end

function ServiceGuildCmdProxy:RecvDonateListGuildCmd(data)
	local items = data.items;
	local num = items and #items or 0;
	GuildProxy.Instance:SetMyGuildDonateItems(items);
	self:Notify(ServiceEvent.GuildCmdDonateListGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvNewDonateItemGuildCmd(data) 
	local donateItem = data.item;
	GuildProxy.Instance:AddOrUpdateGuildDonateItem(donateItem);
	self:Notify(ServiceEvent.GuildCmdNewDonateItemGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvUpdateDonateItemGuildCmd(data) 
	GuildProxy.Instance:AddOrUpdateGuildDonateItem(data.item);
	GuildProxy.Instance:RemoveGuildDonateItem(data.del);
	self:Notify(ServiceEvent.GuildCmdUpdateDonateItemGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvBuildingNtfGuildCmd(data)
	GuildBuildingProxy.Instance:SetBuildingData(data.buildings)
	GuildBuildingProxy.Instance:PlayUpdateEffect()
	self:Notify(ServiceEvent.GuildCmdBuildingNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvBuildingSubmitCountGuildCmd(data)
	self:Notify(ServiceEvent.GuildCmdBuildingSubmitCountGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQueryBuildingRankGuildCmd(data)
	-- helplog("RecvQueryBuildingRankGuildCmd data.items: ",#data.items)
	GuildBuildingProxy.Instance:SetBuildingRank(data)
	self:Notify(ServiceEvent.GuildCmdQueryBuildingRankGuildCmd, data)
end


-- guild Pack begin
function ServiceGuildCmdProxy:RecvQueryPackGuildCmd(data) 
	GuildProxy.Instance:SetGuildPackItems(data.items);
	self:Notify(ServiceEvent.GuildCmdQueryPackGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvPackUpdateGuildCmd(data) 
	GuildProxy.Instance:SetGuildPackItems(data.updates);
	GuildProxy.Instance:RemoveGuildPackItems(data.dels);
	self:Notify(ServiceEvent.GuildCmdPackUpdateGuildCmd, data)
end
-- guild Pack end

function ServiceGuildCmdProxy:RecvBuildingLvupEffGuildCmd(data) 
	GuildBuildingProxy.Instance:PlayBuildingLvupEff(data.effects)
	self:Notify(ServiceEvent.GuildCmdBuildingLvupEffGuildCmd, data)
end

-- guildevent begin
function ServiceGuildCmdProxy:CallQueryEventListGuildCmd() 
	-- helplog("Call-->QueryEventListGuildCmd");
	ServiceGuildCmdProxy.super.CallQueryEventListGuildCmd(self);
end

function ServiceGuildCmdProxy:RecvQueryEventListGuildCmd(data) 
	-- helplog("Recv-->QueryEventListGuildCmd", #data.events);
	GuildProxy.Instance:Server_ResetGuildEventList(data.events);
	self:Notify(ServiceEvent.GuildCmdQueryEventListGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvNewEventGuildCmd(data) 
	local isdel = data.del;
	if(isdel)then
		local id = data.event and data.event.guid;
		GuildProxy.Instance:Server_RemoveGuildEventData(id);
	else
		GuildProxy.Instance:Server_AddGuildEventData(data.event);
	end
	self:Notify(ServiceEvent.GuildCmdNewEventGuildCmd, data)
end
-- guildevent end

function ServiceGuildCmdProxy:CallApplyRewardConGuildCmd(configid) 
	ServiceGuildCmdProxy.super.CallApplyRewardConGuildCmd(self, configid);

	-- local data = {};
	-- data.configid = configid;
	-- data.con = {{id=100,num=828}, {id=140,num=30}, {id=146,num=30}, {id=5034,num=1}};
	-- data.asset = {{id=100,num=828}};
	-- self:RecvApplyRewardConGuildCmd(data);
end

function ServiceGuildCmdProxy:RecvApplyRewardConGuildCmd(data) 
	FunctionDonateItem.Me():SetDetailInfo(data.configid, data.con, data.asset);
	self:Notify(ServiceEvent.GuildCmdApplyRewardConGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvJobUpdateGuildCmd(data) 
	-- helplog("Recv-->JobUpdateGuildCmd");
	-- if(data.job)then
	-- 	helplog(data.job.name, data.job.job, data.job.auth, data.job.editauth);
	-- end
	GuildProxy.Instance:UpdateMyGuildJob(data.job);
	self:Notify(ServiceEvent.GuildCmdJobUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:CallSetGuildOptionGuildCmd(board, recruit, portrait, jobs) 
	-- helplog( string.format("Call-->SetGuildOptionGuildCmd board:%s recruit:%s portrait:%s", tostring(board),tostring(recruit),tostring(portrait)) );
	local pbJobs = {};
	if(jobs)then
		for i=1,#jobs do
			local temp = GuildCmd_pb.GuildJob();
			temp.job = jobs[i].job;
			temp.name = jobs[i].name;
			-- helplog("ChangeJobName:", jobs[i].job, jobs[i].name);
			table.insert(pbJobs, temp)
		end
	end
	if(type(portrait) == "number")then
		portrait = tostring(portrait);
	end
	ServiceGuildCmdProxy.super.CallSetGuildOptionGuildCmd(self, board, recruit, portrait, pbJobs);
end

function ServiceGuildCmdProxy:CallModifyAuthGuildCmd(add, modify, job, auth)
	-- helplog("Call-->ModifyAuthGuildCmd", add, modify, job, auth);
	ServiceGuildCmdProxy.super.CallModifyAuthGuildCmd(self, add, modify, job, auth);
end

function ServiceGuildCmdProxy:RecvQueryGuildCityInfoGuildCmd(data) 
	GvgProxy.Instance:SetRuleGuildInfos(data.infos)
	self:Notify(ServiceEvent.GuildCmdQueryGuildCityInfoGuildCmd, data)
end

function ServiceGuildCmdProxy:CallGuildIconAddGuildCmd(index, state, createtime, isdelete, type) 
	-- helplog("Call-->GuildIconAddGuildCmd", index, state, createtime, isdelete);
	ServiceGuildCmdProxy.super.CallGuildIconAddGuildCmd(self, index, state, createtime, isdelete, type);
end

function ServiceGuildCmdProxy:RecvGuildIconAddGuildCmd(data) 
	-- helplog("Recv-->GuildIconAddGuildCmd", data.index, data.state, data.createtime, data.isdelete);
	GuildProxy.Instance:UpdateMyGuildHeadDataState(data.index, data.state, data.createtime, data.isdelete, data.type)
	self:Notify(ServiceEvent.GuildCmdGuildIconAddGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildIconUploadGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdGuildIconUploadGuildCmd, data)
	EventManager.Me():PassEvent(ServiceEvent.GuildCmdGuildIconUploadGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildIconSyncGuildCmd(data) 
	-- helplog("Recv-->GuildIconSyncGuildCmd", #data.infos, #data.dels);
	GuildProxy.Instance:UpdateMyGuildHeadDatas(data.infos, data.dels)
	self:Notify(ServiceEvent.GuildCmdGuildIconSyncGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvWelfareNtfGuildCmd(data) 
	-- helplog("Recv-->WelfareNtfGuildCmd", data.welfare);
	GuildProxy.Instance:SetGuildWelfareState(data.welfare)
	self:Notify(ServiceEvent.GuildCmdWelfareNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvChallengeUpdateNtfGuildCmd(data) 
	-- helplog("Recv-->ChallengeUpdateNtfGuildCmd", #data.updates, #data.dels, data.refreshtime);
	GuildProxy.Instance:UpdateGuildChallengeTasks(data.updates, data.dels, data.refreshtime);
	self:Notify(ServiceEvent.GuildCmdChallengeUpdateNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvArtifactUpdateNtfGuildCmd(data) 
	ArtifactProxy.Instance:SetArtifactData(data)
	self:Notify(ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvTreasureActionGuildCmd(data)
	helplog("Recv-->RecvTreasureActionGuildCmd")
	if(GuildTreasureProxy.ViewType.TreasurePreview==GuildTreasureProxy.Instance:GetViewType())then
		return
	end
	local isMyself = data.charid==Game.Myself.data.id
	GuildTreasureProxy.Instance:SetTreasure(data)
	if(isMyself)then
		GuildTreasureProxy.Instance:ShowGuildTreasurePanel(data)
	end
	GuildTreasureProxy.Instance:PlayOpenBox(data)
	if(isMyself)then
		self:Notify(ServiceEvent.GuildCmdTreasureActionGuildCmd, data)
	end
end

function ServiceGuildCmdProxy:RecvQueryTreasureResultGuildCmd(data)
	GuildTreasureProxy.Instance:SetTreasureResult(data.result)
	self:Notify(ServiceEvent.GuildCmdQueryTreasureResultGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQueryGCityShowInfoGuildCmd(data) 
	GvgProxy.Instance:Update_GLandStatusInfos(data.infos)
	self:Notify(ServiceEvent.GuildCmdQueryGCityShowInfoGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgOpenFireGuildCmd(data) 
	GvgProxy.Instance:SetGvgOpenFireState(data.fire);
	self:Notify(ServiceEvent.GuildCmdGvgOpenFireGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvEnterPunishTimeNtfGuildCmd(data) 
	helplog("Recv-->EnterPunishTimeNtfGuildCmd", os.date(DATA_FORMAT, data.exittime));
	GuildProxy.Instance:SetExitTimeTick(data.exittime);
	self:Notify(ServiceEvent.GuildCmdEnterPunishTimeNtfGuildCmd, data)
end


function ServiceGuildCmdProxy:RecvOpenRealtimeVoiceGuildCmd(data) 
	helplog("RecvOpenRealtimeVoiceGuildCmd")

	GVoiceProxy.Instance:RecvOpenRealtimeVoiceGuildCmd(data) 
	self:Notify(ServiceEvent.GuildCmdOpenRealtimeVoiceGuildCmd, data)
end