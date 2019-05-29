TeamProxy = class("TeamProxy", pm.Proxy)
TeamProxy.Instance = nil
TeamProxy.NAME = "TeamProxy"
autoImport("MyselfTeamData")
TeamProxy.ExitType = {
  ServerExit = "TeamProxy_ExitType_ServerExit",
  ClearData = "TeamProxy_ExitType_ClearData"
}
TeamInviteMemberType = {
  Friend = 1,
  GuildMember = 2,
  NearlyTeamMember = 3,
  MemberCat = 4
}
function TeamProxy:ctor(proxyName, data)
  self.proxyName = proxyName or TeamProxy.NAME
  if TeamProxy.Instance == nil then
    TeamProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitTeamProxy()
end
function TeamProxy:InitTeamProxy()
  self.myTeam = nil
  self.teamlst = {}
  self.quickEnterTime = 0
  self:InitTeamGoals()
end
function TeamProxy:InitTeamGoals()
  local fatherGoals = {}
  local childGoals = {}
  for k, v in pairs(Table_TeamGoals) do
    if v.id ~= v.type then
      local temp = childGoals[v.type]
      if not temp then
        temp = {}
        childGoals[v.type] = temp
      end
      table.insert(temp, v)
    else
      table.insert(fatherGoals, v)
    end
  end
  self.goals = {}
  for k, v in pairs(fatherGoals) do
    local combine = {}
    combine.fatherGoal = v
    combine.childGoals = childGoals[v.id]
    table.insert(self.goals, combine)
  end
  table.sort(self.goals, function(a, b)
    return a.fatherGoal.id < b.fatherGoal.id
  end)
end
local checkChildGoalRaidType = function(childGoals)
  if not childGoals then
    return false
  end
  for i = 1, #childGoals do
    if childGoals[i].RaidType then
      return true
    end
  end
  return false
end
function TeamProxy:GetTeamGoals(getMatch)
  local result = {}
  for i = 1, #self.goals do
    local v = self.goals[i]
    local newGoal = {}
    local flag
    local isRaidType = checkChildGoalRaidType(v.childGoals)
    if getMatch then
      flag = isRaidType or v.fatherGoal.RaidType
    else
      flag = v.fatherGoal.id ~= GameConfig.Team.defaulttype
    end
    if flag then
      newGoal.fatherGoal = v.fatherGoal
      newGoal.childGoals = {}
      if v.childGoals then
        for ck, cv in pairs(v.childGoals) do
          table.insert(newGoal.childGoals, cv)
        end
        table.sort(newGoal.childGoals, function(a, b)
          return a.id < b.id
        end)
      end
      table.insert(result, newGoal)
    end
  end
  return result
end
function TeamProxy:CheckMatchValid(matchID)
  local enterLv = Table_MatchRaid[matchID].EnterLevel
  local myself = Game.Myself
  local mylv = myself.data.userdata:Get(UDEnum.ROLELEVEL)
  if enterLv > mylv then
    MsgManager.ShowMsgByID(363)
    return
  end
  if 1 == MyselfProxy.Instance:GetMyProfession() then
    MsgManager.ShowMsgByID(378)
    return
  end
  if self:IHaveTeam() then
    if not self:CheckImTheLeader() then
      MsgManager.ShowMsgByID(372)
      return
    end
    local list = self.myTeam:GetMembersList()
    for k, v in pairs(list) do
      if v:IsOffline() then
        MsgManager.ShowMsgByID(25903)
        return
      end
      if enterLv > v.baselv then
        MsgManager.ShowMsgByID(7305, enterLv)
        return
      end
      if 1 == v.profession then
        MsgManager.ShowMsgByID(378)
        return
      end
    end
  end
  return true
end
function TeamProxy:CreateMyTeam(myTeamData)
  if self.myTeam then
    self:ExitTeam()
  end
  self.myTeam = MyselfTeamData.new()
  self.myTeam:SetData(myTeamData)
  if self.myTeam.id ~= 0 then
    local myself = Game.Myself
    myself.data:SetTeamID(self.myTeam.id)
  end
