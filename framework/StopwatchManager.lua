autoImport("Stopwatch")
StopwatchManager = class("StopwatchManager")
StopwatchManager.MaxStopwatchCount = 100
function StopwatchManager.Me()
  if StopwatchManager.me == nil then
    StopwatchManager.me = StopwatchManager.new()
  end
  return StopwatchManager.me
end
function StopwatchManager:ctor()
  self.stopwatchMap = {}
end
function StopwatchManager:CreateStopwatch(pauseFunc, owner)
  local ownerStopwatches = self.stopwatchMap[owner]
  if ownerStopwatches == nil then
    ownerStopwatches = {}
    self.stopwatchMap[owner] = ownerStopwatches
  end
  local id = 0
  for i = 1, self.MaxStopwatchCount do
    if ownerStopwatches[i] == nil then
      id = i
      break
    end
  end
  if id == 0 then
    LogUtility.Warning("Stopwatch\229\183\178\230\187\161")
    return nil
  end
  local stopwatch = ownerStopwatches[id]
  if stopwatch == nil then
    stopwatch = Stopwatch.new(pauseFunc, owner, id)
    ownerStopwatches[id] = stopwatch
  else
    stopwatch:ResetData(pauseFunc, owner, id)
  end
  return stopwatch
end
function StopwatchManager:HasStopwatch(owner, id)
  local ownerStopwatches = self.stopwatchMap[owner]
  if ownerStopwatches == nil then
    return false
  end
  local stopwatch = ownerStopwatches[id]
  if stopwatch == nil then
    return false
  end
  return true
end
function StopwatchManager:ClearStopwatch(owner, id)
  local ownerStopwatches = self.stopwatchMap[owner]
  if ownerStopwatches ~= nil then
    if id ~= nil then
      local stopwatch = ownerStopwatches[id]
      if stopwatch ~= nil then
        stopwatch = nil
        ownerStopwatches[id] = nil
        local stillHasOne = false
        for id, stopwatch in pairs(ownerStopwatches) do
          stillHasOne = true
          break
        end
        if not stillHasOne then
          self.stopwatchMap[owner] = nil
        end
      end
    else
      for id, stopwatch in pairs(ownerStopwatches) do
        stopwatch = nil
      end
      self.stopwatchMap[owner] = nil
    end
  end
end
function StopwatchManager:ClearAll()
  for owner, stopwatches in pairs(self.stopwatchMap) do
    for id, stopwatch in pairs(stopwatches) do
      stopwatch = nil
    end
  end
  self.stopwatchMap = {}
end
