ActivityDungeonInfo = class("ActivityDungeonInfo", SubView)
local EvaConfig = GameConfig.EVA
function ActivityDungeonInfo:Init()
  self:InitUI()
end
local Time = EvaConfig.Time
function ActivityDungeonInfo:InitUI()
  self.toptip = self:FindGO("descriptionTop"):GetComponent(UILabel)
  self.bottip = self:FindGO("descriptionBot"):GetComponent(UILabel)
  self.toptip.text = Table_Help[20006].Desc or ""
  self.bottip.text = Table_Help[20007].Desc or ""
  self.desPic = self:FindGO("desPic"):GetComponent(UITexture)
  PictureManager.Instance:SetUI(EvaConfig.despic, self.desPic)
end
function ActivityDungeonInfo:OnExit()
  self.super.OnExit(self)
end
function ActivityDungeonInfo:Show(target)
  ActivityDungeonInfo.super.Show(self, target)
end
function ActivityDungeonInfo:UpdateTimeTick()
  local time = self.endt
  if time == 0 then
    if self.timetick ~= nil then
      TimeTickManager.Me():ClearTick(self, 10)
      self.timetick = nil
      self.timelable.text = "00:00:00"
    end
    return
  end
  local deltaTime = ServerTime.ServerDeltaSecondTime(time * 1000)
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(deltaTime)
  if deltaTime <= 0 then
    if self.timetick ~= nil then
      TimeTickManager.Me():ClearTick(self, 10)
      self.timetick = nil
      self.timelable.text = "00:00:00"
    end
  elseif deltaTime < 86400 then
    self.timelable.text = string.format(ZhString.EVA_EndInHours, hour, min, sec)
  else
    self.timelable.text = string.format(ZhString.EVA_EndInDays, day)
  end
end
