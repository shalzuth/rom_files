autoImport("OverseaHostHelper")
FunctionLoginBase = class("FunctionLoginBase")
function FunctionLoginBase.Me()
  if nil == FunctionLoginBase.me then
    FunctionLoginBase.me = FunctionLoginBase.new()
  end
  return FunctionLoginBase.me
end
function FunctionLoginBase:ctor()
  self.authUrlHost = nil
  self.authPort = nil
  self.AuthHostHandlerTimes = 0
  self.hasShowAnnouncement = false
  self.retryTime = 1
  self.delayTime = 1
  self.privateMode = FunctionLogin.Me():isPrivateMode()
end
function FunctionLoginBase:initLoginOutListen()
  FunctionSDK.Instance:ListenLogout(function(x)
    self:OnLogoutSuccess(x)
  end, function(x)
    self:OnLogoutFail(x)
  end)
end
function FunctionLoginBase:OnLogoutSuccess(message)
  self:setLoginData(nil)
  message = message or ""
  LogUtility.InfoFormat("ListenLogout sucess msg:{0}", message)
end
function FunctionLoginBase:OnLogoutFail(message)
  self:setLoginData(nil)
  message = message or ""
  LogUtility.InfoFormat("ListenLogout failure msg:{0}", message)
end
function FunctionLoginBase:GetActiveAppendUrl()
  local sdkType = self:getSdkType()
  return NetConfig.ActivateUrl_Xd
end
function FunctionLoginBase:GetAuthAppendUrl()
  local sdkType = self:getSdkType()
  LogUtility.InfoFormat("GetAuthAppendUrl sdkType:{0}", sdkType)
  if sdkType == FunctionSDK.E_SDKType.Any then
    return NetConfig.AccessTokenAuthUrl_AynSdk
  elseif sdkType == FunctionSDK.E_SDKType.XD then
    return NetConfig.AccessTokenAuthUrl_Xd
  elseif sdkType == FunctionSDK.E_SDKType.TXWY then
    return NetConfig.ActivateUrl_TXWY
  end
end
function FunctionLoginBase:appendAnyData(url)
  local json = VerificationOfLogin.Instance.CachedAnyDataForAnySDKLogin
  LogUtility.InfoFormat("FunctionLoginBase:appendAnyData anyData json:{0}", json)
  local anyData = StringUtil.Json2Lua(json)
  if anyData then
    for k, v in pairs(anyData) do
      url = url .. "&" .. tostring(k) .. "=" .. tostring(v)
    end
  end
  return url
end
function FunctionLoginBase:GetActiveUrl(cdKey)
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android and not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
    local url = ""
    local actUrl = self:GetActiveAppendUrl()
    local port = self:GetAuthPort()
    local token = self:getToken()
    url = string.format(":%s%s%s&cdkey=%s", port, actUrl, token, cdKey)
    return url
  end
  local url = ""
  local sdkType = self:getSdkType()
  local actUrl = self:GetActiveAppendUrl()
  local port = self:GetAuthPort()
  if sdkType == FunctionSDK.E_SDKType.Any then
    url = string.format(":%s%scdkey=%s", port, actUrl, cdKey)
    url = self:appendAnyData(url)
  elseif sdkType == FunctionSDK.E_SDKType.XD then
    local token = self:getToken()
    url = string.format(":%s%s%s&cdkey=%s", port, actUrl, token, cdKey)
  end
  return url
end
function FunctionLoginBase:GetAuthAccUrl(token)
  local authUrl = self:GetAuthAppendUrl()
  local version = self:getServerVersion()
  local plat = self:GetPlat()
  local port = self:GetAuthPort()
  local clientCode = CompatibilityVersion.version
  local vd = self:getvd()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    clientCode = FunctionLogin.Me().debugClientCode
  end
  local url = string.format(":%s%s%s&plat=%s&version=%s&clientCode=%s&vd=%s", port, authUrl, token, plat, version, clientCode, vd)
  return url
end
function FunctionLoginBase:getServerVersion()
  local version = VersionUpdateManager.CurrentVersion
  if version == nil then
    version = FunctionLogin.Me():getServerVersion() or version
  end
  return version
