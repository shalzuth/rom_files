autoImport("YoyoViewPage")
autoImport("DesertWolfView")
autoImport("GorgeousMetalView")
ClassicBattleView = class("ClassicBattleView", SubView)
local TEXTURE = {
  "pvp_bg_03",
  "pvp_bg_04",
  "pvp_bg_05"
}
function ClassicBattleView:Init()
  self.coreTabMap = ReusableTable.CreateTable()
  self:FindObjs()
  self:InitShow()
  self:InitTex()
end
function ClassicBattleView:FindObjs()
  self.yoyoToggle = self:FindGO("YoyoBtn")
  self.desertWolfToggle = self:FindGO("DesertWolfBtn")
  self.gorgeousMetalToggle = self:FindGO("GorgeousMetalBtn")
  self.yoyoViewObj = self:FindGO("YoyoView")
  self.desertWolfViewObj = self:FindGO("DesertWolfView")
  self.gorgeousMetalViewObj = self:FindGO("GorgeousMetalView")
  self.yoyoTex = self:FindComponent("YoyoBg", UITexture)
  self.wolfTex = self:FindComponent("WolfBg", UITexture)
  self.matalTex = self:FindComponent("MetalBg", UITexture)
end
function ClassicBattleView:InitTex()
  PictureManager.Instance:SetPVP(TEXTURE[1], self.yoyoTex)
  PictureManager.Instance:SetPVP(TEXTURE[2], self.wolfTex)
  PictureManager.Instance:SetPVP(TEXTURE[3], self.matalTex)
end
function ClassicBattleView:InitShow()
  self.yoyoView = self:AddSubView("YoyoViewPage", YoyoViewPage)
  self.desertWolfView = self:AddSubView("DesertWolfView", DesertWolfView)
  self.gorgeousMetalView = self:AddSubView("GorgeousMetalView", GorgeousMetalView)
  self:AddTabChangeEvent(self.yoyoToggle, self.yoyoViewObj, self.yoyoView)
  self:AddTabChangeEvent(self.desertWolfToggle, self.desertWolfViewObj, self.desertWolfView)
  self:AddTabChangeEvent(self.gorgeousMetalToggle, self.gorgeousMetalViewObj, self.gorgeousMetalView)
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandlerWithPanelID(self.viewdata.view.tab)
  else
    self:TabChangeHandler(self.yoyoToggle.name)
  end
end
function ClassicBattleView:AddTabChangeEvent(toggleObj, targetObj, script)
  local key = toggleObj.name
  if not self.coreTabMap[key] then
    local table = ReusableTable.CreateTable()
    table.obj = targetObj
    table.script = script
    self.coreTabMap[key] = table
    self:AddClickEvent(toggleObj, function(go)
      self:TabChangeHandler(go.name)
    end)
  end
end
function ClassicBattleView:TabChangeHandlerWithPanelID(tabID)
  if tabID == PanelConfig.YoyoViewPage.tab then
    self:TabChangeHandler(self.yoyoToggle.name)
  elseif tabID == PanelConfig.DesertWolfView.tab then
    self:TabChangeHandler(self.desertWolfToggle.name)
  elseif tabID == PanelConfig.GorgeousMetalView.tab then
    self:TabChangeHandler(self.gorgeousMetalToggle.name)
  end
end
function ClassicBattleView:TabChangeHandler(key)
  if self.currentKey ~= key then
    if self.currentKey then
      self.coreTabMap[self.currentKey].obj:SetActive(false)
    end
    self.coreTabMap[key].obj:SetActive(true)
    self.coreTabMap[key].script:UpdateView()
    self.currentKey = key
  end
end
function ClassicBattleView:UpdateView()
  self.coreTabMap[self.currentKey].script:UpdateView()
end
function ClassicBattleView:OnEnter()
  ClassicBattleView.super.OnEnter(self)
  ServiceMatchCCmdProxy.Instance:CallReqMyRoomMatchCCmd()
end
function ClassicBattleView:OnExit()
  for k, v in pairs(self.coreTabMap) do
    ReusableTable.DestroyAndClearTable(v)
  end
  ReusableTable.DestroyAndClearTable(self.coreTabMap)
  PictureManager.Instance:UnLoadPVP()
  ClassicBattleView.super.OnExit(self)
end
