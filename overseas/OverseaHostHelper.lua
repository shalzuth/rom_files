OverseaHostHelper = {}
autoImport("GoogleStorageConfig")
OverseaHostHelper.hostList = nil
OverseaHostHelper.accId = 0
OverseaHostHelper.hasShowAge = false
function OverseaHostHelper:RefreshHostInfo(hostList)
  OverseaHostHelper.hostList = hostList
end
function OverseaHostHelper:GetHosts()
  local hosts = {}
  if OverseaHostHelper.hostList ~= nil then
    for k, v in pairs(OverseaHostHelper.hostList) do
      table.insert(hosts, v.host)
    end
  end
  return hosts
end
function OverseaHostHelper:GetRoleIde()
  local roleInfo = ServiceUserProxy.Instance:GetNewRoleInfo()
  if roleInfo == nil or not roleInfo then
    roleInfo = ServiceUserProxy.Instance:GetRoleInfo()
  end
  local roleId = roleInfo.id
  local timestamp = os.time()
  local ide = roleId .. tostring(timestamp)
  helplog(ide)
  return ide
end
function OverseaHostHelper:isJP()
  return OverSea.LangManager.Instance().CurSysLang == "Japanese"
end
function OverseaHostHelper:CheckStoreIap()
  if ServiceUserProxy.Instance:GetRoleInfo() ~= nil then
    local promotingIap = PlayerPrefs.GetString("PromotingIAP")
    local curProduct
    for _, v in pairs(Table_Deposit) do
      local tpro = v
      if promotingIap ~= "" and tpro.ProductID == promotingIap then
        curProduct = tpro
        break
      end
    end
    if curProduct ~= nil then
      helplog("OverseaHostHelper:CheckStoreIap:" .. promotingIap)
      EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
      ServiceUserEventProxy.Instance:CallQueryChargeCnt()
    else
      helplog("\228\184\141\229\173\152\229\156\168\231\188\147\229\173\152\231\154\132Store \233\162\132\229\148\174,\228\184\141\232\167\166\229\143\145")
    end
  else
    helplog("\232\191\152\230\156\170\231\153\187\229\189\149,\228\184\141\232\167\166\229\143\145")
  end
end
function OverseaHostHelper:OnReceiveQueryChargeCnt(data)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.StorePayPanel,
    viewdata = {}
  })
end
function OverseaHostHelper:StoreIap(msg)
  PlayerPrefs.SetString("PromotingIAP", msg)
  OverseaHostHelper:CheckStoreIap()
end
OverseaHostHelper.isGuest = 0
function OverseaHostHelper:GuestExchangeForbid()
  if OverseaHostHelper.isGuest == 1 then
    MsgManager.FloatMsg("", ZhString.GuestExchangeForbid)
  end
  return OverseaHostHelper.isGuest
end
function OverseaHostHelper:guestSecurity(callback, callbackParam)
  if OverseaHostHelper.isGuest == 1 then
    UIUtil.PopUpConfirmYesNoView(ZhString.GuestSecurityTitle, ZhString.GuestSecurityContent, function()
      Game.Me():BackToLogo()
    end, function()
    end, nil, ZhString.GuestSecurityConfirm, ZhString.GuestSecurityCancel)
  elseif callback then
    callback(callbackParam)
  end
end
function OverseaHostHelper:getScriptPath()
  return ApplicationHelper.persistentDataPath .. "/" .. ApplicationHelper.platformFolder .. "/resources/script2/"
end
function OverseaHostHelper:kr_getClientVVV22Code()
  local scriptFolderList = {
    "overseas.unity3d",
    "login.unity3d"
  }
  local size = 0
  local path = OverseaHostHelper:getScriptPath()
  for i = 1, #scriptFolderList do
    local filePath = path .. scriptFolderList[i]
    local file = io.open(filePath, "r")
    if file then
      size = size + file:seek("end")
      file:close()
    end
  end
  return size
