autoImport("TeamMembersCell")
local BaseCell = autoImport("BaseCell")
TeamCell = class("TeamCell", BaseCell)
function TeamCell:Init()
  self.goal = self:FindComponent("Goal", UILabel)
  self.level = self:FindComponent("Level", UILabel)
  self.teamName = self:FindComponent("TeamName", UILabel)
  self.teamDesc = self:FindComponent("TeamDescLab", UILabel)
  self.memberNum = self:FindComponent("MemberNum", UILabel)
  self.applyBtn = self:FindGO("ApplyButton")
  self.applyLabel = self:FindComponent("Label", UILabel, self.applyBtn)
  self.applyLabel.text = ZhString.TeamCell_Apply
  self.countDownLab = self:FindComponent("CountDownLab", UILabel)
  self.zoneid = self:FindComponent("Zone", UILabel)
  self:AddClickEvent(self.applyBtn, function(go)
    self:OnClickApplyBtn()
  end)
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.listGrid = self:FindComponent("MemberGrid", UIGrid)
  self.memberlist = UIGridListCtrl.new(self.listGrid, TeamMembersCell, "TeamMembersCell")
end
local memberDatas = {}
function TeamCell:UpdateMemberList()
  self:Show(self.listGrid)
  local memberList = TeamProxy.Instance:GetTeamMembers(self.data.id) or {}
  self.memberlist:ResetDatas(memberList)
end
function TeamCell:CountDown(createTime)
  if not createTime then
    self:SetApplyButton(true)
    self:ClearTick()
    self:Hide(self.countDownLab)
    return
  end
  self.createTime = createTime
  self:ClearTick()
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.funcCountDown, self)
end
function TeamCell:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
  end
end
function TeamCell:OnDestroy()
  self:ClearTick()
end
function TeamCell:funcCountDown()
  if self:ObjIsNil(self.gameObject) then
    self:ClearTick()
    return
  end
  local duringTime = GameConfig.Team.applyovertime - (ServerTime.CurServerTime() / 1000 - self.createTime)
  if duringTime > 0 then
    self:Show(self.countDownLab)
    self.countDownLab.text = string.format(ZhString.TeamCell_Applying, ClientTimeUtil.GetFormatSecTimeStr(duringTime))
    self:SetApplyButton(false)
  else
    self:Hide(self.countDownLab)
    self:ClearTick()
    TeamProxy.Instance:RemoveApply(self.data.id)
    self:SetApplyButton(true)
  end
end
function TeamCell:SetApplyButton(applyed)
  self.applyStatus = applyed
  local hasTeam = TeamProxy.Instance:IHaveTeam()
  if hasTeam then
    self:Hide(self.applyBtn)
  else
    self:Show(self.applyBtn)
    self.applyLabel.text = applyed and ZhString.TeamCell_Apply or ZhString.TeamCell_CancelApply
  end
end
function TeamCell:OnClickApplyBtn()
  if self.data then
    if self.applyStatus then
      if TeamProxy.Instance:GetUserApplyCt() >= GameConfig.Team.maxapplycount then
        MsgManager.ShowMsgByID(362)
        return
      end
      ServiceSessionTeamProxy.Instance:CallTeamMemberApply(self.data.id)
    else
      MsgManager.ConfirmMsgByID(370, function()
        ServiceSessionTeamProxy.Instance:CallCancelApplyTeamCmd(self.data.id)
      end)
    end
  end
end
function TeamCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    if data.type and Table_TeamGoals[data.type] then
      self.goal.text = Table_TeamGoals[data.type].NameZh
    end
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    local islvOutRange = mylv < data.minlv or mylv > data.maxlv
    if islvOutRange then
      self.level.text = string.format("[c][ff0000]Lv.%s ~ Lv.%s[-][/c]", tostring(data.minlv), tostring(data.maxlv))
    else
      self.level.text = string.format("Lv.%s ~ Lv.%s", tostring(data.minlv), tostring(data.maxlv))
    end
    self.teamName.text = data.name
    self.teamDesc.text = data.desc
    local leader = data:GetLeader()
    if leader then
      local leaderzone = ChangeZoneProxy.Instance:ZoneNumToString(leader.zoneid)
      self.zoneid.gameObject:SetActive(leaderzone ~= "" and leader.zoneid ~= MyselfProxy.Instance:GetZoneId())
      self.zoneid.text = leaderzone
    end
    local membercount = data.membercount or 1
    self.memberNum.text = string.format("%d/%d", membercount, GameConfig.Team.maxmember)
  else
    self.gameObject:SetActive(false)
  end
end
