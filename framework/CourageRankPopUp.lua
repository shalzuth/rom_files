autoImport("CourageRankData")
autoImport("CourageRankCell")
CourageRankPopUp = class("CourageRankPopUp", BaseView)
CourageRankPopUp.ViewType = UIViewType.NormalLayer
CourageRankPopUp.TexMvpName = "pvp_bg_mvp"
CourageRankPopUp.TexWinBGName = "pvp_bg_win"
CourageRankPopUp.TexWinTextName = "pvp_bg_courage"
CourageRankPopUp.ActivityID = 601
function CourageRankPopUp:Init()
  self:FindObjs()
  self:InitList()
  self:AddButtonEvts()
  self:AddViewEvts()
end
function CourageRankPopUp:FindObjs()
  self.objRoot = self:FindGO("Root")
  self.objFrontPanel = self:FindGO("FrontPanel")
  self.objModelInfos = self:FindGO("ModelInfos", self.objFrontPanel)
  self.labMvpName = self:FindComponent("labMvpName", UILabel, self.objModelInfos)
  self.objModelParent = self:FindGO("ModelRoot", self.objModelInfos)
  self.labLeftTime = self:FindComponent("labLeftTime", UILabel, self.objFrontPanel)
  self.tsfMyselfParent = self:FindGO("MyselfInfoParent").transform
  self.colListDrag = self:FindComponent("ReportList", Collider)
end
function CourageRankPopUp:InitList()
  self.objLoading = self:FindGO("LoadingRoot")
  self.objEmptyList = self:FindGO("EmptyList")
  self.listReports = WrapListCtrl.new(self:FindGO("reportContainer"), CourageRankCell, "CourageRankCell", WrapListCtrl_Dir.Vertical)
end
function CourageRankPopUp:AddButtonEvts()
  self:AddClickEvent(self:FindGO("BtnHelp", self.objFrontPanel), function()
    self:OnBtnShowHelp()
  end)
  self:AddClickEvent(self:FindGO("BtnClose", self.objFrontPanel), function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self:FindGO("BtnLeave", self.objFrontPanel), function()
    self:CloseSelf()
  end)
end
function CourageRankPopUp:AddViewEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdStartActCmd, self.RefreshLeftTime)
  self:AddListenEvt(ServiceEvent.ActivityCmdStopActCmd, self.RefreshLeftTime)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryMenrocoRankMatchCCmd, self.HandleQueryMenrocoRankMatchCCmd)
  self:AddListenEvt(ServiceEvent.ChatCmdQueryUserShowInfoCmd, self.HandleQueryUserShowInfoCmd)
end
function CourageRankPopUp:SetTextures()
  PictureManager.Instance:SetPVP(CourageRankPopUp.TexWinBGName, self:FindComponent("texWinBG", UITexture, self.objFrontPanel))
  PictureManager.Instance:SetPVP(CourageRankPopUp.TexWinTextName, self:FindComponent("texWinText", UITexture, self.objFrontPanel))
  PictureManager.Instance:SetPVP(CourageRankPopUp.TexMvpName, self:FindComponent("texMvp", UITexture, self.objFrontPanel))
end
function CourageRankPopUp:HandleQueryMenrocoRankMatchCCmd(note)
  if not note or not note.body then
    printRed("No Courage Rank Data!")
    return
  end
  self:ClearRankDatas()
  self.rankDatas = ReusableTable.CreateArray()
  local serverDatas = note.body.datas
  for i = 1, #serverDatas do
    self.rankDatas[i] = CourageRankData.ParseServerData(ReusableTable.CreateTable(), serverDatas[i], i)
  end
  self.objLoading:SetActive(false)
  self.objEmptyList:SetActive(#self.rankDatas < 1)
  self.colListDrag.enabled = #self.rankDatas > 9
  self.listReports:ResetDatas(self.rankDatas)
  if #self.rankDatas > 0 then
    self:CreateMyselfCell(note.body.myrank)
    ServiceChatCmdProxy.Instance:CallQueryUserShowInfoCmd(self.rankDatas[1].charid)
    self.labMvpName.text = self.rankDatas[1].name
  end
end
function CourageRankPopUp:CreateMyselfCell(myRank)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("CourageRankCell"))
  cellpfb.transform:SetParent(self.tsfMyselfParent, false)
  self.myselfData = CourageRankData.CreateMyselfData(ReusableTable.CreateTable(), myRank)
  self.cellMyself = CourageRankCell.new(cellpfb)
  self.cellMyself:SetData(self.myselfData)
  self.cellMyself:SetLineActive(false)
  self.cellMyself:SetBGActive(true)
