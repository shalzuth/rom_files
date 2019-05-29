autoImport("UIMapMapListCell")
autoImport("UIMapDeathKingdomCell")
autoImport("UIListItemViewControllerTransmitTeammate")
autoImport("UIModelKaplaTransmit")
UIMapMapList = class("UIMapMapList", ContainerView)
UIMapMapList.ViewType = UIViewType.NormalLayer
local vec3 = LuaVector3.New(0, 0, 0)
local gReusableArray = {}
UIMapMapList.E_TransmitType = {
  Single = 0,
  Team = 1,
  DeathKingdom = 2
}
UIMapMapList.transmitType = nil
function UIMapMapList:Init()
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.DeathKingdom then
    self.listCtrl = UIGridListCtrl.new(self.uiGrid, UIMapDeathKingdomCell, "UIMapDeathKingdomCell")
  else
    self.listCtrl = UIGridListCtrl.new(self.uiGrid, UIMapMapListCell, "UIMapAreaListCell")
  end
  self.teammateListCtrl = UIGridListCtrl.new(self.teammateUIGrid, UIListItemViewControllerTransmitTeammate, "UIListItemTransmitTeammate")
  self.mapsInfo = {}
  self:GetModelSet()
  self:LoadView()
  self:ListenTeamEvent()
  self:ListenServer()
  self:ListenCustomEvent()
end
function UIMapMapList:GetGameObjects()
  self.transScrollList = self:FindGO("ScrollList").transform
  self.transRoot = self:FindGO("Root", self.transScrollList.gameObject).transform
  self.uiGrid = self.transRoot.gameObject:GetComponent(UIGrid)
  self.goButtonBack = self:FindGO("Back", self.transScrollList.gameObject)
  self.goMyTeam = self:FindGO("MyTeam")
  self.goTeammateScrollList = self:FindGO("ScrollList", self.goMyTeam)
  self.goTeammateRoot = self:FindGO("Root", self.goTeammateScrollList)
  self.teammateUIGrid = self.goTeammateRoot:GetComponent(UIGrid)
  self.goBTNInviteFollow = self:FindGO("BTN_InviteFollow", self.goMyTeam)
  self.goTutorial = self:FindGO("Tutorial")
  self.goTutorialLab = self:FindGO("Lab", self.goTutorial)
  self.labTutorial = self.goTutorialLab:GetComponent(UILabel)
  self.labNpcName = self:FindComponent("NPCName", UILabel)
  self.goNoListItem = self:FindGO("NoListItem", self.goTeammateScrollList)
end
function UIMapMapList:RegisterButtonClickEvent()
  self:AddClickEvent(self.goButtonBack, function(go)
    self:OnButtonBackClick(go)
  end)
  self:AddClickEvent(self.goBTNInviteFollow, function(go)
    self:OnClickForButtonInviteFollow(go)
  end)
end
function UIMapMapList:GetModelSet()
  TableUtility.ArrayClear(self.mapsInfo)
  if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.DeathKingdom then
    self:CreateDeathTransferMapData()
  else
    self.areaID = self.viewdata.viewdata.selectID
    local amIMonthlyVIP = UIModelMonthlyVIP.Instance():AmIMonthlyVIP()
    for _, v in pairs(Table_Map) do
      if v.Range == self.areaID and v.Money then
        local couldTransmit = v.MoneyType ~= 2 or amIMonthlyVIP
        if couldTransmit then
          table.insert(self.mapsInfo, v)
        end
      end
    end
    self.teammatesID = UIModelKaplaTransmit.Ins():GetTeammates()
  end
  table.sort(self.mapsInfo, function(x, y)
    return self:Sort(x, y)
  end)
end
function UIMapMapList:CreateDeathTransferMapData()
  self.curNpcID = self.viewdata.viewdata.areaViewData.params
  local curMapID = Game.MapManager:GetMapID()
  local tarMapID = self.viewdata.viewdata.selectID
  local isSameMap = curMapID == tarMapID
  local curIsMainTransfer, isAllActivated = false, true
  local activePoints = WorldMapProxy.Instance.activeDeathKingdomPoints
  local transferPoint, npcID, found
  local deathMapDatas = WorldMapProxy.Instance.deathTransferMapDatas
  for mapID, transfers in pairs(deathMapDatas) do
    if not isSameMap or mapID == curMapID then
      for i = 1, #transfers do
        transferPoint = transfers[i]
        npcID = transferPoint.NpcID
        if activePoints[npcID] ~= 1 then
          isAllActivated = false
        end
        if not found then
          if tostring(npcID) == tostring(self.curNpcID) then
            curIsMainTransfer = transferPoint.NpcType == 0
            found = true
            if mapID ~= curMapID then
              printRed("Table_DeathTransferMap\228\184\173\231\154\132MapID(%s)\229\146\140\229\189\147\229\137\141MapID(%s)\228\184\141\228\184\128\232\135\180\239\188\129", mapID, curMapID)
            end
          end
        end
        if isAllActivated then
        end
      end
    end
  end
  if not found then
    printRed("Cannot Find Death Transfer NPC: %s", self.curNpcID)
    return
  end
  local cellState, tarIsMainTransfer
  for mapID, transfers in pairs(deathMapDatas) do
    if mapID == tarMapID then
      for i = 1, #transfers do
        transferPoint = transfers[i]
        npcID = transferPoint.NpcID
        if tostring(npcID) ~= tostring(self.curNpcID) then
          if activePoints[npcID] == 1 then
            tarIsMainTransfer = transferPoint.NpcType == 0
            if isAllActivated or isSameMap and (curIsMainTransfer or tarIsMainTransfer) or not isSameMap and curIsMainTransfer and tarIsMainTransfer then
              cellState = UIMapDeathKingdomCell.E_State.Activated
            else
              cellState = UIMapDeathKingdomCell.E_State.Disable
            end
          else
            cellState = UIMapDeathKingdomCell.E_State.Unactivated
          end
          self.mapsInfo[#self.mapsInfo + 1] = {
            id = npcID,
            curID = self.curNpcID,
            state = cellState
          }
        end
      end
      break
    end
  end
