autoImport("FunctionLoginBase")
FunctionLoginAny = class("FunctionLoginAny", FunctionLoginBase)
function FunctionLoginAny.Me()
  if nil == FunctionLoginAny.me then
    FunctionLoginAny.me = FunctionLoginAny.new()
  end
  return FunctionLoginAny.me
end
function FunctionLoginAny:startSdkGameLogin(callback)
  LogUtility.InfoFormat("FunctionLoginAny:isLogined:{0}", self:isLogined())
  local isLogined = self:isLogined()
  if not isLogined or not self.loginData then
    local CompatibilityMode_V9 = BackwardCompatibilityUtil.CompatibilityMode_V9
    if CompatibilityMode_V9 then
      self:startSdkLogin(function(code, msg)
        self:SdkLoginHandler(code, msg, function()
          self:LoginDataHandler(NetConfig.ResponseCodeOk, msg, callback)
        end)
      end)
    else
      self:startSdkLoginNew(function(code, msg)
        self:SdkLoginHandler(code, msg, function()
          self:LoginDataHandler(NetConfig.ResponseCodeOk, msg, callback)
        end)
      end)
    end
  elseif callback then
    callback()
  end
end
function FunctionLoginAny:startSdkLoginNew(callback)
  local launchScs = self:isInitialized()
  LogUtility.InfoFormat("FunctionLoginAny:startSdkLoginNew(  ) Launch result:{0}", launchScs)
  if launchScs then
    local authUrl = self:getAuthUrl()
    LogUtility.InfoFormat("FunctionLoginAny:startSdkLoginNew(  ) authUrl:{0}", authUrl)
    FunctionSDK.Instance:AnySDKLogin("", authUrl, function(sucMsg)
      LogUtility.InfoFormat("startSdkLoginNew sucMsg:{0}", sucMsg)
      if callback then
        callback(FunctionLogin.LoginCode.SdkLoginSuc, sucMsg)
      end
      self:resetRetryTime()
    end, function(failMsg)
      local bRetry = self:checkIfNeedRetry()
      LogUtility.InfoFormat("FunctionLoginAny:startSdkLoginNew(  ) bRetry:{0}", bRetry)
      if bRetry then
        self:startRetryLogin(callback)
        return
      end
      self:resetRetryTime()
      if callback then
        callback(FunctionLogin.LoginCode.SdkLoginFailure, failMsg)
      end
    end, function(failMsg)
      if callback then
        callback(FunctionLogin.LoginCode.SdkLoginCancel, failMsg)
      end
      self:resetRetryTime()
    end)
  else
    self:LaunchSdk(function(scuccess, msg)
      if scuccess then
        self:startSdkLogin(callback)
      else
        msg = msg and tostring(msg) or "null"
        LogUtility.Info("LoginFailure msg:" .. msg)
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
        MsgManager.ShowMsgByIDTable(1037, {
          FunctionLogin.ErrorCode.Login_SDKLaunchFailure,
          msg
        })
      end
    end)
  end
end
function FunctionLoginAny:getAuthUrl()
  local addresses = FunctionGetIpStrategy.Me():getRequestAddresss()
  if not addresses then
    return ""
  end
  local domain = addresses[self.retryTime]
  domain = domain or addresses[1]
  local authPort = self:GetAuthPort()
  local plat = self:GetPlat()
  local url = "https://%s:%s/anylogin?plat=%s"
  url = string.format(url, domain, authPort, plat)
  return url
end
function FunctionLoginAny:startRetryLogin(callback)
  self.retryTime = self.retryTime + 1
  self.delayTime = self.delayTime + math.random() * self.retryTime
  LogUtility.InfoFormat("FunctionLoginAny:startSdkLoginNew(  ) self.retryTime:{0},self.delayTime:{1}", self.retryTime, self.delayTime)
  if self.delayTime and self.delayTime > 0 then
    LeanTween.delayedCall(self.delayTime, function()
      self:startSdkLoginNew(callback)
    end)
  else
    self:startSdkLoginNew(callback)
  end
end
