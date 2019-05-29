GorgeousMetalView = class("GorgeousMetalView", SubView)
autoImport("GorgeousMetalRoomCell")
local GorgeousMetal_Path = ResourcePathHelper.UIView("GorgeousMetalView")
local G_PVP_TYPE
local CD_TIME = 5
GorgeousMetalView.PullRefreshTip = ZhString.GorgeousMetalView_PullRefreshTip
GorgeousMetalView.BackRefreshTip = ZhString.GorgeousMetalView_BackRefreshTip
GorgeousMetalView.RefreshingTip = ZhString.GorgeousMetalView_RefreshingTip
function GorgeousMetalView:Init()
  G_PVP_TYPE = PvpProxy.Type.GorgeousMetal
  self:InitView()
  self:AddViewEvts()
end
function GorgeousMetalView:InitView()
  local container = self:FindGO("GorgeousMetalView")
  local gameObject = self:LoadPreferb_ByFullPath(GorgeousMetal_Path, container, true)
  self.ruleButton = self:FindGO("RuleButton")
  self:AddClickEvent(self.ruleButton, function(go)
    self:ruleButtonEvt()
  end)
  self.roomtable = self:FindComponent("RoomTable", UITable, container)
  self.roomCtl = UIGridListCtrl.new(self.roomtable, GorgeousMetalRoomCell, "GorgeousMetalRoomCell")
  self.roomCtl:AddEventListener(MouseEvent.MouseClick, self.clickGorgeousMetalRoom, self)
  self.roomCtl:AddEventListener(GorgeousMetalRoomEvent.Join, self.JoinRoom, self)
  self.roomCtl:AddEventListener(PvpTeamCellEvent.Join, self.JoinTeam, self)
  self.roomCtl:AddEventListener(PvpTeamCellEvent.ClickMember, self.clickMember, self)
  self.roomCtl:AddEventListener(GorgeousMetalRoomEvent.Enter, self.EnterRoom, self)
  self.roomCtl:AddEventListener(GorgeousMetalRoomEvent.Leave, self.LeaveRoom, self)
  self.centerOnChild = self.roomtable:GetComponent(MyUICenterOnChild)
  self.waitting = self:FindComponent("Waitting", UILabel, container)
  self.scrollView = self:FindComponent("RoomScrollView", ROUIScrollView, container)
  function self.scrollView.OnBackToStop()
    self.waitting.text = self.RefreshingTip
  end
  function self.scrollView.OnStop()
    self:ReqServerRoomList()
    if self.lastChooseCell then
      local data = self.lastChooseCell.data
      if data and data.guid then
        ServiceMatchCCmdProxy.Instance:CallReqRoomDetailCCmd(G_PVP_TYPE, data.guid)
      end
    end
  end
  function self.scrollView.OnPulling(offsetY, triggerY)
    self.waitting.text = offsetY < triggerY and self.PullRefreshTip or self.BackRefreshTip
  end
  function self.scrollView.OnRevertFinished()
    self.waitting.text = self.PullRefreshTip
  end
  self.playerTipStick = self:FindComponent("Stick", UIWidget, container)
end
function GorgeousMetalView:ruleButtonEvt()
  local panelId = PanelConfig.GorgeousMetalView.id
  local Desc = Table_Help[panelId] and Table_Help[panelId].Desc or tempRuleTest
  TipsView.Me():ShowGeneralHelp(Desc)
end
function GorgeousMetalView:clickGorgeousMetalRoom(cell)
  self:OpenGorgeousMetalRoom(cell, true)
end
function GorgeousMetalView:OpenGorgeousMetalRoom(cell, isReqServerInfo)
  if cell == self.lastChooseCell then
    cell:Close()
    self.lastChooseCell = nil
    self.roomtable:Reposition()
  else
    if self.lastChooseCell ~= nil then
      self.lastChooseCell:Close()
    end
    cell:Open()
    cell:RefreshRoomDetalInfo()
    self.roomtable:Reposition()
    self.centerOnChild:CenterOn(cell.centerTarget.transform)
    local data = cell.data
    if isReqServerInfo and data ~= nil then
      ServiceMatchCCmdProxy.Instance:CallReqRoomDetailCCmd(G_PVP_TYPE, data.guid)
    end
    self.lastChooseCell = cell
  end
end
function GorgeousMetalView:JoinRoom(cell)
  local data = cell.data
  if data ~= nil then
    self:DoJoinTeam(G_PVP_TYPE, data.guid, nil, false)
  end
end
function GorgeousMetalView:JoinTeam(param)
  local roomCell, teamCell = param[1], param[2]
  if roomCell and teamCell then
    local roomData = roomCell.data
    local teamData = teamCell.data
    if not roomData or teamData then
    end
  end
end
function GorgeousMetalView:DoJoinTeam(type, roomid, name, isquick)
  if TeamProxy.Instance:IHaveTeam() then
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(type, roomid, name, isquick)
    ServiceMatchCCmdProxy.Instance:CallReqRoomDetailCCmd(G_PVP_TYPE, roomid)
  else
    MsgManager.ShowMsgByIDTable(332)
  end
end
function GorgeousMetalView:EnterRoom(cell)
  local data = cell.data
  if data ~= nil then
    ServiceMatchCCmdProxy.Instance:CallJoinFightingCCmd(G_PVP_TYPE, data.guid)
  end
