GeneralShareView = class("GeneralShareView", ContainerView)
GeneralShareView.ViewType = UIViewType.PopUpLayer
function GeneralShareView:Init()
  self:FindObj()
  self:AddEvt()
  self:AddViewEvt()
  self:InitShow()
end
function GeneralShareView:FindObj()
  local qq = self:FindGO("QQ")
  self:AddClickEvent(qq, function()
    self:ClickQQ()
  end)
  local wechat = self:FindGO("Wechat")
  self:AddClickEvent(wechat, function()
    self:ClickWechat()
  end)
  local wechatMoments = self:FindGO("WechatMoments")
  self:AddClickEvent(wechatMoments, function()
    self:ClickWechatMoments()
  end)
  local sina = self:FindGO("Sina")
  self:AddClickEvent(sina, function()
    self:ClickSina()
  end)
  self:ROOShare()
end
function GeneralShareView:ROOShare()
  self.goUIViewSocialShare = self:FindGO("Gridd", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("WechatMoments", self.goUIViewSocialShare)
  self.goButtonWechat = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  local sp = self.goButtonQQ:GetComponent(UISprite)
  sp.spriteName = "Facebook"
  sp = self.goButtonWechat:GetComponent(UISprite)
  sp.spriteName = "Twitter"
  sp = self.goButtonWechatMoments:GetComponent(UISprite)
  sp.spriteName = "line"
  GameObject.Destroy(self.goButtonSina)
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:sendNotification(ShareEvent.ClickPlatform, "line")
  end)
  self:AddClickEvent(self.goButtonWechat, function()
    self:sendNotification(ShareEvent.ClickPlatform, "twitter")
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:sendNotification(ShareEvent.ClickPlatform, "fb")
  end)
  local lbl = self:FindGO("Label", self.goButtonWechatMoments):GetComponent(UILabel)
  lbl.text = "LINE"
  lbl = self:FindGO("Label", self.goButtonWechat):GetComponent(UILabel)
  lbl.text = "Twitter"
  lbl = self:FindGO("Label", self.goButtonQQ):GetComponent(UILabel)
  lbl.text = "Facebook"
end
function GeneralShareView:AddEvt()
end
function GeneralShareView:AddViewEvt()
end
function GeneralShareView:InitShow()
end
function GeneralShareView:ClickQQ()
  local platform = E_PlatformType.QQ
  if SocialShare.Instance:IsClientValid(platform) then
    self:sendNotification(ShareEvent.ClickPlatform, platform)
    self:CloseSelf()
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end
function GeneralShareView:ClickWechat()
  local platform = E_PlatformType.Wechat
  if SocialShare.Instance:IsClientValid(platform) then
    self:sendNotification(ShareEvent.ClickPlatform, platform)
    self:CloseSelf()
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function GeneralShareView:ClickWechatMoments()
  local platform = E_PlatformType.WechatMoments
  if SocialShare.Instance:IsClientValid(platform) then
    self:sendNotification(ShareEvent.ClickPlatform, platform)
    self:CloseSelf()
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function GeneralShareView:ClickSina()
  local platform = E_PlatformType.Sina
  if SocialShare.Instance:IsClientValid(platform) then
    self:sendNotification(ShareEvent.ClickPlatform, platform)
    self:CloseSelf()
  else
    MsgManager.ShowMsgByIDTable(563)
  end
end
