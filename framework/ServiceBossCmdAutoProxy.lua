ServiceBossCmdAutoProxy = class("ServiceBossCmdAutoProxy", ServiceProxy)
ServiceBossCmdAutoProxy.Instance = nil
ServiceBossCmdAutoProxy.NAME = "ServiceBossCmdAutoProxy"
function ServiceBossCmdAutoProxy:ctor(proxyName)
  if ServiceBossCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceBossCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceBossCmdAutoProxy.Instance = self
  end
end
function ServiceBossCmdAutoProxy:Init()
end
function ServiceBossCmdAutoProxy:onRegister()
  self:Listen(15, 1, function(data)
    self:RecvBossListUserCmd(data)
  end)
  self:Listen(15, 2, function(data)
    self:RecvBossPosUserCmd(data)
  end)
  self:Listen(15, 3, function(data)
    self:RecvKillBossUserCmd(data)
  end)
  self:Listen(15, 4, function(data)
    self:RecvQueryKillerInfoBossCmd(data)
  end)
  self:Listen(15, 5, function(data)
    self:RecvWorldBossNtf(data)
  end)
  self:Listen(15, 6, function(data)
    self:RecvStepSyncBossCmd(data)
  end)
end
function ServiceBossCmdAutoProxy:CallBossListUserCmd(bosslist, minilist, deadlist)
  local msg = BossCmd_pb.BossListUserCmd()
  if bosslist ~= nil then
    for i = 1, #bosslist do
      table.insert(msg.bosslist, bosslist[i])
    end
  end
  if minilist ~= nil then
    for i = 1, #minilist do
      table.insert(msg.minilist, minilist[i])
    end
  end
  if deadlist ~= nil then
    for i = 1, #deadlist do
      table.insert(msg.deadlist, deadlist[i])
    end
  end
  self:SendProto(msg)
end
function ServiceBossCmdAutoProxy:CallBossPosUserCmd(pos)
  local msg = BossCmd_pb.BossPosUserCmd()
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  self:SendProto(msg)
end
function ServiceBossCmdAutoProxy:CallKillBossUserCmd(userid)
  local msg = BossCmd_pb.KillBossUserCmd()
  if userid ~= nil then
    msg.userid = userid
  end
  self:SendProto(msg)
end
function ServiceBossCmdAutoProxy:CallQueryKillerInfoBossCmd(charid, userdata)
  local msg = BossCmd_pb.QueryKillerInfoBossCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if userdata ~= nil and userdata.charid ~= nil then
    msg.userdata.charid = userdata.charid
  end
  if userdata ~= nil and userdata.portrait ~= nil then
    msg.userdata.portrait = userdata.portrait
  end
  if userdata ~= nil and userdata.frame ~= nil then
    msg.userdata.frame = userdata.frame
  end
  if userdata ~= nil and userdata.baselevel ~= nil then
    msg.userdata.baselevel = userdata.baselevel
  end
  if userdata ~= nil and userdata.hair ~= nil then
    msg.userdata.hair = userdata.hair
  end
  if userdata ~= nil and userdata.haircolor ~= nil then
    msg.userdata.haircolor = userdata.haircolor
  end
  if userdata ~= nil and userdata.body ~= nil then
    msg.userdata.body = userdata.body
  end
  if userdata ~= nil and userdata.head ~= nil then
    msg.userdata.head = userdata.head
  end
  if userdata ~= nil and userdata.face ~= nil then
    msg.userdata.face = userdata.face
  end
  if userdata ~= nil and userdata.mouth ~= nil then
    msg.userdata.mouth = userdata.mouth
  end
  if userdata ~= nil and userdata.eye ~= nil then
    msg.userdata.eye = userdata.eye
  end
  if userdata ~= nil and userdata.blink ~= nil then
    msg.userdata.blink = userdata.blink
  end
  if userdata ~= nil and userdata.profession ~= nil then
    msg.userdata.profession = userdata.profession
  end
  if userdata ~= nil and userdata.gender ~= nil then
    msg.userdata.gender = userdata.gender
  end
  if userdata ~= nil and userdata.name ~= nil then
    msg.userdata.name = userdata.name
  end
  if userdata ~= nil and userdata.guildname ~= nil then
    msg.userdata.guildname = userdata.guildname
  end
  self:SendProto(msg)
end
function ServiceBossCmdAutoProxy:CallWorldBossNtf(npcid, mapid, time, open)
  local msg = BossCmd_pb.WorldBossNtf()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if time ~= nil then
    msg.time = time
  end
  if open ~= nil then
    msg.open = open
  end
  self:SendProto(msg)
end
function ServiceBossCmdAutoProxy:CallStepSyncBossCmd(actid, step, params)
  local msg = BossCmd_pb.StepSyncBossCmd()
  if actid ~= nil then
    msg.actid = actid
  end
  if step ~= nil then
    msg.step = step
  end
  if params ~= nil and params.params ~= nil then
    for i = 1, #params.params do
      table.insert(msg.params.params, params.params[i])
    end
  end
  self:SendProto(msg)
end
function ServiceBossCmdAutoProxy:RecvBossListUserCmd(data)
  self:Notify(ServiceEvent.BossCmdBossListUserCmd, data)
end
function ServiceBossCmdAutoProxy:RecvBossPosUserCmd(data)
  self:Notify(ServiceEvent.BossCmdBossPosUserCmd, data)
end
function ServiceBossCmdAutoProxy:RecvKillBossUserCmd(data)
  self:Notify(ServiceEvent.BossCmdKillBossUserCmd, data)
end
function ServiceBossCmdAutoProxy:RecvQueryKillerInfoBossCmd(data)
  self:Notify(ServiceEvent.BossCmdQueryKillerInfoBossCmd, data)
end
function ServiceBossCmdAutoProxy:RecvWorldBossNtf(data)
  self:Notify(ServiceEvent.BossCmdWorldBossNtf, data)
end
function ServiceBossCmdAutoProxy:RecvStepSyncBossCmd(data)
  self:Notify(ServiceEvent.BossCmdStepSyncBossCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.BossCmdBossListUserCmd = "ServiceEvent_BossCmdBossListUserCmd"
ServiceEvent.BossCmdBossPosUserCmd = "ServiceEvent_BossCmdBossPosUserCmd"
ServiceEvent.BossCmdKillBossUserCmd = "ServiceEvent_BossCmdKillBossUserCmd"
ServiceEvent.BossCmdQueryKillerInfoBossCmd = "ServiceEvent_BossCmdQueryKillerInfoBossCmd"
ServiceEvent.BossCmdWorldBossNtf = "ServiceEvent_BossCmdWorldBossNtf"
ServiceEvent.BossCmdStepSyncBossCmd = "ServiceEvent_BossCmdStepSyncBossCmd"
