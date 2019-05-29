ServiceStatCmdAutoProxy = class("ServiceStatCmdAutoProxy", ServiceProxy)
ServiceStatCmdAutoProxy.Instance = nil
ServiceStatCmdAutoProxy.NAME = "ServiceStatCmdAutoProxy"
function ServiceStatCmdAutoProxy:ctor(proxyName)
  if ServiceStatCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceStatCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceStatCmdAutoProxy.Instance = self
  end
end
function ServiceStatCmdAutoProxy:Init()
end
function ServiceStatCmdAutoProxy:onRegister()
  self:Listen(207, 1, function(data)
    self:RecvTestStatCmd(data)
  end)
  self:Listen(207, 2, function(data)
    self:RecvStatCmd(data)
  end)
  self:Listen(207, 3, function(data)
    self:RecvTradeToStatLogCmd(data)
  end)
  self:Listen(207, 4, function(data)
    self:RecvKillMonsterNumStatCmd(data)
  end)
  self:Listen(207, 5, function(data)
    self:RecvDayGetZenyCountCmd(data)
  end)
  self:Listen(207, 6, function(data)
    self:RecvStatCurLevel(data)
  end)
  self:Listen(207, 7, function(data)
    self:RecvReqWorldLevelCmd(data)
  end)
  self:Listen(207, 8, function(data)
    self:RecvPetWearUseCountStatCmd(data)
  end)
end
function ServiceStatCmdAutoProxy:CallTestStatCmd()
  local msg = StatCmd_pb.TestStatCmd()
  self:SendProto(msg)
end
function ServiceStatCmdAutoProxy:CallStatCmd(type, key, subkey, subkey2, level, value1, value2, isfloat)
  local msg = StatCmd_pb.StatCmd()
  if type ~= nil then
    msg.type = type
  end
  if key ~= nil then
    msg.key = key
  end
  if subkey ~= nil then
    msg.subkey = subkey
  end
  if subkey2 ~= nil then
    msg.subkey2 = subkey2
  end
  if level ~= nil then
    msg.level = level
  end
  if value1 ~= nil then
    msg.value1 = value1
  end
  if value2 ~= nil then
    msg.value2 = value2
  end
  if isfloat ~= nil then
    msg.isfloat = isfloat
  end
  self:SendProto(msg)