end
function OverseaHostHelper:GachaUseComfirm(count, cb, z, ccb)
  helplog("OverseaHostHelper:GachaUseComfirm", count)
  local id = 99999999
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
  if dont == nil then
    UIUtil.PopUpDontAgainConfirmView(string.format(ZhString.GachaConfirmStr, tostring(count)), function()
      cb()
    end, function()
      if ccb ~= nil then
        ccb()
      end
    end, nil, {
      id = id,
      Title = ZhString.GuestSecurityTitle,
      button = ZhString.GuestSecurityConfirm,
      buttonF = ZhString.GuestSecurityCancel,
      TimeInterval = 1
    })
    if z ~= nil then
      EventManager.Me():PassEvent("XDEChangeZ", {depth = z})
    end
  else
    cb()
  end
end
function OverseaHostHelper:hasRole()
  local roleInfo = ServiceUserProxy.Instance:GetAllRoleInfos()[1]
  if roleInfo and roleInfo.id == 0 then
    return false
  end
  return true
end
function OverseaHostHelper:GenUpLoadSignObj(fields)
  helplog("OverseaHostHelper:GenUpLoadSignObj")
  local uaws = false
  local signDataObj = {}
  for i = 1, #fields do
    local d = fields[i]
    helplog(d.name, d.value)
    signDataObj[d.name] = d.value
  end
  if signDataObj["__using-aws"] and signDataObj["__using-aws"] == "true" then
    uaws = true
  end
  local signObj = uaws and OverSeas_TW.AWSSignObj.insObg(signDataObj.acl, signDataObj["Content-Type"], signDataObj.key, signDataObj.success_action_status, signDataObj["x-amz-algorithm"], signDataObj["x-amz-credential"], signDataObj["x-amz-date"], signDataObj.policy, signDataObj.signature) or OverSeas_TW.GoogleStorageSignObj.insObg(signDataObj["content-type"], signDataObj.bucket, signDataObj.acl, signDataObj.key, signDataObj.GoogleAccessId, signDataObj.policy, signDataObj.signature, signDataObj.success_action_status)
  local url = uaws and string.format("http://%s.s3.ap-northeast-1.amazonaws.com/", signDataObj.bucket) or GoogleStorageConfig.googleStorageUpLoad
  helplog("uploadUrl", url)
  return {signObj = signObj, uploadUrl = url}
end
function OverseaHostHelper:FixLabelOverV1(label, overflow, width)
  label.overflowMethod = overflow
  label.width = width
end
function OverseaHostHelper:FixAnchor(fromAnchor, target, relative, absolute)
  fromAnchor.target = target
  fromAnchor.relative = relative
  fromAnchor.absolute = absolute
end
function OverseaHostHelper:OpenWebView(url, needInternal)
  if ApplicationInfo.IsWindows() then
    Application.OpenURL(url)
  elseif needInternal then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WebviewPanel,
      viewdata = {directurl = url}
    })
  else
    Application.OpenURL(url)
  end
end
function OverseaHostHelper:AFTrack(evntName)
  helplog("OverseaHostHelper:AFTrack", evntName)
  OverSeas_TW.OverSeasManager.GetInstance():TXTrackEvnt(evntName)
end
OverseaHostHelper.AFAchievementObj = {
  AFA1201001 = "\227\131\149\227\131\172\227\131\179\227\131\137\227\130\146\228\189\156\227\129\163\227\129\159",
  AFA1202043 = "\229\136\157\229\155\158\227\130\174\227\131\171\227\131\137\229\138\160\229\133\165\239\188\136\228\189\156\230\136\144\227\130\130\229\144\171\227\130\128\239\188\137",
  AFA1306001 = "\229\134\146\233\153\186\232\128\133\227\131\169\227\131\179\227\130\175F",
  AFA1306002 = "\229\134\146\233\153\186\232\128\133\227\131\169\227\131\179\227\130\175E",
  AFA1306003 = "\229\134\146\233\153\186\232\128\133\227\131\169\227\131\179\227\130\175D",
  AFA1306004 = "\229\134\146\233\153\186\232\128\133\227\131\169\227\131\179\227\130\175C",
  AFA1204008 = "\230\156\128\229\136\157\227\129\174\227\131\154\227\131\131\227\131\136\227\130\146\229\133\165\230\137\139\227\129\151\227\129\159",
  AFA1205011 = "\230\156\128\229\136\157\227\129\174\230\150\153\231\144\134\227\130\146\228\189\156\230\136\144\227\129\151\227\129\159",
  AFA1603084 = "\232\170\178\233\135\145"
}
function OverseaHostHelper:AFAchievementTrack(achievementId)
  local evntName = OverseaHostHelper.AFAchievementObj["AFA" .. tostring(achievementId)]
  helplog("OverseaHostHelper:AFAchievementTrack", achievementId, evntName)
  if evntName ~= nil then
    helplog("exist begin track")
    OverSeas_TW.OverSeasManager.GetInstance():TXTrackEvnt(evntName)
  end
