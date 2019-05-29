ShareAwardView = class("ShareAwardView", BaseView)
autoImport("EffectShowDataWraper")
autoImport("PhotographResultPanel")
ShareAwardView.ViewType = UIViewType.ShareLayer
local tempVector3 = LuaVector3.zero
function ShareAwardView:Init()
  self:initView()
  self:initData()
end
function ShareAwardView:initView()
  self.objHolder = self:FindGO("objHolder")
  self.itemName = self:FindComponent("itemName", UILabel)
  self.Title = self:FindComponent("Title", UILabel)
  self.objBgCt = self:FindGO("objBgCt")
  self.refineBg = self:FindGO("refineBg", self.objBgCt)
  self.closeBtn = self:FindGO("CloseButton")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.ShareDescription = self:FindComponent("ShareDescription", UILabel)
  self.SubTitle = self:FindComponent("SubTitle", UILabel)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  local bgTexture = self:FindComponent("bgTexture", UITexture)
end
function ShareAwardView:FormatBufferStr(bufferId)
  local str = ItemUtil.getBufferDescById(bufferId)
  local result = ""
  local bufferStrs = string.split(str, "\n")
  for m = 1, #bufferStrs do
    local buffData = Table_Buffer[bufferId]
    local buffStr = ""
    if buffData then
      buffStr = string.format("{bufficon=%s} ", buffData.BuffIcon)
    end
    result = result .. buffStr .. bufferStrs[m] .. "\n"
  end
  if result ~= "" then
    result = string.sub(result, 1, -2)
  end
  return result
end
function ShareAwardView:setItemProperty(data)
  local label = ""
  if data.itemData.cardInfo then
    local bufferIds = data.itemData.cardInfo.BuffEffect.buff
    for i = 1, #bufferIds do
      local str = ItemUtil.getBufferDescById(bufferIds[i])
      local bufferStrs = string.split(str, "\n")
      for j = 1, #bufferStrs do
        local cardTip = bufferStrs[j]
        label = label .. cardTip .. "\n"
      end
    end
    label = string.sub(label, 1, -2)
    self.ShareDescription.alignment = 0
  elseif data.effectFromType == FloatAwardView.EffectFromType.RefineType then
    label = ZhString.ShareAwardView_RefineProperty .. " : +" .. data.itemData.equipInfo.refinelv .. "\n"
    label = label .. data.itemData.equipInfo:RefineInfo()
    self.ShareDescription.alignment = 0
  elseif data.showType == FloatAwardView.ShowType.ItemType then
    label = ZhString.ItemTip_Desc .. tostring(data.itemData.staticData.Desc)
    self.ShareDescription.alignment = 1
  elseif data.itemData.equipInfo then
    local equipInfo = data.itemData.equipInfo
    local uniqueEffect = equipInfo:GetUniqueEffect()
    if uniqueEffect and #uniqueEffect > 0 then
      local special = {}
      special.label = {}
      for i = 1, #uniqueEffect do
        local id = uniqueEffect[i].id
        label = label .. self:FormatBufferStr(id) .. "\n"
      end
      label = string.sub(label, 1, -2)
    end
    self.ShareDescription.alignment = 0
  end
  if label ~= "" then
    self.ShareDescription.text = label
  else
    self.ShareDescription.text = ""
  end
end
function ShareAwardView:OnEnter()
  self:SetData(self.viewdata.viewdata)
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(false)
  self.bgTexture = self:FindComponent("refineBg", UITexture)
  helplog("onenter 1")
  if self.bgTexture then
    helplog("onenter 2")
    PictureManager.Instance:SetUI("share_meizi", self.bgTexture)
  end