end
function ServiceStatCmdAutoProxy:CallTradeToStatLogCmd(eType, itemid, price, count, sellerid, buyerid, pendingtime, tradetime, refinelv, itemdata, buyername, elisttype)
  local msg = StatCmd_pb.TradeToStatLogCmd()
  msg.eType = eType
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if price ~= nil then
    msg.price = price
  end
  if count ~= nil then
    msg.count = count
  end
  if sellerid ~= nil then
    msg.sellerid = sellerid
  end
  if buyerid ~= nil then
    msg.buyerid = buyerid
  end
  if pendingtime ~= nil then
    msg.pendingtime = pendingtime
  end
  if tradetime ~= nil then
    msg.tradetime = tradetime
  end
  if refinelv ~= nil then
    msg.refinelv = refinelv
  end
  if itemdata.base ~= nil and itemdata.base.guid ~= nil then
    msg.itemdata.base.guid = itemdata.base.guid
  end
  if itemdata.base ~= nil and itemdata.base.id ~= nil then
    msg.itemdata.base.id = itemdata.base.id
  end
  if itemdata.base ~= nil and itemdata.base.count ~= nil then
    msg.itemdata.base.count = itemdata.base.count
  end
  if itemdata.base ~= nil and itemdata.base.index ~= nil then
    msg.itemdata.base.index = itemdata.base.index
  end
  if itemdata.base ~= nil and itemdata.base.createtime ~= nil then
    msg.itemdata.base.createtime = itemdata.base.createtime
  end
  if itemdata.base ~= nil and itemdata.base.cd ~= nil then
    msg.itemdata.base.cd = itemdata.base.cd
  end
  if itemdata.base ~= nil and itemdata.base.type ~= nil then
    msg.itemdata.base.type = itemdata.base.type
  end
  if itemdata.base ~= nil and itemdata.base.bind ~= nil then
    msg.itemdata.base.bind = itemdata.base.bind
  end
  if itemdata.base ~= nil and itemdata.base.expire ~= nil then
    msg.itemdata.base.expire = itemdata.base.expire
  end
  if itemdata.base ~= nil and itemdata.base.quality ~= nil then
    msg.itemdata.base.quality = itemdata.base.quality
  end
  if itemdata.base ~= nil and itemdata.base.equipType ~= nil then
    msg.itemdata.base.equipType = itemdata.base.equipType
  end
  if itemdata.base ~= nil and itemdata.base.source ~= nil then
    msg.itemdata.base.source = itemdata.base.source
  end
  if itemdata.base ~= nil and itemdata.base.isnew ~= nil then
    msg.itemdata.base.isnew = itemdata.base.isnew
  end
  if itemdata.base ~= nil and itemdata.base.maxcardslot ~= nil then
    msg.itemdata.base.maxcardslot = itemdata.base.maxcardslot
  end
  if itemdata.base ~= nil and itemdata.base.ishint ~= nil then
    msg.itemdata.base.ishint = itemdata.base.ishint
  end
  if itemdata.base ~= nil and itemdata.base.isactive ~= nil then
    msg.itemdata.base.isactive = itemdata.base.isactive
  end
  if itemdata.base ~= nil and itemdata.base.source_npc ~= nil then
    msg.itemdata.base.source_npc = itemdata.base.source_npc
  end
  if itemdata.base ~= nil and itemdata.base.refinelv ~= nil then
    msg.itemdata.base.refinelv = itemdata.base.refinelv
  end
  if itemdata.base ~= nil and itemdata.base.chargemoney ~= nil then
    msg.itemdata.base.chargemoney = itemdata.base.chargemoney
  end
  if itemdata.base ~= nil and itemdata.base.overtime ~= nil then
    msg.itemdata.base.overtime = itemdata.base.overtime
  end
  if itemdata.base ~= nil and itemdata.base.quota ~= nil then
    msg.itemdata.base.quota = itemdata.base.quota
  end
  if itemdata.base ~= nil and itemdata.base.usedtimes ~= nil then
    msg.itemdata.base.usedtimes = itemdata.base.usedtimes
  end
  if itemdata.base ~= nil and itemdata.base.usedtime ~= nil then
    msg.itemdata.base.usedtime = itemdata.base.usedtime
  end
  if itemdata ~= nil and itemdata.equiped ~= nil then
    msg.itemdata.equiped = itemdata.equiped
  end
  if itemdata ~= nil and itemdata.battlepoint ~= nil then
    msg.itemdata.battlepoint = itemdata.battlepoint
  end
  if itemdata.equip ~= nil and itemdata.equip.strengthlv ~= nil then
    msg.itemdata.equip.strengthlv = itemdata.equip.strengthlv
  end
  if itemdata.equip ~= nil and itemdata.equip.refinelv ~= nil then
    msg.itemdata.equip.refinelv = itemdata.equip.refinelv
  end
  if itemdata.equip ~= nil and itemdata.equip.strengthCost ~= nil then
    msg.itemdata.equip.strengthCost = itemdata.equip.strengthCost
  end
  if itemdata ~= nil and itemdata.equip.refineCompose ~= nil then
    for i = 1, #itemdata.equip.refineCompose do
      table.insert(msg.itemdata.equip.refineCompose, itemdata.equip.refineCompose[i])
    end
  end
  if itemdata.equip ~= nil and itemdata.equip.cardslot ~= nil then
    msg.itemdata.equip.cardslot = itemdata.equip.cardslot
  end
  if itemdata ~= nil and itemdata.equip.buffid ~= nil then
    for i = 1, #itemdata.equip.buffid do
      table.insert(msg.itemdata.equip.buffid, itemdata.equip.buffid[i])
    end
  end
  if itemdata.equip ~= nil and itemdata.equip.damage ~= nil then
    msg.itemdata.equip.damage = itemdata.equip.damage
  end
  if itemdata.equip ~= nil and itemdata.equip.lv ~= nil then
    msg.itemdata.equip.lv = itemdata.equip.lv
  end
  if itemdata.equip ~= nil and itemdata.equip.color ~= nil then
    msg.itemdata.equip.color = itemdata.equip.color
  end
  if itemdata.equip ~= nil and itemdata.equip.breakstarttime ~= nil then
    msg.itemdata.equip.breakstarttime = itemdata.equip.breakstarttime
  end
  if itemdata.equip ~= nil and itemdata.equip.breakendtime ~= nil then
    msg.itemdata.equip.breakendtime = itemdata.equip.breakendtime
  end
  if itemdata.equip ~= nil and itemdata.equip.strengthlv2 ~= nil then
    msg.itemdata.equip.strengthlv2 = itemdata.equip.strengthlv2
  end
  if itemdata ~= nil and itemdata.equip.strengthlv2cost ~= nil then
    for i = 1, #itemdata.equip.strengthlv2cost do
      table.insert(msg.itemdata.equip.strengthlv2cost, itemdata.equip.strengthlv2cost[i])
    end
  end
  if itemdata ~= nil and itemdata.card ~= nil then
    for i = 1, #itemdata.card do
      table.insert(msg.itemdata.card, itemdata.card[i])
    end
  end
  if itemdata.enchant ~= nil and itemdata.enchant.type ~= nil then
    msg.itemdata.enchant.type = itemdata.enchant.type
  end
  if itemdata ~= nil and itemdata.enchant.attrs ~= nil then
    for i = 1, #itemdata.enchant.attrs do
      table.insert(msg.itemdata.enchant.attrs, itemdata.enchant.attrs[i])
    end
  end
  if itemdata ~= nil and itemdata.enchant.extras ~= nil then
    for i = 1, #itemdata.enchant.extras do
      table.insert(msg.itemdata.enchant.extras, itemdata.enchant.extras[i])
    end
  end
  if itemdata ~= nil and itemdata.enchant.patch ~= nil then
    for i = 1, #itemdata.enchant.patch do
      table.insert(msg.itemdata.enchant.patch, itemdata.enchant.patch[i])
    end
  end
  if itemdata.previewenchant ~= nil and itemdata.previewenchant.type ~= nil then
    msg.itemdata.previewenchant.type = itemdata.previewenchant.type
  end
  if itemdata ~= nil and itemdata.previewenchant.attrs ~= nil then
    for i = 1, #itemdata.previewenchant.attrs do
      table.insert(msg.itemdata.previewenchant.attrs, itemdata.previewenchant.attrs[i])
    end
  end
  if itemdata ~= nil and itemdata.previewenchant.extras ~= nil then
    for i = 1, #itemdata.previewenchant.extras do
      table.insert(msg.itemdata.previewenchant.extras, itemdata.previewenchant.extras[i])
    end
  end
  if itemdata ~= nil and itemdata.previewenchant.patch ~= nil then
    for i = 1, #itemdata.previewenchant.patch do
      table.insert(msg.itemdata.previewenchant.patch, itemdata.previewenchant.patch[i])
    end
  end
  if itemdata.refine ~= nil and itemdata.refine.lastfail ~= nil then
    msg.itemdata.refine.lastfail = itemdata.refine.lastfail
  end
  if itemdata.refine ~= nil and itemdata.refine.repaircount ~= nil then
    msg.itemdata.refine.repaircount = itemdata.refine.repaircount
  end
  if itemdata.egg ~= nil and itemdata.egg.exp ~= nil then
    msg.itemdata.egg.exp = itemdata.egg.exp
  end
  if itemdata.egg ~= nil and itemdata.egg.friendexp ~= nil then
    msg.itemdata.egg.friendexp = itemdata.egg.friendexp
  end
  if itemdata.egg ~= nil and itemdata.egg.rewardexp ~= nil then
    msg.itemdata.egg.rewardexp = itemdata.egg.rewardexp
  end
  if itemdata.egg ~= nil and itemdata.egg.id ~= nil then
    msg.itemdata.egg.id = itemdata.egg.id
  end
  if itemdata.egg ~= nil and itemdata.egg.lv ~= nil then
    msg.itemdata.egg.lv = itemdata.egg.lv
  end
  if itemdata.egg ~= nil and itemdata.egg.friendlv ~= nil then
    msg.itemdata.egg.friendlv = itemdata.egg.friendlv
  end
  if itemdata.egg ~= nil and itemdata.egg.body ~= nil then
    msg.itemdata.egg.body = itemdata.egg.body
  end
  if itemdata.egg ~= nil and itemdata.egg.relivetime ~= nil then
    msg.itemdata.egg.relivetime = itemdata.egg.relivetime
  end
  if itemdata.egg ~= nil and itemdata.egg.hp ~= nil then
    msg.itemdata.egg.hp = itemdata.egg.hp
  end
  if itemdata.egg ~= nil and itemdata.egg.restoretime ~= nil then
    msg.itemdata.egg.restoretime = itemdata.egg.restoretime
  end
  if itemdata.egg ~= nil and itemdata.egg.time_happly ~= nil then
    msg.itemdata.egg.time_happly = itemdata.egg.time_happly
  end
  if itemdata.egg ~= nil and itemdata.egg.time_excite ~= nil then
    msg.itemdata.egg.time_excite = itemdata.egg.time_excite
  end
  if itemdata.egg ~= nil and itemdata.egg.time_happiness ~= nil then
    msg.itemdata.egg.time_happiness = itemdata.egg.time_happiness
  end
  if itemdata.egg ~= nil and itemdata.egg.time_happly_gift ~= nil then
    msg.itemdata.egg.time_happly_gift = itemdata.egg.time_happly_gift
  end
  if itemdata.egg ~= nil and itemdata.egg.time_excite_gift ~= nil then
    msg.itemdata.egg.time_excite_gift = itemdata.egg.time_excite_gift
  end
  if itemdata.egg ~= nil and itemdata.egg.time_happiness_gift ~= nil then
    msg.itemdata.egg.time_happiness_gift = itemdata.egg.time_happiness_gift
  end
  if itemdata.egg ~= nil and itemdata.egg.touch_tick ~= nil then
    msg.itemdata.egg.touch_tick = itemdata.egg.touch_tick
  end
  if itemdata.egg ~= nil and itemdata.egg.feed_tick ~= nil then
    msg.itemdata.egg.feed_tick = itemdata.egg.feed_tick
  end
  if itemdata.egg ~= nil and itemdata.egg.name ~= nil then
    msg.itemdata.egg.name = itemdata.egg.name
  end
  if itemdata.egg ~= nil and itemdata.egg.var ~= nil then
    msg.itemdata.egg.var = itemdata.egg.var
  end
  if itemdata ~= nil and itemdata.egg.skillids ~= nil then
    for i = 1, #itemdata.egg.skillids do
      table.insert(msg.itemdata.egg.skillids, itemdata.egg.skillids[i])
    end
  end
  if itemdata ~= nil and itemdata.egg.equips ~= nil then
    for i = 1, #itemdata.egg.equips do
      table.insert(msg.itemdata.egg.equips, itemdata.egg.equips[i])
    end
  end
  if itemdata.egg ~= nil and itemdata.egg.buff ~= nil then
    msg.itemdata.egg.buff = itemdata.egg.buff
  end
  if itemdata ~= nil and itemdata.egg.unlock_equip ~= nil then
    for i = 1, #itemdata.egg.unlock_equip do
      table.insert(msg.itemdata.egg.unlock_equip, itemdata.egg.unlock_equip[i])
    end
  end
  if itemdata ~= nil and itemdata.egg.unlock_body ~= nil then
    for i = 1, #itemdata.egg.unlock_body do
      table.insert(msg.itemdata.egg.unlock_body, itemdata.egg.unlock_body[i])
    end
  end
  if itemdata.egg ~= nil and itemdata.egg.version ~= nil then
    msg.itemdata.egg.version = itemdata.egg.version
  end
  if itemdata.egg ~= nil and itemdata.egg.skilloff ~= nil then
    msg.itemdata.egg.skilloff = itemdata.egg.skilloff
  end
  if itemdata.egg ~= nil and itemdata.egg.exchange_count ~= nil then
    msg.itemdata.egg.exchange_count = itemdata.egg.exchange_count
  end
  if itemdata.egg ~= nil and itemdata.egg.guid ~= nil then
    msg.itemdata.egg.guid = itemdata.egg.guid
  end
  if itemdata ~= nil and itemdata.egg.defaultwears ~= nil then
    for i = 1, #itemdata.egg.defaultwears do
      table.insert(msg.itemdata.egg.defaultwears, itemdata.egg.defaultwears[i])
    end
  end
  if itemdata ~= nil and itemdata.egg.wears ~= nil then
    for i = 1, #itemdata.egg.wears do
      table.insert(msg.itemdata.egg.wears, itemdata.egg.wears[i])
    end
  end
  if itemdata.letter ~= nil and itemdata.letter.sendUserName ~= nil then
    msg.itemdata.letter.sendUserName = itemdata.letter.sendUserName
  end
  if itemdata.letter ~= nil and itemdata.letter.bg ~= nil then
    msg.itemdata.letter.bg = itemdata.letter.bg
  end
  if itemdata.letter ~= nil and itemdata.letter.configID ~= nil then
    msg.itemdata.letter.configID = itemdata.letter.configID
  end
  if itemdata.letter ~= nil and itemdata.letter.content ~= nil then
    msg.itemdata.letter.content = itemdata.letter.content
  end
  if itemdata.letter ~= nil and itemdata.letter.content2 ~= nil then
    msg.itemdata.letter.content2 = itemdata.letter.content2
  end
  if itemdata.code ~= nil and itemdata.code.code ~= nil then
    msg.itemdata.code.code = itemdata.code.code
  end
  if itemdata.code ~= nil and itemdata.code.used ~= nil then
    msg.itemdata.code.used = itemdata.code.used
  end
  if itemdata.wedding ~= nil and itemdata.wedding.id ~= nil then
    msg.itemdata.wedding.id = itemdata.wedding.id
  end
  if itemdata.wedding ~= nil and itemdata.wedding.zoneid ~= nil then
    msg.itemdata.wedding.zoneid = itemdata.wedding.zoneid
  end
  if itemdata.wedding ~= nil and itemdata.wedding.charid1 ~= nil then
    msg.itemdata.wedding.charid1 = itemdata.wedding.charid1
  end
  if itemdata.wedding ~= nil and itemdata.wedding.charid2 ~= nil then
    msg.itemdata.wedding.charid2 = itemdata.wedding.charid2
  end
  if itemdata.wedding ~= nil and itemdata.wedding.weddingtime ~= nil then
    msg.itemdata.wedding.weddingtime = itemdata.wedding.weddingtime
  end
  if itemdata.wedding ~= nil and itemdata.wedding.photoidx ~= nil then
    msg.itemdata.wedding.photoidx = itemdata.wedding.photoidx
  end
  if itemdata.wedding ~= nil and itemdata.wedding.phototime ~= nil then
    msg.itemdata.wedding.phototime = itemdata.wedding.phototime
  end
  if itemdata.wedding ~= nil and itemdata.wedding.myname ~= nil then
    msg.itemdata.wedding.myname = itemdata.wedding.myname
  end
  if itemdata.wedding ~= nil and itemdata.wedding.partnername ~= nil then
    msg.itemdata.wedding.partnername = itemdata.wedding.partnername
  end
  if itemdata.wedding ~= nil and itemdata.wedding.starttime ~= nil then
    msg.itemdata.wedding.starttime = itemdata.wedding.starttime
  end
  if itemdata.wedding ~= nil and itemdata.wedding.endtime ~= nil then
    msg.itemdata.wedding.endtime = itemdata.wedding.endtime
  end
  if itemdata.wedding ~= nil and itemdata.wedding.notified ~= nil then
    msg.itemdata.wedding.notified = itemdata.wedding.notified
  end
  if itemdata.sender ~= nil and itemdata.sender.charid ~= nil then
    msg.itemdata.sender.charid = itemdata.sender.charid
  end
  if itemdata.sender ~= nil and itemdata.sender.name ~= nil then
    msg.itemdata.sender.name = itemdata.sender.name
  end
  if buyername ~= nil then
    msg.buyername = buyername
  end
  msg.elisttype = elisttype
  self:SendProto(msg)
