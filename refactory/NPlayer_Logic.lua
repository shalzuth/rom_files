local SampleInterval = 0.1
local nextSampleTime = 0
function NPlayer.StaticUpdate(time, deltaTime)
  if time >= nextSampleTime then
    nextSampleTime = time + SampleInterval
  end
end
function NPlayer:Logic_SamplePosition(time)
  if time < nextSampleTime then
    self.logicTransform:SamplePosition()
  end
end
function NPlayer:Logic_PeakEffect()
  local peak = self.data.userdata:Get(UDEnum.PEAK_EFFECT) or 0
  if peak ~= 1 then
    return false
  end
  local otherPeak = FunctionPerformanceSetting.Me():GetSetting().otherPeak
  if otherPeak == false then
    return false
  end
  return true
end
