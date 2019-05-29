ActivitySubData = class("ActivitySubData")
function ActivitySubData:ctor(serverData)
  self:updateData(serverData)
end
function ActivitySubData:updateData(serverData)
  self.id = serverData.id
  self.name = serverData.name
  self.begintime = serverData.begintime
  self.endtime = serverData.endtime
  self.pathtype = serverData.pathtype
  self.pathevent = serverData.pathevent
  self.url = self:getMultLanContent(serverData, "url")
  self.pic_url = self:getMultLanContent(serverData, "pic_url")
  self.pic_url = string.gsub(self.pic_url, "https", "http")
  self.url = string.gsub(self.url, "https", "http")
  self.groupid = serverData.groupid
end
function ActivitySubData:getMultLanContent(serverData, key)
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