end
function ServiceStatCmdAutoProxy:CallKillMonsterNumStatCmd(userid, killmonster, zoneid, professionid)
  local msg = StatCmd_pb.KillMonsterNumStatCmd()
  msg.userid = userid
  if killmonster ~= nil then
    for i = 1, #killmonster do
      table.insert(msg.killmonster, killmonster[i])
    end
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if professionid ~= nil then
    msg.professionid = professionid
  end
  self:SendProto(msg)
end
function ServiceStatCmdAutoProxy:CallDayGetZenyCountCmd(userid, username, baselv, joblv, profession, normal_zeny, charge_zeny)
  local msg = StatCmd_pb.DayGetZenyCountCmd()
  msg.userid = userid
  if username ~= nil then
    msg.username = username
  end
  if baselv ~= nil then
    msg.baselv = baselv
  end
  if joblv ~= nil then
    msg.joblv = joblv
  end
  if profession ~= nil then
    msg.profession = profession
  end
  if normal_zeny ~= nil then
    msg.normal_zeny = normal_zeny
  end
  if charge_zeny ~= nil then
    msg.charge_zeny = charge_zeny
  end
  self:SendProto(msg)
end
function ServiceStatCmdAutoProxy:CallStatCurLevel(userid, last_offlinetime, last_baselv, last_joblv, cur_time, cur_baselv, cur_joblv)
  local msg = StatCmd_pb.StatCurLevel()
  msg.userid = userid
  if last_offlinetime ~= nil then
    msg.last_offlinetime = last_offlinetime
  end
  if last_baselv ~= nil then
    msg.last_baselv = last_baselv
  end
  if last_joblv ~= nil then
    msg.last_joblv = last_joblv
  end
  if cur_time ~= nil then
    msg.cur_time = cur_time
  end
  if cur_baselv ~= nil then
    msg.cur_baselv = cur_baselv
  end
  if cur_joblv ~= nil then
    msg.cur_joblv = cur_joblv
  end
  self:SendProto(msg)
