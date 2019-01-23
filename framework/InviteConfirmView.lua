InviteConfirmView = class("InviteConfirmView", BaseView);

InviteConfirmView.ViewType = UIViewType.IConfirmLayer

autoImport("InviteConfirmCtl");
autoImport("DesertWolfInviteCell")

local teamProxy;
local server_TeamProxy;
function InviteConfirmView:Init()
	teamProxy = TeamProxy.Instance;
	server_TeamProxy = ServiceSessionTeamProxy.Instance;

	self:InitUI();
	self:MapViewListen();
end

function InviteConfirmView:InitUI()
	local inviteGrid = self:FindGO("InviteGrid");
	self.desertInviteRoot = self:FindGO("Anchor_RightCenter");
	self.conformCtl = InviteConfirmCtl.new(inviteGrid);
end

function InviteConfirmView:MapViewListen()
	self:AddListenEvt(InviteConfirmEvent.AddInvite,self.HandleRecvAddInvite);
	self:AddListenEvt(InviteConfirmEvent.RemoveInviteByType,self.HandleRemoveInviteByType);

	self:AddListenEvt(ServiceEvent.SessionTeamInviteMember, self.HandleRecvInvite);
	self:AddListenEvt(ServiceEvent.SessionTeamTeamSummon, self.HandleRecvFollowInvite);

	self:AddListenEvt(ServiceEvent.NUserInviteJoinHandsUserCmd ,self.HandleRecvJoinHand);

	self:AddListenEvt(ServiceEvent.GuildCmdInviteMemberGuildCmd, self.HandleRecvGuildInvite);
	-- 道场邀请框
	self:AddListenEvt(ServiceEvent.DojoDojoInviteCmd, self.HandleRecvDojoInvite);
	-- 无限塔邀请框
	self:AddListenEvt(ServiceEvent.InfiniteTowerTeamTowerInviteCmd, self.HandleEndlessTowerInvite);
	-- 公会搬家
	self:AddListenEvt(ServiceEvent.GuildCmdExchangeZoneNtfGuildCmd, self.HandleExchangeGuildZoneInvite);
	-- 占卜邀请
	self:AddListenEvt(ServiceEvent.SceneAuguryAuguryInvite, self.HandleAuguryInvite)
	-- 邀请跟随
	self:AddListenEvt(ServiceEvent.NUserInviteFollowUserCmd, self.HandleRecvFollow);	
	-- 沙漠之狼队长挑战邀请
	self:AddListenEvt(ServiceEvent.MatchCCmdRevChallengeCCmd,self.HandleRecvChallenge);
	-- 沙漠之狼队员确认挑战
	self:AddListenEvt(ServiceEvent.MatchCCmdFightConfirmCCmd,self.HandleDesertWorfConfirm);
	-- 团队接取
	self:AddListenEvt(ServiceEvent.QuestInviteHelpAcceptQuestCmd, self.HandleRecvTeamWantedAcp);

	-- 接受队伍邀请
	self:AddListenEvt(ServiceEvent.NUserCallTeamerUserCmd, self.HandleRecvCallTeamerReplyUserCmd);

	--求婚邀请
	self:AddListenEvt(ServiceEvent.NUserMarriageProposalCmd, self.HandleMarriageProposalCmd);
	self:AddListenEvt(InviteConfirmEvent.Courtship_OutDistance, self.HandleMarriageProposal_OutDistance);
	self:AddListenEvt(ServiceEvent.WeddingCCmdMissyouInviteWedCCmd, self.HandleMissyouInviteWedCCmd);

	-- 接受结婚邀请
	self:AddListenEvt(ServiceEvent.WeddingCCmdInviteBeginWeddingCCmd, self.HandleRecvInviteBeginWeddingCCmd);
	--订婚邀请
	self:AddListenEvt(ServiceEvent.WeddingCCmdNtfReserveWeddingDateCCmd, self.HandleReserveWeddingDate)
	--协议离婚邀请
	self:AddListenEvt(ServiceEvent.WeddingCCmdDivorceRollerCoasterInviteCCmd, self.HandleDivorceRollerCoasterInvite)

	-- 卡牌副本
	self:AddListenEvt(ServiceEvent.PveCardInvitePveCardCmd, self.HandleCardInvitePveCardCmd)

	self:AddListenEvt(ServiceEvent.NUserTwinsActionUserCmd, self.HandleRecvTwinsAction)

	-- PVP集结糖浆传送邀请
	self:AddListenEvt(ServiceEvent.NUserInviteWithMeUserCmd, self.HandleRecvInviteWithMe)
	
	-- 奥特曼副本
	self:AddListenEvt(ServiceEvent.TeamRaidCmdTeamRaidInviteCmd, self.HandleAltmanInviteMsg)

	--组队看板之快速完成
	self:AddListenEvt(ServiceEvent.QuestHelpQuickFinishBoardQuestCmd, self.HandleQuestHelpQuickFinish)
