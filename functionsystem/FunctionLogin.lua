FunctionLogin = class("FunctionLogin")
autoImport("FunctionLoginXd")
autoImport("FunctionLoginAny")
autoImport("FunctionLoginTXWY")
autoImport("FunctionGetIpStrategy")
autoImport("ScenicSpotPhotoNew")
autoImport("GamePhoto")
autoImport("FunctionLoginAnnounce")
FunctionLogin.AuthStatus = {
  Ok = 0,
  OherError = 1,
  GetServerListFailure = 2,
  CreateRoleFailure = 3,
  NoActive = 9
}
FunctionLogin.LoginCode = {
  SdkLoginCancel = 1,
  SdkLoginSuc = 2,
  SdkLoginFailure = 3,
  SdkLoginNoneSdkType = 4
}
FunctionLogin.ErrorCode = {
  RequestAuthAccToken_NoneToken = 2001,
  StartActive_NoneToken = 2002,
  CheckAccTokenValid_Failure_GetServerListFailure = 2005,
  CheckAccTokenValid_Failure_CreateRoleFailure = 2006,
  Login_TokenInValid = 2010,
  LoginDataHandler_ServerListEmpty = 2011,
  Login_SDKLoginFailure = 2008,
  Login_SDKLaunchFailure = 2009,
  Login_SDKLoginCancel = 2012,
  StartGameLogin_NoneSdkType = 2013,
  AuthHostHandler_Failure = 10000,
  LoginDataHandler_Failure = 30000,
  HandleConnectServer = 40000,
  InvalidServerIP = 50000,
  LoginAnnounceError = 900000,
  LoginAnnounceFormatError = 900001
}
function FunctionLogin.Me()
  if nil == FunctionLogin.me then
    FunctionLogin.me = FunctionLogin.new()
  end
  return FunctionLogin.me
end
function FunctionLogin:ctor()
  self.gatePort = nil
  self.AsyncGetAliIp = false
  self.connectTime = 0
  self.reconnectTimes = 0
  self.delayTime = 0
  self.privateMode = false
  self.PrivatePlat = 82
  self.ShowWeChat = not Game.inAppStoreReview
  self.Debug = false
  self.debugServerVersion = "1.1.3"
  self.debugPlat = 1
  self.debugServerPort = 8888
  self.debugAuthPort = 5003
  self.debugClientCode = 13
  local tokens = {
    LXY = "1ec43da401cc32a3ac49a9174e8b5610",
    ZGB = "c8835efca46e0403a7afbd8bd9269c07",
    STB = "cada1fbebab105edc9f2e7a087daaa9f",
    HJY = "fa72c04c7993917886766c87255e6c4e",
    KM = "5396f64b0d8207d8eaea75d9c6848af0",
    WSKC = "b67c8c4ea1b8fa2c097adc424b171f41",
    TXWY = ""
  }
  self.debugToken = tokens.TXWY
end
function FunctionLogin:StartActive(cdKey, callback)
  local fucntionSdk = self:getFunctionSdk()
  if fucntionSdk then
    fucntionSdk:StartActive(cdKey, callback)
  end
