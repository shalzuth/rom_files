TeamPwsBord = class("TeamPwsBord", CoreView)
local PREFAB_PATH = "GUI/v1/part/TeamPwsBord"
local TeamColor
function TeamPwsBord:ctor(parent)
  if parent == nil then
    error("not find parent..root")
    return
  end
  self:CreateSelf(parent)
  TeamColor = PvpProxy.TeamPws.TeamColor
end
function TeamPwsBord:CreateSelf(parent)
  self.gameObject = self:LoadPreferb_ByFullPath("GUI/v1/part/TeamPwsBord", parent, true)
  self:InitView()
end
function TeamPwsBord:InitView()
  self.leftTime_Raid = self:FindComponent("LeftTime_Raid", UILabel)
  self.leftTime_Red = self:FindComponent("LeftTime_Red", UILabel)
  self.leftTime_Blue = self:FindComponent("LeftTime_Blue", UILabel)
  self.score_Red = self:FindComponent("Score_Red", UILabel)
  self.score_Blue = self:FindComponent("Score_Blue", UILabel)
  local buff_redGO = self:FindGO("BuffIcon_Red")
  IconManager:SetUIIcon("ui_teampvp_skillg", self:FindComponent("Bg", UISprite, buff_redGO))
  self.buffIcon_Red = buff_redGO:GetComponent(UISprite)
  self.buffIcon_Red_1 = self:FindComponent("1", UISprite, buff_redGO)
  self.buffIcon_Red_2 = self:FindComponent("2", UISprite, buff_redGO)
  self.buffIcon_Red_3 = self:FindComponent("3", UISprite, buff_redGO)
  self.buffIcon_Red_4 = self:FindComponent("4", UISprite, buff_redGO)
  local buff_blueGO = self:FindGO("BuffIcon_Blue")
  IconManager:SetUIIcon("ui_teampvp_skillg", self:FindComponent("Bg", UISprite, buff_blueGO))
  self.buffIcon_Blue = buff_blueGO:GetComponent(UISprite)
  self.buffIcon_Blue_1 = self:FindComponent("1", UISprite, buff_blueGO)
  self.buffIcon_Blue_2 = self:FindComponent("2", UISprite, buff_blueGO)
  self.buffIcon_Blue_3 = self:FindComponent("3", UISprite, buff_blueGO)
  self.buffIcon_Blue_4 = self:FindComponent("4", UISprite, buff_blueGO)
  local detailButton = self:FindGO("DetailButton")
  self:AddClickEvent(detailButton, function(go)
    self:ShowDetail()
  end)
  local stick = self:FindComponent("Stick", UIWidget)
  self:AddClickEvent(buff_redGO, function(go)
    if self.red_BuffID == nil then
      return
    end
    local desc = Table_Buffer[self.red_BuffID].BuffDesc
    local normalTip = TipManager.Instance:ShowNormalTip(desc, stick, NGUIUtil.AnchorSide.Left, {-270, 0})
    normalTip:SetAnchor(NGUIUtil.AnchorSide.TopRight)
  end)
  self:AddClickEvent(buff_blueGO, function(go)
    if self.blue_BuffID == nil then
      return
    end
    local desc = Table_Buffer[self.blue_BuffID].BuffDesc
    local normalTip = TipManager.Instance:ShowNormalTip(desc, stick, NGUIUtil.AnchorSide.Left, {-270, 0})
    normalTip:SetAnchor(NGUIUtil.AnchorSide.TopRight)
  end)
end
function TeamPwsBord:ShowDetail()
  if self.vd_TPvpDetail == nil then
    self.vd_TPvpDetail = {}
    self.vd_TPvpDetail.view = PanelConfig.TeamPwsReportPopUp
    self.vd_TPvpDetail.viewdata = {}
  end
  self:sendNotification(UIEvent.JumpPanel, self.vd_TPvpDetail)
end
function TeamPwsBord:UpdateInfo()
  self:UpdateRaidInfo()
  self:UpdateScoreInfo()
  self:UpdateBuffInfo()
end
function TeamPwsBord:UpdateBuffInfo()
  local redInfo = PvpProxy.Instance:GetTeamPwsInfo(TeamColor.Red)
  local blueInfo = PvpProxy.Instance:GetTeamPwsInfo(TeamColor.Blue)
  if redInfo == nil or blueInfo == nil then
    return
  end
  local _PvpTeamRaid = DungeonProxy.Instance:GetConfigPvpTeamRaid()
  self:UpdateLeftTime_BuffRed(redInfo.effectcd)
  local combineConfig = _PvpTeamRaid.ElementCombine
  if redInfo.effectid and redInfo.effectid ~= 0 then
    local cdata = combineConfig[redInfo.effectid]
    self.buffIcon_Red.enabled = true
    IconManager:SetUIIcon(cdata.icon, self.buffIcon_Red)
    self.red_BuffID = cdata.BuffIDs[1]
  else
    self.buffIcon_Red.enabled = false
    self.red_BuffID = nil
  end
  self:UpdateLeftTime_BuffBlue(blueInfo.effectcd)
  if blueInfo.effectid and blueInfo.effectid ~= 0 then
    local cdata = combineConfig[blueInfo.effectid]
    self.buffIcon_Blue.enabled = true
    IconManager:SetUIIcon(cdata.icon, self.buffIcon_Blue)
    self.blue_BuffID = cdata.BuffIDs[1]
  else
    self.buffIcon_Blue.enabled = false
    IconManager:SetUIIcon("ui_teampvp_skillg", self.buffIcon_Blue)
    self.blue_BuffID = nil
  end
  local redBallMap, blueBallMap = redInfo.balls, blueInfo.balls
  local ballConfig = _PvpTeamRaid.ElementNpcsID
  for i = 1, 4 do
    local redSp = self["buffIcon_Red_" .. i]
    if redBallMap[i] then
      redSp.enabled = true
      IconManager:SetUIIcon(ballConfig[i].icon, redSp)
    else
      redSp.enabled = false
    end
    local blueSp = self["buffIcon_Blue_" .. i]
    if blueBallMap[i] then
      blueSp.enabled = true
      IconManager:SetUIIcon(ballConfig[i].icon, blueSp)
    else
      blueSp.enabled = false
    end
  end
