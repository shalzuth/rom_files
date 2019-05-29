ScenerytDetailPanel = class("ScenerytDetailPanel", ContainerView)
ScenerytDetailPanel.ViewType = UIViewType.PopUpLayer
autoImport("PermissionUtil")
function ScenerytDetailPanel:Init()
  self:initView()
  self:initData()
  self:AddEventListener()
  self:AddViewEvts()
end
function ScenerytDetailPanel:AddViewEvts()
  self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadCompleteCallback, self.photoCompleteCallback)
  self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadProgressCallback, self.photoProgressCallback)
end
function ScenerytDetailPanel:photoCompleteCallback(note)
  local data = note.body
  if self.index == data.index then
    self:completeCallback(data.byte)
  end
end
function ScenerytDetailPanel:photoProgressCallback(note)
  local data = note.body
  if self.index == data.index then
    self:progressCallback(data.progress)
  end
end
function ScenerytDetailPanel:initData()
  self.scenicSpotData = self.viewdata.scenicSpotData
  self.PhotoData = PhotoData.new(self.scenicSpotData, PhotoDataProxy.PhotoType.SceneryPhotoType)
  self.index = self.scenicSpotData.staticId
  self.adventureValue.text = self.scenicSpotData:getAdventureValue()
  local icon = self:FindGO("icon"):GetComponent(UISprite)
  self.canbeShare = false
  local bg = self:FindGO("background"):GetComponent(UISprite)
  self:initDefaultTextureSize()
  LeanTween.cancel(self.gameObject)
  LeanTween.delayedCall(self.gameObject, 0.1, function()
    self:getPhoto()
  end)
end
function ScenerytDetailPanel:initView()
  self.photo = self:FindGO("photo"):GetComponent(UITexture)
  self.adventureValue = self:FindGO("adventureValue"):GetComponent(UILabel)
  self.noneTxIcon = self:FindGO("noneTxIcon"):GetComponent(UISprite)
  self.progress = self:FindGO("loadProgress"):GetComponent(UILabel)
  self:Hide(self.progress.gameObject)
  self.confirmBtn = self:FindGO("confirmBtn")
  self.shareBtn = self:FindGO("shareBtn")
  self.closeShare = self:FindGO("closeShare")
  self:AddClickEvent(self.closeShare, function()
    self:Hide(self.goUIViewSocialShare)
  end)
  self:AddClickEvent(self.shareBtn, function()
    self:Show(self.goUIViewSocialShare)
  end)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:ROOShare()
end
function ScenerytDetailPanel:ROOShare()
  local sp = self.goButtonQQ:GetComponent(UISprite)
  sp.spriteName = "Facebook"
  sp = self.goButtonWechat:GetComponent(UISprite)
  sp.spriteName = "Twitter"
  sp = self.goButtonWechatMoments:GetComponent(UISprite)
  sp.spriteName = "line"
  GameObject.Destroy(self.goButtonSina)
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:sharePicture("line", "", "")
  end)
  self:AddClickEvent(self.goButtonWechat, function()
    self:sharePicture("twitter", OverseaHostHelper.TWITTER_MSG, "")
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:sharePicture("fb", "", "")
  end)
  local lbl = self:FindGO("Label", self.goButtonWechatMoments):GetComponent(UILabel)
  lbl.text = "LINE"
  lbl = self:FindGO("Label", self.goButtonWechat):GetComponent(UILabel)
  lbl.text = "Twitter"
  lbl = self:FindGO("Label", self.goButtonQQ):GetComponent(UILabel)
  lbl.text = "Facebook"
end
function ScenerytDetailPanel:initDefaultTextureSize()
  self.originWith = self.photo.width
  self.originHeight = self.photo.height
end
function ScenerytDetailPanel:setTexture(texture)
  local orginRatio = self.originWith / self.originHeight
  local textureRatio = texture.width / texture.height
  local wRatio = math.min(orginRatio, textureRatio) == orginRatio
  local height = self.originHeight
  local width = self.originWith
  if wRatio then
    height = self.originWith / textureRatio
  else
    width = self.originHeight * textureRatio
  end
  Object.DestroyImmediate(self.photo.mainTexture)
  self.photo.width = width
  self.photo.height = height
  self.photo.mainTexture = texture
  self.texture = texture
end
function ScenerytDetailPanel:AddEventListener()
  self:AddClickEvent(self.confirmBtn, function(go)
    if self.texture then
      local result = PermissionUtil.Access_SavePicToMediaStorage()
      if result then
        local picName = "RO_" .. tostring(os.time())
        local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
        ScreenShot.SaveJPG(self.texture, path, 100)
        ExternalInterfaces.SavePicToDCIM(path .. ".jpg")
        MsgManager.ShowMsgByID(907)
      end
    end
    self:CloseSelf()
  end)
  self:AddButtonEvent("closeBtn", function(go)
    self:CloseSelf()
  end)
