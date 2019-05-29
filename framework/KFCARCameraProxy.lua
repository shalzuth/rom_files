KFCARCameraProxy = class("KFCARCameraProxy", pm.Proxy)
KFCARCameraProxy.Instance = nil
KFCARCameraProxy.NAME = "KFCARCameraProxy"
function KFCARCameraProxy:DebugLog(msg)
  if self:SelfTest() then
    LogUtility.Info("-------KFCARCameraProxy-----------:::" .. msg)
  end
end
function KFCARCameraProxy:SelfTest()
  return false
end
function KFCARCameraProxy:ctor(proxyName, data)
  self.proxyName = proxyName or KFCARCameraProxy.NAME
  if KFCARCameraProxy.Instance == nil then
    KFCARCameraProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self:AddEvts()
end
function KFCARCameraProxy:Init()
end
function KFCARCameraProxy:AddEvts()
end
function KFCARCameraProxy:StartGPS()
end
function KFCARCameraProxy:CheckDateValidByBranch()
  local StartDate, FinishDate
  if EnvChannel.IsReleaseBranch() then
    StartDate = GameConfig.KfcArPhoto.start_time_release
    FinishDate = GameConfig.KfcArPhoto.end_time_release
  else
    StartDate = GameConfig.KfcArPhoto.start_time_TF
    FinishDate = GameConfig.KfcArPhoto.end_time_TF
  end
  if StartDate and FinishDate then
    if GameConfig.KfcArPhoto and StartDate and FinishDate or KFCARCameraProxy.Instance:SelfTest() then
      if KFCARCameraProxy.Instance:CheckDateValid(StartDate, FinishDate) or KFCARCameraProxy.Instance:SelfTest() then
        return true
      else
        helplog("KFC\228\184\141\229\156\168\230\180\187\229\138\168\230\151\182\233\151\180")
        return false
      end
    else
      helplog("\231\173\150\229\136\146\230\178\161\233\133\141\230\180\187\229\138\168\230\151\182\233\151\180")
      return false
    end
  else
    helplog("\231\173\150\229\136\146\230\178\161\233\133\141\230\180\187\229\138\168\230\151\182\233\151\180")
    return false
  end
end
function KFCARCameraProxy:CheckDateValid(StartDate, FinishDate)
  helplog(" KFCARCameraProxy: StartDate:" .. StartDate .. "\tFinishDate:" .. FinishDate)
  if self:StringIsNullOrEmpty(StartDate) or self:StringIsNullOrEmpty(FinishDate) then
    helplog("\230\180\187\229\138\168\230\151\182\233\151\180\230\178\161\233\133\141 \232\175\183\231\173\150\229\136\146\230\163\128\230\159\165")
    return false
  end
  if not StringUtil.IsEmpty(StartDate) and not StringUtil.IsEmpty(FinishDate) then
    local customStartData = self:GetSelfCustomDate(StartDate)
    local customFinishData = self:GetSelfCustomDate(FinishDate)
    local curServerTime = ServerTime.CurServerTime()
    if customStartData and customFinishData and curServerTime and (customStartData > curServerTime / 1000 or customFinishData < curServerTime / 1000) then
      return false
    end
  end
  return true
end
function KFCARCameraProxy:GetSelfCustomDate(validDate)
  local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local year, month, day, hour, min, sec = validDate:match(p)
  local ddd = tonumber(os.date("%z", 0)) / 100
  local offset = (8 - ddd) * 3600
  if day == nil then
    helplog("\231\173\150\229\136\146\231\158\142\229\134\153")
    return
  end
  local startDate = os.time({
    day = day,
    month = month,
    year = year,
    hour = hour,
    min = min,
    sec = sec
  })
  startDate = startDate - offset
  return startDate
end
function KFCARCameraProxy:StringIsNullOrEmpty(text)
  if text == nil or text == "" then
    return true
  else
    return false
  end
end
function KFCARCameraProxy:GetDistance(lat1, lng1, lat2, lng2)
  local a, b, R
  R = 6378137
  lat1 = lat1 * math.pi / 180.0
  lat2 = lat2 * math.pi / 180.0
  a = lat1 - lat2
  b = (lng1 - lng2) * math.pi / 180.0
  local d, sa2, sb2
  sa2 = math.sin(a / 2.0)
  sb2 = math.sin(b / 2.0)
  d = 2 * R * math.asin(math.sqrt(sa2 * sa2 + math.cos(lat1) * math.cos(lat2) * sb2 * sb2))
  return d
