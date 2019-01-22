PlayerTipFuncConfig = {
	SendMessage = {name = ZhString.FunctionPlayerTip_SendMessage, },
	InviteMember = {name = ZhString.FunctionPlayerTip_InviteMember, },
	ApplyTeam = {name = ZhString.FunctionPlayerTip_ApplyTeam, },
	AddFriend = {name = ZhString.FunctionPlayerTip_AddFriend, },
	ShowDetail = {name = ZhString.FunctionPlayerTip_ShowDetail, },
	SetLeader = {name = ZhString.FunctionPlayerTip_SetLeader, },
	KickMember = {name = ZhString.FunctionPlayerTip_KickMember, },
	LeaverTeam = {name = ZhString.FunctionPlayerTip_LeaverTeam, },
	FollowMember = {name = ZhString.FunctionPlayerTip_FollowMember, },
	CancelFollowMember = {name = ZhString.FunctionPlayerTip_CancelFollowMember, },
	CreateTeam = {name = ZhString.FunctionPlayerTip_CreateTeam, },
	JoinTeam = {name = ZhString.FunctionPlayerTip_JoinTeam, },
	InviteFriend = {name = ZhString.FunctionPlayerTip_InviteFriend, },
	InviteJoinHand = {name = ZhString.FunctionPlayerTip_InviteJoinHand, },
	CancelJoinHand = {name = ZhString.FunctionPlayerTip_CancelJoinHand, },
	ApplyList = {name = ZhString.FunctionPlayerTip_ApplyList, },
	GuildRecruit = {name = ZhString.FunctionPlayerTip_GuildRecruit, },
	GiveGift = {name = ZhString.FunctionPlayerTip_GiveGift, },
	DeleteFriend = {name = ZhString.FunctionPlayerTip_DeleteFriend, },
	ApplyEnterGuild = {name = ZhString.FunctionPlayerTip_ApplyEnterGuild, },
	InviteEnterGuild = {name = ZhString.FunctionPlayerTip_InviteEnterGuild, },
	KickGuildMember = {name = ZhString.FunctionPlayerTip_KickGuildMember, },
	DistributeArtifact = {name = ZhString.FunctionPlayerTip_DistributeArtifact ,},
	ChangeGuildJob = {name = ZhString.FunctionPlayerTip_ChangeGuildJob, },
	KickChatMember = {name = ZhString.FunctionPlayerTip_KickChatMember, },
	ExchangeRoomOwner = {name = ZhString.FunctionPlayerTip_ExchangeRoomOwner, },
	AddBlacklist = {name = ZhString.FunctionPlayerTip_AddBlacklist, },
	ForeverBlacklist = {name = ZhString.FunctionPlayerTip_ForeverBlacklist, },
	RemoveFromBlacklist = {name = ZhString.FunctionPlayerTip_RemoveFromBlacklist, },
	RemoveFromForeverBlacklist = {name = ZhString.FunctionPlayerTip_RemoveFromBlacklist, },
	FireHireman = {name = ZhString.FunctionPlayerTip_FireHireman, },
	ReHireCat = {name = ZhString.FunctionPlayerTip_ReHireCat,},
	Pet_GiveGift = {name = ZhString.FunctionPlayerTip_Pet_GiveGift},
	Pet_Touch = {name = ZhString.FunctionPlayerTip_Pet_Touch},
	Pet_CallBack = {name = ZhString.FunctionPlayerTip_Pet_CallBack},
	Pet_ShowDetail = {name = ZhString.FunctionPlayerTip_Pet_ShowDetail},
	Pet_Hug = {name = ZhString.FunctionPlayerTip_Pet_Hug},
	Pet_CancelHug = {name = ZhString.FunctionPlayerTip_Pet_CancelHug},
	Pet_AutoFight = {name = ZhString.FunctionPlayerTip_Pet_AutoFight},
	Tutor_InviteBeTutor = {name = ZhString.FunctionPlayerTip_Tutor_Tutor},
	Tutor_InviteBeStudent = {name = ZhString.FunctionPlayerTip_Tutor_Student},
	Tutor_DeleteTutor = {name = ZhString.FunctionPlayerTip_Tutor_DeleteTutor},
	Tutor_DeleteStudent = {name = ZhString.FunctionPlayerTip_Tutor_DeleteTutor},
	Wedding_MissYou = {name = ZhString.FunctionPlayerTip_WeddingMissYou},
	Wedding_CallBack = {name = ZhString.FunctionPlayerTip_WeddingCallBack},
	Double_Action = {name = ZhString.PlayerTip_DoubleAction},
	TalkAuthorization = {name = ZhString.FunctionPlayerTip_TalkAuthorization},
	Booth = {name = ZhString.FunctionPlayerTip_Booth},
}

PlayerTipFuncState = {
	Active = 1,
	InActive = 2,
	Grey = 3,
	Special = 4,
}

autoImport("RClickFuncCell");
autoImport("PlayerTip");
autoImport("RClickTip");
autoImport("ChatRoomProxy")
autoImport("PlayerTipData")
FunctionPlayerTip = class("FunctionPlayerTip")

local friend = {}

function FunctionPlayerTip.Me()
	if nil == FunctionPlayerTip.me then
		FunctionPlayerTip.me = FunctionPlayerTip.new()
	end
	return FunctionPlayerTip.me
end