end
function TeamPwsBord:UpdateRaidInfo()
  local sparetime = PvpProxy.Instance:GetSpareTime()
  self:UpdateLeftTime_Raid(sparetime)
end
function TeamPwsBord:UpdateScoreInfo()
  local rd = PvpProxy.Instance:GetTeamPwsInfo(TeamColor.Red)
  if rd ~= nil then
    self.score_Red.text = rd.score or 0
  else
    self.score_Red.text = 0
  end
  local bd = PvpProxy.Instance:GetTeamPwsInfo(TeamColor.Blue)
  if bd ~= nil then
    self.score_Blue.text = bd.score or 0
  else
    self.score_Blue.text = 0
  end
end
local f_gnt
local getNowTime = function()
  if f_gnt == nil then
    f_gnt = ServerTime.CurServerTime
  end
  if f_gnt then
    return f_gnt() / 1000
  end
  return 0
end
function TeamPwsBord:UpdateLeftTime_Raid(endtime)
  self.endtime_raid = endtime
  local nowtime = getNowTime()
  if endtime <= nowtime then
    self:RemoveTimeTick_Raid()
    return
  end
  if self.raid_tick ~= nil then
    return
  end
  self:AddTimeTick_Raid()
end
function TeamPwsBord:RemoveTimeTick_Raid()
  if self.raid_tick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.raid_tick = nil
  end
  self.leftTime_Raid.text = string.format("%02d:%02d", 0, 0)
end
function TeamPwsBord:AddTimeTick_Raid()
  self.raid_tick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateTimeTick_Raid, self, 1)
end
function TeamPwsBord:_UpdateTimeTick_Raid()
  local lefttime = self.endtime_raid - getNowTime()
  if lefttime <= 0 then
    self:RemoveTimeTick_Raid()
    return
  end
  self.leftTime_Raid.text = string.format("%02d:%02d", math.floor(lefttime / 60), math.floor(lefttime % 60))
end
function TeamPwsBord:UpdateLeftTime_BuffRed(endtime)
  endtime = endtime or 0
  self.endtime_buffRed = endtime
  local nowtime = getNowTime()
  if endtime <= nowtime then
    self:RemoveTimeTick_BuffRed()
    return
  end
  if self.buffRed_tick ~= nil then
    return
  end
  self:AddTimeTick_BuffRed()
end
function TeamPwsBord:RemoveTimeTick_BuffRed()
  if self.buffRed_tick then
    TimeTickManager.Me():ClearTick(self, 2)
    self.buffRed_tick = nil
  end
  self.leftTime_Red.text = string.format("%ss", 0)
end
function TeamPwsBord:AddTimeTick_BuffRed()
  self.buffRed_tick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateTimeTick_BuffRed, self, 2)
end
function TeamPwsBord:_UpdateTimeTick_BuffRed()
  local lefttime = self.endtime_buffRed - getNowTime()
  if lefttime <= 0 then
    self:RemoveTimeTick_BuffRed()
    return
  end
  self.leftTime_Red.text = string.format("%ss", math.floor(lefttime))
end
function TeamPwsBord:UpdateLeftTime_BuffBlue(endtime)
  endtime = endtime or 0
  self.endtime_buffBlue = endtime
  local nowtime = getNowTime()
  if endtime <= nowtime then
    self:RemoveTimeTick_BuffBlue()
    return
  end
  if self.buffBlue_tick ~= nil then
    return
  end
  self:AddTimeTick_BuffBlue()
end
function TeamPwsBord:RemoveTimeTick_BuffBlue()
  if self.buffBlue_tick then
    TimeTickManager.Me():ClearTick(self, 3)
    self.buffBlue_tick = nil
  end
  self.leftTime_Blue.text = string.format("%ss", 0)
end
function TeamPwsBord:AddTimeTick_BuffBlue()
  self.buffBlue_tick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateTimeTick_BuffBlue, self, 3)
end
function TeamPwsBord:_UpdateTimeTick_BuffBlue()
  local lefttime = self.endtime_buffBlue - getNowTime()
  if lefttime <= 0 then
    self:RemoveTimeTick_BuffBlue()
    return
  end
  self.leftTime_Blue.text = string.format("%ss", math.floor(lefttime))
end
function TeamPwsBord:Show()
  TeamPwsBord.super.Show(self)
  EventManager.Me():AddEventListener(PVPEvent.TeamPws_BuffBallChange, self.UpdateBuffInfo, self)
  self:UpdateInfo()
end
function TeamPwsBord:Hide()
  TeamPwsBord.super.Hide(self)
  EventManager.Me():RemoveEventListener(PVPEvent.TeamPws_BuffBallChange, self.UpdateBuffInfo, self)
end
