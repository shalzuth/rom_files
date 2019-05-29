autoImport("ServiceSessionTeamAutoProxy")
ServiceSessionTeamProxy = class("ServiceSessionTeamProxy", ServiceSessionTeamAutoProxy)
ServiceSessionTeamProxy.Instance = nil
ServiceSessionTeamProxy.NAME = "ServiceSessionTeamProxy"
function ServiceSessionTeamProxy:ctor(proxyName)
  if ServiceSessionTeamProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionTeamProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionTeamProxy.Instance = self
  end
end
function ServiceSessionTeamProxy:CallProcessTeamInvite(type, userguid)
  local isInTeam = TeamProxy.Instance:IsInMyTeam(userguid)
  if not isInTeam then
    ServiceSessionTeamProxy.super.CallProcessTeamInvite(self, type, userguid)
  end
end
function ServiceSessionTeamProxy:RecvInviteMember(data)
  printGreen("Recv-->InviteMember")
  self:Notify(ServiceEvent.SessionTeamInviteMember, data)
end
function ServiceSessionTeamProxy:CallTeamList(type, page, lv, querytype, list)
  ServiceSessionTeamProxy.super.CallTeamList(self, type, page, lv, querytype, list)
end
function ServiceSessionTeamProxy:RecvTeamList(data)
  printGreen("Recv-->TeamList", #data.list)
  TeamProxy.Instance:UpdateAroundTeamList(data.list)
  self:Notify(ServiceEvent.SessionTeamTeamList, data)
end
function ServiceSessionTeamProxy:RecvTeamDataUpdate(data)
  TeamProxy.Instance:UpdateMyTeamData(data.datas, data.name, data.dojo)
  self:Notify(ServiceEvent.SessionTeamTeamDataUpdate, data)
end
function ServiceSessionTeamProxy:CallCreateTeam(minlv, maxlv, type, autoaccept, name, state, desc)
  helplog("Call-->" .. "CreateTeam")
  ServiceSessionTeamProxy.super.CallCreateTeam(self, minlv, maxlv, type, autoaccept, name, state, desc)
end
function ServiceSessionTeamProxy:RecvCreateTeam(data)
  self:Notify(ServiceEvent.SessionTeamCreateTeam, data)
end
function ServiceSessionTeamProxy:RecvEnterTeam(data)
  TeamProxy.Instance:CreateMyTeam(data.data)
  GVoiceProxy.Instance:RecvEnterTeam(data)
  self:Notify(ServiceEvent.SessionTeamEnterTeam, data)
end
function ServiceSessionTeamProxy:RecvTeamMemberUpdate(data)
  helplog("Recv-->" .. "TeamMemberUpdate")
  TeamProxy.Instance:UpdateTeamMember(data.updates, data.deletes)
  self:Notify(ServiceEvent.SessionTeamTeamMemberUpdate, data)
end
function ServiceSessionTeamProxy:RecvExitTeam(data)
  TeamProxy.Instance:ExitTeam()
  GVoiceProxy.Instance:RecvExitTeam(data)
  self:Notify(ServiceEvent.SessionTeamExitTeam, data)
end
function ServiceSessionTeamProxy:RecvTeamApplyUpdate(data)
  TeamProxy.Instance:UpdateMyTeamApply(data.updates, data.deletes)
  self:Notify(ServiceEvent.SessionTeamTeamApplyUpdate, data)
end
function ServiceSessionTeamProxy:RecvMemberPosUpdate(data)
  TeamProxy.Instance:UpdateMyTeamMemberPos(data.id, data.pos)
  self:Notify(ServiceEvent.SessionTeamMemberPosUpdate, data)
end
function ServiceSessionTeamProxy:RecvMemberDataUpdate(data)
  TeamProxy.Instance:UpdateMyTeamMemberData(data.id, data.members)
  GVoiceProxy.Instance:RecvMemberDataUpdate(data)
  self:Notify(ServiceEvent.SessionTeamMemberDataUpdate, data)
end
function ServiceSessionTeamProxy:RecvLockTarget(data)
  TeamProxy.Instance:LockTeamTarget(data.targetid)
  self:Notify(ServiceEvent.SessionTeamLockTarget, data)
end
function ServiceSessionTeamProxy:CallSetTeamOption(name, items)
  local result = {}
  for i = 1, #items do
    local combineItem = SessionTeam_pb.TeamSummaryItem()
    combineItem.type = items[i].type
    if combineItem.type == SessionTeam_pb.ETEAMDATA_DESC then
      combineItem.strvalue = items[i].strvalue
    else
      combineItem.value = items[i].value
    end
    table.insert(result, combineItem)
  end
  if name ~= nil or #result > 0 then
    ServiceSessionTeamProxy.super.CallSetTeamOption(self, name, result)
  end
end
function ServiceSessionTeamProxy:CallQueryUserTeamInfoTeamCmd(charid, teamid)
  ServiceSessionTeamProxy.super.CallQueryUserTeamInfoTeamCmd(self, charid, teamid)
end
function ServiceSessionTeamProxy:RecvQueryUserTeamInfoTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd, data)
end
function ServiceSessionTeamProxy:CallQuickEnter(type, time, set)
  ServiceSessionTeamProxy.super.CallQuickEnter(self, type, time, set)