function FunctionPlayerTip:ctor()
	self.funcMap = {};
	self.checkMap = {};

	self.funcMap.SendMessage = FunctionPlayerTip.SendMessage;
	self.funcMap.InviteMember = FunctionPlayerTip.InviteMember;
	self.funcMap.ApplyTeam = FunctionPlayerTip.ApplyTeam;
	self.funcMap.AddFriend = FunctionPlayerTip.AddFriend;
	self.funcMap.ShowTeam = FunctionPlayerTip.ShowTeam;
	self.funcMap.ShowDetail = FunctionPlayerTip.ShowDetail;
	self.funcMap.SetLeader = FunctionPlayerTip.SetLeader;
	self.funcMap.KickMember = FunctionPlayerTip.KickMember;
	self.funcMap.LeaverTeam = FunctionPlayerTip.LeaverTeam;
	self.funcMap.FollowMember = FunctionPlayerTip.FollowMember;
	self.funcMap.CancelFollowMember = FunctionPlayerTip.CancelFollowMember;
	self.funcMap.CreateTeam = FunctionPlayerTip.CreateTeam;
	self.funcMap.InviteFriend = FunctionPlayerTip.InviteFriend;
	self.funcMap.InviteJoinHand = FunctionPlayerTip.InviteJoinHand;
	self.funcMap.CancelJoinHand = FunctionPlayerTip.CancelJoinHand;
	self.funcMap.ApplyList = FunctionPlayerTip.ApplyList;
	self.funcMap.GuildRecruit = FunctionPlayerTip.GuildRecruit;
	self.funcMap.GiveGift = FunctionPlayerTip.GiveGift;
	self.funcMap.DeleteFriend = FunctionPlayerTip.DeleteFriend;
	self.funcMap.ApplyEnterGuild = FunctionPlayerTip.ApplyEnterGuild;
	self.funcMap.InviteEnterGuild = FunctionPlayerTip.InviteEnterGuild;
	self.funcMap.KickGuildMember = FunctionPlayerTip.KickGuildMember;
	self.funcMap.DistributeArtifact = FunctionPlayerTip.DistributeArtifact
	self.funcMap.ChangeGuildJob = FunctionPlayerTip.ChangeGuildJob;
	self.funcMap.KickChatMember = FunctionPlayerTip.KickChatMember;
	self.funcMap.ExchangeRoomOwner = FunctionPlayerTip.ExchangeRoomOwner;
	self.funcMap.AddBlacklist = FunctionPlayerTip.AddBlacklist
	self.funcMap.ForeverBlacklist = FunctionPlayerTip.ForeverBlacklist
	self.funcMap.RemoveFromBlacklist = FunctionPlayerTip.RemoveFromBlacklist
	self.funcMap.RemoveFromForeverBlacklist = FunctionPlayerTip.RemoveFromForeverBlacklist
	self.funcMap.FireHireman = FunctionPlayerTip.FireHireman
	self.funcMap.ReHireCat = FunctionPlayerTip.ReHireCat
	self.funcMap.Pet_GiveGift = FunctionPlayerTip.Pet_GiveGift
	self.funcMap.Pet_Touch = FunctionPlayerTip.Pet_Touch
	self.funcMap.Pet_CallBack = FunctionPlayerTip.Pet_CallBack
	self.funcMap.Pet_ShowDetail = FunctionPlayerTip.Pet_ShowDetail
	self.funcMap.Pet_Hug = FunctionPlayerTip.Pet_Hug
	self.funcMap.Pet_CancelHug = FunctionPlayerTip.Pet_CancelHug
	self.funcMap.Pet_AutoFight = FunctionPlayerTip.Pet_AutoFight
	self.funcMap.Tutor_InviteBeTutor = FunctionPlayerTip.Tutor_InviteBeTutor
	self.funcMap.Tutor_InviteBeStudent = FunctionPlayerTip.Tutor_InviteBeStudent
	self.funcMap.Tutor_DeleteTutor = FunctionPlayerTip.Tutor_DeleteTutor
	self.funcMap.Tutor_DeleteStudent = FunctionPlayerTip.Tutor_DeleteStudent
	self.funcMap.Wedding_MissYou = FunctionPlayerTip.Wedding_MissYou
	self.funcMap.Wedding_CallBack = FunctionPlayerTip.Wedding_CallBack
	self.funcMap.Double_Action = FunctionPlayerTip.Double_Action
	self.funcMap.TalkAuthorization  = FunctionPlayerTip.TalkAuthorization
	self.funcMap.Booth = FunctionPlayerTip.Booth

	self.checkMap.ChangeGuildJob = FunctionPlayerTip.CheckChangeGuildJob;
	self.checkMap.KickGuildMember = FunctionPlayerTip.CheckKickGuildMember;
	self.checkMap.DistributeArtifact = FunctionPlayerTip.CheckDistributeArtifact;
	self.checkMap.InviteEnterGuild = FunctionPlayerTip.CheckInviteEnterGuild;
	self.checkMap.ApplyEnterGuild = FunctionPlayerTip.CheckApplyEnterGuild;
	self.checkMap.InviteMember = FunctionPlayerTip.CheckInviteMember;
	self.checkMap.ForeverBlacklist = FunctionPlayerTip.CheckForeverBlacklist;
	self.checkMap.KickMember = FunctionPlayerTip.CheckKickMember;
	self.checkMap.FireHireman = FunctionPlayerTip.CheckFireHireman;
	self.checkMap.ReHireCat = FunctionPlayerTip.CheckReHireCat;
	self.checkMap.Pet_Hug = FunctionPlayerTip.CheckPet_Hug;
	self.checkMap.Pet_CancelHug =FunctionPlayerTip.CheckCancelPet_Hug;
	self.checkMap.Pet_AutoFight = FunctionPlayerTip.CheckPet_AutoFight
	self.checkMap.Tutor_InviteBeTutor = FunctionPlayerTip.CheckTutor_InviteBeTutor
	self.checkMap.Tutor_InviteBeStudent = FunctionPlayerTip.CheckTutor_InviteBeStudent
	self.checkMap.Wedding_MissYou = FunctionPlayerTip.CheckWedding_MissYou
	self.checkMap.Wedding_CallBack = FunctionPlayerTip.CheckWedding_CallBack
	self.checkMap.Double_Action = FunctionPlayerTip.CheckDouble_Action
	self.checkMap.TalkAuthorization = FunctionPlayerTip.CheckTalkAuthorization
	self.checkMap.Booth = FunctionPlayerTip.CheckBooth
end