end

-- 沙漠之狼挑战 队长邀请
function InviteConfirmView:HandleRecvChallenge(note)
	local data = note.body
	if(not data)then return end 
	local DesertWolfInviteCell=DesertWolfInviteCell.new(self.desertInviteRoot, data);
end

-- 沙漠之狼队员确认挑战
function InviteConfirmView:HandleDesertWorfConfirm(note)
	local data = note.body
	helplog("HandleDesertWorfConfirm",data.roomid)
	if TeamProxy.Instance:CheckIHaveLeaderAuthority() then
		return 
	end
	
	local roomid = data.roomid
	local teamID = Game.Myself.data:GetTeamID()
	local playerid = Game.Myself.data.id
	local challenger = data.challenger
	local data = {
		playerid = playerid,
		time = GameConfig.Team.inviteovertime,
		msgId = teamID==data.teamid and 969 or 979,
		msgParama = {challenger},
	};
	data.yesevt = function (id)
		ServiceMatchCCmdProxy.Instance:CallFightConfirmCCmd(PvpProxy.Type.DesertWolf, roomid,teamID,1);
	end;
	data.noevt = function (id)
		ServiceMatchCCmdProxy.Instance:CallFightConfirmCCmd(PvpProxy.Type.DesertWolf, roomid,teamID,2);
	end

	self.conformCtl:AddInvite(InviteType.DesertWolf ,data);
end


-- 牵手邀请
function InviteConfirmView:HandleRecvTeamWantedAcp(note)
	local leaderName = note.body.leadername;
	local leaderid = note.body.leaderid;
	local questid = note.body.questid;
	local stData = Table_WantedQuest[questid]
	local issubmit = note.body.issubmit
	if(stData)then
		local questName = stData.Name
		local sign = note.body.sign;
		local time = note.body.time;
		local msgId = 4011
		local data = {
			playerid = sign,
			time = GameConfig.Team.inviteovertime,
			msgId = msgId,
			msgParama = {leaderName, questName},
		};
		data.yesevt = function (id)
			ServiceQuestProxy.Instance:CallReplyHelpAccelpQuestCmd(leaderid,questid,time,sign,true)
		end;
		data.endevt = function (id)
			ServiceQuestProxy.Instance:CallReplyHelpAccelpQuestCmd(leaderid,questid,time,sign,true)
		end;
		-- data.noevt = function (id)
		-- 	-- 拒绝（sign time 不赋值为拒绝）
		-- 	-- ServiceNUserProxy.Instance:CallJoinHandsUserCmd(masterid);
		-- end

		self.conformCtl:AddInvite(InviteType.TmLeaderAcp ,data);
	else
		helplog("unkown wantedQuest:",questid)
	end
	
end

