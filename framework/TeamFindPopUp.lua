TeamFindPopUp = class("TeamFindPopUp", ContainerView)
TeamFindPopUp.ViewType = UIViewType.NormalLayer
autoImport("TeamCell")
autoImport("TeamGoalCombineCell")
local COLOR_GRAY = ColorUtil.TitleGray
local COLOR_BLUE = ColorUtil.TitleBlue
local MATCH_TEXTURE = "TeamBg_"
local RED_FORMAT = "[c][FF0000]%s[-][/c]"
function TeamFindPopUp:Init()
  self:InitUI()
  self:AddEvts()
  self:AddViewInerest()
end
function TeamFindPopUp:InitUI()
  local filter = self:FindComponent("LevelPopUpFilter", UIPopupList)
  local minlvOption = {0}
  local filterlvConfig = GameConfig.Team.filtratelevel
  local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  for i = 1, #filterlvConfig do
    if mylv >= filterlvConfig[i] then
      table.insert(minlvOption, filterlvConfig[i])
    end
  end
  for i = 1, #minlvOption do
    local minlv = minlvOption[i]
    if minlv == 0 then
      filter:AddItem(ZhString.TeamFindPopUp_NoneFilterLevel, 0)
    else
      filter:AddItem(string.format(ZhString.TeamFindPopUp_StartLevel, minlv), minlv)
    end
  end
  self.filterlevel = 0
  self.filterzone = 0
  EventDelegate.Add(filter.onChange, function()
    if self.filterlevel ~= filter.data then
      self.filterlevel = filter.data
      self:CallTeamList(1, true)
    end
  end)
  local zonefilter = self:FindComponent("ZonePopUpFilter", UIPopupList)
  zonefilter:AddItem(ZhString.TeamFindPopUp_AllZone, 0)
  zonefilter:AddItem(ZhString.TeamFindPopUp_CurrentZone, 1)
  zonefilter:AddItem(ZhString.TeamFindPopUp_OthersZone, 2)
  EventDelegate.Add(zonefilter.onChange, function()
    if self.filterzone ~= zonefilter.data then
      self.filterzone = zonefilter.data
      self:CallTeamList(1, true)
    end
  end)
  local goalslist = self:FindComponent("GoalsTabel", UITable)
  self.goalListCtl = UIGridListCtrl.new(goalslist, TeamGoalCombineCell, "TeamGoalCombineCell")
  self.goalListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self)
  self.teamTable = self:FindComponent("TeamList", UITable)
  self.teamListCtl = UIGridListCtrl.new(self.teamTable, TeamCell, "TeamCell")
  self.teamListCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickTeamCell, self)
  self.noteamtip = self:FindGO("NoTeamTip")
  OverseaHostHelper:FixLabelOverV1(self.noteamtip:GetComponent(UILabel), 3, 280)
  local scrollView = self:FindComponent("TeamsScroll", UIScrollView)
  scrollView.momentumAmount = 100
  NGUIUtil.HelpChangePageByDrag(scrollView, function()
    if self.nowPage then
      local page = math.max(self.nowPage - 1, 1)
      self:CallTeamList(page)
    end
  end, function()
    if self.nowPage then
      local page = self.nowPage + 1
      if self.maxPage then
        page = math.min(self.maxPage, page)
      end
      self:CallTeamList(page)
    end
  end, 120)
  self.createTeamBtn = self:FindGO("CreateTeamButton")
  self.quickEntering = self:FindGO("Entering")
  self.quickNone = self:FindGO("None")
  self.normalPos = self:FindGO("NormalPos")
  self.matchPos = self:FindGO("MatchPos")
  self.matchBg = self:FindGO("MatchBg")
  self.normalMatchTog = self:FindComponent("NormalMatchTog", UIToggle)
  local normalLab = self:FindComponent("NormalMatchTog", UILabel)
  normalLab.text = ZhString.TeamFindPopUp_Title_Normal
  self.randomMatchTog = self:FindComponent("RandomMatchTog", UIToggle)
  local randomMatchLab = self:FindComponent("RandomMatchTog", UILabel)
  randomMatchLab.text = ZhString.TeamFindPopUp_Title_Random
  self.matchBgTex = self:FindComponent("MatchBgTexture", UITexture)
  self.randomMatchDesc = self:FindComponent("RandomMatchDesc", UILabel)
  self.createTeamBtn:SetActive(not TeamProxy.Instance:IHaveTeam())
  self.applyCtLab = self:FindComponent("ApplyCount", UILabel)
  self.goalScrollView = self:FindComponent("GoalsScrollView", UIScrollView)
  local matchTitle = self:FindComponent("MatchTitle", UILabel)
  matchTitle.text = ZhString.TeamFindPopUp_Title_Set
  normalLab.fontSize = 19
  randomMatchLab.fontSize = 19
  OverseaHostHelper:FixLabelOverV1(normalLab, 3, 150)
  OverseaHostHelper:FixLabelOverV1(randomMatchLab, 2, 150)
