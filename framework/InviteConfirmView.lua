InviteConfirmView = class("InviteConfirmView", BaseView)
InviteConfirmView.ViewType = UIViewType.IConfirmLayer
autoImport("InviteConfirmCtl")
autoImport("DesertWolfInviteCell")
local teamProxy, server_TeamProxy
function InviteConfirmView:Init()
  teamProxy = TeamProxy.Instance
  server_TeamProxy = ServiceSessionTeamProxy.Instance
  self:InitUI()
  self:MapViewListen()
end
function InviteConfirmView:InitUI()
  local inviteGrid = self:FindGO("InviteGrid")
  self.desertInviteRoot = self:FindGO("Anchor_RightCenter")
  self.conformCtl = InviteConfirmCtl.new(inviteGrid)
end
function InviteConfirmView:MapViewListen()
  self:AddListenEvt(InviteConfirmEvent.AddInvite, self.HandleRecvAddInvite)
  self:AddListenEvt(InviteConfirmEvent.RemoveInviteByType, self.HandleRemoveInviteByType)
  self:AddListenEvt(ServiceEvent.SessionTeamInviteMember, self.HandleRecvInvite)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamSummon, self.HandleRecvFollowInvite)
  self:AddListenEvt(ServiceEvent.NUserInviteJoinHandsUserCmd, self.HandleRecvJoinHand)
  self:AddListenEvt(ServiceEvent.GuildCmdInviteMemberGuildCmd, self.HandleRecvGuildInvite)
  self:AddListenEvt(ServiceEvent.DojoDojoInviteCmd, self.HandleRecvDojoInvite)
  self:AddListenEvt(ServiceEvent.InfiniteTowerTeamTowerInviteCmd, self.HandleEndlessTowerInvite)
  self:AddListenEvt(ServiceEvent.GuildCmdExchangeZoneNtfGuildCmd, self.HandleExchangeGuildZoneInvite)
  self:AddListenEvt(ServiceEvent.SceneAuguryAuguryInvite, self.HandleAuguryInvite)
  self:AddListenEvt(ServiceEvent.NUserInviteFollowUserCmd, self.HandleRecvFollow)
  self:AddListenEvt(ServiceEvent.MatchCCmdRevChallengeCCmd, self.HandleRecvChallenge)
  self:AddListenEvt(ServiceEvent.MatchCCmdFightConfirmCCmd, self.HandleDesertWorfConfirm)
  self:AddListenEvt(ServiceEvent.QuestInviteHelpAcceptQuestCmd, self.HandleRecvTeamWantedAcp)
  self:AddListenEvt(ServiceEvent.NUserCallTeamerUserCmd, self.HandleRecvCallTeamerReplyUserCmd)
  self:AddListenEvt(ServiceEvent.NUserMarriageProposalCmd, self.HandleMarriageProposalCmd)
  self:AddListenEvt(InviteConfirmEvent.Courtship_OutDistance, self.HandleMarriageProposal_OutDistance)
  self:AddListenEvt(ServiceEvent.WeddingCCmdMissyouInviteWedCCmd, self.HandleMissyouInviteWedCCmd)
  self:AddListenEvt(ServiceEvent.WeddingCCmdInviteBeginWeddingCCmd, self.HandleRecvInviteBeginWeddingCCmd)
  self:AddListenEvt(ServiceEvent.WeddingCCmdNtfReserveWeddingDateCCmd, self.HandleReserveWeddingDate)
  self:AddListenEvt(ServiceEvent.WeddingCCmdDivorceRollerCoasterInviteCCmd, self.HandleDivorceRollerCoasterInvite)
  self:AddListenEvt(ServiceEvent.PveCardInvitePveCardCmd, self.HandleCardInvitePveCardCmd)
  self:AddListenEvt(ServiceEvent.NUserTwinsActionUserCmd, self.HandleRecvTwinsAction)
  self:AddListenEvt(ServiceEvent.NUserInviteWithMeUserCmd, self.HandleRecvInviteWithMe)
  self:AddListenEvt(ServiceEvent.TeamRaidCmdTeamRaidInviteCmd, self.HandleAltmanInviteMsg)
  self:AddListenEvt(ServiceEvent.QuestHelpQuickFinishBoardQuestCmd, self.HandleQuestHelpQuickFinish)
  self:AddListenEvt(ServiceEvent.FuBenCmdInviteSummonBossFubenCmd, self.HandleInviteSummonBossFubenCmd)