function InviteConfirmView:HandleRecvJoinHand(note)
	local playerid = note.body.charid;
	local masterid = note.body.masterid;
	local username = note.body.mastername;

	local sign = note.body.sign;
	local time = note.body.time;

	local data = {
		playerid = masterid,
		time = GameConfig.Team.inviteovertime,
		msgId = 825,
		msgParama = {username, username},
	};
	data.yesevt = function (id)
		if(teamProxy:IHaveTeam())then
			ServiceNUserProxy.Instance:CallJoinHandsUserCmd(masterid, sign, time);
		else
			MsgManager.ShowMsgByIDTable(827);
		end
	end;
	data.noevt = function (id)
		-- 拒绝（sign time 不赋值为拒绝）
		ServiceNUserProxy.Instance:CallJoinHandsUserCmd(masterid);
	end

	self.conformCtl:AddInvite(InviteType.JoinHand ,data);
end

function InviteConfirmView:HandleRecvAddInvite(note)
	local data = note.body;
	data.yestip = ZhString.InviteConfirmView_Join;
	local yesevt = data.yesevt;
	self.conformCtl:AddInvite(InviteType.Carrier ,data);
end

function InviteConfirmView:HandleRemoveInviteByType(note)
	self.conformCtl:ClearInviteMap(note.body);
end

function InviteConfirmView:HandleRecvInvite(note)
	local playerid = note.body.userguid;
	local teamname = note.body.teamname;
	local username = note.body.username;
	local data = {
		playerid = playerid,
		time = GameConfig.Team.inviteovertime,
		msgId = 323,
		msgParama = {teamname, username},
	};
	data.yesevt = function (id)
		server_TeamProxy:CallProcessTeamInvite(SessionTeam_pb.ETEAMINVITETYPE_AGREE, id);
	end;
	data.noevt = function (id)
		server_TeamProxy:CallProcessTeamInvite(SessionTeam_pb.ETEAMINVITETYPE_DISAGREE, id);
	end

	self.conformCtl:AddInvite(InviteType.Team ,data);
end

function InviteConfirmView:HandleRecvFollowInvite(note)
	local leader = self.MyTeam():GetLeader();
	local raid = note.body.raidid;
	local data = {
		playerid = leader.id,
		time = 20,
		msgId = 406,
		msgParama = {leader.name, Table_MapRaid[raid].NameZh},
	};
	data.yesevt = function (id)
		local nowFollowID = Game.Myself:Client_GetFollowLeaderID();
		if(not nowFollowID or nowFollowID == 0)then
			self:sendNotification(FollowEvent.Follow, id);
		else
			MsgManager.ShowMsgByIDTable(404);
		end
	end;
	self.conformCtl:AddInvite(InviteType.Carrier ,data);
end

-- 公会邀请
function InviteConfirmView:HandleRecvGuildInvite(note)
	local guildid = note.body.guildid;
	local playername = note.body.invitename;
	local guildname = note.body.guildname;
	if(guildid and guildname)then
		local data = {
			playerid = guildid,
			time = GameConfig.Team.inviteovertime,
			msgId = 2632,
			msgParama = {playername, guildname},
		};
		data.yesevt = function (id)
			ServiceGuildCmdProxy.Instance:CallProcessInviteGuildCmd(GuildCmd_pb.EGUILDACTION_AGREE, id);
		end;
		data.noevt = function (id)
			ServiceGuildCmdProxy.Instance:CallProcessInviteGuildCmd(GuildCmd_pb.EGUILDACTION_DISAGREE, id);
		end

		self.conformCtl:AddInvite(InviteType.Guild ,data);
	end
end

