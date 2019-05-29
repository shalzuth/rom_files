MainViewTeamPage = class("MainViewTeamPage", SubView)
autoImport("TMInfoCell")
local teamProxy
function MainViewTeamPage:Init()
  teamProxy = TeamProxy.Instance
  self:InitUI()
  self:MapViewListener()
end
function MainViewTeamPage:InitUI()
  local teamButton = self:FindGO("TeamButton")
  local rClickBg = teamButton:GetComponent(UISprite)
  FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.TeamMemberListPopUp.id, teamButton)
  self:AddClickEvent(teamButton, function(go)
    if not teamProxy:IHaveTeam() then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TeamFindPopUp
      })
    else
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TeamMemberListPopUp
      })
    end
  end)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TEAMAPPLY, teamButton, 42)
  local teamGrid = self:FindComponent("TeamGrid", UIGrid)
  self.teamCtl = UIGridListCtrl.new(teamGrid, TMInfoCell, "TMInfoCell")
  self.teamCtl:AddEventListener(MouseEvent.MouseClick, self.ClickTeamPlayer, self)
  self.playerTipStick = self:FindComponent("PlayerTipStick", UIWidget)
end
function MainViewTeamPage:ClickTeamPlayer(cellCtl)
  local data = cellCtl.data
  if data == MyselfTeamData.EMPTY_STATE then
    FunctionPlayerTip.Me():CloseTip()
    self.nowClickMember = nil
    if not teamProxy:IHaveTeam() then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TeamFindPopUp
      })
    else
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TeamInvitePopUp
      })
    end
  elseif data ~= nil then
    if self.nowClickMember ~= cellCtl then
      local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.playerTipStick, NGUIUtil.AnchorSide.Right)
      local funckeys
      if data.cat ~= nil and data.cat ~= 0 then
        funckeys = FunctionPlayerTip.Me():GetHireCatFunckey(data)
      else
        funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(data.id)
        table.insert(funckeys, "Double_Action")
      end
      local playerData = PlayerTipData.new()
      playerData:SetByTeamMemberData(data)
      local tipData = {
        playerData = playerData,
        funckeys = funckeys,
        callback = nil
      }
      playerTip:SetWhereIClickThisIcon(PlayerTipSource.FromTeam)
      playerTip:SetData(tipData)
      function playerTip.closecallback()
        self.nowClickMember = nil
      end
      playerTip:AddIgnoreBound(cellCtl.gameObject)
      self.nowClickMember = cellCtl
      local role = NSceneUserProxy.Instance:Find(data.id)
      if role == nil then
        role = NSceneNpcProxy.Instance:Find(data.id)
      end
      if role ~= nil then
        Game.Myself:Client_LockTarget(role)
      end
    else
      FunctionPlayerTip.Me():CloseTip()
      self.nowClickMember = nil
    end
  end
end
function MainViewTeamPage:UpdateTeamMember()
  if teamProxy.myTeam and nil == teamProxy.myTeam.hireMemberList_dirty then
    ServiceSessionTeamProxy.Instance:CallQueryMemberCatTeamCmd()
  end
  if teamProxy.myTeam then
    local memberlst = teamProxy.myTeam:GetMemberListWithAdd()
    if memberlst then
      self.teamCtl:ResetDatas(memberlst)
    end
  else
    self.teamCtl:ResetDatas({
      MyselfTeamData.EMPTY_STATE
    })
  end
end
function MainViewTeamPage:UpdateMemberPos()
  local cells = self.teamCtl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateMemberPos()
  end
end
function MainViewTeamPage:MapViewListener()
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamExchangeLeader, self.UpdateTeamMember)
  self:AddListenEvt(TeamEvent.MemberOffline, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamQuickEnter, self.HandleQuickEnter)
  self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd, self.HandleFollowStateChange)
  self:AddDispatcherEvt(FunctionFollowCaptainEvent.StateChanged, self.HandleFollowStateChange)
  EventManager.Me():AddEventListener(TeamEvent.VoiceChange, self.HandleVoiceChange, self)
  EventManager.Me():AddEventListener(TeamEvent.VoiceBan, self.HandleVoiceBan, self)
end
function MainViewTeamPage:HandleVoiceChange(note)
  if note then
    local members = self.teamCtl:GetCells()
    for _, member in pairs(members) do
      if member and member.id and tonumber(member.id) == tonumber(note.userId) then
        member.teamHead:UpdateVoice(note.showMic)
      end
    end
  else
    local members = self.teamCtl:GetCells()
    for _, member in pairs(members) do
      member.teamHead:UpdateVoice(false)
    end
  end
end
function MainViewTeamPage:HandleVoiceBan(note)
  if note then
    local members = self.teamCtl:GetCells()
    for _, member in pairs(members) do
      if member and member.id and tonumber(member.id) == tonumber(note.userId) then
        if note.ban == true then
          member.teamHead:SetVoiceBan(true)
        else
          member.teamHead:SetVoiceBan(false)
        end
      end
    end
  else
    local members = self.teamCtl:GetCells()
    for _, member in pairs(members) do
      member.teamHead:UpdateVoice(false)
    end
  end
end
function MainViewTeamPage:HandleQuickEnter(note)
  local members = self.teamCtl:GetCells()
  for _, member in pairs(members) do
    member:UpdateEmptyState()
  end
end
function MainViewTeamPage:HandleFollowStateChange(note)
  local members = self.teamCtl:GetCells()
  for _, member in pairs(members) do
    member:UpdateFollow()
  end
  self:BreakOrJoinHandTip()
end
function MainViewTeamPage:BreakOrJoinHandTip()
  local followId = Game.Myself:Client_GetFollowLeaderID()
  local isHandFollow = Game.Myself:Client_IsFollowHandInHand()
  local handFollowerId = Game.Myself:Client_GetHandInHandFollower()
  local handTargetId = isHandFollow and followId or handFollowerId
  if self.cacheHandTargetId == handTargetId then
    return
  end
  if 0 ~= handTargetId then
    if nil ~= self.cacheHandTargetName then
      MsgManager.ShowMsgByIDTable(886, self.cacheHandTargetName)
    end
    self.cacheHandTargetId = handTargetId
    local memberData = teamProxy.myTeam and teamProxy.myTeam:GetMemberByGuid(handTargetId)
    if memberData then
      self.cacheHandTargetName = memberData.name
      if nil ~= self.cacheHandTargetName then
        MsgManager.ShowMsgByIDTable(885, self.cacheHandTargetName)
      end
    else
      self.cacheHandTargetName = nil
    end
  elseif nil ~= self.cacheHandTargetId then
    if nil ~= self.cacheHandTargetName then
      MsgManager.ShowMsgByIDTable(886, self.cacheHandTargetName)
    end
    self.cacheHandTargetId = nil
    self.cacheHandTargetName = nil
  end
end
function MainViewTeamPage:OnEnter()
  MainViewTeamPage.super.OnEnter(self)
  self:UpdateTeamMember()
end