end
function FunctionLogin:requestGetUrlHost(url, callback, address, privateMode)
  local phoneplat = ApplicationInfo.GetRunPlatformStr()
  local timestamp = os.time()
  timestamp = string.format("&timestamp=%s&phoneplat=%s", timestamp, phoneplat)
  local requests = HttpWWWSeveralRequests()
  if privateMode or self.privateMode then
    local ip = NetConfig.PrivateAuthServerUrl
    ip = string.format("http://%s%s%s", ip, url, timestamp)
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost address url:{0}", ip)
    local order = HttpWWWRequestOrder(ip, NetConfig.HttpRequestTimeOut, nil, false, true)
    requests:AddOrder(order)
  elseif address and "" ~= address then
    local ip = address
    ip = string.format("https://%s%s%s", ip, url, timestamp)
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost address url:{0}", ip)
    local order = HttpWWWRequestOrder(ip, NetConfig.HttpRequestTimeOut, nil, false, true)
    requests:AddOrder(order)
  else
    local ips = FunctionGetIpStrategy.Me():getRequestAddresss()
    for i = 1, #ips do
      local ip = ips[i]
      ip = string.format("https://%s%s%s", ip, url, timestamp)
      LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost url:{0}", ip)
      local order = HttpWWWRequestOrder(ip, NetConfig.HttpRequestTimeOut, nil, false, true)
      requests:AddOrder(order)
    end
  end
  requests:SetCallBacks(function(response)
    callback(NetConfig.ResponseCodeOk, response.resString)
  end, function(order)
    local IsOverTime = order.IsOverTime
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost IsOverTime:{0}", IsOverTime)
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost occur error,url:{0},address:{1},errorMsg:{2}", url, address, order.orderError)
    callback(FunctionLogin.AuthStatus.OherError, order)
  end)
  requests:StartRequest()
end
function FunctionLogin:LoginDataHandler(status, content, callback)
  local functionSdk = self:getFunctionSdk()
  if functionSdk then
    functionSdk:LoginDataHandler(status, content, callback)
  end
end
function FunctionLogin:connectGameServer(callback, isRestart)
  if self.AsyncGetAliIp then
    FunctionGetIpStrategy.Me():getServerIpAsync(function(result)
      local port = self:getServerPort()
      if result and result ~= "" then
        local serverHost = result.ip and result.ip or result
        LogUtility.InfoFormat("getServerIpAsync,serverHost:{0} port:{1}", serverHost, port)
        if result.socket and not Slua.IsNull(result.socket) then
          Game.NetConnectionManager:setSocket(result.socket)
          self.netDelay = result.delay
          self:handleConnectServer(NetState.Connect, callback, isRestart)
        else
          NetManager.ConnGameServer(serverHost, port, function(state, netDelay)
            self.netDelay = netDelay
            self:handleConnectServer(state, callback, isRestart)
          end)
        end
      else
        FunctionLoginAnnounce.Me():showCDNAnnounce()
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
      end
    end)
  else
    local port = self:getServerPort()
    if self.privateMode then
      FunctionGetIpStrategy.Me():getServerIpSync(function(result)
        if result and result ~= "" then
          local serverHost = result.ip and result.ip or result
          LogUtility.InfoFormat("getServerIpAsync,serverHost:{0} port:{1}", serverHost, port)
          if result.socket and not Slua.IsNull(result.socket) then
            Game.NetConnectionManager:setSocket(result.socket)
            self.netDelay = result.delay
            self:handleConnectServer(NetState.Connect, callback, isRestart)
          else
            NetManager.ConnGameServer(serverHost, port, function(state, netDelay)
              self.netDelay = netDelay
              self:handleConnectServer(state, callback, isRestart)
            end)
          end
        else
          FunctionLoginAnnounce.Me():showCDNAnnounce()
          GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
        end
      end)
    else
      FunctionGetIpStrategy.Me():getServerIpSync(function(result)
        if result and result ~= "" then
          local serverHost = result.ip and result.ip or result
          LogUtility.InfoFormat("getServerIpAsync,serverHost:{0} port:{1}", serverHost, port)
          if result.socket and not Slua.IsNull(result.socket) then
            Game.NetConnectionManager:setSocket(result.socket)
            self.netDelay = result.delay
            self:handleConnectServer(NetState.Connect, callback, isRestart)
          else
            NetManager.ConnGameServer(serverHost, port, function(state, netDelay)
              self.netDelay = netDelay
              self:handleConnectServer(state, callback, isRestart)
            end)
          end
        else
          FunctionLoginAnnounce.Me():showCDNAnnounce()
          GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
        end
      end)
      break
    end
  end