function FunctionPlayerTip:GetPlayerFunckey(playerid)
	local result = {};
	result[3] = "SendMessage";
	if(not FriendProxy.Instance:IsFriend(playerid))then
		result[4] = "AddFriend";
	end
	if(FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.TeamMemberListPopUp.id))then
		result[1] = "InviteMember";
	end

	if(TeamProxy.Instance:IHaveTeam())then
		local myTeam = TeamProxy.Instance.myTeam;
		local teamMember = myTeam:GetMemberByGuid(playerid);
		if(teamMember)then
			local online = not teamMember:IsOffline();
			local imleader = TeamProxy.Instance:CheckIHaveLeaderAuthority();
			if(imleader)then
				result[5] = "SetLeader";
				result[6] = "KickMember";
			end
			if(online)then
				-- Hand In Hand
				local attriFunction = Game.Myself.data:GetProperty("AttrFunction")
				local pos = CommonFun.AttrFunction.HandEnable or 1;
				local serverCanJoinHand = (attriFunction >> (pos-1)) & 1 == 1;
				-- Follow and handinhand
				local followId = Game.Myself:Client_GetFollowLeaderID();
				if(followId == playerid)then
					local isHandFollow = Game.Myself:Client_IsFollowHandInHand();
					if(isHandFollow)then
						result[2] = "FollowMember";						
						result[7] = "CancelJoinHand";
					else
						result[2] = "CancelFollowMember";
						if(serverCanJoinHand)then
							local handFollowerId = Game.Myself:Client_GetHandInHandFollower();
							if(handFollowerId == playerid)then
								result[7] = "CancelJoinHand";
							else
								result[7] = "InviteJoinHand";
							end
						end
					end
				else
					local handFollowerId = Game.Myself:Client_GetHandInHandFollower();
					if(handFollowerId == playerid)then
						result[2] = "FollowMember";
						result[7] = "CancelJoinHand";
					else
						result[2] = "FollowMember";
						if(serverCanJoinHand)then
							result[7] = "InviteJoinHand";
						end
					end
				end
			end
		end
	end

	local hasGuild = GuildProxy.Instance:IHaveGuild();
	if(hasGuild)then
		result[9] = "InviteEnterGuild";
		result[15] = "TalkAuthorization";
	else
		result[8] = "ApplyEnterGuild";
	end
	
	result[10] = "ShowDetail";

	result[11] = "Tutor_InviteBeStudent";
	result[12] = "Tutor_InviteBeTutor";

	result[13] = "AddBlacklist";
	result[14] = "DistributeArtifact";

	
	local resultlist = {};
	for i=1,15 do
		if(result[i])then
			table.insert(resultlist, result[i]);
		end
	end
	return resultlist;
end

function FunctionPlayerTip:GetPlayerTip(stick, side, offset,data)
	TipsView.Me():ShowStickTip(PlayerTip, data, side, stick, offset, "PlayerTip");
	return TipsView.Me().currentTip;
end

function FunctionPlayerTip:CurPlayerTip()
	local playerTip = TipsView.Me().currentTip;
	if(playerTip and playerTip.__cname == "PlayerTip")then
		return playerTip;
	end
end

function FunctionPlayerTip:CloseTip()
	if(self:CurPlayerTip())then
		TipsView.Me():HideCurrent();
	end
end

function FunctionPlayerTip:CheckTipFuncStateByKey( key, playerTipData )
	if(self.checkMap[key])then
		return  self.checkMap[key](playerTipData);
	end
	return PlayerTipFuncState.Active;
end





function FunctionPlayerTip:GetFuncByKey(key)
	return self.funcMap[key];
end

-- TipFunc Implmented begin
function FunctionPlayerTip.SendMessage(ptdata)
	if(ptdata)then
		local tempArray = ReusableTable.CreateArray()
		tempArray[1] = ptdata.id
		ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Chat)
		ReusableTable.DestroyArray(tempArray)
		
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ChatRoomPage, viewdata = { key = "PrivateChat"}})
		GameFacade.Instance:sendNotification(ChatRoomEvent.UpdateSelectChat , ptdata)
	end
end

function FunctionPlayerTip.CallAddFriend(id, name)
	if FriendProxy.Instance:IsInBlacklist(id) then
		MsgManager.ConfirmMsgByID(427, function ()
			TableUtility.ArrayClear(friend)
			table.insert(friend,id)
			FriendProxy.Instance:CallAddFriend(friend)

			MsgManager.ShowMsgByID(461,name)
		end, nil,nil,name)
	else
		TableUtility.ArrayClear(friend)
		table.insert(friend,id)
		FriendProxy.Instance:CallAddFriend(friend)
	end
end

function FunctionPlayerTip.AddFriend(ptdata)
	if(ptdata)then
		FunctionPlayerTip.CallAddFriend(ptdata.id, ptdata.name)
		-- table.insert(friend,ptdata.id)
		-- FriendProxy.Instance:CallAddFriend(friend);
	end
end

function FunctionPlayerTip.DeleteFriend(ptdata)
	if ptdata ~= nil then
		MsgManager.ConfirmMsgByID(415, function ()
			FunctionSecurity.Me():DeleteFriend(function (arg)
				ServiceSessionSocialityProxy.Instance:CallRemoveRelation(arg, SocialManager.PbRelation.Friend)
			end, ptdata.id)
		end, nil,nil,"Lv."..ptdata.level.." "..ptdata.name)
	end
end

function FunctionPlayerTip.ShowDetail(ptdata)
	if(ptdata.cat and ptdata.cat~=0)then
		local data = {
			staticData = Table_MercenaryCat[ptdata.cat],
			expiretime = ptdata.expiretime,
			masterid = ptdata.masterid,
		};
		TipManager.Instance:ShowCatTip(data,nil,nil,{-100,0});
	elseif(ptdata.id)then
		ServiceChatCmdProxy.Instance:CallQueryUserInfoChatCmd(ptdata.id, nil, ChatCmd_pb.EUSERINFOTYPE_CHAT) 
	end
end

