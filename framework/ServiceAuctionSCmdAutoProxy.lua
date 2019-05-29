ServiceAuctionSCmdAutoProxy = class("ServiceAuctionSCmdAutoProxy", ServiceProxy)
ServiceAuctionSCmdAutoProxy.Instance = nil
ServiceAuctionSCmdAutoProxy.NAME = "ServiceAuctionSCmdAutoProxy"
function ServiceAuctionSCmdAutoProxy:ctor(proxyName)
  if ServiceAuctionSCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceAuctionSCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceAuctionSCmdAutoProxy.Instance = self
  end
end
function ServiceAuctionSCmdAutoProxy:Init()
end
function ServiceAuctionSCmdAutoProxy:onRegister()
  self:Listen(213, 1, function(data)
    self:RecvForwardCCmd2Auction(data)
  end)
  self:Listen(213, 2, function(data)
    self:RecvForwardSCmd2Auction(data)
  end)
  self:Listen(213, 3, function(data)
    self:RecvForwardAuction2SCmd(data)
  end)
  self:Listen(213, 4, function(data)
    self:RecvSignUpItemSCmd(data)
  end)
  self:Listen(213, 5, function(data)
    self:RecvOfferPriceSCmd(data)
  end)
  self:Listen(213, 6, function(data)
    self:RecvOfferPriceDelOrderSCmd(data)
  end)
  self:Listen(213, 7, function(data)
    self:RecvTakeRecordSCmd(data)
  end)
  self:Listen(213, 8, function(data)
    self:RecvWorldCmdSCmd(data)
  end)
  self:Listen(213, 9, function(data)
    self:RecvGmModifyAuctionTimeSCmd(data)
  end)
  self:Listen(213, 10, function(data)
    self:RecvGmStopAuctionSCmd(data)
  end)
  self:Listen(213, 11, function(data)
    self:RecvBroadcastMsgBySessionAuctionSCmd(data)
  end)
end
function ServiceAuctionSCmdAutoProxy:CallForwardCCmd2Auction(charid, zoneid, name, data, len)
  local msg = AuctionSCmd_pb.ForwardCCmd2Auction()
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
function ServiceAuctionSCmdAutoProxy:CallForwardSCmd2Auction(charid, zoneid, name, data, len)
  local msg = AuctionSCmd_pb.ForwardSCmd2Auction()
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
function ServiceAuctionSCmdAutoProxy:CallForwardAuction2SCmd(charid, data, len)
  local msg = AuctionSCmd_pb.ForwardAuction2SCmd()
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
function ServiceAuctionSCmdAutoProxy:CallSignUpItemSCmd(iteminfo, ret, charid, batchid, orderid, guid, fm_point, fm_buff, itemdata)
  local msg = AuctionSCmd_pb.SignUpItemSCmd()
  if iteminfo ~= nil and iteminfo.itemid ~= nil then
    msg.iteminfo.itemid = iteminfo.itemid
  end
  if iteminfo ~= nil and iteminfo.price ~= nil then
    msg.iteminfo.price = iteminfo.price
  end
  if iteminfo ~= nil and iteminfo.auction ~= nil then
    msg.iteminfo.auction = iteminfo.auction
  end
  if ret ~= nil then
    msg.ret = ret
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if batchid ~= nil then
    msg.batchid = batchid
  end
  if orderid ~= nil then
    msg.orderid = orderid
  end
  if guid ~= nil then
    msg.guid = guid
  end
  if fm_point ~= nil then
    msg.fm_point = fm_point
  end
  if fm_buff ~= nil then
    msg.fm_buff = fm_buff
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
function ServiceAuctionSCmdAutoProxy:CallOfferPriceSCmd(orderid, batchid, itemid, reduce_money, total_price, ret, charid, signupid)
  local msg = AuctionSCmd_pb.OfferPriceSCmd()
  if orderid ~= nil then
    msg.orderid = orderid
  end
  if batchid ~= nil then
    msg.batchid = batchid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if reduce_money ~= nil then
    msg.reduce_money = reduce_money
  end
  if total_price ~= nil then
    msg.total_price = total_price
  end
  if ret ~= nil then
    msg.ret = ret
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if signupid ~= nil then
    msg.signupid = signupid
  end
  self:SendProto(msg)