end
function FunctionLoginBase:GetPlat()
  local plat = FunctionLogin.Me().debugPlat
  local debug = FunctionLogin.Me():isDebug()
  if self.privateMode then
    plat = FunctionLogin.Me().PrivatePlat
  end
  if not debug then
    local json = EnvChannel.GetHttpOperationJson()
    LogUtility.InfoFormat("FunctionLoginBase:GetAuthPort() json:{0}", json)
    if json then
      local ele = json.elements
      if ele and ele.plat then
        plat = ele.plat
      end
    end
  end
  plat = tostring(plat)
  return plat
end
function FunctionLoginBase:GetAuthPort()
  if not self.authPort then
    local port = 5003
    local debug = FunctionLogin.Me():isDebug()
    if debug then
      port = FunctionLogin.Me().debugAuthPort
    end
    if self.privateMode then
      port = NetConfig.PrivateAuthServerUrlPort
    end
    local verStr = VersionUpdateManager.serverResJsonString
    local result = StringUtil.Json2Lua(verStr)
    if result and result.data then
      local data = result.data
      local tmp = tonumber(data.authport)
      port = tmp and tmp or port
    end
    LogUtility.InfoFormat("FunctionLoginBase:GetAuthPort() authPort:{0}", port)
    self.authPort = port
  end
  return self.authPort
end
function FunctionLoginBase:StartActive(cdKey, callback)
  local url = self:GetActiveUrl(cdKey)
  local addresses = FunctionGetIpStrategy.Me():getRequestAddresss()
  local address
  if addresses then
    address = addresses[1]
  end
  self:requestGetUrlHost(url, function(status, content)
    if callback then
      callback(status, content)
    end
  end, address)
end
function FunctionLoginBase:requestGetUrlHost(url, callback, address)
  FunctionLogin.Me():requestGetUrlHost(url, callback, address)
end
function FunctionLoginBase:CheckAccTokenValid(result)
  if result and result.status == FunctionLogin.AuthStatus.Ok then
    return result.data
  end
end
function FunctionLoginBase:HandleAnnoucement(accData)
  if accData then
    local msg = accData.msg
    local tips = accData.tips
    local PicUrl = accData.picurl
    if msg or tips or PicUrl then
      self.readyMSG = msg
      self.readyTips = tips
      self.readyPicURL = PicUrl
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1500.0, self.OnTimeTick, self, 1)
    end
  end
end
function FunctionLoginBase:OnTimeTick()
  FloatingPanel.Instance:ShowMaintenanceMsg(ZhString.ServiceErrorUserCmdProxy_Maintain, self.readyMSG, self.readyTips, ZhString.ServiceErrorUserCmdProxy_Confirm, self.readyPicURL)
  TimeTickManager.Me():ClearTick(self, 1)
end
function FunctionLoginBase:checkEnableEncrypt(accData)
  local enableEncrypt = false
  if accData then
    enableEncrypt = accData.fkmtfk
    if enableEncrypt == nil then
      enableEncrypt = false
    end
    if enableEncrypt ~= true or enableEncrypt ~= false then
      enableEncrypt = false
    end
  end
  Game.NetConnectionManager.EnableEncrypt = enableEncrypt
