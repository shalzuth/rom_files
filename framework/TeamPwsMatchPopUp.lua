TeamPwsMatchPopUp = class("TeamPwsMatchPopUp", BaseView)
TeamPwsMatchPopUp.ViewType = UIViewType.PopUpLayer
TeamPwsMatchPopUp.Instance = nil
TeamPwsMatchPopUp.Anchor = nil
function TeamPwsMatchPopUp.Show(pvpType)
  if not TeamPwsMatchPopUp.Instance then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamPwsMatchPopUp,
      viewdata = {pvptype = pvpType}
    })
    return
  end
  if TeamPwsMatchPopUp.Instance.isShow then
    return
  end
  if TeamPwsMatchPopUp.Anchor and TeamPwsMatchPopUp.Anchor.gameObject.activeInHierarchy then
    TeamPwsMatchPopUp.Instance.gameObject.transform.localScale = Vector3.zero
    TeamPwsMatchPopUp.Instance.gameObject.transform.position = TeamPwsMatchPopUp.Anchor.position
    TweenPosition.Begin(TeamPwsMatchPopUp.Instance.gameObject, 0.2, Vector3.zero)
    TweenScale.Begin(TeamPwsMatchPopUp.Instance.gameObject, 0.2, Vector3.one)
  else
    TeamPwsMatchPopUp.Instance.gameObject.transform.localPosition = Vector3.zero
    TeamPwsMatchPopUp.Instance.gameObject.transform.localScale = Vector3.one
  end
  if pvpType then
    TeamPwsMatchPopUp.Instance.pvpType = pvpType
  end
  TeamPwsMatchPopUp.Instance:OnShow()
  TeamPwsMatchPopUp.Instance.isShow = true
end
function TeamPwsMatchPopUp.Hide()
  if not TeamPwsMatchPopUp.Instance or not TeamPwsMatchPopUp.Instance.isShow then
    return
  end
  if TeamPwsMatchPopUp.Anchor and TeamPwsMatchPopUp.Anchor.gameObject.activeInHierarchy then
    TweenPosition.Begin(TeamPwsMatchPopUp.Instance.gameObject, 0.2, TeamPwsMatchPopUp.Anchor.position).worldSpace = true
  end
  TweenScale.Begin(TeamPwsMatchPopUp.Instance.gameObject, 0.2, Vector3.zero)
  TeamPwsMatchPopUp.Instance:OnHide()
  TeamPwsMatchPopUp.Instance.isShow = false
end
function TeamPwsMatchPopUp:Init()
  if TeamPwsMatchPopUp.Instance then
    self:CloseSelf()
    return
  end
  TeamPwsMatchPopUp.Instance = self
  self:FindObjs()
  self:AddButtonEvts()
  self:AddEvts()
  TeamPwsMatchPopUp.Show(self.viewdata.viewdata.pvptype)
end
function TeamPwsMatchPopUp:FindObjs()
  self.objLayoutLeader = self:FindGO("layoutLeader")
  self.objLayoutMember = self:FindGO("layoutMember")
  self.labTime = self:FindComponent("labTime", UILabel)
  self.labMatching = self:FindComponent("labMatching", UILabel)
end
function TeamPwsMatchPopUp:AddButtonEvts()
  self:AddClickEvent(self:FindGO("btnCancel"), function()
    self:ClickBtnCancel()
  end)
  self:AddClickEvent(self:FindGO("Mask"), function()
    TeamPwsMatchPopUp.Hide()
  end)
end
function TeamPwsMatchPopUp:AddEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.HandleNtfMatchInfoCCmd)
  self:AddListenEvt(ServiceEvent.MatchCCmdTeamPwsPreInfoMatchCCmd, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.SetLayout)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.CloseSelf)
  self:AddListenEvt(PVEEvent.ExpRaid_Launch, self.CloseSelf)
end
function TeamPwsMatchPopUp:SetLayout()
  self.labMatching.text = PvpProxy.Instance:GetTypeName()
  local bImLeader = not TeamProxy.Instance:IHaveTeam() or TeamProxy.Instance:CheckIHaveLeaderAuthority()
  self.objLayoutLeader:SetActive(bImLeader)
  self.objLayoutMember:SetActive(not bImLeader)
end
function TeamPwsMatchPopUp:HandleNtfMatchInfoCCmd(note)
  if note.body.etype == self.pvpType and note.body.ismatch then
    self:CountMatchingTime()
  else
    self:CloseSelf()
  end
end
function TeamPwsMatchPopUp:CountMatchingTime()
  TimeTickManager.Me():ClearTick(self, 1)
  self.startMatchTime = PvpProxy.Instance:GetStartMatchTime(self.pvpType)
  if self.startMatchTime then
    TimeTickManager.Me():CreateTick(0, 250, self.UpdateMatchingTime, self, 1)
  else
    self.labTime.text = "-"
  end
end
function TeamPwsMatchPopUp:ClickBtnCancel()
  if TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:CheckIHaveLeaderAuthority() or self.disableClick then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallLeaveRoomCCmd(self.pvpType)
  self.disableClick = true
  self.ltDisableClick = LeanTween.delayedCall(3, function()
    self.disableClick = false
    self.ltDisableClick = nil
  end)
end
function TeamPwsMatchPopUp:UpdateMatchingTime()
  local matchingTime = (ServerTime.CurServerTime() - self.startMatchTime) / 1000
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(matchingTime)
  self.labTime.text = string.format("%02d:%02d", min, sec)
end
function TeamPwsMatchPopUp:OnShow()
  self.super.OnShow(self)
  self:SetLayout()
  self:CountMatchingTime()
end
function TeamPwsMatchPopUp:OnHide()
  TimeTickManager.Me():ClearTick(self, 1)
  self.super.OnHide(self)
end
function TeamPwsMatchPopUp:OnExit()
  TimeTickManager.Me():ClearTick(self, 1)
  if self.ltDisableClick then
    self.ltDisableClick:cancel()
    self.ltDisableClick = nil
  end
  TeamPwsMatchPopUp.Instance = nil
  self.super.OnExit(self)
end
