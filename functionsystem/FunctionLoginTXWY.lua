autoImport("FunctionLoginBase")
FunctionLoginTXWY = class("FunctionLoginTXWY", FunctionLoginBase)
function FunctionLoginTXWY.Me()
  if nil == FunctionLoginTXWY.me then
    FunctionLoginTXWY.me = FunctionLoginTXWY.new()
  end
  return FunctionLoginTXWY.me
end
function FunctionLoginTXWY:startSdkGameLogin(callback)
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
function FunctionLoginTXWY:startAuthAccessToken(callback)
  GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
  self.callback = callback
  self:RequestAuthAccToken()
end
function FunctionLoginTXWY:RequestAuthAccToken()
  local sid = self:getToken()
  if sid then
    local version = self:getServerVersion()
    local plat = self:GetPlat()
    local clientCode = CompatibilityVersion.version
    local clientV2Code = 0
    local resVersion = VersionUpdateManager.CurrentVersion
    pcall(function()
      clientV2Code = OverseaHostHelper:kr_getClientVVV22Code()
    end)
    local url = string.format("%s/auth?sid=%s&p=%s&sver=%s&cver=%s&blueberry=%s&v=%s", NetConfig.NewAccessTokenAuthHost[1], sid, plat, version, clientCode, clientV2Code, resVersion)
    Debug.LogFormat("txwy RequestAuthAccToken url : {0}", url)
    local order = HttpWWWRequestOrder(url, NetConfig.HttpRequestTimeOut, nil, false, true)
    if order then
      order:SetCallBacks(function(response)
        GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        self:LoginDataHandler(NetConfig.ResponseCodeOk, response.resString, self.callback)
      end, function(order)
        GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        self:LoginDataHandler(FunctionLogin.AuthStatus.OherError, "", self.callback)
      end, function(order)
        GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        self:LoginDataHandler(FunctionLogin.AuthStatus.OherError, "", self.callback)
      end)
      Game.HttpWWWRequest:RequestByOrder(order)
    else
    end
  else
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.RequestAuthAccToken_NoneToken
    })
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  end
end
