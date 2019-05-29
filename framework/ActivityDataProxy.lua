ActivityDataProxy = class("ActivityDataProxy", pm.Proxy)
ActivityDataProxy.Instance = nil
ActivityDataProxy.NAME = "ActivityDataProxy"
autoImport("ActivityGroupData")
autoImport("ActivitySubData")
function ActivityDataProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityDataProxy.NAME
  if ActivityDataProxy.Instance == nil then
    ActivityDataProxy.Instance = self
  end
  self.activitys = {}
end
function ActivityDataProxy:InitActivityDatas(data)
  TableUtility.ArrayClear(self.activitys)
  local activitys = data.activity
  if activitys and #activitys > 0 then
    for i = 1, #activitys do
      local single = activitys[i]
      local data = ActivityGroupData.new(single)
      self.activitys[#self.activitys + 1] = data
    end
  end
end
function ActivityDataProxy:getActiveActivitys()
  if self.activitys and #self.activitys > 0 then
    local result = {}
    local currentTime = ServerTime.CurServerTime()
    currentTime = math.floor(currentTime / 1000)
    for i = 1, #self.activitys do
      local single = self.activitys[i]
      if currentTime >= single.begintime and currentTime <= single.endtime then
        local subActs = single.sub_activity
        local valid = false
        if subActs and #subActs > 0 then
          for i = 1, #subActs do
            local singleSub = subActs[i]
            if currentTime >= singleSub.begintime and currentTime <= singleSub.endtime then
              valid = true
              break
            end
          end
        end
        if valid then
          result[#result + 1] = single
        end
      end
    end
    return result
  end
end
function ActivityDataProxy:getActiveSubActivitys(groupId)
  local currentTime = ServerTime.CurServerTime()
  currentTime = math.floor(currentTime / 1000)
  for i = 1, #self.activitys do
    local activity = self.activitys[i]
    if activity.id == groupId then
      local subActs = activity.sub_activity
      if subActs and #subActs > 0 then
        local result = {}
        for i = 1, #subActs do
          local single = subActs[i]
          if currentTime >= single.begintime and currentTime <= single.endtime then
            result[#result + 1] = single
          end
        end
        return result
      end
      break
    end
  end
end
function ActivityDataProxy:getActivitys()
  return self.activitys
end
