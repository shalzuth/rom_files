FunctionTeam = class("FunctionTeam")
FunctionTeam.EndlessTowerID = 31
function FunctionTeam.Me()
  if nil == FunctionTeam.me then
    FunctionTeam.me = FunctionTeam.new()
  end
  return FunctionTeam.me
end
function FunctionTeam:ctor()
  self.canInviteFollow = true
end
function FunctionTeam:InviteMemberFollow()
  self:TryInviteMemberFollow()
end
function FunctionTeam:TryInviteMemberFollow(charid, follow)
  if TeamProxy.Instance:IHaveTeam() then
    local myTeam = TeamProxy.Instance.myTeam
    local memberlist = myTeam:GetMembersList()
    if #memberlist > 1 then
      self:DoInviteMemberFollow(charid, follow)
    else
      MsgManager.ShowMsgByIDTable(345)
    end
  end
end
function FunctionTeam:DoInviteMemberFollow(charid, follow)
  if follow == false then
    ServiceNUserProxy.Instance:CallInviteFollowUserCmd(charid, follow)
    return
  end
  if self.canInviteFollow then
    self.canInviteFollow = false
    MsgManager.ShowMsgByIDTable(342)
    ServiceNUserProxy.Instance:CallInviteFollowUserCmd(charid, follow)
    if self.inviteFollow_LT then
      self.inviteFollow_LT:cancel()
      self.inviteFollow_LT = nil
    end
    self.inviteFollow_LT = LeanTween.delayedCall(20, function()
      self.canInviteFollow = true
    end)
  else
    MsgManager.ShowMsgByIDTable(343)
  end
end
function FunctionTeam:MyTeamJobChange(newjob)
  if newjob ~= SessionTeam_pb.ETEAMJOB_LEADER or newjob ~= SessionTeam_pb.ETEAMJOB_TEMPLEADER then
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TEAMAPPLY)
    TeamProxy.Instance.myTeam:ClearApplyList()
  end
end