function InviteConfirmView:HandleRecvDojoInvite(note)
	local sponsorid = note.body.sponsorid;
	local sponsorname = note.body.sponsorname;
	local dojoid = note.body.dojoid;
	if(sponsorid and sponsorname and dojoid)then
		local dojoName = Table_Guild_Dojo[dojoid] and Table_Guild_Dojo[dojoid].Name or ""
		local data = {
			playerid = sponsorid,
			time = GameConfig.Team.inviteovertime,
			msgId = 406,
			msgParama = {sponsorname, dojoName},
		};
		data.yesevt = function (id)
			local lvreq = DojoProxy.Instance:GetGroupLvreq(dojoid)
			if lvreq and MyselfProxy.Instance:RoleLevel() < lvreq then
				MsgManager.ShowMsgByID(2950)
				ServiceDojoProxy.Instance:CallDojoReplyCmd( Dojo_pb.EDOJOREPLY_DISAGREE )
				return
			end

			ServiceDojoProxy.Instance:CallDojoReplyCmd( Dojo_pb.EDOJOREPLY_AGREE )
			-- self:sendNotification(FollowEvent.Follow, id)
		end;
		data.noevt = function (id)
			ServiceDojoProxy.Instance:CallDojoReplyCmd( Dojo_pb.EDOJOREPLY_DISAGREE )
		end

		self.conformCtl:AddInvite(InviteType.Dojo ,data);
	end
end

function InviteConfirmView:HandleEndlessTowerInvite(note)
	if(not teamProxy:IHaveTeam())then
		return;
	end

	local leaderId = teamProxy.myTeam:GetNowLeader().id;
	local data = {
		playerid = leaderId;
		time = GameConfig.Team.inviteovertime,
		msgId = 1311,
	};
	data.yesevt = function (id)
		ServiceInfiniteTowerProxy.Instance:CallTeamTowerReplyCmd(InfiniteTower_pb.ETOWERREPLY_AGREE ,Game.Myself.data.id)
		self:sendNotification(FollowEvent.Follow, leaderId)
	end;
	data.noevt = function (id)
		ServiceInfiniteTowerProxy.Instance:CallTeamTowerReplyCmd(InfiniteTower_pb.ETOWERREPLY_DISAGREE ,Game.Myself.data.id)
	end
	self.conformCtl:AddInvite(InviteType.EndlessTower ,data);
end


-- exchange guild zoneid begin
function InviteConfirmView.AgreeExchangeGuildZone(id)
	ServiceGuildCmdProxy.Instance:CallExchangeZoneAnswerGuildCmd(true) 
end

function InviteConfirmView.RefuseExchangeGuildZone(id)
	ServiceGuildCmdProxy.Instance:CallExchangeZoneAnswerGuildCmd(false) 
end

function InviteConfirmView:HandleExchangeGuildZoneInvite(note)
	local curzoneid = note.body.curzoneid;
	curzoneid = ChangeZoneProxy.Instance:ZoneNumToString(curzoneid);
	local nextzoneid = note.body.nextzoneid;
	nextzoneid = ChangeZoneProxy.Instance:ZoneNumToString(nextzoneid);
	local data = {
		playerid = "Temp",
		time = GameConfig.Team.inviteovertime,
		msgId = 3081,
		msgParama = {nextzoneid, nextzoneid},
	};
	data.yesevt = InviteConfirmView.AgreeExchangeGuildZone;
	data.noevt = InviteConfirmView.RefuseExchangeGuildZone;
	data.endevt = InviteConfirmView.RefuseExchangeGuildZone;

	self.conformCtl:AddInvite(InviteType.Guild ,data);
end
-- exchange guild zoneid end

-- Augury Invite begin
function InviteConfirmView:HandleAuguryInvite(note)
	local body = note.body
	local inviterid = body.inviterid
	local invitername = body.invitername
	local npcId = body.npcguid
	local augurytype = body.type
	local isextra = body.isextra
	local data = {
		playerid = inviterid,
		time = GameConfig.Team.inviteovertime,
		msgId = 928,
		msgParama = {invitername},
	};
	data.yesevt = function (id)
		if npcId then
			local npc = NSceneNpcProxy.Instance:Find(npcId)
			if npc and VectorUtility.DistanceXZ( Game.Myself:GetPosition(), npc:GetPosition() ) <= GameConfig.Augury.Range then
				ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply( SceneAugury_pb.EReplyType_Agree , id , npcId, augurytype, isextra)
			else
				ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply( SceneAugury_pb.EReplyType_Refuse , id , npcId, augurytype, isextra)
			end
		end
	end
	data.noevt = function (id)
		ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply( SceneAugury_pb.EReplyType_Refuse , id , npcId, augurytype, isextra)
	end
	data.endevt = function (id)
		ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply( SceneAugury_pb.EReplyType_Refuse , id , npcId, augurytype, isextra)
	end

	self.conformCtl:AddInvite(InviteType.Augury ,data)
