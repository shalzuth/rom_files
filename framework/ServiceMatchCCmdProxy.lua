autoImport("ServiceMatchCCmdAutoProxy")
ServiceMatchCCmdProxy = class("ServiceMatchCCmdProxy", ServiceMatchCCmdAutoProxy)
ServiceMatchCCmdProxy.Instance = nil
ServiceMatchCCmdProxy.NAME = "ServiceMatchCCmdProxy"
function ServiceMatchCCmdProxy:ctor(proxyName)
  if ServiceMatchCCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMatchCCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMatchCCmdProxy.Instance = self
  end
end
function ServiceMatchCCmdProxy:RecvReqRoomListCCmd(data)
  helplog("MatchCCmd Recv ReqRoomListCCmd", data.type, #data.room_lists)
  for i = 1, #data.room_lists do
    local whole = data.room_lists[i].name
    local prefix = string.match(whole, "[^-]+") or ""
    local suffix = string.match(whole, "-.+") or ""
    data.room_lists[i].name = OverSea.LangManager.Instance():GetLangByKey(prefix) .. suffix
  end
  PvpProxy.Instance:SetRoomList(data.type, data.room_lists)
  if data.type == PvpProxy.Type.Yoyo then
    PvpProxy.Instance:SetYoyoRoomList(data.type, data.room_lists)
  end
  self:Notify(ServiceEvent.MatchCCmdReqRoomListCCmd, data)
end
function ServiceMatchCCmdProxy:RecvReqRoomDetailCCmd(data)
  helplog("MatchCCmd Recv ReqRoomDetailCCmd", data.type, data.roomid)
  PvpProxy.Instance:SetRoomDetailInfo(data.type, data.roomid, data.datail_info)
  self:Notify(ServiceEvent.MatchCCmdReqRoomDetailCCmd, data)
end
function ServiceMatchCCmdProxy:CallReqMyRoomMatchCCmd(type, brief_info)
  helplog("Call --> ReqMyRoomMatchCCmd", type)
  ServiceMatchCCmdProxy.super.CallReqMyRoomMatchCCmd(self, type)
end
function ServiceMatchCCmdProxy:CallRevChallengeCCmd(type, roomid, challenger, challenger_zoneid, members, reply)
  helplog("reply: ", reply)
  helplog("MatchCCmd Call CallRevChallengeCCmd", type, reply, roomid, members, challenger, challenger_zoneid)
  ServiceMatchCCmdProxy.super.CallRevChallengeCCmd(self, type, roomid, challenger, challenger_zoneid, members, reply)
end
function ServiceMatchCCmdProxy:RecvRevChallengeCCmd(data)
  helplog("Recv-->ChallengeCCmd", tostring(data.challenger), data.challenger_zoneid, data.roomid, data.type)
  self:Notify(ServiceEvent.MatchCCmdRevChallengeCCmd, data)
end
function ServiceMatchCCmdProxy:RecvReqMyRoomMatchCCmd(data)
  helplog("Recv --> MatchCCmd Recv ReqMyRoomMatchCCmd")
  PvpProxy.Instance:SetMyRoomBriefInfo(data.type, data.brief_info)
  self:Notify(ServiceEvent.MatchCCmdReqMyRoomMatchCCmd, data)
end
function ServiceMatchCCmdProxy:CallFightConfirmCCmd(type, roomid, teamid, reply)
  helplog("MatchCCmd CallFightConfirmCCmd", type, roomid, teamid, reply)
  ServiceMatchCCmdProxy.super.CallFightConfirmCCmd(self, type, roomid, teamid, reply)
end
function ServiceMatchCCmdProxy:CallJoinRoomCCmd(type, roomid, name, isquick, teamid, teammember, ret, guildid, users, matcher)
  local logStr = string.format("type:%s, roomid:%s, teamid:%s", tostring(type), tostring(roomid), tostring(teamid))
  helplog("MatchCCmd Call JoinRoomCCmd", logStr)
  ServiceMatchCCmdProxy.super.CallJoinRoomCCmd(self, type, roomid, name, isquick, teamid, teammember, ret, guildid, users, matcher)
end
function ServiceMatchCCmdProxy:CallLeaveRoomCCmd(type, guid)
  helplog("MatchCCmd Call LeaveRoomCCmd", type, guid)
  ServiceMatchCCmdProxy.super.CallLeaveRoomCCmd(self, type, guid)
end
function ServiceMatchCCmdProxy:CallReqRoomDetailCCmd(type, guid, datail_info)
  helplog("MatchCCmd Call ReqRoomDetailCCmd", type, guid)
  ServiceMatchCCmdProxy.super.CallReqRoomDetailCCmd(self, type, guid)
end
function ServiceMatchCCmdProxy:RecvNtfFightStatCCmd(data)
  PvpProxy.Instance:NtfFightStatCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdNtfFightStatCCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.MatchCCmdNtfFightStatCCmd, data)
end
function ServiceMatchCCmdProxy:RecvGodEndTimeCCmd(data)
  PvpProxy.Instance:RecvGodEndTime(data.endtime)
  EventManager.Me():PassEvent(ServiceEvent.MatchCCmdGodEndTimeCCmd, data)