function FunctionPlayerTip.InviteMember(ptdata)
	if(ptdata)then
		if ptdata.zoneid and MyselfProxy.Instance:GetZoneId() ~= ptdata.zoneid then
			MsgManager.ShowMsgByID(350)
			return;
		end

		local isInTeam = TeamProxy.Instance:IsInMyTeam(ptdata.id);
		if(not isInTeam)then
			ServiceSessionTeamProxy.Instance:CallInviteMember(ptdata.id, ptdata.cat)
		else
			MsgManager.ShowMsgByIDTable(333);
		end
	end
end

function FunctionPlayerTip.ApplyTeam(ptdata)
	if(ptdata and ptdata.teamid)then
		if ptdata.zoneid and MyselfProxy.Instance:GetZoneId() ~= ptdata.zoneid then
			MsgManager.ShowMsgByID(350)
			return;
		end
		
		ServiceSessionTeamProxy.Instance:CallTeamMemberApply(ptdata.teamid);
	end
end

function FunctionPlayerTip.SetLeader(ptdata)
	if(ptdata.id)then
		MsgManager.ConfirmMsgByID(327, function ()
			ServiceSessionTeamProxy.Instance:CallExchangeLeader(ptdata.id); 
		end, nil, nil, ptdata.name)
	end
end

function FunctionPlayerTip.KickMember(ptdata)
	if(ptdata.id)then
		-- if(ptdata.cat and ptdata.cat~=0)then
		-- 	if(TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:CheckIHaveLeaderAuthority())then

		-- 	end
		-- end
		MsgManager.ConfirmMsgByID(326, function ()
			if(ptdata.cat~=nil and ptdata.cat~=0)then
				ServiceSessionTeamProxy.Instance:CallKickMember(ptdata.id, ptdata.cat); 
			else
				ServiceSessionTeamProxy.Instance:CallKickMember(ptdata.id); 
			end
		end, nil, nil, ptdata.name)
	end
end

function FunctionPlayerTip.LeaverTeam(ptdata)
	if(TeamProxy.Instance:IHaveTeam())then
		if(Game.MapManager:IsPVPMode_MvpFight())then
			MsgManager.ConfirmMsgByID(7312, function ()
				if(TeamProxy.Instance:IHaveTeam())then
					ServiceSessionTeamProxy.Instance:CallExitTeam(TeamProxy.Instance.myTeam.id);
				end
			end, nil, nil)
			return;
		end

		MsgManager.ConfirmMsgByID(328, function ()
			if(TeamProxy.Instance:IHaveTeam())then
				ServiceSessionTeamProxy.Instance:CallExitTeam(TeamProxy.Instance.myTeam.id);
			end
		end, nil, nil, TeamProxy.Instance.myTeam.name)
	end
end

function FunctionPlayerTip.ShowMyDetail(ptdata)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.Charactor});
end

function FunctionPlayerTip.FollowMember(ptdata)
	if(not ptdata or not ptdata.id)then
		return;
	end
	if(Game.Myself:IsDead())then
		MsgManager.ShowMsgByIDTable(2500);
		return;
	end
	if(ptdata.zoneid ~= MyselfProxy.Instance:GetZoneId())then
		MsgManager.ShowMsgByIDTable(3056);
		return;
	end

	local myTeam = TeamProxy.Instance.myTeam;
	if(myTeam == nil)then
		MsgManager.ShowMsgByIDTable(332);
		return;
	end
	local teamMemberData = myTeam:GetMemberByGuid(ptdata.id);
	if(teamMemberData == nil)then
		return;
	end
	if(teamMemberData.mapid == 51)then
		MsgManager.ShowMsgByIDTable(121);
		return;
	end

	GameFacade.Instance:sendNotification(FollowEvent.Follow ,ptdata.id);
end

function FunctionPlayerTip.CancelFollowMember(ptdata)
	if(ptdata)then
		Game.Myself:Client_SetFollowLeader(0);
	end
end

function FunctionPlayerTip.CreateTeam(ptdata)
	if(not TeamProxy.Instance:IHaveTeam())then
		local defaultMinlv,defaulttarget = 1,10000;
		local defaultMaxlv = GameConfig.Team.filtratelevel[#GameConfig.Team.filtratelevel];
		local defaultname = Game.Myself.data.name..GameConfig.Team.teamname;
		ServiceSessionTeamProxy.Instance:CallCreateTeam(defaultMinlv, defaultMaxlv, defaulttarget, false, defaultname);
	end
end

function FunctionPlayerTip.ApplyList(ptdata)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamApplyListPopUp});
end

function FunctionPlayerTip.InviteFriend(ptdata)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamInvitePopUp}) 
end

function FunctionPlayerTip.InviteJoinHand(ptdata)
	local haveTeam = TeamProxy.Instance:IHaveTeam();
	local myTeamData = TeamProxy.Instance.myTeam;
	local tmData = myTeamData and myTeamData:GetMemberByGuid(ptdata.id);
	
	if(ptdata.masterid ~= nil)then
		if(ptdata.masterid ~= nil and ptdata.masterid == Game.Myself.data.id)then
			local myTeamData = TeamProxy.Instance.myTeam;
			if(myTeamData)then
				local catTeamData = myTeamData:GetMemberByGuid(ptdata.id);
				if(catTeamData)then
					if(Game.Myself:IsDead())then
						MsgManager.ShowMsgByIDTable(5005);
						return;
					end

					local expiretime = catTeamData.expiretime;
					if(expiretime~=0 and ServerTime.CurServerTime()/1000 > expiretime)then
						MsgManager.ShowMsgByIDTable(5005);
						return;
					end

					local resttime = catTeamData.resttime;
					if(resttime~=0 and ServerTime.CurServerTime()/1000 <= resttime)then
						MsgManager.ShowMsgByIDTable(5005);
						return;
					end
				end
			end
		end
		ServiceUserEventProxy.Instance:CallHandCatUserEvent(ptdata.id, false);
	elseif(haveTeam and tmData)then
		if(tmData.hp and tmData.hp <= 0)then
			MsgManager.ShowMsgByIDTable(856);
			return;
		end

		local role = NSceneUserProxy.Instance:Find(ptdata.id);
		if(role)then
			local isTransformed = role.data:IsTransformed();
			if(isTransformed)then
				MsgManager.ShowMsgByIDTable(830);
				return;
			end
		end
			 
		ServiceNUserProxy.Instance:CallInviteJoinHandsUserCmd(ptdata.id);
	else
		MsgManager.ShowMsgByIDTable(827);
	end
