autoImport("TeamData")
MyselfTeamData = class("TeamData", TeamData)
MyselfTeamData.EMPTY_STATE = 1
function MyselfTeamData:ctor(teamData)
  MyselfTeamData.super.ctor(self, teamData)
  self.memberListExpMe = {}
  self.memberListWithAdd = {}
  self.hireMemberMap = {}
  self.hireMemberList = {}
  self.playerMemberList = {}
end
function MyselfTeamData:SetMember(data)
  local member = self:GetMemberByGuid(data.guid)
  if not member then
    member = self:AddMember(data)
    self:RefreshCatMasterInfo(member)
  else
    local isMyMemberData = data.guid == member.id
    local cachemapid = member.mapid
    local cacheJob = member.job
    local cacheOffline = member:IsOffline()
    local cacheCat = member.cat
    member:SetData(data)
    if cacheOffline ~= member:IsOffline() then
      if member:IsOffline() then
        self:NotifyMemberOffline(member)
      else
        self:NotifyMemberOnline(member)
      end
    end
    if cachemapid ~= member.mapid then
      self:NotifyMemberChangeMap(member)
    end
    if isMyMemberData and cacheJob ~= member.job then
      self:NotifyMyTeamJobChange(member.job)
    end
    if cacheCat ~= member.cat then
      self:RefreshCatMasterInfo(member)
    end
  end
  return member
end
function MyselfTeamData:NotifyMemberOnline(memberData)
  EventManager.Me():DispatchEvent(TeamEvent.MemberOnline, memberData)
  GameFacade.Instance:sendNotification(TeamEvent.MemberOnline, memberData)
end
function MyselfTeamData:NotifyMemberOffline(memberData)
  EventManager.Me():DispatchEvent(TeamEvent.MemberOffline, memberData)
  GameFacade.Instance:sendNotification(TeamEvent.MemberOffline, memberData)
end
function MyselfTeamData:NotifyMemberChangeMap(memberData)
  GameFacade.Instance:sendNotification(TeamEvent.MemberChangeMap, memberData)
end
function MyselfTeamData:NotifyMyTeamJobChange(nowJob)
  FunctionTeam.Me():MyTeamJobChange(nowJob)
end
function MyselfTeamData:RefreshCatMasterInfo(memberData)
  local masterid = memberData.masterid
  local master = self:GetMemberByGuid(masterid)
  if master then
    memberData:SetMasterName(master.name)
  elseif masterid == Game.Myself.data.id then
    memberData:SetMasterName(Game.Myself.data.name)
  end
end
function MyselfTeamData:AddMember(member)
  local addMember = MyselfTeamData.super.AddMember(self, member)
  if addMember then
    if addMember.id == Game.Myself.data.id then
      self.myMemberInfo = addMember
      addMember.offline = 0
    else
      local scenePlayer = NSceneUserProxy.Instance:Find(addMember.id)
      if scenePlayer then
        scenePlayer:OnAvatarPriorityChanged()
        scenePlayer.data:Camp_SetIsInMyTeam(true)
        scenePlayer.data:SetTeamID(self.id)
      end
    end
    GameFacade.Instance:sendNotification(TeamEvent.MemberEnterTeam, addMember)
    EventManager.Me():DispatchEvent(TeamEvent.MemberEnterTeam, addMember)
    return addMember
  end
end
function MyselfTeamData:RemoveMember(guid, catid)
  local removeMember = MyselfTeamData.super.RemoveMember(self, guid, catid)
  if removeMember then
    if removeMember.id ~= Game.Myself.data.id then
      local scenePlayer = NSceneUserProxy.Instance:Find(removeMember.id)
      if scenePlayer then
        scenePlayer:OnAvatarPriorityChanged()
        scenePlayer.data:Camp_SetIsInMyTeam(false)
        scenePlayer.data:SetTeamID(scenePlayer.data.id)
      end
    end
    GameFacade.Instance:sendNotification(TeamEvent.MemberExitTeam, removeMember)
    EventManager.Me():DispatchEvent(TeamEvent.MemberExitTeam, removeMember)
    return removeMember
  end
end
function MyselfTeamData:GetMembersListExceptMe()
  local memberList = self:GetMembersList()
  TableUtility.ArrayClear(self.memberListExpMe)
  for i = 1, #memberList do
    if memberList[i].id ~= Game.Myself.data.id then
      table.insert(self.memberListExpMe, memberList[i])
    end
  end
  return self.memberListExpMe
end
function MyselfTeamData:GetMemberListWithAdd()
  local memberList = self:GetMembersListExceptMe()
  TableUtility.ArrayClear(self.memberListWithAdd)
  for i = 1, #memberList do
    table.insert(self.memberListWithAdd, memberList[i])
  end
  if #self.memberListWithAdd < GameConfig.Team.maxmember - 1 then
    table.insert(self.memberListWithAdd, MyselfTeamData.EMPTY_STATE)
  end
  return self.memberListWithAdd
