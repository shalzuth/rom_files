ServiceBossSCmdAutoProxy = class("ServiceBossSCmdAutoProxy", ServiceProxy)
ServiceBossSCmdAutoProxy.Instance = nil
ServiceBossSCmdAutoProxy.NAME = "ServiceBossSCmdAutoProxy"
function ServiceBossSCmdAutoProxy:ctor(proxyName)
  if ServiceBossSCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceBossSCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceBossSCmdAutoProxy.Instance = self
  end
end
function ServiceBossSCmdAutoProxy:Init()
end
function ServiceBossSCmdAutoProxy:onRegister()
  self:Listen(216, 1, function(data)
    self:RecvDeadBossOpenBossSCmd(data)
  end)
  self:Listen(216, 2, function(data)
    self:RecvDeadBossOpenSyncBossSCmd(data)
  end)
  self:Listen(216, 3, function(data)
    self:RecvSummonBossBossSCmd(data)
  end)
  self:Listen(216, 4, function(data)
    self:RecvBossDieBossSCmd(data)
  end)
  self:Listen(216, 5, function(data)
    self:RecvWorldBossNtfBossSCmd(data)
  end)
  self:Listen(216, 6, function(data)
    self:RecvBossSetBossSCmd(data)
  end)
end
function ServiceBossSCmdAutoProxy:CallDeadBossOpenBossSCmd(info)
  local msg = BossSCmd_pb.DeadBossOpenBossSCmd()
  if info ~= nil and info.charid ~= nil then
    msg.info.charid = info.charid
  end
  if info ~= nil and info.zoneid ~= nil then
    msg.info.zoneid = info.zoneid
  end
  if info ~= nil and info.time ~= nil then
    msg.info.time = info.time
  end
  if info ~= nil and info.name ~= nil then
    msg.info.name = info.name
  end
  self:SendProto(msg)
end
function ServiceBossSCmdAutoProxy:CallDeadBossOpenSyncBossSCmd(info)
  local msg = BossSCmd_pb.DeadBossOpenSyncBossSCmd()
  if info ~= nil and info.charid ~= nil then
    msg.info.charid = info.charid
  end
  if info ~= nil and info.zoneid ~= nil then
    msg.info.zoneid = info.zoneid
  end
  if info ~= nil and info.time ~= nil then
    msg.info.time = info.time
  end
  if info ~= nil and info.name ~= nil then
    msg.info.name = info.name
  end
  self:SendProto(msg)
end
function ServiceBossSCmdAutoProxy:CallSummonBossBossSCmd(mapid, npcid, bosstype, lv)
  local msg = BossSCmd_pb.SummonBossBossSCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if bosstype ~= nil then
    msg.bosstype = bosstype
  end
  if lv ~= nil then
    msg.lv = lv
  end
  self:SendProto(msg)
end
function ServiceBossSCmdAutoProxy:CallBossDieBossSCmd(npcid, killer, killid, mapid, reset)
  local msg = BossSCmd_pb.BossDieBossSCmd()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if killer ~= nil then
    msg.killer = killer
  end
  if killid ~= nil then
    msg.killid = killid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if reset ~= nil then
    msg.reset = reset
  end
  self:SendProto(msg)
end
function ServiceBossSCmdAutoProxy:CallWorldBossNtfBossSCmd(ntf)
  local msg = BossSCmd_pb.WorldBossNtfBossSCmd()
  if ntf ~= nil and ntf.cmd ~= nil then
    msg.ntf.cmd = ntf.cmd
  end
  if ntf ~= nil and ntf.param ~= nil then
    msg.ntf.param = ntf.param
  end
  if ntf ~= nil and ntf.npcid ~= nil then
    msg.ntf.npcid = ntf.npcid
  end
  if ntf ~= nil and ntf.mapid ~= nil then
    msg.ntf.mapid = ntf.mapid
  end
  if ntf ~= nil and ntf.time ~= nil then
    msg.ntf.time = ntf.time
  end
  if ntf ~= nil and ntf.open ~= nil then
    msg.ntf.open = ntf.open
  end
  self:SendProto(msg)
end
function ServiceBossSCmdAutoProxy:CallBossSetBossSCmd()
  local msg = BossSCmd_pb.BossSetBossSCmd()
  self:SendProto(msg)
end
function ServiceBossSCmdAutoProxy:RecvDeadBossOpenBossSCmd(data)
  self:Notify(ServiceEvent.BossSCmdDeadBossOpenBossSCmd, data)
end
function ServiceBossSCmdAutoProxy:RecvDeadBossOpenSyncBossSCmd(data)
  self:Notify(ServiceEvent.BossSCmdDeadBossOpenSyncBossSCmd, data)
end
function ServiceBossSCmdAutoProxy:RecvSummonBossBossSCmd(data)
  self:Notify(ServiceEvent.BossSCmdSummonBossBossSCmd, data)
end
function ServiceBossSCmdAutoProxy:RecvBossDieBossSCmd(data)
  self:Notify(ServiceEvent.BossSCmdBossDieBossSCmd, data)
end
function ServiceBossSCmdAutoProxy:RecvWorldBossNtfBossSCmd(data)
  self:Notify(ServiceEvent.BossSCmdWorldBossNtfBossSCmd, data)
end
function ServiceBossSCmdAutoProxy:RecvBossSetBossSCmd(data)
  self:Notify(ServiceEvent.BossSCmdBossSetBossSCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.BossSCmdDeadBossOpenBossSCmd = "ServiceEvent_BossSCmdDeadBossOpenBossSCmd"
ServiceEvent.BossSCmdDeadBossOpenSyncBossSCmd = "ServiceEvent_BossSCmdDeadBossOpenSyncBossSCmd"
ServiceEvent.BossSCmdSummonBossBossSCmd = "ServiceEvent_BossSCmdSummonBossBossSCmd"
ServiceEvent.BossSCmdBossDieBossSCmd = "ServiceEvent_BossSCmdBossDieBossSCmd"
ServiceEvent.BossSCmdWorldBossNtfBossSCmd = "ServiceEvent_BossSCmdWorldBossNtfBossSCmd"
ServiceEvent.BossSCmdBossSetBossSCmd = "ServiceEvent_BossSCmdBossSetBossSCmd"
