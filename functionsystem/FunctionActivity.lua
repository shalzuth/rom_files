autoImport("ActivityData")
FunctionActivity = class("FunctionActivity")
local math_floor = math.floor
local tempArray = {}
FunctionActivity.TraceType = {
  NeedRefresh = 0,
  Refreshed = 1,
  Update = 2
}
local MapManager
local f_GetType = ActivityData.GetTraceQuestDataType
local f_GetId = ActivityData.CreateIdByType
function FunctionActivity.Me()
  if nil == FunctionActivity.me then
    FunctionActivity.me = FunctionActivity.new()
  end
  return FunctionActivity.me
end
function FunctionActivity:ctor()
  self.activityDataMap = {}
  self.tracedActivityMap = {}
  self.countDownDataMap = {}
  MapManager = Game.MapManager
end
function FunctionActivity:GetMapEvents(mapid)
  TableUtility.ArrayClear(tempArray)
  for activityType, activityData in pairs(self.activityDataMap) do
    if activityData.mapid == mapid then
      table.insert(tempArray, activityData)
    end
  end
  return tempArray
end
function FunctionActivity:Launch(activityType, mapid, startTime, endTime)
  local logStr = ""
  logStr = "\230\180\187\229\138\168\229\188\128\229\144\175 --> "
  local dateFormat = "%m:%d %H:%M:%S\231\167\146"
  logStr = logStr .. string.format(" | activityType:%s | \229\156\176\229\155\190Id:%s | \229\188\128\229\167\139\230\151\182\233\151\180:%s | \231\187\147\230\157\159\230\151\182\233\151\180:%s | \229\189\147\229\137\141\230\151\182\233\151\180:%s | ", tostring(activityType), tostring(mapid), os.date(dateFormat, startTime), os.date(dateFormat, endTime), os.date(dateFormat, ServerTime.CurServerTime() / 1000))
  helplog(logStr)
  local activityData = self.activityDataMap[activityType]
  if activityData == nil then
    activityData = self:AddActivityData(activityType, mapid, startTime, endTime)
  else
    activityData:UpdateInfo(mapid, startTime, endTime)
  end
  if activityData:IsShowInMenu() then
    GameFacade.Instance:sendNotification(MainViewEvent.MenuActivityOpen, activityType)
  end
  if activityType == GameConfig.MvpBattle.ActivityID then
    GameFacade.Instance:sendNotification(MainViewEvent.UpdateMatchBtn)
  elseif MoroccTimeProxy.Instance:IsInMorrocTime() and MoroccTimeProxy.Instance:IsMoroccActivity(activityType) then
    GameFacade.Instance:sendNotification(MoroccTimeEvent.ActivityOpen)
  end
  self:UpdateNowMapTraceInfo()
end
function FunctionActivity:UpdateState(activityType, state, starttime, endtime)
  local activityData = self.activityDataMap[activityType]
  if activityData then
    activityData:SetState(state, starttime, endtime)
    self:UpdateNowMapTraceInfo()
  else
    errorLog(string.format("Activity:%s not Launch when Recv StateUpdate", tostring(activityType)))
  end
end
function FunctionActivity:IsActivityRunning(activityType)
  local d = self.activityDataMap[activityType]
  if d == nil then
    return false
  end
  return d:InRunningTime()
end
function FunctionActivity:GetActivityData(activityType)
  return self.activityDataMap[activityType]
end
function FunctionActivity:AddActivityData(activityType, mapid, startTime, endTime)
  local activityData = ActivityData.new(activityType, mapid, startTime, endTime)
  self.activityDataMap[activityType] = activityData
  return activityData
end
function FunctionActivity:RemoveActivityData(activityType)
  local oldData = self.activityDataMap[activityType]
  self.activityDataMap[activityType] = nil
  if not oldData then
    return
  end
  if oldData:IsShowInMenu() then
    GameFacade.Instance:sendNotification(MainViewEvent.MenuActivityClose, activityType)
  end
  if MoroccTimeProxy.Instance:IsInMorrocTime() and MoroccTimeProxy.Instance:IsMoroccActivity(activityType) then
    GameFacade.Instance:sendNotification(MoroccTimeEvent.ActivityClose)
  end
  oldData:Destroy()
end
local removeTraceCells = {}
function FunctionActivity:UpdateNowMapTraceInfo()
  for activityType, _ in pairs(self.tracedActivityMap) do
    if not self.activityDataMap[activityType] then
      local data = {}
      data.id = f_GetId(activityType)
      data.type = f_GetType(activityType)
      table.insert(removeTraceCells, data)
      self.tracedActivityMap[activityType] = nil
    end
  end
  local tracedCount = 0
  local nowMapId = MapManager:GetMapID()
  for activityType, activityData in pairs(self.activityDataMap) do
    local needTrace = activityData:IsNeedTrace(nowMapId)
    if needTrace then
      if activityData:IsTraceInfo_NeedUpdate() then
        self.tracedActivityMap[activityType] = FunctionActivity.TraceType.Update
      else
        self.tracedActivityMap[activityType] = FunctionActivity.TraceType.NeedRefresh
      end
      tracedCount = tracedCount + 1
    elseif self.tracedActivityMap[activityType] then
      local data = {}
      data.id = f_GetId(activityType)
      data.type = f_GetType(activityType)
      table.insert(removeTraceCells, data)
      self.tracedActivityMap[activityType] = nil
    end
  end
  if #removeTraceCells > 0 then
    QuestProxy.Instance:RemoveTraceCells(removeTraceCells)
    TableUtility.ArrayClear(removeTraceCells)
  end
  if tracedCount == 0 then
    self:RemoveTraceTimeTick()
  else
    self:AddTraceTimeTick()
  end
