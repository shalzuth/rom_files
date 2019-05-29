AELotteryBannerData = class("AELotteryBannerData")
function AELotteryBannerData:ctor(data)
end
function AELotteryBannerData:SetData(data)
  if data ~= nil then
    helplog("AELotteryBannerData:SetData")
    self.id = data.id
    self.begintime = data.begintime
    self.endtime = data.endtime
    local banner = data.lotterybanner
    self.type = banner.lotterytype
    self.path = string.gsub(banner.path, "https", "http")
  end
end
function AELotteryBannerData:IsInActivity()
  if self.begintime ~= nil and self.endtime ~= nil then
    local server = ServerTime.CurServerTime() / 1000
    return server >= self.begintime and server <= self.endtime
  else
    return true
  end
end
function AELotteryBannerData:GetPath()
  return self.path
end
function AELotteryBannerData:getMultLanContent(serverData, key)
  if serverData[key] and serverData[key] ~= "" then
    return serverData[key]
  end
  local lanData = serverData.urls
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
