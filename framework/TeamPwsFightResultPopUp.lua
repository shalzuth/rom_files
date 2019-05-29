autoImport("TeamPwsReportPanel")
TeamPwsFightResultPopUp = class("TeamPwsFightResultPopUp", BaseView)
TeamPwsFightResultPopUp.ViewType = UIViewType.NormalLayer
TeamPwsFightResultPopUp.TexMvpName = "pvp_bg_mvp"
function TeamPwsFightResultPopUp:Init()
  self:FindObjs()
  self:InitReportPanel()
  self:AddButtonEvts()
  self:AddViewEvts()
  self:InitSocialShare()
end
function TeamPwsFightResultPopUp:FindObjs()
  self.objRoot = self:FindGO("Root")
  self.objModelInfos = self:FindGO("ModelInfos")
  self.labMvpName = self:FindComponent("labMvpName", UILabel)
  self.objModelParent = self:FindGO("ModelRoot")
end
function TeamPwsFightResultPopUp:InitReportPanel()
  self.reportPanel = TeamPwsReportPanel.new(self:FindGO("ReportRoot"))
end
function TeamPwsFightResultPopUp:AddButtonEvts()
  self:AddClickEvent(self:FindGO("BtnClose"), function()
    self:ClickButtonLeave()
  end)
  self:AddClickEvent(self:FindGO("BtnLeave"), function()
    self:ClickButtonLeave()
  end)
end
function TeamPwsFightResultPopUp:AddViewEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleLoadScene)
end
function TeamPwsFightResultPopUp:SetTexturesAndEffects()
  self.effectWin = self:PlayUIEffect(self.isRedTeamWin and EffectMap.UI.TeamPws_RedWin or EffectMap.UI.TeamPws_BlueWin, self:FindGO("WinEffect"))
  self.effectWin:RegisterWeakObserver(self)
  self.effectRole = self:PlayUIEffect(EffectMap.UI.TeamPws_MvpPlayer, self:FindGO("RoleEffect"))
  self.effectRole:RegisterWeakObserver(self)
  PictureManager.Instance:SetPVP(TeamPwsFightResultPopUp.TexMvpName, self:FindComponent("texMvp", UITexture))
end
function TeamPwsFightResultPopUp:CreateMvpPlayerRole()
  self:DestroyRoleModel()
  local userdata = self.mvpUserData
  if not userdata then
    return
  end
  local parts = Asset_Role.CreatePartArray()
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0
  parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
  parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0
  parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0
  parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
  parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
  parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0
  parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
  parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
  parts[partIndex.Mount] = 0
  parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
  parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
  parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
  parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
  parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
  self.role = Asset_Role.Create(parts)
  self.role:SetParent(self.objModelParent.transform, false)
  self.role:SetLayer(self.objModelParent.layer)
  self.role:SetName(userdata:Get(UDEnum.NAME) or self.labMvpName.text)
  self.role:SetPosition(LuaGeometry.Const_V3_zero)
  self.role:SetEulerAngleY(180)
  self.role:SetScale(320)
  self.role:RegisterWeakObserver(self)
  self.timeTick = TimeTickManager.Me():CreateTick(0, 33, self.ProcessLayoutWhenModelCreated, self, 1)
end
function TeamPwsFightResultPopUp:ObserverDestroyed(obj)
  if obj == self.role then
    self:ClearTick()
    self.role = nil
  elseif obj == self.effectRole then
    self.effectRole = nil
  elseif obj == self.effectWin then
    self.effectWin = nil
  end
end
function TeamPwsFightResultPopUp:ProcessLayoutWhenModelCreated()
  if not self.role then
    self:ClearTick()
    return
  end
  if not self.role.complete.body then
    return
  end
  self:ClearTick()
  local animParams = Asset_Role.GetPlayActionParams(GameConfig.teamPVP.Victoryanimation, Asset_Role.ActionName.Idle, 1)
  animParams[7] = function()
    if self.role then
      self.role:PlayAction_Simple(Asset_Role.ActionName.Idle)
    end
  end
  self.role:PlayAction(animParams)
  if not self.role.complete.body.mainSMR then
    return
  end
  local width = self.role.complete.body.mainSMR.localBounds.size.x
  if width < 1.65 then
    return
  end
  local pos = self.objRoot.transform.localPosition
  pos.x = pos.x - 80
  self.objRoot.transform.localPosition = pos
  pos = self.objModelInfos.transform.localPosition
  pos.x = pos.x + 150
  self.objModelInfos.transform.localPosition = pos
  local mvpName = self:FindGO("MvpName").transform
  pos = mvpName.localPosition
  pos.x = pos.x - 50
  mvpName.localPosition = pos
end
function TeamPwsFightResultPopUp:ClickButtonLeave()
  ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
  self:CloseSelf()
