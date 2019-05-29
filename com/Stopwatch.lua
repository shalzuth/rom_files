Stopwatch = class("Stopwatch")
function Stopwatch:ctor(pauseFunc, owner, id)
  self:ResetData(pauseFunc, owner, id)
end
function Stopwatch:ResetData(pauseFunc, owner, id)
  self.pauseFunc = pauseFunc
  self.owner = owner
  self.id = id
  self:Clear()
end
function Stopwatch:Start()
  self:Clear()
  self:Continue()
end
function Stopwatch:Continue()
  self.continueTime = ServerTime.CurServerTime()
  self.continueFrameCount = Time.frameCount
  self.isOn = true
end
function Stopwatch:Pause()
  self.isOn = false
  self.timeInterval = self.timeInterval + (ServerTime.CurServerTime() - self.continueTime)
  self.frameInterval = self.frameInterval + (Time.frameCount - self.continueFrameCount)
  if self.pauseFunc then
    self.pauseFunc(self.owner, self.timeInterval, self.frameInterval)
  end
end
function Stopwatch:Clear()
  self.isOn = false
  self.continueTime = 0
  self.continueFrameCount = 0
  self.timeInterval = 0
  self.frameInterval = 0
end
