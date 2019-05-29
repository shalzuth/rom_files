autoImport("TeamPwsView")
autoImport("FreeBattleView")
autoImport("ClassicBattleView")
PvpMainView = class("PvpMainView", ContainerView)
PvpMainView.ViewType = UIViewType.NormalLayer
local TEXTURE = {
  "pvp_bg_07",
  "pvp_bg_08",
  "pvp_bg_09"
}
local Color_Gray = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
local Color_White = Color(1, 1, 1, 1)
function PvpMainView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
  self:InitTex()
end
function PvpMainView:FindObjs()
  self.teamPwsToggle = self:FindGO("TeamPwsBtn")
  self.freeBattleToggle = self:FindGO("FreeBattleBtn")
  self.classicBattleToggle = self:FindGO("ClassicBattleBtn")
  self.teamPwsViewObj = self:FindGO("TeamPwsView")
  self.freeBattleViewObj = self:FindGO("FreeBattleView")
  self.classicBattleViewObj = self:FindGO("ClassicBattleView")
  self.playerTipStick = self:FindComponent("Stick", UIWidget)
  self.teamPwsTex = self:FindComponent("TeamPwsBg", UITexture)
  self.freeBattleTex = self:FindComponent("FreeBattleBg", UITexture)
  self.classicBattleTex = self:FindComponent("ClassicBattleBg", UITexture)
end
function PvpMainView:AddEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleLoadScene)
  self:AddListenEvt(PVPEvent.PVPDungeonLaunch, self.HandleDungeonLaunch)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.CloseSelf)
end
function PvpMainView:HandleDungeonLaunch(note)
  self:CloseSelf()
end
function PvpMainView:AddViewEvts()
end
function PvpMainView:InitTex()
  PictureManager.Instance:SetPVP(TEXTURE[1], self.teamPwsTex)
  PictureManager.Instance:SetPVP(TEXTURE[2], self.freeBattleTex)
  PictureManager.Instance:SetPVP(TEXTURE[3], self.classicBattleTex)
end
function PvpMainView:InitShow()
  self.teamPwsView = self:AddSubView("TeamPwsView", TeamPwsView)
  self.freeBattleView = self:AddSubView("FreeBattleView", FreeBattleView)
  self.classicBattleView = self:AddSubView("ClassicBattleView", ClassicBattleView)
  self:AddTabChangeEvent(self.teamPwsToggle, self.teamPwsViewObj, PanelConfig.TeamPwsView)
  self:AddTabChangeEvent(self.freeBattleToggle, self.freeBattleViewObj, PanelConfig.FreeBattleView)
  self:AddTabChangeEvent(self.classicBattleToggle, self.classicBattleViewObj, PanelConfig.ClassicBattleView)
  local teamPwsOpen = not GameConfig.SystemForbid.TeamPws
  self.teamPwsToggle:GetComponent(Collider).enabled = teamPwsOpen
  self:FindGO("NotOpenMask", self.teamPwsToggle):SetActive(not teamPwsOpen)
  self.teamPwsTex.color = teamPwsOpen and Color_White or Color_Gray
  local defaultTab = teamPwsOpen and PanelConfig.TeamPwsView.tab or PanelConfig.FreeBattleView.tab
  local teamRelaxOpen = not GameConfig.SystemForbid.TeamRelax
  self.freeBattleToggle:GetComponent(Collider).enabled = teamRelaxOpen
  self:FindGO("NotOpenMask", self.freeBattleToggle):SetActive(not teamRelaxOpen)
  self.teamPwsTex.color = teamPwsOpen and Color_White or Color_Gray
  local defaultTab = teamRelaxOpen and PanelConfig.FreeBattleView.tab or PanelConfig.ClassicBattleView.tab
  if self.viewdata.view and self.viewdata.view.tab then
    local tab = self.viewdata.view.tab
    if key == PanelConfig.YoyoViewPage.tab or key == PanelConfig.DesertWolfView.tab or key == PanelConfig.GorgeousMetalView.tab then
      self:TabChangeHandler(PanelConfig.ClassicBattleView.tab)
      self.classicBattleView:TabChangeHandlerWithPanelID(tab)
    else
      self:TabChangeHandler(tab)
    end
  else
    self:TabChangeHandler(defaultTab)
  end
end
function PvpMainView:TabChangeHandler(key)
  if self.currentKey ~= key then
    PvpMainView.super.TabChangeHandler(self, key)
    if key == PanelConfig.TeamPwsView.tab then
      self.teamPwsView:UpdateView()
    elseif key == PanelConfig.FreeBattleView.tab then
      self.freeBattleView:UpdateView()
    elseif key == PanelConfig.ClassicBattleView.tab then
      self.classicBattleView:UpdateView()
    end
    self.currentKey = key
  end
end
function PvpMainView:OnEnter()
  PvpMainView.super.OnEnter(self)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ChitchatLayer)
end
function PvpMainView:OnExit()
  PictureManager.Instance:UnLoadPVP()
  PvpMainView.super.OnExit(self)
end
function PvpMainView:HandleLoadScene()
  if PvpProxy.Instance:IsSelfInGuildBase() then
    self:CloseSelf()
  end
end