end
function TeamPwsFightResultPopUp:HandleLoadScene()
  if not Game.MapManager:IsPVPMode_TeamPws() then
    self:CloseSelf()
  end
end
function TeamPwsFightResultPopUp:DestroyRoleModel()
  if self.role then
    self.role:Destroy()
    self.role = nil
  end
end
function TeamPwsFightResultPopUp:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end
function TeamPwsFightResultPopUp:InitSocialShare()
  self:InitSocialShareData()
  self:FindSocialShareObjs()
  self:RegisterButtonClickEvent()
end
function TeamPwsFightResultPopUp:InitSocialShareData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end
function TeamPwsFightResultPopUp:FindSocialShareObjs()
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare")
  self.objBtnShare = self:FindGO("BtnShare")
end
function TeamPwsFightResultPopUp:RegisterButtonClickEvent()
  self:AddClickEvent(self.objBtnShare, function()
    self:Show(self.goUIViewSocialShare)
  end)
  self:AddClickEvent(self:FindGO("closeShare", self.goUIViewSocialShare), function()
    self:Hide(self.goUIViewSocialShare)
  end)
  self:AddClickEvent(self:FindGO("Facebook", self.goUIViewSocialShare), function()
    self:sharePicture(E_PlatformType.WechatMoments, "", "")
  end)
end
function TeamPwsFightResultPopUp:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    self:sharePicture(E_PlatformType.WechatMoments, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function TeamPwsFightResultPopUp:OnClickForButtonWechat()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
    self:sharePicture(E_PlatformType.Wechat, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function TeamPwsFightResultPopUp:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    self:sharePicture(E_PlatformType.QQ, "", "")
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end
function TeamPwsFightResultPopUp:OnClickForButtonSina()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
    local contentBody = GameConfig.PhotographResultPanel_ShareDescription
    if contentBody == nil or #contentBody <= 0 then
      contentBody = "RO"
    end
    self:sharePicture(E_PlatformType.Sina, "", contentBody)
  else
    MsgManager.ShowMsgByIDTable(563)
  end
end
function TeamPwsFightResultPopUp:sharePicture(platform_type, content_title, content_body)
  self:startCaptureScreen(platform_type, content_title, content_body)
end
function TeamPwsFightResultPopUp:startCaptureScreen(platform_type, content_title, content_body)
  local ui = NGUIUtil:GetCameraByLayername("UI")
  local default = NGUIUtil:GetCameraByLayername("Default")
  self:changeUIState(true)
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:changeUIState(false)
    self:startSharePicture(texture, platform_type, content_title, content_body)
  end, ui, default)
end
function TeamPwsFightResultPopUp:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.objBtnShare)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.objBtnShare)
  end
end
function TeamPwsFightResultPopUp:startSharePicture(texture, platform_type, content_title, content_body)
  local picName = string.format("Ro_%s", tostring(os.time()))
  local path = string.format("%s/%s", PathUtil.GetSavePath(PathConfig.PhotographPath), picName)
  ScreenShot.SaveJPG(texture, path, 100)
  path = string.format("%s%s", path, ".jpg")
  self:Log("MarriageCertificate sharePicture pic path:", path)
  local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
  overseasManager:ShareImg(path, content_title, "", content_body, function(msg)
    ROFileUtils.FileDelete(path)
    if msg == "1" then
      MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
    else
      MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
    end
  end)
end
function TeamPwsFightResultPopUp:OnEnter()
  self.super.OnEnter(self)
  local viewdata = self.viewdata and self.viewdata.viewdata
  if viewdata then
    if viewdata.mvpUserInfo then
      self.mvpUserData = UserData.CreateAsTable()
      local serverdata = viewdata.mvpUserInfo.datas
      local sdata
      for i = 1, #serverdata do
        sdata = serverdata[i]
        if sdata then
          self.mvpUserData:SetByID(sdata.type, sdata.value, sdata.data)
        end
      end
      self.labMvpName.text = viewdata.mvpUserInfo.name or ""
    end
    self.isRedTeamWin = viewdata.winTeamColor == PvpProxy.TeamPws.TeamColor.Red
  end
  self:CreateMvpPlayerRole()
  self.reportPanel:InitData()
  self:SetTexturesAndEffects()
end
function TeamPwsFightResultPopUp:OnExit()
  PictureManager.Instance:UnLoadPVP()
  self:ClearTick()
  self:DestroyRoleModel()
  PvpProxy.Instance:ClearTeamPwsReportData()
  if self.mvpUserData then
    self.mvpUserData:Destroy()
  end
  if self.effectWin and self.effectWin:Alive() then
    self.effectWin:Destroy()
  end
  if self.effectRole and self.effectRole:Alive() then
    self.effectRole:Destroy()
  end
  self.super.OnExit(self)
end