end
function ServiceMatchCCmdProxy:CallReqRoomListCCmd(type, roomids, room_lists)
  helplog("MatchCCmd Call CallReqRoomListCCmd", type)
  ServiceMatchCCmdProxy.super.CallReqRoomListCCmd(self, type, roomids, room_lists)
end
function ServiceMatchCCmdProxy:RecvComboNotifyCCmd(data)
  helplog("MatchCCmd Recv RecvComboNotifyCCmd", data)
  self:Notify(ServiceEvent.MatchCCmdComboNotifyCCmd, data)
  ComboCtl.Instance:ShowCombo(data.comboNum)
end
function ServiceMatchCCmdProxy:RecvPvpResultCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdPvpResultCCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.MatchCCmdPvpResultCCmd, data)
  local dataType = data.type
  if dataType == PvpProxy.Type.DesertWolf or dataType == PvpProxy.Type.GorgeousMetal then
    helplog("RecvPvpResultCCmd ", data.result)
    if data.result == 3 then
      MsgManager.ShowMsgByID(972)
    elseif data.result == 1 or data.result == 2 then
      PvpProxy.Instance:HandlePvpResult(data.result)
    end
  elseif dataType == PvpProxy.Type.PoringFight then
    PvpProxy.Instance:PoringFightResult(data.rank, data.reward, data.apple)
  end
end
function ServiceMatchCCmdProxy:RecvPvpMemberDataUpdateCCmd(data)
  helplog("Recv-->PvpMemberDataUpdateCCmd")
  PvpProxy.Instance:PvpMemberDataUpdate(data.data)
  self:Notify(ServiceEvent.MatchCCmdPvpMemberDataUpdateCCmd, data)
end
function ServiceMatchCCmdProxy:RecvPvpTeamMemberUpdateCCmd(data)
  helplog("Recv-->PvpTeamMemberUpdateCCmd")
  PvpProxy.Instance:PvpTeamMemberUpdateCCmd(data.data)
  self:Notify(ServiceEvent.MatchCCmdPvpTeamMemberUpdateCCmd, data)
end
function ServiceMatchCCmdProxy:RecvKickTeamCCmd(data)
  helplog("Recv-->DoKickTeamCCmd", data.type, data.roomid, data.zoneid, data.teamid)
  PvpProxy.Instance:DoKickTeamCCmd(data.type, data.roomid, data.zoneid, data.teamid)
  self:Notify(ServiceEvent.MatchCCmdKickTeamCCmd, data)
end
function ServiceMatchCCmdProxy:RecvNtfRoomStateCCmd(data)
  helplog("Recv-->NtfRoomStateCCmd", data.pvp_type, data.roomid, data.state, data.endtime)
  PvpProxy.Instance:UpdateMyRoomStatus(data.pvp_type, data.roomid, data.state, data.endtime)
  self:Notify(ServiceEvent.MatchCCmdNtfRoomStateCCmd, data)
end
function ServiceMatchCCmdProxy:RecvNtfMatchInfoCCmd(data)
  helplog("Recv-->NtfMatchInfoCCmd", data.etype, data.ismatch, data.isfight)
  PvpProxy.Instance:NtfMatchInfo(data.etype, data.ismatch, data.isfight)
  self:Notify(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, data)
end
function ServiceMatchCCmdProxy:RecvNtfRankChangeCCmd(data)
  PvpProxy.Instance:RecvNtfRankChangeCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdNtfRankChangeCCmd, data)
end
function ServiceMatchCCmdProxy:RecvTutorMatchResultNtfMatchCCmd(data)
  helplog("Recv-->RecvTutorMatchResultNtfMatchCCmd")
  TutorProxy.Instance:UpdateTutorMatchInfo(data)
  self:Notify(ServiceEvent.MatchCCmdTutorMatchResultNtfMatchCCmd, data)
end
function ServiceMatchCCmdProxy:RecvTutorMatchResponseMatchCCmd(data)
  helplog("Recv-->RecvTutorMatchResponseMatchCCmd")
  TutorProxy.Instance:UpdateTutorMatchInfo(data)
  self:Notify(ServiceEvent.MatchCCmdTutorMatchResponseMatchCCmd, data)
end
function ServiceMatchCCmdProxy:CallTutorMatchResponseMatchCCmd(response)
  helplog("Call-->CallTutorMatchResponseMatchCCmd")
  self.super.CallTutorMatchResponseMatchCCmd(self, response)
end
function ServiceMatchCCmdProxy:RecvTeamPwsPreInfoMatchCCmd(data)
  PvpProxy.Instance:RecvTeamPwsPreInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTeamPwsPreInfoMatchCCmd, data)
end
function ServiceMatchCCmdProxy:RecvUpdatePreInfoMatchCCmd(data)
  PvpProxy.Instance:RecvUpdatePreInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdUpdatePreInfoMatchCCmd, data)
end
function ServiceMatchCCmdProxy:RecvQueryTeamPwsRankMatchCCmd(data)
  PvpProxy.Instance:RecvQueryTeamPwsRankMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTeamPwsRankMatchCCmd, data)
end