end
function TeamFindPopUp:AddEvts()
  self:AddClickEvent(self.createTeamBtn, function(go)
    self:CreateTeam()
  end)
  self:AddButtonEvent("QuickEnterButton", function(go)
    local isEnter = TeamProxy.Instance:IsQuickEntering()
    ServiceSessionTeamProxy.Instance:CallQuickEnter(self.goal, nil, not isEnter)
  end)
  self:AddButtonEvent("RefreshButton", function(go)
    local now = Time.unscaledTime
    if self._refreshTime == nil or now - self._refreshTime >= 3 then
      self._refreshTime = now
      self:CallTeamList(1, true)
    else
      MsgManager.ShowMsgByID(3210)
    end
  end)
  self:AddButtonEvent("InviteMemberButton", function(go)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamInvitePopUp
    })
  end)
  self:AddButtonEvent("MatchBtn", function(go)
    self:OnClickMatch()
  end)
  self:AddButtonEvent("PublishBtn", function(go)
    local nextGoal = self.goal + 1
    nextGoalType = Table_TeamGoals[nextGoal] and Table_TeamGoals[nextGoal].type
    local goalType = self.goal and Table_TeamGoals[self.goal]
    if goalType and nextGoalType and goalType.type == self.goal and nextGoalType == goalType.type then
      MsgManager.ShowMsgByID(360)
      return
    end
    if TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:CheckImTheLeader() then
      MsgManager.ShowMsgByID(364)
      return
    end
    local viewData = {
      goal = self.goal,
      ispublish = true
    }
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamOptionPopUp,
      viewdata = viewData
    })
  end)
  self:AddToggleChange(self.normalMatchTog, self.OnToggleChange, false)
  self:AddToggleChange(self.randomMatchTog, self.OnToggleChange, true)
end
function TeamFindPopUp:AddToggleChange(toggle, handler, param)
  EventDelegate.Add(toggle.onChange, function()
    local label = toggle.gameObject:GetComponent(UILabel)
    if toggle.value then
      label.color = COLOR_BLUE
      if handler ~= nil then
        handler(self, param)
      end
    else
      label.color = COLOR_GRAY
    end
  end)
end
function TeamFindPopUp:OnClickMatch()
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
    return
  end
  local raidMatchId = self.goal and Table_TeamGoals[self.goal] and Table_TeamGoals[self.goal].RaidType
  local sData = raidMatchId and Table_MatchRaid and Table_MatchRaid[raidMatchId]
  if not sData then
    MsgManager.ShowMsgByID(360)
    return
  end
  if not TeamProxy.Instance:CheckMatchValid(raidMatchId) then
    return
  end
  if PvpProxy.Instance:CheckMatchValid(sData.Type, sData.RaidConfigID) then
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(sData.Type, sData.RaidConfigID)
    self:CloseSelf()
  end
end
function TeamFindPopUp:CallTeamList(page, init)
  if init then
    self.prePage = nil
    self.nowPage = 1
  else
    self.prePage = self.nowPage
    self.nowPage = page
  end
  ServiceSessionTeamProxy.Instance:CallTeamList(self.goal, self.nowPage, self.filterlevel, self.filterzone)
end
function TeamFindPopUp:OnEnter()
  TeamFindPopUp.super.OnEnter(self)
  self:OnToggleChange(false)
  self:UpdateQuickEnterState()