end
function FunctionLogin:connectLanGameServer(accid, callback, isRestart)
  local ips = self:getServerIp()
  local ip = ips[1]
  local port = self:getServerPort()
  LogUtility.InfoFormat("FunctionLogin:connectLanGameServer(  )ip:{0},port:{1} accid:{2}", ip, port, tostring(accid))
  GameFacade.Instance:sendNotification(NewLoginEvent.StartLogin)
  NetManager.ConnGameServer(ip, port, function(state, netDelay)
    self.netDelay = netDelay
    self:handleConnectLanServerSuccess(state, accid, callback, isRestart)
  end)
end
function FunctionLogin:handleConnectLanServerSuccess(state, accid, callback, isRestart)
  self.recvReqLoginParamCallback = callback
  LogUtility.InfoFormat("handleConnectLanServerSuccess:state:{0}", state)
  if state ~= NetState.Connect then
    FunctionGetIpStrategy.Me():setHasConnFailure(true)
    if not isRestart and state ~= 10051 and self:startTryReconnectLan(accid, callback, isRestart) then
      return
    end
    self:clearReconnectRelated()
    if isRestart then
    else
      UIWarning.Instance:HideBord()
      if state == NetState.Timeout or state == 10051 then
        FunctionNetError.Me():ShowErrorById(11)
      else
        MsgManager.ShowMsgByIDTable(1017, {
          FunctionLogin.ErrorCode.HandleConnectServer + state
        })
      end
    end
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  else
    FunctionGetIpStrategy.Me():setHasConnFailure(false)
    local accid = tonumber(accid)
    LogUtility.InfoFormat("CallReqLoginParamUserCmd:accid:{0}", accid)
    GameFacade.Instance:sendNotification(NewLoginEvent.ReqLoginUserCmd)
    ServiceLoginUserCmdProxy.Instance:CallReqLoginParamUserCmd(accid)
    self:HandleConnectSus()
  end
end
function FunctionLogin:RecvReqLoginParamUserCmd(data)
  local loginData = {}
  loginData.sha1 = data.sha1
  loginData.accid = data.accid
  loginData.timestamp = data.timestamp
  loginData.zoneid = self.ServerZone
  GamePhoto.SetPlayerAccount(data.accid)
  self:setLoginData(loginData)
  if self.recvReqLoginParamCallback then
    self.recvReqLoginParamCallback()
  end
end
function FunctionLogin:clearConnectTime()
  self.connectTime = 0
end
function FunctionLogin:handleConnectServer(state, callback, isRestart)
  LogUtility.InfoFormat("handleConnectServer:state:{0}", state)
  if state ~= NetState.Connect then
    FunctionGetIpStrategy.Me():setHasConnFailure(true)
    if not isRestart and state ~= 10051 and self:startTryReconnect(callback, isRestart) then
      return
    end
    self:clearReconnectRelated()
    if isRestart then
    else
      UIWarning.Instance:HideBord()
      if state == NetState.Timeout or state == 10051 then
        FunctionNetError.Me():ShowErrorById(11)
      else
        MsgManager.ShowMsgByIDTable(1017, {
          FunctionLogin.ErrorCode.HandleConnectServer + state
        })
      end
    end
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  else
    FunctionGetIpStrategy.Me():setHasConnFailure(false)
    self:clearReconnectRelated()
    self:HandleConnectSus()
    self:LoginUserCmd()
    if callback then
      callback()
    end
  end
end
function FunctionLogin:startTryReconnect(callback, isRestart)
  if self.reconnectTimes < 5 then
    local port = self:getServerPort()
    if self.reconnectTimes == 0 then
      GameFacade.Instance:sendNotification(NewLoginEvent.StartReconnect)
    end
    if self.delayTime and 0 < self.delayTime then
      LeanTween.delayedCall(self.delayTime, function()
        self:connectGameServer(callback, isRestart)
      end)
    else
      self:connectGameServer(callback, isRestart)
    end
    self.reconnectTimes = self.reconnectTimes + 1
    self.delayTime = self.delayTime + self.reconnectTimes + math.random() * self.reconnectTimes
    return true
  end
  return false