end

function FunctionPlayerTip.CancelJoinHand(ptdata)
	MsgManager.ConfirmMsgByID(826, function ()
		if(ptdata.masterid ~= nil and ptdata.masterid == Game.Myself.data.id)then
			ServiceUserEventProxy.Instance:CallHandCatUserEvent(ptdata.id, true);
		else
			ServiceNUserProxy.Instance:CallBreakUpHandsUserCmd();
		end
	end, nil,nil);
end

function FunctionPlayerTip.ShowTeam(ptdata)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamMemberListPopUp}) 
end

function FunctionPlayerTip.ChangeGuildJob(ptdata)
	local myGuildMemberData = GuildProxy.Instance:GetMyGuildMemberData()
	if(myGuildMemberData)then
		local canDo = GuildProxy.Instance:CanJobDoAuthority(myGuildMemberData.job, GuildAuthorityMap.SetJob);
		if(canDo)then
			local viewdata = {
				view = PanelConfig.GuildJobChangePopUp, 
				viewdata = {guildMember = ptdata.parama},
			};
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel, viewdata);
		end
	end
end

function FunctionPlayerTip.KickGuildMember(ptdata)
	local member = ptdata.parama;
	if(member)then
		MsgManager.ConfirmMsgByID(2800, function ()
			ServiceGuildCmdProxy.Instance:CallKickMemberGuildCmd(member.id) 
		end, nil, self, member.baselevel, member.name);
	end
end

function FunctionPlayerTip.DistributeArtifact(ptdata)
	if(not ptdata or not ptdata.id)then
		return;
	end

	local artiData = ArtifactProxy.Instance:GetOptionalArtifacts(ptdata.id)
	if(artiData and #artiData>0)then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ArtifactDistributePopUp,viewdata = {data=artiData,charID=ptdata.id}})
	else
		MsgManager.ShowMsgByID(3806)
	end
end

function FunctionPlayerTip.ApplyEnterGuild( ptdata )
	if(GuildProxy.Instance:IsInJoinCD())then
		MsgManager.ShowMsgByIDTable(4046)
		return;
	end
	
	local role = NSceneUserProxy.Instance:Find(ptdata.id);
	if(role)then
		local guildData = role.data:GetGuildData();
		if(guildData and guildData.id)then
			ServiceGuildCmdProxy.Instance:CallApplyGuildGuildCmd(guildData.id) 
		end
	end
end

function FunctionPlayerTip.InviteEnterGuild( ptdata )
	if(ptdata)then
		if ptdata.zoneid and MyselfProxy.Instance:GetZoneId() ~= ptdata.zoneid then
			MsgManager.ShowMsgByID(350)
			return
		end
		
		ServiceGuildCmdProxy.Instance:CallInviteMemberGuildCmd(ptdata.id);
	end
end

function FunctionPlayerTip.KickChatMember(ptdata)
	if(ptdata)then
		if (not ChatZoomProxy.Instance:SomeoneIsInZoom(ptdata.id)) then
			MsgManager.ShowMsgByID(809)
		else
			local zoomInfo = ChatZoomProxy.Instance:CachedZoomInfo()
			ServiceChatRoomProxy.Instance:CallKickChatMember(zoomInfo.roomid, ptdata.id)
		end
	end
end

function FunctionPlayerTip.ExchangeRoomOwner(ptdata)
	if(ptdata)then
		if (not ChatZoomProxy.Instance:SomeoneIsInZoom(ptdata.id)) then
			MsgManager.ShowMsgByID(809)
		else
			ServiceChatRoomProxy.Instance:CallExchangeRoomOwner(ptdata.id)
		end
	end
end

function FunctionPlayerTip.AddBlacklist(ptdata)
	if ptdata and ptdata.id then
		if FriendProxy.Instance:IsBlacklist(ptdata.id) then
			MsgManager.ShowMsgByID(464)
		else
			local name = ptdata.name or ""
			MsgManager.ConfirmMsgByID(425, function ()
				local tempArray = ReusableTable.CreateArray()
				tempArray[1] = ptdata.id
				ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Black)
				ReusableTable.DestroyArray(tempArray)
			end, nil,nil,name)
		end
	end
end

function FunctionPlayerTip.ForeverBlacklist(ptdata)
	if ptdata and ptdata.id then
		local name = ptdata.name or ""
		MsgManager.ConfirmMsgByID(426, function ()
			local tempArray = ReusableTable.CreateArray()
			tempArray[1] = ptdata.id
			ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.BlackForever)
			ReusableTable.DestroyArray(tempArray)
		end, nil,nil,name)
	end
end

function FunctionPlayerTip.RemoveFromBlacklist(ptdata)
	if ptdata and ptdata.id then
		local name = ptdata.name or ""
		ServiceSessionSocialityProxy.Instance:CallRemoveRelation(ptdata.id, SocialManager.PbRelation.Black)
		MsgManager.ShowMsgByID(461,name)
	end
end

function FunctionPlayerTip.RemoveFromForeverBlacklist(ptdata)
	if ptdata and ptdata.id then
		local name = ptdata.name or ""
		ServiceSessionSocialityProxy.Instance:CallRemoveRelation(ptdata.id, SocialManager.PbRelation.BlackForever)
		MsgManager.ShowMsgByID(461,name)
	end
end

function FunctionPlayerTip.FireHireman(ptdata)
	if(ptdata.cat)then
		MsgManager.ConfirmMsgByID(5002,function ()
			ServiceScenePetProxy.Instance:CallFireCatPetCmd(ptdata.cat)
		end , nil , nil)
	end
end

function FunctionPlayerTip.ReHireCat(ptdata)
	if(ptdata.cat)then
		GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "HireCatPopUp", catid = ptdata.cat});
	end
end