end
function ScenerytDetailPanel:getPhoto()
  local tBytes = ScenicSpotPhotoNew.Ins():TryGetThumbnailFromLocal_Share(self.index, self.PhotoData.time)
  if tBytes then
    self:completeCallback(tBytes, true)
  end
  MySceneryPictureManager.Instance():tryGetMySceneryOriginImage(self.PhotoData.roleId, self.index, self.PhotoData.time)
end
function ScenerytDetailPanel:sharePicture(platform_type, content_title, content_body)
  if self.canbeShare then
    do
      local path = ScenicSpotPhotoNew.Ins():GetLocalAbsolutePath_Share(self.index, true)
      self:Log("sharePicture pic path:", path)
      if path then
        local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
        if platform_type ~= "fb" then
          xdlog("startSharePicture", platform_type .. "\229\136\134\228\186\171")
          Debug.Log("\229\136\134\228\186\171")
          Debug.Log(content_title)
          Debug.Log(OverseaHostHelper.Share_URL)
          Debug.Log(content_body)
          overseasManager:ShareImgWithChannel(path, content_title, OverseaHostHelper.Share_URL, content_body, platform_type, function(msg)
            redlog("msg" .. msg)
            ROFileUtils.FileDelete(path)
            if msg == "1" then
              Debug.Log("success")
            else
              MsgManager.FloatMsgTableParam(nil, ZhString.LineNotInstalled)
            end
          end)
          return true
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
        do return true end
        SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
          self:Log("SocialShare.Instance:Share success")
          if platform_type == E_PlatformType.Sina then
            MsgManager.ShowMsgByIDTable(566)
          end
        end, function(failCode, failMsg)
          self:Log("SocialShare.Instance:Share failure")
          local errorMessage = failMsg or "error"
          if failCode ~= nil then
            errorMessage = failCode .. ", " .. errorMessage
          end
          MsgManager.ShowMsg("", errorMessage, MsgManager.MsgType.Float)
        end, function()
          self:Log("SocialShare.Instance:Share cancel")
        end)
      else
        MsgManager.FloatMsg(nil, ZhString.ShareAwardView_EmptyPath)
      end
      return true
    end
  else
  end
  return false
end
function ScenerytDetailPanel:progressCallback(progress)
  self:Show(self.progress.gameObject)
  if progress >= 1 then
    progress = 1 or progress
  end
  local value = progress * 100
  value = math.floor(value)
  self.progress.text = value .. "%"
end
function ScenerytDetailPanel:completeCallback(bytes, thumbnail)
  if not thumbnail then
    self:Hide(self.progress.gameObject)
  end
  self.isThumbnail = thumbnail
  if bytes then
    local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
    local bRet = ImageConversion.LoadImage(texture, bytes)
    if bRet then
      self.canbeShare = not thumbnail
      self:setTexture(texture)
    else
      Object.DestroyImmediate(texture)
    end
  end
end
function ScenerytDetailPanel:OnExit()
  LeanTween.cancel(self.gameObject)
  Object.DestroyImmediate(self.photo.mainTexture)
end
function ScenerytDetailPanel:GetGameObjects()
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("WechatMoments", self.goUIViewSocialShare)
  self.goButtonWechat = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  local enable = FloatAwardView.ShareFunctionIsOpen()
  if not enable then
    self:Hide(self.shareBtn)
  end
end
function ScenerytDetailPanel:RegisterButtonClickEvent()
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:OnClickForButtonWechatMoments()
  end)
  self:AddClickEvent(self.goButtonWechat, function()
    self:OnClickForButtonWechat()
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:OnClickForButtonQQ()
  end)
  self:AddClickEvent(self.goButtonSina, function()
    self:OnClickForButtonSina()
  end)
end
function ScenerytDetailPanel:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    local result = self:sharePicture(E_PlatformType.WechatMoments, "", "")
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function ScenerytDetailPanel:OnClickForButtonWechat()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
    local result = self:sharePicture(E_PlatformType.Wechat, "", "")
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function ScenerytDetailPanel:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    local result = self:sharePicture(E_PlatformType.QQ, "", "")
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end
function ScenerytDetailPanel:OnClickForButtonSina()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
    local contentBody = GameConfig.PhotographResultPanel_ShareDescription
    if contentBody == nil or #contentBody <= 0 then
      contentBody = "RO"
    end
    local result = self:sharePicture(E_PlatformType.Sina, "", contentBody)
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(563)
  end
end