end
function TeamProxy:UpdateMyTeamData(summaryDatas, name, dojo)
  if not self.myTeam then
    errorLog("Not Find MyTeam (UpdateMyTeamData)")
    return
  end
  self.myTeam:SetSummary(summaryDatas, name)
  if dojo then
    self.myTeam:SetDojo(data.dojo)
  end
end
function TeamProxy:LockTeamTarget(targetId)
  if not self.myTeam then
    errorLog("Not Find MyTeam (LockTeamTarget)")
    return
  end
  self.myTeam.target = targetId
end
function TeamProxy:UpdateTeamMember(updates, dels)
  if not self.myTeam then
    errorLog("Not Find MyTeam (UpdateMyTeamData)")
    return
  end
  self.myTeam:SetMembers(updates)
  self.myTeam:RemoveMembers(dels)
end
function TeamProxy:UpdateMyTeamMemberData(memberid, memberData)
  if not self.myTeam then
    errorLog("I'm Not EnterTeam When Recv(UpdateMyTeamData)")
    return
  end
  local teamMemberData = self.myTeam:GetMemberByGuid(memberid)
  if teamMemberData then
    local tempData = {guid = memberid, datas = memberData}
    self.myTeam:SetMember(tempData)
  else
    errorLog(string.format("Member:%s Not EnterTeam When Recv(MemberDataUpdate)", memberid))
  end
end
function TeamProxy:UpdateMyTeamApply(updates, dels)
  if not self.myTeam then
    errorLog("Not Find MyTeam (UpdateMyTeamData)")
    return
  end
  self.myTeam:SetApplys(updates)
  self.myTeam:RemoveApplys(dels)
end
function TeamProxy:UpdateMyTeamMemberPos(id, pos)
  if not self.myTeam then
    errorLog("Not Find MyTeam (UpdateMyTeamMemberPos)")
    return
  end
  local member = self.myTeam:GetMemberByGuid(id)
  if not member then
    errorLog(string.format("No Member In Team When Update Member Pos %s", id))
    return
  end
  member:UpdatePos(pos)
end
function TeamProxy:SetMyHireTeamMembers(cats)
  if self.myTeam then
    self.myTeam:Server_SetHireTeamMembers(cats)
  end
end
function TeamProxy:RemoveMyHireTeamMembers(dels)
  if self.myTeam then
    self.myTeam:Server_RemoveHireTeamMembers(dels)
  end
end
function TeamProxy:ClearHireTeamMembers()
  if self.myTeam then
    self.myTeam:ClearHireTeamMembers()
  end
end
function TeamProxy:GetMyHireTeamMembers()
  if self.myTeam then
    return self.myTeam:GetHireTeamMembers()
  end
  return {}