end
function FunctionLogin:clearReconnectRelated()
  self.reconnectTimes = 0
  self.delayTime = 0
  GameFacade.Instance:sendNotification(NewLoginEvent.StopReconnect)
end
function FunctionLogin:startTryReconnectLan(accid, callback, isRestart)
  if self.reconnectTimes < 5 then
    local port = self:getServerPort()
    if self.reconnectTimes == 0 then
      GameFacade.Instance:sendNotification(NewLoginEvent.StartReconnect)
    end
    if self.delayTime and 0 < self.delayTime then
      LeanTween.delayedCall(self.delayTime, function()
        self:connectLanGameServer(accid, callback, isRestart)
      end)
    else
      self:connectLanGameServer(accid, callback, isRestart)
    end
    self.reconnectTimes = self.reconnectTimes + 1
    self.delayTime = self.delayTime + self.reconnectTimes + math.random() * self.reconnectTimes
    return true
  end
  return false
end
function FunctionLogin:stopTryReconnect()
  self:clearReconnectRelated()
  ServiceConnProxy.Instance:StopHeart()
end
function FunctionLogin:HandleConnectSus()
  ServiceConnProxy.Instance:HandleConnect()
end
function FunctionLogin:getServerVersion()
  local version = VersionUpdateManager.CurrentServerVersion
  if version == nil then
    version = self.debugServerVersion or version
  end
  if AppEnvConfig.IsTestApp then
    version = self.debugServerVersion
  end
  version = tostring(version)
  return version
end
function FunctionLogin:LoginUserCmd()
  local loginData = self:getLoginData()
  if not loginData then
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
    return
  end
  local accid = loginData.accid
  OverseaHostHelper.accId = accid
  helplog("FunctionLogin:LoginUserCmd!!!!!!!!!", OverseaHostHelper.accId)
  local sha1 = tostring(loginData.sha1)
  local timestamp = tonumber(loginData.timestamp)
  local zoneid = tonumber(self.ServerZone)
  local version = self:getServerVersion()
  local socketInfo = FunctionGetIpStrategy.Me():getCurrentSocketInfo()
  local domain, ip
  if socketInfo then
    ip = socketInfo.ip
    domain = socketInfo.domain
  end
  local device = "editor"
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android then
    device = "android"
  elseif runtimePlatform == RuntimePlatform.IPhonePlayer then
    device = "ios"
  elseif runtimePlatform == RuntimePlatform.WindowsPlayer then
    device = "Windows"
  elseif runtimePlatform == RuntimePlatform.WindowsEditor then
    device = "Windows"
  end
  local phone = self:getPhoneNum()
  local param = self:getSecurityParam()
  local loginVersion = self:getLoginVersion()
  local zone = ApplicationInfo.GetSystemLanguage()
  local site = self:getLoginSite() or 0
  site = tonumber(site)
  local authoriz = self:getLogin_authoriz_state()
  authoriz = tostring(authoriz)
  LogUtility.InfoFormat("FunctionLogin:LoginUserCmd CallReqLoginUserCmd:zoneid:{0},version:{1}", zoneid, version)
  LogUtility.InfoFormat("accid:{0},sha1:{1}", accid, sha1)
  LogUtility.InfoFormat("netDelay:{0},userIp:{1}", self.netDelay, userIp)
  LogUtility.InfoFormat("ip:{0},domain:{1}", ip, domain)
  LogUtility.InfoFormat("param:{0},zone:{1}", param, zone)
  ServiceLoginUserCmdProxy.Instance:CallServerTimeUserCmd()
  ServiceLoginUserCmdProxy.Instance:CallReqLoginUserCmd(accid, sha1, zoneid, timestamp, version, domain, ip, device, phone, param, zone, site, authoriz)
  self.netDelay = 0 < self.netDelay and self.netDelay or 0
  ServiceLoginUserCmdProxy.Instance:CallClientInfoUserCmd(nil, self.netDelay)
  GameFacade.Instance:sendNotification(NewLoginEvent.ReqLoginUserCmd)