end
function ServiceAuctionSCmdAutoProxy:CallOfferPriceDelOrderSCmd(orderid, charid)
  local msg = AuctionSCmd_pb.OfferPriceDelOrderSCmd()
  if orderid ~= nil then
    msg.orderid = orderid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceAuctionSCmdAutoProxy:CallTakeRecordSCmd(id, type, charid, batchid, itemid, item, zeny, ret, bcat, signup_id, itemdata)
  local msg = AuctionSCmd_pb.TakeRecordSCmd()
  if id ~= nil then
    msg.id = id
  end
  if type ~= nil then
    msg.type = type
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if batchid ~= nil then
    msg.batchid = batchid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if item ~= nil and item.guid ~= nil then
    msg.item.guid = item.guid
  end
  if item ~= nil and item.id ~= nil then
    msg.item.id = item.id
  end
  if item ~= nil and item.count ~= nil then
    msg.item.count = item.count
  end
  if item ~= nil and item.index ~= nil then
    msg.item.index = item.index
  end
  if item ~= nil and item.createtime ~= nil then
    msg.item.createtime = item.createtime
  end
  if item ~= nil and item.cd ~= nil then
    msg.item.cd = item.cd
  end
  if item ~= nil and item.type ~= nil then
    msg.item.type = item.type
  end
  if item ~= nil and item.bind ~= nil then
    msg.item.bind = item.bind
  end
  if item ~= nil and item.expire ~= nil then
    msg.item.expire = item.expire
  end
  if item ~= nil and item.quality ~= nil then
    msg.item.quality = item.quality
  end
  if item ~= nil and item.equipType ~= nil then
    msg.item.equipType = item.equipType
  end
  if item ~= nil and item.source ~= nil then
    msg.item.source = item.source
  end
  if item ~= nil and item.isnew ~= nil then
    msg.item.isnew = item.isnew
  end
  if item ~= nil and item.maxcardslot ~= nil then
    msg.item.maxcardslot = item.maxcardslot
  end
  if item ~= nil and item.ishint ~= nil then
    msg.item.ishint = item.ishint
  end
  if item ~= nil and item.isactive ~= nil then
    msg.item.isactive = item.isactive
  end
  if item ~= nil and item.source_npc ~= nil then
    msg.item.source_npc = item.source_npc
  end
  if item ~= nil and item.refinelv ~= nil then
    msg.item.refinelv = item.refinelv
  end
  if item ~= nil and item.chargemoney ~= nil then
    msg.item.chargemoney = item.chargemoney
  end
  if item ~= nil and item.overtime ~= nil then
    msg.item.overtime = item.overtime
  end
  if item ~= nil and item.quota ~= nil then
    msg.item.quota = item.quota
  end
  if item ~= nil and item.usedtimes ~= nil then
    msg.item.usedtimes = item.usedtimes
  end
  if item ~= nil and item.usedtime ~= nil then
    msg.item.usedtime = item.usedtime
  end
  if zeny ~= nil then
    msg.zeny = zeny
  end
  if ret ~= nil then
    msg.ret = ret
  end
  if bcat ~= nil then
    msg.bcat = bcat
  end
  if signup_id ~= nil then
    msg.signup_id = signup_id
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
function ServiceAuctionSCmdAutoProxy:CallWorldCmdSCmd(data, len)
  local msg = AuctionSCmd_pb.WorldCmdSCmd()
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceAuctionSCmdAutoProxy:CallGmModifyAuctionTimeSCmd(auction_time)
  local msg = AuctionSCmd_pb.GmModifyAuctionTimeSCmd()
  if auction_time ~= nil then
    msg.auction_time = auction_time
  end
  self:SendProto(msg)
end
function ServiceAuctionSCmdAutoProxy:CallGmStopAuctionSCmd()
  local msg = AuctionSCmd_pb.GmStopAuctionSCmd()
  self:SendProto(msg)
