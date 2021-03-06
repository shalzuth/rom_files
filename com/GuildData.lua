GuildData = class("GuildData")
autoImport("GuildHeadData")
autoImport("GuildMemberData")
GuildSummaryType = {
  initType1 = "createtime",
  OtherGuildSummary1 = "curmember",
  OtherGuildSummary2 = "maxmember",
  OtherGuildSummary3 = "chairmanname",
  OtherGuildSummary4 = "guildname",
  OtherGuildSummary5 = "chairmangender"
}
local mapGuildEnumProp = function(enum, propName)
  if enum then
    GuildSummaryType[enum] = propName
  else
    helplog("enum is nil! propName is", propName)
  end
end
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ID, "guid")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_NAME, "name")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_LEVEL, "level")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_PORTRAIT, "portrait")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ASSET, "asset")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_DISMISSTIME, "dismisstime")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_BOARDINFO, "boardinfo")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_RECRUITINFO, "recruitinfo")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_QUEST_RESETTIME, "questresettime")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ZONEID, "zoneid")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ZONETIME, "zonetime")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_NEXTZONE, "nextzone")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_DONATETIME1, "donatetime1")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_DONATETIME2, "donatetime2")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ASSET_DAY, "assettoday")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_CITYID, "cityid")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_CITY_GIVEUP_CD, "citygiveuptime")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_OPEN_FUNCTION, "openfunction")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_TREASURE_GVG_COUNT, "gvg_treasure_count")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_TREASURE_GUILD_COUNT, "guild_treasure_count")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_TREASURE_BCOIN_COUNT, "bcoin_treasure_count")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_SUPERGVG, "insupergvg")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_SUPERGVG_LV, "supergvg_lv")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_MATERIAL_MACHINE_COUNT, "material_machine_count")
GuildData.PropertyTypeMap = {
  name = "string",
  boardinfo = "string",
  recruitinfo = "string",
  chairmanname = "string",
  guildname = "string",
  portrait = "string"
}
GuildJobType = {
  Chairman = GuildCmd_pb.EGUILDJOB_CHAIRMAN,
  ViceChairman = GuildCmd_pb.EGUILDJOB_VICE_CHAIRMAN,
  Member1 = GuildCmd_pb.EGUILDJOB_MEMBER1,
  Member2 = GuildCmd_pb.EGUILDJOB_MEMBER2,
  Member3 = GuildCmd_pb.EGUILDJOB_MEMBER3,
  Member4 = GuildCmd_pb.EGUILDJOB_MEMBER4,
  Member5 = GuildCmd_pb.EGUILDJOB_MEMBER5,
  Member6 = GuildCmd_pb.EGUILDJOB_MEMBER6,
  Member7 = GuildCmd_pb.EGUILDJOB_MEMBER7,
  Member8 = GuildCmd_pb.EGUILDJOB_MEMBER8,
  Member9 = GuildCmd_pb.EGUILDJOB_MEMBER9,
  Member10 = GuildCmd_pb.EGUILDJOB_MEMBER10
}
function GuildData:ctor(guildData)
  self.id = nil
  self.memberNum = 0
  self.maxMemberNum = 0
  self.membersMap = {}
  self.applysMap = {}
  self.jobMap = {}
  self:SetData(guildData)
end
function GuildData:GetPropertyType(key)
  return GuildData.PropertyTypeMap[key] or "number"
end
function GuildData:SetData(gdata)
  if gdata then
    for _, key in pairs(GuildSummaryType) do
      if gdata[key] then
        self[key] = gdata[key]
      else
        local summary = gdata.summary
        if summary and summary[key] then
          self[key] = summary[key]
        end
      end
    end
    self.id = self.guid
    self:UpdateStaticData()
    self:UpdateGuildJobInfos(gdata.jobs)
    self:SetMembers(gdata.members)
    self:SetApplys(gdata.applys)
  end
end
function GuildData:UpdateGuildJobInfos(server_jobs)
  if server_jobs and #server_jobs > 0 then
    local jobInfo
    for i = 1, #server_jobs do
      self:UpdateGuildJobInfo(server_jobs[i])
    end
  end
end
function GuildData:UpdateGuildJobInfo(single)
  local jobId = single.job
  if jobId then
    local jobInfo = self.jobMap[jobId]
    if jobInfo == nil then
      jobInfo = {}
      jobInfo.id = jobId
      self.jobMap[jobId] = jobInfo
    end
    local config = Table_GuildJob[jobId]
    if config == nil then
      helplog("Error Server Data ", tostring(jobId))
      return
    end
    if single.name ~= nil and single.name ~= "" then
      jobInfo.name = single.name
    else
      jobInfo.name = config.Name
    end
    jobInfo.auth = single.auth
    jobInfo.limitlv = config.OpenLevel
    jobInfo.editauth = single.editauth or 0
  end
