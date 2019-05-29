LotteryGiftView = class("LotteryGiftView", ContainerView)
LotteryGiftView.ViewType = UIViewType.NormalLayer
local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"
function LotteryGiftView:Init()
  self:FindObj()
  self:AddEvt()
  self:AddViewEvt()
  self:InitShow()
end
function LotteryGiftView:FindObj()
  self.content = self:FindGO("Content"):GetComponent(UILabel)
  self.content2 = self:FindGO("Content2"):GetComponent(UILabel)
  self.from = self:FindGO("From"):GetComponent(UILabel)
  self.to = self:FindGO("To"):GetComponent(UILabel)
  self.share = self:FindGO("Share")
  self.effectContainer = self:FindGO("EffectContainer")
  self.btnRoot = self:FindGO("BtnRoot")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
end
function LotteryGiftView:AddEvt()
  local closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(closeButton, function()
    self:CloseView()
  end)
  self:AddClickEvent(self.share, function()
    self:ClickShare()
  end)
end
function LotteryGiftView:AddViewEvt()
  self:AddListenEvt(ShareEvent.ClickPlatform, self.ClickPlatform)
end
function LotteryGiftView:ClickShare()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GeneralShareView
  })
end
function LotteryGiftView:ClickPlatform(note)
  helplog("LotteryGiftView:ClickPlatform,note : ", type(note))
  local data = note.body
  if data then
    helplog("LotteryGiftView:ClickPlatform  data :", data)
    self:SharePicture(data, "", "")
  else
    helplog("LotteryGiftView:ClickPlatform  data is nil ")
  end
end
function LotteryGiftView:InitShow()
  self.isQueue = self.viewdata.viewdata == nil
  local isOpen = StarProxy.Instance:CheckShareOpen()
  self.share:SetActive(isOpen)
  self:UpdateView()
end
function LotteryGiftView:UpdateView()
  local data
  if self.isQueue then
    data = StarProxy.Instance:GetFrontData()
  else
    data = self.viewdata.viewdata
  end
  if data then
    self:SetData(data)
  end
end
function LotteryGiftView:SetData(data)
  if data then
    self.content.text = data.content
    self.content2.text = data.content2
    self.from.text = data.name
    self.to.text = Game.Myself.data.name
  end
end
function LotteryGiftView:SharePicture(platform_type, content_title, content_body)
  helplog("LotteryGiftView SharePicture", platform_type)
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.btnRoot:SetActive(false)
  self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self.btnRoot:SetActive(true)
    local picName = shotName .. tostring(os.time())
    local path = PathUtil.GetSavePath(PathConfig.TempShare) .. "/" .. picName
    ScreenShot.SaveJPG(texture, path, 100)
    path = path .. ".jpg"
    helplog("LotteryGiftView Share path", path)
    local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
    overseasManager:ShareImg(path, content_title, "", content_body, function(msg)
      ROFileUtils.FileDelete(path)
      if msg == "1" then
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
      else
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
      end
    end)
  end, gmCm, ui)
end
function LotteryGiftView:OnEnter()
  self:PlayUIEffect(EffectMap.UI.LotteryCard, self.effectContainer, false)
end
function LotteryGiftView:CloseView()
  local isNext = StarProxy.Instance:ShowNext()
  if isNext then
    self:CloseSelf()
  else
    self:UpdateView()
  end
end