end
function TeamProxy:GetCanChangeCats()
  local teamCats = self.myTeam:GetHireCatID()
  local catDatas = {}
  local hireCats = self:GetMyHireTeamMembers()
  local curServerTime = ServerTime.CurServerTime() / 1000
  for i = 1, #hireCats do
    local catData = hireCats[i]
    if not TeamProxy.Instance:IsInMyTeam(catData.id) and curServerTime > catData.expiretime then
      local cat = {}
      cat.expiretime = catData.expiretime
      cat.id = catData.cat
      catDatas[#catDatas + 1] = cat
    end
  end
  for _, cfg in pairs(Table_MercenaryCat) do
    if 0 == TableUtility.ArrayFindIndex(teamCats, cfg.id) and FunctionUnLockFunc.Me():CheckCanOpen(cfg.MenuID) then
      local cat = {}
      cat.id = cfg.id
      cat.expiretime = 0
      catDatas[#catDatas + 1] = cat
    end
  end
  return catDatas
end
function TeamProxy:ExitTeam(exitType)
  exitType = exitType or TeamProxy.ExitType.ServerExit
  if self.myTeam then
    if self.myTeam.id ~= 0 then
      local myself = Game.Myself
      if myself and myself.data then
        myself.data:SetTeamID(self.myTeam.id)
      end
    end
    self.myTeam:Exit(exitType)
    self.myTeam = nil
  end
  GameFacade.Instance:sendNotification(TeamEvent.ExitTeam, exitType)
  GameFacade.Instance:sendNotification(ServiceEvent.SessionTeamExitTeam, exitType)
end
function TeamProxy:HandleUserApplyUpdate(serverdata)
  if not self.userApplyMap then
    self.userApplyMap = {}
  end
  local updates = serverdata.updates
  if updates then
    for i = 1, #updates do
      self.userApplyMap[updates[i].teamid] = updates[i].createtime
    end
  end
  local deletes = serverdata.deletes
  if deletes then
    for i = 1, #deletes do
      self.userApplyMap[deletes[i]] = nil
    end
  end
end
function TeamProxy:GetUserApply(teamid)
  if not self.userApplyMap then
    return
  end
  return self.userApplyMap[teamid]
end
function TeamProxy:RemoveApply(teamid)
  self.userApplyMap[teamid] = nil
end
function TeamProxy:GetUserApplyCt()
  local c = 0
  if self.userApplyMap then
    for k, v in pairs(self.userApplyMap) do
      c = c + 1
    end
  end
  return c
end
function TeamProxy:IHaveTeam()
  return self.myTeam ~= nil and self.myTeam.id ~= 0
end
function TeamProxy:IsInMyTeam(playerid)
  if self.myTeam then
    return self.myTeam:GetMemberByGuid(playerid) ~= nil
  end
  return false
end
function TeamProxy:CheckImTheLeader()
  local myMemberData = self:GetMyTeamMemberData()
  if myMemberData then
    return myMemberData.job == SessionTeam_pb.ETEAMJOB_LEADER
  end
  return false
end
function TeamProxy:CheckIHaveLeaderAuthority()
  local myMemberData = self:GetMyTeamMemberData()
  if myMemberData then
    return myMemberData.job == SessionTeam_pb.ETEAMJOB_LEADER or myMemberData.job == SessionTeam_pb.ETEAMJOB_TEMPLEADER
  end
  return false
end
function TeamProxy:GetMyTeamMemberData()
  if not Game.Myself then
    return
  end
  if not self.myTeam then
    return
  end
  return self.myTeam:GetMemberByGuid(Game.Myself.data.id)
end
function TeamProxy:UpdateAroundTeamList(list)
  self.aroundTeamList = {}
  for i = 1, #list do
    local teamData = TeamData.new(list[i])
    table.insert(self.aroundTeamList, teamData)
  end
end
function TeamProxy:HandleQueryMemberTeam(data)
  if not self.teamMemberMap then
    self.teamMemberMap = {}
  end
  self.teamMemberMap[data.teamid] = {}
  for i = 1, #data.members do
    local member = TeamMemberData.new(data.members[i])
    table.insert(self.teamMemberMap[data.teamid], member)
  end
end
function TeamProxy:ClearTeamMembers()
  if self.teamMemberMap then
    TableUtility.TableClear(self.teamMemberMap)
  end
end
function TeamProxy:GetTeamMembers(teamid)
  if not self.teamMemberMap then
    return
  end
  return self.teamMemberMap[teamid]
end
function TeamProxy:GetAroundTeamList()
  return self.aroundTeamList
end
function TeamProxy:SetItemImageUser(userid)
  self.imageUser = userid
end
function TeamProxy:GetItemImageUser()
  return self.imageUser
end
function TeamProxy:SetQuickEnterTime(time)
  self.quickEnterTime = time
end
function TeamProxy:IsQuickEntering()
  if self.quickEnterTime ~= nil then
    return ServerTime.CurServerTime() / 1000 < self.quickEnterTime
  end
  return false
end
function TeamProxy:CheckIsCatByPlayerId(id)
  if self.myTeam then
    local memberData = self.myTeam:GetMemberByGuid(id)
    if memberData and memberData.cat then
      return memberData.cat ~= 0
    end
  end
  return false
end
function TeamProxy:GetCatMasterName(catid)
  if self.myTeam then
    local memberData = self.myTeam:GetMemberByGuid(catid)
    if memberData then
      return memberData.mastername
    end
  end
end
