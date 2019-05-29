autoImport("FunctionLoginBase")
FunctionLoginXd = class("FunctionLoginXd", FunctionLoginBase)
function FunctionLoginXd.Me()
  if nil == FunctionLoginXd.me then
    FunctionLoginXd.me = FunctionLoginXd.new()
  end
  return FunctionLoginXd.me
end
function FunctionLoginXd:RequestAuthAccToken()
  local token = self:getToken()
  LogUtility.InfoFormat("FunctionLoginXd:RequestAuthAccToken token:{0}", token)
  if token then
    self:setLastLoginToken(token)
    local url = self:GetAuthAccUrl(token)
    self:requestGetUrlHost(url, function(status, content)
      GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
      self:LoginDataHandler(status, content, self.callback)
    end)
  else
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.RequestAuthAccToken_NoneToken
    })
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  end
end
function FunctionLoginXd:startAuthAccessToken(callback)
  GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
  self.callback = callback
  self:RequestAuthAccToken()
end
function FunctionLoginXd:startSdkGameLogin(callback)
  LogUtility.InfoFormat("startSdkGameLogin:isLogined:{0}", self:isLogined())
  local isLogined = self:isLogined()
  if not isLogined then
    self:startSdkLogin(function(code, msg)
      self:SdkLoginHandler(code, msg, function()
        self:startAuthAccessToken(function()
          if callback then
            callback()
          end
        end)
      end)
    end)
  elseif not self.loginData then
    self:startAuthAccessToken(function()
      if callback then
        callback()
      end
    end)
  elseif callback then
    callback()
  end
end
function FunctionLoginXd:requestGetUrlHost(url, callback, address)
  local phoneplat = ApplicationInfo.GetRunPlatformStr()
  local timestamp = os.time()
  timestamp = string.format("&timestamp=%s&phoneplat=%s", timestamp, phoneplat)
  local order
  if self.privateMode then
    local ip = NetConfig.PrivateAuthServerUrl
    ip = string.format("http://%s%s%s", ip, url, timestamp)
    LogUtility.InfoFormat("FunctionLoginXd:requestGetUrlHost address url:{0}", ip)
    order = HttpWWWRequestOrder(ip, NetConfig.HttpRequestTimeOut, nil, false, true)
  elseif address and "" ~= address then
    local ip = address
    ip = string.format("https://%s%s%s", ip, url, timestamp)
    LogUtility.InfoFormat("FunctionLoginXd:requestGetUrlHost address url:{0}", ip)
    order = HttpWWWRequestOrder(ip, NetConfig.HttpRequestTimeOut, nil, false, true)
  else
    local addresses = FunctionGetIpStrategy.Me():getRequestAddresss()
    if not addresses then
      callback(FunctionLogin.AuthStatus.OherError)
      return
    end
    local ip = addresses[self.retryTime]
    ip = ip or addresses[1]
    ip = string.format("https://%s%s%s", ip, url, timestamp)
    LogUtility.InfoFormat("FunctionLoginXd:requestGetUrlHost url:{0}", ip)
    order = HttpWWWRequestOrder(ip, NetConfig.HttpRequestTimeOut, nil, false, true)
  end
  if order then
    order:SetCallBacks(function(response)
      self.hasHandleRes = true
      self:resetRetryTime()
      callback(NetConfig.ResponseCodeOk, response.resString)
    end, function(order)
      self:RequestError(callback, order, address)
    end, function(order)
      self:RequestError(callback, order, address)
    end)
    self.hasHandleRes = false
    Game.HttpWWWRequest:RequestByOrder(order)
  else
    callback(FunctionLogin.AuthStatus.OherError)
  end
end
function FunctionLoginXd:RequestError(callback, order, address)
  if self.hasHandleRes then
    return
  end
  self.hasHandleRes = true
  if not order then
    self:resetRetryTime()
    callback(FunctionLogin.AuthStatus.OherError)
    return
  end
  local IsOverTime = order.IsOverTime
  LogUtility.InfoFormat("FunctionLoginXd:requestGetUrlHost IsOverTime:{0},requestUrl:{1}", IsOverTime, order.url)
  LogUtility.InfoFormat("FunctionLoginXd:requestGetUrlHost occur error,url:{0},address:{1},errorMsg:{2}", url, address, order.orderError)
  if self.privateMode or address and "" ~= address then
    self:resetRetryTime()
    callback(FunctionLogin.AuthStatus.OherError)
  elseif self:checkIfNeedRetry() then
    self:startRetryRequsetAuth()
    return
  else
    self:resetRetryTime()
    callback(FunctionLogin.AuthStatus.OherError)
  end
end
function FunctionLoginXd:startRetryRequsetAuth()
  self.retryTime = self.retryTime + 1
  self.delayTime = self.delayTime + math.random() * self.retryTime
  LogUtility.InfoFormat("FunctionLoginXd:startRetryRequsetAuth(  ) self.retryTime:{0},self.delayTime:{1}", self.retryTime, self.delayTime)
  if self.delayTime and self.delayTime > 0 then
    LeanTween.delayedCall(self.delayTime, function()
      self:RequestAuthAccToken()
    end)
  else
    self:RequestAuthAccToken()
  end
end
