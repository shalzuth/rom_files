Bat = class("Bat")
function Bat:ctor(interval, func, owner)
  self.timerInterval = interval
  self.timerFunc = func
  self.timerFuncOwner = owner
  self:Init()
end
function Bat:Init()
end
function Bat:StartRecording(delay)
  if self:IsRecording() then
    self:StopRecording()
  end
  delay = delay or 0
  self.timerId = LuaTimer.Add(delay, self.timerInterval, function()
    self.timerFunc(self.timerFuncOwner)
    return true
  end)
end
function Bat:StopRecording()
  if not self:IsRecording() then
    return
  end
  LuaTimer.Delete(self.timerId)
  self.timerId = nil
end
function Bat:IsRecording()
  return self.timerId ~= nil
end
function Bat:SetTimerInterval(interval)
  interval = interval or 5000
  self.timerInterval = interval
  if self:IsRecording() then
    self:StartRecording()
  end
end
function Bat:SetTimerFunc(func, owner)
  if not func or not owner then
    return
  end
  self.timerFunc = func
  self.timerFuncOwner = owner
end
