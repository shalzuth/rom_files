local BaseCell = autoImport("BaseCell")
GorgeousMetalRoomCell = class("GorgeousMetalRoomCell", BaseCell)
GorgeousMetalRoomEvent = {
  Join = "GorgeousMetalRoomEvent_Join",
  Leave = "GorgeousMetalRoomEvent_Leave",
  Enter = "GorgeousMetalRoomEvent_Enter"
}
autoImport("PvpTeamCell")
function GorgeousMetalRoomCell:Init()
  self.bg = self:FindComponent("Bg", UISprite)
  self.buttonsMap = {}
  self.buttonsMap.joinButton = self:FindGO("JoinButton")
  self:AddClickEvent(self.buttonsMap.joinButton, function(go)
    self:PassEvent(GorgeousMetalRoomEvent.Join, self)
  end)
  self.buttonsMap.leaveButton = self:FindGO("LeaveButton")
  self:AddClickEvent(self.buttonsMap.leaveButton, function(go)
    self:PassEvent(GorgeousMetalRoomEvent.Leave, self)
  end)
  self.buttonsMap.enterButton = self:FindGO("EnterButton")
  self:AddClickEvent(self.buttonsMap.enterButton, function(go)
    self:PassEvent(GorgeousMetalRoomEvent.Enter, self)
  end)
  self.buttonsMap.fullTip = self:FindGO("FullTip")
  self.buttonsMap.teamMemberTip = self:FindGO("TeamMemberTip")
  self.name = self:FindComponent("Name", UILabel)
  self.team1_Tip = self:FindComponent("MemberNumTip1", UILabel)
  self.team2_Tip = self:FindComponent("MemberNumTip2", UILabel)
  self.team3_Tip = self:FindComponent("MemberNumTip3", UILabel)
  self.roomDetailInfo = self:FindGO("RoomDetailInfo")
  local pvpGrid = self:FindComponent("PvpTeamGrid", UIGrid)
  self.pvpTeamCtl = UIGridListCtrl.new(pvpGrid, PvpTeamCell, "PvpTeamCell")
  self.pvpTeamCtl:AddEventListener(PvpTeamCellEvent.Join, self.handleJoinTeam, self)
  self.pvpTeamCtl:AddEventListener(PvpTeamCellEvent.ClickMember, self.handleClickMember, self)
  self.centerTarget = self:FindGO("CenterTarget")
  self:AddCellClickEvent()
end
function GorgeousMetalRoomCell:handleJoinTeam(pvpTeamCell)
  self:PassEvent(PvpTeamCellEvent.Join, {self, pvpTeamCell})
end
function GorgeousMetalRoomCell:handleClickMember(param)
  self:PassEvent(PvpTeamCellEvent.ClickMember, {
    self,
    param[1],
    param[2]
  })
end
function GorgeousMetalRoomCell:SetData(data)
  self.data = data
  self.name.text = string.format(ZhString.GorgeouseMetalRoomCell_RoomTip, data.index)
  self.team1_Tip.text = data:GetTeamMemberNumByPos(1)
  self.team2_Tip.text = data:GetTeamMemberNumByPos(2)
  self.team3_Tip.text = data:GetTeamMemberNumByPos(3)
  self:UpdateButtonsActive()
  self.pvpTeamCtl:ResetDatas(self.data:GetRoomTeamList())
end
function GorgeousMetalRoomCell:UpdateButtonsActive()
  if self.data == nil then
    return
  end
  self:ActiveJoinButton(true)
  local myRoomId = PvpProxy.Instance:GetMyRoomGuid()
  local myRoomState = PvpProxy.Instance:GetMyRoomState(PvpProxy.Type.GorgeousMetal)
  local myRoomType = PvpProxy.Instance:GetMyRoomType()
  if myRoomId == self.data.guid and myRoomType == PvpProxy.Type.GorgeousMetal then
    if myRoomState == PvpProxy.RoomStatus.Fighting or myRoomState == PvpProxy.RoomStatus.Success or myRoomState == PvpProxy.RoomStatus.End then
      for key, go in pairs(self.buttonsMap) do
        go:SetActive(go == self.buttonsMap.enterButton)
      end
      self.name.text = ZhString.GorgeouseMetalRoomCell_MyRoomTip
      self:ActiveTeamFinghtSymbol(true)
    else
      local imleader = TeamProxy.Instance:CheckIHaveLeaderAuthority()
      if imleader then
        for key, go in pairs(self.buttonsMap) do
          go:SetActive(go == self.buttonsMap.leaveButton)
        end
      else
        for key, go in pairs(self.buttonsMap) do
          go:SetActive(go == self.buttonsMap.teamMemberTip)
        end
      end
      self:ActiveJoinButton(false)
      self:ActiveTeamFinghtSymbol(false)
    end
  else
    self:ActiveTeamFinghtSymbol(false)
    if self.data:IsFull() then
      for key, go in pairs(self.buttonsMap) do
        go:SetActive(go == self.buttonsMap.fullTip)
      end
    else
      for key, go in pairs(self.buttonsMap) do
        go:SetActive(go == self.buttonsMap.joinButton)
      end
      if myRoomState == PvpProxy.RoomStatus.Fighting or myRoomState == PvpProxy.RoomStatus.Success or myRoomState == PvpProxy.RoomStatus.End then
        self:ActiveJoinButton(false)
      end
    end
  end
end
function GorgeousMetalRoomCell:ActiveTeamFinghtSymbol(b)
  local cells = self.pvpTeamCtl:GetCells()
  for i = 1, #cells do
    cells[i]:ActiveFightSymbol(b)
  end
end
local tempColor = LuaColor.New(1, 1, 1, 1)
function GorgeousMetalRoomCell:ActiveJoinButton(b)
  local joinButton = self.buttonsMap.joinButton
  if joinButton then
    local sp = self:FindComponent("Background", UISprite)
    local label = self:FindComponent("Label", UILabel)
    if b then
      tempColor:Set(1, 1, 1, 1)
      sp.color = tempColor
      tempColor:Set(0.6666666666666666, 0.39215686274509803, 0.011764705882352941, 1)
      label.effectColor = tempColor
    else
      tempColor:Set(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
      sp.color = tempColor
      tempColor:Set(0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
      label.effectColor = tempColor
    end
  end
end
function GorgeousMetalRoomCell:RefreshRoomDetalInfo()
  if self.data then
    self:SetData(self.data)
  end
end
function GorgeousMetalRoomCell:Open()
  self.bg.height = 367
  self.roomDetailInfo:SetActive(true)
end
function GorgeousMetalRoomCell:Close()
  self.bg.height = 90
  self.roomDetailInfo:SetActive(false)
end
