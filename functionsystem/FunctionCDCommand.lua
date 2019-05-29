autoImport("AssociateRemoveFunctionCD")
autoImport("CDCtrlRefresher")
autoImport("TimerCDCtrlRefresher")
FunctionCDCommand = class("FunctionCDCommand")
function FunctionCDCommand.Me()
  if nil == FunctionCDCommand.me then
    FunctionCDCommand.me = FunctionCDCommand.new()
  end
  return FunctionCDCommand.me
end
function FunctionCDCommand:ctor()
  self:Reset()
  TimeTickManager.Me():CreateTick(0, 33, self.Update, self)
end
function FunctionCDCommand:Reset()
  self.cmdMap = {}
end
function FunctionCDCommand:GetCDProxy(cmdClass, owner)
  owner = owner or cmdClass
  return self.cmdMap[owner]
end
function FunctionCDCommand:GetAssiRemoveProxy(owner)
  return self:GetCDProxy(AssociateRemoveFunctionCD, owner)
end
function FunctionCDCommand:StopAllCD()
  for k, v in pairs(self.cmdMap) do
    v:SetEnable(false)
  end
end
function FunctionCDCommand:StopCD(cmdClass)
  local cmd = self.cmdMap[cmdClass]
  if cmd ~= nil then
    cmd:SetEnable(false)
  end
end
function FunctionCDCommand:StartCDProxy(cmdClass, interval, owner)
  owner = owner or cmdClass
  local cmd = self.cmdMap[owner]
  interval = interval or 33
  if cmd == nil then
    cmd = cmdClass.new(interval)
    self.cmdMap[owner] = cmd
  end
end
function FunctionCDCommand:StartAllCD()
  for k, v in pairs(self.cmdMap) do
    if v:IsRunning() == false then
      v:SetEnable(true)
    end
  end
end
function FunctionCDCommand:Update(deltaTime)
  local cdMap = CDProxy.Instance.cdMap
  deltaTime = deltaTime / 1000
  for k, maps in pairs(cdMap) do
    local removes
    for id, cdData in pairs(maps) do
      cdData:CalCd(-deltaTime)
      if cdData:GetCd() <= 0 and cdData:GetPureCdMax() ~= nil then
        removes = removes or {}
        removes[#removes + 1] = id
      end
    end
    if removes then
      for i = 1, #removes do
        maps[removes[i]] = nil
      end
    end
  end
end
