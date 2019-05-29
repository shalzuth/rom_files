autoImport("ServiceLoginUserCmdAutoProxy")
autoImport("FunctionADBuiltInTyrantdb")
autoImport("UIModelRolesList")
autoImport("PersonalPhotoHelper")
autoImport("ScenicSpotPhotoHelperNew")
autoImport("UnionWallPhotoHelper")
autoImport("PersonalPhoto")
autoImport("ScenicSpotPhotoNew")
autoImport("UnionWallPhotoNew")
autoImport("AppStorePurchase")
autoImport("UnionLogo")
autoImport("MarryPhoto")
ServiceLoginUserCmdProxy = class("ServiceLoginUserCmdProxy", ServiceLoginUserCmdAutoProxy)
ServiceLoginUserCmdProxy.Instance = nil
ServiceLoginUserCmdProxy.NAME = "ServiceLoginUserCmdProxy"
ServiceLoginUserCmdProxy.saveID = "ProfessionSaveLoadView_saveID"
ServiceLoginUserCmdProxy.toswitchroleid = "ServiceLoginUserCmdProxy_toswitchroleid"
function ServiceLoginUserCmdProxy:ctor(proxyName)
  if ServiceLoginUserCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceLoginUserCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceLoginUserCmdProxy.Instance = self
  end
end
function ServiceLoginUserCmdProxy:RecvReqLoginParamUserCmd(data)
  FunctionLogin.Me():RecvReqLoginParamUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdReqLoginParamUserCmd, data)
end
function ServiceLoginUserCmdProxy:RecvHeartBeatUserCmd(data)
  ServiceConnProxy.Instance:RecvHeart()
  self:Notify(ServiceEvent.LoginUserCmdHeartBeatUserCmd, data)
end
function ServiceLoginUserCmdProxy:RecvLoginResultUserCmd(data)
  local ret = data.ret
  if ret == 0 then
    LogUtility.Info("<color=lime>\231\153\187\233\153\134\230\136\144\229\138\159</color>")
    self:CallServerTimeUserCmd()
    DiskFileHandler.Ins():EnterServer()
    FunctionChatIO.Me():CheckLocalFiles()
    DiskFileHandler.Ins():EnterBeautifulArea()
    DiskFileHandler.Ins():EnterUnionWallPhoto()
    DiskFileHandler.Ins():EnterPersonalPhoto()
    DiskFileHandler.Ins():EnterUnionLogo()
    DiskFileHandler.Ins():EnterMarryPhoto()
    UpYunNetIngFileTaskManager.Ins:Open()
    BeautifulAreaPhotoHandler.Ins():Initialize()
    BeautifulAreaPhotoNetIngManager.Ins():Initialize()
    PersonalPhotoHelper.Ins():Initialize()
    ScenicSpotPhotoHelperNew.Ins():Initialize()
    UnionWallPhotoHelper.Ins():Initialize()
    PersonalPhoto.Ins():Initialize()
    ScenicSpotPhotoNew.Ins():Initialize()
    UnionWallPhotoNew.Ins():Initialize()
    UnionLogo.Ins():Initialize()
    MarryPhoto.Ins():Initialize()
    FunctionActivity.Me():Reset()
    SealProxy.Instance:ResetSealData()
    SealProxy.Instance:ResetAcceptSealInfo()
    FunctionRepairSeal.Me():ResetRepairSeal()
    TeamProxy.Instance:ExitTeam()
    GuildProxy.Instance:ExitGuild()
    QuestProxy.Instance:CleanAllQuest()
    if Game.Myself then
      Game.Myself:Client_ClearFollower()
    end
    AstrolabeProxy.Instance:ResetPlate()
    RedTipProxy.Instance:RemoveAll()
    PvpProxy.Instance:ClearBosses()
    PvpProxy.Instance:ClearMatchInfo()
    MultiProfessionSaveProxy.Instance:Clear()
    ExchangeShopProxy.Instance:ClearData()
    FunctionBuff.Me():ClearMyBuffs()
    FunctionTempItem.Me():ClearUseIntervalMap()
    GameFacade.Instance:sendNotification(ServiceUserProxy.RecvLogin)
  else
    LogUtility.Info("<color=yellow>\231\153\187\233\153\134\229\164\177\232\180\165</color>")
  end
  self:Notify(ServiceEvent.LoginUserCmdLoginResultUserCmd, data)
end
function ServiceLoginUserCmdProxy:RecvSnapShotUserCmd(data)
  local security = FunctionSecurity.Me()
  if security.verifySecuriySus and security.verifySecuriyCode then
    ServiceLoginUserCmdProxy.Instance:CallConfirmAuthorizeUserCmd(security.verifySecuriyCode)
  end
  MyselfProxy.Instance:SetUserRolesInfo(data)
  UIModelRolesList.Ins():SetRoleDeleteCDCompleteTime(data.deletecdtime)
  ServiceUserProxy.Instance:RecvRoleInfo(data)
  ServiceConnProxy.Instance:CheckHeartStatus()
  ServiceConnProxy.Instance:RecvHeart()
  self:CallServerTimeUserCmd()
  self:Notify(ServiceEvent.LoginUserCmdSnapShotUserCmd, data)
  local loginData = FunctionLogin.Me():getLoginData()
  local account = loginData ~= nil and loginData.accid or 0
  DiskFileHandler.Ins():SetUser(account)
  local server = FunctionLogin.Me():getCurServerData()
  local serverID = server ~= nil and server.serverid or 0
  DiskFileHandler.Ins():SetServer(serverID)
  local loginData = FunctionLogin.Me():getLoginData()
  local account = loginData ~= nil and loginData.accid or 0
  local userAge = 99
  local userName = "wumingshi"
  FunctionTyrantdb.Instance:SetUser(account, E_TyrantdbUserType.Registered, E_TyrantdbUserSex.Unknown, userAge, userName)
  if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
    local runtimePlatform = ApplicationInfo.GetRunPlatform()
    if runtimePlatform == RuntimePlatform.IPhonePlayer then
    end
  end
  local server = FunctionLogin.Me():getCurServerData()
  local serverName = server ~= nil and server.name or "Unknown"
  FunctionTyrantdb.Instance:SetServer(serverName)
end
function ServiceLoginUserCmdProxy:RecvServerTimeUserCmd(data)
  ServerTime.InitTime(data.time)
  LocalSaveProxy.Instance:InitDontShowAgain()
  self:Notify(ServiceEvent.NUserServerTime, data)
end
function ServiceLoginUserCmdProxy:RecvConfirmAuthorizeUserCmd(data)
  FunctionSecurity.Me():RecvAuthorizeInfo(data)
  self:Notify(ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd, data)
end
function ServiceLoginUserCmdProxy:RecvSafeDeviceUserCmd(data)
  Game.isSecurityDevice = data.safe
  self:Notify(ServiceEvent.LoginUserCmdSafeDeviceUserCmd, data)
end
function ServiceLoginUserCmdProxy:CallRealAuthorizeUserCmd(authoriz_state, authorized)
  helplog("Call-->RealAuthorizeUserCmd", authoriz_state)
  ServiceLoginUserCmdProxy.super.CallRealAuthorizeUserCmd(self, authoriz_state, authorized)
end
function ServiceLoginUserCmdProxy:RecvRealAuthorizeUserCmd(data)
  helplog("Recv-->RealAuthorizeUserCmd", data.authorized)
  FunctionLogin.Me():set_realName_Centified(data.authorized)
  self:Notify(ServiceEvent.LoginUserCmdRealAuthorizeUserCmd, data)
end
