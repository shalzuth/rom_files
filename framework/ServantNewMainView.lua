autoImport("ServantRecommendView")
autoImport("FinanceView")
autoImport("ServantImproveViewNew")
autoImport("ServantCalendarView")
ServantNewMainView = class("ServantNewMainView", ContainerView)
ServantNewMainView.ViewType = UIViewType.NormalLayer
if not GameConfig.Servant.Filter then
  local UI_FLITER = {11, 12}
end
local TOGGLE_BTN_UNCHOOSEN = Color(0.25882352941176473, 0.34901960784313724, 0.6705882352941176, 1)
local OUTLINE_TEXTURE = "calendar_bg"
local FIXED_TEXTURE = "calendar_bg1_picture"
local C_BG_TEXTURE = "calendar_bg1"
local L_BG_TEXTURE = "calendar_bg2"
local SEASON_TEXTURE = {
  [1] = "calendar_bg_winter",
  [2] = "calendar_bg_spring",
  [3] = "calendar_bg_summer",
  [4] = "calendar_bg_autumn"
}
function ServantNewMainView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:InitShow()
end
function ServantNewMainView:FindObjs()
  self.bg = self:FindGO("Bg"):GetComponent(UITexture)
  self.bgL = self:FindGO("BgL"):GetComponent(UITexture)
  self.bgR = self:FindGO("BgR"):GetComponent(UITexture)
  self.outLineTex = self:FindGO("OutLineTexture"):GetComponent(UITexture)
  self.fixedTex = self:FindGO("FixedTexture"):GetComponent(UITexture)
  self.recommendToggle = self:FindGO("RecommendBtn")
  self.financeToggle = self:FindGO("FinanceBtn")
  self.improveToggle = self:FindGO("ImproveBtn")
  self.toggleBtnSprite = {
    self.recommendToggle:GetComponent(UISprite),
    self.financeToggle:GetComponent(UISprite),
    self.improveToggle:GetComponent(UISprite)
  }
  self.toggleBg = {}
  for i = 1, 3 do
    self.toggleBg[i] = self:FindGO("ToggleBg" .. i)
  end
  self.recommendObj = self:FindGO("recommendView")
  self.financeObj = self:FindGO("financeView")
  self.improveObj = self:FindGO("improveView")
  self.seasonTexture = {}
  self.seasonPos = self:FindGO("SeasonPos")
  for i = 1, 4 do
    self.seasonTexture[i] = self:FindGO("season" .. i, self.seasonPos)
  end
end
function ServantNewMainView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleEvt)
  self:AddListenEvt(ShortCut.MoveToPos, self.HandleEvt)
  self:AddListenEvt(ServantImproveEvent.FunctionListUpdate, self.UpdateFunctionList)
  self:AddListenEvt(ServantImproveEvent.ItemListUpdate, self.UpdateGroup)
  self:AddListenEvt(ServantImproveEvent.GiftProgressUpdate, self.UpdateGiftProgressNew)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem)
  self:AddListenEvt(ServiceEvent.NUserServantRecEquipUserCmd, self.RecEquipUserCmd)
end
function ServantNewMainView:RecEquipUserCmd(data)
  if not self.improveView then
    return
  end
  self.improveView:RecEquipUserCmd(data)
end
function ServantNewMainView:UpdateFunctionList(data)
  if not self.improveView then
    return
  end
  self.improveView:UpdateFunctionList(data)
end
function ServantNewMainView:UpdateGroup(data)
  if not self.improveView then
    return
  end
  self.improveView:UpdateGroup(data)
end
function ServantNewMainView:UpdateGiftProgressNew(data)
  if not self.improveView then
    return
  end
  self.improveView:UpdateGiftProgressNew(data)
end
function ServantNewMainView:RecvQueryShopConfig(data)
  if not self.improveView then
    return
  end
  self.improveView:RecvQueryShopConfig(data)
end
function ServantNewMainView:OnReceiveUpdateShopGotItem(data)
  if not self.improveView then
    return
  end
  self.improveView:OnReceiveUpdateShopGotItem(data)
end
function ServantNewMainView:HandleEvt()
  self:CloseSelf()
end
function ServantNewMainView:InitShow()
  RedTipProxy.Instance:RegisterUIByGroupID(11, self.recommendToggle, 4, {-5, -5})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_GROWTH, self.improveToggle, 4, {-5, -5})
  self:AddTabChangeEvent(self.recommendToggle, self.recommendObj, PanelConfig.ServantRecommendView)
  self:AddTabChangeEvent(self.financeToggle, self.financeObj, PanelConfig.FinanceView)
  self:AddTabChangeEvent(self.improveToggle, self.improveObj, PanelConfig.ServantImproveViewNew)
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  else
    self:TabChangeHandler(PanelConfig.ServantRecommendView.tab)
  end
  self.stefanie = self:FindGO("Stefanie")
  self.stefanie:SetActive(GameConfig.Servant.Stefanie == Game.Myself.data.userdata:Get(UDEnum.SERVANTID))
  local randomVoice = GameConfig.Servant.StefanieRandomVoice
  self:AddClickEvent(self.stefanie, function()
    if not StringUtil.IsEmpty(randomVoice) then
      local r = math.random(#randomVoice)
      AudioUtil.PlayNpcVisitVocal(randomVoice[r])
    end
  end)
end
function ServantNewMainView:TabChangeHandler(key)
  if self.currentKey ~= key then
    ServantNewMainView.super.TabChangeHandler(self, key)
    self:SetMainTexture()
    if key == PanelConfig.ServantRecommendView.tab then
      if not self.recommendView then
        self.recommendView = self:AddSubView("ServantRecommendView", ServantRecommendView)
      end
      self.recommendView:ShowTexture()
    elseif key == PanelConfig.FinanceView.tab then
      if not self.financeView then
        self.financeView = self:AddSubView("FinanceView", FinanceView)
      end
    elseif key == PanelConfig.ServantImproveViewNew.tab and not self.improveView then
      self.improveView = self:AddSubView("ServantImproveView", ServantImproveViewNew)
    end
    self.currentKey = key
    for i = 1, 3 do
      self.toggleBg[i]:SetActive(i == self.currentKey)
      self.toggleBtnSprite[i].color = i == self.currentKey and ColorUtil.NGUIWhite or TOGGLE_BTN_UNCHOOSEN
    end
  end
end
function ServantNewMainView:SetMainTexture()
  PictureManager.Instance:SetUI(OUTLINE_TEXTURE, self.outLineTex)
  self.seasonPos:SetActive(false)
end
function ServantNewMainView:SetSeasonTexture(month)
  local season = ServantCalendarProxy.GetSeason(month)
  PictureManager.Instance:SetUI(SEASON_TEXTURE[season], self.outLineTex)
  self.seasonPos:SetActive(true)
  for i = 1, 4 do
    self.seasonTexture[i]:SetActive(i == season)
  end
end
function ServantNewMainView:OnEnter()
  PictureManager.Instance:SetUI(FIXED_TEXTURE, self.fixedTex)
  PictureManager.Instance:SetUI(C_BG_TEXTURE, self.bg)
  PictureManager.Instance:SetUI(L_BG_TEXTURE, self.bgL)
  PictureManager.Instance:SetUI(L_BG_TEXTURE, self.bgR)
  FunctionSceneFilter.Me():StartFilter(UI_FLITER)
  ServantNewMainView.super.OnEnter(self)
end
function ServantNewMainView:OnExit()
  PictureManager.Instance:UnLoadUI()
  FunctionSceneFilter.Me():EndFilter(UI_FLITER)
  ServantNewMainView.super.OnExit(self)
end