local tempParam = {};
function FunctionPlayerTip.Pet_GiveGift(ptdata)
	local myPetInfo = PetProxy.Instance:GetMyPetInfoData(ptdata.petid);
	local giftItems = myPetInfo:GetGiftItems();
	local _,itemid = next(giftItems);

	local item = BagProxy.Instance:GetItemByStaticID(itemid)
	if(item and item.num > 0)then
		local dont = LocalSaveProxy.Instance:GetDontShowAgain(9015)
		if(dont == nil)then
			MsgManager.DontAgainConfirmMsgByID(9015, function ()
				ServiceScenePetProxy.Instance:CallGiveGiftPetCmd(myPetInfo.petid, item.id);
			end, nil, nil, item.staticData.NameZh, myPetInfo.name);
		else
			ServiceScenePetProxy.Instance:CallGiveGiftPetCmd(myPetInfo.petid, item.id);
		end
	else
		TableUtility.TableClear(tempParam);
		tempParam[1] = Table_Item[itemid].NameZh;
		MsgManager.ShowMsgByIDTable(9000, tempParam);
	end
end

function FunctionPlayerTip.Pet_Touch(ptdata)
	local petData = Table_Pet[ptdata.petid];
	local skillID = petData and petData.TouchSkill or 10000;

	local target = PetProxy.Instance:GetMySceneNpet(ptdata.petid)
	if(target)then
		Game.Myself:Client_UseSkill(skillID, target);
	end
end

function FunctionPlayerTip.Pet_CallBack(ptdata)
	if(ptdata.beingid)then
		ServiceSceneBeingProxy.Instance:CallBeingOffCmd(ptdata.beingid) 
	elseif(ptdata.petid)then
		MsgManager.ConfirmMsgByID(9005, function ()
			ServiceScenePetProxy.Instance:CallEggRestorePetCmd(ptdata.petid);
		end, nil,nil)
	else
		helplog("Pet_CallBack Not Find id.");
	end
end

function FunctionPlayerTip.Pet_ShowDetail(ptdata)
	if(ptdata.petid)then
		local scenePet = PetProxy.Instance:GetMySceneNpet(ptdata.petid)
		if(scenePet == nil)then
			MsgManager.ShowMsgByIDTable(9007);
			return;
		end

		local petInfoData = PetProxy.Instance:GetMyPetInfoData(ptdata.petid);
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.PetInfoView, viewdata = {petInfoData = petInfoData}});

	elseif(ptdata.beingid)then
		local sceneBeing = PetProxy.Instance:GetSceneBeingNpc(ptdata.beingid)
		if(sceneBeing == nil)then
			MsgManager.ShowMsgByIDTable(9007);
			return;
		end

		local beingInfoData = PetProxy.Instance:GetMySummonBeingInfo(ptdata.beingid);
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.BeingInfoView, viewdata = {beingInfoData = beingInfoData}});
	end
end

function FunctionPlayerTip.Pet_Hug(ptdata)
	if(Game.Myself.data:IsTransformed())then
		MsgManager.ShowMsgByIDTable(830);
		return;
	end
	local handNpc = Game.Myself:GetHandNpc();
	if(handNpc)then
		MsgManager.ShowMsgByIDTable(856);
		return;
	end
	local petInfoData = PetProxy.Instance:GetMyPetInfoData(ptdata.petid);
	if(petInfoData:CanHug())then
		ServiceScenePetProxy.Instance:CallHandPetPetCmd(petInfoData.guid, false);
	end
end

function FunctionPlayerTip.Pet_CancelHug(ptdata)
	local petInfoData = PetProxy.Instance:GetMyPetInfoData(ptdata.petid);
	ServiceScenePetProxy.Instance:CallHandPetPetCmd(petInfoData.guid, true);
end

function FunctionPlayerTip.Pet_AutoFight(ptdata)
	if(ptdata.petid)then
		-- local npet = 
		local myPetInfo = PetProxy.Instance:GetMyPetInfoData(ptdata.petid);
		if(myPetInfo)then
			ServiceScenePetProxy.Instance:CallSwitchSkillPetCmd(ptdata.petid, not myPetInfo:IsAutoFighting());
		end
	elseif(ptdata.beingid)then
		local beingInfo = PetProxy.Instance:GetMySummonBeingInfo(ptdata.beingid);
		if(beingInfo)then
			ServiceSceneBeingProxy.Instance:CallBeingSwitchState(ptdata.beingid, not beingInfo:IsAutoFighting())
		end
	end
end

function FunctionPlayerTip.Tutor_InviteBeTutor(ptdata)
	helplog("Tutor_InviteBeTutor:", ptdata.id);
	TutorProxy.Instance:CallAddStudent(ptdata.id)
end

function FunctionPlayerTip.Tutor_InviteBeStudent(ptdata)
	helplog("Tutor_InviteBeStudent:", ptdata.id);
	TutorProxy.Instance:CallAddTutor(ptdata.id)
end

function FunctionPlayerTip.Tutor_DeleteTutor(ptdata)
	TutorProxy.Instance:CallDeleteTutor(ptdata.id)
end

function FunctionPlayerTip.Tutor_DeleteStudent(ptdata)
	TutorProxy.Instance:CallDeleteStudent(ptdata.id)
end

function FunctionPlayerTip.Wedding_MissYou(ptdata)
	helplog("Call Missyou InviteWedCCmd");
	ServiceWeddingCCmdProxy.Instance:CallMissyouInviteWedCCmd();
	-- local skillId = 2000001;
	-- Game.Myself:Client_UseSkill(skillId)
end

function FunctionPlayerTip.Wedding_CallBack(ptdata)
	helplog("Call CallBack");
	local skillId = GameConfig.Wedding.BackSkill_Id or 13001;
	Game.Myself:Client_UseSkill(skillId)
end

function FunctionPlayerTip.Double_Action(ptdata)
	helplog("Implmented In 'PlayerTip'. ");
end

