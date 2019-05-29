autoImport("TeamPwsMemberCell")
autoImport("TeamPwsRankPopUp")
TeamPwsView = class("TeamPwsView", SubView)
local teamPwsView_Path = ResourcePathHelper.UIView("TeamPwsView")
TeamPwsView.TexUp = "pvp_bg_06"
TeamPwsView.TexSeason = "pvp_icon_season_1"
local T_PVP_TYPE
function TeamPwsView:Init()
  local roomID, pwsConfig = next(GameConfig.PvpTeamRaid)
  self.pwsConfig = pwsConfig
  self.roomID = roomID
  T_PVP_TYPE = PvpProxy.Type.TeamPws
  self:FindObjs()
  self:AddBtnEvts()
  self:AddViewEvts()
  self:InitShow()
end
function TeamPwsView:FindObjs()
  self:LoadSubView()
  local gridMember = self:FindComponent("memberGrid", UIGrid, self.objRoot)
  self.listMember = UIGridListCtrl.new(gridMember, TeamPwsMemberCell, "TeamPwsMemberCell")
  self.labFightCountInfo = self:FindComponent("labFightCountInfo", UILabel, self.objRoot)
  self.labEventCountDown = self:FindComponent("labEventCountDown", UILabel, self.objRoot)
  self.labWeekCount = self:FindComponent("labWeekCount", UILabel, self.objRoot)
  self.objMyLevel = self:FindGO("sprLabMyLevel", self.objRoot)
  self.labMyScore = self:FindComponent("labMyScore", UILabel, self.objRoot)
  self.labTeamScore = self:FindComponent("labTeamScore", UILabel, self.objRoot)
  self.objLowLevel = self:FindGO("labLowLevel", self.objRoot)
  self.objEmptyTeam = self:FindGO("EmptyTeam", self.objRoot)
  self.objBtnMatch = self:FindGO("MatchBtn", self.objRoot)
  self.colBtnMatch = self.objBtnMatch:GetComponent(BoxCollider)
  self.sprBtnMatch = self:FindComponent("BG", UISprite, self.objBtnMatch)
  self.objEnableMatchBtnLabel = self:FindGO("enableLabel", self.objBtnMatch)
  self.objDisableMatchBtnLabel = self:FindGO("disableLabel", self.objBtnMatch)
  OverseaHostHelper:FixLabelOverV1(self.objDisableMatchBtnLabel:GetComponent(UILabel), 3, 180)
  OverseaHostHelper:FixLabelOverV1(self.objEnableMatchBtnLabel:GetComponent(UILabel), 3, 180)
end
function TeamPwsView:LoadSubView()
  self.objRoot = self:FindGO("TeamPwsView")
  local obj = self:LoadPreferb_ByFullPath(teamPwsView_Path, self.objRoot, true)
  obj.name = "TeamPwsView"
end
function TeamPwsView:AddBtnEvts()
  self:AddClickEvent(self:FindGO("RuleBtn", self.objRoot), function()
    self:ClickButtonRule()
  end)
  self:AddClickEvent(self:FindGO("RankBtn", self.objRoot), function()
    self:ClickButtonRank()
  end)
  self:AddClickEvent(self:FindGO("RewardBtn", self.objRoot), function()
    self:ClickButtonReward()
  end)
  self:AddClickEvent(self.objBtnMatch, function()
    self:ClickButtonMatch()
  end)
end
function TeamPwsView:AddViewEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.UpdateMatchButton)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.UpdateMatchButton)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTeamPwsTeamInfoMatchCCmd, self.HandleQueryTeamPwsTeamInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateMemberInfosAndScore)
  self:AddListenEvt(TeamEvent.MemberEnterTeam, self.UpdateMemberInfosAndScore)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateMemberInfosOnly)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.UpdateMemberInfosOnly)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdateMemberInfosOnly)
  self:AddListenEvt(ServiceEvent.ActivityCmdStartActCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.ActivityCmdStopActCmd, self.UpdateView)
  self.listMember:AddEventListener(MouseEvent.MouseClick, self.ClickTeamMember, self)