end
function TeamFindPopUp:HandleApplyCt()
  local leftCt = GameConfig.Team.maxapplycount - TeamProxy.Instance:GetUserApplyCt()
  self.applyCtLab.text = string.format(ZhString.TeamFindPopUp_ApplyFormat, leftCt, GameConfig.Team.maxapplycount)
  local cells = self.teamListCtl:GetCells()
  for i = 1, #cells do
    local ctDate = TeamProxy.Instance:GetUserApply(cells[i].data.id)
    cells[i]:CountDown(ctDate)
  end
end
function TeamFindPopUp:OnToggleChange(match)
  self.isRandomMatch = match
  if match then
    self.startGoal = GameConfig.Team.defaultmatchtype
  elseif self.viewdata and self.viewdata.viewdata then
    self.startGoal = self.viewdata.viewdata.goalid
  else
    self.startGoal = GameConfig.Team.defaultpublishtype
  end
  self.goalScrollView:ResetPosition()
  self.normalPos:SetActive(not match)
  self.matchPos:SetActive(match)
  self:_resetCurCombine()
  local goals = TeamProxy.Instance:GetTeamGoals(match)
  table.sort(goals, function(a, b)
    return a.fatherGoal.id < b.fatherGoal.id
  end)
  self.goalListCtl:ResetDatas(goals)
  local goalCells = self.goalListCtl:GetCells()
  if goalCells and #goalCells > 0 then
    for i = 1, #goalCells do
      local goalData = goalCells[i].data
      if goalData and goalData.fatherGoal.id == self.startGoal then
        goalCells[i]:ClickFather()
        break
      end
    end
  end
end
function TeamFindPopUp:OnClickTeamCell(cellctl)
  local data = cellctl and cellctl.data
  if data then
    local cell = self:GetTeamCell(data.id)
    if not cell then
      return
    end
    if cell.listGrid.gameObject.activeSelf then
      cell.listGrid.gameObject:SetActive(false)
    else
      local members = TeamProxy.Instance:GetTeamMembers(data.id)
      if members and #members > 0 then
        cell:UpdateMemberList()
      else
        ServiceSessionTeamProxy.Instance:CallQueryMemberTeamCmd(data.id)
      end
    end
    self.teamTable:Reposition()
  end
end
function TeamFindPopUp:UpdateQuickEnterState()
  local isEntering = TeamProxy.Instance:IsQuickEntering()
  self.quickEntering:SetActive(isEntering)
  self.quickNone:SetActive(not isEntering)
end
function TeamFindPopUp:HandleQueryMemberTeam(note)
  local data = note.body
  if not data then
    return
  end
  local cell = self:GetTeamCell(data.teamid)
  if cell then
    cell:UpdateMemberList()
  end
  self.teamTable:Reposition()
  self.teamListCtl:Layout()
end
function TeamFindPopUp:GetTeamCell(id)
  local cells = self.teamListCtl:GetCells()
  for i = 1, #cells do
    if cells[i].data.id == id then
      return cells[i]
    end
  end