end
function KFCARCameraProxy:ClickQQ(path, content_title, content_body)
  local platform = E_PlatformType.QQ
  if SocialShare.Instance:IsClientValid(platform) then
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end
function KFCARCameraProxy:ClickWechat(path, content_title, content_body)
  local platform = E_PlatformType.Wechat
  if SocialShare.Instance:IsClientValid(platform) then
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function KFCARCameraProxy:ClickWechatMoments(path, content_title, content_body)
  local platform = E_PlatformType.WechatMoments
  if SocialShare.Instance:IsClientValid(platform) then
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function KFCARCameraProxy:ClickSina(path)
  local platform = E_PlatformType.Sina
  if SocialShare.Instance:IsClientValid(platform) then
  else
    MsgManager.ShowMsgByIDTable(563)
  end
end
function KFCARCameraProxy:ClickPlatform()
  local data = note.body
  if data then
    self:SharePicture(data, "", "")
  end
end
function KFCARCameraProxy:SharePicture(path, platform_type, content_title, content_body)
  helplog("StarView SharePicture", platform_type)
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self:changeUIState(true)
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:changeUIState(false)
    self:startSharePicture(texture, platform_type, content_title, content_body)
  end, ui)
  SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
    helplog("StarView Share success")
    ROFileUtils.FileDelete(path)
    if platform_type == E_PlatformType.Sina then
      MsgManager.ShowMsgByIDTable(566)
    end
  end, function(failCode, failMsg)
    helplog("StarView Share failure")
    ROFileUtils.FileDelete(path)
    local errorMessage = failMsg or "error"
    if failCode ~= nil then
      errorMessage = failCode .. ", " .. errorMessage
    end
    MsgManager.ShowMsg("", errorMessage, MsgManager.MsgType.Float)
  end, function()
    helplog("StarView Share cancel")
    ROFileUtils.FileDelete(path)
  end)
end
function KFCARCameraProxy:CheckPhone(var)
  local b = tonumber(var)
  helplog(b)
  if b == nil then
    print("is not number")
    return false
  end
  helplog("var==========" .. var)
  if #var ~= 11 then
    return false
  end
  return true
end
function KFCARCameraProxy:JumpPanel()
  if self:CheckGPSisEnabledByUser() or self:SelfTest() then
  else
    self:ShowGPSMsg()
    return
  end
  if self.c1 ~= nil then
    return
  end
  self.c1 = coroutine.create(function()
    Input.location:Stop()
    Input.location:Start(0.1, 0.1)
    local maxWait = 20
    while true do
      local b1 = self:CheckGPSisEnabledByUser() or self:SelfTest()
      local b2 = self:CheckGPSLocationServiceStatus() or self:SelfTest()
      local b3 = self:CheckCameraPermission() or self:SelfTest()
      if b1 and b2 then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.KFCARCameraPanel,
          viewdata = nil
        })
        self.c1 = nil
        return
      end
      if b3 == false then
        Input.location:Stop()
        self.c1 = nil
        return
      end
      helplog("maxWait" .. maxWait)
      maxWait = maxWait - 1
      if maxWait < 0 then
        Input.location:Stop()
        self:ShowGPSMsg()
        self.c1 = nil
        return
      end
      Yield(WaitForSeconds(1))
    end
  end)
  coroutine.resume(self.c1)
end
function KFCARCameraProxy:CheckGPSisEnabledByUser()
  if Input.location.isEnabledByUser then
    return true
  else
    return false
  end
end
function KFCARCameraProxy:CheckGPSLocationServiceStatus()
  if Input.location.status == LocationServiceStatus.Stopped then
    return false
  elseif Input.location.status == LocationServiceStatus.Initializing then
    return false
  elseif Input.location.status == LocationServiceStatus.Running then
    return true
  elseif Input.location.status == LocationServiceStatus.Failed then
    return false
  end
  return false
end
function KFCARCameraProxy:CheckCameraPermission()
  Yield(Application.RequestUserAuthorization(UserAuthorization.WebCam))
  if Application.HasUserAuthorization(UserAuthorization.WebCam) then
    local devices = UnityEngine.WebCamTexture.devices
    if devices == nil then
      self:ShowCameraMsg()
      return false
    end
    helplog("#devices" .. #devices)
    if #devices == 0 then
      self:ShowCameraMsg()
      return false
    else
      return true
    end
  else
    helplog("camera deny3")
    self:ShowCameraMsg()
    return false
  end
end
function KFCARCameraProxy:ShowCameraMsg()
  helplog("camera deny4")
  MsgManager.ConfirmMsgByID(28018)
end
function KFCARCameraProxy:ShowGPSMsg()
  helplog("camera deny5")
  MsgManager.ConfirmMsgByID(28014)
end
return KFCARCameraProxy