function FunctionPlayerTip.Booth(ptdata)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.BoothMainView, viewdata = {playerID = ptdata.id}})
end
-- TipFunc end
function FunctionPlayerTip.TalkAuthorization(ptdata)
	helplog("---FunctionPlayerTip.TalkAuthorization(ptdata)---");

	local myGuildData = GuildProxy.Instance.myGuildData
    local guildMemberData = myGuildData:GetMemberByGuid(ptdata.id);
    if guildMemberData:IsRealtimevoice() then
    	helplog("??????????????? ServiceGuildCmdProxy.Instance:CallOpenRealtimeVoiceGuildCmd(ptdata.id,false)")
    	ServiceGuildCmdProxy.Instance:CallOpenRealtimeVoiceGuildCmd(ptdata.id,false)
    else
    	helplog("???????????? ServiceGuildCmdProxy.Instance:CallOpenRealtimeVoiceGuildCmd(ptdata.id,true)")
    	ServiceGuildCmdProxy.Instance:CallOpenRealtimeVoiceGuildCmd(ptdata.id,true)
    end	
end

-- TipFunc Check begin
function FunctionPlayerTip.CheckIHasGuildAuthority(aid)
	local canDo = false;
	local myGuildMemberData = GuildProxy.Instance:GetMyGuildMemberData()
	if(myGuildMemberData)then
		canDo = GuildProxy.Instance:CanJobDoAuthority(myGuildMemberData.job, aid);
	end
	if(canDo)then
		return PlayerTipFuncState.Active;
	else
		return PlayerTipFuncState.InActive;
	end
end

function FunctionPlayerTip.CheckChangeGuildJob(data)
	return FunctionPlayerTip.CheckIHasGuildAuthority(GuildAuthorityMap.SetJob)
end

function FunctionPlayerTip.CheckKickGuildMember(data)
	return FunctionPlayerTip.CheckIHasGuildAuthority(GuildAuthorityMap.KickMember)
end

function FunctionPlayerTip.CheckDistributeArtifact(data)
	--todo xde ??????????????????????????????
	if(GameConfig.SystemForbid.GvGDroiyan) then
		return PlayerTipFuncState.InActive;
	end

	local myGuildData = GuildProxy.Instance.myGuildData
	if(myGuildData)then
		local guildMemberData = myGuildData:GetMemberByGuid(data.id);
		local switch = ArtifactProxy.Instance:GetDistributeActiveFlag()
		if(guildMemberData and switch)then
			return  FunctionPlayerTip.CheckIHasGuildAuthority(GuildAuthorityMap.ArtifactOption)
		end
	end
	return PlayerTipFuncState.InActive;
end

function FunctionPlayerTip.CheckInviteEnterGuild(data)
	return FunctionPlayerTip.CheckIHasGuildAuthority(GuildAuthorityMap.InviteJoin)
end

function FunctionPlayerTip.CheckApplyEnterGuild(data)
	local canDo = false;
	if(data)then
		canDo = data.guildid~=nil and data.guildid~=0;
	end
	if(canDo)then
		return PlayerTipFuncState.Active;
	else
		return PlayerTipFuncState.InActive;
	end
end

function FunctionPlayerTip.CheckInviteMember(data)
	if(TeamProxy.Instance:IsInMyTeam(data.id))then
		return PlayerTipFuncState.InActive;
	else
		ServiceSessionTeamProxy.Instance:CallQueryUserTeamInfoTeamCmd(data.id)
		return PlayerTipFuncState.Active;
	end
end

function FunctionPlayerTip.CheckForeverBlacklist(data)
	return PlayerTipFuncState.Special;
end

function FunctionPlayerTip.CheckKickMember(data)
	if(data.cat and data.masterid == Game.Myself.data.id)then
		return PlayerTipFuncState.Active;
	end
	if(TeamProxy.Instance:CheckIHaveLeaderAuthority())then
		return PlayerTipFuncState.Active;
	end
	return PlayerTipFuncState.InActive;
end

function FunctionPlayerTip.CheckFireHireman(data)
	if(data.masterid ~= nil and data.masterid == Game.Myself.data.id)then
		local myTeamData = TeamProxy.Instance.myTeam;
		if(myTeamData)then
			local catTeamData = myTeamData:GetMemberByGuid(data.id);
			if(catTeamData)then
				local expiretime = catTeamData.expiretime;
				if(expiretime~=0 and ServerTime.CurServerTime()/1000 < expiretime)then
					return PlayerTipFuncState.Active;
				end
			end
		end
	end
	return PlayerTipFuncState.InActive;
end

function FunctionPlayerTip.CheckReHireCat(data)
	if(data.masterid ~= nil and data.masterid == Game.Myself.data.id)then
		local myTeamData = TeamProxy.Instance.myTeam;
		if(myTeamData)then
			local catTeamData = myTeamData:GetMemberByGuid(data.id);
			if(catTeamData)then
				local expiretime = catTeamData.expiretime;
				if(expiretime~=0 and ServerTime.CurServerTime()/1000 >= expiretime)then
					return PlayerTipFuncState.Active;
				end
			end
		end
	end
	return PlayerTipFuncState.InActive;
end

function FunctionPlayerTip.CheckPet_Hug(data)
	local petInfoData = PetProxy.Instance:GetMyPetInfoData(data.petid);
	if(petInfoData:CanHug())then
		local scenePet = PetProxy.Instance:GetMySceneNpet(petid)
		local otherName;
		if(scenePet and scenePet.data:GetFeature_BeHold())then
			otherName = ZhString.FunctionPlayerTip_Pet_Hug;
		else
			otherName = ZhString.FunctionPlayerTip_Pet_HandInHand;
		end
		return PlayerTipFuncState.Active, otherName;
	end
	return PlayerTipFuncState.InActive;
end

function FunctionPlayerTip.CheckCancelPet_Hug(data)
	local petInfoData = PetProxy.Instance:GetMyPetInfoData(data.petid);

	local otherName;
	if(petInfoData)then
		local scenePet = PetProxy.Instance:GetMySceneNpet(petid)
		if(scenePet and scenePet.data:GetFeature_BeHold())then
			otherName = ZhString.FunctionPlayerTip_Pet_CancelHug;
		else
			otherName = ZhString.FunctionPlayerTip_Pet_CancelHandInHand;
		end
	end

	return PlayerTipFuncState.Active, otherName;
