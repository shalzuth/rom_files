SignInTipsView = class("SignInTipsView", BaseView)
SignInTipsView.ViewType = UIViewType.PopUpLayer
SignInTipsView.AnimDuration = 0.6
local proxyIns, picManager
function SignInTipsView:Init()
  proxyIns, picManager = NewServerSignInProxy.Instance, PictureManager.Instance
  self:FindObjs()
  self:InitShow()
  self:AddEvents()
end
function SignInTipsView:FindObjs()
  self.tipPage = self:FindPage("TipPage", "sign_bg")
  self.anotherPage = self:FindPage("AnotherPage", "sign_bg1")
  self.anotherTweenTransform = self.anotherPage.gameObject:GetComponent(TweenTransform)
  self.iconTex = self:FindComponent("TipIcon", UITexture)
  self.jokeTex = self:FindComponent("Joke", UITexture)
  self.jokeLabel = self:FindComponent("JokeLabel", UILabel)
  self.prevButton = self:FindGO("PrevButton")
  self.nextButton = self:FindGO("NextButton")
  self.initialPoint = self:FindGO("InitialPoint").transform
  self.anotherPoint = self:FindGO("AnotherPagePoint").transform
  self.psGo = self:FindGO("TipScrollView")
  self.TipScrollView = self.psGo:GetComponent(UIScrollView)
  self.TipScrollView.panel.baseClipRegion = Vector4(0, 0, 360, 150)
end
function SignInTipsView:InitShow()
  self.day = proxyIns.signedCount + (proxyIns.isTodaySigned and 0 or 1)
  self.anotherTweenTransform:SetOnFinished(function()
    self.anotherTweenTransform.enabled = false
    self:ResetTip()
  end)
end
function SignInTipsView:AddEvents()
  self:AddClickEvent(self.prevButton, function()
    if self.anotherTweenTransform.enabled then
      return
    end
    self.day = self:GetRemainderOfDay(self.day - 1)
    self:TryPlayChangeTipAnim(true)
  end)
  self:AddClickEvent(self.nextButton, function()
    if self.anotherTweenTransform.enabled then
      return
    end
    self.day = self:GetRemainderOfDay(self.day + 1)
    self:TryPlayChangeTipAnim(false)
  end)
  self:AddListenEvt(NewServerSignInEvent.MapViewClose, self.CloseSelf)
end
function SignInTipsView:FindPage(pageName, pageBgTexName)
  local page = {}
  page.gameObject = self:FindGO(pageName)
  page.trans = page.gameObject.transform
  page.bgTex = self:FindComponent("TipBg", UITexture, page.gameObject)
  page.bgTexName = pageBgTexName
  page.titleLabel = self:FindComponent("TipTitle", UILabel, page.gameObject)
  page.bannerTex = self:FindComponent("BannerTex", UITexture, page.gameObject)
  page.bannerTexName = nil
  page.descLabel = self:FindComponent("TipDescLabel", UILabel, page.gameObject)
  return page
end
function SignInTipsView:ResetTip()
  self:UpdateTip(self.tipPage, self.day)
  self.anotherPage.trans.position = self.anotherPoint.position
end
function SignInTipsView:UpdateTip(page, day)
  if not page or not day then
    return
  end
  page.titleLabel.text = ZhString.NewServerSignIn_TipTitle
  local staticData = proxyIns:GetStaticTextDataOfDay(day)
  if not staticData then
    LogUtility.ErrorFormat("Cannot find SignIn data of Day {0}!", self.day)
    return
  end
  page.descLabel.text = string.format(ZhString.NewServerSignIn_TipDesc, staticData.Tips, staticData.Explain)
  local todayStaticData = proxyIns:GetStaticTextDataOfDay(self.day)
  self.jokeLabel.text = todayStaticData and todayStaticData.Joke or ""
  if page.bannerTexName ~= staticData.ShopID then
    self:TryUnloadBannerTexOfPage(page)
    page.bannerTexName = staticData.ShopID
    picManager:SetSignIn(page.bannerTexName, page.bannerTex)
  end
end
function SignInTipsView:TryPlayChangeTipAnim(isPrev)
  if isPrev then
    self:UpdateTip(self.anotherPage, self.day)
  else
    self:UpdateTip(self.anotherPage, self.day - 1)
    self:UpdateTip(self.tipPage, self.day)
  end
  local from = isPrev and self.anotherPoint or self.initialPoint
  local to = isPrev and self.initialPoint or self.anotherPoint
  self.anotherTweenTransform.method = isPrev and 2 or 1
  self:SetTweenTransformAndPlay(from, to)
end
function SignInTipsView:OnEnter()
  SignInTipsView.super.OnEnter(self)
  self.iconTexName = "sign_boli"
  self.jokeTexName = "sign_bg_dialog-box"
  picManager:SetUI(self.iconTexName, self.iconTex)
  picManager:SetUI(self.jokeTexName, self.jokeTex)
  self:LoadBgTexOfPage(self.tipPage)
  self:LoadBgTexOfPage(self.anotherPage)
  self:ResetTip()
end
function SignInTipsView:OnExit()
  self.anotherTweenTransform.enabled = false
  self.anotherTweenTransform = nil
  picManager:UnLoadUI(self.iconTexName, self.iconTex)
  picManager:UnLoadUI(self.jokeTexName, self.jokeTex)
  self:UnloadBgTexOfPage(self.tipPage)
  self:UnloadBgTexOfPage(self.anotherPage)
  self:TryUnloadBannerTexOfPage(self.tipPage)
  self:TryUnloadBannerTexOfPage(self.anotherPage)
  SignInTipsView.super.OnExit(self)
end
function SignInTipsView:SetTweenTransformAndPlay(from, to, duration)
  self.anotherTweenTransform.enabled = true
  self.anotherTweenTransform.from = from
  self.anotherTweenTransform.to = to
  self.anotherTweenTransform.duration = duration or SignInTipsView.AnimDuration
  self.anotherTweenTransform:ResetToBeginning()
  self.anotherTweenTransform:PlayForward()
end
function SignInTipsView:TryUnloadBannerTexOfPage(page)
  if not page.bannerTexName then
    return
  end
  picManager:UnLoadSignIn(page.bannerTexName, page.bannerTex)
end
function SignInTipsView:LoadBgTexOfPage(page)
  picManager:SetUI(page.bgTexName, page.bgTex)
end
function SignInTipsView:UnloadBgTexOfPage(page)
  picManager:UnLoadUI(page.bgTexName, page.bgTex)
end
function SignInTipsView:GetRemainderOfDay(day)
  return proxyIns:GetRemainderOfDay(day, proxyIns:GetStaticTextDataCount())
end
