ActivityGroupData = class("ActivityGroupData")
function ActivityGroupData:ctor(serverData)
  self:updateData(serverData)
end
function ActivityGroupData:updateData(serverData)
  self.id = serverData.id
  self.name = serverData.name
  self.iconurl = self:getMultLanContent(serverData, "iconurl")
  self.begintime = serverData.begintime
  self.endtime = serverData.endtime
  self.url = self:getMultLanContent(serverData, "url")
  self.iconurl = string.gsub(self.iconurl, "https", "http")
  self.url = string.gsub(self.url, "https", "http")
  self.countdown = serverData.countdown
  local sub_activity = serverData.sub_activity
  if #sub_activity > 0 then
    local sub_activity_ = {}
    for i = 1, #sub_activity do
      local singleSub = sub_activity[i]
      local subData = ActivitySubData.new(singleSub)
      sub_activity_[#sub_activity_ + 1] = subData
    end
    self.sub_activity = sub_activity_
  end
end
function ActivityGroupData:getMultLanContent(serverData, key)
  if serverData[key] and serverData[key] ~= "" then
    return serverData[key]
  end
  local lanData = serverData.data
  lanData = lanData[key]
  if not lanData then
    return ""
  end
  local language = ApplicationInfo.GetSystemLanguage()
  for i = 1, #lanData do
    local single = lanData[i]
    if single.language == language then
      return single.url
    end
  end
end