end
function GorgeousMetalView:LeaveRoom(cell)
  if self.lastChooseCell then
    self:OpenGorgeousMetalRoom(self.lastChooseCell, false)
  end
  local data = cell.data
  if data ~= nil then
    ServiceMatchCCmdProxy.Instance:CallLeaveRoomCCmd(G_PVP_TYPE, data.guid)
  end
end
function GorgeousMetalView:clickMember(param)
  local roomCell, teamCell, headCell = param[1], param[2], param[3]
  if roomCell and teamCell and headCell then
    local teamData = teamCell.data
    local memberHeadData = headCell.data
    local id = memberHeadData.iconData.id
    if id == Game.Myself.data.id then
      return
    end
    local memberData = teamData:GetMemberByGuid(id)
    if memberData then
      local playerData = PlayerTipData.new()
      playerData:SetByTeamMemberData(memberData)
      if not self.container.playerTipShow then
        self.container.playerTipShow = true
        local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.playerTipStick, NGUIUtil.AnchorSide.Left, {-300, 0})
        local tipData = {
          playerData = playerData,
          funckeys = {
            "SendMessage",
            "AddFriend",
            "AddBlacklist",
            "ShowDetail"
          }
        }
        playerTip:SetData(tipData)
        function playerTip.closecallback(go)
          self.container.playerTipShow = false
        end
      else
        FunctionPlayerTip.Me():CloseTip()
        self.container.playerTipShow = false
      end
    else
      redlog("not find member", tostring(id))
    end
  end
end
function GorgeousMetalView:OnEnter()
  GorgeousMetalView.super.OnEnter(self)
end
function GorgeousMetalView:OnExit()
  GorgeousMetalView.super.OnExit(self)
  if self.cdlt then
    self.cdlt:cancel()
    self.cdlt = nil
  end
end
function GorgeousMetalView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdReqRoomListCCmd, self.HandleReqRoomList)
  self:AddListenEvt(ServiceEvent.MatchCCmdReqRoomDetailCCmd, self.HandleReqRoomDetailCCmd)
  self:AddListenEvt(ServiceEvent.MatchCCmdReqMyRoomMatchCCmd, self.HandleUpdateMyRoom)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfRoomStateCCmd, self.HandleNtfRoomState)
  self:AddListenEvt(ServiceEvent.MatchCCmdPvpTeamMemberUpdateCCmd, self.HandlePvpMemberUpdate)
  self:AddListenEvt(ServiceEvent.MatchCCmdPvpMemberDataUpdateCCmd, self.HandlePvpMemberDataUpdate)
  self:AddListenEvt(ServiceEvent.MatchCCmdKickTeamCCmd, self.HandleKickTeamCCmd)
end
function GorgeousMetalView:HandleReqRoomList(note)
  local data = note.body
  if data then
    local dtype = data.type
    if dtype == G_PVP_TYPE then
      self:UpdateRoomList()
    end
  end
  self.scrollView:Revert()
end
function GorgeousMetalView:HandleReqRoomDetailCCmd(note)
  local data = note.body
  if data then
    local dtype, roomid = data.type, data.roomid
    if dtype == G_PVP_TYPE then
      self:UpdateRoomDetalInfo(roomid)
    end
  end
end
function GorgeousMetalView:UpdateRoomList()
  local roomlist = PvpProxy.Instance:GetRoomList(G_PVP_TYPE)
  self.roomCtl:ResetDatas(roomlist)
end
function GorgeousMetalView:UpdateRoomDetalInfo(roomid)
  if self.lastChooseCell then
    local data = self.lastChooseCell.data
    if data.guid ~= roomid then
      local cells = self.roomCtl:GetCells()
      for i = 1, #cells do
        local data = cells[i].data
        if data.guid == roomid then
          self:OpenGorgeousMetalRoom(cells[i], false)
          break
        end
      end
    else
      self.lastChooseCell:RefreshRoomDetalInfo()
    end
  else
    local cells = self.roomCtl:GetCells()
    for i = 1, #cells do
      local data = cells[i].data
      if data.guid == roomid then
        self:OpenGorgeousMetalRoom(cells[i], false)
        break
      end
    end
  end
end
function GorgeousMetalView:HandleUpdateMyRoom(note)
  self:UpdateRoomList()
end
function GorgeousMetalView:HandleKickTeamCCmd()
  self:UpdateRoomList()
end
function GorgeousMetalView:HandlePvpMemberUpdate(note)
  self:UpdateRoomList()
end
function GorgeousMetalView:HandlePvpMemberDataUpdate(note)
  self:UpdateRoomList()
  if self.lastChooseCell then
    local lastRoomid = self.lastChooseCell.data.id
    self:UpdateRoomDetalInfo(lastRoomid)
  end
end
function GorgeousMetalView:HandleNtfRoomState(note)
  self:UpdateRoomList()
end
function GorgeousMetalView:UpdateView()
  self:ReqServerRoomList()
  if self.lastChooseCell then
    local data = self.lastChooseCell.data
    if data and data.guid then
      ServiceMatchCCmdProxy.Instance:CallReqRoomDetailCCmd(G_PVP_TYPE, data.guid)
    end
  end
end
function GorgeousMetalView:ReqServerRoomList()
  if self.reqRoom_inCD then
    MsgManager.ShowMsgByIDTable(952)
    return
  end
  if self.cdlt then
    self.cdlt:cancel()
    self.cdlt = nil
  end
  self.cdlt = LeanTween.delayedCall(CD_TIME, function()
    self.reqRoom_inCD = false
  end)
  ServiceMatchCCmdProxy.Instance:CallReqRoomListCCmd(G_PVP_TYPE)
end
