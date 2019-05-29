autoImport("ZoneData")
ChangeZoneProxy = class("ChangeZoneProxy", pm.Proxy)
ChangeZoneProxy.Instance = nil
ChangeZoneProxy.NAME = "ChangeZoneProxy"
ChangeZoneProxy.TypeEnum = {
  ChangeLine = "ChangeLine",
  BackGuildLine = "BackGuildLine",
  ChangeGuildLine = "ChangeGuildLine"
}
CONFIG_ZONE_ID_SUF = {
  "",
  "a",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "k",
  "m",
  "n",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "aa",
  "cc",
  "dd",
  "ee",
  "ff",
  "gg",
  "hh",
  "kk"
}
INVERSE_CONFIG_ZONE_ID_SUF = {}
for i = 1, #CONFIG_ZONE_ID_SUF do
  local v = CONFIG_ZONE_ID_SUF[i]
  INVERSE_CONFIG_ZONE_ID_SUF[v] = i
end
function ChangeZoneProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ChangeZoneProxy.NAME
  if ChangeZoneProxy.Instance == nil then
    ChangeZoneProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function ChangeZoneProxy:Init()
  self.infos = {}
  self.recents = {}
end
function ChangeZoneProxy:RecvQueryZoneStatus(data)
  self:RecvInfos(data)
  self:RecvRecents(data)
end
function ChangeZoneProxy:RecvInfos(data)
  TableUtility.TableClear(self.infos)
  if data.infos then
    for i = 1, #data.infos do
      local zoneData = ZoneData.new(data.infos[i])
      self.infos[zoneData.zoneid] = zoneData
    end
    if #data.infos > 0 then
      self.minZoneId = data.infos[1].zoneid
      self.maxZoneId = data.infos[#data.infos].zoneid
    end
  end
end
local tempRecentZoneInfo = {}
function ChangeZoneProxy:RecvRecents(data)
  TableUtility.ArrayClear(self.recents)
  if data.recents then
    for i = 1, #data.recents do
      local recentData = ZoneData.new(data.recents[i])
      TableUtility.ArrayPushBack(self.recents, recentData)
    end
  end
  if GuildProxy.Instance:IHaveGuild() then
    TableUtility.TableClear(tempRecentZoneInfo)
    tempRecentZoneInfo.type = ZoneData.JumpZone.Guild
    tempRecentZoneInfo.zoneid = GuildProxy.Instance.myGuildData.zoneid
    local recentData = ZoneData.new(tempRecentZoneInfo)
    TableUtility.ArrayPushBack(self.recents, recentData)
  end
  if TeamProxy.Instance:IHaveTeam() then
    local leader = TeamProxy.Instance.myTeam:GetNowLeader()
    if leader then
      TableUtility.TableClear(tempRecentZoneInfo)
      tempRecentZoneInfo.type = ZoneData.JumpZone.Team
      tempRecentZoneInfo.zoneid = leader.zoneid
      local recentData = ZoneData.new(tempRecentZoneInfo)
      TableUtility.ArrayPushBack(self.recents, recentData)
    end
  end
  table.sort(self.recents, function(l, r)
    if l.type == r.type then
      return false
    else
      return l.type < r.type
    end
  end)
end
function ChangeZoneProxy:GetInfos(zoneid)
  return self.infos[zoneid]
end
function ChangeZoneProxy:GetRecents()
  return self.recents
end
function ChangeZoneProxy:GetMinZoneId()
  return self.minZoneId or 1
end
function ChangeZoneProxy:GetMaxZoneId()
  return self.maxZoneId or 1
end
function ChangeZoneProxy:ZoneNumToString(num, formatStr)
  if num then
    if type(num) ~= "number" then
      num = tonumber(num)
    end
    if num and num > 0 then
      if num >= 9999 then
        num = math.fmod(num, 10000)
      end
      if num >= 9000 then
        return ZhString.ChangeZoneProxy_PvpLine
      end
      if UnionConfig and UnionConfig.Zone then
        local unionZoneList = UnionConfig.Zone.zone_name
        if unionZoneList then
          for i = 1, #unionZoneList do
            local zone = unionZoneList[i]
            if num >= zone.min and num <= zone.max then
              return zone.name_prefix .. num - zone.min + 1
            end
          end
        end
      end
      local length = #CONFIG_ZONE_ID_SUF
      local n1 = math.ceil(num / length)
      local n2 = num % length
      if n2 == 0 then
        n2 = n2 + length
      end
      n2 = CONFIG_ZONE_ID_SUF[n2]
      if formatStr then
        return string.format(formatStr, n1 .. n2)
      else
        return n1 .. n2
      end
    end
  end
  errorLog(string.format("error when ZoneNumToString(%s)", tostring(num)))
  return ""
end
function ChangeZoneProxy:ZoneStringToNum(zoneStr)
  if zoneStr then
    local n1, n2 = "", ""
    for i = 1, string.len(zoneStr) do
      local c = string.char(string.byte(zoneStr, i))
      if tonumber(c) == nil then
        n2 = n2 .. c
      else
        n1 = n1 .. c
      end
    end
    if n1 ~= nil and n1 ~= "" and n2 ~= nil then
      n1 = tonumber(n1)
      n2 = string.lower(n2)
      if INVERSE_CONFIG_ZONE_ID_SUF[n2] then
        n2 = INVERSE_CONFIG_ZONE_ID_SUF[n2]
        return (n1 - 1) * #CONFIG_ZONE_ID_SUF + n2
      end
    end
  end
  return 0
end