end
function FunctionLoginBase:LoginDataHandler(status, content, callback)
  local result
  local isCall = pcall(function(i)
    result = StringUtil.Json2Lua(content)
    if result == nil and status == NetConfig.ResponseCodeOk then
      result = json.decode(content)
    end
  end)
  local accData = self:CheckAccTokenValid(result)
  LogUtility.InfoFormat("FunctionLoginBase:LoginDataHandler:status\239\188\154{0},content:{1},sha1:{2}", status, content, tostring(self:getToken()))
  if status == NetConfig.ResponseCodeOk and accData then
    local serverData = accData.regions
    OverseaHostHelper.accId = accData.accid
    OverseaHostHelper.isGuest = tonumber(accData.isGuest)
    OverseaHostHelper:RefreshHostInfo(accData.gates)
    local hasServerList = serverData and #serverData > 0
    if hasServerList then
      local loginData = {}
      loginData.sha1 = accData.sha1
      loginData.accid = accData.accid
      loginData.timestamp = accData.timestamp
      GamePhoto.SetPlayerAccount(accData.accid)
      self:setLoginData(loginData)
      self:setServerData(serverData)
      self:setDefaultServerData(accData.default)
      self:checkEnableEncrypt(accData)
      FunctionLogin.Me():setPhoneNum(accData.phone)
      FunctionLogin.Me():setSecurityParam(accData.param)
      FunctionLogin.Me():setLoginVersion(accData.version)
      FunctionLogin.Me():setLoginSite(accData.site)
      FunctionLogin.Me():setLogin_authoriz_state(accData.authorize_state)
      FunctionLogin.Me():set_IsTmp(accData.is_tmp)
      GameFacade.Instance:sendNotification(NewLoginEvent.EndSdkLogin)
      if callback then
        callback()
      end
    else
      GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
      MsgManager.ShowMsgByIDTable(1017, {
        FunctionLogin.ErrorCode.LoginDataHandler_ServerListEmpty
      })
    end
    if self.hasShowAnnouncement == false and accData then
      local msg = accData.msg
      local tips = accData.tips
      local picURL = accData.picurl
      if msg and msg ~= "" or tips and tips ~= "" or picURL and picURL ~= "" then
        self:HandleAnnoucement(accData)
        self.hasShowAnnouncement = true
      end
    end
  elseif status ~= NetConfig.ResponseCodeOk then
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.LoginDataHandler_Failure + status
    })
  else
    if result then
      if result.status == FunctionLogin.AuthStatus.NoActive then
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "ActivePanel"
        })
        return
      elseif result.status == FunctionLogin.AuthStatus.GetServerListFailure then
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
        MsgManager.ShowMsgByIDTable(1017, {
          FunctionLogin.ErrorCode.CheckAccTokenValid_Failure_GetServerListFailure
        })
        return
      elseif result.status == FunctionLogin.AuthStatus.CreateRoleFailure then
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
        MsgManager.ShowMsgByIDTable(1017, {
          FunctionLogin.ErrorCode.CheckAccTokenValid_Failure_CreateRoleFailure
        })
        return
      elseif result.status == 888001 then
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
        MsgManager.ShowMsgByIDTable(888001, {})
        return
      elseif result.status == 888002 then
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
        MsgManager.ShowMsgByIDTable(888002, {})
        return
      else
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
        MsgManager.ShowMsgByIDTable(1017, {
          result.status
        })
        return
      end
    end
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.LoginDataHandler_Failure
    })
  end
end
function FunctionLoginBase:LaunchSdkHandler(bRet, msg, callback)
  LogUtility.InfoFormat("FunctionLoginBase:LaunchSdkHandler(  ) return,Launch result:{0},msg:{1}", bRet, tostring(msg))
  if callback then
    callback(bRet, msg)
  end
end
function FunctionLoginBase:LaunchSdk(callback)
  local launchScs = self:isInitialized()
  local debug = FunctionLogin.Me():isDebug()
  if not debug then
    if launchScs then
      if callback then
        callback(launchScs)
      end
    elseif not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V8) then
      local currentType = FunctionSDK.Instance.CurrentType
      if currentType == FunctionSDK.E_SDKType.XD then
        local xdsdkApplicationInfo = AppBundleConfig.GetXDSDKInfo()
        FunctionSDK.Instance:XDSDKInitialize(xdsdkApplicationInfo.APP_ID, xdsdkApplicationInfo.APP_SECRET, xdsdkApplicationInfo.PRIVATE_SECRET, xdsdkApplicationInfo.ORIENTATION, function(sucMsg)
          self:LaunchSdkHandler(true, sucMsg, callback)
        end, function(failMsg)
          self:LaunchSdkHandler(false, failMsg, callback)
        end)
      elseif currentType == FunctionSDK.E_SDKType.Any then
        local anysdkApplicationInfo = AppBundleConfig.GetANYSDKInfo()
        FunctionSDK.Instance:AnySDKInitialize(anysdkApplicationInfo.APP_KEY, anysdkApplicationInfo.APP_SECRET, anysdkApplicationInfo.PRIVATE_KEY, anysdkApplicationInfo.OAUTH_LOGIN_SERVER, function(sucMsg)
          self:LaunchSdkHandler(true, sucMsg, callback)
        end, function(failMsg)
          self:LaunchSdkHandler(false, failMsg, callback)
        end)
      elseif currentType == FunctionSDK.E_SDKType.TXWY then
        local txwysdkApplicationInfo = AppBundleConfig.GetTXWYSDKInfo()
        helplog("txwysdkApplicationInfo.APP_ID = ", txwysdkApplicationInfo.APP_ID)
        helplog("txwysdkApplicationInfo.LANG = ", txwysdkApplicationInfo.LANG)
        FunctionSDK.Instance:TXWYSDKInitialize(txwysdkApplicationInfo.APP_ID, txwysdkApplicationInfo.APP_KEY, txwysdkApplicationInfo.FUID, txwysdkApplicationInfo.LANG, function(sucMsg)
          self:LaunchSdkHandler(true, sucMsg, callback)
        end, function(failMsg)
          self:LaunchSdkHandler(false, failMsg, callback)
        end)
      end
    else
      FunctionSDK.Instance:Initialize(function(sucMsg)
        self:LaunchSdkHandler(true, sucMsg, callback)
      end, function(failMsg)
        self:LaunchSdkHandler(false, failMsg, callback)
      end)
    end
    self:initLoginOutListen()
  else
  end