end
function OverseaHostHelper:AFRenewTrack()
  local key = "xde_packageVersion"
  local packageVersion = PlayerPrefs.GetInt(key)
  local currentVersion = CompatibilityVersion.version
  helplog("OverseaHostHelper:AFRenewTrack", packageVersion, currentVersion)
  if packageVersion < currentVersion then
    PlayerPrefs.SetInt(key, currentVersion)
    OverseaHostHelper:AFTrack("\227\130\162\227\131\131\227\131\151\227\131\135\227\131\188\227\131\136")
  else
    helplog("same not need renew")
  end
end
function OverseaHostHelper:ShowGiftProbability(itemId)
  local url = "https://jp-cdn.ro.com/item/manual.html#id=" .. itemId
  helplog("OverseaHostHelper:ShowGiftProbability", url)
  OverseaHostHelper:OpenWebView(url, true)
end
function OverseaHostHelper:TryShowQualitySelect()
  local key = "xde_quality_select"
  local hasSelect = PlayerPrefs.GetInt(key)
  helplog("OverseaHostHelper:TryShowQualitySelect()", hasSelect)
  if hasSelect == 0 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QualitySelect,
      viewdata = {}
    })
    PlayerPrefs.SetInt(key, 1)
  end
end
function OverseaHostHelper:GetWrapLeftStringTextSharp(uiLabel, text)
  uiLabel.text = text
  local textlen = OverSeas_TW.OverSeasManager.GetInstance():GetStringLength(text)
  local bWarp, finalStr, leftStr
  bWarp, finalStr = uiLabel:Wrap(text, finalStr, uiLabel.height)
  finalStr = string.gsub(finalStr, "\n", "")
  if not bWarp then
    local finallen = OverSeas_TW.OverSeasManager.GetInstance():GetStringLength(finalStr)
    uiLabel.text = OverSeas_TW.OverSeasManager.GetInstance():SubString(text, 0, finallen)
    local nextlen = textlen - finallen
    if nextlen > 0 then
      leftStr = OverSeas_TW.OverSeasManager.GetInstance():SubString(text, finallen, nextlen)
    else
      leftStr = ""
    end
  else
    leftStr = nil
  end
  return bWarp, leftStr
end
function OverseaHostHelper:GetWrapLeftStringTextLua(uiLabel, text)
  uiLabel.text = text
  local bWarp, finalStr, leftStr
  bWarp, finalStr = uiLabel:Wrap(text, finalStr, uiLabel.height)
  finalStr = string.gsub(finalStr, "\n", "")
  if not bWarp then
    local finallen = StringUtil.getTextLen(finalStr)
    local lastSpaceIndex = StringUtil.LastIndexOf(finalStr, " ") or finallen
    uiLabel.text = StringUtil.getTextByIndex(text, 1, lastSpaceIndex)
    local textlen = StringUtil.getTextLen(text)
    if finallen < textlen then
      leftStr = StringUtil.getTextByIndex(text, lastSpaceIndex + 1, textlen)
    else
      leftStr = ""
    end
  else
    leftStr = nil
  end
  return bWarp, leftStr
end
function OverseaHostHelper:GetStringLength(str)
  return OverSeas_TW.OverSeasManager.GetInstance():GetStringLength(str)
end
function OverseaHostHelper.AppFlyOpenDeepLink()
  helplog("OverseaHostHelper:AppFlyOpenDeepLink")
end
OverseaHostHelper.Share_URL = "https://ragnarokm.gungho.jp/"
OverseaHostHelper.TWITTER_MSG = "#\227\131\169\227\130\176\227\131\158\227\130\185"
OverseaHostHelper.SAVE_FAILED = "\232\168\177\229\143\175\227\129\149\227\130\140\227\129\166\227\129\132\227\129\170\227\129\132\227\129\159\227\130\129\227\128\129\228\191\157\229\173\152\227\129\151\227\129\190\227\129\155\227\130\147\227\129\167\227\129\151\227\129\159"
