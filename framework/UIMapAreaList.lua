autoImport("UIMapAreaListCell")
autoImport("UIModelMonthlyVIP")
UIMapAreaList = class("UIMapAreaList", ContainerView)
UIMapAreaList.ViewType = UIViewType.NormalLayer
UIMapAreaList.E_TransmitType = {
  Single = 0,
  Team = 1,
  DeathKingdom = 2
}
UIMapAreaList.transmitType = nil
function UIMapAreaList:Init()
  self.transScrollList = self:FindGO("ScrollList").transform
  self.transRoot = self:FindGO("Root", self.transScrollList.gameObject).transform
  self.uiGrid = self.transRoot.gameObject:GetComponent(UIGrid)
  self.listCtrl = UIGridListCtrl.new(self.uiGrid, UIMapAreaListCell, "UIMapAreaListCell")
  self.goButtonBack = self:FindGO("Back", self.transScrollList.gameObject)
  self:AddClickEvent(self.goButtonBack, function(go)
    self:OnButtonBackClick(go)
  end)
  self.goMyTeam = self:FindGO("MyTeam")
  self:HideMyTeam()
  self.goTutorial = self:FindGO("Tutorial")
  self.goTutorialLab = self:FindGO("Lab", self.goTutorial)
  self.labTutorial = self.goTutorialLab:GetComponent(UILabel)
  self.labNpcName = self:FindComponent("NPCName", UILabel)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickAreaCell, self)
  self.activeAreas = {}
  self:InitData()
end
function UIMapAreaList:InitData()
  TableUtility.ArrayClear(self.activeAreas)
  if UIMapAreaList.transmitType == UIMapAreaList.E_TransmitType.DeathKingdom then
    local deathMapDatas = WorldMapProxy.Instance.deathTransferMapDatas
    for mapID, transfers in pairs(deathMapDatas) do
      local mapData = Table_Map[mapID]
      if mapData then
        self.activeAreas[#self.activeAreas + 1] = {
          id = mapData.id,
          name = mapData.NameZh
        }
      else
        printRed("Cannot Find Map Data With ID: %s", mapID)
      end
    end
    local curNpcData = Table_Npc[self.viewdata.viewdata.params]
    if curNpcData then
      self.labTutorial.text = DialogUtil.GetDialogData(curNpcData.DefaultDialog).Text
      self.labNpcName.text = curNpcData.NameZh
    end
  else
    local amIMonthlyVIP = UIModelMonthlyVIP.Instance():AmIMonthlyVIP()
    local activeMaps = WorldMapProxy.Instance.activeMaps
    for mapid, _ in pairs(activeMaps) do
      local mapInfo = Table_Map[mapid]
      if mapInfo then
        local couldTransmit = mapInfo.MoneyType ~= 2 or amIMonthlyVIP
        if couldTransmit then
          local areaID = mapInfo.Range
          if areaID ~= nil and not self:AlreadyInitedArea(areaID) then
            local areaInfo = Table_ItemType[areaID]
            local text = areaInfo and string.format("%s%s", areaInfo.Name, ZhString.CapraTransmission_Area) or ""
            table.insert(self.activeAreas, {id = areaID, name = text})
          end
        end
      end
    end
    if UIMapAreaList.transmitType == UIMapAreaList.E_TransmitType.Single then
      local handInHandPlayerID = UIModelKaplaTransmit.Ins():GetHandInHandPlayerID_Teammate_NotCat()
      if handInHandPlayerID ~= nil then
        local handInHandPlayer = UIModelKaplaTransmit.Ins():GetTeammateDetail(handInHandPlayerID)
        local handInHandPlayerName = handInHandPlayer and handInHandPlayer.name or ""
        self.labTutorial.text = string.format(ZhString.kaplaTransmit_HandInHandTransmitTutorial, handInHandPlayerName)
      else
        self.labTutorial.text = ZhString.KaplaTransmit_SelectTransmitDestination
      end
    elseif UIMapAreaList.transmitType == UIMapAreaList.E_TransmitType.Team then
      self.labTutorial.text = ZhString.KaplaTransmit_TeammateTransmitTutorial
    end
  end
  table.sort(self.activeAreas, function(x, y)
    return self:Sort(x, y)
  end)
  self.listCtrl:ResetDatas(self.activeAreas)
end
function UIMapAreaList:ClickAreaCell(cell)
  local viewdata = {
    selectID = cell.data.id,
    areaViewData = self.viewdata.viewdata
  }
  FunctionNpcFunc.JumpPanel(PanelConfig.UIMapMapList, viewdata)
end
function UIMapAreaList:OnButtonBackClick(go)
  self:CloseSelf()
end
function UIMapAreaList:AlreadyInitedArea(id)
  for i = 1, #self.activeAreas do
    if self.activeAreas[i].id == id then
      return true
    end
  end
  return false
end
function UIMapAreaList:Sort(x, y)
  if x == nil then
    return true
  elseif y == nil then
    return false
  else
    return x.id < y.id
  end
end
function UIMapAreaList:HideMyTeam()
  self.goMyTeam:SetActive(false)
end
function UIMapAreaList:OnEnter()
  UIMapAreaList.super.OnEnter(self)
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.npc = viewdata and viewdata.npcdata
  self:UpdateInfo()
end
function UIMapAreaList:UpdateInfo()
  if self.npc and self.labNpcName then
    self.labNpcName.text = self.npc.data.name
  end
end