end
-- Augury Invite end

function InviteConfirmView:HandleRecvFollow(note)
	local playerid = note.body.charid;
	if(Game.Myself and Game.Myself:Client_GetFollowLeaderID() == playerid)then
		return;
	end
	
	if(teamProxy:IHaveTeam())then
		local memData = teamProxy.myTeam:GetMemberByGuid(playerid);
		if(not memData)then
			errorLog("No Member When Recv FollowInvite");
			return;
		end
		local data = {
			playerid = playerid,
			time = GameConfig.Team.inviteovertime,
			msgId = 344,
			msgParama = {memData.name},
		};
		
		local yesevt = function (id)
			if(Game.Myself:IsDead())then
				MsgManager.ShowMsgByIDTable(2500);
				return;
			end
			if(memData.zoneid ~= MyselfProxy.Instance:GetZoneId())then
				MsgManager.ShowMsgByIDTable(3056);
				return;
			end
			GameFacade.Instance:sendNotification(FollowEvent.Follow ,id);
		end;
		data.yesevt = yesevt;
		data.endevt = function (id)
			local myMemberData = teamProxy:GetMyTeamMemberData();
			if(myMemberData and myMemberData.autofollow == 1)then
				yesevt(id);
			end
		end

		self.conformCtl:AddInvite(InviteType.Follow ,data);
	else
		errorLog("No Team When Recv FollowInvite");
	end
end

function InviteConfirmView:HandleRecvCallTeamerReplyUserCmd(note)
	local playerid = note.body.masterid;
	local sign = note.body.sign;
	local time = note.body.time;
	
	if(teamProxy:IHaveTeam())then
		local memData = teamProxy.myTeam:GetMemberByGuid(playerid);
		if(not memData)then
			errorLog("No Member When Recv FollowInvite");
			return;
		end
		local data = {
			playerid = playerid,
			time = 5,
			msgId = 344,
			msgParama = {note.body.username},
		};
		
		local yesevt = function (id)
			ServiceNUserProxy.Instance:CallCallTeamerReplyUserCmd(playerid, sign, time);
		end;
		data.yesevt = yesevt;
		data.endevt = yesevt;

		self.conformCtl:AddInvite(InviteType.Follow ,data);
	else
		errorLog("No Team When Recv FollowInvite");
	end
end

local marriageProposal_Map = {};
function InviteConfirmView:HandleMarriageProposalCmd(note)
	local server_data = note.body;
	if(server_data == nil)then
		return;
	end

	local masterid = server_data.masterid;
	local mastername = server_data.mastername;
	local itemid = server_data.itemid;
	local sign = server_data.sign;
	local server_time = server_data.time;

	local gameconfig_wedding = GameConfig.Wedding;
	local overtime, msgId = 5, 344;
	if(gameconfig_wedding)then
		overtime, msgId = gameconfig_wedding.Courtship_InviteOverTime, gameconfig_wedding.Courtship_InviteMsgId;
	end

	local data = {
		playerid = masterid,
		time = overtime,
		msgId = msgId,
	};

	local msgData = Table_Sysmsg[ msgId ];
	local msgTitle = msgData.Title;
	if(msgTitle)then
		msgTitle = string.format(msgTitle, mastername);
		data.tip = msgTitle;
	end

	data.yesevt = function (id)
		FunctionWedding.Me():RemoveCourtshipDistanceCheck(id);

		ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, 
			SceneUser2_pb.EPROPOSALREPLY_YES,
			server_time,
			sign);

		marriageProposal_Map[id] = nil;
	end
	data.noevt = function (id)
		FunctionWedding.Me():RemoveCourtshipDistanceCheck(id);

		ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, 
			SceneUser2_pb.EPROPOSALREPLY_NO,
			server_time,
			sign)

		marriageProposal_Map[id] = nil;
	end
	data.endevt = function (id)
		FunctionWedding.Me():RemoveCourtshipDistanceCheck(id);

		ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, 
			SceneUser2_pb.EPROPOSALREPLY_CANCEL,
			server_time,
			sign,
			itemid)

		marriageProposal_Map[id] = nil;
	end

	marriageProposal_Map[masterid] = { sign, server_time };
	
	self.conformCtl:AddInvite(InviteType.Courtship ,data)