end
function CourageRankPopUp:HandleQueryUserShowInfoCmd(note)
  if not note or not note.body then
    return
  end
  self:DestroyRoleModel()
  self.objModelInfos:SetActive(true)
  local serverdata = note.body.info.datas
  if serverdata then
    self.mvpUserData = UserData.CreateAsTable()
    local sdata
    for i = 1, #serverdata do
      sdata = serverdata[i]
      if sdata then
        self.mvpUserData:SetByID(sdata.type, sdata.value, sdata.data)
      end
    end
  end
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
  self.role:SetName(self.labMvpName.text)
  self.role:SetPosition(LuaGeometry.Const_V3_zero)
  self.role:SetEulerAngleY(180)
  self.role:SetScale(320)
  self.role:RegisterWeakObserver(self)
  TimeTickManager.Me():CreateTick(0, 33, self.CheckModelCreated, self, 1)
  if self.effectRole and self.effectRole:Alive() then
    self.effectRole:Destroy()
  end
  self.effectRole = self:PlayUIEffect(EffectMap.UI.TeamPws_MvpPlayer, self:FindGO("RoleEffect"))
  self.effectRole:RegisterWeakObserver(self)
end
function CourageRankPopUp:ObserverDestroyed(obj)
  if obj == self.role then
    TimeTickManager.Me():ClearTick(self, 1)
    self.role = nil
  elseif obj == self.effectRole then
    self.effectRole = nil
  end
end
function CourageRankPopUp:OnBtnShowHelp()
  local panelId = PanelConfig.CourageRankPopUp.id
  local Desc = Table_Help[panelId] and Table_Help[panelId].Desc or ZhString.Help_RuleDes
  TipsView.Me():ShowGeneralHelp(Desc)
end
function CourageRankPopUp:RefreshLeftTime()
  self:ClearTick()
  local activityOpen = FunctionActivity.Me():IsActivityRunning(CourageRankPopUp.ActivityID)
  self.labLeftTime.gameObject:SetActive(activityOpen)
  if activityOpen then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 330, self.UpdateLeftTime, self, 2)
  end
end
function CourageRankPopUp:UpdateLeftTime()
  local actData = FunctionActivity.Me():GetActivityData(CourageRankPopUp.ActivityID)
  if not actData then
    self.labLeftTime.gameObject:SetActive(false)
    self:ClearTick()
    LogUtility.Error(string.format("Cannot Find Activity Data By ID: %s", CourageRankPopUp.ActivityID))
    return
  end
  local totalSec = actData:GetEndTime() - ServerTime.CurServerTime() / 1000
  if totalSec > 0 then
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(totalSec)
    if day > 0 then
      self.labLeftTime.text = string.format(ZhString.Courage_EndTime, (hour > 0 or min > 0 or sec > 0) and day + 1 or day)
    else
      self.labLeftTime.text = string.format(ZhString.Courage_EndTime_Detail, hour, min, sec)
    end
  else
    self.labLeftTime.text = string.format(ZhString.Courage_EndTime_Detail, 0, 0, 0)
    self:ClearTick()
  end
end
function CourageRankPopUp:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self, 2)
    self.timeTick = nil
  end
end
function CourageRankPopUp:ClearRankDatas()
  if self.myselfData then
    ReusableTable.DestroyAndClearTable(self.myselfData)
    self.myselfData = nil
  end
  if self.rankDatas then
    for i = 1, #self.rankDatas do
      ReusableTable.DestroyAndClearTable(self.rankDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.rankDatas)
    self.rankDatas = nil
  end
end
function CourageRankPopUp:CheckModelCreated()
  if not self.role.complete.body then
    return
  end
  TimeTickManager.Me():ClearTick(self, 1)
  local animParams = Asset_Role.GetPlayActionParams(GameConfig.teamPVP.Victoryanimation, Asset_Role.ActionName.Idle, 1)
  animParams[7] = function()
    if self.role then
      self.role:PlayAction_Simple(Asset_Role.ActionName.Idle)
    end
  end
  self.role:PlayAction(animParams)