end
function MyselfTeamData:GetHireCatID()
  local data = {}
  local memberListWithAdd = self:GetMemberListWithAdd()
  for k, v in pairs(memberListWithAdd) do
    if "table" == type(v) and v:IsHireMember() then
      data[#data + 1] = v.cat
    end
  end
  return data
end
function MyselfTeamData:GetPlayerMemberList(includeMe, exceptCat)
  TableUtility.ArrayClear(self.playerMemberList)
  local list = self:GetMembersList()
  for i = 1, #list do
    if list[i].id == Game.Myself.data.id then
      if includeMe then
        table.insert(self.playerMemberList, list[i])
      end
    elseif exceptCat ~= true then
      table.insert(self.playerMemberList, list[i])
    elseif list[i].cat == nil or list[i].cat == 0 then
      table.insert(self.playerMemberList, list[i])
    end
  end
  return self.playerMemberList
end
function MyselfTeamData:GetMemberCreatureArrayInRange(range, creatureArray, filter, filterArgs)
  local FindCreature = SceneCreatureProxy.FindCreature
  local myPosition = Game.Myself:GetPosition()
  for _, v in pairs(self.membersMap) do
    local creature = FindCreature(v.id)
    if nil ~= creature and (filter == nil or filter(creature, filterArgs)) then
      if range > 0 then
        local dist = VectorUtility.DistanceXZ(creature:GetPosition(), myPosition)
        if range > dist then
          TableUtility.ArrayPushBack(creatureArray, creature)
        end
      else
        TableUtility.ArrayPushBack(creatureArray, creature)
      end
    end
  end
end
function MyselfTeamData:GetApplyList()
  local memData = self:GetMemberByGuid(Game.Myself.data.id)
  if memData and (memData.job == SessionTeam_pb.ETEAMJOB_LEADER or memData.job == SessionTeam_pb.ETEAMJOB_TEMPLEADER) then
    return MyselfTeamData.super.GetApplyList(self)
  end
  return {}
end
function MyselfTeamData:Server_SetHireTeamMembers(cats)
  self.hireMemberList_dirty = true
  for i = 1, #cats do
    local serverCat = cats[i]
    local guid = serverCat.id
    local memberData = self.hireMemberMap[guid]
    if not memberData then
      memberData = TeamMemberData.new()
      memberData.id = guid
      self.hireMemberMap[guid] = memberData
    end
    memberData.cat = serverCat.catid
    memberData:SetRestTime(serverCat.relivetime)
    memberData.baselv = serverCat.lv
    memberData.expiretime = serverCat.expiretime
    memberData.masterid = serverCat.ownerid
    memberData:UpdateHireMemberInfo()
    self:RefreshCatMasterInfo(memberData)
  end
end
function MyselfTeamData:Server_RemoveHireTeamMembers(cats)
  for i = 1, #cats do
    self:Server_RemoveHireTeamMember(cats[i])
  end
end
function MyselfTeamData:ClearHireTeamMembers()
  for key, catMember in pairs(self.hireMemberMap) do
    self.hireMemberList_dirty = true
    catMember:Exit()
    self.hireMemberMap[key] = nil
  end
end
function MyselfTeamData:Server_RemoveHireTeamMember(serverCat)
  local memberData = self.hireMemberMap[serverCat.id]
  if memberData then
    self.hireMemberList_dirty = true
    memberData:Exit()
  end
  self.hireMemberMap[serverCat.id] = nil
end
function MyselfTeamData:GetHireTeamMembers()
  if self.hireMemberList_dirty then
    self.hireMemberList_dirty = false
    TableUtility.ArrayClear(self.hireMemberList)
    for _, member in pairs(self.hireMemberMap) do
      table.insert(self.hireMemberList, member)
    end
    table.sort(self.hireMemberList, TeamData.SortTeamMember)
  end
  return self.hireMemberList
end
local strFormat = string.format
function MyselfTeamData:GetStrStatus()
  if self.state == SessionTeam_pb.ETEAMSTATE_MATCH then
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.TeamMemberListPopUp_Match)
  elseif self.state == SessionTeam_pb.ETEAMSTATE_PUBLISH then
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.TeamMemberListPopUp_Publish)
  else
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.TeamMemberListPopUp_Free)
  end
end
function MyselfTeamData:Exit()
  for _, v in pairs(self.membersMap) do
    self:RemoveMember(v.id)
  end
  RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_TEAMAPPLY)
  RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TEAMAPPLY)
  EventManager.Me():DispatchEvent(TeamEvent.ExitTeam)
end