end
function ServiceAuctionSCmdAutoProxy:CallBroadcastMsgBySessionAuctionSCmd(data, len)
  local msg = AuctionSCmd_pb.BroadcastMsgBySessionAuctionSCmd()
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceAuctionSCmdAutoProxy:RecvForwardCCmd2Auction(data)
  self:Notify(ServiceEvent.AuctionSCmdForwardCCmd2Auction, data)
end
function ServiceAuctionSCmdAutoProxy:RecvForwardSCmd2Auction(data)
  self:Notify(ServiceEvent.AuctionSCmdForwardSCmd2Auction, data)
end
function ServiceAuctionSCmdAutoProxy:RecvForwardAuction2SCmd(data)
  self:Notify(ServiceEvent.AuctionSCmdForwardAuction2SCmd, data)
end
function ServiceAuctionSCmdAutoProxy:RecvSignUpItemSCmd(data)
  self:Notify(ServiceEvent.AuctionSCmdSignUpItemSCmd, data)
end
function ServiceAuctionSCmdAutoProxy:RecvOfferPriceSCmd(data)
  self:Notify(ServiceEvent.AuctionSCmdOfferPriceSCmd, data)
end
function ServiceAuctionSCmdAutoProxy:RecvOfferPriceDelOrderSCmd(data)
  self:Notify(ServiceEvent.AuctionSCmdOfferPriceDelOrderSCmd, data)
end
function ServiceAuctionSCmdAutoProxy:RecvTakeRecordSCmd(data)
  self:Notify(ServiceEvent.AuctionSCmdTakeRecordSCmd, data)
end
function ServiceAuctionSCmdAutoProxy:RecvWorldCmdSCmd(data)
  self:Notify(ServiceEvent.AuctionSCmdWorldCmdSCmd, data)
end
function ServiceAuctionSCmdAutoProxy:RecvGmModifyAuctionTimeSCmd(data)
  self:Notify(ServiceEvent.AuctionSCmdGmModifyAuctionTimeSCmd, data)
end
function ServiceAuctionSCmdAutoProxy:RecvGmStopAuctionSCmd(data)
  self:Notify(ServiceEvent.AuctionSCmdGmStopAuctionSCmd, data)
end
function ServiceAuctionSCmdAutoProxy:RecvBroadcastMsgBySessionAuctionSCmd(data)
  self:Notify(ServiceEvent.AuctionSCmdBroadcastMsgBySessionAuctionSCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.AuctionSCmdForwardCCmd2Auction = "ServiceEvent_AuctionSCmdForwardCCmd2Auction"
ServiceEvent.AuctionSCmdForwardSCmd2Auction = "ServiceEvent_AuctionSCmdForwardSCmd2Auction"
ServiceEvent.AuctionSCmdForwardAuction2SCmd = "ServiceEvent_AuctionSCmdForwardAuction2SCmd"
ServiceEvent.AuctionSCmdSignUpItemSCmd = "ServiceEvent_AuctionSCmdSignUpItemSCmd"
ServiceEvent.AuctionSCmdOfferPriceSCmd = "ServiceEvent_AuctionSCmdOfferPriceSCmd"
ServiceEvent.AuctionSCmdOfferPriceDelOrderSCmd = "ServiceEvent_AuctionSCmdOfferPriceDelOrderSCmd"
ServiceEvent.AuctionSCmdTakeRecordSCmd = "ServiceEvent_AuctionSCmdTakeRecordSCmd"
ServiceEvent.AuctionSCmdWorldCmdSCmd = "ServiceEvent_AuctionSCmdWorldCmdSCmd"
ServiceEvent.AuctionSCmdGmModifyAuctionTimeSCmd = "ServiceEvent_AuctionSCmdGmModifyAuctionTimeSCmd"
ServiceEvent.AuctionSCmdGmStopAuctionSCmd = "ServiceEvent_AuctionSCmdGmStopAuctionSCmd"
ServiceEvent.AuctionSCmdBroadcastMsgBySessionAuctionSCmd = "ServiceEvent_AuctionSCmdBroadcastMsgBySessionAuctionSCmd"
