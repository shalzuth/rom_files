MainViewExpRaidPage = class("MainViewExpRaidPage", SubView)
MainViewExpRaidPage.LackBattleTimeThreshold = 3600
local proxyInstance, tickInstance
function MainViewExpRaidPage:Init()
  proxyInstance = ExpRaidProxy.Instance
  tickInstance = TimeTickManager.Me()
  self:InitView()
  self:AddEvents()
  self:ResetData()
end
function MainViewExpRaidPage:InitView()
  self.gameObject = self:FindGO("ExpRaidInfoBord")
  self.expRaidScoreLabel = self:FindComponent("ExpRaidScoreLabel", UILabel)
  self.inRaidScoreLabel = self:FindComponent("InRaidScoreLabel", UILabel)
  self.titleLabel = self:FindComponent("TitleLabel", UILabel)
  self.titleLabel.text = ZhString.ExpRaid_InfoBordTitleLabel
  self.descLabel = self:FindComponent("ExpRaidDesc", UILabel)
  self.descLabel.text = ZhString.ExpRaid_InfoBordDesc
  self.countdownLabel = self:FindComponent("CountdownLabel", UILabel)
  self.countdownSlider = self:FindComponent("CountdownSlider", UISlider)
  self.totalTime = GameConfig.TeamExpRaid.raid_time
end
function MainViewExpRaidPage:AddEvents()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleUpdateExpRaidScore)
  self:AddListenEvt(ServiceEvent.FuBenCmdTrackFuBenUserCmd, self.HandleTrackFuBenUserCmd)
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamExpReportFubenCmd, self.HandleRecvExpRaidResult)
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamExpSyncFubenCmd, self.HandleExpSyncFubenCmd)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandleBattleTimelenUserCmd)
end
function MainViewExpRaidPage:ResetData()
  self:HandleUpdateExpRaidScore()
  tickInstance:ClearTick(self)
  self.countdownTick = nil
  self.countdownLabel.text = self:MakeTimeStr(self.totalTime)
  self.countdownSlider.value = 1
end
function MainViewExpRaidPage:HandleUpdateExpRaidScore()
  self.expRaidScoreLabel.text = string.format(ZhString.ExpRaid_InfoBordScoreLabel, proxyInstance:GetExpRaidScore())
  self.inRaidScoreLabel.text = string.format(ZhString.ExpRaid_InfoBordInRaidScoreLabel, proxyInstance:GetExpRaidScoreInRaid())
end
function MainViewExpRaidPage:HandleTrackFuBenUserCmd()
  if not Game.MapManager:IsPVEMode_ExpRaid() then
    return
  end
  ServiceNUserProxy.Instance:CallBattleTimelenUserCmd()
end
function MainViewExpRaidPage:HandleRecvExpRaidResult()
  if not Game.MapManager:IsPVEMode_ExpRaid() then
    return
  end
  self:ResetData()
end
function MainViewExpRaidPage:HandleExpSyncFubenCmd(note)
  local data = note.body
  if not data or not data.endtime or data.endtime <= 0 then
    return
  end
  tickInstance:ClearTick(self)
  self.endTime = data.endtime
  self.countdownTick = tickInstance:CreateTick(0, 300, self.UpdateCountdown, self)
end
function MainViewExpRaidPage:HandleBattleTimelenUserCmd(note)
  if not Game.MapManager:IsPVEMode_ExpRaid() then
    return
  end
  local data = note.body
  if not data or not data.timelen or not data.totaltime then
    return
  end
  local leftTimeLen = data.totaltime - data.timelen
  if leftTimeLen < MainViewExpRaidPage.LackBattleTimeThreshold then
    local musicTime = data.musictime or 0
    local tutorTime = data.tutortime or 0
    if musicTime + tutorTime + (leftTimeLen < 0 and 0 or leftTimeLen) < MainViewExpRaidPage.LackBattleTimeThreshold then
      MsgManager.ShowMsgByID(28020)
    end
  end
end
function MainViewExpRaidPage:Show(tarObj)
  MainViewExpRaidPage.super.Show(self, tarObj)
  if not tarObj then
    self:ResetData()
  end
end
function MainViewExpRaidPage:Hide(tarObj)
  MainViewExpRaidPage.super.Hide(self, tarObj)
  if not tarObj then
    self:ResetData()
  end
end
function MainViewExpRaidPage:UpdateCountdown()
  local leftTime = self.endTime - ServerTime.CurServerTime() / 1000
  if leftTime < 0 then
    leftTime = 0
    tickInstance:ClearTick(self)
    self.countdownTick = nil
  end
  leftTime = math.floor(leftTime)
  self.countdownLabel.text = self:MakeTimeStr(leftTime)
  self.countdownSlider.value = leftTime / self.totalTime
end
function MainViewExpRaidPage:MakeTimeStr(time)
  local min = math.floor(time / 60)
  local s = time - min * 60
  return string.format("%02d:%02d", min, s)
end
