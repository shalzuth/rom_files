autoImport("Bat")
Atcmi = class("Atcmi", Bat)
local mcmi, fcm, sw
function Atcmi:ctor(interval, threshold)
  self.threshold = threshold or 0
  Atcmi.super.ctor(self, interval, self.Send, self)
end
function Atcmi:Init()
  sw = StopwatchManager.Me():CreateStopwatch(self.Record, self)
  self:Reset()
end
function Atcmi:Reset()
  mcmi = 100000
  fcm = 3000
end
function Atcmi:Record(interval, fc)
  if self.threshold <= 0 then
    return
  end
  if interval < mcmi then
    mcmi = math.floor(interval)
    fcm = fc
  end
  if not self:IsRecording() and interval < self.threshold then
    self:Send()
    self:StartRecording()
  end
end
function Atcmi:Send()
  local interval, fc = mcmi, fcm
  if interval < self.threshold then
    ServiceNUserProxy.Instance:CallCheatTagUserCmd(interval, fc)
    self:Reset()
  end
end
function Atcmi:IsOn()
  return sw and sw.isOn
end
function Atcmi:Start()
  if sw then
    sw:Start()
  end
end
function Atcmi:Clear()
  if sw then
    sw:Clear()
  end
end
function Atcmi:R()
  if sw then
    sw:Pause()
  end
end
