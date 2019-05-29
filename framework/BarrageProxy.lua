BarrageProxy = class("BarrageProxy", pm.Proxy)
BarrageProxy.Instance = nil
BarrageProxy.NAME = "BarrageProxy"
function BarrageProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BarrageProxy.NAME
  if BarrageProxy.Instance == nil then
    BarrageProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function BarrageProxy:Init()
  self.unlockFrameIDs = {}
end
function BarrageProxy:RecvSystemBarrageChatCmd(serverData)
  self.sysBarrageID = serverData.msgid
end
function BarrageProxy:GetSysBarrageID()
  return self.sysBarrageID
end
function BarrageProxy:RecvUnlockFrameUserCmd(serverData)
  TableUtility.TableClear(self.unlockFrameIDs)
  local unlockFrames = serverData.frameid
  for i = 1, #unlockFrames do
    self.unlockFrameIDs[unlockFrames[i]] = 1
  end
end
function BarrageProxy:IsFrameUnlocked(frameid)
  return frameid == 1 or self.unlockFrameIDs[frameid] == 1
end