end
local cache_RunningMap = {}
function FunctionActivity:AddTraceTimeTick()
  if not self.traceTimeTick then
    TableUtility.TableClear(cache_RunningMap)
    self.traceTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateActivityTraceInfos, self, 1)
  end
end
function FunctionActivity:RemoveTraceTimeTick()
  if self.traceTimeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.traceTimeTick = nil
    TableUtility.TableClear(cache_RunningMap)
  end
end
local updateTraceCells = {}
function FunctionActivity:UpdateActivityTraceInfos()
  local needUpdate, activityData
  local nowMapId = MapManager:GetMapID()
  for traceAType, traceType in pairs(self.tracedActivityMap) do
    needUpdate = false
    activityData = self.activityDataMap[traceAType]
    local running = activityData:InRunningTime()
    if traceType == FunctionActivity.TraceType.NeedRefresh then
      self.tracedActivityMap[traceAType] = FunctionActivity.TraceType.Refreshed
      needUpdate = true
    elseif traceType == FunctionActivity.TraceType.Update and running then
      needUpdate = true
    end
    if activityData == nil then
      self.tracedActivityMap[traceAType] = nil
      redlog(string.format("activity(type:%s) accident break.", traceAType))
    end
    if running ~= cache_RunningMap[traceAType] then
      needUpdate = running
      if not running then
        local data = {}
        data.id = f_GetId(traceAType)
        data.type = f_GetType(traceAType)
        table.insert(removeTraceCells, data)
      end
      cache_RunningMap[traceAType] = running
    end
    if needUpdate then
      local traceInfo = activityData:GetTraceInfo(nowMapId)
      if traceInfo then
        table.insert(updateTraceCells, traceInfo)
      end
    end
  end
  if #updateTraceCells > 0 then
    QuestProxy.Instance:AddTraceCells(updateTraceCells)
    TableUtility.ArrayClear(updateTraceCells)
  end
  if #removeTraceCells > 0 then
    QuestProxy.Instance:RemoveTraceCells(removeTraceCells)
    TableUtility.ArrayClear(removeTraceCells)
  end
end
function FunctionActivity:ShutDownActivity(activityType)
  self:RemoveActivityData(activityType)
  self:UpdateNowMapTraceInfo()
end
function FunctionActivity:Reset()
  for activityType, activityData in pairs(self.activityDataMap) do
    self:RemoveActivityData(activityType)
  end
  self:UpdateNowMapTraceInfo()
end
function FunctionActivity:AddCountDownAct(id, startTime, endTime)
  local countDownData = self.countDownDataMap[id]
  if countDownData == nil then
    countDownData = {}
    self.countDownDataMap[id] = countDownData
  end
  countDownData.id = id
  countDownData.startTime = startTime
  countDownData.endTime = endTime
  if id == 28 then
    countDownData.startTime = startTime - 3600
    countDownData.endTime = endTime - 3600
    xdlog("\229\164\132\231\144\134\230\152\165\232\138\130\230\180\187\229\138\168", countDownData.startTime, countDownData.endTime)
  end
  local effectConfig = GameConfig.ActivityCountDown and GameConfig.ActivityCountDown[id]
  if effectConfig then
    countDownData.effectPath = effectConfig.effectPath
    countDownData.finalEffectPath = effectConfig.finalEffectPath
  end
  self:UpdateCountDownAct()
end
function FunctionActivity:RemoveCountDownAct(id)
  local countDownData = self.countDownDataMap[id]
  if countDownData == nil then
    return
  end
  self.countDownDataMap[id] = nil
  self:UpdateCountDownAct()
end
function FunctionActivity:UpdateCountDownAct()
  local nowServerTime = ServerTime.CurServerTime() / 1000
  local needUpdate = false
  for id, countDownData in pairs(self.countDownDataMap) do
    if nowServerTime < countDownData.endTime then
      needUpdate = true
    end
  end
  if needUpdate then
    if self.countDownTick == nil then
      self.countDownTick = TimeTickManager.Me():CreateTick(0, 33, self._UpdateCountDown, self, 2)
    end
  else
    self:RemoveCountDownTick()
  end
end
function FunctionActivity:_UpdateCountDown()
  local nowServerTime = ServerTime.CurServerTime() / 1000
  TableUtility.ArrayClear(tempArray)
  local leftSec
  for id, data in pairs(self.countDownDataMap) do
    if nowServerTime >= data.startTime then
      leftSec = math_floor(data.endTime - nowServerTime)
      if leftSec < 0 then
        table.insert(tempArray, id)
      elseif data.leftSec ~= leftSec then
        data.leftSec = leftSec
        self:PlayCountDownEffect(id, leftSec, data.effectPath, data.finalEffectPath)
      end
    end
  end
  for i = 1, #tempArray do
    self:RemoveCountDownAct(tempArray[i])
  end
end
function FunctionActivity:RemoveCountDownTick()
  if self.countDownTick == nil then
    return
  end
  TimeTickManager.Me():ClearTick(self, 2)
  self.countDownTick = nil
end
function FunctionActivity:PlayCountDownEffect(id, leftSec, effectPath, finalEffectPath)
  if finalEffectPath and leftSec == 0 then
    FloatingPanel.Instance:PlayMidEffect(finalEffectPath)
    return
  end
  local callBack = function(effectHandle)
    local timeNum = UIUtil.FindComponent("Num", UITexture, effectHandle.gameObject)
    if timeNum then
      PictureManager.Instance:SetUI("time_text_" .. leftSec, timeNum)
    end
  end
  FloatingPanel.Instance:PlayMidEffect(effectPath, callBack)
end
