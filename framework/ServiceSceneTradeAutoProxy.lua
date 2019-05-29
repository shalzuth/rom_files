ServiceSceneTradeAutoProxy = class("ServiceSceneTradeAutoProxy", ServiceProxy)
ServiceSceneTradeAutoProxy.Instance = nil
ServiceSceneTradeAutoProxy.NAME = "ServiceSceneTradeAutoProxy"
function ServiceSceneTradeAutoProxy:ctor(proxyName)
  if ServiceSceneTradeAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneTradeAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneTradeAutoProxy.Instance = self
  end
end
function ServiceSceneTradeAutoProxy:Init()
end
function ServiceSceneTradeAutoProxy:onRegister()
  self:Listen(26, 1, function(data)
    self:RecvFrostItemListSceneTradeCmd(data)
  end)
  self:Listen(201, 3, function(data)
    self:RecvReduceMoneyRecordTradeCmd(data)
  end)
  self:Listen(201, 4, function(data)
    self:RecvAddItemRecordTradeCmd(data)
  end)
  self:Listen(201, 5, function(data)
    self:RecvAddMoneyRecordTradeCmd(data)
  end)
  self:Listen(201, 6, function(data)
    self:RecvReduceItemRecordTrade(data)
  end)
  self:Listen(201, 1, function(data)
    self:RecvSessionToMeRecordTrade(data)
  end)
  self:Listen(201, 7, function(data)
    self:RecvSessionForwardUsercmdTrade(data)
  end)
  self:Listen(201, 8, function(data)
    self:RecvSessionForwardScenecmdTrade(data)
  end)
  self:Listen(201, 9, function(data)
    self:RecvForwardUserCmdToRecordCmd(data)
  end)
  self:Listen(201, 10, function(data)
    self:RecvWorldMsgCmd(data)
  end)
  self:Listen(201, 11, function(data)
    self:RecvUpdateTradeLogCmd(data)
  end)
  self:Listen(201, 12, function(data)
    self:RecvGiveCheckMoneySceneTradeCmd(data)
  end)
  self:Listen(201, 13, function(data)
    self:RecvSyncGiveItemSceneTradeCmd(data)
  end)
  self:Listen(201, 14, function(data)
    self:RecvAddGiveSceneTradeCmd(data)
  end)
  self:Listen(201, 15, function(data)
    self:RecvDelGiveSceneTradeCmd(data)
  end)
  self:Listen(201, 17, function(data)
    self:RecvAddGiveItemSceneTradeCmd(data)
  end)
  self:Listen(201, 16, function(data)
    self:RecvReceiveGiveSceneTradeCmd(data)
  end)
  self:Listen(201, 18, function(data)
    self:RecvNtfGiveStatusSceneTradeCmd(data)
  end)
  self:Listen(201, 19, function(data)
    self:RecvReduceQuotaSceneTradeCmd(data)
  end)
  self:Listen(201, 24, function(data)
    self:RecvUnlockQuotaSceneTradeCmd(data)
  end)
  self:Listen(201, 20, function(data)
    self:RecvExtraPermissionSceneTradeCmd(data)
  end)
  self:Listen(201, 21, function(data)
    self:RecvSecurityCmdSceneTradeCmd(data)
  end)
  self:Listen(201, 22, function(data)
    self:RecvTradePriceQueryTradeCmd(data)
  end)
  self:Listen(201, 23, function(data)
    self:RecvBoothOpenTradeCmd(data)
  end)