end

function InviteConfirmView:HandleMarriageProposal_OutDistance(note)
	local playerid = note.body;
	if(playerid == nil)then
		return;
	end

	local cacheInfo = marriageProposal_Map[playerid];
	if(cacheInfo == nil)then
		return;
	end

	local sign, server_time = cacheInfo[1], cacheInfo[2];
	
	ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, 
		SceneUser2_pb.EPROPOSALREPLY_OUTRANGE,
		server_time,
		sign)
end

function InviteConfirmView:HandleRecvInviteBeginWeddingCCmd(note)
	local server_data = note.body;

	local masterid = server_data.masterid;
	local myname = Game.Myself.data.name;
	local name = server_data.name;
	local tocharid = server_data.tocharid;

	local gameconfig_wedding = GameConfig.Wedding;
	local overtime, msgId = 5, 344;
	if(gameconfig_wedding)then
		overtime, msgId = gameconfig_wedding.Cememony_InviteOverTime, gameconfig_wedding.Cememony_InviteMsgId;
	end

	local msgData = Table_Sysmsg[ msgId ];
	local msgTitle, msgText = msgData.Title, msgData.Text;

	local data = {
		playerid = masterid,
		time = overtime,
		msgId = msgId,
	};
	if(msgTitle ~= "")then
		msgTitle = string.format(msgTitle, myname, name);
		data.tip = msgTitle;
	end
	data.yesevt = function (id)
		ServiceWeddingCCmdProxy.Instance:CallReplyBeginWeddingCCmd(masterid) 
	end
	data.noevt = function (id)
	end
	data.endevt = function (id)
	end

	self.conformCtl:AddInvite(InviteType.WeddingCemoney ,data)
end

function InviteConfirmView:HandleRecvInviteWeddingStartNtf(note)
	local itemguid = note.body.itemguid;
	if(itemguid == nil)then
		return;
	end

	local itemData = BagProxy.Instance:GetItemByGuid(itemguid);
	if(itemData == nil)then
		return;
	end

	local weddingData = itemData.weddingData;
	if(weddingData == nil)then
		return;
	end

	-- type playerid, tip, lab, yesevt, noevt, endevt, time, msgId, msgParama, agreeNoClose
	local gameconfig_wedding = GameConfig.Wedding;
	local overtime, msgId = 5, 344;
	if(gameconfig_wedding)then
		overtime, msgId = gameconfig_wedding.Cememony_InviteOverTime, gameconfig_wedding.Cememony_Invite_GotoMsgId;
	end
	local msgData = Table_Sysmsg[ msgId ];
	local msgTitle, msgText = msgData.Title, msgData.Text;

	local data = {
		playerid = itemguid,
		time = overtime,
		msgId = msgId,
	};
	if(msgTitle ~= "")then
		-- msgTitle = string.format(msgTitle, );
	end
	data.yesevt = function (id)
		ServiceWeddingCCmdProxy.Instance:CallReplyBeginWeddingCCmd(tocharid) 
	end
	data.noevt = function (id)
	end
	data.endevt = function (id)
	end

	self.conformCtl:AddInvite(InviteType.WeddingCemoney ,data)
end