end
function ServiceStatCmdAutoProxy:CallReqWorldLevelCmd(zoneid)
  local msg = StatCmd_pb.ReqWorldLevelCmd()
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceStatCmdAutoProxy:CallPetWearUseCountStatCmd(wears)
  local msg = StatCmd_pb.PetWearUseCountStatCmd()
  if wears ~= nil then
    for i = 1, #wears do
      table.insert(msg.wears, wears[i])
    end
  end
  self:SendProto(msg)
end
function ServiceStatCmdAutoProxy:RecvTestStatCmd(data)
  self:Notify(ServiceEvent.StatCmdTestStatCmd, data)
end
function ServiceStatCmdAutoProxy:RecvStatCmd(data)
  self:Notify(ServiceEvent.StatCmdStatCmd, data)
end
function ServiceStatCmdAutoProxy:RecvTradeToStatLogCmd(data)
  self:Notify(ServiceEvent.StatCmdTradeToStatLogCmd, data)
end
function ServiceStatCmdAutoProxy:RecvKillMonsterNumStatCmd(data)
  self:Notify(ServiceEvent.StatCmdKillMonsterNumStatCmd, data)
end
function ServiceStatCmdAutoProxy:RecvDayGetZenyCountCmd(data)
  self:Notify(ServiceEvent.StatCmdDayGetZenyCountCmd, data)