end
function TeamPwsView:InitShow()
  PictureManager.Instance:SetPVP(TeamPwsView.TexUp, self:FindComponent("upTexture", UITexture, self.objRoot))
  local texSeason = self:FindComponent("texSeason", UITexture, self.objRoot)
  PictureManager.Instance:SetPVP(TeamPwsView.TexSeason, texSeason)
  texSeason:MakePixelPerfect()
  self.sprLabMyLevel = SpriteLabel.new(self.objMyLevel, nil, 42, 35, true)
  self:UpdateView()
end
function TeamPwsView:UpdateMatchButton()
  local btnMatchEnable = FunctionActivity.Me():IsActivityRunning(self.pwsConfig.ActivityID)
  if btnMatchEnable then
    local matchStatus = PvpProxy.Instance:GetMatchState(T_PVP_TYPE)
    local freeBattleMatchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.FreeBattle)
    if matchStatus and matchStatus.ismatch or freeBattleMatchStatus and freeBattleMatchStatus.ismatch or Game.MapManager:IsPVPMode_TeamPws() then
      btnMatchEnable = false
    end
  end
  self.colBtnMatch.enabled = btnMatchEnable
  if btnMatchEnable then
    self:SetTextureWhite(self.sprBtnMatch)
  else
    self:SetTextureGrey(self.sprBtnMatch)
  end
  self.objEnableMatchBtnLabel:SetActive(btnMatchEnable)
  self.objDisableMatchBtnLabel:SetActive(not btnMatchEnable)
end
function TeamPwsView:UpdateMemberInfosAndScore()
  self:UpdateMemberInfos(true)
end
function TeamPwsView:UpdateMemberInfosOnly()
  self:UpdateMemberInfos(false)
end
function TeamPwsView:UpdateMemberInfos(refreshScore)
  if TeamProxy.Instance:IHaveTeam() then
    self.objEmptyTeam:SetActive(false)
    local isLowLevel = false
    local memberlst = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
    local member
    for i = 1, #memberlst do
      member = memberlst[i]
      if member.baselv < self.pwsConfig.RequireLv then
        isLowLevel = true
        break
      end
      self.labTeamScore.gameObject:SetActive(not isLowLevel)
      self.objLowLevel:SetActive(isLowLevel)
    end
    self.listMember:ResetDatas(memberlst)
    for i = #memberlst + 1, GameConfig.Team.maxmember do
      self.listMember:AddCell(MyselfTeamData.EMPTY_STATE, i)
    end
    self.listMember:Layout()
    self:UpdateTeamScoreInfo()
  else
    self.listMember:RemoveAll()
    self.objEmptyTeam:SetActive(true)
    self.labTeamScore.gameObject:SetActive(false)
    self.objLowLevel:SetActive(Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) < self.pwsConfig.RequireLv)
  end
  if refreshScore then
    ServiceMatchCCmdProxy.Instance:CallQueryTeamPwsTeamInfoMatchCCmd()
  end
end
function TeamPwsView:HandleQueryTeamPwsTeamInfo(note)
  self.teamInfoData = note.body
  local weekCount = math.ceil(self.teamInfoData.count / (self.pwsConfig.EventCountPerWeek or 1))
  local strWeek
  if weekCount > 10 then
    local first, second = math.modf(weekCount / 10)
    if second > 0 then
      strWeek = string.format("%s%s", ZhString.ChinaNumber[10], ZhString.ChinaNumber[math.floor(second * 10 + 0.5)])
    else
      strWeek = ZhString.ChinaNumber[10]
    end
    if first > 1 then
      strWeek = string.format("%s%s", ZhString.ChinaNumber[math.clamp(first, 1, 9)], strWeek)
    end
  else
    strWeek = weekCount > 0 and ZhString.ChinaNumber[weekCount] or weekCount
  end
  self.labWeekCount.text = string.format(ZhString.TeamPws_Week, strWeek)
  self:UpdateTeamScoreInfo()
