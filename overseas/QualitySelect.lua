QualitySelect = class("QualitySelect", ContainerView)
QualitySelect.ViewType = UIViewType.PopUpLayer
function QualitySelect:Init()
  local low = self:FindGO("LowSelect")
  local lowSelect = self:FindGO("Selected", low)
  local high = self:FindGO("HighSelect")
  local highSelect = self:FindGO("Selected", high)
  local Comfirm = self:FindGO("Comfirm")
  self.index = 2
  self:AddClickEvent(low, function(go)
    lowSelect:SetActive(true)
    highSelect:SetActive(false)
    self.index = 1
  end)
  self:AddClickEvent(high, function(go)
    highSelect:SetActive(true)
    lowSelect:SetActive(false)
    self.index = 2
  end)
  self:AddClickEvent(Comfirm, function(go)
    self:SetFrame()
    self:SetEffect()
    self:CloseSelf()
  end)
end
function QualitySelect:SetFrame()
  local TargetFrameRate = {
    {
      name = ZhString.SetView_LowFrameRate,
      count = 30,
      index = 1
    },
    {
      name = ZhString.SetView_HightFrameRate,
      count = 60,
      index = 2
    }
  }
  local count = 30
  for _, v in pairs(TargetFrameRate) do
    if v.index == self.index then
      count = v.count
      break
    end
  end
  helplog("QualitySelect:SetFrame", self.index, count)
  UnityEngine.Application.targetFrameRate = count
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  setting:SetFrameRate(self.index)
  setting:SetEnd()
end
function QualitySelect:SetEffect()
  local setting = FunctionPerformanceSetting.Me()
  local value = false
  if self.index == 2 then
    value = true
  end
  local screenCount = self.index == 1 and GameConfig.Setting.ScreenCountLow or GameConfig.Setting.ScreenCountHigh
  helplog("QualitySelect:SetEffect", self.index, value, screenCount)
  setting:SetBegin()
  setting:SetOutLine(value)
  setting:SetToonLight(value)
  setting:SetEffectLow(not value)
  setting:SetSelfPeak(value)
  setting:SetOtherPeak(value)
  setting:SetScreenCount(screenCount)
  setting:SetEnd()
end
function QualitySelect:OnEnter()
  self.super.OnEnter(self)
end
function QualitySelect:OnExit()
end
