NetMonitor = class("NetMonitor")
function NetMonitor.Me()
  if nil == NetMonitor.me then
    NetMonitor.me = NetMonitor.new()
  end
  return NetMonitor.me
end
function NetMonitor:ctor()
  self.idCall = {}
end
function NetMonitor:InitCallBack()
  NetManager.SetSocketSendCallBack(function(protocolID)
    self:HandleSendDone(protocolID)
  end)
end
function NetMonitor:AddSendCallBack(id1, id2, call)
  local map = self.idCall[id1]
  if map == nil then
    map = {}
    self.idCall[id1] = map
  end
  map[id2] = call
  NetManager.AddSendCallBackProtocolID(id1, id2)
end
function NetMonitor:HandleSendDone(protocolID)
  local map = self.idCall[protocolID.id1]
  if map == nil or not map[protocolID.id2] then
    local call
  end
  if call then
    call()
  end
end
function NetMonitor:ListenSkillUseSendCallBack()
  self:AddSendCallBack(5, 27, function()
    if self.skillUsedLuaTimeSpan then
      printRed("send use skill delta:" .. os.time() - self.skillUsedLuaTimeSpan)
    end
    self.skillUsedLuaTimeSpan = os.time()
    if self.skillUsedServerTime then
      printRed("SkillAttackedHandler delta:" .. ServerTime.CurServerTime() - self.skillUsedServerTime)
    end
    self.skillUsedServerTime = ServerTime.CurServerTime()
  end)
end
