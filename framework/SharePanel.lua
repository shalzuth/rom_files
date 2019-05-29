using("UnityEngine")
autoImport("SceneUser2_pb")
autoImport("ShangJiaCell")
SharePanel = class("SharePanel", ContainerView)
SharePanel.ViewType = UIViewType.FocusLayer
local SharePanelConfig = {
  CommonHintPanel = {
    id = 1,
    gameObject = nil,
    data = nil
  },
  YouHaveNotArrived = {
    id = 2,
    gameObject = nil,
    data = nil
  },
  ShangJiaPanel = {
    id = 3,
    gameObject = nil,
    data = nil
  },
  TakePhotoPanel = {
    id = 4,
    gameObject = nil,
    data = nil
  },
  SignUpPanel = {
    id = 5,
    gameObject = nil,
    data = nil
  },
  QRCodePanel = {
    id = 6,
    gameObject = nil,
    data = nil
  },
  PhotographResultPanel = {
    id = 7,
    gameObject = nil,
    data = nil
  }
}
local tempV3_1, tempV3_2 = LuaVector3(), LuaVector3()
local tempRot = LuaQuaternion()
function SharePanel:Init()
  self:initData()
  self:initView()
end
function SharePanel:initData()
  self.QueueTable = {}
end
function SharePanel:NPCDance()
  if self.role then
    self.role:PlayAction_Simple("functional_action")
  end
end
function SharePanel:ShowCustomPanel(PanelconifgPanel, PanelData, btnfunc)
end
function SharePanel:HideCustomPanel(PanelconifgPanel)
end
function SharePanel:initView()
  self.CloseButton = self:FindGO("CloseButton")
  self:HideNPC()
  self.QRCodePanel = self:FindGO("QRCodePanel")
  self.QRCodePanelCloseBtn = self:FindGO("CloseBtn", self.QRCodePanel)
  self:AddClickEvent(self.QRCodePanelCloseBtn.gameObject, function()
    self:CloseSelf()
  end)
  self:InitShare()
end
function SharePanel:InitShare()
  self.QRCodePanelWeiBoBtn = self:FindGO("WeiBoBtn", self.QRCodePanel)
  self.QRCodePanelQQBtn = self:FindGO("QQBtn", self.QRCodePanel)
  self.QRCodePanelWeChatBtn = self:FindGO("WeChatBtn", self.QRCodePanel)
  self.QRCodePanelconfirmBtn = self:FindGO("confirmBtn", self.QRCodePanel)
  self.QRCodePanelBG = self:FindGO("BG", self.QRCodePanel)
  self.QRCodePanelBG_UITexture = self.QRCodePanelBG:GetComponent(UITexture)
  local texName = GameConfig.KFCItems[3]
  if texName then
    PictureManager.Instance:SetUI(texName, self.QRCodePanelBG_UITexture)
  else
    helplog("\233\133\141\231\189\174\232\161\168\230\156\137\232\175\175")
  end
  self:AddClickEvent(self.QRCodePanelWeiBoBtn.gameObject, function()
    self:ShareAndReward(3, "", "", E_PlatformType.Sina, self.QRCodePanelBG_UITexture.mainTexture)
  end)
  self:AddClickEvent(self.QRCodePanelQQBtn.gameObject, function()
    self:ShareAndReward(3, "", "", E_PlatformType.QQ, self.QRCodePanelBG_UITexture.mainTexture)
  end)
  self:AddClickEvent(self.QRCodePanelWeChatBtn.gameObject, function()
    self:ShareAndReward(3, "", "", E_PlatformType.WechatMoments, self.QRCodePanelBG_UITexture.mainTexture)
  end)
  self:AddClickEvent(self.QRCodePanelconfirmBtn.gameObject, function()
    self:SavePic(self.QRCodePanelBG_UITexture.mainTexture, "KFC\230\180\187\229\138\168")
  end)
end
local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"
function SharePanel:ShareAndReward(sharetype, content_title, content_body, platform_type, texture)
  ServiceNUserProxy.Instance:CallKFCShareUserCmd(sharetype)
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  if self.screenShotHelper == nil then
    self.gameObject:AddComponent(ScreenShotHelper)
  end
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  local picName = shotName .. tostring(os.time())
  local path = PathUtil.GetSavePath(PathConfig.TempShare) .. "/" .. picName
  ScreenShot.SaveJPG(texture, path, 100)
  path = path .. ".jpg"
  helplog("path" .. path)
  SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
    ROFileUtils.FileDelete(path)
    if platform_type == E_PlatformType.Sina then
      MsgManager.ShowMsgByIDTable(566)
    end
  end, function(failCode, failMsg)
    ROFileUtils.FileDelete(path)
    local errorMessage = failMsg or "error"
    if failCode ~= nil then
      errorMessage = failCode .. ", " .. errorMessage
    end
    MsgManager.ShowMsg("", errorMessage, MsgManager.MsgType.Float)
  end, function()
    ROFileUtils.FileDelete(path)
  end)
end
function SharePanel:RecvKFCEnrollCodeUserCmd(data)
end
function SharePanel:RecvKFCHasEnrolledUserCmd(data)
end
function SharePanel:RecvKFCEnrollUserCmd(data)
end
function SharePanel:RecvKFCEnrollReplyUserCmd(data)
end
function SharePanel:takePic()
end
function SharePanel:PreTakePic()
end
function SharePanel:StringIsNullOrEmpty(text)
  if text == nil or text == "" then
    return true
  else
    return false
  end
end
function SharePanel:InitHead()
  self.playerHeadCell = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), self.TakePhotoPanelPortraitCell)
  self.targetCell = PlayerFaceCell.new(self.playerHeadCell)
  self.targetCell:HideHpMp()
  self.targetCell:HideLevel()
  self.headData = HeadImageData.new()
  self.headData:TransByMyself()
  self.headData.frame = nil
  self.headData.job = nil
  self.targetCell:SetData(self.headData)
end
function SharePanel:OnEnter()
  helplog("@SharePanel:OnEnter()")
  self.hasExit = false
end
function SharePanel:OnExit()
  self.QueueTable = {}
  TimeTickManager.Me():ClearTick(self)
  self.hasExit = true
end
function SharePanel:CheckGPS()
end
function SharePanel:RecvKFCShareUserCmd(data)
  helplog("function SharePanel:RecvKFCShareUserCmd(data)")
end
function SharePanel:SavePic(texture, name)
  local result = PermissionUtil.Access_SavePicToMediaStorage()
  if result then
    local picName = name
    local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
    ScreenShot.SaveJPG(texture, path, 100)
    path = path .. ".jpg"
    ExternalInterfaces.SavePicToDCIM(path)
    MsgManager.ShowMsgByID(907)
  end
end
function SharePanel:ShowNPC()
  if self.role and self.assetEffect then
    self.role:SetPosition(Vector3(0, -246, 664.5))
    self.assetEffect:ResetLocalPositionXYZ(0, 0, 0)
    self:NPCDance()
  end
end
function SharePanel:HideNPC()
  if self.role and self.assetEffect then
    self.role:SetPosition(Vector3(99999, 99999, 999999))
    self.assetEffect:ResetLocalPositionXYZ(99999, 99999, 999999)
    self:NPCDance()
  end
end
