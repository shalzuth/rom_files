autoImport("ServiceBossCmdAutoProxy")
ServiceBossCmdProxy = class("ServiceBossCmdProxy", ServiceBossCmdAutoProxy)
ServiceBossCmdProxy.Instance = nil
ServiceBossCmdProxy.NAME = "ServiceBossCmdProxy"
ServiceBossCmdProxy.BossType = {
  MVP = BossCmd_pb.ESETTYPE_BOSS,
  WORLD = BossCmd_pb.ESETTYPE_WORLD,
  DEATH = BossCmd_pb.ESETTYPE_DEAD
}
function ServiceBossCmdProxy:ctor(proxyName)
  if ServiceBossCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceBossCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceBossCmdProxy.Instance = self
  end
end
function ServiceBossCmdProxy:RecvBossListUserCmd(data)
  local mvplist = {}
  local deathlist = {}
  if data.bosslist ~= nil then
    for i = 1, #data.bosslist do
      local v = data.bosslist[i]
      if Table_Boss[v.id] then
        local new = {}
        local delta = ServerTime.ServerDeltaSecondTime(v.refreshTime * 1000)
        if v.settime ~= 0 then
          if delta > 0 or v.summontime <= v.dietime and delta <= 0 then
            if Table_Boss[v.id].MvpID then
              new.id = Table_Boss[v.id].MvpID
              new.priority = 1
            else
              new.id = v.id
              new.priority = 2
            end
          else
            new.id = v.id
            new.priority = 1
          end
        else
          new.id = v.id
          new.priority = 1
        end
        local bdata = Table_Boss[new.id]
        new.staticData = bdata
        new.time = v.refreshTime
        new.killerID = v.charid
        new.killer = v.lastKiller
        new.mapid = v.mapid
        new.dietime = v.dietime
        new.bosstype = bdata.Type
        new.settime = v.settime
        new.summontime = v.summontime
        if bdata.Type == 3 then
          new.lv = v.lv
        else
          new.lv = Table_Monster[new.id].Level
        end
        new.listtype = 1
        table.insert(mvplist, new)
      else
        errorLog(string.format("Not Find BossID(%s) In Table_Boss", v.id))
      end
    end
  end
  local deathlist = {}
  if data.deadlist then
    local len = #data.deadlist
    for i = 1, len do
      local single = {}
      local v = data.deadlist[i]
      local sdata = Table_Boss[v.id]
      single.staticData = sdata
      single.id = v.id
      single.lv = v.lv
      single.killerID = v.charid
      single.time = v.refreshTime
      single.settime = v.settime
      single.killer = v.lastKiller
      single.mapid = sdata.Map[1]
      single.bosstype = sdata.Type
      single.listtype = 2
      single.priority = 1
      single.dietime = v.dietime
      single.summontime = v.summontime
      table.insert(deathlist, single)
    end
  end
  local minilist = {}
  if data.minilist ~= nil then
    for i = 1, #data.minilist do
      local v = data.minilist[i]
      local mdata = Table_Boss[v.id]
      if mdata then
        local new = {}
        new.id = v.id
        new.staticData = mdata
        new.time = v.refreshTime
        new.killerID = v.charid
        new.killer = v.lastKiller
        new.mapid = v.mapid
        new.bosstype = mdata.Type
        new.summontime = v.summontime
        new.listtype = 1
        new.priority = 1
        table.insert(minilist, new)
      else
        errorLog(string.format("Not Find BossID(%s) In Table_Boss", v.id))
      end
    end
  end
  self:Notify(ServiceEvent.BossCmdBossListUserCmd, {
    mvplist,
    minilist,
    deathlist
  })
end
function ServiceBossCmdProxy:RecvBossPosUserCmd(data)
  self:Notify(ServiceEvent.BossCmdBossPosUserCmd, data)
end
function ServiceBossCmdProxy:RecvKillBossUserCmd(data)
  self:Notify(ServiceEvent.BossCmdKillBossUserCmd, data)
end
function ServiceBossCmdAutoProxy:RecvStepSyncBossCmd(data)
  QuestProxy.Instance:RecvStepSyncBossCmd(data)
  self:Notify(ServiceEvent.BossCmdStepSyncBossCmd, data)
end