end
function ServiceSessionTeamProxy:RecvQuickEnter(data)
  TeamProxy.Instance:SetQuickEnterTime(data.time)
  self:Notify(ServiceEvent.SessionTeamQuickEnter, data)
end
function ServiceSessionTeamProxy:RecvQuestWantedQuestTeamCmd(data)
  ShareAnnounceQuestProxy.Instance:RecvQuestWantedQuestTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQuestWantedQuestTeamCmd, data)
end
function ServiceSessionTeamProxy:RecvUpdateWantedQuestTeamCmd(data)
  ShareAnnounceQuestProxy.Instance:RecvUpdateWantedQuestTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamUpdateWantedQuestTeamCmd, data)
end
function ServiceSessionTeamProxy:RecvUpdateHelpWantedTeamCmd(data)
  ShareAnnounceQuestProxy.Instance:RecvUpdateHelpWantedTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamUpdateHelpWantedTeamCmd, data)
end
function ServiceSessionTeamProxy:RecvQueryHelpWantedTeamCmd(data)
  ShareAnnounceQuestProxy.Instance:RecvQueryHelpWantedTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQueryHelpWantedTeamCmd, data)
end
function ServiceSessionTeamProxy:CallKickMember(userid, catid)
  helplog("Call-->KickMember", userid, catid)
  ServiceSessionTeamProxy.super.CallKickMember(self, userid, catid)
end
function ServiceSessionTeamProxy:CallQueryMemberCatTeamCmd(data)
  helplog("Call-->QueryMemberCatTeamCmd")
  TeamProxy.Instance:ClearHireTeamMembers()
  ServiceSessionTeamProxy.super.CallQueryMemberCatTeamCmd(self, data)
end
function ServiceSessionTeamProxy:RecvMemberCatUpdateTeam(data)
  helplog("Recv-->MemberCatUpdateTeam", #data.updates, #data.dels)
  TeamProxy.Instance:SetMyHireTeamMembers(data.updates)
  TeamProxy.Instance:RemoveMyHireTeamMembers(data.dels)
  self:Notify(ServiceEvent.SessionTeamMemberCatUpdateTeam, data)
end
function ServiceSessionTeamProxy:RecvQueryMemberTeamCmd(data)
  helplog("Recv-->QueryMemberTeamCmd", #data.members)
  TeamProxy.Instance:HandleQueryMemberTeam(data)
  self:Notify(ServiceEvent.SessionTeamQueryMemberTeamCmd, data)
end
function ServiceSessionTeamProxy:RecvUserApplyUpdateTeamCmd(data)
  helplog("RecvUserApplyUpdateTeamCmd")
  TeamProxy.Instance:HandleUserApplyUpdate(data)
  self:Notify(ServiceEvent.SessionTeamUserApplyUpdateTeamCmd, data)
end