end
function CourageRankPopUp:DestroyRoleModel()
  if self.role then
    self.role:Destroy()
    self.role = nil
  end
  TimeTickManager.Me():ClearTick(self, 1)
end
function CourageRankPopUp:InitSocialShare()
  self:InitSocialShareData()
  self:FindSocialShareObjs()
  self:RegisterButtonClickEvent()
end
function CourageRankPopUp:InitSocialShareData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end
function CourageRankPopUp:FindSocialShareObjs()
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare")
  self.objBtnShare = self:FindGO("BtnShare", self.objFrontPanel)
end
function CourageRankPopUp:RegisterButtonClickEvent()
  self:AddClickEvent(self:FindGO("WechatMoments", self.goUIViewSocialShare), function()
    self:OnClickForButtonWechatMoments()
  end)
  self:AddClickEvent(self:FindGO("Wechat", self.goUIViewSocialShare), function()
    self:OnClickForButtonWechat()
  end)
  self:AddClickEvent(self:FindGO("QQ", self.goUIViewSocialShare), function()
    self:OnClickForButtonQQ()
  end)
  self:AddClickEvent(self:FindGO("Sina", self.goUIViewSocialShare), function()
    self:OnClickForButtonSina()
  end)
  self:AddClickEvent(self.objBtnShare, function()
    self:Show(self.goUIViewSocialShare)
  end)
  self:AddClickEvent(self:FindGO("closeShare", self.goUIViewSocialShare), function()
    self:Hide(self.goUIViewSocialShare)
  end)
end
function CourageRankPopUp:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    self:sharePicture(E_PlatformType.WechatMoments, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function CourageRankPopUp:OnClickForButtonWechat()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
    self:sharePicture(E_PlatformType.Wechat, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function CourageRankPopUp:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    self:sharePicture(E_PlatformType.QQ, "", "")
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end
function CourageRankPopUp:OnClickForButtonSina()
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
function CourageRankPopUp:sharePicture(platform_type, content_title, content_body)
  self:startCaptureScreen(platform_type, content_title, content_body)
end
function CourageRankPopUp:startCaptureScreen(platform_type, content_title, content_body)
  local ui = NGUIUtil:GetCameraByLayername("UI")
  local default = NGUIUtil:GetCameraByLayername("Default")
  self:changeUIState(true)
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:changeUIState(false)
    self:startSharePicture(texture, platform_type, content_title, content_body)
  end, ui, default)
end
function CourageRankPopUp:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.objBtnShare)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.objBtnShare)
  end
end
function CourageRankPopUp:startSharePicture(texture, platform_type, content_title, content_body)
  local picName = string.format("Ro_%s", tostring(os.time()))
  local path = string.format("%s/%s", PathUtil.GetSavePath(PathConfig.PhotographPath), picName)
  ScreenShot.SaveJPG(texture, path, 100)
  path = string.format("%s%s", path, ".jpg")
  self:Log("MarriageCertificate sharePicture pic path:", path)
  SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
    self:Log("SocialShare.Instance:Share success")
    ROFileUtils.FileDelete(path)
    if platform_type == E_PlatformType.Sina then
      MsgManager.ShowMsgByIDTable(566)
    end
  end, function(failCode, failMsg)
    self:Log("SocialShare.Instance:Share failure")
    ROFileUtils.FileDelete(path)
    local errorMessage = failMsg or "error"
    if failCode then
      errorMessage = string.format("%s, %s", failCode, errorMessage)
    end
    MsgManager.ShowMsg("", errorMessage, MsgManager.MsgType.Float)
  end, function()
    self:Log("SocialShare.Instance:Share cancel")
    ROFileUtils.FileDelete(path)
  end)
end
function CourageRankPopUp:OnEnter()
  self.super.OnEnter(self)
  self:SetTextures()
  self:RefreshLeftTime()
  ServiceMatchCCmdProxy.Instance:CallQueryMenrocoRankMatchCCmd()
  self.objModelInfos:SetActive(false)
end
function CourageRankPopUp:OnExit()
  PictureManager.Instance:UnLoadPVP()
  TimeTickManager.Me():ClearTick(self)
  self:ClearRankDatas()
  self:DestroyRoleModel()
  if self.mvpUserData then
    self.mvpUserData:Destroy()
  end
  if self.effectRole and self.effectRole:Alive() then
    self.effectRole:Destroy()
  end
  self.super.OnExit(self)
end