function InviteConfirmView:HandleReserveWeddingDate(note)
	local serverData = note.body

	local zoneid = serverData.zoneid % 10000
	local starttime = os.date("*t", serverData.starttime)
	local endtime = os.date("*t", serverData.endtime)

	local title = Table_Sysmsg[9609]
	title = string.format(title.Title, serverData.name)

	local data = {
		playerid = serverData.charid1,
		time = GameConfig.Wedding.EngageInviteOverTime,
		msgId = 9609,
		tip = title,
		msgParama = {starttime.month, starttime.day, starttime.hour, endtime.hour, ChangeZoneProxy.Instance:ZoneNumToString(zoneid)},
	}
	data.yesevt = function (id)
		ServiceWeddingCCmdProxy.Instance:CallReplyReserveWeddingDateCCmd(serverData.date, serverData.configid, id, WeddingCCmd_pb.EReply_Agree, 
			serverData.time, serverData.use_ticket, serverData.zoneid, serverData.sign)
	end
	data.noevt = function (id)
		ServiceWeddingCCmdProxy.Instance:CallReplyReserveWeddingDateCCmd(serverData.date, serverData.configid, id, WeddingCCmd_pb.EReply_Refuse, 
			serverData.time, serverData.use_ticket, serverData.zoneid, serverData.sign)
	end
	data.endevt = function (id)
		ServiceWeddingCCmdProxy.Instance:CallReplyReserveWeddingDateCCmd(serverData.date, serverData.configid, id, WeddingCCmd_pb.EReply_Refuse, 
			serverData.time, serverData.use_ticket, serverData.zoneid, serverData.sign)
	end

	self.conformCtl:AddInvite(InviteType.Engage ,data)
end

function InviteConfirmView:HandleDivorceRollerCoasterInvite(note)
	local serverData = note.body

	local data = {
		playerid = serverData.inviter,
		time = GameConfig.Wedding.Divorce_OverTime,
		msgId = 9612,
		msgParama = {serverData.inviter_name},
	}

	data.yesevt = function (id)
		ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterReplyCCmd(id, WeddingCCmd_pb.EReply_Agree)
	end
	data.noevt = function (id)
		ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterReplyCCmd(id, WeddingCCmd_pb.EReply_Refuse)
	end
	data.endevt = function (id)
		ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterReplyCCmd(id, WeddingCCmd_pb.EReply_Refuse)
	end

	self.conformCtl:AddInvite(InviteType.ConsentDivorce ,data)
end

function InviteConfirmView:HandleQuestHelpQuickFinish(note)
	local serverData = note.body

	local data = {
		playerid = serverData.questid,
		msgId = 25443 ,
		time = 3,
		msgParama = {serverData.leadername},
	}

	data.endevt = function (id)
		ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD,id)
	end

	self.conformCtl:AddInvite(InviteType.HelpFinishQuest ,data)
end

function InviteConfirmView:HandleMissyouInviteWedCCmd(note)
	local playerid = Game.Myself.data.id;
   	local msgId = GameConfig.Wedding.MissYou_Inviteid or 969;
	local data = {
		playerid = playerid,
		time = GameConfig.Team.inviteovertime,
		msgId = msgId,
		msgParama = {},
	};
	data.yesevt = function (id)
		ServiceWeddingCCmdProxy.Instance:CallMisccyouReplyWedCCmd(true) 
	end;
	data.noevt = function (id)
		ServiceWeddingCCmdProxy.Instance:CallMisccyouReplyWedCCmd(false) 
	end

	self.conformCtl:AddInvite(InviteType.DesertWolf ,data);
end

function InviteConfirmView:HandleCardInvitePveCardCmd(note)
	local playerid, iscancel = note.body.configid, note.body.iscancel;
	local msgId = GameConfig.CardRaid.invitemsg or 969;
	local data = {
		playerid = playerid,
		time = GameConfig.Team.inviteovertime,
		msgId = msgId,
		msgParama = {},
	};
	data.yesevt = function (id)
		ServicePveCardProxy.Instance:CallReplyPveCardCmd(true, id)
	end;
	data.noevt = function (id)
		ServicePveCardProxy.Instance:CallReplyPveCardCmd(false, id)
	end

	self.conformCtl:AddInvite(InviteType.RaidCard ,data);
