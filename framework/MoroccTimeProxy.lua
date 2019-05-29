MoroccTimeProxy = class("MoroccTimeProxy", pm.Proxy)
MoroccTimeProxy.Instance = nil
MoroccTimeProxy.NAME = "MoroccTimeProxy"
autoImport("SealData")
function MoroccTimeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MoroccTimeProxy.NAME
  if MoroccTimeProxy.Instance == nil then
    MoroccTimeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitMorrocTimeData()
end
function MoroccTimeProxy:InitMorrocTimeData()
  self.moroccActDataMap = {}
  self.moroccActStartTimeArray = {}
  local branch
  if EnvChannel.IsTFBranch() then
    branch = 1
  elseif EnvChannel.IsReleaseBranch() then
    branch = 2
  end
  local data
  for i = 1, #Table_MoroccTime do
    data = Table_MoroccTime[i]
    if data.ServerManager == branch then
      self.moroccActDataMap[data.StrarTime] = data
      TableUtility.ArrayPushBack(self.moroccActStartTimeArray, data.StrarTime)
    end
  end
  if not next(self.moroccActStartTimeArray) then
    self.moroccActDataMap = nil
    self.moroccActStartTimeArray = nil
  else
    table.sort(self.moroccActStartTimeArray)
  end
end
local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local ddd = tonumber(os.date("%z", 0)) / 100
local offset = (8 - ddd) * 3600
local timeTable = {}
local timeStrToTime = function(timeStr)
  timeTable.year, timeTable.month, timeTable.day, timeTable.hour, timeTable.min, timeTable.sec = timeStr:match(p)
  return os.time(timeTable) - offset
end
local isNowTimeEarlierThan = function(timeStr)
  local curServerTime = ServerTime.CurServerTime()
  if not curServerTime then
    return nil
  end
  curServerTime = curServerTime / 1000
  return curServerTime < timeStrToTime(timeStr)
end
local checkNowTimeBetween = function(startTimeStr, endTimeStr)
  if not startTimeStr or not endTimeStr then
    return nil
  end
  return not isNowTimeEarlierThan(startTimeStr) and isNowTimeEarlierThan(endTimeStr)
end
function MoroccTimeProxy:GetCurrentMoroccTimeData()
  if not self.moroccActDataMap then
    return nil
  end
  local startTimeStr
  for i = 1, #self.moroccActStartTimeArray - 1 do
    if checkNowTimeBetween(self.moroccActStartTimeArray[i], self.moroccActStartTimeArray[i + 1]) then
      startTimeStr = self.moroccActStartTimeArray[i]
      break
    end
  end
  if startTimeStr then
    local data = self.moroccActDataMap[startTimeStr]
    if checkNowTimeBetween(data.StrarTime, data.EndTime) then
      return data
    end
  else
    local lastStr = self.moroccActStartTimeArray[#self.moroccActStartTimeArray]
    local lastData = self.moroccActDataMap[lastStr]
    if checkNowTimeBetween(lastData.StrarTime, lastData.EndTime) then
      return lastData
    end
  end
  return nil
end
function MoroccTimeProxy:GetNextMoroccTimeData()
  if not self.moroccActDataMap then
    return nil
  end
  local startTimeStr
  for i = 1, #self.moroccActStartTimeArray - 1 do
    if checkNowTimeBetween(self.moroccActStartTimeArray[i], self.moroccActStartTimeArray[i + 1]) then
      startTimeStr = self.moroccActStartTimeArray[i + 1]
      break
    end
  end
  if startTimeStr then
    return self.moroccActDataMap[startTimeStr]
  else
    local firstData = self.moroccActDataMap[self.moroccActStartTimeArray[1]]
    if isNowTimeEarlierThan(firstData.StrarTime) then
      return firstData
    end
  end
  return nil
end
function MoroccTimeProxy:GetNextMoroccActStartTime()
  local nextMoroccData = self:GetNextMoroccTimeData()
  if not nextMoroccData then
    return nil
  end
  return timeStrToTime(nextMoroccData.StrarTime)
end
function MoroccTimeProxy:GetPeriodFromNowToNextMoroccActStart()
  local nextMoroccActStartTime = self:GetNextMoroccActStartTime()
  local curServerTime = ServerTime.CurServerTime()
  if not nextMoroccActStartTime or not curServerTime then
    return nil
  end
  curServerTime = curServerTime / 1000
  return nextMoroccActStartTime - curServerTime
end
function MoroccTimeProxy:IsMoroccActivity(activityId)
  if not activityId then
    return false
  end
  for _, data in pairs(self.moroccActDataMap) do
    if data.ActivityID == activityId then
      return true
    end
  end
  return false
end
function MoroccTimeProxy:IsInMorrocTime()
  local startTimeStr, endTimeStr
  if EnvChannel.IsTFBranch() then
    startTimeStr = GameConfig.MoroccTime.start_time_TF
    endTimeStr = GameConfig.MoroccTime.end_time_TF
  elseif EnvChannel.IsReleaseBranch() then
    startTimeStr = GameConfig.MoroccTime.start_time_release
    endTimeStr = GameConfig.MoroccTime.end_time_release
  end
  if not startTimeStr or not endTimeStr then
    return false
  end
  return not isNowTimeEarlierThan(startTimeStr) and isNowTimeEarlierThan(endTimeStr)
end
function MoroccTimeProxy:AddMoroccSealData(activityId, mapId, raidId, npcId)
  if not self.moroccSealData then
    self.moroccSealData = {}
  end
  self.moroccSealData[activityId] = ReusableTable.CreateTable()
  self.moroccSealData[activityId].mapId = mapId
  self.moroccSealData[activityId].raidId = raidId
  self.moroccSealData[activityId].npcId = npcId
end
function MoroccTimeProxy:RemoveMoroccSealData(activityId)
  if not self.moroccSealData then
    LogUtility.Warning("There's no MorrocSealData to remove!!")
    return
  end
  if not self.moroccSealData[activityId] then
    LogUtility.WarningFormat("There's no MorrocSealData with activityId={0} to remove!!", activityId)
    return
  end
  ReusableTable.DestroyAndClearTable(self.moroccSealData[activityId])
  self.moroccSealData[activityId] = nil
  if not next(self.moroccSealData) then
    self.moroccSealData = nil
  end
end
function MoroccTimeProxy:ClearMoroccSealData()
  for activityId, _ in pairs(self.moroccSealData) do
    self:RemoveMoroccSealData(activityId)
  end
end
function MoroccTimeProxy:GetMoroccSealData()
  return self.moroccSealData
end