end
function InviteConfirmView:HandleRecvChallenge(note)
  local data = note.body
  if not data then
    return
  end
  local DesertWolfInviteCell = DesertWolfInviteCell.new(self.desertInviteRoot, data)
end
function InviteConfirmView:HandleDesertWorfConfirm(note)
  local data = note.body
  helplog("HandleDesertWorfConfirm", data.roomid)
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
    msgId = teamID == data.teamid and 969 or 979,
    msgParama = {challenger}
  }
  function data.yesevt(id)
    ServiceMatchCCmdProxy.Instance:CallFightConfirmCCmd(PvpProxy.Type.DesertWolf, roomid, teamID, 1)
  end
  function data.noevt(id)
    ServiceMatchCCmdProxy.Instance:CallFightConfirmCCmd(PvpProxy.Type.DesertWolf, roomid, teamID, 2)
  end
  self.conformCtl:AddInvite(InviteType.DesertWolf, data)
end
function InviteConfirmView:HandleRecvTeamWantedAcp(note)
  local leaderName = note.body.leadername
  local leaderid = note.body.leaderid
  local questid = note.body.questid
  local stData = Table_WantedQuest[questid]
  local issubmit = note.body.issubmit
  if stData then
    local questName = stData.Name
    local sign = note.body.sign
    local time = note.body.time
    local msgId = 4011
    local data = {
      playerid = sign,
      time = GameConfig.Team.inviteovertime,
      msgId = msgId,
      msgParama = {leaderName, questName}
    }
    function data.yesevt(id)
      ServiceQuestProxy.Instance:CallReplyHelpAccelpQuestCmd(leaderid, questid, time, sign, true)
    end
    function data.endevt(id)
      ServiceQuestProxy.Instance:CallReplyHelpAccelpQuestCmd(leaderid, questid, time, sign, true)
    end
    self.conformCtl:AddInvite(InviteType.TmLeaderAcp, data)
    break
  else
    helplog("unkown wantedQuest:", questid)
  end
end
function InviteConfirmView:HandleRecvJoinHand(note)
  local playerid = note.body.charid
  local masterid = note.body.masterid
  local username = note.body.mastername
  local sign = note.body.sign
  local time = note.body.time
  local data = {
    playerid = masterid,
    time = GameConfig.Team.inviteovertime,
    msgId = 825,
    msgParama = {username, username}
  }
  function data.yesevt(id)
    if teamProxy:IHaveTeam() then
      ServiceNUserProxy.Instance:CallJoinHandsUserCmd(masterid, sign, time)
    else
      MsgManager.ShowMsgByIDTable(827)
    end
  end
  function data.noevt(id)
    ServiceNUserProxy.Instance:CallJoinHandsUserCmd(masterid)
  end
  self.conformCtl:AddInvite(InviteType.JoinHand, data)
end
function InviteConfirmView:HandleRecvAddInvite(note)
  local data = note.body
  data.yestip = ZhString.InviteConfirmView_Join
  local yesevt = data.yesevt
  self.conformCtl:AddInvite(InviteType.Carrier, data)
end
function InviteConfirmView:HandleRemoveInviteByType(note)
  self.conformCtl:ClearInviteMap(note.body)
end
function InviteConfirmView:HandleRecvInvite(note)
  local playerid = note.body.userguid
  local teamname = note.body.teamname
  local username = note.body.username
  local data = {
    playerid = playerid,
    time = GameConfig.Team.inviteovertime,
    msgId = 323,
    msgParama = {teamname, username}
  }
  function data.yesevt(id)
    server_TeamProxy:CallProcessTeamInvite(SessionTeam_pb.ETEAMINVITETYPE_AGREE, id)
  end
  function data.noevt(id)
    server_TeamProxy:CallProcessTeamInvite(SessionTeam_pb.ETEAMINVITETYPE_DISAGREE, id)
  end
  self.conformCtl:AddInvite(InviteType.Team, data)