end
function ServiceStatCmdAutoProxy:RecvStatCurLevel(data)
  self:Notify(ServiceEvent.StatCmdStatCurLevel, data)
end
function ServiceStatCmdAutoProxy:RecvReqWorldLevelCmd(data)
  self:Notify(ServiceEvent.StatCmdReqWorldLevelCmd, data)
end
function ServiceStatCmdAutoProxy:RecvPetWearUseCountStatCmd(data)
  self:Notify(ServiceEvent.StatCmdPetWearUseCountStatCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.StatCmdTestStatCmd = "ServiceEvent_StatCmdTestStatCmd"
ServiceEvent.StatCmdStatCmd = "ServiceEvent_StatCmdStatCmd"
ServiceEvent.StatCmdTradeToStatLogCmd = "ServiceEvent_StatCmdTradeToStatLogCmd"
ServiceEvent.StatCmdKillMonsterNumStatCmd = "ServiceEvent_StatCmdKillMonsterNumStatCmd"
ServiceEvent.StatCmdDayGetZenyCountCmd = "ServiceEvent_StatCmdDayGetZenyCountCmd"
ServiceEvent.StatCmdStatCurLevel = "ServiceEvent_StatCmdStatCurLevel"
ServiceEvent.StatCmdReqWorldLevelCmd = "ServiceEvent_StatCmdReqWorldLevelCmd"
ServiceEvent.StatCmdPetWearUseCountStatCmd = "ServiceEvent_StatCmdPetWearUseCountStatCmd"