end

function FunctionPlayerTip.CheckTutor_InviteBeTutor(ptdata)
	-- local reqlv = GameConfig.Tutor and GameConfig.Tutor.student_baselv_req or 10;
	-- local mylv = MyselfProxy.Instance:RoleLevel();
	-- if(mylv < reqlv)then
	-- 	return PlayerTipFuncState.InActive;
	-- end

	-- local reqtutorlv = GameConfig.Tutor and GameConfig.Tutor.tutor_baselv_req or 80;
	-- if(mylv > reqtutorlv)then
	-- 	return PlayerTipFuncState.InActive;
	-- end

	if (GameConfig.SystemForbid.Tutor) then
		return PlayerTipFuncState.InActive;
	end

	local mytutor = TutorProxy.Instance:GetMyTutor()
	if(mytutor ~= nil)then
		return PlayerTipFuncState.InActive;
	end

	if(TutorProxy.Instance:CanAsStudent())then
		return PlayerTipFuncState.Active;
	end

	return PlayerTipFuncState.InActive;
end

function FunctionPlayerTip.CheckTutor_InviteBeStudent(ptdata)
	-- local mytutor = TutorProxy.Instance:GetMyTutor()
	-- if(mytutor ~= nil)then
	-- 	return PlayerTipFuncState.InActive;
	-- end

	-- local reqlv = GameConfig.Tutor and GameConfig.Tutor.tutor_baselv_req or 80;
	-- local mylv = MyselfProxy.Instance:RoleLevel();
	-- if(mylv <= reqlv)then
	-- 	return PlayerTipFuncState.InActive;
	-- end
	
	if (GameConfig.SystemForbid.Tutor) then
		return PlayerTipFuncState.InActive;
	end

	if(TutorProxy.Instance:CanAsTutor())then
		return PlayerTipFuncState.Active;
	end

	return PlayerTipFuncState.InActive;
end

function FunctionPlayerTip.CheckPet_AutoFight(ptdata)
	if(ptdata == nil)then
		return PlayerTipFuncState.InActive;
	end

	local myPetInfo = nil
	if(ptdata.petid)then
		myPetInfo = PetProxy.Instance:GetMyPetInfoData(ptdata.petid);
	elseif(ptdata.beingid)then
		myPetInfo = PetProxy.Instance:GetMySummonBeingInfo(ptdata.beingid);
	end

	if(myPetInfo == nil)then
		return PlayerTipFuncState.InActive;
	end

	if(myPetInfo:IsAutoFighting())then
		return PlayerTipFuncState.Active, ZhString.FunctionPlayerTip_Pet_CancelAutoFight;
	else
		return PlayerTipFuncState.Active, ZhString.FunctionPlayerTip_Pet_AutoFight;
	end
end

function FunctionPlayerTip.CheckWedding_MissYou(ptdata)
	if(WeddingProxy.Instance:IsSelfMarried())then
		return PlayerTipFuncState.Active;
	end
	return PlayerTipFuncState.InActive;
end

function FunctionPlayerTip.CheckWedding_CallBack(ptdata)
	-- if(WeddingProxy.Instance:IsSelfMarried())then
	-- 	return PlayerTipFuncState.Active;
	-- end
	return PlayerTipFuncState.InActive;
end

function FunctionPlayerTip.CheckDouble_Action(ptdata)
	if(GameConfig.SystemForbid.DoubleAction)then
		return PlayerTipFuncState.InActive;
	end
	if(not TeamProxy.Instance:IHaveTeam())then
		return PlayerTipFuncState.InActive;
	end
	if(not TeamProxy.Instance:IsInMyTeam(ptdata.id))then
		return PlayerTipFuncState.InActive;
	end
	return PlayerTipFuncState.Active;
end

function FunctionPlayerTip.CheckBooth(ptdata)
	local player = NSceneUserProxy.Instance:Find(ptdata.id)
	if player ~= nil and player:IsInBooth() then
		return PlayerTipFuncState.Active
	end
	return PlayerTipFuncState.InActive
end
-- TipFunc Check end
function FunctionPlayerTip.CheckTalkAuthorization(ptdata)
	helplog("---FunctionPlayerTip.TalkAuthorization(ptdata)---");

	local myGuildData = GuildProxy.Instance.myGuildData
	local guildMemberData = nil

	if myGuildData then
    	 guildMemberData = myGuildData:GetMemberByGuid(ptdata.id);
    end	 

    local othrerName = "impossible"
    if guildMemberData and guildMemberData:IsRealtimevoice() then
    	othrerName = ZhString.DISABLE_MIC
    else
    	othrerName = ZhString.ENABLE_MIC
    end	

    -- ????????????????????????????????????????????????????????????
    local state = PlayerTipFuncState.Active

    if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Voice) then

    	state = PlayerTipFuncState.Active
    	if GameConfig.realtime_voice_limit and GVoiceProxy.Instance:GetCurGuildRealTimeVoiceCount() < GameConfig.realtime_voice_limit then
	    	 state = PlayerTipFuncState.Active
	    else
	    	 state = PlayerTipFuncState.InActive
	    end	
    else
    	 state = PlayerTipFuncState.InActive
    end	



	return state,othrerName;
end

function FunctionPlayerTip:UpdateInviteMemberFuncState(playerid, teamid)
	local curPlayerTip = self:CurPlayerTip();
	if(curPlayerTip)then
		local playerTipData = curPlayerTip.playerTipData;
		if(playerTipData and playerTipData.id == playerid)then
			playerTipData:SetTeamId(teamid);

			if(teamid~=0)then
				if(not TeamProxy.Instance:IHaveTeam())then
					curPlayerTip:ChangeFunc("InviteMember", "ApplyTeam");
				else
					curPlayerTip:UpdateFuncState("InviteMember", PlayerTipFuncState.Grey, ZhString.PlayerTip_AlreadyHaveTeam);
				end
			end
		end
	end
end