end
function InviteConfirmView:HandleRecvFollowInvite(note)
  local leader = self.MyTeam():GetLeader()
  local raid = note.body.raidid
  local data = {
    playerid = leader.id,
    time = 20,
    msgId = 406,
    msgParama = {
      leader.name,
      Table_MapRaid[raid].NameZh
    }
  }
  function data.yesevt(id)
    local nowFollowID = Game.Myself:Client_GetFollowLeaderID()
    if not nowFollowID or nowFollowID == 0 then
      self:sendNotification(FollowEvent.Follow, id)
    else
      MsgManager.ShowMsgByIDTable(404)
    end
  end
  self.conformCtl:AddInvite(InviteType.Carrier, data)
end
function InviteConfirmView:HandleRecvGuildInvite(note)
  local guildid = note.body.guildid
  local playername = note.body.invitename
  local guildname = note.body.guildname
  if guildid and guildname then
    local data = {
      playerid = guildid,
      time = GameConfig.Team.inviteovertime,
      msgId = 2632,
      msgParama = {playername, guildname}
    }
    function data.yesevt(id)
      ServiceGuildCmdProxy.Instance:CallProcessInviteGuildCmd(GuildCmd_pb.EGUILDACTION_AGREE, id)
    end
    function data.noevt(id)
      ServiceGuildCmdProxy.Instance:CallProcessInviteGuildCmd(GuildCmd_pb.EGUILDACTION_DISAGREE, id)
    end
    self.conformCtl:AddInvite(InviteType.Guild, data)
  end
end
function InviteConfirmView:HandleRecvDojoInvite(note)
  local sponsorid = note.body.sponsorid
  local sponsorname = note.body.sponsorname
  local dojoid = note.body.dojoid
  if sponsorid and sponsorname and dojoid then
    local dojoName = Table_Guild_Dojo[dojoid] and Table_Guild_Dojo[dojoid].Name or ""
    local data = {
      playerid = sponsorid,
      time = GameConfig.Team.inviteovertime,
      msgId = 406,
      msgParama = {sponsorname, dojoName}
    }
    function data.yesevt(id)
      local lvreq = DojoProxy.Instance:GetGroupLvreq(dojoid)
      if lvreq and lvreq > MyselfProxy.Instance:RoleLevel() then
        MsgManager.ShowMsgByID(2950)
        ServiceDojoProxy.Instance:CallDojoReplyCmd(Dojo_pb.EDOJOREPLY_DISAGREE)
        return
      end
      ServiceDojoProxy.Instance:CallDojoReplyCmd(Dojo_pb.EDOJOREPLY_AGREE)
    end
    function data.noevt(id)
      ServiceDojoProxy.Instance:CallDojoReplyCmd(Dojo_pb.EDOJOREPLY_DISAGREE)
    end
    self.conformCtl:AddInvite(InviteType.Dojo, data)
  end
end
function InviteConfirmView:HandleEndlessTowerInvite(note)
  if not teamProxy:IHaveTeam() then
    return
  end
  local leaderId = teamProxy.myTeam:GetNowLeader().id
  local data = {
    playerid = leaderId,
    time = GameConfig.Team.inviteovertime,
    msgId = 1311
  }
  function data.yesevt(id)
    ServiceInfiniteTowerProxy.Instance:CallTeamTowerReplyCmd(InfiniteTower_pb.ETOWERREPLY_AGREE, Game.Myself.data.id)
    self:sendNotification(FollowEvent.Follow, leaderId)
  end
  function data.noevt(id)
    ServiceInfiniteTowerProxy.Instance:CallTeamTowerReplyCmd(InfiniteTower_pb.ETOWERREPLY_DISAGREE, Game.Myself.data.id)
  end
  self.conformCtl:AddInvite(InviteType.EndlessTower, data)
end
function InviteConfirmView.AgreeExchangeGuildZone(id)
  ServiceGuildCmdProxy.Instance:CallExchangeZoneAnswerGuildCmd(true)
end
function InviteConfirmView.RefuseExchangeGuildZone(id)
  ServiceGuildCmdProxy.Instance:CallExchangeZoneAnswerGuildCmd(false)