end
function FunctionLogin:reStartGameLogin(callback)
  local sdkEnable = self:getSdkEnable()
  local loginData = self:getLoginData()
  FunctionGetIpStrategy.Me():setReConnectState(true)
  if sdkEnable then
    LogUtility.InfoFormat("reStartGameLogin sdkEnable:{0} self.ServerZone:{1}", sdkEnable, self.ServerZone)
    local functionSdk = self:getFunctionSdk()
    if functionSdk then
      functionSdk:startSdkGameLogin(function()
        self:connectGameServer(callback, true)
      end)
    end
  else
    self:connectLanGameServer(loginData.accid, callback, true)
  end
end
function FunctionLogin:LaunchSdk(callback)
  LogUtility.Info("FunctionLogin:LaunchSdk()")
  local fucntionSdk = self:getFunctionSdk()
  if fucntionSdk then
    fucntionSdk:LaunchSdk(callback)
  end
end
function FunctionLogin:startSdkLogin(callback)
  local fucntionSdk = self:getFunctionSdk()
  if fucntionSdk then
    fucntionSdk:startSdkLogin(callback)
  end
end
function FunctionLogin:startAuthAccessToken(callback)
  LogUtility.Info("FunctionLogin:startAuthAccessToken()")
  local fucntionSdk = self:getFunctionSdk()
  if fucntionSdk then
    Debug.Log("FunctionLogin:startAuthAccessToken1")
    fucntionSdk:startAuthAccessToken(callback)
  end
end
function FunctionLogin:startGameLogin(serverData, accid, callback)
  ServiceConnProxy.Instance:StopHeart()
  LogUtility.InfoFormat("FunctionLogin:startGameLogin(  ) loginData and accid:{0}", accid)
  local SDKEnable = self:getSdkEnable()
  if accid and not SDKEnable then
    self.serverData = serverData
    self.ServerZone = serverData.serverid
    self:connectLanGameServer(accid, callback)
  else
    local loginData = self:getLoginData()
    local isLogined = self:isLogined()
    if not isLogined or not loginData then
      local functionSdk = self:getFunctionSdk()
      if functionSdk then
        functionSdk:setLoginData(nil)
        functionSdk:startSdkGameLogin(callback)
      end
    else
      self.serverData = serverData
      self.ServerZone = serverData.serverid
      PlayerPrefs.SetInt("PlayerPrefsMYServer", tonumber(self.ServerZone) or 0)
      self:connectGameServer(callback)
    end
  end
end
function FunctionLogin:createRole(name, role_sex, profession, hair, haircolor, clothcolor, index)
  haircolor = haircolor or 0
  bodycolor = bodycolor or 0
  name = tostring(name)
  role_sex = tonumber(role_sex) or 0
  profession = tonumber(profession) or 0
  hair = tonumber(hair) or 1
  haircolor = tonumber(haircolor) or 0
  clothcolor = tonumber(clothcolor) or 0
  index = index or 0
  ServiceLoginUserCmdProxy.Instance:CallCreateCharUserCmd(name, role_sex, profession, hair, haircolor, clothcolor, nil, index)
end
function FunctionLogin:getSdkEnable()
  if self.Debug then
    return true
  else
    local SDKEnable = EnvChannel.SDKEnable()
    return SDKEnable
  end
end
function FunctionLogin:getSdkType()
  if self.Debug then
    return FunctionSDK.E_SDKType.TXWY
  else
    return FunctionSDK.Instance.CurrentType
  end
end
function FunctionLogin:isLogined()
  local functionSdk = self:getFunctionSdk()
  if functionSdk then
    return functionSdk:isLogined()
  end
end
function FunctionLogin:isDebug()
  return self.Debug