end
local defaulTeamDesc = GameConfig.Team.defaulTeamDesc or "%s\229\137\175\230\156\172\229\188\128\231\187\132"
function TeamFindPopUp:CreateTeam(state)
  local teamState = state or SessionTeam_pb.ETEAMSTATE_FREE
  local teamDesc
  local defaultname = Game.Myself.data.name .. GameConfig.Team.teamname
  local filterType = GameConfig.MaskWord.TeamName
  local accept = self.accept or GameConfig.Team.defaultauto
  if FunctionMaskWord.Me():CheckMaskWord(defaultname, filterType) then
    defaultname = Game.Myself.data.name .. "_" .. GameConfig.Team.teamname
  end
  local filtratelevel = GameConfig.Team.filtratelevel
  local defaultMinlv, defaultMaxlv = filtratelevel[1], filtratelevel[#filtratelevel]
  local goal = state == nil and GameConfig.Team.defaulttype or self.goal
  local typeName = Table_TeamGoals[goal].NameZh
  teamDesc = goal == GameConfig.Team.defaulttype and typeName or string.format(defaulTeamDesc, typeName)
  if goal then
    local goalData = Table_TeamGoals[goal]
    if goalData and goalData.SetShow == 0 then
      if goalData.Filter == 10 then
        goal = 10010
      elseif goalData.SetShow == 0 then
        goal = goalData.type
      end
    end
  end
  ServiceSessionTeamProxy.Instance:CallCreateTeam(defaultMinlv, defaultMaxlv, goal, accept, defaultname, teamState, teamDesc)
end
function TeamFindPopUp:_resetCurCombine()
  if self.combineGoal then
    self.combineGoal:SetChoose(false)
    self.combineGoal:SetFolderState(false)
    self.combineGoal = nil
  end
end
function TeamFindPopUp:ResetTeamMembers()
  local cells = self.teamListCtl:GetCells()
  if cells then
    for i = 1, #cells do
      self:Hide(cells[i].listGrid)
    end
    self.teamListCtl:Layout()
  end
end
function TeamFindPopUp:ClickGoal(parama)
  self:ResetTeamMembers()
  if "Father" == parama.type then
    local combine = parama.combine
    if combine == self.combineGoal then
      combine:PlayReverseAnimation()
      return
    end
    self:_resetCurCombine()
    self.combineGoal = combine
    self.combineGoal:PlayReverseAnimation()
    self.fatherGoalId = combine.data.fatherGoal.id
    self.goal = self.fatherGoalId
  elseif parama.child and parama.child.data then
    self.goal = parama.child.data.id
  else
    self.goal = self.fatherGoalId
  end
  if not self.isRandomMatch then
    self:CallTeamList(1, true)
  else
    local raidMatchId = Table_TeamGoals[self.goal].RaidType
    if raidMatchId then
      local choosenName = Table_TeamGoals[self.goal].NameZh
      local lvLimited = Table_MatchRaid[raidMatchId].EnterLevel
      local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
      if lvLimited > mylv then
        lvLimited = string.format(RED_FORMAT, lvLimited)
      end
      self.randomMatchDesc.text = string.format(ZhString.TeamFindPopUp_RandomMatchTeamDesc, choosenName, lvLimited)
      self:Show(self.matchBg)
    else
      self:Hide(self.matchBg)
    end
    local bgTxName = MATCH_TEXTURE .. tostring(Table_TeamGoals[self.goal].type)
    PictureManager.Instance:SetUI(bgTxName, self.matchBgTex)
  end
end
function TeamFindPopUp:AddViewInerest()
  self:AddListenEvt(ServiceEvent.SessionTeamTeamList, self.HandleUpdateTeamList)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.HandleEnterTeam)
  self:AddListenEvt(ServiceEvent.SessionTeamQuickEnter, self.UpdateQuickEnterState)
  self:AddListenEvt(ServiceEvent.SessionTeamQueryMemberTeamCmd, self.HandleQueryMemberTeam)
  self:AddListenEvt(ServiceEvent.SessionTeamUserApplyUpdateTeamCmd, self.HandleApplyCt)
end
function TeamFindPopUp:HandleEnterTeam(note)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamMemberListPopUp
  })
end
function TeamFindPopUp:HandleUpdateTeamList()
  local datas = TeamProxy.Instance:GetAroundTeamList() or {}
  if self.prePage then
    if #datas > 0 then
      if self.nowPage < self.prePage then
        for i = #datas, 1, -1 do
          self.teamListCtl:AddCell(datas[i], 1)
        end
      elseif self.prePage < self.nowPage then
        for i = 1, #datas do
          self.teamListCtl:AddCell(datas[i])
        end
      end
    else
      self.nowPage = self.prePage
      self.maxPage = self.nowPage
    end
  elseif self.nowPage then
    self.teamListCtl:ResetDatas(datas)
    self.teamListCtl:Layout()
  end
  self.noteamtip:SetActive(#self.teamListCtl:GetCells() == 0)
  self:HandleApplyCt()
end
function TeamFindPopUp:OnExit()
  TeamFindPopUp.super.OnExit(self)
  PictureManager.Instance:UnLoadUI()
  TeamProxy.Instance:ClearTeamMembers()
end