end
function ServiceSceneTradeAutoProxy:CallFrostItemListSceneTradeCmd(lists)
  local msg = SceneTrade_pb.FrostItemListSceneTradeCmd()
  if lists ~= nil then
    for i = 1, #lists do
      table.insert(msg.lists, lists[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallReduceMoneyRecordTradeCmd(money_type, total_money, ret, charid, item_info, quota, type, record_id, lock_quota)
  local msg = SceneTrade_pb.ReduceMoneyRecordTradeCmd()
  if money_type ~= nil then
    msg.money_type = money_type
  end
  if total_money ~= nil then
    msg.total_money = total_money
  end
  if ret ~= nil then
    msg.ret = ret
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if item_info ~= nil and item_info.itemid ~= nil then
    msg.item_info.itemid = item_info.itemid
  end
  if item_info ~= nil and item_info.price ~= nil then
    msg.item_info.price = item_info.price
  end
  if item_info ~= nil and item_info.count ~= nil then
    msg.item_info.count = item_info.count
  end
  if item_info ~= nil and item_info.guid ~= nil then
    msg.item_info.guid = item_info.guid
  end
  if item_info ~= nil and item_info.order_id ~= nil then
    msg.item_info.order_id = item_info.order_id
  end
  if item_info ~= nil and item_info.refine_lv ~= nil then
    msg.item_info.refine_lv = item_info.refine_lv
  end
  if item_info ~= nil and item_info.overlap ~= nil then
    msg.item_info.overlap = item_info.overlap
  end
  if item_info ~= nil and item_info.is_expired ~= nil then
    msg.item_info.is_expired = item_info.is_expired
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.guid ~= nil then
    msg.item_info.item_data.base.guid = item_info.item_data.base.guid
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.id ~= nil then
    msg.item_info.item_data.base.id = item_info.item_data.base.id
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.count ~= nil then
    msg.item_info.item_data.base.count = item_info.item_data.base.count
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.index ~= nil then
    msg.item_info.item_data.base.index = item_info.item_data.base.index
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.createtime ~= nil then
    msg.item_info.item_data.base.createtime = item_info.item_data.base.createtime
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.cd ~= nil then
    msg.item_info.item_data.base.cd = item_info.item_data.base.cd
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.type ~= nil then
    msg.item_info.item_data.base.type = item_info.item_data.base.type
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.bind ~= nil then
    msg.item_info.item_data.base.bind = item_info.item_data.base.bind
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.expire ~= nil then
    msg.item_info.item_data.base.expire = item_info.item_data.base.expire
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.quality ~= nil then
    msg.item_info.item_data.base.quality = item_info.item_data.base.quality
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.equipType ~= nil then
    msg.item_info.item_data.base.equipType = item_info.item_data.base.equipType
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.source ~= nil then
    msg.item_info.item_data.base.source = item_info.item_data.base.source
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.isnew ~= nil then
    msg.item_info.item_data.base.isnew = item_info.item_data.base.isnew
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.maxcardslot ~= nil then
    msg.item_info.item_data.base.maxcardslot = item_info.item_data.base.maxcardslot
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.ishint ~= nil then
    msg.item_info.item_data.base.ishint = item_info.item_data.base.ishint
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.isactive ~= nil then
    msg.item_info.item_data.base.isactive = item_info.item_data.base.isactive
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.source_npc ~= nil then
    msg.item_info.item_data.base.source_npc = item_info.item_data.base.source_npc
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.refinelv ~= nil then
    msg.item_info.item_data.base.refinelv = item_info.item_data.base.refinelv
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.chargemoney ~= nil then
    msg.item_info.item_data.base.chargemoney = item_info.item_data.base.chargemoney
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.overtime ~= nil then
    msg.item_info.item_data.base.overtime = item_info.item_data.base.overtime
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.quota ~= nil then
    msg.item_info.item_data.base.quota = item_info.item_data.base.quota
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.usedtimes ~= nil then
    msg.item_info.item_data.base.usedtimes = item_info.item_data.base.usedtimes
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.usedtime ~= nil then
    msg.item_info.item_data.base.usedtime = item_info.item_data.base.usedtime
  end
  if item_info.item_data ~= nil and item_info.item_data.equiped ~= nil then
    msg.item_info.item_data.equiped = item_info.item_data.equiped
  end
  if item_info.item_data ~= nil and item_info.item_data.battlepoint ~= nil then
    msg.item_info.item_data.battlepoint = item_info.item_data.battlepoint
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.strengthlv ~= nil then
    msg.item_info.item_data.equip.strengthlv = item_info.item_data.equip.strengthlv
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.refinelv ~= nil then
    msg.item_info.item_data.equip.refinelv = item_info.item_data.equip.refinelv
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.strengthCost ~= nil then
    msg.item_info.item_data.equip.strengthCost = item_info.item_data.equip.strengthCost
  end
  if item_info ~= nil and item_info.item_data.equip.refineCompose ~= nil then
    for i = 1, #item_info.item_data.equip.refineCompose do
      table.insert(msg.item_info.item_data.equip.refineCompose, item_info.item_data.equip.refineCompose[i])
    end
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.cardslot ~= nil then
    msg.item_info.item_data.equip.cardslot = item_info.item_data.equip.cardslot
  end
  if item_info ~= nil and item_info.item_data.equip.buffid ~= nil then
    for i = 1, #item_info.item_data.equip.buffid do
      table.insert(msg.item_info.item_data.equip.buffid, item_info.item_data.equip.buffid[i])
    end
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.damage ~= nil then
    msg.item_info.item_data.equip.damage = item_info.item_data.equip.damage
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.lv ~= nil then
    msg.item_info.item_data.equip.lv = item_info.item_data.equip.lv
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.color ~= nil then
    msg.item_info.item_data.equip.color = item_info.item_data.equip.color
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.breakstarttime ~= nil then
    msg.item_info.item_data.equip.breakstarttime = item_info.item_data.equip.breakstarttime
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.breakendtime ~= nil then
    msg.item_info.item_data.equip.breakendtime = item_info.item_data.equip.breakendtime
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.strengthlv2 ~= nil then
    msg.item_info.item_data.equip.strengthlv2 = item_info.item_data.equip.strengthlv2
  end
  if item_info ~= nil and item_info.item_data.equip.strengthlv2cost ~= nil then
    for i = 1, #item_info.item_data.equip.strengthlv2cost do
      table.insert(msg.item_info.item_data.equip.strengthlv2cost, item_info.item_data.equip.strengthlv2cost[i])
    end
  end
  if item_info ~= nil and item_info.item_data.card ~= nil then
    for i = 1, #item_info.item_data.card do
      table.insert(msg.item_info.item_data.card, item_info.item_data.card[i])
    end
  end
  if item_info.item_data.enchant ~= nil and item_info.item_data.enchant.type ~= nil then
    msg.item_info.item_data.enchant.type = item_info.item_data.enchant.type
  end
  if item_info ~= nil and item_info.item_data.enchant.attrs ~= nil then
    for i = 1, #item_info.item_data.enchant.attrs do
      table.insert(msg.item_info.item_data.enchant.attrs, item_info.item_data.enchant.attrs[i])
    end
  end
  if item_info ~= nil and item_info.item_data.enchant.extras ~= nil then
    for i = 1, #item_info.item_data.enchant.extras do
      table.insert(msg.item_info.item_data.enchant.extras, item_info.item_data.enchant.extras[i])
    end
  end
  if item_info ~= nil and item_info.item_data.enchant.patch ~= nil then
    for i = 1, #item_info.item_data.enchant.patch do
      table.insert(msg.item_info.item_data.enchant.patch, item_info.item_data.enchant.patch[i])
    end
  end
  if item_info.item_data.previewenchant ~= nil and item_info.item_data.previewenchant.type ~= nil then
    msg.item_info.item_data.previewenchant.type = item_info.item_data.previewenchant.type
  end
  if item_info ~= nil and item_info.item_data.previewenchant.attrs ~= nil then
    for i = 1, #item_info.item_data.previewenchant.attrs do
      table.insert(msg.item_info.item_data.previewenchant.attrs, item_info.item_data.previewenchant.attrs[i])
    end
  end
  if item_info ~= nil and item_info.item_data.previewenchant.extras ~= nil then
    for i = 1, #item_info.item_data.previewenchant.extras do
      table.insert(msg.item_info.item_data.previewenchant.extras, item_info.item_data.previewenchant.extras[i])
    end
  end
  if item_info ~= nil and item_info.item_data.previewenchant.patch ~= nil then
    for i = 1, #item_info.item_data.previewenchant.patch do
      table.insert(msg.item_info.item_data.previewenchant.patch, item_info.item_data.previewenchant.patch[i])
    end
  end
  if item_info.item_data.refine ~= nil and item_info.item_data.refine.lastfail ~= nil then
    msg.item_info.item_data.refine.lastfail = item_info.item_data.refine.lastfail
  end
  if item_info.item_data.refine ~= nil and item_info.item_data.refine.repaircount ~= nil then
    msg.item_info.item_data.refine.repaircount = item_info.item_data.refine.repaircount
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.exp ~= nil then
    msg.item_info.item_data.egg.exp = item_info.item_data.egg.exp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.friendexp ~= nil then
    msg.item_info.item_data.egg.friendexp = item_info.item_data.egg.friendexp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.rewardexp ~= nil then
    msg.item_info.item_data.egg.rewardexp = item_info.item_data.egg.rewardexp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.id ~= nil then
    msg.item_info.item_data.egg.id = item_info.item_data.egg.id
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.lv ~= nil then
    msg.item_info.item_data.egg.lv = item_info.item_data.egg.lv
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.friendlv ~= nil then
    msg.item_info.item_data.egg.friendlv = item_info.item_data.egg.friendlv
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.body ~= nil then
    msg.item_info.item_data.egg.body = item_info.item_data.egg.body
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.relivetime ~= nil then
    msg.item_info.item_data.egg.relivetime = item_info.item_data.egg.relivetime
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.hp ~= nil then
    msg.item_info.item_data.egg.hp = item_info.item_data.egg.hp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.restoretime ~= nil then
    msg.item_info.item_data.egg.restoretime = item_info.item_data.egg.restoretime
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happly ~= nil then
    msg.item_info.item_data.egg.time_happly = item_info.item_data.egg.time_happly
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_excite ~= nil then
    msg.item_info.item_data.egg.time_excite = item_info.item_data.egg.time_excite
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happiness ~= nil then
    msg.item_info.item_data.egg.time_happiness = item_info.item_data.egg.time_happiness
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happly_gift ~= nil then
    msg.item_info.item_data.egg.time_happly_gift = item_info.item_data.egg.time_happly_gift
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_excite_gift ~= nil then
    msg.item_info.item_data.egg.time_excite_gift = item_info.item_data.egg.time_excite_gift
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happiness_gift ~= nil then
    msg.item_info.item_data.egg.time_happiness_gift = item_info.item_data.egg.time_happiness_gift
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.touch_tick ~= nil then
    msg.item_info.item_data.egg.touch_tick = item_info.item_data.egg.touch_tick
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.feed_tick ~= nil then
    msg.item_info.item_data.egg.feed_tick = item_info.item_data.egg.feed_tick
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.name ~= nil then
    msg.item_info.item_data.egg.name = item_info.item_data.egg.name
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.var ~= nil then
    msg.item_info.item_data.egg.var = item_info.item_data.egg.var
  end
  if item_info ~= nil and item_info.item_data.egg.skillids ~= nil then
    for i = 1, #item_info.item_data.egg.skillids do
      table.insert(msg.item_info.item_data.egg.skillids, item_info.item_data.egg.skillids[i])
    end
  end
  if item_info ~= nil and item_info.item_data.egg.equips ~= nil then
    for i = 1, #item_info.item_data.egg.equips do
      table.insert(msg.item_info.item_data.egg.equips, item_info.item_data.egg.equips[i])
    end
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.buff ~= nil then
    msg.item_info.item_data.egg.buff = item_info.item_data.egg.buff
  end
  if item_info ~= nil and item_info.item_data.egg.unlock_equip ~= nil then
    for i = 1, #item_info.item_data.egg.unlock_equip do
      table.insert(msg.item_info.item_data.egg.unlock_equip, item_info.item_data.egg.unlock_equip[i])
    end
  end
  if item_info ~= nil and item_info.item_data.egg.unlock_body ~= nil then
    for i = 1, #item_info.item_data.egg.unlock_body do
      table.insert(msg.item_info.item_data.egg.unlock_body, item_info.item_data.egg.unlock_body[i])
    end
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.version ~= nil then
    msg.item_info.item_data.egg.version = item_info.item_data.egg.version
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.skilloff ~= nil then
    msg.item_info.item_data.egg.skilloff = item_info.item_data.egg.skilloff
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.exchange_count ~= nil then
    msg.item_info.item_data.egg.exchange_count = item_info.item_data.egg.exchange_count
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.guid ~= nil then
    msg.item_info.item_data.egg.guid = item_info.item_data.egg.guid
  end
  if item_info ~= nil and item_info.item_data.egg.defaultwears ~= nil then
    for i = 1, #item_info.item_data.egg.defaultwears do
      table.insert(msg.item_info.item_data.egg.defaultwears, item_info.item_data.egg.defaultwears[i])
    end
  end
  if item_info ~= nil and item_info.item_data.egg.wears ~= nil then
    for i = 1, #item_info.item_data.egg.wears do
      table.insert(msg.item_info.item_data.egg.wears, item_info.item_data.egg.wears[i])
    end
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.sendUserName ~= nil then
    msg.item_info.item_data.letter.sendUserName = item_info.item_data.letter.sendUserName
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.bg ~= nil then
    msg.item_info.item_data.letter.bg = item_info.item_data.letter.bg
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.configID ~= nil then
    msg.item_info.item_data.letter.configID = item_info.item_data.letter.configID
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.content ~= nil then
    msg.item_info.item_data.letter.content = item_info.item_data.letter.content
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.content2 ~= nil then
    msg.item_info.item_data.letter.content2 = item_info.item_data.letter.content2
  end
  if item_info.item_data.code ~= nil and item_info.item_data.code.code ~= nil then
    msg.item_info.item_data.code.code = item_info.item_data.code.code
  end
  if item_info.item_data.code ~= nil and item_info.item_data.code.used ~= nil then
    msg.item_info.item_data.code.used = item_info.item_data.code.used
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.id ~= nil then
    msg.item_info.item_data.wedding.id = item_info.item_data.wedding.id
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.zoneid ~= nil then
    msg.item_info.item_data.wedding.zoneid = item_info.item_data.wedding.zoneid
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.charid1 ~= nil then
    msg.item_info.item_data.wedding.charid1 = item_info.item_data.wedding.charid1
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.charid2 ~= nil then
    msg.item_info.item_data.wedding.charid2 = item_info.item_data.wedding.charid2
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.weddingtime ~= nil then
    msg.item_info.item_data.wedding.weddingtime = item_info.item_data.wedding.weddingtime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.photoidx ~= nil then
    msg.item_info.item_data.wedding.photoidx = item_info.item_data.wedding.photoidx
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.phototime ~= nil then
    msg.item_info.item_data.wedding.phototime = item_info.item_data.wedding.phototime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.myname ~= nil then
    msg.item_info.item_data.wedding.myname = item_info.item_data.wedding.myname
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.partnername ~= nil then
    msg.item_info.item_data.wedding.partnername = item_info.item_data.wedding.partnername
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.starttime ~= nil then
    msg.item_info.item_data.wedding.starttime = item_info.item_data.wedding.starttime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.endtime ~= nil then
    msg.item_info.item_data.wedding.endtime = item_info.item_data.wedding.endtime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.notified ~= nil then
    msg.item_info.item_data.wedding.notified = item_info.item_data.wedding.notified
  end
  if item_info.item_data.sender ~= nil and item_info.item_data.sender.charid ~= nil then
    msg.item_info.item_data.sender.charid = item_info.item_data.sender.charid
  end
  if item_info.item_data.sender ~= nil and item_info.item_data.sender.name ~= nil then
    msg.item_info.item_data.sender.name = item_info.item_data.sender.name
  end
  if item_info ~= nil and item_info.publicity_id ~= nil then
    msg.item_info.publicity_id = item_info.publicity_id
  end
  if item_info ~= nil and item_info.end_time ~= nil then
    msg.item_info.end_time = item_info.end_time
  end
  if item_info ~= nil and item_info.key ~= nil then
    msg.item_info.key = item_info.key
  end
  if item_info ~= nil and item_info.charid ~= nil then
    msg.item_info.charid = item_info.charid
  end
  if item_info ~= nil and item_info.name ~= nil then
    msg.item_info.name = item_info.name
  end
  if item_info ~= nil and item_info.type ~= nil then
    msg.item_info.type = item_info.type
  end
  if item_info ~= nil and item_info.up_rate ~= nil then
    msg.item_info.up_rate = item_info.up_rate
  end
  if item_info ~= nil and item_info.down_rate ~= nil then
    msg.item_info.down_rate = item_info.down_rate
  end
  if quota ~= nil then
    msg.quota = quota
  end
  if type ~= nil then
    msg.type = type
  end
  if record_id ~= nil then
    msg.record_id = record_id
  end
  if lock_quota ~= nil then
    msg.lock_quota = lock_quota
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallAddItemRecordTradeCmd(item_info, charid, addtype, total_quota)
  local msg = SceneTrade_pb.AddItemRecordTradeCmd()
  if item_info ~= nil and item_info.itemid ~= nil then
    msg.item_info.itemid = item_info.itemid
  end
  if item_info ~= nil and item_info.price ~= nil then
    msg.item_info.price = item_info.price
  end
  if item_info ~= nil and item_info.count ~= nil then
    msg.item_info.count = item_info.count
  end
  if item_info ~= nil and item_info.guid ~= nil then
    msg.item_info.guid = item_info.guid
  end
  if item_info ~= nil and item_info.order_id ~= nil then
    msg.item_info.order_id = item_info.order_id
  end
  if item_info ~= nil and item_info.refine_lv ~= nil then
    msg.item_info.refine_lv = item_info.refine_lv
  end
  if item_info ~= nil and item_info.overlap ~= nil then
    msg.item_info.overlap = item_info.overlap
  end
  if item_info ~= nil and item_info.is_expired ~= nil then
    msg.item_info.is_expired = item_info.is_expired
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.guid ~= nil then
    msg.item_info.item_data.base.guid = item_info.item_data.base.guid
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.id ~= nil then
    msg.item_info.item_data.base.id = item_info.item_data.base.id
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.count ~= nil then
    msg.item_info.item_data.base.count = item_info.item_data.base.count
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.index ~= nil then
    msg.item_info.item_data.base.index = item_info.item_data.base.index
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.createtime ~= nil then
    msg.item_info.item_data.base.createtime = item_info.item_data.base.createtime
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.cd ~= nil then
    msg.item_info.item_data.base.cd = item_info.item_data.base.cd
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.type ~= nil then
    msg.item_info.item_data.base.type = item_info.item_data.base.type
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.bind ~= nil then
    msg.item_info.item_data.base.bind = item_info.item_data.base.bind
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.expire ~= nil then
    msg.item_info.item_data.base.expire = item_info.item_data.base.expire
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.quality ~= nil then
    msg.item_info.item_data.base.quality = item_info.item_data.base.quality
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.equipType ~= nil then
    msg.item_info.item_data.base.equipType = item_info.item_data.base.equipType
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.source ~= nil then
    msg.item_info.item_data.base.source = item_info.item_data.base.source
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.isnew ~= nil then
    msg.item_info.item_data.base.isnew = item_info.item_data.base.isnew
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.maxcardslot ~= nil then
    msg.item_info.item_data.base.maxcardslot = item_info.item_data.base.maxcardslot
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.ishint ~= nil then
    msg.item_info.item_data.base.ishint = item_info.item_data.base.ishint
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.isactive ~= nil then
    msg.item_info.item_data.base.isactive = item_info.item_data.base.isactive
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.source_npc ~= nil then
    msg.item_info.item_data.base.source_npc = item_info.item_data.base.source_npc
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.refinelv ~= nil then
    msg.item_info.item_data.base.refinelv = item_info.item_data.base.refinelv
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.chargemoney ~= nil then
    msg.item_info.item_data.base.chargemoney = item_info.item_data.base.chargemoney
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.overtime ~= nil then
    msg.item_info.item_data.base.overtime = item_info.item_data.base.overtime
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.quota ~= nil then
    msg.item_info.item_data.base.quota = item_info.item_data.base.quota
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.usedtimes ~= nil then
    msg.item_info.item_data.base.usedtimes = item_info.item_data.base.usedtimes
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.usedtime ~= nil then
    msg.item_info.item_data.base.usedtime = item_info.item_data.base.usedtime
  end
  if item_info.item_data ~= nil and item_info.item_data.equiped ~= nil then
    msg.item_info.item_data.equiped = item_info.item_data.equiped
  end
  if item_info.item_data ~= nil and item_info.item_data.battlepoint ~= nil then
    msg.item_info.item_data.battlepoint = item_info.item_data.battlepoint
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.strengthlv ~= nil then
    msg.item_info.item_data.equip.strengthlv = item_info.item_data.equip.strengthlv
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.refinelv ~= nil then
    msg.item_info.item_data.equip.refinelv = item_info.item_data.equip.refinelv
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.strengthCost ~= nil then
    msg.item_info.item_data.equip.strengthCost = item_info.item_data.equip.strengthCost
  end
  if item_info ~= nil and item_info.item_data.equip.refineCompose ~= nil then
    for i = 1, #item_info.item_data.equip.refineCompose do
      table.insert(msg.item_info.item_data.equip.refineCompose, item_info.item_data.equip.refineCompose[i])
    end
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.cardslot ~= nil then
    msg.item_info.item_data.equip.cardslot = item_info.item_data.equip.cardslot
  end
  if item_info ~= nil and item_info.item_data.equip.buffid ~= nil then
    for i = 1, #item_info.item_data.equip.buffid do
      table.insert(msg.item_info.item_data.equip.buffid, item_info.item_data.equip.buffid[i])
    end
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.damage ~= nil then
    msg.item_info.item_data.equip.damage = item_info.item_data.equip.damage
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.lv ~= nil then
    msg.item_info.item_data.equip.lv = item_info.item_data.equip.lv
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.color ~= nil then
    msg.item_info.item_data.equip.color = item_info.item_data.equip.color
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.breakstarttime ~= nil then
    msg.item_info.item_data.equip.breakstarttime = item_info.item_data.equip.breakstarttime
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.breakendtime ~= nil then
    msg.item_info.item_data.equip.breakendtime = item_info.item_data.equip.breakendtime
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.strengthlv2 ~= nil then
    msg.item_info.item_data.equip.strengthlv2 = item_info.item_data.equip.strengthlv2
  end
  if item_info ~= nil and item_info.item_data.equip.strengthlv2cost ~= nil then
    for i = 1, #item_info.item_data.equip.strengthlv2cost do
      table.insert(msg.item_info.item_data.equip.strengthlv2cost, item_info.item_data.equip.strengthlv2cost[i])
    end
  end
  if item_info ~= nil and item_info.item_data.card ~= nil then
    for i = 1, #item_info.item_data.card do
      table.insert(msg.item_info.item_data.card, item_info.item_data.card[i])
    end
  end
  if item_info.item_data.enchant ~= nil and item_info.item_data.enchant.type ~= nil then
    msg.item_info.item_data.enchant.type = item_info.item_data.enchant.type
  end
  if item_info ~= nil and item_info.item_data.enchant.attrs ~= nil then
    for i = 1, #item_info.item_data.enchant.attrs do
      table.insert(msg.item_info.item_data.enchant.attrs, item_info.item_data.enchant.attrs[i])
    end
  end
  if item_info ~= nil and item_info.item_data.enchant.extras ~= nil then
    for i = 1, #item_info.item_data.enchant.extras do
      table.insert(msg.item_info.item_data.enchant.extras, item_info.item_data.enchant.extras[i])
    end
  end
  if item_info ~= nil and item_info.item_data.enchant.patch ~= nil then
    for i = 1, #item_info.item_data.enchant.patch do
      table.insert(msg.item_info.item_data.enchant.patch, item_info.item_data.enchant.patch[i])
    end
  end
  if item_info.item_data.previewenchant ~= nil and item_info.item_data.previewenchant.type ~= nil then
    msg.item_info.item_data.previewenchant.type = item_info.item_data.previewenchant.type
  end
  if item_info ~= nil and item_info.item_data.previewenchant.attrs ~= nil then
    for i = 1, #item_info.item_data.previewenchant.attrs do
      table.insert(msg.item_info.item_data.previewenchant.attrs, item_info.item_data.previewenchant.attrs[i])
    end
  end
  if item_info ~= nil and item_info.item_data.previewenchant.extras ~= nil then
    for i = 1, #item_info.item_data.previewenchant.extras do
      table.insert(msg.item_info.item_data.previewenchant.extras, item_info.item_data.previewenchant.extras[i])
    end
  end
  if item_info ~= nil and item_info.item_data.previewenchant.patch ~= nil then
    for i = 1, #item_info.item_data.previewenchant.patch do
      table.insert(msg.item_info.item_data.previewenchant.patch, item_info.item_data.previewenchant.patch[i])
    end
  end
  if item_info.item_data.refine ~= nil and item_info.item_data.refine.lastfail ~= nil then
    msg.item_info.item_data.refine.lastfail = item_info.item_data.refine.lastfail
  end
  if item_info.item_data.refine ~= nil and item_info.item_data.refine.repaircount ~= nil then
    msg.item_info.item_data.refine.repaircount = item_info.item_data.refine.repaircount
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.exp ~= nil then
    msg.item_info.item_data.egg.exp = item_info.item_data.egg.exp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.friendexp ~= nil then
    msg.item_info.item_data.egg.friendexp = item_info.item_data.egg.friendexp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.rewardexp ~= nil then
    msg.item_info.item_data.egg.rewardexp = item_info.item_data.egg.rewardexp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.id ~= nil then
    msg.item_info.item_data.egg.id = item_info.item_data.egg.id
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.lv ~= nil then
    msg.item_info.item_data.egg.lv = item_info.item_data.egg.lv
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.friendlv ~= nil then
    msg.item_info.item_data.egg.friendlv = item_info.item_data.egg.friendlv
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.body ~= nil then
    msg.item_info.item_data.egg.body = item_info.item_data.egg.body
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.relivetime ~= nil then
    msg.item_info.item_data.egg.relivetime = item_info.item_data.egg.relivetime
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.hp ~= nil then
    msg.item_info.item_data.egg.hp = item_info.item_data.egg.hp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.restoretime ~= nil then
    msg.item_info.item_data.egg.restoretime = item_info.item_data.egg.restoretime
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happly ~= nil then
    msg.item_info.item_data.egg.time_happly = item_info.item_data.egg.time_happly
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_excite ~= nil then
    msg.item_info.item_data.egg.time_excite = item_info.item_data.egg.time_excite
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happiness ~= nil then
    msg.item_info.item_data.egg.time_happiness = item_info.item_data.egg.time_happiness
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happly_gift ~= nil then
    msg.item_info.item_data.egg.time_happly_gift = item_info.item_data.egg.time_happly_gift
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_excite_gift ~= nil then
    msg.item_info.item_data.egg.time_excite_gift = item_info.item_data.egg.time_excite_gift
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happiness_gift ~= nil then
    msg.item_info.item_data.egg.time_happiness_gift = item_info.item_data.egg.time_happiness_gift
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.touch_tick ~= nil then
    msg.item_info.item_data.egg.touch_tick = item_info.item_data.egg.touch_tick
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.feed_tick ~= nil then
    msg.item_info.item_data.egg.feed_tick = item_info.item_data.egg.feed_tick
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.name ~= nil then
    msg.item_info.item_data.egg.name = item_info.item_data.egg.name
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.var ~= nil then
    msg.item_info.item_data.egg.var = item_info.item_data.egg.var
  end
  if item_info ~= nil and item_info.item_data.egg.skillids ~= nil then
    for i = 1, #item_info.item_data.egg.skillids do
      table.insert(msg.item_info.item_data.egg.skillids, item_info.item_data.egg.skillids[i])
    end
  end
  if item_info ~= nil and item_info.item_data.egg.equips ~= nil then
    for i = 1, #item_info.item_data.egg.equips do
      table.insert(msg.item_info.item_data.egg.equips, item_info.item_data.egg.equips[i])
    end
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.buff ~= nil then
    msg.item_info.item_data.egg.buff = item_info.item_data.egg.buff
  end
  if item_info ~= nil and item_info.item_data.egg.unlock_equip ~= nil then
    for i = 1, #item_info.item_data.egg.unlock_equip do
      table.insert(msg.item_info.item_data.egg.unlock_equip, item_info.item_data.egg.unlock_equip[i])
    end
  end
  if item_info ~= nil and item_info.item_data.egg.unlock_body ~= nil then
    for i = 1, #item_info.item_data.egg.unlock_body do
      table.insert(msg.item_info.item_data.egg.unlock_body, item_info.item_data.egg.unlock_body[i])
    end
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.version ~= nil then
    msg.item_info.item_data.egg.version = item_info.item_data.egg.version
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.skilloff ~= nil then
    msg.item_info.item_data.egg.skilloff = item_info.item_data.egg.skilloff
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.exchange_count ~= nil then
    msg.item_info.item_data.egg.exchange_count = item_info.item_data.egg.exchange_count
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.guid ~= nil then
    msg.item_info.item_data.egg.guid = item_info.item_data.egg.guid
  end
  if item_info ~= nil and item_info.item_data.egg.defaultwears ~= nil then
    for i = 1, #item_info.item_data.egg.defaultwears do
      table.insert(msg.item_info.item_data.egg.defaultwears, item_info.item_data.egg.defaultwears[i])
    end
  end
  if item_info ~= nil and item_info.item_data.egg.wears ~= nil then
    for i = 1, #item_info.item_data.egg.wears do
      table.insert(msg.item_info.item_data.egg.wears, item_info.item_data.egg.wears[i])
    end
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.sendUserName ~= nil then
    msg.item_info.item_data.letter.sendUserName = item_info.item_data.letter.sendUserName
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.bg ~= nil then
    msg.item_info.item_data.letter.bg = item_info.item_data.letter.bg
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.configID ~= nil then
    msg.item_info.item_data.letter.configID = item_info.item_data.letter.configID
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.content ~= nil then
    msg.item_info.item_data.letter.content = item_info.item_data.letter.content
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.content2 ~= nil then
    msg.item_info.item_data.letter.content2 = item_info.item_data.letter.content2
  end
  if item_info.item_data.code ~= nil and item_info.item_data.code.code ~= nil then
    msg.item_info.item_data.code.code = item_info.item_data.code.code
  end
  if item_info.item_data.code ~= nil and item_info.item_data.code.used ~= nil then
    msg.item_info.item_data.code.used = item_info.item_data.code.used
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.id ~= nil then
    msg.item_info.item_data.wedding.id = item_info.item_data.wedding.id
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.zoneid ~= nil then
    msg.item_info.item_data.wedding.zoneid = item_info.item_data.wedding.zoneid
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.charid1 ~= nil then
    msg.item_info.item_data.wedding.charid1 = item_info.item_data.wedding.charid1
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.charid2 ~= nil then
    msg.item_info.item_data.wedding.charid2 = item_info.item_data.wedding.charid2
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.weddingtime ~= nil then
    msg.item_info.item_data.wedding.weddingtime = item_info.item_data.wedding.weddingtime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.photoidx ~= nil then
    msg.item_info.item_data.wedding.photoidx = item_info.item_data.wedding.photoidx
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.phototime ~= nil then
    msg.item_info.item_data.wedding.phototime = item_info.item_data.wedding.phototime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.myname ~= nil then
    msg.item_info.item_data.wedding.myname = item_info.item_data.wedding.myname
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.partnername ~= nil then
    msg.item_info.item_data.wedding.partnername = item_info.item_data.wedding.partnername
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.starttime ~= nil then
    msg.item_info.item_data.wedding.starttime = item_info.item_data.wedding.starttime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.endtime ~= nil then
    msg.item_info.item_data.wedding.endtime = item_info.item_data.wedding.endtime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.notified ~= nil then
    msg.item_info.item_data.wedding.notified = item_info.item_data.wedding.notified
  end
  if item_info.item_data.sender ~= nil and item_info.item_data.sender.charid ~= nil then
    msg.item_info.item_data.sender.charid = item_info.item_data.sender.charid
  end
  if item_info.item_data.sender ~= nil and item_info.item_data.sender.name ~= nil then
    msg.item_info.item_data.sender.name = item_info.item_data.sender.name
  end
  if item_info ~= nil and item_info.publicity_id ~= nil then
    msg.item_info.publicity_id = item_info.publicity_id
  end
  if item_info ~= nil and item_info.end_time ~= nil then
    msg.item_info.end_time = item_info.end_time
  end
  if item_info ~= nil and item_info.key ~= nil then
    msg.item_info.key = item_info.key
  end
  if item_info ~= nil and item_info.charid ~= nil then
    msg.item_info.charid = item_info.charid
  end
  if item_info ~= nil and item_info.name ~= nil then
    msg.item_info.name = item_info.name
  end
  if item_info ~= nil and item_info.type ~= nil then
    msg.item_info.type = item_info.type
  end
  if item_info ~= nil and item_info.up_rate ~= nil then
    msg.item_info.up_rate = item_info.up_rate
  end
  if item_info ~= nil and item_info.down_rate ~= nil then
    msg.item_info.down_rate = item_info.down_rate
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if addtype ~= nil then
    msg.addtype = addtype
  end
  if total_quota ~= nil then
    msg.total_quota = total_quota
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallAddMoneyRecordTradeCmd(money_type, total_money, charid, itemid, count, price, type, money2)
  local msg = SceneTrade_pb.AddMoneyRecordTradeCmd()
  if money_type ~= nil then
    msg.money_type = money_type
  end
  if total_money ~= nil then
    msg.total_money = total_money
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if count ~= nil then
    msg.count = count
  end
  if price ~= nil then
    msg.price = price
  end
  if type ~= nil then
    msg.type = type
  end
  if money2 ~= nil then
    msg.money2 = money2
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallReduceItemRecordTrade(item_info, charid, ret, boothfee, is_resell, orderid, type, quota_unlock, quota_lock, quota)
  local msg = SceneTrade_pb.ReduceItemRecordTrade()
  if item_info ~= nil and item_info.itemid ~= nil then
    msg.item_info.itemid = item_info.itemid
  end
  if item_info ~= nil and item_info.price ~= nil then
    msg.item_info.price = item_info.price
  end
  if item_info ~= nil and item_info.count ~= nil then
    msg.item_info.count = item_info.count
  end
  if item_info ~= nil and item_info.guid ~= nil then
    msg.item_info.guid = item_info.guid
  end
  if item_info ~= nil and item_info.order_id ~= nil then
    msg.item_info.order_id = item_info.order_id
  end
  if item_info ~= nil and item_info.refine_lv ~= nil then
    msg.item_info.refine_lv = item_info.refine_lv
  end
  if item_info ~= nil and item_info.overlap ~= nil then
    msg.item_info.overlap = item_info.overlap
  end
  if item_info ~= nil and item_info.is_expired ~= nil then
    msg.item_info.is_expired = item_info.is_expired
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.guid ~= nil then
    msg.item_info.item_data.base.guid = item_info.item_data.base.guid
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.id ~= nil then
    msg.item_info.item_data.base.id = item_info.item_data.base.id
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.count ~= nil then
    msg.item_info.item_data.base.count = item_info.item_data.base.count
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.index ~= nil then
    msg.item_info.item_data.base.index = item_info.item_data.base.index
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.createtime ~= nil then
    msg.item_info.item_data.base.createtime = item_info.item_data.base.createtime
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.cd ~= nil then
    msg.item_info.item_data.base.cd = item_info.item_data.base.cd
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.type ~= nil then
    msg.item_info.item_data.base.type = item_info.item_data.base.type
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.bind ~= nil then
    msg.item_info.item_data.base.bind = item_info.item_data.base.bind
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.expire ~= nil then
    msg.item_info.item_data.base.expire = item_info.item_data.base.expire
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.quality ~= nil then
    msg.item_info.item_data.base.quality = item_info.item_data.base.quality
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.equipType ~= nil then
    msg.item_info.item_data.base.equipType = item_info.item_data.base.equipType
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.source ~= nil then
    msg.item_info.item_data.base.source = item_info.item_data.base.source
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.isnew ~= nil then
    msg.item_info.item_data.base.isnew = item_info.item_data.base.isnew
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.maxcardslot ~= nil then
    msg.item_info.item_data.base.maxcardslot = item_info.item_data.base.maxcardslot
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.ishint ~= nil then
    msg.item_info.item_data.base.ishint = item_info.item_data.base.ishint
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.isactive ~= nil then
    msg.item_info.item_data.base.isactive = item_info.item_data.base.isactive
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.source_npc ~= nil then
    msg.item_info.item_data.base.source_npc = item_info.item_data.base.source_npc
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.refinelv ~= nil then
    msg.item_info.item_data.base.refinelv = item_info.item_data.base.refinelv
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.chargemoney ~= nil then
    msg.item_info.item_data.base.chargemoney = item_info.item_data.base.chargemoney
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.overtime ~= nil then
    msg.item_info.item_data.base.overtime = item_info.item_data.base.overtime
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.quota ~= nil then
    msg.item_info.item_data.base.quota = item_info.item_data.base.quota
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.usedtimes ~= nil then
    msg.item_info.item_data.base.usedtimes = item_info.item_data.base.usedtimes
  end
  if item_info.item_data.base ~= nil and item_info.item_data.base.usedtime ~= nil then
    msg.item_info.item_data.base.usedtime = item_info.item_data.base.usedtime
  end
  if item_info.item_data ~= nil and item_info.item_data.equiped ~= nil then
    msg.item_info.item_data.equiped = item_info.item_data.equiped
  end
  if item_info.item_data ~= nil and item_info.item_data.battlepoint ~= nil then
    msg.item_info.item_data.battlepoint = item_info.item_data.battlepoint
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.strengthlv ~= nil then
    msg.item_info.item_data.equip.strengthlv = item_info.item_data.equip.strengthlv
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.refinelv ~= nil then
    msg.item_info.item_data.equip.refinelv = item_info.item_data.equip.refinelv
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.strengthCost ~= nil then
    msg.item_info.item_data.equip.strengthCost = item_info.item_data.equip.strengthCost
  end
  if item_info ~= nil and item_info.item_data.equip.refineCompose ~= nil then
    for i = 1, #item_info.item_data.equip.refineCompose do
      table.insert(msg.item_info.item_data.equip.refineCompose, item_info.item_data.equip.refineCompose[i])
    end
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.cardslot ~= nil then
    msg.item_info.item_data.equip.cardslot = item_info.item_data.equip.cardslot
  end
  if item_info ~= nil and item_info.item_data.equip.buffid ~= nil then
    for i = 1, #item_info.item_data.equip.buffid do
      table.insert(msg.item_info.item_data.equip.buffid, item_info.item_data.equip.buffid[i])
    end
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.damage ~= nil then
    msg.item_info.item_data.equip.damage = item_info.item_data.equip.damage
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.lv ~= nil then
    msg.item_info.item_data.equip.lv = item_info.item_data.equip.lv
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.color ~= nil then
    msg.item_info.item_data.equip.color = item_info.item_data.equip.color
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.breakstarttime ~= nil then
    msg.item_info.item_data.equip.breakstarttime = item_info.item_data.equip.breakstarttime
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.breakendtime ~= nil then
    msg.item_info.item_data.equip.breakendtime = item_info.item_data.equip.breakendtime
  end
  if item_info.item_data.equip ~= nil and item_info.item_data.equip.strengthlv2 ~= nil then
    msg.item_info.item_data.equip.strengthlv2 = item_info.item_data.equip.strengthlv2
  end
  if item_info ~= nil and item_info.item_data.equip.strengthlv2cost ~= nil then
    for i = 1, #item_info.item_data.equip.strengthlv2cost do
      table.insert(msg.item_info.item_data.equip.strengthlv2cost, item_info.item_data.equip.strengthlv2cost[i])
    end
  end
  if item_info ~= nil and item_info.item_data.card ~= nil then
    for i = 1, #item_info.item_data.card do
      table.insert(msg.item_info.item_data.card, item_info.item_data.card[i])
    end
  end
  if item_info.item_data.enchant ~= nil and item_info.item_data.enchant.type ~= nil then
    msg.item_info.item_data.enchant.type = item_info.item_data.enchant.type
  end
  if item_info ~= nil and item_info.item_data.enchant.attrs ~= nil then
    for i = 1, #item_info.item_data.enchant.attrs do
      table.insert(msg.item_info.item_data.enchant.attrs, item_info.item_data.enchant.attrs[i])
    end
  end
  if item_info ~= nil and item_info.item_data.enchant.extras ~= nil then
    for i = 1, #item_info.item_data.enchant.extras do
      table.insert(msg.item_info.item_data.enchant.extras, item_info.item_data.enchant.extras[i])
    end
  end
  if item_info ~= nil and item_info.item_data.enchant.patch ~= nil then
    for i = 1, #item_info.item_data.enchant.patch do
      table.insert(msg.item_info.item_data.enchant.patch, item_info.item_data.enchant.patch[i])
    end
  end
  if item_info.item_data.previewenchant ~= nil and item_info.item_data.previewenchant.type ~= nil then
    msg.item_info.item_data.previewenchant.type = item_info.item_data.previewenchant.type
  end
  if item_info ~= nil and item_info.item_data.previewenchant.attrs ~= nil then
    for i = 1, #item_info.item_data.previewenchant.attrs do
      table.insert(msg.item_info.item_data.previewenchant.attrs, item_info.item_data.previewenchant.attrs[i])
    end
  end
  if item_info ~= nil and item_info.item_data.previewenchant.extras ~= nil then
    for i = 1, #item_info.item_data.previewenchant.extras do
      table.insert(msg.item_info.item_data.previewenchant.extras, item_info.item_data.previewenchant.extras[i])
    end
  end
  if item_info ~= nil and item_info.item_data.previewenchant.patch ~= nil then
    for i = 1, #item_info.item_data.previewenchant.patch do
      table.insert(msg.item_info.item_data.previewenchant.patch, item_info.item_data.previewenchant.patch[i])
    end
  end
  if item_info.item_data.refine ~= nil and item_info.item_data.refine.lastfail ~= nil then
    msg.item_info.item_data.refine.lastfail = item_info.item_data.refine.lastfail
  end
  if item_info.item_data.refine ~= nil and item_info.item_data.refine.repaircount ~= nil then
    msg.item_info.item_data.refine.repaircount = item_info.item_data.refine.repaircount
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.exp ~= nil then
    msg.item_info.item_data.egg.exp = item_info.item_data.egg.exp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.friendexp ~= nil then
    msg.item_info.item_data.egg.friendexp = item_info.item_data.egg.friendexp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.rewardexp ~= nil then
    msg.item_info.item_data.egg.rewardexp = item_info.item_data.egg.rewardexp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.id ~= nil then
    msg.item_info.item_data.egg.id = item_info.item_data.egg.id
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.lv ~= nil then
    msg.item_info.item_data.egg.lv = item_info.item_data.egg.lv
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.friendlv ~= nil then
    msg.item_info.item_data.egg.friendlv = item_info.item_data.egg.friendlv
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.body ~= nil then
    msg.item_info.item_data.egg.body = item_info.item_data.egg.body
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.relivetime ~= nil then
    msg.item_info.item_data.egg.relivetime = item_info.item_data.egg.relivetime
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.hp ~= nil then
    msg.item_info.item_data.egg.hp = item_info.item_data.egg.hp
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.restoretime ~= nil then
    msg.item_info.item_data.egg.restoretime = item_info.item_data.egg.restoretime
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happly ~= nil then
    msg.item_info.item_data.egg.time_happly = item_info.item_data.egg.time_happly
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_excite ~= nil then
    msg.item_info.item_data.egg.time_excite = item_info.item_data.egg.time_excite
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happiness ~= nil then
    msg.item_info.item_data.egg.time_happiness = item_info.item_data.egg.time_happiness
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happly_gift ~= nil then
    msg.item_info.item_data.egg.time_happly_gift = item_info.item_data.egg.time_happly_gift
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_excite_gift ~= nil then
    msg.item_info.item_data.egg.time_excite_gift = item_info.item_data.egg.time_excite_gift
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.time_happiness_gift ~= nil then
    msg.item_info.item_data.egg.time_happiness_gift = item_info.item_data.egg.time_happiness_gift
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.touch_tick ~= nil then
    msg.item_info.item_data.egg.touch_tick = item_info.item_data.egg.touch_tick
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.feed_tick ~= nil then
    msg.item_info.item_data.egg.feed_tick = item_info.item_data.egg.feed_tick
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.name ~= nil then
    msg.item_info.item_data.egg.name = item_info.item_data.egg.name
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.var ~= nil then
    msg.item_info.item_data.egg.var = item_info.item_data.egg.var
  end
  if item_info ~= nil and item_info.item_data.egg.skillids ~= nil then
    for i = 1, #item_info.item_data.egg.skillids do
      table.insert(msg.item_info.item_data.egg.skillids, item_info.item_data.egg.skillids[i])
    end
  end
  if item_info ~= nil and item_info.item_data.egg.equips ~= nil then
    for i = 1, #item_info.item_data.egg.equips do
      table.insert(msg.item_info.item_data.egg.equips, item_info.item_data.egg.equips[i])
    end
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.buff ~= nil then
    msg.item_info.item_data.egg.buff = item_info.item_data.egg.buff
  end
  if item_info ~= nil and item_info.item_data.egg.unlock_equip ~= nil then
    for i = 1, #item_info.item_data.egg.unlock_equip do
      table.insert(msg.item_info.item_data.egg.unlock_equip, item_info.item_data.egg.unlock_equip[i])
    end
  end
  if item_info ~= nil and item_info.item_data.egg.unlock_body ~= nil then
    for i = 1, #item_info.item_data.egg.unlock_body do
      table.insert(msg.item_info.item_data.egg.unlock_body, item_info.item_data.egg.unlock_body[i])
    end
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.version ~= nil then
    msg.item_info.item_data.egg.version = item_info.item_data.egg.version
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.skilloff ~= nil then
    msg.item_info.item_data.egg.skilloff = item_info.item_data.egg.skilloff
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.exchange_count ~= nil then
    msg.item_info.item_data.egg.exchange_count = item_info.item_data.egg.exchange_count
  end
  if item_info.item_data.egg ~= nil and item_info.item_data.egg.guid ~= nil then
    msg.item_info.item_data.egg.guid = item_info.item_data.egg.guid
  end
  if item_info ~= nil and item_info.item_data.egg.defaultwears ~= nil then
    for i = 1, #item_info.item_data.egg.defaultwears do
      table.insert(msg.item_info.item_data.egg.defaultwears, item_info.item_data.egg.defaultwears[i])
    end
  end
  if item_info ~= nil and item_info.item_data.egg.wears ~= nil then
    for i = 1, #item_info.item_data.egg.wears do
      table.insert(msg.item_info.item_data.egg.wears, item_info.item_data.egg.wears[i])
    end
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.sendUserName ~= nil then
    msg.item_info.item_data.letter.sendUserName = item_info.item_data.letter.sendUserName
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.bg ~= nil then
    msg.item_info.item_data.letter.bg = item_info.item_data.letter.bg
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.configID ~= nil then
    msg.item_info.item_data.letter.configID = item_info.item_data.letter.configID
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.content ~= nil then
    msg.item_info.item_data.letter.content = item_info.item_data.letter.content
  end
  if item_info.item_data.letter ~= nil and item_info.item_data.letter.content2 ~= nil then
    msg.item_info.item_data.letter.content2 = item_info.item_data.letter.content2
  end
  if item_info.item_data.code ~= nil and item_info.item_data.code.code ~= nil then
    msg.item_info.item_data.code.code = item_info.item_data.code.code
  end
  if item_info.item_data.code ~= nil and item_info.item_data.code.used ~= nil then
    msg.item_info.item_data.code.used = item_info.item_data.code.used
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.id ~= nil then
    msg.item_info.item_data.wedding.id = item_info.item_data.wedding.id
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.zoneid ~= nil then
    msg.item_info.item_data.wedding.zoneid = item_info.item_data.wedding.zoneid
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.charid1 ~= nil then
    msg.item_info.item_data.wedding.charid1 = item_info.item_data.wedding.charid1
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.charid2 ~= nil then
    msg.item_info.item_data.wedding.charid2 = item_info.item_data.wedding.charid2
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.weddingtime ~= nil then
    msg.item_info.item_data.wedding.weddingtime = item_info.item_data.wedding.weddingtime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.photoidx ~= nil then
    msg.item_info.item_data.wedding.photoidx = item_info.item_data.wedding.photoidx
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.phototime ~= nil then
    msg.item_info.item_data.wedding.phototime = item_info.item_data.wedding.phototime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.myname ~= nil then
    msg.item_info.item_data.wedding.myname = item_info.item_data.wedding.myname
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.partnername ~= nil then
    msg.item_info.item_data.wedding.partnername = item_info.item_data.wedding.partnername
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.starttime ~= nil then
    msg.item_info.item_data.wedding.starttime = item_info.item_data.wedding.starttime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.endtime ~= nil then
    msg.item_info.item_data.wedding.endtime = item_info.item_data.wedding.endtime
  end
  if item_info.item_data.wedding ~= nil and item_info.item_data.wedding.notified ~= nil then
    msg.item_info.item_data.wedding.notified = item_info.item_data.wedding.notified
  end
  if item_info.item_data.sender ~= nil and item_info.item_data.sender.charid ~= nil then
    msg.item_info.item_data.sender.charid = item_info.item_data.sender.charid
  end
  if item_info.item_data.sender ~= nil and item_info.item_data.sender.name ~= nil then
    msg.item_info.item_data.sender.name = item_info.item_data.sender.name
  end
  if item_info ~= nil and item_info.publicity_id ~= nil then
    msg.item_info.publicity_id = item_info.publicity_id
  end
  if item_info ~= nil and item_info.end_time ~= nil then
    msg.item_info.end_time = item_info.end_time
  end
  if item_info ~= nil and item_info.key ~= nil then
    msg.item_info.key = item_info.key
  end
  if item_info ~= nil and item_info.charid ~= nil then
    msg.item_info.charid = item_info.charid
  end
  if item_info ~= nil and item_info.name ~= nil then
    msg.item_info.name = item_info.name
  end
  if item_info ~= nil and item_info.type ~= nil then
    msg.item_info.type = item_info.type
  end
  if item_info ~= nil and item_info.up_rate ~= nil then
    msg.item_info.up_rate = item_info.up_rate
  end
  if item_info ~= nil and item_info.down_rate ~= nil then
    msg.item_info.down_rate = item_info.down_rate
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if ret ~= nil then
    msg.ret = ret
  end
  if boothfee ~= nil then
    msg.boothfee = boothfee
  end
  if is_resell ~= nil then
    msg.is_resell = is_resell
  end
  if orderid ~= nil then
    msg.orderid = orderid
  end
  if type ~= nil then
    msg.type = type
  end
  if quota_unlock ~= nil then
    msg.quota_unlock = quota_unlock
  end
  if quota_lock ~= nil then
    msg.quota_lock = quota_lock
  end
  if quota ~= nil then
    msg.quota = quota
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallSessionToMeRecordTrade(charid, data, len)
  local msg = SceneTrade_pb.SessionToMeRecordTrade()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallSessionForwardUsercmdTrade(charid, zoneid, data, len)
  local msg = SceneTrade_pb.SessionForwardUsercmdTrade()
  if charid ~= nil then
    msg.charid = charid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallSessionForwardScenecmdTrade(charid, zoneid, name, data, len)
  local msg = SceneTrade_pb.SessionForwardScenecmdTrade()
  if charid ~= nil then
    msg.charid = charid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if name ~= nil then
    msg.name = name
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallForwardUserCmdToRecordCmd(charid, data, len)
  local msg = SceneTrade_pb.ForwardUserCmdToRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallWorldMsgCmd(data, len)
  local msg = SceneTrade_pb.WorldMsgCmd()
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallUpdateTradeLogCmd(charid, type, id, trade_type)
  local msg = SceneTrade_pb.UpdateTradeLogCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if type ~= nil then
    msg.type = type
  end
  if id ~= nil then
    msg.id = id
  end
  if trade_type ~= nil then
    msg.trade_type = trade_type
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallGiveCheckMoneySceneTradeCmd(charid, type, id, friendid, content, anonymous, quota, fee, background, ret, itemdata, fromtrade)
  local msg = SceneTrade_pb.GiveCheckMoneySceneTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if type ~= nil then
    msg.type = type
  end
  if id ~= nil then
    msg.id = id
  end
  if friendid ~= nil then
    msg.friendid = friendid
  end
  if content ~= nil then
    msg.content = content
  end
  if anonymous ~= nil then
    msg.anonymous = anonymous
  end
  if quota ~= nil then
    msg.quota = quota
  end
  if fee ~= nil then
    msg.fee = fee
  end
  if background ~= nil then
    msg.background = background
  end
  if ret ~= nil then
    msg.ret = ret
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
  if fromtrade ~= nil then
    msg.fromtrade = fromtrade
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallSyncGiveItemSceneTradeCmd(charid, iteminfo, type)
  local msg = SceneTrade_pb.SyncGiveItemSceneTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if iteminfo ~= nil then
    for i = 1, #iteminfo do
      table.insert(msg.iteminfo, iteminfo[i])
    end
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallAddGiveSceneTradeCmd(charid, iteminfo)
  local msg = SceneTrade_pb.AddGiveSceneTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if iteminfo ~= nil and iteminfo.id ~= nil then
    msg.iteminfo.id = iteminfo.id
  end
  if iteminfo ~= nil and iteminfo.status ~= nil then
    msg.iteminfo.status = iteminfo.status
  end
  if iteminfo ~= nil and iteminfo.itemid ~= nil then
    msg.iteminfo.itemid = iteminfo.itemid
  end
  if iteminfo ~= nil and iteminfo.count ~= nil then
    msg.iteminfo.count = iteminfo.count
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.guid ~= nil then
    msg.iteminfo.itemdata.base.guid = iteminfo.itemdata.base.guid
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.id ~= nil then
    msg.iteminfo.itemdata.base.id = iteminfo.itemdata.base.id
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.count ~= nil then
    msg.iteminfo.itemdata.base.count = iteminfo.itemdata.base.count
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.index ~= nil then
    msg.iteminfo.itemdata.base.index = iteminfo.itemdata.base.index
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.createtime ~= nil then
    msg.iteminfo.itemdata.base.createtime = iteminfo.itemdata.base.createtime
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.cd ~= nil then
    msg.iteminfo.itemdata.base.cd = iteminfo.itemdata.base.cd
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.type ~= nil then
    msg.iteminfo.itemdata.base.type = iteminfo.itemdata.base.type
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.bind ~= nil then
    msg.iteminfo.itemdata.base.bind = iteminfo.itemdata.base.bind
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.expire ~= nil then
    msg.iteminfo.itemdata.base.expire = iteminfo.itemdata.base.expire
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.quality ~= nil then
    msg.iteminfo.itemdata.base.quality = iteminfo.itemdata.base.quality
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.equipType ~= nil then
    msg.iteminfo.itemdata.base.equipType = iteminfo.itemdata.base.equipType
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.source ~= nil then
    msg.iteminfo.itemdata.base.source = iteminfo.itemdata.base.source
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.isnew ~= nil then
    msg.iteminfo.itemdata.base.isnew = iteminfo.itemdata.base.isnew
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.maxcardslot ~= nil then
    msg.iteminfo.itemdata.base.maxcardslot = iteminfo.itemdata.base.maxcardslot
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.ishint ~= nil then
    msg.iteminfo.itemdata.base.ishint = iteminfo.itemdata.base.ishint
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.isactive ~= nil then
    msg.iteminfo.itemdata.base.isactive = iteminfo.itemdata.base.isactive
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.source_npc ~= nil then
    msg.iteminfo.itemdata.base.source_npc = iteminfo.itemdata.base.source_npc
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.refinelv ~= nil then
    msg.iteminfo.itemdata.base.refinelv = iteminfo.itemdata.base.refinelv
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.chargemoney ~= nil then
    msg.iteminfo.itemdata.base.chargemoney = iteminfo.itemdata.base.chargemoney
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.overtime ~= nil then
    msg.iteminfo.itemdata.base.overtime = iteminfo.itemdata.base.overtime
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.quota ~= nil then
    msg.iteminfo.itemdata.base.quota = iteminfo.itemdata.base.quota
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.usedtimes ~= nil then
    msg.iteminfo.itemdata.base.usedtimes = iteminfo.itemdata.base.usedtimes
  end
  if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.usedtime ~= nil then
    msg.iteminfo.itemdata.base.usedtime = iteminfo.itemdata.base.usedtime
  end
  if iteminfo.itemdata ~= nil and iteminfo.itemdata.equiped ~= nil then
    msg.iteminfo.itemdata.equiped = iteminfo.itemdata.equiped
  end
  if iteminfo.itemdata ~= nil and iteminfo.itemdata.battlepoint ~= nil then
    msg.iteminfo.itemdata.battlepoint = iteminfo.itemdata.battlepoint
  end
  if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.strengthlv ~= nil then
    msg.iteminfo.itemdata.equip.strengthlv = iteminfo.itemdata.equip.strengthlv
  end
  if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.refinelv ~= nil then
    msg.iteminfo.itemdata.equip.refinelv = iteminfo.itemdata.equip.refinelv
  end
  if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.strengthCost ~= nil then
    msg.iteminfo.itemdata.equip.strengthCost = iteminfo.itemdata.equip.strengthCost
  end
  if iteminfo ~= nil and iteminfo.itemdata.equip.refineCompose ~= nil then
    for i = 1, #iteminfo.itemdata.equip.refineCompose do
      table.insert(msg.iteminfo.itemdata.equip.refineCompose, iteminfo.itemdata.equip.refineCompose[i])
    end
  end
  if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.cardslot ~= nil then
    msg.iteminfo.itemdata.equip.cardslot = iteminfo.itemdata.equip.cardslot
  end
  if iteminfo ~= nil and iteminfo.itemdata.equip.buffid ~= nil then
    for i = 1, #iteminfo.itemdata.equip.buffid do
      table.insert(msg.iteminfo.itemdata.equip.buffid, iteminfo.itemdata.equip.buffid[i])
    end
  end
  if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.damage ~= nil then
    msg.iteminfo.itemdata.equip.damage = iteminfo.itemdata.equip.damage
  end
  if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.lv ~= nil then
    msg.iteminfo.itemdata.equip.lv = iteminfo.itemdata.equip.lv
  end
  if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.color ~= nil then
    msg.iteminfo.itemdata.equip.color = iteminfo.itemdata.equip.color
  end
  if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.breakstarttime ~= nil then
    msg.iteminfo.itemdata.equip.breakstarttime = iteminfo.itemdata.equip.breakstarttime
  end
  if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.breakendtime ~= nil then
    msg.iteminfo.itemdata.equip.breakendtime = iteminfo.itemdata.equip.breakendtime
  end
  if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.strengthlv2 ~= nil then
    msg.iteminfo.itemdata.equip.strengthlv2 = iteminfo.itemdata.equip.strengthlv2
  end
  if iteminfo ~= nil and iteminfo.itemdata.equip.strengthlv2cost ~= nil then
    for i = 1, #iteminfo.itemdata.equip.strengthlv2cost do
      table.insert(msg.iteminfo.itemdata.equip.strengthlv2cost, iteminfo.itemdata.equip.strengthlv2cost[i])
    end
  end
  if iteminfo ~= nil and iteminfo.itemdata.card ~= nil then
    for i = 1, #iteminfo.itemdata.card do
      table.insert(msg.iteminfo.itemdata.card, iteminfo.itemdata.card[i])
    end
  end
  if iteminfo.itemdata.enchant ~= nil and iteminfo.itemdata.enchant.type ~= nil then
    msg.iteminfo.itemdata.enchant.type = iteminfo.itemdata.enchant.type
  end
  if iteminfo ~= nil and iteminfo.itemdata.enchant.attrs ~= nil then
    for i = 1, #iteminfo.itemdata.enchant.attrs do
      table.insert(msg.iteminfo.itemdata.enchant.attrs, iteminfo.itemdata.enchant.attrs[i])
    end
  end
  if iteminfo ~= nil and iteminfo.itemdata.enchant.extras ~= nil then
    for i = 1, #iteminfo.itemdata.enchant.extras do
      table.insert(msg.iteminfo.itemdata.enchant.extras, iteminfo.itemdata.enchant.extras[i])
    end
  end
  if iteminfo ~= nil and iteminfo.itemdata.enchant.patch ~= nil then
    for i = 1, #iteminfo.itemdata.enchant.patch do
      table.insert(msg.iteminfo.itemdata.enchant.patch, iteminfo.itemdata.enchant.patch[i])
    end
  end
  if iteminfo.itemdata.previewenchant ~= nil and iteminfo.itemdata.previewenchant.type ~= nil then
    msg.iteminfo.itemdata.previewenchant.type = iteminfo.itemdata.previewenchant.type
  end
  if iteminfo ~= nil and iteminfo.itemdata.previewenchant.attrs ~= nil then
    for i = 1, #iteminfo.itemdata.previewenchant.attrs do
      table.insert(msg.iteminfo.itemdata.previewenchant.attrs, iteminfo.itemdata.previewenchant.attrs[i])
    end
  end
  if iteminfo ~= nil and iteminfo.itemdata.previewenchant.extras ~= nil then
    for i = 1, #iteminfo.itemdata.previewenchant.extras do
      table.insert(msg.iteminfo.itemdata.previewenchant.extras, iteminfo.itemdata.previewenchant.extras[i])
    end
  end
  if iteminfo ~= nil and iteminfo.itemdata.previewenchant.patch ~= nil then
    for i = 1, #iteminfo.itemdata.previewenchant.patch do
      table.insert(msg.iteminfo.itemdata.previewenchant.patch, iteminfo.itemdata.previewenchant.patch[i])
    end
  end
  if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.lastfail ~= nil then
    msg.iteminfo.itemdata.refine.lastfail = iteminfo.itemdata.refine.lastfail
  end
  if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.repaircount ~= nil then
    msg.iteminfo.itemdata.refine.repaircount = iteminfo.itemdata.refine.repaircount
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.exp ~= nil then
    msg.iteminfo.itemdata.egg.exp = iteminfo.itemdata.egg.exp
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.friendexp ~= nil then
    msg.iteminfo.itemdata.egg.friendexp = iteminfo.itemdata.egg.friendexp
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.rewardexp ~= nil then
    msg.iteminfo.itemdata.egg.rewardexp = iteminfo.itemdata.egg.rewardexp
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.id ~= nil then
    msg.iteminfo.itemdata.egg.id = iteminfo.itemdata.egg.id
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.lv ~= nil then
    msg.iteminfo.itemdata.egg.lv = iteminfo.itemdata.egg.lv
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.friendlv ~= nil then
    msg.iteminfo.itemdata.egg.friendlv = iteminfo.itemdata.egg.friendlv
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.body ~= nil then
    msg.iteminfo.itemdata.egg.body = iteminfo.itemdata.egg.body
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.relivetime ~= nil then
    msg.iteminfo.itemdata.egg.relivetime = iteminfo.itemdata.egg.relivetime
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.hp ~= nil then
    msg.iteminfo.itemdata.egg.hp = iteminfo.itemdata.egg.hp
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.restoretime ~= nil then
    msg.iteminfo.itemdata.egg.restoretime = iteminfo.itemdata.egg.restoretime
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happly ~= nil then
    msg.iteminfo.itemdata.egg.time_happly = iteminfo.itemdata.egg.time_happly
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_excite ~= nil then
    msg.iteminfo.itemdata.egg.time_excite = iteminfo.itemdata.egg.time_excite
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happiness ~= nil then
    msg.iteminfo.itemdata.egg.time_happiness = iteminfo.itemdata.egg.time_happiness
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happly_gift ~= nil then
    msg.iteminfo.itemdata.egg.time_happly_gift = iteminfo.itemdata.egg.time_happly_gift
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_excite_gift ~= nil then
    msg.iteminfo.itemdata.egg.time_excite_gift = iteminfo.itemdata.egg.time_excite_gift
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happiness_gift ~= nil then
    msg.iteminfo.itemdata.egg.time_happiness_gift = iteminfo.itemdata.egg.time_happiness_gift
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.touch_tick ~= nil then
    msg.iteminfo.itemdata.egg.touch_tick = iteminfo.itemdata.egg.touch_tick
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.feed_tick ~= nil then
    msg.iteminfo.itemdata.egg.feed_tick = iteminfo.itemdata.egg.feed_tick
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.name ~= nil then
    msg.iteminfo.itemdata.egg.name = iteminfo.itemdata.egg.name
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.var ~= nil then
    msg.iteminfo.itemdata.egg.var = iteminfo.itemdata.egg.var
  end
  if iteminfo ~= nil and iteminfo.itemdata.egg.skillids ~= nil then
    for i = 1, #iteminfo.itemdata.egg.skillids do
      table.insert(msg.iteminfo.itemdata.egg.skillids, iteminfo.itemdata.egg.skillids[i])
    end
  end
  if iteminfo ~= nil and iteminfo.itemdata.egg.equips ~= nil then
    for i = 1, #iteminfo.itemdata.egg.equips do
      table.insert(msg.iteminfo.itemdata.egg.equips, iteminfo.itemdata.egg.equips[i])
    end
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.buff ~= nil then
    msg.iteminfo.itemdata.egg.buff = iteminfo.itemdata.egg.buff
  end
  if iteminfo ~= nil and iteminfo.itemdata.egg.unlock_equip ~= nil then
    for i = 1, #iteminfo.itemdata.egg.unlock_equip do
      table.insert(msg.iteminfo.itemdata.egg.unlock_equip, iteminfo.itemdata.egg.unlock_equip[i])
    end
  end
  if iteminfo ~= nil and iteminfo.itemdata.egg.unlock_body ~= nil then
    for i = 1, #iteminfo.itemdata.egg.unlock_body do
      table.insert(msg.iteminfo.itemdata.egg.unlock_body, iteminfo.itemdata.egg.unlock_body[i])
    end
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.version ~= nil then
    msg.iteminfo.itemdata.egg.version = iteminfo.itemdata.egg.version
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.skilloff ~= nil then
    msg.iteminfo.itemdata.egg.skilloff = iteminfo.itemdata.egg.skilloff
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.exchange_count ~= nil then
    msg.iteminfo.itemdata.egg.exchange_count = iteminfo.itemdata.egg.exchange_count
  end
  if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.guid ~= nil then
    msg.iteminfo.itemdata.egg.guid = iteminfo.itemdata.egg.guid
  end
  if iteminfo ~= nil and iteminfo.itemdata.egg.defaultwears ~= nil then
    for i = 1, #iteminfo.itemdata.egg.defaultwears do
      table.insert(msg.iteminfo.itemdata.egg.defaultwears, iteminfo.itemdata.egg.defaultwears[i])
    end
  end
  if iteminfo ~= nil and iteminfo.itemdata.egg.wears ~= nil then
    for i = 1, #iteminfo.itemdata.egg.wears do
      table.insert(msg.iteminfo.itemdata.egg.wears, iteminfo.itemdata.egg.wears[i])
    end
  end
  if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.sendUserName ~= nil then
    msg.iteminfo.itemdata.letter.sendUserName = iteminfo.itemdata.letter.sendUserName
  end
  if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.bg ~= nil then
    msg.iteminfo.itemdata.letter.bg = iteminfo.itemdata.letter.bg
  end
  if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.configID ~= nil then
    msg.iteminfo.itemdata.letter.configID = iteminfo.itemdata.letter.configID
  end
  if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.content ~= nil then
    msg.iteminfo.itemdata.letter.content = iteminfo.itemdata.letter.content
  end
  if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.content2 ~= nil then
    msg.iteminfo.itemdata.letter.content2 = iteminfo.itemdata.letter.content2
  end
  if iteminfo.itemdata.code ~= nil and iteminfo.itemdata.code.code ~= nil then
    msg.iteminfo.itemdata.code.code = iteminfo.itemdata.code.code
  end
  if iteminfo.itemdata.code ~= nil and iteminfo.itemdata.code.used ~= nil then
    msg.iteminfo.itemdata.code.used = iteminfo.itemdata.code.used
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.id ~= nil then
    msg.iteminfo.itemdata.wedding.id = iteminfo.itemdata.wedding.id
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.zoneid ~= nil then
    msg.iteminfo.itemdata.wedding.zoneid = iteminfo.itemdata.wedding.zoneid
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.charid1 ~= nil then
    msg.iteminfo.itemdata.wedding.charid1 = iteminfo.itemdata.wedding.charid1
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.charid2 ~= nil then
    msg.iteminfo.itemdata.wedding.charid2 = iteminfo.itemdata.wedding.charid2
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.weddingtime ~= nil then
    msg.iteminfo.itemdata.wedding.weddingtime = iteminfo.itemdata.wedding.weddingtime
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.photoidx ~= nil then
    msg.iteminfo.itemdata.wedding.photoidx = iteminfo.itemdata.wedding.photoidx
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.phototime ~= nil then
    msg.iteminfo.itemdata.wedding.phototime = iteminfo.itemdata.wedding.phototime
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.myname ~= nil then
    msg.iteminfo.itemdata.wedding.myname = iteminfo.itemdata.wedding.myname
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.partnername ~= nil then
    msg.iteminfo.itemdata.wedding.partnername = iteminfo.itemdata.wedding.partnername
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.starttime ~= nil then
    msg.iteminfo.itemdata.wedding.starttime = iteminfo.itemdata.wedding.starttime
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.endtime ~= nil then
    msg.iteminfo.itemdata.wedding.endtime = iteminfo.itemdata.wedding.endtime
  end
  if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.notified ~= nil then
    msg.iteminfo.itemdata.wedding.notified = iteminfo.itemdata.wedding.notified
  end
  if iteminfo.itemdata.sender ~= nil and iteminfo.itemdata.sender.charid ~= nil then
    msg.iteminfo.itemdata.sender.charid = iteminfo.itemdata.sender.charid
  end
  if iteminfo.itemdata.sender ~= nil and iteminfo.itemdata.sender.name ~= nil then
    msg.iteminfo.itemdata.sender.name = iteminfo.itemdata.sender.name
  end
  if iteminfo ~= nil and iteminfo.senderid ~= nil then
    msg.iteminfo.senderid = iteminfo.senderid
  end
  if iteminfo ~= nil and iteminfo.sendername ~= nil then
    msg.iteminfo.sendername = iteminfo.sendername
  end
  if iteminfo ~= nil and iteminfo.anonymous ~= nil then
    msg.iteminfo.anonymous = iteminfo.anonymous
  end
  if iteminfo ~= nil and iteminfo.expiretime ~= nil then
    msg.iteminfo.expiretime = iteminfo.expiretime
  end
  if iteminfo ~= nil and iteminfo.content ~= nil then
    msg.iteminfo.content = iteminfo.content
  end
  if iteminfo ~= nil and iteminfo.quota ~= nil then
    msg.iteminfo.quota = iteminfo.quota
  end
  if iteminfo ~= nil and iteminfo.receivername ~= nil then
    msg.iteminfo.receivername = iteminfo.receivername
  end
  if iteminfo ~= nil and iteminfo.background ~= nil then
    msg.iteminfo.background = iteminfo.background
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallDelGiveSceneTradeCmd(charid, id)
  local msg = SceneTrade_pb.DelGiveSceneTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallAddGiveItemSceneTradeCmd(charid, id, itemid, count, itemData, background, ret)
  local msg = SceneTrade_pb.AddGiveItemSceneTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if id ~= nil then
    msg.id = id
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if count ~= nil then
    msg.count = count
  end
  if itemData.base ~= nil and itemData.base.guid ~= nil then
    msg.itemData.base.guid = itemData.base.guid
  end
  if itemData.base ~= nil and itemData.base.id ~= nil then
    msg.itemData.base.id = itemData.base.id
  end
  if itemData.base ~= nil and itemData.base.count ~= nil then
    msg.itemData.base.count = itemData.base.count
  end
  if itemData.base ~= nil and itemData.base.index ~= nil then
    msg.itemData.base.index = itemData.base.index
  end
  if itemData.base ~= nil and itemData.base.createtime ~= nil then
    msg.itemData.base.createtime = itemData.base.createtime
  end
  if itemData.base ~= nil and itemData.base.cd ~= nil then
    msg.itemData.base.cd = itemData.base.cd
  end
  if itemData.base ~= nil and itemData.base.type ~= nil then
    msg.itemData.base.type = itemData.base.type
  end
  if itemData.base ~= nil and itemData.base.bind ~= nil then
    msg.itemData.base.bind = itemData.base.bind
  end
  if itemData.base ~= nil and itemData.base.expire ~= nil then
    msg.itemData.base.expire = itemData.base.expire
  end
  if itemData.base ~= nil and itemData.base.quality ~= nil then
    msg.itemData.base.quality = itemData.base.quality
  end
  if itemData.base ~= nil and itemData.base.equipType ~= nil then
    msg.itemData.base.equipType = itemData.base.equipType
  end
  if itemData.base ~= nil and itemData.base.source ~= nil then
    msg.itemData.base.source = itemData.base.source
  end
  if itemData.base ~= nil and itemData.base.isnew ~= nil then
    msg.itemData.base.isnew = itemData.base.isnew
  end
  if itemData.base ~= nil and itemData.base.maxcardslot ~= nil then
    msg.itemData.base.maxcardslot = itemData.base.maxcardslot
  end
  if itemData.base ~= nil and itemData.base.ishint ~= nil then
    msg.itemData.base.ishint = itemData.base.ishint
  end
  if itemData.base ~= nil and itemData.base.isactive ~= nil then
    msg.itemData.base.isactive = itemData.base.isactive
  end
  if itemData.base ~= nil and itemData.base.source_npc ~= nil then
    msg.itemData.base.source_npc = itemData.base.source_npc
  end
  if itemData.base ~= nil and itemData.base.refinelv ~= nil then
    msg.itemData.base.refinelv = itemData.base.refinelv
  end
  if itemData.base ~= nil and itemData.base.chargemoney ~= nil then
    msg.itemData.base.chargemoney = itemData.base.chargemoney
  end
  if itemData.base ~= nil and itemData.base.overtime ~= nil then
    msg.itemData.base.overtime = itemData.base.overtime
  end
  if itemData.base ~= nil and itemData.base.quota ~= nil then
    msg.itemData.base.quota = itemData.base.quota
  end
  if itemData.base ~= nil and itemData.base.usedtimes ~= nil then
    msg.itemData.base.usedtimes = itemData.base.usedtimes
  end
  if itemData.base ~= nil and itemData.base.usedtime ~= nil then
    msg.itemData.base.usedtime = itemData.base.usedtime
  end
  if itemData ~= nil and itemData.equiped ~= nil then
    msg.itemData.equiped = itemData.equiped
  end
  if itemData ~= nil and itemData.battlepoint ~= nil then
    msg.itemData.battlepoint = itemData.battlepoint
  end
  if itemData.equip ~= nil and itemData.equip.strengthlv ~= nil then
    msg.itemData.equip.strengthlv = itemData.equip.strengthlv
  end
  if itemData.equip ~= nil and itemData.equip.refinelv ~= nil then
    msg.itemData.equip.refinelv = itemData.equip.refinelv
  end
  if itemData.equip ~= nil and itemData.equip.strengthCost ~= nil then
    msg.itemData.equip.strengthCost = itemData.equip.strengthCost
  end
  if itemData ~= nil and itemData.equip.refineCompose ~= nil then
    for i = 1, #itemData.equip.refineCompose do
      table.insert(msg.itemData.equip.refineCompose, itemData.equip.refineCompose[i])
    end
  end
  if itemData.equip ~= nil and itemData.equip.cardslot ~= nil then
    msg.itemData.equip.cardslot = itemData.equip.cardslot
  end
  if itemData ~= nil and itemData.equip.buffid ~= nil then
    for i = 1, #itemData.equip.buffid do
      table.insert(msg.itemData.equip.buffid, itemData.equip.buffid[i])
    end
  end
  if itemData.equip ~= nil and itemData.equip.damage ~= nil then
    msg.itemData.equip.damage = itemData.equip.damage
  end
  if itemData.equip ~= nil and itemData.equip.lv ~= nil then
    msg.itemData.equip.lv = itemData.equip.lv
  end
  if itemData.equip ~= nil and itemData.equip.color ~= nil then
    msg.itemData.equip.color = itemData.equip.color
  end
  if itemData.equip ~= nil and itemData.equip.breakstarttime ~= nil then
    msg.itemData.equip.breakstarttime = itemData.equip.breakstarttime
  end
  if itemData.equip ~= nil and itemData.equip.breakendtime ~= nil then
    msg.itemData.equip.breakendtime = itemData.equip.breakendtime
  end
  if itemData.equip ~= nil and itemData.equip.strengthlv2 ~= nil then
    msg.itemData.equip.strengthlv2 = itemData.equip.strengthlv2
  end
  if itemData ~= nil and itemData.equip.strengthlv2cost ~= nil then
    for i = 1, #itemData.equip.strengthlv2cost do
      table.insert(msg.itemData.equip.strengthlv2cost, itemData.equip.strengthlv2cost[i])
    end
  end
  if itemData ~= nil and itemData.card ~= nil then
    for i = 1, #itemData.card do
      table.insert(msg.itemData.card, itemData.card[i])
    end
  end
  if itemData.enchant ~= nil and itemData.enchant.type ~= nil then
    msg.itemData.enchant.type = itemData.enchant.type
  end
  if itemData ~= nil and itemData.enchant.attrs ~= nil then
    for i = 1, #itemData.enchant.attrs do
      table.insert(msg.itemData.enchant.attrs, itemData.enchant.attrs[i])
    end
  end
  if itemData ~= nil and itemData.enchant.extras ~= nil then
    for i = 1, #itemData.enchant.extras do
      table.insert(msg.itemData.enchant.extras, itemData.enchant.extras[i])
    end
  end
  if itemData ~= nil and itemData.enchant.patch ~= nil then
    for i = 1, #itemData.enchant.patch do
      table.insert(msg.itemData.enchant.patch, itemData.enchant.patch[i])
    end
  end
  if itemData.previewenchant ~= nil and itemData.previewenchant.type ~= nil then
    msg.itemData.previewenchant.type = itemData.previewenchant.type
  end
  if itemData ~= nil and itemData.previewenchant.attrs ~= nil then
    for i = 1, #itemData.previewenchant.attrs do
      table.insert(msg.itemData.previewenchant.attrs, itemData.previewenchant.attrs[i])
    end
  end
  if itemData ~= nil and itemData.previewenchant.extras ~= nil then
    for i = 1, #itemData.previewenchant.extras do
      table.insert(msg.itemData.previewenchant.extras, itemData.previewenchant.extras[i])
    end
  end
  if itemData ~= nil and itemData.previewenchant.patch ~= nil then
    for i = 1, #itemData.previewenchant.patch do
      table.insert(msg.itemData.previewenchant.patch, itemData.previewenchant.patch[i])
    end
  end
  if itemData.refine ~= nil and itemData.refine.lastfail ~= nil then
    msg.itemData.refine.lastfail = itemData.refine.lastfail
  end
  if itemData.refine ~= nil and itemData.refine.repaircount ~= nil then
    msg.itemData.refine.repaircount = itemData.refine.repaircount
  end
  if itemData.egg ~= nil and itemData.egg.exp ~= nil then
    msg.itemData.egg.exp = itemData.egg.exp
  end
  if itemData.egg ~= nil and itemData.egg.friendexp ~= nil then
    msg.itemData.egg.friendexp = itemData.egg.friendexp
  end
  if itemData.egg ~= nil and itemData.egg.rewardexp ~= nil then
    msg.itemData.egg.rewardexp = itemData.egg.rewardexp
  end
  if itemData.egg ~= nil and itemData.egg.id ~= nil then
    msg.itemData.egg.id = itemData.egg.id
  end
  if itemData.egg ~= nil and itemData.egg.lv ~= nil then
    msg.itemData.egg.lv = itemData.egg.lv
  end
  if itemData.egg ~= nil and itemData.egg.friendlv ~= nil then
    msg.itemData.egg.friendlv = itemData.egg.friendlv
  end
  if itemData.egg ~= nil and itemData.egg.body ~= nil then
    msg.itemData.egg.body = itemData.egg.body
  end
  if itemData.egg ~= nil and itemData.egg.relivetime ~= nil then
    msg.itemData.egg.relivetime = itemData.egg.relivetime
  end
  if itemData.egg ~= nil and itemData.egg.hp ~= nil then
    msg.itemData.egg.hp = itemData.egg.hp
  end
  if itemData.egg ~= nil and itemData.egg.restoretime ~= nil then
    msg.itemData.egg.restoretime = itemData.egg.restoretime
  end
  if itemData.egg ~= nil and itemData.egg.time_happly ~= nil then
    msg.itemData.egg.time_happly = itemData.egg.time_happly
  end
  if itemData.egg ~= nil and itemData.egg.time_excite ~= nil then
    msg.itemData.egg.time_excite = itemData.egg.time_excite
  end
  if itemData.egg ~= nil and itemData.egg.time_happiness ~= nil then
    msg.itemData.egg.time_happiness = itemData.egg.time_happiness
  end
  if itemData.egg ~= nil and itemData.egg.time_happly_gift ~= nil then
    msg.itemData.egg.time_happly_gift = itemData.egg.time_happly_gift
  end
  if itemData.egg ~= nil and itemData.egg.time_excite_gift ~= nil then
    msg.itemData.egg.time_excite_gift = itemData.egg.time_excite_gift
  end
  if itemData.egg ~= nil and itemData.egg.time_happiness_gift ~= nil then
    msg.itemData.egg.time_happiness_gift = itemData.egg.time_happiness_gift
  end
  if itemData.egg ~= nil and itemData.egg.touch_tick ~= nil then
    msg.itemData.egg.touch_tick = itemData.egg.touch_tick
  end
  if itemData.egg ~= nil and itemData.egg.feed_tick ~= nil then
    msg.itemData.egg.feed_tick = itemData.egg.feed_tick
  end
  if itemData.egg ~= nil and itemData.egg.name ~= nil then
    msg.itemData.egg.name = itemData.egg.name
  end
  if itemData.egg ~= nil and itemData.egg.var ~= nil then
    msg.itemData.egg.var = itemData.egg.var
  end
  if itemData ~= nil and itemData.egg.skillids ~= nil then
    for i = 1, #itemData.egg.skillids do
      table.insert(msg.itemData.egg.skillids, itemData.egg.skillids[i])
    end
  end
  if itemData ~= nil and itemData.egg.equips ~= nil then
    for i = 1, #itemData.egg.equips do
      table.insert(msg.itemData.egg.equips, itemData.egg.equips[i])
    end
  end
  if itemData.egg ~= nil and itemData.egg.buff ~= nil then
    msg.itemData.egg.buff = itemData.egg.buff
  end
  if itemData ~= nil and itemData.egg.unlock_equip ~= nil then
    for i = 1, #itemData.egg.unlock_equip do
      table.insert(msg.itemData.egg.unlock_equip, itemData.egg.unlock_equip[i])
    end
  end
  if itemData ~= nil and itemData.egg.unlock_body ~= nil then
    for i = 1, #itemData.egg.unlock_body do
      table.insert(msg.itemData.egg.unlock_body, itemData.egg.unlock_body[i])
    end
  end
  if itemData.egg ~= nil and itemData.egg.version ~= nil then
    msg.itemData.egg.version = itemData.egg.version
  end
  if itemData.egg ~= nil and itemData.egg.skilloff ~= nil then
    msg.itemData.egg.skilloff = itemData.egg.skilloff
  end
  if itemData.egg ~= nil and itemData.egg.exchange_count ~= nil then
    msg.itemData.egg.exchange_count = itemData.egg.exchange_count
  end
  if itemData.egg ~= nil and itemData.egg.guid ~= nil then
    msg.itemData.egg.guid = itemData.egg.guid
  end
  if itemData ~= nil and itemData.egg.defaultwears ~= nil then
    for i = 1, #itemData.egg.defaultwears do
      table.insert(msg.itemData.egg.defaultwears, itemData.egg.defaultwears[i])
    end
  end
  if itemData ~= nil and itemData.egg.wears ~= nil then
    for i = 1, #itemData.egg.wears do
      table.insert(msg.itemData.egg.wears, itemData.egg.wears[i])
    end
  end
  if itemData.letter ~= nil and itemData.letter.sendUserName ~= nil then
    msg.itemData.letter.sendUserName = itemData.letter.sendUserName
  end
  if itemData.letter ~= nil and itemData.letter.bg ~= nil then
    msg.itemData.letter.bg = itemData.letter.bg
  end
  if itemData.letter ~= nil and itemData.letter.configID ~= nil then
    msg.itemData.letter.configID = itemData.letter.configID
  end
  if itemData.letter ~= nil and itemData.letter.content ~= nil then
    msg.itemData.letter.content = itemData.letter.content
  end
  if itemData.letter ~= nil and itemData.letter.content2 ~= nil then
    msg.itemData.letter.content2 = itemData.letter.content2
  end
  if itemData.code ~= nil and itemData.code.code ~= nil then
    msg.itemData.code.code = itemData.code.code
  end
  if itemData.code ~= nil and itemData.code.used ~= nil then
    msg.itemData.code.used = itemData.code.used
  end
  if itemData.wedding ~= nil and itemData.wedding.id ~= nil then
    msg.itemData.wedding.id = itemData.wedding.id
  end
  if itemData.wedding ~= nil and itemData.wedding.zoneid ~= nil then
    msg.itemData.wedding.zoneid = itemData.wedding.zoneid
  end
  if itemData.wedding ~= nil and itemData.wedding.charid1 ~= nil then
    msg.itemData.wedding.charid1 = itemData.wedding.charid1
  end
  if itemData.wedding ~= nil and itemData.wedding.charid2 ~= nil then
    msg.itemData.wedding.charid2 = itemData.wedding.charid2
  end
  if itemData.wedding ~= nil and itemData.wedding.weddingtime ~= nil then
    msg.itemData.wedding.weddingtime = itemData.wedding.weddingtime
  end
  if itemData.wedding ~= nil and itemData.wedding.photoidx ~= nil then
    msg.itemData.wedding.photoidx = itemData.wedding.photoidx
  end
  if itemData.wedding ~= nil and itemData.wedding.phototime ~= nil then
    msg.itemData.wedding.phototime = itemData.wedding.phototime
  end
  if itemData.wedding ~= nil and itemData.wedding.myname ~= nil then
    msg.itemData.wedding.myname = itemData.wedding.myname
  end
  if itemData.wedding ~= nil and itemData.wedding.partnername ~= nil then
    msg.itemData.wedding.partnername = itemData.wedding.partnername
  end
  if itemData.wedding ~= nil and itemData.wedding.starttime ~= nil then
    msg.itemData.wedding.starttime = itemData.wedding.starttime
  end
  if itemData.wedding ~= nil and itemData.wedding.endtime ~= nil then
    msg.itemData.wedding.endtime = itemData.wedding.endtime
  end
  if itemData.wedding ~= nil and itemData.wedding.notified ~= nil then
    msg.itemData.wedding.notified = itemData.wedding.notified
  end
  if itemData.sender ~= nil and itemData.sender.charid ~= nil then
    msg.itemData.sender.charid = itemData.sender.charid
  end
  if itemData.sender ~= nil and itemData.sender.name ~= nil then
    msg.itemData.sender.name = itemData.sender.name
  end
  if background ~= nil then
    msg.background = background
  end
  if ret ~= nil then
    msg.ret = ret
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallReceiveGiveSceneTradeCmd(charid, id)
  local msg = SceneTrade_pb.ReceiveGiveSceneTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallNtfGiveStatusSceneTradeCmd(charid, id, status, name)
  local msg = SceneTrade_pb.NtfGiveStatusSceneTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if id ~= nil then
    msg.id = id
  end
  if status ~= nil then
    msg.status = status
  end
  if name ~= nil then
    msg.name = name
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallReduceQuotaSceneTradeCmd(charid, id, quota, receivername)
  local msg = SceneTrade_pb.ReduceQuotaSceneTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if id ~= nil then
    msg.id = id
  end
  if quota ~= nil then
    msg.quota = quota
  end
  if receivername ~= nil then
    msg.receivername = receivername
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallUnlockQuotaSceneTradeCmd(charid, id, quota, receivername)
  local msg = SceneTrade_pb.UnlockQuotaSceneTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if id ~= nil then
    msg.id = id
  end
  if quota ~= nil then
    msg.quota = quota
  end
  if receivername ~= nil then
    msg.receivername = receivername
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallExtraPermissionSceneTradeCmd(charid, permission, value)
  local msg = SceneTrade_pb.ExtraPermissionSceneTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if permission ~= nil then
    msg.permission = permission
  end
  if value ~= nil then
    msg.value = value
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallSecurityCmdSceneTradeCmd(valid, type, charid, itemid, refinelv, key)
  local msg = SceneTrade_pb.SecurityCmdSceneTradeCmd()
  if valid ~= nil then
    msg.valid = valid
  end
  if type ~= nil then
    msg.type = type
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if refinelv ~= nil then
    msg.refinelv = refinelv
  end
  if key ~= nil then
    msg.key = key
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallTradePriceQueryTradeCmd(batchid, signup_id, price, itemdata)
  local msg = SceneTrade_pb.TradePriceQueryTradeCmd()
  if batchid ~= nil then
    msg.batchid = batchid
  end
  if signup_id ~= nil then
    msg.signup_id = signup_id
  end
  if price ~= nil then
    msg.price = price
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
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:CallBoothOpenTradeCmd(charid, open)
  local msg = SceneTrade_pb.BoothOpenTradeCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if open ~= nil then
    msg.open = open
  end
  self:SendProto(msg)
end
function ServiceSceneTradeAutoProxy:RecvFrostItemListSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeFrostItemListSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvReduceMoneyRecordTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeReduceMoneyRecordTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvAddItemRecordTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeAddItemRecordTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvAddMoneyRecordTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeAddMoneyRecordTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvReduceItemRecordTrade(data)
  self:Notify(ServiceEvent.SceneTradeReduceItemRecordTrade, data)
end
function ServiceSceneTradeAutoProxy:RecvSessionToMeRecordTrade(data)
  self:Notify(ServiceEvent.SceneTradeSessionToMeRecordTrade, data)
end
function ServiceSceneTradeAutoProxy:RecvSessionForwardUsercmdTrade(data)
  self:Notify(ServiceEvent.SceneTradeSessionForwardUsercmdTrade, data)
end
function ServiceSceneTradeAutoProxy:RecvSessionForwardScenecmdTrade(data)
  self:Notify(ServiceEvent.SceneTradeSessionForwardScenecmdTrade, data)
end
function ServiceSceneTradeAutoProxy:RecvForwardUserCmdToRecordCmd(data)
  self:Notify(ServiceEvent.SceneTradeForwardUserCmdToRecordCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvWorldMsgCmd(data)
  self:Notify(ServiceEvent.SceneTradeWorldMsgCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvUpdateTradeLogCmd(data)
  self:Notify(ServiceEvent.SceneTradeUpdateTradeLogCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvGiveCheckMoneySceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeGiveCheckMoneySceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvSyncGiveItemSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeSyncGiveItemSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvAddGiveSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeAddGiveSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvDelGiveSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeDelGiveSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvAddGiveItemSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeAddGiveItemSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvReceiveGiveSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeReceiveGiveSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvNtfGiveStatusSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeNtfGiveStatusSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvReduceQuotaSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeReduceQuotaSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvUnlockQuotaSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeUnlockQuotaSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvExtraPermissionSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeExtraPermissionSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvSecurityCmdSceneTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeSecurityCmdSceneTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvTradePriceQueryTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeTradePriceQueryTradeCmd, data)
end
function ServiceSceneTradeAutoProxy:RecvBoothOpenTradeCmd(data)
  self:Notify(ServiceEvent.SceneTradeBoothOpenTradeCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneTradeFrostItemListSceneTradeCmd = "ServiceEvent_SceneTradeFrostItemListSceneTradeCmd"
ServiceEvent.SceneTradeReduceMoneyRecordTradeCmd = "ServiceEvent_SceneTradeReduceMoneyRecordTradeCmd"
ServiceEvent.SceneTradeAddItemRecordTradeCmd = "ServiceEvent_SceneTradeAddItemRecordTradeCmd"
ServiceEvent.SceneTradeAddMoneyRecordTradeCmd = "ServiceEvent_SceneTradeAddMoneyRecordTradeCmd"
ServiceEvent.SceneTradeReduceItemRecordTrade = "ServiceEvent_SceneTradeReduceItemRecordTrade"
ServiceEvent.SceneTradeSessionToMeRecordTrade = "ServiceEvent_SceneTradeSessionToMeRecordTrade"
ServiceEvent.SceneTradeSessionForwardUsercmdTrade = "ServiceEvent_SceneTradeSessionForwardUsercmdTrade"
ServiceEvent.SceneTradeSessionForwardScenecmdTrade = "ServiceEvent_SceneTradeSessionForwardScenecmdTrade"
ServiceEvent.SceneTradeForwardUserCmdToRecordCmd = "ServiceEvent_SceneTradeForwardUserCmdToRecordCmd"
ServiceEvent.SceneTradeWorldMsgCmd = "ServiceEvent_SceneTradeWorldMsgCmd"
ServiceEvent.SceneTradeUpdateTradeLogCmd = "ServiceEvent_SceneTradeUpdateTradeLogCmd"
ServiceEvent.SceneTradeGiveCheckMoneySceneTradeCmd = "ServiceEvent_SceneTradeGiveCheckMoneySceneTradeCmd"
ServiceEvent.SceneTradeSyncGiveItemSceneTradeCmd = "ServiceEvent_SceneTradeSyncGiveItemSceneTradeCmd"
ServiceEvent.SceneTradeAddGiveSceneTradeCmd = "ServiceEvent_SceneTradeAddGiveSceneTradeCmd"
ServiceEvent.SceneTradeDelGiveSceneTradeCmd = "ServiceEvent_SceneTradeDelGiveSceneTradeCmd"
ServiceEvent.SceneTradeAddGiveItemSceneTradeCmd = "ServiceEvent_SceneTradeAddGiveItemSceneTradeCmd"
ServiceEvent.SceneTradeReceiveGiveSceneTradeCmd = "ServiceEvent_SceneTradeReceiveGiveSceneTradeCmd"
ServiceEvent.SceneTradeNtfGiveStatusSceneTradeCmd = "ServiceEvent_SceneTradeNtfGiveStatusSceneTradeCmd"
ServiceEvent.SceneTradeReduceQuotaSceneTradeCmd = "ServiceEvent_SceneTradeReduceQuotaSceneTradeCmd"
ServiceEvent.SceneTradeUnlockQuotaSceneTradeCmd = "ServiceEvent_SceneTradeUnlockQuotaSceneTradeCmd"
ServiceEvent.SceneTradeExtraPermissionSceneTradeCmd = "ServiceEvent_SceneTradeExtraPermissionSceneTradeCmd"
ServiceEvent.SceneTradeSecurityCmdSceneTradeCmd = "ServiceEvent_SceneTradeSecurityCmdSceneTradeCmd"
ServiceEvent.SceneTradeTradePriceQueryTradeCmd = "ServiceEvent_SceneTradeTradePriceQueryTradeCmd"
ServiceEvent.SceneTradeBoothOpenTradeCmd = "ServiceEvent_SceneTradeBoothOpenTradeCmd"