end
function FunctionLogin:isPrivateMode()
  return self.privateMode
end
function FunctionLogin:getServerDatas()
  local functionSdk = self:getFunctionSdk()
  if functionSdk then
    return functionSdk:getServerDatas()
  end
end
function FunctionLogin:getCurServerData()
  return self.serverData
end
function FunctionLogin:replaceBracket(arg)
  local str = string.gsub(arg, "{", "(")
  str = string.gsub(str, "}", ")")
  return str
end
function FunctionLogin:getDefaultServerData()
  local functionSdk = self:getFunctionSdk()
  if functionSdk then
    return functionSdk:getDefaultServerData()
  end
end
function FunctionLogin:getServerIp()
  local ips
  if self:getSdkEnable() then
    ips = EnvChannel.GetPublicIP()
  else
    ips = self.serverData.type == 2 and EnvChannel.GetPublicIP() or {
      NetConfig.PrivateGameServerUrl
    }
  end
  return ips
end
function FunctionLogin:setLoginData(data)
  self.loginData = data
  LogUtility.InfoFormat("setLoginData:accid:{0}", self.loginData.accid)
  local accid = tonumber(self.loginData.accid)
  self.loginData.accid = accid
  FunctionGetIpStrategy.Me():setAccId(accid)
end
function FunctionLogin:getLoginData()
  local sdkEnable = self:getSdkEnable()
  if sdkEnable then
    local functionSdk = self:getFunctionSdk()
    if functionSdk then
      return functionSdk:getLoginData()
    end
  else
    return self.loginData
  end
end
function FunctionLogin:getFunctionSdk()
  local sdkType = self:getSdkType()
  if sdkType == FunctionSDK.E_SDKType.Any then
    return FunctionLoginAny.Me()
  elseif sdkType == FunctionSDK.E_SDKType.XD then
    return FunctionLoginXd.Me()
  elseif sdkType == FunctionSDK.E_SDKType.TXWY then
    return FunctionLoginTXWY.Me()
  else
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.StartGameLogin_NoneSdkType
    })
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  end
end
function FunctionLogin:setServerPort(port)
  self.gatePort = port
end
function FunctionLogin:getServerPort()
  if not self.gatePort then
    local port = EnvChannel.GetPublicPort()
    if self.Debug then
      port = self.debugServerPort
    end
    if self.privateMode then
      port = NetConfig.PrivateGameServerUrlPort
    end
    if self:getSdkEnable() then
      local verStr = VersionUpdateManager.serverResJsonString
      LogUtility.InfoFormat("FunctionLogin:getServerPort() verStr:{0}", verStr)
      local result = StringUtil.Json2Lua(verStr)
      if result and result.data then
        local data = result.data
        local tmp = tonumber(data.gateport)
        port = not tmp or tmp or port
      end
    elseif self.serverData.type ~= 2 then
      port = NetConfig.PrivateGameServerUrlPort
    end
    if self.Debug then
      port = self.debugServerPort
    end
    self.gatePort = port
    LogUtility.InfoFormat("FunctionLogin:getServerPort() gatePort:{0}", port)
  end
  return self.gatePort
end
function FunctionLogin:setSecurityParam(param)
  self.securityParam = param
end
function FunctionLogin:getSecurityParam()
  return self.securityParam
end
function FunctionLogin:getPhoneNum()
  return self.phoneNum
end
function FunctionLogin:setPhoneNum(phoneNum)
  self.phoneNum = phoneNum
end
function FunctionLogin:getLoginSite()
  return self.site
end
function FunctionLogin:setLoginSite(site)
  helplog("setLoginSite:", site)
  self.site = site
end
function FunctionLogin:getLoginVersion()
  return self.loginVersion
end
function FunctionLogin:setLoginVersion(loginVersion)
  self.loginVersion = loginVersion