end
function TeamPwsView:UpdateTeamScoreInfo()
  if not self.teamInfoData then
    return
  end
  local datas = self.teamInfoData.userinfos
  local myRank = self.teamInfoData.myrank
  local allScore, memberNum = 0, 0
  local myID = Game.Myself.data.id
  local cells = self.listMember:GetCells()
  local data, cell
  for i = 1, #datas do
    data = datas[i]
    if data.charid == myID then
      self.sprLabMyLevel:Reset()
      if data.erank ~= MatchCCmd_pb.ETEAMPWSRANK_NONE then
        local iconName = string.format("ui_teampvp_lv%s", data.erank)
        local myLevelInfo = string.format(ZhString.TeamPws_MyLevel, string.format("{uiicon=%s}", iconName))
        if myRank and 0 ~= myRank then
          myLevelInfo = string.format("%s  %s", myLevelInfo, myRank)
        end
        self.sprLabMyLevel:SetText(myLevelInfo, true)
      else
        self.sprLabMyLevel:SetText(string.format(ZhString.TeamPws_MyLevel, myRank and myRank ~= 0 and myRank or "-"), true)
      end
      self.labMyScore.text = string.format(ZhString.TeamPws_MyScore, data.score)
      if not TeamProxy.Instance:IHaveTeam() then
        return
      end
    end
    for j = 1, #cells do
      cell = cells[j]
      if data.charid == cell.charID then
        allScore = allScore + math.pow(data.score, 2)
        memberNum = memberNum + 1
        cell:SetScore(data)
        break
      end
    end
  end
  allScore = math.floor(math.sqrt(math.floor(allScore / memberNum)))
  self.labTeamScore.text = string.format(ZhString.TeamPws_TeamScore, memberNum > 0 and allScore or 0)
end
function TeamPwsView:ClickButtonRule()
  local panelId = PanelConfig.TeamPwsView.id
  local Desc = Table_Help[panelId] and Table_Help[panelId].Desc or ZhString.Help_RuleDes
  TipsView.Me():ShowGeneralHelp(Desc)
end
function TeamPwsView:ClickButtonRank()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamPwsRankPopUp
  })
end
function TeamPwsView:ClickButtonReward()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamPwsRewardPopUp
  })
end
function TeamPwsView:ClickButtonMatch()
  if self.disableClick then
    return
  end
  local valid = TeamProxy.Instance:CheckMatchValid(self.pwsConfig.matchid) and PvpProxy.Instance:CheckPwsMatchValid(false, self.roomID)
  if valid then
    if TeamProxy.Instance:IHaveTeam() then
      local memberlst = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
      if #memberlst < GameConfig.Team.maxmember then
        MsgManager.ConfirmMsgByID(25904, function()
          self:CallMatch()
        end, nil)
        return
      end
    end
    self:CallMatch()
  end
end
function TeamPwsView:CallMatch()
  if self.disableClick then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(T_PVP_TYPE)
  self.disableClick = true
  self.ltDisableClick = LeanTween.delayedCall(3, function()
    self.disableClick = false
    self.ltDisableClick = nil
  end)
end
function TeamPwsView:UpdateView()
  local teamPwsCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_TEAMPWS_COUNT) or 0
  self.labFightCountInfo.text = string.format(ZhString.TeamPws_FightCount, teamPwsCount, GameConfig.teamPVP.Maxtime)
  self.haveChance = teamPwsCount < GameConfig.teamPVP.Maxtime
  self:UpdateMatchButton()
  self:UpdateMemberInfosAndScore()
  self:RefreshLeftTime()
end
function TeamPwsView:ClickTeamMember(cellCtl)
  local memberData = cellCtl.data
  if cellCtl == self.curCell or cellCtl.charID == Game.Myself.data.id or memberData.cat and memberData.cat ~= 0 then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = cellCtl
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.headIcon.frameSp, NGUIUtil.AnchorSide.TopRight, {-70, 14})
  local playerData = PlayerTipData.new()
  playerData:SetByTeamMemberData(memberData)
  local funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(memberData.id)
  playerTip:SetData({playerData = playerData, funckeys = funckeys})
  playerTip:AddIgnoreBound(cellCtl.headIcon.gameObject)
  function playerTip.closecallback()
    self.curCell = nil
  end
