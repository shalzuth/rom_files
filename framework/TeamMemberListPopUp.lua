TeamMemberListPopUp = class("TeamMemberListPopUp", ContainerView)
TeamMemberListPopUp.ViewType = UIViewType.NormalLayer
autoImport("TeamMemberCell")
function TeamMemberListPopUp:Init()
  self:InitView()
  self:MapEvent()
end
function TeamMemberListPopUp:InitView()
  self.teamName = self:FindComponent("TeamName", UILabel)
  self.pickUpMode = self:FindComponent("PickUpMode", UILabel)
  self.pickUpMode.gameObject:SetActive(GameConfig.SystemForbid.TeamPickUpMode == nil)
  local reposition = self:FindComponent("TLReposition", UIGrid)
  reposition.repositionNow = true
  self.teamLevel = self:FindComponent("TeamLevel", UILabel)
  local listGrid = self:FindComponent("MemberGrid", UIGrid)
  self.memberlist = UIGridListCtrl.new(listGrid, TeamMemberCell, "TeamMemberCell")
  self.memberlist:AddEventListener(MouseEvent.MouseClick, self.ClickTeamMember, self)
  local applyPageButton = self:FindGO("ApplyListButton")
  self.applyPageButton = applyPageButton:GetComponent(UIButton)
  self:AddClickEvent(applyPageButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamApplyListPopUp
    })
  end)
  local applyPageButtonBg = applyPageButton:GetComponent(UISprite)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TEAMAPPLY, applyPageButtonBg, 25)
  local findTeamBtn = self:FindGO("FindTeamBtn")
  self:AddClickEvent(findTeamBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamFindPopUp
    })
  end)
  local leaveButton = self:FindGO("LeaveTeamButton")
  self:AddClickEvent(leaveButton, function(go)
    FunctionPlayerTip.LeaverTeam()
  end)
  local inviteMemberButton = self:FindGO("InviteMemberButton")
  self.inviteMemberButton = inviteMemberButton:GetComponent(UIButton)
  self:AddClickEvent(inviteMemberButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamInvitePopUp
    })
  end)
  self.optionButton = self:FindGO("OptionButton")
  self:AddClickEvent(self.optionButton, function(go)
    local viewData = {
      goal = TeamProxy.Instance.myTeam.type,
      ispublish = false
    }
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamOptionPopUp,
      viewdata = viewData
    })
  end)
  self.inviteAllButton = self:FindGO("InviteAllFollowButton")
  self:AddClickEvent(self.inviteAllButton, function()
    FunctionTeam.Me():InviteMemberFollow()
  end)
  self.autoFollowTog = self:FindComponent("AutoFollowTog", UIToggle)
  self:AddClickEvent(self.autoFollowTog.gameObject, function()
    local togValue = self.autoFollowTog.value
    local myMemberData = TeamProxy.Instance:GetMyTeamMemberData()
    local isautoFollow = myMemberData.autofollow == 1
    if togValue ~= isautoFollow then
      helplog("CallSetMemberOptionTeamCmd", togValue)
      ServiceSessionTeamProxy.Instance:CallSetMemberOptionTeamCmd(togValue)
    end
  end)
end
function TeamMemberListPopUp:ClickTeamMember(cellCtl)
  if cellCtl ~= self.nowCell then
    local clickMy = cellCtl.data.id == Game.Myself.data.id
    if not clickMy then
      self.nowCell = cellCtl
      local memberData = cellCtl.data
      local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.bg, NGUIUtil.AnchorSide.TopRight, {-70, 14})
      local playerData = PlayerTipData.new()
      playerData:SetByTeamMemberData(memberData)
      local funckeys
      if memberData.cat ~= nil and memberData.cat ~= 0 then
        funckeys = FunctionPlayerTip.Me():GetHireCatFunckey(memberData)
      else
        funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(memberData.id)
      end
      local tipData = {playerData = playerData, funckeys = funckeys}
      playerTip:SetData(tipData)
      playerTip:AddIgnoreBound(cellCtl.portraitCell.gameObject)
      function playerTip.closecallback()
        self.nowCell = nil
      end
      function playerTip.clickcallback(funcConfig)
        if funcConfig.key == "LeaverTeam" then
          self:CloseSelf()
        end
      end
    else
      FunctionPlayerTip.Me():CloseTip()
      self.nowCell = nil
    end
  else
    FunctionPlayerTip.Me():CloseTip()
    self.nowCell = nil
  end
end
function TeamMemberListPopUp:OnEnter()
  TeamMemberListPopUp.super.OnEnter(self)
  self:UpdateTeamInfo()
  self:UpdateMemberList()
end
function TeamMemberListPopUp:UpdateTeamInfo()
  if TeamProxy.Instance:IHaveTeam() then
    local myTeam = TeamProxy.Instance.myTeam
    self.teamName.text = myTeam:GetStrStatus()
    local type, goalStr = myTeam.type, nil
    if type and Table_TeamGoals[type] then
      goalStr = Table_TeamGoals[type].NameZh
    end
    self.teamLevel.text = string.format("%s[%s~%s]", tostring(goalStr), tostring(myTeam.minlv), tostring(myTeam.maxlv))
    local pickUpMode = myTeam.pickupmode or 0
    if pickUpMode == 0 then
      self.pickUpMode.text = ZhString.TeamMemberListPopUp_FreePick
    elseif pickUpMode == 1 then
      self.pickUpMode.text = ZhString.TeamMemberListPopUp_RandomPick
    end
    local leaderAuthority = TeamProxy.Instance:CheckIHaveLeaderAuthority()
    self.applyPageButton.gameObject:SetActive(leaderAuthority)
    self.inviteMemberButton.gameObject:SetActive(leaderAuthority)
    self.optionButton.gameObject:SetActive(leaderAuthority)
    self.inviteAllButton.gameObject:SetActive(leaderAuthority)
    self.autoFollowTog.gameObject:SetActive(not leaderAuthority)
    local myMemberData = TeamProxy.Instance:GetMyTeamMemberData()
    if myMemberData then
      self.autoFollowTog.value = myMemberData.autofollow == 1
    else
      self.autoFollowTog.value = false
    end
  end
end
local memberDatas = {}
function TeamMemberListPopUp:UpdateMemberList()
  if TeamProxy.Instance:IHaveTeam() then
    local myTeam = TeamProxy.Instance.myTeam
    local memberList = myTeam:GetMembersList()
    TableUtility.ArrayClear(memberDatas)
    for i = 1, #memberList do
      table.insert(memberDatas, memberList[i])
    end
    if #memberDatas < GameConfig.Team.maxmember then
      table.insert(memberDatas, MyselfTeamData.EMPTY_STATE)
    end
    self.memberlist:ResetDatas(memberDatas)
  else
    self.memberlist:ResetDatas({})
  end
end
function TeamMemberListPopUp:MapEvent()
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.HandleEnterTeam)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateTeamInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateMemberList)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateMemberList)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.HandleExitTeam)
  self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd, self.UpdateMemberList)
end
function TeamMemberListPopUp:HandleEnterTeam(note)
  self:UpdateTeamInfo()
  self:UpdateMemberList()
end
function TeamMemberListPopUp:HandleExitTeam(note)
  self:CloseSelf()
end
function TeamMemberListPopUp:OnExit()
  self.memberlist:ResetDatas({})
  TeamMemberListPopUp.super.OnExit(self)
  FunctionPlayerTip.Me():CloseTip()
end