end
function GuildData:UpdateStaticData(updateDatas)
  if self.level then
    local key = math.max(1, self.level)
    key = math.min(self.level, #Table_Guild)
    self.staticData = Table_Guild[key]
    self.maxMemberNum = self.staticData and self.staticData.MemberNum or 0
  end
end
function GuildData:UpdateData(updateDatas)
  local jobNameUpdate = false
  for i = 1, #updateDatas do
    local single = updateDatas[i]
    local type, value, data = single.type, single.value, single.data
    local key = GuildSummaryType[type]
    if key then
      local propertyType = self:GetPropertyType(key)
      if propertyType == "string" then
        self[key] = data or ""
      else
        self[key] = value
      end
    end
  end
  if jobNameUpdate then
    for _, member in pairs(self.membersMap) do
      member:UpdateJobInfo(self.jobInfo)
    end
  end
  self:UpdateStaticData()
end
function GuildData:SetMembers(smDatas)
  if smDatas then
    for i = 1, #smDatas do
      member = self:SetMember(smDatas[i])
    end
  end
end
function GuildData:SetMember(serviceGuildMember)
  local member = self:GetMemberByGuid(serviceGuildMember.charid)
  if not member then
    member = self:AddMember(serviceGuildMember)
  else
    local cacheOffline = member:IsOffline()
    member:SetData(serviceGuildMember)
  end
  return member
end
function GuildData:AddMember(serviceGuildMember)
  if serviceGuildMember then
    local newMember = GuildMemberData.new(serviceGuildMember, self)
    self.membersMap[serviceGuildMember.charid] = newMember
    self.memberNum = self.memberNum + 1
    return newMember
  end
end
function GuildData:RemoveMembers(dels)
  for i = 1, #dels do
    self:RemoveMember(dels[i])
  end
end
function GuildData:RemoveMember(guid)
  local catchMember = self:GetMemberByGuid(guid)
  if catchMember then
    self.membersMap[guid] = nil
    self.memberNum = self.memberNum - 1
  end
  return catchMember
end
function GuildData:GetMemberByGuid(guid)
  return self.membersMap[guid]
end
function GuildData:GetMemberList()
  local result = {}
  for k, v in pairs(self.membersMap) do
    table.insert(result, v)
  end
  return result
end
function GuildData:SetApplys(applys)
  if applys and #applys > 0 then
    for i = 1, #applys do
      self:SetApply(applys[i])
    end
  end
end
function GuildData:SetApply(serviceGuildApply)
  local catchApply = self:GetApplyByGuid(serviceGuildApply.charid)
  if not catchApply then
    catchApply = self:AddApply(serviceGuildApply)
  else
    catchApply:SetData(serviceGuildApply)
  end
  return catchApply
end
function GuildData:AddApply(apply)
  if apply and apply.charid then
    local catchApply = GuildMemberData.new(apply)
    self.applysMap[apply.charid] = catchApply
    return catchApply
  end
end
function GuildData:RemoveApplys(dels)
  for i = 1, #dels do
    self:RemoveApply(dels[i])
  end
end
function GuildData:RemoveApply(guid)
  local catchApply = self:GetApplyByGuid(guid)
  if catchApply then
    self.applysMap[guid] = nil
  end
  return catchApply
end
function GuildData:GetApplyByGuid(guid)
  return self.applysMap[guid]
end
function GuildData:GetApplyList()
  local result = {}
  for k, v in pairs(self.applysMap) do
    table.insert(result, v)
  end
  return result
end
function GuildData:ClearApplyList()
  self.applysMap = {}
end
function GuildData:GetChairMan()
  for _, member in pairs(self.membersMap) do
    if member.job == GuildJobType.Chairman then
      return member
    end
  end
  local _, errorChairMan = next(self.membersMap)
  return errorChairMan
end
function GuildData:GetViceChairmanList()
  local result = {}
  for _, member in pairs(self.membersMap) do
    if member.job == GuildJobType.ViceChairman then
      table.insert(result, member)
    end
  end
  return result
end
function GuildData:GetOnlineMembers()
  local result = {}
  for _, member in pairs(self.membersMap) do
    if not member:IsOffline() then
      table.insert(result, member)
    end
  end
  return result
end
function GuildData:GetUpgradeConfig()
  return self:GetGuildConfig(self.level + 1)
end
function GuildData:GetGuildConfig(level)
  level = level or self.level
  local maxlv = 1
  for lv, _ in pairs(Table_Guild) do
    maxlv = math.max(maxlv, lv)
  end
  level = math.min(level, maxlv)
  level = math.max(1, level)
  return Table_Guild[level]
end
function GuildData:GetNextDonateTime()
  if self.donatetime1 and self.donatetime2 then
    return self.donatetime1 < self.donatetime2 and self.donatetime1 or self.donatetime2
  end
  return 0
end
function GuildData:GetJobMap()
  return self.jobMap
end
function GuildData:GetJobAuthValue(job)
  if self.jobMap[job] then
    return self.jobMap[job].auth
  end
end
function GuildData:GetJobName(job)
  if self.jobMap[job] then
    return self.jobMap[job].name
  end
end
function GuildData:GetJobEditAuth(job)
  if self.jobMap[job] then
    return self.jobMap[job].editauth
  end
end
function GuildData:CheckFunctionOpen(etype)
  local v = 1 << etype - 1
  local openfunction = self.openfunction or 0
  return v & openfunction > 0
end
function GuildData:Exit()
end