end
function InviteConfirmView:HandleExchangeGuildZoneInvite(note)
  local curzoneid = note.body.curzoneid
  curzoneid = ChangeZoneProxy.Instance:ZoneNumToString(curzoneid)
  local nextzoneid = note.body.nextzoneid
  nextzoneid = ChangeZoneProxy.Instance:ZoneNumToString(nextzoneid)
  local data = {
    playerid = "Temp",
    time = GameConfig.Team.inviteovertime,
    msgId = 3081,
    msgParama = {nextzoneid, nextzoneid}
  }
  data.yesevt = InviteConfirmView.AgreeExchangeGuildZone
  data.noevt = InviteConfirmView.RefuseExchangeGuildZone
  data.endevt = InviteConfirmView.RefuseExchangeGuildZone
  self.conformCtl:AddInvite(InviteType.Guild, data)
end
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
    msgParama = {invitername}
  }
  function data.yesevt(id)
    if npcId then
      local npc = NSceneNpcProxy.Instance:Find(npcId)
      if npc and VectorUtility.DistanceXZ(Game.Myself:GetPosition(), npc:GetPosition()) <= GameConfig.Augury.Range then
        ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply(SceneAugury_pb.EReplyType_Agree, id, npcId, augurytype, isextra)
      else
        ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply(SceneAugury_pb.EReplyType_Refuse, id, npcId, augurytype, isextra)
      end
    end
  end
  function data.noevt(id)
    ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply(SceneAugury_pb.EReplyType_Refuse, id, npcId, augurytype, isextra)
  end
  function data.endevt(id)
    ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply(SceneAugury_pb.EReplyType_Refuse, id, npcId, augurytype, isextra)
  end
  self.conformCtl:AddInvite(InviteType.Augury, data)
end
function InviteConfirmView:HandleRecvFollow(note)
  local playerid = note.body.charid
  if Game.Myself and Game.Myself:Client_GetFollowLeaderID() == playerid then
    return
  end
  if teamProxy:IHaveTeam() then
    local memData = teamProxy.myTeam:GetMemberByGuid(playerid)
    if not memData then
      errorLog("No Member When Recv FollowInvite")
      return
    end
    local data = {
      playerid = playerid,
      time = GameConfig.Team.inviteovertime,
      msgId = 344,
      msgParama = {
        memData.name
      }
    }
    local yesevt = function(id)
      if Game.Myself:IsDead() then
        MsgManager.ShowMsgByIDTable(2500)
        return
      end
      local memberInRaid = memData.raid ~= 0 or Table_MapRaid[memData.mapid] ~= nil
      local mymapid = Game.MapManager:GetMapID()
      local myRaid = Game.MapManager:GetRaidID()
      local meInRaid = myRaid ~= 0 or Table_MapRaid[mymapid] ~= nil
      redlog("MY mapid,raidid,meInRaid", mymapid, myRaid, meInRaid)
      redlog("TeamMember mapid,raidid,memberInRaid", memData.mapid, memData.raid, memberInRaid)
      if memData.zoneid == MyselfProxy.Instance:GetZoneId() and not memberInRaid and not meInRaid or memData.zoneid == MyselfProxy.Instance:GetZoneId() and memData.raid == myRaid then
        GameFacade.Instance:sendNotification(FollowEvent.Follow, id)
        redlog("FollowEvent.Follow")
        return
      else
        if not memberInRaid and not meInRaid then
          MsgManager.DontAgainConfirmMsgByID(27012, function()
            ServiceNUserProxy.Instance:CallGoMapFollowUserCmd(memData.mapid, memData.id)
            redlog("CallGoMapFollowUserCmd ------ with tip")
          end)
          return
        end
        ServiceNUserProxy.Instance:CallGoMapFollowUserCmd(memData.mapid, memData.id)
        redlog("CallGoMapFollowUserCmd")
        return
      end
    end
    data.yesevt = yesevt
    function data.endevt(id)
      local myMemberData = teamProxy:GetMyTeamMemberData()
      if myMemberData and myMemberData.autofollow == 1 then
        yesevt(id)
      end
    end
    self.conformCtl:AddInvite(InviteType.Follow, data)
    break
  else
    errorLog("No Team When Recv FollowInvite")
  end