end
function ShareAwardView:SetData(data)
  self.data = data
  self.itemName.text = data.itemData.staticData.NameZh
  if data.effectFromType == FloatAwardView.EffectFromType.RefineType then
    self.Title.text = ZhString.ShareAwardView_RefineSus
    data.showType = FloatAwardView.ShowType.ItemType
    self:Show(self.objBgCt)
    self:Show(self.refineBg)
    self:Show(self.SubTitle)
    self.SubTitle.text = "+" .. data.itemData.equipInfo.refinelv
  elseif data.showType == FloatAwardView.ShowType.CardType then
    self.Title.text = ZhString.ShareAwardView_GetCard
    self:Show(self.objBgCt)
    self:Hide(self.SubTitle.gameObject)
  else
    self.Title.text = ZhString.ShareAwardView_GetItem
    data.showType = FloatAwardView.ShowType.ItemType
    self:Show(self.objBgCt)
    self:Show(self.refineBg)
    self:Hide(self.SubTitle.gameObject)
  end
  local obj = data:getModelObj(self.objHolder)
  if data.showType == FloatAwardView.ShowType.CardType and obj then
    tempVector3:Set(0, 0, 0)
    obj.transform.localPosition = tempVector3
    tempVector3:Set(0.8, 0.8, 0.8)
    obj.transform.localScale = tempVector3
  elseif data.effectFromType == FloatAwardView.EffectFromType.RefineType and obj then
    tempVector3:Set(0, 0, 0)
    obj.transform.localPosition = tempVector3
    tempVector3:Set(1.624, 1.624, 1.624)
    obj.transform.localScale = tempVector3
  elseif data.showType == FloatAwardView.ShowType.ItemType and obj then
    tempVector3:Set(1.624, 1.624, 1.624)
    obj.transform.localScale = tempVector3
  end
  self:setItemProperty(data)
end
function ShareAwardView:GetGameObjects()
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  local sp = self:FindComponent("Sina1", UISprite, self.goButtonSina)
  sp.spriteName = "share_icon_Facebook"
  sp = self:FindComponent("Wechat222", UISprite, self.goButtonWechatMoments)
  sp.spriteName = "share_icon_LINE"
  sp = self:FindComponent("QQ1", UISprite, self.goButtonQQ)
  sp.spriteName = "share_icon_Twitter"
  self.goFBShareBtn = self:FindGO("BG", self.goUIViewSocialShare)
  local bg2ss = self:FindGO("bg2ss", self.goUIViewSocialShare)
  bg2ss:SetActive(false)
end
function ShareAwardView:RegisterButtonClickEvent()
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:sharePicture("line", "", "")
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:sharePicture("twitter", OverseaHostHelper.TWITTER_MSG, "")
  end)
  self:AddClickEvent(self.goButtonSina, function()
    self:sharePicture("fb", "", "")
  end)
  do return end
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:OnClickForButtonWechatMoments()
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:OnClickForButtonQQ()
  end)
  self:AddClickEvent(self.goButtonSina, function()
    self:OnClickForButtonSina()
  end)
end
function ShareAwardView:OnClickForButtonFB()
  self:sharePicture("fb", "", "")
end
function ShareAwardView:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    self:sharePicture(E_PlatformType.WechatMoments, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function ShareAwardView:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    self:sharePicture(E_PlatformType.QQ, "", "")
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end
function ShareAwardView:OnClickForButtonSina()
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
function ShareAwardView:startSharePicture(texture, platform_type, content_title, content_body)
  local picName = PhotographResultPanel.picNameName .. tostring(os.time())
  local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
  ScreenShot.SaveJPG(texture, path, 100)
  path = path .. ".jpg"
  self:Log("ShareAwardView sharePicture pic path:", path)
  local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
  if platform_type ~= "fb" then
    xdlog("startSharePicture", platform_type .. "\229\136\134\228\186\171")
    overseasManager:ShareImgWithChannel(path, content_title, OverseaHostHelper.Share_URL, content_body, platform_type, function(msg)
      redlog("msg" .. msg)
      ROFileUtils.FileDelete(path)
      if msg == "1" then
      else
        MsgManager.FloatMsgTableParam(nil, ZhString.LineNotInstalled)
      end
    end)
    return
  end
  xdlog("startSharePicture", "fb \229\136\134\228\186\171\229\155\190\231\137\135")
  overseasManager:ShareImg(path, content_title, OverseaHostHelper.Share_URL, content_body, function(msg)
    redlog("msg" .. msg)
    ROFileUtils.FileDelete(path)
    if msg == "1" then
      MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
    else
      MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
    end
  end)
end
function ShareAwardView:sharePicture(platform_type, content_title, content_body)
  self:startCaptureScreen(platform_type, content_title, content_body)
end
function ShareAwardView:startCaptureScreen(platform_type, content_title, content_body)
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self:changeUIState(true)
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:changeUIState(false)
    self:startSharePicture(texture, platform_type, content_title, content_body)
  end, ui)
end
function ShareAwardView:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.closeBtn)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.closeBtn)
  end
end
function ShareAwardView:initData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end
function ShareAwardView:OnExit()
  if self.data then
    self.data:Exit()
  end
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(true)
  if self.bgTexture then
    PictureManager.Instance:UnLoadUI("share_meizi", self.bgTexture)
  end
end
