FunctionLoginAnnounce = class("FunctionLoginAnnounce")
function FunctionLoginAnnounce.Me()
  if nil == FunctionLoginAnnounce.me then
    FunctionLoginAnnounce.me = FunctionLoginAnnounce.new()
  end
  return FunctionLoginAnnounce.me
end
function FunctionLoginAnnounce:ctor()
  self.hasShowedAnnouncement = false
end
function FunctionLoginAnnounce:requestAnnouncement()
  if self.hasShowedAnnouncement then
    FunctionLogin.Me():launchAndLoginSdk()
    return
  end
  local address = NetConfig.AnnounceAddress
  local url = "https://%s/%s"
  local timestamp = os.time()
  local plat = FunctionLogin:getFunctionSdk():GetPlat()
  local channelId = "1"
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android then
    channelId = "2"
  end
  local fileName = "%s-%s.json"
  fileName = string.format(fileName, plat, channelId, timestamp)
  url = string.format(url, address, fileName)
  self:doRequest(url, function(status, content)
    self:announceHandle(status, content)
    GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
  end)
  GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
end
function FunctionLoginAnnounce:doRequest(url, callback)
  LogUtility.Info("FunctionLogin:requestGetUrlHost address url:" .. url)
  Game.WWWRequestManager:SimpleRequest(url, 5, function(www)
    local content = www.text
    local responseHeaders = www.responseHeaders
    local date = responseHeaders.Date
    self.hasHandleRes = true
    local p = "%a+, (%d+) (%a+) (%d+) (%d+):(%d+):(%d+) GMT"
    local day, month, year, hour, min, sec = date:match(p)
    local MON = {
      Jan = 1,
      Feb = 2,
      Mar = 3,
      Apr = 4,
      May = 5,
      Jun = 6,
      Jul = 7,
      Aug = 8,
      Sep = 9,
      Oct = 10,
      Nov = 11,
      Dec = 12
    }
    local month = MON[month]
    local curTime = os.time({
      day = day,
      month = month,
      year = year,
      hour = hour,
      min = min,
      sec = sec
    })
    self.curTime = curTime
    callback(NetConfig.ResponseCodeOk, content)
  end, function(www, error)
    if self.hasHandleRes then
      return
    end
    self.hasHandleRes = true
    callback(FunctionLogin.AuthStatus.OherError)
  end, function(www)
    if self.hasHandleRes then
      return
    end
    self.hasHandleRes = true
    callback(FunctionLogin.AuthStatus.OherError)
  end)
  self.hasHandleRes = false
end
function FunctionLoginAnnounce:announceHandle(status, content)
  if status == NetConfig.ResponseCodeOk then
    self:doAnnounce(content)
  elseif status ~= NetConfig.ResponseCodeOk then
    FunctionLogin.Me():launchAndLoginSdk()
  end
end
function FunctionLoginAnnounce:checkTimeValid(startT, endT)
  local result = false
  local isCall = pcall(function(i)
    startT = tonumber(startT)
    endT = tonumber(endT)
    local timeStr1 = os.date("%Y-%m-%d %H:%M:%S", startT)
    local timeStr2 = os.date("%Y-%m-%d %H:%M:%S", endT)
    local timeStr3 = os.date("%Y-%m-%d %H:%M:%S", self.curTime)
    LogUtility.InfoFormat("checkTimeValid startT:{0},endT:{1},curTime:{2}", timeStr1, timeStr2, timeStr3)
    if self.curTime and self.curTime >= startT and self.curTime <= endT then
      result = true
    end
  end)
  return isCall and result
end
function FunctionLoginAnnounce:doAnnounce(content)
  local result = StringUtil.Json2Lua(content)
  local result
  local isCall = pcall(function(i)
    result = StringUtil.Json2Lua(content)
    if result == nil then
      result = json.decode(content)
    end
  end)
  if result then
    local msg = result.msg
    local tips = result.tips
    local picURL = result.picture
    local startT = result.startTime
    local endT = result.endTime
    local valid = self:checkTimeValid(startT, endT)
    local contentValid = msg and msg ~= "" or tips and tips ~= "" or picURL and picURL ~= ""
    if contentValid and valid then
      FloatingPanel.Instance:ShowMaintenanceMsg(ZhString.ServiceErrorUserCmdProxy_Maintain, msg, tips, ZhString.ServiceErrorUserCmdProxy_Confirm, picURL, function()
        FunctionLogin.Me():launchAndLoginSdk()
      end)
      self.hasShowedAnnouncement = true
    else
      FunctionLogin.Me():launchAndLoginSdk()
    end
  else
    FunctionLogin.Me():launchAndLoginSdk()
  end
end
function FunctionLoginAnnounce:showCDNAnnounce()
  local address = NetConfig.AnnounceAddress
  local url = "https://%s/%s"
  local timestamp = os.time()
  local plat = FunctionLogin:getFunctionSdk():GetPlat()
  local channelId = "1"
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android then
    channelId = "2"
  end
  local fileName = "%s-%s.json?timestamp=%s"
  fileName = string.format(fileName, plat, channelId, timestamp)
  url = string.format(url, address, fileName)
  Debug.Log("showCDNAnnounce:" .. url)
  self:doRequest(url, function(status, content)
    self:handleCDNAnnounce(status, content)
    GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
  end)
  GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
end
function FunctionLoginAnnounce:handleCDNAnnounce(status, content)
  if status == NetConfig.ResponseCodeOk then
    self:doCDNAnnounce(content)
  elseif status ~= NetConfig.ResponseCodeOk then
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.LoginAnnounceError
    })
  end
end
function FunctionLoginAnnounce:doCDNAnnounce(content)
  local result = StringUtil.Json2Lua(content)
  local result
  local isCall = pcall(function(i)
    result = StringUtil.Json2Lua(content)
    if result == nil then
      result = json.decode(content)
    end
  end)
  if result then
    local msg = result.msg
    local tips = result.tips
    local picURL = result.picture
    local startT = result.startTime
    local endT = result.endTime
    local valid = self:checkTimeValid(startT, endT)
    local contentValid = msg and msg ~= "" or tips and tips ~= "" or picURL and picURL ~= ""
    if contentValid and valid then
      FloatingPanel.Instance:ShowMaintenanceMsg(ZhString.ServiceErrorUserCmdProxy_Maintain, msg, tips, ZhString.ServiceErrorUserCmdProxy_Confirm, picURL, function()
      end)
    else
      MsgManager.ShowMsgByIDTable(1017, {
        FunctionLogin.ErrorCode.InvalidServerIP
      })
    end
  else
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.LoginAnnounceFormatError
    })
  end
end