end
function FunctionLoginBase:SdkLoginHandler(code, msg, callback)
  LogUtility.InfoFormat("FunctionLoginBase:SdkLoginHandler(  ) return,Login result:{0},msg:{1}", bRet, msg)
  if code == FunctionLogin.LoginCode.SdkLoginSuc then
    if callback then
      callback()
    end
  elseif code == FunctionLogin.LoginCode.SdkLoginCancel then
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  elseif code == FunctionLogin.LoginCode.SdkLoginNoneSdkType then
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
    LogUtility.Info(ZhString.Login_SdkLoginNoneSdkType, "none")
  else
    msg = msg and tostring(msg) or "null"
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
    MsgManager.ShowMsgByIDTable(1037, {
      FunctionLogin.ErrorCode.Login_SDKLoginFailure,
      msg
    })
  end
end
function FunctionLoginBase:startSdkLogin(callback)
  local launchScs = self:isInitialized()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    callback(FunctionLogin.LoginCode.SdkLoginSuc, "debug mode sucMsg")
    return
  end
  LogUtility.InfoFormat("FunctionLoginBase:startSdkLogin(  ) Launch result:{0}", launchScs)
  if launchScs then
    FunctionSDK.Instance:Login(function(sucMsg)
      LogUtility.InfoFormat("startSdkLogin sucMsg:{0}", sucMsg)
      OverseaHostHelper:AFTrack("ID\233\128\163\230\144\186")
      if callback then
        callback(FunctionLogin.LoginCode.SdkLoginSuc, sucMsg)
      end
    end, function(failMsg)
      if callback then
        callback(FunctionLogin.LoginCode.SdkLoginFailure, failMsg)
      end
    end, function(failMsg)
      if callback then
        callback(FunctionLogin.LoginCode.SdkLoginCancel, failMsg)
      end
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
function FunctionLoginBase:createRole(name, role_sex, profession, hair, haircolor, clothcolor)
  haircolor = haircolor or 0
  bodycolor = bodycolor or 0
  name = tostring(name)
  role_sex = tonumber(role_sex) or 0
  profession = tonumber(profession) or 0
  hair = tonumber(hair) or 0
  haircolor = tonumber(haircolor) or 0
  clothcolor = tonumber(clothcolor) or 0
  ServiceLoginUserCmdProxy.Instance:CallCreateCharUserCmd(name, role_sex, profession, hair, haircolor, clothcolor)
end
function FunctionLoginBase:getLoginData()
  return self.loginData
end
function FunctionLoginBase:setLoginData(data)
  self.loginData = data
  if data then
    LogUtility.InfoFormat("setLoginData:accid:{0}", self.loginData.accid)
    local accid = tonumber(self.loginData.accid)
    self.loginData.accid = accid
    FunctionGetIpStrategy.Me():setAccId(accid)
  end
end
function FunctionLoginBase:setLastLoginToken(token)
  self.lastLoginToken = token
end
function FunctionLoginBase:getServerDatas()
  return self.serverDatas
end
function FunctionLoginBase:setServerData(data)
  self.serverDatas = data
end
function FunctionLoginBase:setDefaultServerData(default)
  if default and self.serverDatas then
    if default == "" then
      self.DefaultServerData = self.serverDatas[#self.serverDatas]
    else
      for i = 1, #self.serverDatas do
        local single = self.serverDatas[i]
        if single.serverid == default then
          self.DefaultServerData = single
          break
        end
      end
    end
  end
  GameFacade.Instance:sendNotification(NewLoginEvent.UpdateServerList)
end
function FunctionLoginBase:getDefaultServerData()
  return self.DefaultServerData
end
function FunctionLoginBase:getSdkEnable()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    return true
  else
    local SDKEnable = EnvChannel.SDKEnable()
    LogUtility.InfoFormat("SDKEnable:{0}", SDKEnable)
    return SDKEnable
  end
end
function FunctionLoginBase:getServerIp()
  return FunctionLogin.Me():getServerIp()
end
function FunctionLoginBase:getServerPort()
  return FunctionLogin.Me():getServerPort()
end
function FunctionLoginBase:getToken()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    return FunctionLogin.Me().debugToken
  else
    local token = FunctionSDK.Instance:GetAccessToken()
    if not token or token == "" then
      return nil
    else
      return token
    end
  end
end
function FunctionLoginBase:isLogined()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    return true
  else
    return FunctionSDK.Instance:IsLogined()
  end
end
function FunctionLoginBase:isInitialized()
  return FunctionSDK.Instance.IsInitialized
end
function FunctionLoginBase:getSdkType()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    return FunctionSDK.E_SDKType.TXWY
  else
    return FunctionSDK.Instance.CurrentType
  end
end
function FunctionLoginBase:replaceBracket(arg)
  return FunctionLogin.Me():replaceBracket(arg)
end
function FunctionLoginBase:checkIfNeedRetry()
  local addresses = FunctionGetIpStrategy.Me():getRequestAddresss()
  if addresses and self.retryTime == #addresses then
    return false
  else
    return true
  end
end
function FunctionLoginBase:resetRetryTime()
  self.retryTime = 1
  self.delayTime = 1
end
local abSize_Script2
function FunctionLoginBase:getvd()
  if abSize_Script2 ~= nil then
    return abSize_Script2
  end
  local getScriptPath = function()
    return table.concat({
      ApplicationHelper.persistentDataPath,
      "/",
      ApplicationHelper.platformFolder,
      "/resources/script2/"
    })
  end
  local scriptFolderList = {
    "util.unity3d",
    "login.unity3d",
    "config_item_daoju.unity3d",
    "oversea.unity3d",
    "diskfilehandler.unity3d",
    "overseas.unity3d",
    "config_resource_ziyuan.unity3d",
    "envchannel.unity3d",
    "net.unity3d",
    "config_pay_zhifu.unity3d",
    "config_guild_gonghui.unity3d",
    "test.unity3d",
    "org.unity3d",
    "unionwallphoto.unity3d",
    "purchase.unity3d",
    "framework.unity3d",
    "mconfig.unity3d",
    "config_adventure_chengjiu_maoxian.unity3d",
    "config_hint_tishizhiyin.unity3d",
    "config_event_shijian.unity3d",
    "protocolstatistics.unity3d",
    "config.unity3d",
    "tablemathextension.unity3d",
    "config_npc_mowu.unity3d",
    "functionsystem.unity3d",
    "gmtool.unity3d",
    "itemswithrolestatuschange.unity3d",
    "personalphoto.unity3d",
    "config_text_wenben.unity3d",
    "config_pvp_jingjisai.unity3d",
    "config_skill_jineng.unity3d",
    "unionlogo.unity3d",
    "config_pet_suicong.unity3d",
    "main.unity3d",
    "config_marry_jiehun.unity3d",
    "config_map_fuben.unity3d",
    "config_property_zhiye_shuxing.unity3d",
    "refactory.unity3d",
    "marryphoto.unity3d",
    "com.unity3d",
    "gamephotoutil.unity3d",
    "scenicspotsphoto.unity3d",
    "config_equip_zhuangbei_kapian.unity3d"
  }
  local p = ApplicationHelper.platformFolder
  abSize_Script2 = p:sub(1, 1) .. "Q"
  for i = 1, #scriptFolderList do
    local path = getScriptPath() .. scriptFolderList[i]
    local file = io.open(getScriptPath() .. scriptFolderList[i], "r")
    if file then
      local singleSize = file:seek("end")
      abSize_Script2 = abSize_Script2 .. i .. "_" .. singleSize .. "Q"
      file:close()
    end
  end
  return abSize_Script2
end