end
function InviteConfirmView:HandleRecvCallTeamerReplyUserCmd(note)
  local playerid = note.body.masterid
  local sign = note.body.sign
  local time = note.body.time
  if teamProxy:IHaveTeam() then
    local memData = teamProxy.myTeam:GetMemberByGuid(playerid)
    if not memData then
      errorLog("No Member When Recv FollowInvite")
      return
    end
    local data = {
      playerid = playerid,
      time = 5,
      msgId = 344,
      msgParama = {
        note.body.username
      }
    }
    local yesevt = function(id)
      ServiceNUserProxy.Instance:CallCallTeamerReplyUserCmd(playerid, sign, time)
    end
    data.yesevt = yesevt
    data.endevt = yesevt
    self.conformCtl:AddInvite(InviteType.Follow, data)
  else
    errorLog("No Team When Recv FollowInvite")
  end
end
local marriageProposal_Map = {}
function InviteConfirmView:HandleMarriageProposalCmd(note)
  local server_data = note.body
  if server_data == nil then
    return
  end
  local masterid = server_data.masterid
  local mastername = server_data.mastername
  local itemid = server_data.itemid
  local sign = server_data.sign
  local server_time = server_data.time
  local gameconfig_wedding = GameConfig.Wedding
  local overtime, msgId = 5, 344
  if gameconfig_wedding then
    overtime, msgId = gameconfig_wedding.Courtship_InviteOverTime, gameconfig_wedding.Courtship_InviteMsgId
  end
  local data = {
    playerid = masterid,
    time = overtime,
    msgId = msgId
  }
  local msgData = Table_Sysmsg[msgId]
  local msgTitle = msgData.Title
  if msgTitle then
    msgTitle = string.format(msgTitle, mastername)
    data.tip = msgTitle
  end
  function data.yesevt(id)
    FunctionWedding.Me():RemoveCourtshipDistanceCheck(id)
    ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, SceneUser2_pb.EPROPOSALREPLY_YES, server_time, sign)
    marriageProposal_Map[id] = nil
  end
  function data.noevt(id)
    FunctionWedding.Me():RemoveCourtshipDistanceCheck(id)
    ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, SceneUser2_pb.EPROPOSALREPLY_NO, server_time, sign)
    marriageProposal_Map[id] = nil
  end
  function data.endevt(id)
    FunctionWedding.Me():RemoveCourtshipDistanceCheck(id)
    ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, SceneUser2_pb.EPROPOSALREPLY_CANCEL, server_time, sign, itemid)
    marriageProposal_Map[id] = nil
  end
  marriageProposal_Map[masterid] = {sign, server_time}
  self.conformCtl:AddInvite(InviteType.Courtship, data)
end
function InviteConfirmView:HandleMarriageProposal_OutDistance(note)
  local playerid = note.body
  if playerid == nil then
    return
  end
  local cacheInfo = marriageProposal_Map[playerid]
  if cacheInfo == nil then
    return
  end
  local sign, server_time = cacheInfo[1], cacheInfo[2]
  ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, SceneUser2_pb.EPROPOSALREPLY_OUTRANGE, server_time, sign)
end
function InviteConfirmView:HandleRecvInviteBeginWeddingCCmd(note)
  local server_data = note.body
  local masterid = server_data.masterid
  local myname = Game.Myself.data.name
  local name = server_data.name
  local tocharid = server_data.tocharid
  local gameconfig_wedding = GameConfig.Wedding
  local overtime, msgId = 5, 344
  if gameconfig_wedding then
    overtime, msgId = gameconfig_wedding.Cememony_InviteOverTime, gameconfig_wedding.Cememony_InviteMsgId
  end
  local msgData = Table_Sysmsg[msgId]
  local msgTitle, msgText = msgData.Title, msgData.Text
  local data = {
    playerid = masterid,
    time = overtime,
    msgId = msgId
  }
  if msgTitle ~= "" then
    msgTitle = string.format(msgTitle, myname, name)
    data.tip = msgTitle
  end
  function data.yesevt(id)
    ServiceWeddingCCmdProxy.Instance:CallReplyBeginWeddingCCmd(masterid)
  end
  function data.noevt(id)
  end
  function data.endevt(id)
  end
  self.conformCtl:AddInvite(InviteType.WeddingCemoney, data)