end
function UIMapMapList:LoadView()
  self.listCtrl:ResetDatas(self.mapsInfo)
  if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Single or UIMapMapList.transmitType == UIMapMapList.E_TransmitType.DeathKingdom then
    self:TransmitLayout()
  elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
    self:TeamTransmitLayout()
  end
  self.teammateListCtrl:ResetDatas(self.teammatesID)
  self.goNoListItem:SetActive(not self.teammatesID or #self.teammatesID < 1)
  if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Single then
    local handInHandPlayerID = UIModelKaplaTransmit.Ins():GetHandInHandPlayerID_Teammate_NotCat()
    if handInHandPlayerID ~= nil then
      local handInHandPlayer = UIModelKaplaTransmit.Ins():GetTeammateDetail(handInHandPlayerID)
      local handInHandPlayerName = handInHandPlayer and handInHandPlayer.name or ""
      self.labTutorial.text = string.format(ZhString.kaplaTransmit_HandInHandTransmitTutorial, handInHandPlayerName)
    else
      self.labTutorial.text = ZhString.KaplaTransmit_SelectTransmitDestination
    end
  elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
    self.labTutorial.text = ZhString.KaplaTransmit_TeammateTransmitTutorial
  elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.DeathKingdom then
    local curNpcData = Table_Npc[self.curNpcID]
    if curNpcData then
      self.labTutorial.text = DialogUtil.GetDialogData(curNpcData.DefaultDialog).Text
      self.labNpcName.text = curNpcData.NameZh
    end
  end
end
function UIMapMapList:OnButtonBackClick(go)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UIMapAreaList,
    viewdata = self.viewdata.viewdata.areaViewData
  })
end
function UIMapMapList:OnClickForButtonInviteFollow(go)
  if UIModelKaplaTransmit.Ins():AmITeamLeader() then
    self:RequestInviteTeammateFollow()
  else
    MsgManager.ShowMsgByID(351)
  end
end
function UIMapMapList:Sort(x, y)
  if x == nil then
    return true
  elseif y == nil then
    return false
  else
    return x.id < y.id
  end
end
function UIMapMapList:TeamTransmitLayout()
  local localPos = self.transScrollList.localPosition
  vec3:Set(-112, localPos.y, localPos.z)
  self.transScrollList.localPosition = vec3
  localPos = self.goTeammateScrollList.transform.localPosition
  vec3:Set(52, localPos.y, localPos.z)
  self.goTeammateScrollList.transform.localPosition = vec3
end
function UIMapMapList:TransmitLayout()
  local localPos = self.transScrollList.localPosition
  vec3:Set(0, localPos.y, localPos.z)
  self.transScrollList.localPosition = vec3
  self.goMyTeam:SetActive(false)
end
function UIMapMapList:ListenCustomEvent()
  self:AddListenEvt("UIMapMapList.CloseSelf", function()
    self:CloseSelf()
  end)
  if UIMapMapList.transmitType ~= UIMapMapList.E_TransmitType.DeathKingdom then
    self:AddDispatcherEvt(FunctionFollowCaptainEvent.StateChanged, self.OnReceiveFunctionFollowCaptainEventStateChanged)
  end
end
function UIMapMapList:ListenTeamEvent()
  if UIMapMapList.transmitType ~= UIMapMapList.E_TransmitType.DeathKingdom then
    self:AddListenEvt(TeamEvent.MemberEnterTeam, self.OnReceiveMemberEnterTeam)
    self:AddListenEvt(TeamEvent.MemberExitTeam, self.OnReceiveMemberExitTeam)
    self:AddListenEvt(TeamEvent.MemberOffline, self.OnReceiveMemberOffline)
    self:AddListenEvt(TeamEvent.MemberOnline, self.OnReceiveMemberOnline)
  end
end
function UIMapMapList:ListenServer()
  if UIMapMapList.transmitType ~= UIMapMapList.E_TransmitType.DeathKingdom then
    self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd, self.OnReceiveBeFollowed)
  end
end
function UIMapMapList:OnReceiveMemberEnterTeam()
  self:Refresh()
end
function UIMapMapList:OnReceiveMemberExitTeam()
  self:Refresh()
end
function UIMapMapList:OnReceiveMemberOffline()
  self:Refresh()
end
function UIMapMapList:OnReceiveMemberOnline()
  self:Refresh()
end
function UIMapMapList:OnReceiveBeFollowed()
  self:Refresh()
end
function UIMapMapList:OnReceiveFunctionFollowCaptainEventStateChanged()
  self:Refresh()
end
function UIMapMapList:RequestInviteTeammateFollow()
  if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
    FunctionTeam.Me():InviteMemberFollow()
  end
end
function UIMapMapList:Refresh()
  self:GetModelSet()
  self:LoadView()
end
function UIMapMapList:OnEnter()
  UIMapMapList.super.OnEnter(self)
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.npc = viewdata and viewdata.areaViewData and viewdata.areaViewData.npcdata
  if self.npc and self.labNpcName then
    self.labNpcName.text = self.npc.data.name
  end
end
function UIMapMapList:OnExit()
  UIMapMapList.super.OnExit(self)
end
