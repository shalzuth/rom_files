using("UnityEngine")
autoImport("SceneUser2_pb")
autoImport("ShangJiaCell")
KFCARCameraPanel = class("KFCARCameraPanel", ContainerView)
KFCARCameraPanel.ViewType = UIViewType.FocusLayer
local KFCARCameraPanelConfig = {
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
function KFCARCameraPanel:Init()
  self:initData()
  self:initView()
  KFCARCameraPanelConfig = {
    CommonHintPanel = {
      id = 1,
      gameObject = self.CommonHintPanel.gameObject
    },
    YouHaveNotArrived = {
      id = 2,
      gameObject = self.YouHaveNotArrived.gameObject
    },
    ShangJiaPanel = {
      id = 3,
      gameObject = self.ShangJiaPanel.gameObject
    },
    TakePhotoPanel = {
      id = 4,
      gameObject = self.TakePhotoPanel.gameObject
    },
    SignUpPanel = {
      id = 5,
      gameObject = self.SignUpPanel.gameObject
    },
    QRCodePanel = {
      id = 6,
      gameObject = self.QRCodePanel.gameObject
    },
    PhotographResultPanel = {
      id = 7,
      gameObject = self.PhotographResultPanel.gameObject
    }
  }
  self.SignUpPanelNumberInput_UIInput.value = ""
  self.SignUpPanelCodeInput_UIInput.value = ""
  KFCARCameraPanelConfig.TakePhotoPanel.gameObject:SetActive(false)
  KFCARCameraPanelConfig.ShangJiaPanel.gameObject:SetActive(false)
  KFCARCameraPanelConfig.SignUpPanel.gameObject:SetActive(false)
  KFCARCameraPanelConfig.QRCodePanel.gameObject:SetActive(false)
  KFCARCameraPanelConfig.PhotographResultPanel.gameObject:SetActive(false)
end
function KFCARCameraPanel:initData()
  self.QueueTable = {}
end
function KFCARCameraPanel:NPCDance()
  if self.role then
    self.role:PlayAction_Simple("functional_action")
  end
end
function KFCARCameraPanel:ShowCustomPanel(PanelconifgPanel, PanelData, btnfunc)
  helplog("ShowCustomPanel:" .. PanelconifgPanel.gameObject.name)
  if self.hasExit then
    return
  end
  if PanelconifgPanel == KFCARCameraPanelConfig.YouHaveNotArrived then
    PanelconifgPanel.gameObject:SetActive(true)
    return
  end
  if PanelconifgPanel == KFCARCameraPanelConfig.ShangJiaPanel then
    if PanelconifgPanel.gameObject.activeInHierarchy then
      helplog("ShangJiaPanel active")
      return
    else
      helplog("ShangJiaPanel not active")
    end
  end
  self.QueueTable = self.QueueTable or {}
  helplog("#self.QueueTable:" .. #self.QueueTable)
  for i = 1, #self.QueueTable do
    local tmp = self.QueueTable[i]
    tmp.panel.gameObject:SetActive(false)
    if tmp.panel == KFCARCameraPanelConfig.TakePhotoPanel then
      self.role:SetPosition(Vector3(0, -9999999, -999999))
      self.assetEffect:ResetLocalPositionXYZ(0, -9999999, -9999999)
    end
  end
  if PanelconifgPanel == KFCARCameraPanelConfig.TakePhotoPanel then
    helplog("ShowCustomPanel Take show")
    if PanelconifgPanel.gameObject.activeInHierarchy then
      helplog("TakePhotoPanel active")
      return
    else
      helplog("TakePhotoPanel not active")
    end
    self:ShowNPC()
  end
  if PanelconifgPanel == KFCARCameraPanelConfig.CommonHintPanel then
    if PanelData and PanelData.text then
      self.CommonHintPanelTitle_UILabel.text = PanelData.text
    end
    if btnfunc ~= nil then
      self:AddClickEvent(self.CommonHintPanelclose.gameObject, function()
        helplog("CommonHintPanelclose")
        btnfunc()
      end)
    else
      self:AddClickEvent(self.CommonHintPanelclose.gameObject, function()
        self:HideCustomPanel(KFCARCameraPanelConfig.CommonHintPanel)
      end)
    end
  end
  PanelconifgPanel.gameObject:SetActive(true)
  local tmp = {}
  tmp.panel = PanelconifgPanel
  tmp.panelData = PanelData
  tmp.panelFunc = btnfunc
  table.insert(self.QueueTable, tmp)
end
function KFCARCameraPanel:HideCustomPanel(PanelconifgPanel)
  if self.hasExit then
    return
  end
  if PanelconifgPanel == KFCARCameraPanelConfig.YouHaveNotArrived then
    PanelconifgPanel.gameObject:SetActive(false)
    return
  end
  PanelconifgPanel.gameObject:SetActive(false)
  self.QueueTable = self.QueueTable or {}
  if #self.QueueTable > 1 then
    local tmp = self.QueueTable[#self.QueueTable - 1]
    tmp.panel.gameObject:SetActive(true)
    if tmp.panel == KFCARCameraPanelConfig.TakePhotoPanel then
      helplog("HideCustomPanel Take show")
      self:ShowNPC()
    end
    if tmp.panel == KFCARCameraPanelConfig.CommonHintPanel then
      if tmp.panelData and tmp.panelData.text then
        self.CommonHintPanelTitle_UILabel.text = tmp.panelData.text
      end
      if tmp.panelFunc ~= nil then
        self:AddClickEvent(self.CommonHintPanelclose.gameObject, function()
          helplog("CommonHintPanelclose")
          tmp.panelFunc()
        end)
      else
        self:AddClickEvent(self.CommonHintPanelclose.gameObject, function()
          self:HideCustomPanel(KFCARCameraPanelConfig.CommonHintPanel)
        end)
      end
    else
    end
  else
  end
  if PanelconifgPanel == KFCARCameraPanelConfig.TakePhotoPanel then
    self.role:SetPosition(Vector3(0, -9999999, -999999))
    self.assetEffect:ResetLocalPositionXYZ(0, -9999999, -9999999)
  end
  if #self.QueueTable > 0 then
    table.remove(self.QueueTable, #self.QueueTable)
  end
end
function KFCARCameraPanel:initView()
  self.CloseButton = self:FindGO("CloseButton")
  self.CommonHintPanel = self:FindGO("CommonHintPanel")
  self.CommonHintPanelclose = self:FindGO("close", self.CommonHintPanel)
  self.CommonHintPanelTitle = self:FindGO("Title", self.CommonHintPanel)
  self.CommonHintPanelTitle_UILabel = self.CommonHintPanelTitle:GetComponent(UILabel)
  self.CameraTex = self:FindGO("CameraTex")
  self.CameraTex.gameObject:SetActive(true)
  self.CameraTexUITexture = self.CameraTex:GetComponent(UITexture)
  self.CommonHintPanel.gameObject:SetActive(false)
  PictureManager.ReFitFullScreen(self.CameraTexUITexture, 1)
  self.TakePhotoPanel = self:FindGO("TakePhotoPanel")
  self.TakePhotoPanel.gameObject:SetActive(true)
  self.TakePhotoPanelFindBtn = self:FindGO("FindBtn", self.TakePhotoPanel)
  self.TakePhotoPanel = self:FindGO("TakePhotoPanel")
  self.TakePhotoPanelModelTexture = self:FindGO("ModelTexture", self.TakePhotoPanel)
  self.TakePhotoPanelModelTexture_UITexture = self.TakePhotoPanelModelTexture:GetComponent(UITexture)
  self.TakePhotoPanelTeXiao = self:FindGO("TeXiao", self.TakePhotoPanel)
  self.role = Asset_RoleUtility.CreateNpcRole(890003)
  self.role:SetName("@@@@@")
  local tempRot = LuaQuaternion()
  local tempV3 = LuaVector3()
  tempV3:Set(0, 180, 0)
  tempRot.eulerAngles = tempV3
  self.role:SetRotation(tempRot)
  self.role:SetScale(0.8)
  self.role:PlayAction_AttackIdle()
  self.role:SetLayer(RO.Config.Layer.UI.Value)
  self.role:SetParent(self.gameObject.transform)
  self.role:SetScale(360)
  local effectPath = EffectMap.Maps.Chicken_induction
  self.assetEffect = Asset_Effect.PlayOn(effectPath, self.TakePhotoPanelTeXiao.gameObject.transform)
  self.assetEffect:ResetLocalPositionXYZ(0, 0, 0)
  self:HideNPC()
  self.TakePhotoPanelTeXiao:AddComponent(ChangeRqByTex)
  self.TakePhotoPaneltakePicBtn = self:FindGO("takePicBtn", self.TakePhotoPanel)
  self.SignUpPanel = self:FindGO("SignUpPanel")
  self.SignUpPanel.gameObject:SetActive(false)
  self.SignUpPanelCloseBtn = self:FindGO("CloseBtn", self.SignUpPanel)
  self.SignUpPanelSignUpBtn = self:FindGO("SignUpBtn", self.SignUpPanel)
  self.QRCodePanel = self:FindGO("QRCodePanel")
  self.QRCodePanel.gameObject:SetActive(false)
  self.QRCodePanelCloseBtn = self:FindGO("CloseBtn", self.QRCodePanel)
  self.SignUpPanelNumberInput = self:FindGO("NumberInput", self.SignUpPanel)
  self.SignUpPanelCodeInput = self:FindGO("CodeInput", self.SignUpPanel)
  self.SignUpPanelNumberInput_UIInput = self.SignUpPanelNumberInput:GetComponent(UIInput)
  self.SignUpPanelCodeInput_UIInput = self.SignUpPanelCodeInput:GetComponent(UIInput)
  self.SignUpPanelGetCode = self:FindGO("GetCode", self.SignUpPanel)
  self.TakePhotoPanelPortraitCell = self:FindGO("PortraitCell", self.TakePhotoPanel)
  self.PhotographResultPanel = self:FindGO("PhotographResultPanel")
  self.PhotographResultPanelphoto = self:FindGO("photo", self.PhotographResultPanel)
  self.PhotographResultPanelphoto_UITexture = self.PhotographResultPanelphoto:GetComponent(UITexture)
  self.PhotographResultPanel.gameObject:SetActive(false)
  self.PhotographResultPanelAnchor_Btn = self:FindGO("Anchor_Btn", self.PhotographResultPanel)
  self.PhotographResultPanelAnchor_BtnbtnTable = self:FindGO("btnTable", self.PhotographResultPanelAnchor_Btn)
  self.PhotographResultPanelAnchor_BtnbtnTableWeiBoBtn = self:FindGO("WeiBoBtn", self.PhotographResultPanelAnchor_BtnbtnTable)
  self.PhotographResultPanelAnchor_BtnbtnTableQQBtn = self:FindGO("QQBtn", self.PhotographResultPanelAnchor_BtnbtnTable)
  self.PhotographResultPanelAnchor_BtnbtnTableWeChatBtn = self:FindGO("WeChatBtn", self.PhotographResultPanelAnchor_BtnbtnTable)
  self.PhotographResultPanelAnchor_BtnbtnTableconfirmBtn = self:FindGO("confirmBtn", self.PhotographResultPanelAnchor_BtnbtnTable)
  self.PhotographResultPanelAnchor_leftUp = self:FindGO("Anchor_leftUp", self.PhotographResultPanel)
  self.PhotographResultPanelAnchor_leftUpCloseButton = self:FindGO("CloseButton", self.PhotographResultPanelAnchor_leftUp)
  self.YouHaveNotArrived = self:FindGO("YouHaveNotArrived")
  self.BottomText = self:FindGO("BottomText", self.YouHaveNotArrived)
  self.BottomText_UILabel = self.BottomText:GetComponent(UILabel)
  self.BottomText_UILabel.text = "\230\156\170\229\136\176\232\190\190\230\140\135\229\174\154\229\174\154\228\189\141\229\140\186\229\159\159"
  self.Location = self:FindGO("Location")
  self.ShangJiaPanel = self:FindGO("ShangJiaPanel")
  self.ShangJiaPanel.gameObject:SetActive(false)
  self.ShangJiaPanelBG = self:FindGO("BG", self.ShangJiaPanel)
  self.ShangJiaPanelBGScroll = self:FindGO("Scroll", self.ShangJiaPanelBG)
  self.ShangJiaPanelBGScrollGrid = self:FindGO("Grid", self.ShangJiaPanelBGScroll)
  self.ShangJiaPanelBGScrollGrid_UIGrid = self.ShangJiaPanelBGScrollGrid:GetComponent(UIGrid)
  self.ShangJiaGrid = UIGridListCtrl.new(self.ShangJiaPanelBGScrollGrid_UIGrid, ShangJiaCell, "ShangJiaCell")
  self.TakePhotoPanelQR = self:FindGO("QR", self.TakePhotoPanel)
  self.TakePhotoPanelQR.gameObject:SetActive(false)
  local ShangJiaTable = Table_KfcAcitivityShore
  if ShangJiaTable then
    self.ShangJiaGrid:ResetDatas(ShangJiaTable)
  end
  self.ShangJiaPanelBGCloseBtn = self:FindGO("CloseBtn")
  self:AddClickEvent(self.PhotographResultPanelAnchor_BtnbtnTableconfirmBtn.gameObject, function()
    self:SavePic(self.PhotographResultPanelphoto_UITexture.mainTexture, "KFC\231\133\167\231\137\135")
  end)
  self:AddClickEvent(self.ShangJiaPanelBGCloseBtn.gameObject, function()
    self:HideCustomPanel(KFCARCameraPanelConfig.ShangJiaPanel)
  end)
  self:AddClickEvent(self.Location.gameObject, function()
    self:ShowCustomPanel(KFCARCameraPanelConfig.ShangJiaPanel)
  end)
  self:AddClickEvent(self.TakePhotoPaneltakePicBtn.gameObject, function()
    self:PreTakePic()
    self:takePic()
    self.PhotographResultPanelAnchor_leftUpCloseButton.gameObject:SetActive(true)
    AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.Picture))
  end)
  self:AddClickEvent(self.PhotographResultPanelAnchor_leftUpCloseButton.gameObject, function()
    self.TakePhotoPaneltakePicBtn.gameObject:SetActive(true)
    self.TakePhotoPanelPortraitCell.gameObject:SetActive(true)
    self.TakePhotoPanelFindBtn.gameObject:SetActive(true)
    self.CloseButton.gameObject:SetActive(true)
    self.Location.gameObject:SetActive(true)
    self.TakePhotoPanelQR.gameObject:SetActive(false)
    self:HideCustomPanel(KFCARCameraPanelConfig.PhotographResultPanel)
  end)
  self:AddClickEvent(self.CloseButton.gameObject, function()
    self:CloseSelf()
    if KFCARCameraProxy.Instance:CheckDateValid("2018-11-23 11:00:00", "2018-11-23 12:00:00") then
      helplog("in it")
    else
      helplog("not in it")
    end
    local d = KFCARCameraProxy.Instance:GetDistance(31.281, 121.437, 39.9, 116.4)
  end)
  self:AddClickEvent(self.CommonHintPanelclose.gameObject, function()
    self:HideCustomPanel(KFCARCameraPanelConfig.CommonHintPanel)
  end)
  self:AddClickEvent(self.TakePhotoPanelFindBtn.gameObject, function()
    ServiceNUserProxy.Instance:CallKFCEnrollQueryUserCmd()
  end)
  self:AddClickEvent(self.SignUpPanelCloseBtn.gameObject, function()
    self:HideCustomPanel(KFCARCameraPanelConfig.SignUpPanel)
  end)
  self:AddClickEvent(self.QRCodePanelCloseBtn.gameObject, function()
    self:HideCustomPanel(KFCARCameraPanelConfig.QRCodePanel)
    self:HideCustomPanel(KFCARCameraPanelConfig.SignUpPanel)
    self:ShowCustomPanel(KFCARCameraPanelConfig.TakePhotoPanel)
  end)
  self:AddClickEvent(self.SignUpPanelSignUpBtn.gameObject, function()
    if not KFCARCameraProxy:CheckPhone(self.SignUpPanelNumberInput_UIInput.value) then
      MsgManager.FloatMsg(nil, "\230\137\139\230\156\186\229\143\183\231\160\129\230\160\188\229\188\143\228\184\141\229\175\185")
      return
    end
    if self:StringIsNullOrEmpty(self.SignUpPanelCodeInput_UIInput.value) then
      MsgManager.FloatMsg(nil, "\233\170\140\232\175\129\231\160\129\228\184\186\231\169\186\228\184\186\231\169\186")
      return
    end
    helplog("\233\131\189\229\175\185\228\186\134 \229\143\145\231\187\153\230\156\141\229\138\161\229\153\168  \230\156\141\229\138\161\229\153\168\232\191\148\229\155\158\229\144\142\230\152\190\231\164\186\228\186\140\231\187\180\231\160\129\231\149\140\233\157\162")
    if self.currentKFCStore ~= nil then
      ServiceNUserProxy.Instance:CallKFCEnrollCodeUserCmd(tonumber(self.SignUpPanelCodeInput_UIInput.value), self.currentKFCStore.name)
    else
      if KFCARCameraProxy.Instance:SelfTest() then
        ServiceNUserProxy.Instance:CallKFCEnrollCodeUserCmd(tonumber(self.SignUpPanelCodeInput_UIInput.value), "Debug")
      end
      helplog("\229\189\147\229\137\141\230\178\161\229\136\176\229\186\151\233\135\140")
    end
  end)
  self:AddClickEvent(self.SignUpPanelGetCode.gameObject, function()
    if not KFCARCameraProxy:CheckPhone(self.SignUpPanelNumberInput_UIInput.value) then
      MsgManager.FloatMsg(nil, "\230\137\139\230\156\186\229\143\183\231\160\129\230\160\188\229\188\143\228\184\141\229\175\185")
      return
    end
    helplog("self.SignUpPanelNumberInput_UIInput.value" .. self.SignUpPanelNumberInput_UIInput.value)
    ServiceNUserProxy.Instance:CallKFCEnrollUserCmd(self.SignUpPanelNumberInput_UIInput.value)
  end)
  self:InitHead()
  self:InitShare()
  self:AddListenEvt(ServiceEvent.NUserKFCHasEnrolledUserCmd, self.RecvKFCHasEnrolledUserCmd)
  self:AddListenEvt(ServiceEvent.NUserKFCEnrollReplyUserCmd, self.RecvKFCEnrollReplyUserCmd)
  self:AddListenEvt(ServiceEvent.NUserKFCEnrollUserCmd, self.RecvKFCEnrollUserCmd)
  self:AddListenEvt(ServiceEvent.NUserKFCEnrollCodeUserCmd, self.RecvKFCEnrollCodeUserCmd)
  self:AddListenEvt(ServiceEvent.NUserKFCShareUserCmd, self.RecvKFCShareUserCmd)
end
function KFCARCameraPanel:InitShare()
  self.QRCodePanelWeiBoBtn = self:FindGO("WeiBoBtn", self.QRCodePanel)
  self.QRCodePanelQQBtn = self:FindGO("QQBtn", self.QRCodePanel)
  self.QRCodePanelWeChatBtn = self:FindGO("WeChatBtn", self.QRCodePanel)
  self.QRCodePanelconfirmBtn = self:FindGO("confirmBtn", self.QRCodePanel)
  self.QRCodePanelBG = self:FindGO("BG", self.QRCodePanel)
  self.QRCodePanelBG_UITexture = self.QRCodePanelBG:GetComponent(UITexture)
  self:AddClickEvent(self.QRCodePanelWeiBoBtn.gameObject, function()
    self:ShareAndReward(1, "", "", E_PlatformType.Sina, self.QRCodePanelBG_UITexture.mainTexture)
  end)
  self:AddClickEvent(self.QRCodePanelQQBtn.gameObject, function()
    self:ShareAndReward(1, "", "", E_PlatformType.QQ, self.QRCodePanelBG_UITexture.mainTexture)
  end)
  self:AddClickEvent(self.QRCodePanelWeChatBtn.gameObject, function()
    self:ShareAndReward(1, "", "", E_PlatformType.WechatMoments, self.QRCodePanelBG_UITexture.mainTexture)
  end)
  self:AddClickEvent(self.PhotographResultPanelAnchor_BtnbtnTableWeiBoBtn.gameObject, function()
    self:ShareAndReward(1, "", "", E_PlatformType.Sina, self.PhotographResultPanelphoto_UITexture.mainTexture)
  end)
  self:AddClickEvent(self.PhotographResultPanelAnchor_BtnbtnTableQQBtn.gameObject, function()
    self:ShareAndReward(1, "", "", E_PlatformType.QQ, self.PhotographResultPanelphoto_UITexture.mainTexture)
  end)
  self:AddClickEvent(self.PhotographResultPanelAnchor_BtnbtnTableWeChatBtn.gameObject, function()
    self:ShareAndReward(1, "", "", E_PlatformType.WechatMoments, self.PhotographResultPanelphoto_UITexture.mainTexture)
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
function KFCARCameraPanel:ShareAndReward(sharetype, content_title, content_body, platform_type, texture)
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
function KFCARCameraPanel:RecvKFCEnrollCodeUserCmd(data)
  helplog("----------------RecvKFCEnrollCodeUserCmd")
  self.QRCodePanel.gameObject:SetActive(true)
end
function KFCARCameraPanel:RecvKFCHasEnrolledUserCmd(data)
  helplog("--------------------function KFCARCameraPanel:RecvKFCHasEnrolledUserCmd(data)--------------------------")
  local hasenrolled = data.body.hasenrolled
  if hasenrolled then
    helplog("hasenrolled")
    MsgManager.ShowMsgByID(28015)
  else
    helplog("not hasenrolled")
    self:ShowCustomPanel(KFCARCameraPanelConfig.SignUpPanel)
  end
  if KFCARCameraProxy.Instance:SelfTest() then
    self:ShowCustomPanel(KFCARCameraPanelConfig.SignUpPanel)
  end
end
function KFCARCameraPanel:RecvKFCEnrollUserCmd(data)
  helplog("123function KFCARCameraPanel:RecvKFCEnrollUserCmd(data)\232\139\165\229\144\166,\229\136\153\231\187\153\230\137\139\230\156\186\229\143\145\233\128\129\233\170\140\232\175\129\231\160\129,\229\185\182\232\174\176\229\189\149\230\151\182\233\151\180,1\229\136\134\233\146\159\230\137\141\229\143\175\229\134\141\230\172\161\229\143\145\233\128\129,30\229\136\134\233\146\159\229\144\142\232\191\135\230\156\159.")
  TableUtil.Print(data.body)
end
function KFCARCameraPanel:RecvKFCEnrollReplyUserCmd(data)
  helplog("----KFCARCameraPanel:RecvKFCEnrollReplyUserCmd(data)data.body.result" .. data.body.result)
  if KFCARCameraProxy.Instance:SelfTest() then
    self:ShowCustomPanel(KFCARCameraPanelConfig.QRCodePanel)
    return
  end
  if data.body.result == 0 then
    self:ShowCustomPanel(KFCARCameraPanelConfig.QRCodePanel)
  elseif data.body.result == 1 then
    MsgManager.FloatMsg(nil, "\232\167\146\232\137\178charid\229\183\178\229\173\152\229\156\168")
  elseif data.body.result == 2 then
    MsgManager.FloatMsg(nil, "\230\137\139\230\156\186\229\143\183\229\183\178\229\173\152\229\156\168")
  elseif data.body.result == 3 then
    MsgManager.FloatMsg(nil, "\233\170\140\232\175\129\231\160\129\228\184\141\229\175\185")
  elseif data.body.result == 4 then
    MsgManager.FloatMsg(nil, "\232\190\147\229\133\165\228\191\161\230\129\175\230\156\137\232\175\175")
  elseif data.body.result == 5 then
    MsgManager.FloatMsg(nil, "\229\143\145\233\170\140\232\175\129\231\160\129\233\162\145\231\142\135\232\191\135\229\191\171")
  elseif data.body.result == 6 then
    MsgManager.FloatMsg(nil, "\229\143\145\231\148\159\233\148\153\232\175\175")
  else
    MsgManager.FloatMsg(nil, "\230\156\170\231\159\165\233\148\153\232\175\175")
  end
end
function KFCARCameraPanel:takePic()
  self:PreTakePic()
  local c = coroutine.create(function()
    local w = Screen.width
    local h = Screen.height
    Yield(WaitForEndOfFrame())
    local rect = Rect(0, 0, w, h)
    local screenShot = Texture2D(rect.width, rect.height, TextureFormat.RGB24, false)
    screenShot:ReadPixels(rect, 0, 0, true)
    screenShot:Apply()
    local bytes = ImageConversion.EncodeToPNG(screenShot)
    local localPath = "666.png"
    FileDirectoryHandler.WriteFile(localPath, bytes, function(x)
      self:ShowCustomPanel(KFCARCameraPanelConfig.PhotographResultPanel)
      self.PhotographResultPanelphoto_UITexture.mainTexture = screenShot
    end)
  end)
  coroutine.resume(c)
end
function KFCARCameraPanel:PreTakePic()
  self.TakePhotoPaneltakePicBtn.gameObject:SetActive(false)
  self.TakePhotoPanelPortraitCell.gameObject:SetActive(false)
  self.TakePhotoPanelFindBtn.gameObject:SetActive(false)
  self:HideCustomPanel(KFCARCameraPanelConfig.YouHaveNotArrived)
  self.CloseButton.gameObject:SetActive(false)
  self.Location.gameObject:SetActive(false)
  self.TakePhotoPanelQR.gameObject:SetActive(true)
  ResourceManager.Instance:GC()
  MyLuaSrv.Instance:LuaManualGC()
end
function KFCARCameraPanel:StringIsNullOrEmpty(text)
  if text == nil or text == "" then
    return true
  else
    return false
  end
end
function KFCARCameraPanel:InitHead()
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
function KFCARCameraPanel:OnEnter()
  helplog("@KFCARCameraPanel:OnEnter()")
  self.hasExit = false
  self:InitCameraCor()
  self:CheckGPS()
  FunctionBGMCmd.Me():PlayUIBgm("InBattle", 0)
end
function KFCARCameraPanel:OnExit()
  self.QueueTable = {}
  TimeTickManager.Me():ClearTick(self)
  if self.role then
    self.role:Destroy()
    self.role = nil
  end
  if self.assetEffect then
    self.assetEffect:Destroy()
    self.assetEffect = nil
  end
  self.hasExit = true
  FunctionBGMCmd.Me():StopUIBgm()
  Input.location:Stop()
end
function KFCARCameraPanel:CheckGPS()
  self.c1 = coroutine.create(function()
    if self.hasExit then
      return
    end
    while true do
      if self.hasExit then
        return
      end
      if KFCARCameraProxy.Instance:CheckGPSisEnabledByUser() or KFCARCameraProxy.Instance:SelfTest() then
      else
        KFCARCameraProxy.Instance:ShowGPSMsg()
        Input.location:Stop()
        return
      end
      if KFCARCameraProxy.Instance:CheckGPSLocationServiceStatus() or KFCARCameraProxy.Instance:SelfTest() then
      else
        KFCARCameraProxy.Instance:ShowGPSMsg()
        Input.location:Stop()
        return
      end
      helplog("\232\142\183\229\143\150GPS \230\136\144\229\138\159")
      helplog("N:" .. Input.location.lastData.latitude)
      helplog("E:" .. Input.location.lastData.longitude)
      local tableDian = Table_KfcAcitivityShore
      if tableDian then
        for k, v in pairs(tableDian) do
          local zuobiao = v.arLbsCoordinate
          helplog("zuobiao[1]:" .. zuobiao[1] .. "\tzuobiao[2]:" .. zuobiao[2])
          local radius = v.radius
          if radius >= KFCARCameraProxy.Instance:GetDistance(zuobiao[1], zuobiao[2], Input.location.lastData.latitude, Input.location.lastData.longitude) then
            helplog("\230\137\190\229\136\176\228\186\134")
            self:HideCustomPanel(KFCARCameraPanelConfig.YouHaveNotArrived)
            self.currentKFCStore = v
            Input.location:Stop()
            Yield(WaitForSeconds(3))
            self:ShowCustomPanel(KFCARCameraPanelConfig.TakePhotoPanel)
            return
          end
        end
      end
      helplog("\228\189\160\230\178\161\229\136\176")
      self:ShowCustomPanel(KFCARCameraPanelConfig.YouHaveNotArrived)
      if KFCARCameraProxy.Instance:SelfTest() then
        helplog("@1 TakePhotoPanel")
        self:HideCustomPanel(KFCARCameraPanelConfig.YouHaveNotArrived)
        Yield(WaitForSeconds(3))
        self:ShowCustomPanel(KFCARCameraPanelConfig.TakePhotoPanel)
        Input.location:Stop()
        return
      else
        self:HideCustomPanel(KFCARCameraPanelConfig.TakePhotoPanel)
      end
      Yield(WaitForSeconds(1))
    end
  end)
  coroutine.resume(self.c1)
end
function KFCARCameraPanel:RecvKFCShareUserCmd(data)
  helplog("function KFCARCameraPanel:RecvKFCShareUserCmd(data)")
end
function KFCARCameraPanel:InitCameraCor()
  self.c2 = coroutine.create(function()
    Yield(Application.RequestUserAuthorization(UserAuthorization.WebCam))
    if Application.HasUserAuthorization(UserAuthorization.WebCam) then
      local devices = UnityEngine.WebCamTexture.devices
      if devices == nil then
        KFCARCameraProxy:ShowCameraMsg()
        return
      end
      helplog("#devices" .. #devices)
      if #devices == 0 then
        KFCARCameraProxy.Instance:ShowCameraMsg()
        return
      else
        local DeviceName = devices[1].name
        local CameraSizeX = 100
        local CameraSizeY = 100
        local CameraFPS = 60
        self.webCamera = UnityEngine.WebCamTexture(DeviceName, Screen.width, Screen.height, CameraFPS)
        self.CameraTexUITexture.mainTexture = self.webCamera
        self:PlayCamera()
        return
      end
    else
      KFCARCameraProxy.Instance:ShowCameraMsg()
      return
    end
  end)
  coroutine.resume(self.c2)
end
function KFCARCameraPanel:PlayCamera()
  if self.webCamera then
    self.webCamera:Play()
  end
  self.c3 = coroutine.create(function()
    while true do
      if self.hasExit then
        return
      end
      if self.webCamera then
        if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer and self.webCamera.videoRotationAngle then
          if self.webCamera.videoRotationAngle == 180 then
            tempV3_1:Set(0, 0, 0)
            tempRot.eulerAngles = tempV3_1
            self.CameraTex.gameObject.transform.localRotation = tempRot
          else
            tempV3_1:Set(0, 0, 180)
            tempRot.eulerAngles = tempV3_1
            self.CameraTex.gameObject.transform.localRotation = tempRot
          end
        end
        if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android and self.webCamera.videoRotationAngle then
          if self.webCamera.videoRotationAngle == 180 then
            tempV3_1:Set(0, 0, 180)
            tempRot.eulerAngles = tempV3_1
            self.CameraTex.gameObject.transform.localRotation = tempRot
          else
            tempV3_1:Set(0, 0, 0)
            tempRot.eulerAngles = tempV3_1
            self.CameraTex.gameObject.transform.localRotation = tempRot
          end
        end
      end
      Yield(WaitForSeconds(1))
    end
  end)
  coroutine.resume(self.c3)
end
function KFCARCameraPanel:StopCamera()
  if self.webCamera then
    self.webCamera:Stop()
  end
end
function KFCARCameraPanel:SavePic(texture, name)
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
function KFCARCameraPanel:ShowNPC()
  if self.role and self.assetEffect then
    self.role:SetPosition(Vector3(0, -246, 664.5))
    self.assetEffect:ResetLocalPositionXYZ(0, 0, 0)
    self:NPCDance()
  end
end
function KFCARCameraPanel:HideNPC()
  if self.role and self.assetEffect then
    self.role:SetPosition(Vector3(99999, 99999, 999999))
    self.assetEffect:ResetLocalPositionXYZ(99999, 99999, 999999)
    self:NPCDance()
  end
end