end
function InviteConfirmView:HandleRecvInviteWeddingStartNtf(note)
  local itemguid = note.body.itemguid
  if itemguid == nil then
    return
  end
  local itemData = BagProxy.Instance:GetItemByGuid(itemguid)
  if itemData == nil then
    return
  end
  local weddingData = itemData.weddingData
  if weddingData == nil then
    return
  end
  local gameconfig_wedding = GameConfig.Wedding
  local overtime, msgId = 5, 344
  if gameconfig_wedding then
    overtime, msgId = gameconfig_wedding.Cememony_InviteOverTime, gameconfig_wedding.Cememony_Invite_GotoMsgId
  end
  local msgData = Table_Sysmsg[msgId]
  local msgTitle, msgText = msgData.Title, msgData.Text
  local data = {
    playerid = itemguid,
    time = overtime,
    msgId = msgId
  }
  if msgTitle ~= "" then
  end
  function data.yesevt(id)
    ServiceWeddingCCmdProxy.Instance:CallReplyBeginWeddingCCmd(tocharid)
  end
  function data.noevt(id)
  end
  function data.endevt(id)
  end
  self.conformCtl:AddInvite(InviteType.WeddingCemoney, data)
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
    msgParama = {
      starttime.month,
      starttime.day,
      starttime.hour,
      endtime.hour,
      ChangeZoneProxy.Instance:ZoneNumToString(zoneid)
    }
  }
  function data.yesevt(id)
    ServiceWeddingCCmdProxy.Instance:CallReplyReserveWeddingDateCCmd(serverData.date, serverData.configid, id, WeddingCCmd_pb.EReply_Agree, serverData.time, serverData.use_ticket, serverData.zoneid, serverData.sign)
  end
  function data.noevt(id)
    ServiceWeddingCCmdProxy.Instance:CallReplyReserveWeddingDateCCmd(serverData.date, serverData.configid, id, WeddingCCmd_pb.EReply_Refuse, serverData.time, serverData.use_ticket, serverData.zoneid, serverData.sign)
  end
  function data.endevt(id)
    ServiceWeddingCCmdProxy.Instance:CallReplyReserveWeddingDateCCmd(serverData.date, serverData.configid, id, WeddingCCmd_pb.EReply_Refuse, serverData.time, serverData.use_ticket, serverData.zoneid, serverData.sign)
  end
  self.conformCtl:AddInvite(InviteType.Engage, data)
end
function InviteConfirmView:HandleDivorceRollerCoasterInvite(note)
  local serverData = note.body
  local data = {
    playerid = serverData.inviter,
    time = GameConfig.Wedding.Divorce_OverTime,
    msgId = 9612,
    msgParama = {
      serverData.inviter_name
    }
  }
  function data.yesevt(id)
    ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterReplyCCmd(id, WeddingCCmd_pb.EReply_Agree)
  end
  function data.noevt(id)
    ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterReplyCCmd(id, WeddingCCmd_pb.EReply_Refuse)
  end
  function data.endevt(id)
    ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterReplyCCmd(id, WeddingCCmd_pb.EReply_Refuse)
  end
  self.conformCtl:AddInvite(InviteType.ConsentDivorce, data)
end
function InviteConfirmView:HandleQuestHelpQuickFinish(note)
  local serverData = note.body
  local data = {
    playerid = serverData.questid,
    msgId = 25443,
    time = 3,
    msgParama = {
      serverData.leadername
    }
  }
  function data.endevt(id)
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD, id)
  end
  self.conformCtl:AddInvite(InviteType.HelpFinishQuest, data)
end
function InviteConfirmView:HandleMissyouInviteWedCCmd(note)
  local playerid = Game.Myself.data.id
  local msgId = GameConfig.Wedding.MissYou_Inviteid or 969
  local data = {
    playerid = playerid,
    time = GameConfig.Team.inviteovertime,
    msgId = msgId,
    msgParama = {}
  }
  function data.yesevt(id)
    ServiceWeddingCCmdProxy.Instance:CallMisccyouReplyWedCCmd(true)
  end
  function data.noevt(id)
    ServiceWeddingCCmdProxy.Instance:CallMisccyouReplyWedCCmd(false)
  end
  self.conformCtl:AddInvite(InviteType.DesertWolf, data)
end
function InviteConfirmView:HandleCardInvitePveCardCmd(note)
  local playerid, iscancel = note.body.configid, note.body.iscancel
  local msgId = GameConfig.CardRaid.invitemsg or 969
  local data = {
    playerid = playerid,
    time = GameConfig.Team.inviteovertime,
    msgId = msgId,
    msgParama = {}
  }
  function data.yesevt(id)
    ServicePveCardProxy.Instance:CallReplyPveCardCmd(true, id)
  end
  function data.noevt(id)
    ServicePveCardProxy.Instance:CallReplyPveCardCmd(false, id)
  end
  self.conformCtl:AddInvite(InviteType.RaidCard, data)
