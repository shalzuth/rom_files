ExpRaidMapView = class("ExpRaidMapView", BaseView)
ExpRaidMapView.ViewType = UIViewType.InterstitialLayer
local tempVector3 = LuaVector3.zero
function ExpRaidMapView:Init()
  self:FindObjs()
  self:InitShow()
  self:AddEvents()
end
function ExpRaidMapView:FindObjs()
  self.timesLeftLabel = self:FindComponent("TimesLeftLabel", UILabel)
  self.mapBgTex = self:FindComponent("MapBg", UITexture)
  self.contentParentTrans = self:FindComponent("Content", Transform)
  self.raidDataArray = ExpRaidProxy.Instance:GetExpRaidDataArray()
  self.raidIdCellMap = {}
  local cellGO
  for i = 1, #self.raidDataArray do
    cellGO = self:FindGO("ExpRaidMapCell" .. i)
    if not cellGO then
      LogUtility.ErrorFormat("Cannot find ExpRaidMapCell{0}", i)
      return
    end
    self:SetOutlineOfCellActive(cellGO, false)
    self.raidIdCellMap[self.raidDataArray[i].id] = cellGO
  end
end
function ExpRaidMapView:InitShow()
  self.timesLeftLabel.text = string.format(ZhString.ExpRaid_TimesLeft, ExpRaidProxy.Instance:GetExpRaidTimesLeft(), GameConfig.TeamExpRaid.day_count)
  local manualHeight = UIManagerProxy.Instance:GetMyMobileScreenAdaptionManualHeight()
  if manualHeight then
    local ratio = manualHeight / 720
    tempVector3:Set(ratio, ratio, ratio)
    self.contentParentTrans.localScale = tempVector3
  end
  local selfLevel = MyselfProxy.Instance:RoleLevel()
  local isShow, cell, lvLabel, recommendLv
  for i = 1, #self.raidDataArray do
    local raidData = self.raidDataArray[i]
    isShow = selfLevel >= raidData.Level
    cell = self.raidIdCellMap[raidData.id]
    cell:SetActive(isShow)
    lvLabel = self:FindComponent("LvLabel", UILabel, cell)
    recommendLv = raidData.RecommendLv
    if not recommendLv or not next(recommendLv) then
      LogUtility.WarningFormat("Cannot find RecommendLv of ExpRaid id={0}", raidData.id)
      return
    end
    lvLabel.text = string.format(ZhString.ExpRaid_MapCellLvLabel, recommendLv[1], recommendLv[2] or 0)
  end
  self:SelectCell(ExpRaidProxy.Instance:GetRaidIdWithSuitableLevel(selfLevel))
end
function ExpRaidMapView:AddEvents()
  for id, cell in pairs(self.raidIdCellMap) do
    self:AddClickEvent(cell, function()
      self:SelectCell(id)
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ExpRaidDetailView,
        viewdata = id
      })
    end)
    break
  end
  self:AddListenEvt(PVEEvent.ExpRaid_Launch, self.CloseSelf)
end
function ExpRaidMapView:OnEnter()
  ExpRaidMapView.super.OnEnter(self)
  self.mapBgTexName = "fb_map"
  PictureManager.Instance:SetMap(self.mapBgTexName, self.mapBgTex)
end
function ExpRaidMapView:OnExit()
  PictureManager.Instance:UnLoadMap(self.mapBgTexName, self.mapBgTex)
  TipsView.Me():HideCurrent()
  self:sendNotification(ExpRaidEvent.MapViewClose)
  ExpRaidMapView.super.OnExit(self)
end
function ExpRaidMapView:AddHelpButtonEvent()
  local go = self:FindGO("HelpButton")
  if go then
    self:AddClickEvent(go, function()
      self:OpenHelpView(Table_Help[928])
    end)
  end
end
function ExpRaidMapView:SelectCell(id)
  if self.selectedCellId then
    if id == self.selectedCellId then
      return
    end
    local selectedCell = self.raidIdCellMap[self.selectedCellId]
    tempVector3:Set(1, 1, 1)
    selectedCell.transform.localScale = tempVector3
    self:SetOutlineOfCellActive(selectedCell, false)
  end
  if not self.raidIdCellMap[id] then
    LogUtility.WarningFormat("Cannot find ExpRaidCell with id:{0}", id)
    return
  end
  self.selectedCellId = id
  tempVector3:Set(1.2, 1.2, 1.2)
  self.raidIdCellMap[id].transform.localScale = tempVector3
  self:SetOutlineOfCellActive(self.raidIdCellMap[id], true)
end
function ExpRaidMapView:SetOutlineOfCellActive(cellGO, isActive)
  local outlineGO = self:FindGO("Outline", cellGO)
  outlineGO:SetActive(isActive)
end