end
function FunctionLogin:setLogin_authoriz_state(login_authoriz_state)
  helplog("setLogin_authoriz_state:", login_authoriz_state)
  self.login_authoriz_state = login_authoriz_state
end
function FunctionLogin:getLogin_authoriz_state(login_authoriz_state)
  return self.login_authoriz_state
end
function FunctionLogin:set_realName_Centified(b)
  self.realName_Centified = b
end
function FunctionLogin:get_realName_Centified()
  return self.realName_Centified
end
function FunctionLogin:set_IsTmp(is_tmp)
  self.is_tmp = is_tmp
end
function FunctionLogin:get_IsTmp()
  return self.is_tmp
end
function FunctionLogin:launchAndLoginSdk(callback)
  if ApplicationInfo.IsWindows() then
    EventManager.Me():PassEvent(NewLoginEvent.DisableLoginCollider, nil)
  end
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android and not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
    self:LaunchSdk(function(state, msg)
      if state then
        self:startSdkLogin(function(code, msg)
          if code == FunctionLogin.LoginCode.SdkLoginSuc then
            self:startAuthAccessToken(callback)
          else
            GameFacade.Instance:sendNotification(NewLoginEvent.SDKLoginFailure)
          end
        end)
      else
        GameFacade.Instance:sendNotification(NewLoginEvent.LaunchFailure)
      end
    end)
    return
  end
  self:LaunchSdk(function(state, msg)
    local sdkType = FunctionLogin.Me():getSdkType()
    if state then
      self:startSdkLogin(function(code, msg)
        if ApplicationInfo.IsWindows() then
          EventManager.Me():PassEvent(NewLoginEvent.EnableLoginCollider, nil)
        end
        if code == FunctionLogin.LoginCode.SdkLoginSuc then
          if sdkType == FunctionSDK.E_SDKType.XD or sdkType == FunctionSDK.E_SDKType.TXWY then
            self:startAuthAccessToken(callback)
          else
            self:LoginDataHandler(NetConfig.ResponseCodeOk, msg, callback)
          end
        else
          GameFacade.Instance:sendNotification(NewLoginEvent.SDKLoginFailure)
        end
      end)
    else
      GameFacade.Instance:sendNotification(NewLoginEvent.LaunchFailure)
    end
  end)
end
function FunctionLogin:GetRealNameCentifyUrl(realname, realid)
  local authUrl = NetConfig.AccessTokenRealNameCentifyUrl_Xd
  local sdkEnable = self:getSdkEnable()
  local port, token
  if not sdkEnable then
    token = FunctionLogin.Me().debugToken
    port = 5556
  else
    local login = self:getFunctionSdk()
    if login then
      token = login:getToken()
      port = login:GetAuthPort()
    end
  end
  return string.format(":%s%s%s&is_tmp=%s&realname=%s&realid=%s", port, authUrl, token, self.is_tmp or 0, realname, realid)
end
function FunctionLogin:SyncServerDID()
  local url = NetConfig.SyncDidUrl
  local customVersion = GameConfig.DidVersion or 1
  local pfKey = string.format("RO_DeviceID_%s", customVersion)
  local value = PlayerPrefs.GetString(pfKey)
  local timestamp = os.time()
  local token
  local login = self:getFunctionSdk()
  if login then
    token = login:getToken()
  end
  if not token or not token then
    token = ""
  end
  if not value or value == "" then
    local did = DeviceInfo.GetID()
    value = string.format("%s:%s:%s", did, timestamp, customVersion)
    PlayerPrefs.SetString(pfKey, value)
    helplog("\228\191\157\229\173\152\232\174\190\229\164\135DID:", value)
  else
    helplog("\232\142\183\229\143\150\232\174\190\229\164\135DID:", value)
  end
  url = string.format(url, value, token)
  FunctionLoginAnnounce.Me():doRequest(url, function(status, content)
    helplog("\229\144\140\230\173\165\232\174\190\229\164\135DID\229\174\140\230\136\144\239\188\129", status, content)
  end)
end