end
function InviteConfirmView:HandleRecvTwinsAction(note)
  local userid, etype = note.body.userid, note.body.etype
  if etype ~= SceneUser2_pb.ETWINS_OPERATION_REQUEST then
    return
  end
  local myTeam = TeamProxy.Instance.myTeam
  local memberData = myTeam and myTeam:GetMemberByGuid(userid)
  local name = memberData and memberData.name or ""
  local msgId = 393
  if Table_Sysmsg[393] == nil then
    msgId = 969
  end
  local data = {
    playerid = userid,
    time = 10,
    msgId = msgId,
    msgParama = {name}
  }
  function data.yesevt(id)
    ServiceNUserProxy.Instance:CallTwinsActionUserCmd(userid, nil, SceneUser2_pb.ETWINS_OPERATION_AGREE)
    self:sendNotification(DialogEvent.CloseDialog)
  end
  function data.noevt(id)
    ServiceNUserProxy.Instance:CallTwinsActionUserCmd(userid, nil, SceneUser2_pb.ETWINS_OPERATION_DISAGREE)
  end
  function data.endevt(id)
    ServiceNUserProxy.Instance:CallTwinsActionUserCmd(userid, nil, SceneUser2_pb.ETWINS_OPERATION_DISAGREE)
  end
  self.conformCtl:AddInvite(InviteType.DoubleAction, data)
end
function InviteConfirmView:HandleRecvInviteWithMe(note)
  local serverData = note.body
  local messageId = 25521
  if Table_Sysmsg[25521] == nil then
    messageId = 969
    errorLog("Message ID: 25521 is not exist")
  end
  local data = {
    playerid = serverData.sendid,
    time = GameConfig.Team.inviteovertime,
    msgId = messageId,
    msgParama = {}
  }
  function data.yesevt(id)
    ServiceNUserProxy.Instance:CallInviteWithMeUserCmd(serverData.sendid, serverData.time, true, serverData.sign)
  end
  function data.noevt(id)
    ServiceNUserProxy.Instance:CallInviteWithMeUserCmd(serverData.sendid, serverData.time, false, serverData.sign)
  end
  function data.endevt(id)
    ServiceNUserProxy.Instance:CallInviteWithMeUserCmd(serverData.sendid, serverData.time, false, serverData.sign)
  end
  self.conformCtl:AddInvite(InviteType.InviteWithMe, data)
end
function InviteConfirmView:HandleAltmanInviteMsg(note)
  local msgId = GameConfig.EVA.invite_msgid or GameConfig.Altman.invite_msgid or 323
  local data = {
    playerid = Game.Myself.data.id,
    time = 10,
    msgId = msgId
  }
  function data.yesevt(id)
    local myTeam = TeamProxy.Instance.myTeam
    if myTeam == nil then
      redlog("No Team")
      return
    end
    local nowleader = myTeam:GetNowLeader()
    if nowleader == nil then
      redlog("No Leader")
      return
    end
    GameFacade.Instance:sendNotification(FollowEvent.Follow, nowleader.id)
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidReplyCmd(true, Game.Myself.data.id, FuBenCmd_pb.ERAIDTYPE_ALTMAN)
  end
  function data.noevt(id)
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidReplyCmd(false, Game.Myself.data.id, FuBenCmd_pb.ERAIDTYPE_ALTMAN)
  end
  self.conformCtl:AddInvite(InviteType.AltMan, data)
end
function InviteConfirmView:HandleInviteSummonBossFubenCmd(note)
  local msgId = 25921
  local data = {
    playerid = Game.Myself.data.id,
    time = 10,
    msgId = msgId
  }
  function data.yesevt(id)
    ServiceFuBenCmdProxy.Instance:CallReplySummonBossFubenCmd(nil, true)
  end
  function data.noevt(id)
    ServiceFuBenCmdProxy.Instance:CallReplySummonBossFubenCmd(nil, false)
  end
  self.conformCtl:AddInvite(InviteType.PveCard, data)
end