end
function TeamPwsView:RefreshLeftTime()
  self:ClearTick()
  self.activityOpen = FunctionActivity.Me():IsActivityRunning(self.pwsConfig.ActivityID)
  if not self.activityOpen and self.pwsConfig.ActivityStartTime then
    local nearestTime = ReusableTable.CreateTable()
    nearestTime.index = 1
    local serverTime = ServerTime.CurServerTime() / 1000
    local dayofWeek = tonumber(os.date("%w", serverTime))
    local curHour = tonumber(os.date("%H", serverTime))
    local minToNextHour = 60 - tonumber(os.date("%M", serverTime))
    local waitDay, waitHour, waitMin, openDay, openHour
    for i = 1, #self.pwsConfig.ActivityStartTime do
      openDay = self.pwsConfig.ActivityStartTime[i].dayofweek
      openHour = self.pwsConfig.ActivityStartTime[i].hour or 0
      waitDay = dayofWeek > openDay and 7 - dayofWeek + openDay or openDay - dayofWeek
      if waitDay < 1 then
        waitHour = openHour - curHour
      else
        waitHour = 24 - curHour + openHour
        waitHour = waitHour > 0 and waitHour + (waitDay - 1) * 24 or waitDay * 24
      end
      if waitHour > 0 then
        waitMin = minToNextHour > 0 and (waitHour - 1) * 60 + minToNextHour or waitHour * 60
        if not nearestTime.min or waitMin < nearestTime.min then
          nearestTime.min = waitMin
          nearestTime.index = i
        end
      end
    end
    self.nearestOpenTimeIndex = nearestTime.index
    ReusableTable.DestroyAndClearTable(nearestTime)
  end
  self.timeTick = TimeTickManager.Me():CreateTick(0, self.activityOpen and 330 or 5000, self.UpdateLeftTime, self)
end
function TeamPwsView:UpdateLeftTime()
  if not self.activityOpen then
    self:UpdateNextOpenTime()
    return
  end
  local actData = FunctionActivity.Me():GetActivityData(self.pwsConfig.ActivityID)
  if actData then
    local totalSec = actData:GetEndTime() - ServerTime.CurServerTime() / 1000
    if totalSec > 0 then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(totalSec)
      self.labEventCountDown.text = string.format(ZhString.TeamPws_LeftTime, day * 24 + hour, min, sec)
      return
    end
  end
  self.labEventCountDown.text = string.format(ZhString.TeamPws_LeftTime, 0, 0, 0)
end
function TeamPwsView:UpdateNextOpenTime()
  if not self.pwsConfig.ActivityStartTime then
    self.labEventCountDown.text = string.format(ZhString.TeamPws_EventWaitTime_Detail, 0, 0)
    return
  end
  local serverTime = ServerTime.CurServerTime() / 1000
  local dayofWeek = tonumber(os.date("%w", serverTime))
  local curHour = tonumber(os.date("%H", serverTime))
  local curMin = tonumber(os.date("%M", serverTime))
  local openDay = self.pwsConfig.ActivityStartTime[self.nearestOpenTimeIndex].dayofweek or 6
  local openHour = self.pwsConfig.ActivityStartTime[self.nearestOpenTimeIndex].hour or 0
  local endHour = openHour + (self.pwsConfig.ActivityDuration.hour or 0)
  local isOver = openDay == dayofWeek and (curHour > endHour or curHour == endHour and curMin > (self.pwsConfig.ActivityDuration.min or 0))
  local waitDay = (dayofWeek > openDay or isOver) and 7 - dayofWeek + openDay or openDay - dayofWeek
  if waitDay > 1 then
    self.labEventCountDown.text = string.format(ZhString.TeamPws_EventWaitTime, waitDay)
  else
    local waitHour = waitDay < 1 and openHour - curHour or 24 - curHour + openHour
    if waitHour > 24 then
      self.labEventCountDown.text = string.format(ZhString.TeamPws_EventWaitTime, 1)
    else
      local waitMin = waitHour > 0 and 60 - curMin or 0
      self.labEventCountDown.text = string.format(ZhString.TeamPws_EventWaitTime_Detail, math.max(waitMin > 0 and waitHour - 1 or waitHour, 0), waitMin)
    end
  end
end
function TeamPwsView:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end
function TeamPwsView:OnEnter()
  TeamPwsView.super.OnEnter(self)
end
function TeamPwsView:OnExit()
  PictureManager.Instance:UnLoadPVP()
  if self.sprLabMyLevel then
    self.sprLabMyLevel:Destroy()
  end
  if self.ltDisableClick then
    self.ltDisableClick:cancel()
    self.ltDisableClick = nil
  end
  self:ClearTick()
  TeamPwsView.super.OnExit(self)
end
