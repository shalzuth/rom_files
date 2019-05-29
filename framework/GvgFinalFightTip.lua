GvgFinalFightTip = class("GvgFinalFightTip", CoreView)
autoImport("GvgFinalMapRankCell")
autoImport("GvgFinalSectionCell")
GvgFinalFightTip.totalCaptureLen = 260
GvgFinalFightTip.EGvgTowerType = {
  [FuBenCmd_pb.EGVGTOWERTYPE_CORE] = {
    name = "\230\160\184\229\191\131\229\141\160\233\162\134\229\186\166",
    totalValue = GameConfig.GvgDroiyan ~= nil and (GameConfig.GvgDroiyan.RobPlatform_RobValue or 1800) or 1800
  },
  [FuBenCmd_pb.EGVGTOWERTYPE_WEST] = {
    name = "\232\165\191\233\131\168\230\153\182\229\161\148\229\141\160\233\162\134\229\186\166",
    totalValue = GameConfig.GvgDroiyan ~= nil and (GameConfig.GvgDroiyan.RobPlatform_RobValue or 1800) or 1800
  },
  [FuBenCmd_pb.EGVGTOWERTYPE_EAST] = {
    name = "\228\184\156\233\131\168\230\153\182\229\161\148\229\141\160\233\162\134\229\186\166",
    totalValue = GameConfig.GvgDroiyan ~= nil and (GameConfig.GvgDroiyan.RobPlatform_RobValue or 1800) or 1800
  }
}
GvgFinalFightTip.GuildIndex = {
  [1] = {color = "gvg_bg_red", colorName = "Red"},
  [2] = {
    color = "gvg_bg_blue",
    colorName = "Blue"
  },
  [3] = {
    color = "gvg_bg_purple",
    colorName = "Purple"
  },
  [4] = {
    color = "gvg_bg_green",
    colorName = "Green"
  }
}
function GvgFinalFightTip:ctor(go)
  GvgFinalFightTip.super.ctor(self, go)
  self:Init()
end
function GvgFinalFightTip:Init()
  self:initView()
end
function GvgFinalFightTip:initView()
  self.topRankCt = self:FindComponent("topRankCt", UITable)
  self.topRankCt = UIGridListCtrl.new(self.topRankCt, GvgFinalMapRankCell, "GvgFinalMapRankCell")
  self.sectionInfos = self:FindComponent("sectionInfoCt", UIGrid)
  self.sectionInfos = UIGridListCtrl.new(self.sectionInfos, GvgFinalSectionCell, "GvgFinalSectionCell")
  local Title = self:FindComponent("Title", UILabel)
  Title.text = ZhString.GvgFinalFightTip_Title
  local metalNumLabel = self:FindComponent("metalNumLabel", UILabel)
  metalNumLabel.text = ZhString.MainviewGvgFinalPage_Title
  self.timeLabel = self:FindComponent("timeLabel", UILabel)
  local timeDes = self:FindComponent("timeDes", UILabel)
  timeDes.text = ZhString.GvgFinalFightTip_TimeDes
end
function GvgFinalFightTip:initData()
  local secDiff = SuperGvgProxy.Instance:GetFinalFightTimeDiff()
  if secDiff < 0 then
    self.hasWarStart = true
  else
    self.hasWarStart = false
  end
  self.warStartCoundDown = secDiff
  self.warStartedTime = -secDiff
  local infos = SuperGvgProxy.Instance:GetGuildInfos()
  self.topRankCt:ResetDatas(infos)
  local towers = SuperGvgProxy.Instance:GetTowers()
  self.sectionInfos:ResetDatas(towers)
  if self.tickMg then
    self.tickMg:ClearTick(self)
  else
    self.tickMg = TimeTickManager.Me()
  end
  self.tickMg:CreateTick(0, 1000, self.updateCountTime, self)
end
function GvgFinalFightTip:OnShow()
  if self.isQurryedTowerInfo == nil or not self.isQurryedTowerInfo then
    for k, v in pairs(GvgFinalFightTip.EGvgTowerType) do
      SuperGvgProxy.Instance:Active_QueryTowerInfo(k, true)
    end
    self.isQurryedTowerInfo = true
  end
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, self.UpdateCrystal, self)
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, self.UpdateTowers, self)
  self:initData()
end
function GvgFinalFightTip:OnHide()
  if self.callback then
    self.callback(self.callbackParam)
  end
  if self.tickMg then
    self.tickMg:ClearTick(self)
    self.tickMg = nil
  end
  if self.isQurryedTowerInfo then
    for k, v in pairs(GvgFinalFightTip.EGvgTowerType) do
      SuperGvgProxy.Instance:Active_QueryTowerInfo(k, false)
    end
    self.isQurryedTowerInfo = false
  end
  EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, self.UpdateCrystal, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, self.UpdateTowers, self)
end
function GvgFinalFightTip:SetData()
end
function GvgFinalFightTip:updateCountTime()
  local leftTime = 0
  if self.hasWarStart then
    self.warStartedTime = self.warStartedTime + 1
    leftTime = self.warStartedTime
  else
    self.warStartCoundDown = self.warStartCoundDown - 1
    leftTime = self.warStartCoundDown
    if self.warStartCoundDown == 0 then
      self.hasWarStart = true
      self.warStartedTime = 0
    end
  end
  local m = math.floor(leftTime / 60)
  local s = leftTime - m * 60
  local time = string.format(ZhString.MainViewGvgPage_LeftTime, m, s)
  if self.timeLabel then
    self.timeLabel.text = time
  end
end
function GvgFinalFightTip:CloseSelf()
end
function GvgFinalFightTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
function GvgFinalFightTip:UpdateCrystal()
  local infos = SuperGvgProxy.Instance:GetGuildInfos()
  self.topRankCt:ResetDatas(infos)
end
function GvgFinalFightTip:UpdateTowers()
  local towers = SuperGvgProxy.Instance:GetTowers()
  self.sectionInfos:ResetDatas(towers)
end