end

function InviteConfirmView:HandleRecvTwinsAction(note)
	local userid, etype = note.body.userid, note.body.etype;

	if(etype ~= SceneUser2_pb.ETWINS_OPERATION_REQUEST)then
		return;
	end

	local myTeam = TeamProxy.Instance.myTeam;
	local memberData = myTeam and myTeam:GetMemberByGuid(userid)
	local name = memberData and memberData.name or ""

	local msgId = 393;
	if(Table_Sysmsg[393] == nil)then
		msgId = 969;
	end
	local data = {
		playerid = userid,
		time = 10,
		msgId = msgId,
		msgParama = {name},
	};

	data.yesevt = function (id)
		ServiceNUserProxy.Instance:CallTwinsActionUserCmd(userid, 
			nil, 
			SceneUser2_pb.ETWINS_OPERATION_AGREE);
	end;
	data.noevt = function (id)
		ServiceNUserProxy.Instance:CallTwinsActionUserCmd(userid, 
			nil, 
			SceneUser2_pb.ETWINS_OPERATION_DISAGREE);
	end
	data.endevt = function (id)
		ServiceNUserProxy.Instance:CallTwinsActionUserCmd(userid, 
			nil, 
			SceneUser2_pb.ETWINS_OPERATION_DISAGREE);
	end

	self.conformCtl:AddInvite(InviteType.DoubleAction , data);
end

-- PVP集结糖浆传送邀请
function InviteConfirmView:HandleRecvInviteWithMe(note)
	local serverData = note.body;

	local messageId = 25521;
	if(Table_Sysmsg[25521] == nil)then
		messageId = 969;
		errorLog("Message ID: 25521 is not exist")
	end

	local data = {
		playerid = serverData.sendid,
		time = GameConfig.Team.inviteovertime,
		msgId = messageId,
		msgParama = {},
	};

	data.yesevt = function (id)
		ServiceNUserProxy.Instance:CallInviteWithMeUserCmd(serverData.sendid, 
			serverData.time, 
			true,
			serverData.sign);
	end;
	data.noevt = function (id)
			ServiceNUserProxy.Instance:CallInviteWithMeUserCmd(serverData.sendid, 
			serverData.time, 
			false,
			serverData.sign);
	end
	data.endevt = function (id)
			ServiceNUserProxy.Instance:CallInviteWithMeUserCmd(serverData.sendid, 
			serverData.time, 
			false,
			serverData.sign);
	end

	self.conformCtl:AddInvite(InviteType.InviteWithMe, data);
end

function InviteConfirmView:HandleAltmanInviteMsg(note)
	-- local userid, raid_type = note.body.userid, note.body.raid_type;
	
	local msgId = GameConfig.Altman.invite_msgid or 323;
	local data = {
		playerid = Game.Myself.data.id,
		time = 10,
		msgId = msgId,
	};

	-- if(raid_type ~= 31)then
	-- 	return;
	-- end


	data.yesevt = function (id)
		local myTeam = TeamProxy.Instance.myTeam;
		if(myTeam == nil)then
			redlog("No Team");
			return;
		end

		local nowleader = myTeam:GetNowLeader();
		if(nowleader == nil)then
			redlog("No Leader");
			return;
		end
		GameFacade.Instance:sendNotification(FollowEvent.Follow ,nowleader.id);
		ServiceTeamRaidCmdProxy.Instance:CallTeamRaidReplyCmd(true, Game.Myself.data.id, FuBenCmd_pb.ERAIDTYPE_ALTMAN);
	end
	data.noevt = function (id)
		ServiceTeamRaidCmdProxy.Instance:CallTeamRaidReplyCmd(false, Game.Myself.data.id, FuBenCmd_pb.ERAIDTYPE_ALTMAN);
	end

	self.conformCtl:AddInvite(InviteType.AltMan , data);
end
