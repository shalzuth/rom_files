ServiceRecordTradeAutoProxy = class('ServiceRecordTradeAutoProxy', ServiceProxy)

ServiceRecordTradeAutoProxy.Instance = nil

ServiceRecordTradeAutoProxy.NAME = 'ServiceRecordTradeAutoProxy'

function ServiceRecordTradeAutoProxy:ctor(proxyName)
	if ServiceRecordTradeAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceRecordTradeAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceRecordTradeAutoProxy.Instance = self
	end
end

function ServiceRecordTradeAutoProxy:Init()
end

function ServiceRecordTradeAutoProxy:onRegister()
	self:Listen(57, 1, function (data)
		self:RecvBriefPendingListRecordTradeCmd(data) 
	end)
	self:Listen(57, 3, function (data)
		self:RecvDetailPendingListRecordTradeCmd(data) 
	end)
	self:Listen(57, 4, function (data)
		self:RecvItemSellInfoRecordTradeCmd(data) 
	end)
	self:Listen(57, 7, function (data)
		self:RecvMyPendingListRecordTradeCmd(data) 
	end)
	self:Listen(57, 9, function (data)
		self:RecvMyTradeLogRecordTradeCmd(data) 
	end)
	self:Listen(57, 27, function (data)
		self:RecvTakeLogCmd(data) 
	end)
	self:Listen(57, 28, function (data)
		self:RecvAddNewLog(data) 
	end)
	self:Listen(57, 29, function (data)
		self:RecvFetchNameInfoCmd(data) 
	end)
	self:Listen(57, 14, function (data)
		self:RecvReqServerPriceRecordTradeCmd(data) 
	end)
	self:Listen(57, 15, function (data)
		self:RecvBuyItemRecordTradeCmd(data) 
	end)
	self:Listen(57, 20, function (data)
		self:RecvSellItemRecordTradeCmd(data) 
	end)
	self:Listen(57, 22, function (data)
		self:RecvCancelItemRecordTrade(data) 
	end)
	self:Listen(57, 23, function (data)
		self:RecvResellPendingRecordTrade(data) 
	end)
	self:Listen(57, 24, function (data)
		self:RecvPanelRecordTrade(data) 
	end)
	self:Listen(57, 25, function (data)
		self:RecvListNtfRecordTrade(data) 
	end)
	self:Listen(57, 26, function (data)
		self:RecvHotItemidRecordTrade(data) 
	end)
	self:Listen(57, 30, function (data)
		self:RecvNtfCanTakeCountTradeCmd(data) 
	end)
	self:Listen(57, 31, function (data)
		self:RecvGiveTradeCmd(data) 
	end)
	self:Listen(57, 33, function (data)
		self:RecvAcceptTradeCmd(data) 
	end)
	self:Listen(57, 34, function (data)
		self:RecvRefuseTradeCmd(data) 
	end)
	self:Listen(57, 32, function (data)
		self:RecvReqGiveItemInfoCmd(data) 
	end)
	self:Listen(57, 35, function (data)
		self:RecvCheckPackageSizeTradeCmd(data) 
	end)
	self:Listen(57, 36, function (data)
		self:RecvQucikTakeLogTradeCmd(data) 
	end)
	self:Listen(57, 37, function (data)
		self:RecvQueryItemCountTradeCmd(data) 
	end)
	self:Listen(57, 38, function (data)
		self:RecvLotteryGiveCmd(data) 
	end)
	self:Listen(57, 39, function (data)
		self:RecvTodayFinanceRank(data) 
	end)
	self:Listen(57, 40, function (data)
		self:RecvTodayFinanceDetail(data) 
	end)
	self:Listen(57, 41, function (data)
		self:RecvBoothPlayerPendingListCmd(data) 
	end)
	self:Listen(57, 42, function (data)
		self:RecvUpdateOrderTradeCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceRecordTradeAutoProxy:CallBriefPendingListRecordTradeCmd(charid, category, job, fashion, pub_lists, lists) 
	local msg = RecordTrade_pb.BriefPendingListRecordTradeCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(category ~= nil )then
		msg.category = category
	end
	if(job ~= nil )then
		msg.job = job
	end
	if(fashion ~= nil )then
		msg.fashion = fashion
	end
	if( pub_lists ~= nil )then
		for i=1,#pub_lists do 
			table.insert(msg.pub_lists, pub_lists[i])
		end
	end
	if( lists ~= nil )then
		for i=1,#lists do 
			table.insert(msg.lists, lists[i])
		end
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallDetailPendingListRecordTradeCmd(search_cond, charid, lists, total_page_count) 
	local msg = RecordTrade_pb.DetailPendingListRecordTradeCmd()
	if(search_cond ~= nil )then
		if(search_cond.item_id ~= nil )then
			msg.search_cond.item_id = search_cond.item_id
		end
	end
	if(search_cond ~= nil )then
		if(search_cond.page_index ~= nil )then
			msg.search_cond.page_index = search_cond.page_index
		end
	end
	if(search_cond ~= nil )then
		if(search_cond.page_count ~= nil )then
			msg.search_cond.page_count = search_cond.page_count
		end
	end
	if(search_cond ~= nil )then
		if(search_cond.rank_type ~= nil )then
			msg.search_cond.rank_type = search_cond.rank_type
		end
	end
	if(search_cond ~= nil )then
		if(search_cond.trade_type ~= nil )then
			msg.search_cond.trade_type = search_cond.trade_type
		end
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	if( lists ~= nil )then
		for i=1,#lists do 
			table.insert(msg.lists, lists[i])
		end
	end
	if(total_page_count ~= nil )then
		msg.total_page_count = total_page_count
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallItemSellInfoRecordTradeCmd(charid, itemid, refine_lv, publicity_id, statetype, count, buyer_count, buy_info, order_id, type, quota) 
	local msg = RecordTrade_pb.ItemSellInfoRecordTradeCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	if(refine_lv ~= nil )then
		msg.refine_lv = refine_lv
	end
	if(publicity_id ~= nil )then
		msg.publicity_id = publicity_id
	end
	if(statetype ~= nil )then
		msg.statetype = statetype
	end
	if(count ~= nil )then
		msg.count = count
	end
	if(buyer_count ~= nil )then
		msg.buyer_count = buyer_count
	end
	if( buy_info ~= nil )then
		for i=1,#buy_info do 
			table.insert(msg.buy_info, buy_info[i])
		end
	end
	if(order_id ~= nil )then
		msg.order_id = order_id
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(quota ~= nil )then
		msg.quota = quota
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallMyPendingListRecordTradeCmd(search_cond, charid, lists) 
	local msg = RecordTrade_pb.MyPendingListRecordTradeCmd()
	if(search_cond ~= nil )then
		if(search_cond.item_id ~= nil )then
			msg.search_cond.item_id = search_cond.item_id
		end
	end
	if(search_cond ~= nil )then
		if(search_cond.page_index ~= nil )then
			msg.search_cond.page_index = search_cond.page_index
		end
	end
	if(search_cond ~= nil )then
		if(search_cond.page_count ~= nil )then
			msg.search_cond.page_count = search_cond.page_count
		end
	end
	if(search_cond ~= nil )then
		if(search_cond.rank_type ~= nil )then
			msg.search_cond.rank_type = search_cond.rank_type
		end
	end
	if(search_cond ~= nil )then
		if(search_cond.trade_type ~= nil )then
			msg.search_cond.trade_type = search_cond.trade_type
		end
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	if( lists ~= nil )then
		for i=1,#lists do 
			table.insert(msg.lists, lists[i])
		end
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallMyTradeLogRecordTradeCmd(charid, index, total_page_count, log_list, trade_type) 
	local msg = RecordTrade_pb.MyTradeLogRecordTradeCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(index ~= nil )then
		msg.index = index
	end
	if(total_page_count ~= nil )then
		msg.total_page_count = total_page_count
	end
	if( log_list ~= nil )then
		for i=1,#log_list do 
			table.insert(msg.log_list, log_list[i])
		end
	end
	if(trade_type ~= nil )then
		msg.trade_type = trade_type
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallTakeLogCmd(log, success) 
	local msg = RecordTrade_pb.TakeLogCmd()
	if(log ~= nil )then
		if(log.id ~= nil )then
			msg.log.id = log.id
		end
	end
	if(log ~= nil )then
		if(log.status ~= nil )then
			msg.log.status = log.status
		end
	end
	if(log ~= nil )then
		if(log.logtype ~= nil )then
			msg.log.logtype = log.logtype
		end
	end
	if(log ~= nil )then
		if(log.itemid ~= nil )then
			msg.log.itemid = log.itemid
		end
	end
	if(log ~= nil )then
		if(log.refine_lv ~= nil )then
			msg.log.refine_lv = log.refine_lv
		end
	end
	if(log ~= nil )then
		if(log.damage ~= nil )then
			msg.log.damage = log.damage
		end
	end
	if(log ~= nil )then
		if(log.tradetime ~= nil )then
			msg.log.tradetime = log.tradetime
		end
	end
	if(log ~= nil )then
		if(log.count ~= nil )then
			msg.log.count = log.count
		end
	end
	if(log ~= nil )then
		if(log.price ~= nil )then
			msg.log.price = log.price
		end
	end
	if(log ~= nil )then
		if(log.tax ~= nil )then
			msg.log.tax = log.tax
		end
	end
	if(log ~= nil )then
		if(log.getmoney ~= nil )then
			msg.log.getmoney = log.getmoney
		end
	end
	if(log ~= nil )then
		if(log.costmoney ~= nil )then
			msg.log.costmoney = log.costmoney
		end
	end
	if(log ~= nil )then
		if(log.failcount ~= nil )then
			msg.log.failcount = log.failcount
		end
	end
	if(log ~= nil )then
		if(log.retmoney ~= nil )then
			msg.log.retmoney = log.retmoney
		end
	end
	if(log ~= nil )then
		if(log.totalcount ~= nil )then
			msg.log.totalcount = log.totalcount
		end
	end
	if(log ~= nil )then
		if(log.endtime ~= nil )then
			msg.log.endtime = log.endtime
		end
	end
	if(log.name_info ~= nil )then
		if(log.name_info.name ~= nil )then
			msg.log.name_info.name = log.name_info.name
		end
	end
	if(log.name_info ~= nil )then
		if(log.name_info.zoneid ~= nil )then
			msg.log.name_info.zoneid = log.name_info.zoneid
		end
	end
	if(log.name_info ~= nil )then
		if(log.name_info.count ~= nil )then
			msg.log.name_info.count = log.name_info.count
		end
	end
	if(log ~= nil )then
		if(log.is_many_people ~= nil )then
			msg.log.is_many_people = log.is_many_people
		end
	end
	if(log ~= nil )then
		if(log.name_list.name_infos ~= nil )then
			for i=1,#log.name_list.name_infos do 
				table.insert(msg.log.name_list.name_infos, log.name_list.name_infos[i])
			end
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.guid ~= nil )then
			msg.log.itemdata.base.guid = log.itemdata.base.guid
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.id ~= nil )then
			msg.log.itemdata.base.id = log.itemdata.base.id
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.count ~= nil )then
			msg.log.itemdata.base.count = log.itemdata.base.count
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.index ~= nil )then
			msg.log.itemdata.base.index = log.itemdata.base.index
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.createtime ~= nil )then
			msg.log.itemdata.base.createtime = log.itemdata.base.createtime
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.cd ~= nil )then
			msg.log.itemdata.base.cd = log.itemdata.base.cd
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.type ~= nil )then
			msg.log.itemdata.base.type = log.itemdata.base.type
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.bind ~= nil )then
			msg.log.itemdata.base.bind = log.itemdata.base.bind
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.expire ~= nil )then
			msg.log.itemdata.base.expire = log.itemdata.base.expire
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.quality ~= nil )then
			msg.log.itemdata.base.quality = log.itemdata.base.quality
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.equipType ~= nil )then
			msg.log.itemdata.base.equipType = log.itemdata.base.equipType
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.source ~= nil )then
			msg.log.itemdata.base.source = log.itemdata.base.source
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.isnew ~= nil )then
			msg.log.itemdata.base.isnew = log.itemdata.base.isnew
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.maxcardslot ~= nil )then
			msg.log.itemdata.base.maxcardslot = log.itemdata.base.maxcardslot
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.ishint ~= nil )then
			msg.log.itemdata.base.ishint = log.itemdata.base.ishint
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.isactive ~= nil )then
			msg.log.itemdata.base.isactive = log.itemdata.base.isactive
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.source_npc ~= nil )then
			msg.log.itemdata.base.source_npc = log.itemdata.base.source_npc
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.refinelv ~= nil )then
			msg.log.itemdata.base.refinelv = log.itemdata.base.refinelv
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.chargemoney ~= nil )then
			msg.log.itemdata.base.chargemoney = log.itemdata.base.chargemoney
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.overtime ~= nil )then
			msg.log.itemdata.base.overtime = log.itemdata.base.overtime
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.quota ~= nil )then
			msg.log.itemdata.base.quota = log.itemdata.base.quota
		end
	end
	if(log.itemdata ~= nil )then
		if(log.itemdata.equiped ~= nil )then
			msg.log.itemdata.equiped = log.itemdata.equiped
		end
	end
	if(log.itemdata ~= nil )then
		if(log.itemdata.battlepoint ~= nil )then
			msg.log.itemdata.battlepoint = log.itemdata.battlepoint
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.strengthlv ~= nil )then
			msg.log.itemdata.equip.strengthlv = log.itemdata.equip.strengthlv
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.refinelv ~= nil )then
			msg.log.itemdata.equip.refinelv = log.itemdata.equip.refinelv
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.strengthCost ~= nil )then
			msg.log.itemdata.equip.strengthCost = log.itemdata.equip.strengthCost
		end
	end
	if(log ~= nil )then
		if(log.itemdata.equip.refineCompose ~= nil )then
			for i=1,#log.itemdata.equip.refineCompose do 
				table.insert(msg.log.itemdata.equip.refineCompose, log.itemdata.equip.refineCompose[i])
			end
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.cardslot ~= nil )then
			msg.log.itemdata.equip.cardslot = log.itemdata.equip.cardslot
		end
	end
	if(log ~= nil )then
		if(log.itemdata.equip.buffid ~= nil )then
			for i=1,#log.itemdata.equip.buffid do 
				table.insert(msg.log.itemdata.equip.buffid, log.itemdata.equip.buffid[i])
			end
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.damage ~= nil )then
			msg.log.itemdata.equip.damage = log.itemdata.equip.damage
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.lv ~= nil )then
			msg.log.itemdata.equip.lv = log.itemdata.equip.lv
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.color ~= nil )then
			msg.log.itemdata.equip.color = log.itemdata.equip.color
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.breakstarttime ~= nil )then
			msg.log.itemdata.equip.breakstarttime = log.itemdata.equip.breakstarttime
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.breakendtime ~= nil )then
			msg.log.itemdata.equip.breakendtime = log.itemdata.equip.breakendtime
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.strengthlv2 ~= nil )then
			msg.log.itemdata.equip.strengthlv2 = log.itemdata.equip.strengthlv2
		end
	end
	if(log ~= nil )then
		if(log.itemdata.equip.strengthlv2cost ~= nil )then
			for i=1,#log.itemdata.equip.strengthlv2cost do 
				table.insert(msg.log.itemdata.equip.strengthlv2cost, log.itemdata.equip.strengthlv2cost[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.card ~= nil )then
			for i=1,#log.itemdata.card do 
				table.insert(msg.log.itemdata.card, log.itemdata.card[i])
			end
		end
	end
	if(log.itemdata.enchant ~= nil )then
		if(log.itemdata.enchant.type ~= nil )then
			msg.log.itemdata.enchant.type = log.itemdata.enchant.type
		end
	end
	if(log ~= nil )then
		if(log.itemdata.enchant.attrs ~= nil )then
			for i=1,#log.itemdata.enchant.attrs do 
				table.insert(msg.log.itemdata.enchant.attrs, log.itemdata.enchant.attrs[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.enchant.extras ~= nil )then
			for i=1,#log.itemdata.enchant.extras do 
				table.insert(msg.log.itemdata.enchant.extras, log.itemdata.enchant.extras[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.enchant.patch ~= nil )then
			for i=1,#log.itemdata.enchant.patch do 
				table.insert(msg.log.itemdata.enchant.patch, log.itemdata.enchant.patch[i])
			end
		end
	end
	if(log.itemdata.previewenchant ~= nil )then
		if(log.itemdata.previewenchant.type ~= nil )then
			msg.log.itemdata.previewenchant.type = log.itemdata.previewenchant.type
		end
	end
	if(log ~= nil )then
		if(log.itemdata.previewenchant.attrs ~= nil )then
			for i=1,#log.itemdata.previewenchant.attrs do 
				table.insert(msg.log.itemdata.previewenchant.attrs, log.itemdata.previewenchant.attrs[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.previewenchant.extras ~= nil )then
			for i=1,#log.itemdata.previewenchant.extras do 
				table.insert(msg.log.itemdata.previewenchant.extras, log.itemdata.previewenchant.extras[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.previewenchant.patch ~= nil )then
			for i=1,#log.itemdata.previewenchant.patch do 
				table.insert(msg.log.itemdata.previewenchant.patch, log.itemdata.previewenchant.patch[i])
			end
		end
	end
	if(log.itemdata.refine ~= nil )then
		if(log.itemdata.refine.lastfail ~= nil )then
			msg.log.itemdata.refine.lastfail = log.itemdata.refine.lastfail
		end
	end
	if(log.itemdata.refine ~= nil )then
		if(log.itemdata.refine.repaircount ~= nil )then
			msg.log.itemdata.refine.repaircount = log.itemdata.refine.repaircount
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.exp ~= nil )then
			msg.log.itemdata.egg.exp = log.itemdata.egg.exp
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.friendexp ~= nil )then
			msg.log.itemdata.egg.friendexp = log.itemdata.egg.friendexp
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.rewardexp ~= nil )then
			msg.log.itemdata.egg.rewardexp = log.itemdata.egg.rewardexp
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.id ~= nil )then
			msg.log.itemdata.egg.id = log.itemdata.egg.id
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.lv ~= nil )then
			msg.log.itemdata.egg.lv = log.itemdata.egg.lv
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.friendlv ~= nil )then
			msg.log.itemdata.egg.friendlv = log.itemdata.egg.friendlv
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.body ~= nil )then
			msg.log.itemdata.egg.body = log.itemdata.egg.body
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.relivetime ~= nil )then
			msg.log.itemdata.egg.relivetime = log.itemdata.egg.relivetime
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.hp ~= nil )then
			msg.log.itemdata.egg.hp = log.itemdata.egg.hp
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.restoretime ~= nil )then
			msg.log.itemdata.egg.restoretime = log.itemdata.egg.restoretime
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_happly ~= nil )then
			msg.log.itemdata.egg.time_happly = log.itemdata.egg.time_happly
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_excite ~= nil )then
			msg.log.itemdata.egg.time_excite = log.itemdata.egg.time_excite
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_happiness ~= nil )then
			msg.log.itemdata.egg.time_happiness = log.itemdata.egg.time_happiness
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_happly_gift ~= nil )then
			msg.log.itemdata.egg.time_happly_gift = log.itemdata.egg.time_happly_gift
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_excite_gift ~= nil )then
			msg.log.itemdata.egg.time_excite_gift = log.itemdata.egg.time_excite_gift
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_happiness_gift ~= nil )then
			msg.log.itemdata.egg.time_happiness_gift = log.itemdata.egg.time_happiness_gift
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.touch_tick ~= nil )then
			msg.log.itemdata.egg.touch_tick = log.itemdata.egg.touch_tick
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.feed_tick ~= nil )then
			msg.log.itemdata.egg.feed_tick = log.itemdata.egg.feed_tick
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.name ~= nil )then
			msg.log.itemdata.egg.name = log.itemdata.egg.name
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.var ~= nil )then
			msg.log.itemdata.egg.var = log.itemdata.egg.var
		end
	end
	if(log ~= nil )then
		if(log.itemdata.egg.skillids ~= nil )then
			for i=1,#log.itemdata.egg.skillids do 
				table.insert(msg.log.itemdata.egg.skillids, log.itemdata.egg.skillids[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.egg.equips ~= nil )then
			for i=1,#log.itemdata.egg.equips do 
				table.insert(msg.log.itemdata.egg.equips, log.itemdata.egg.equips[i])
			end
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.buff ~= nil )then
			msg.log.itemdata.egg.buff = log.itemdata.egg.buff
		end
	end
	if(log ~= nil )then
		if(log.itemdata.egg.unlock_equip ~= nil )then
			for i=1,#log.itemdata.egg.unlock_equip do 
				table.insert(msg.log.itemdata.egg.unlock_equip, log.itemdata.egg.unlock_equip[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.egg.unlock_body ~= nil )then
			for i=1,#log.itemdata.egg.unlock_body do 
				table.insert(msg.log.itemdata.egg.unlock_body, log.itemdata.egg.unlock_body[i])
			end
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.version ~= nil )then
			msg.log.itemdata.egg.version = log.itemdata.egg.version
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.skilloff ~= nil )then
			msg.log.itemdata.egg.skilloff = log.itemdata.egg.skilloff
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.exchange_count ~= nil )then
			msg.log.itemdata.egg.exchange_count = log.itemdata.egg.exchange_count
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.guid ~= nil )then
			msg.log.itemdata.egg.guid = log.itemdata.egg.guid
		end
	end
	if(log.itemdata.letter ~= nil )then
		if(log.itemdata.letter.sendUserName ~= nil )then
			msg.log.itemdata.letter.sendUserName = log.itemdata.letter.sendUserName
		end
	end
	if(log.itemdata.letter ~= nil )then
		if(log.itemdata.letter.bg ~= nil )then
			msg.log.itemdata.letter.bg = log.itemdata.letter.bg
		end
	end
	if(log.itemdata.letter ~= nil )then
		if(log.itemdata.letter.configID ~= nil )then
			msg.log.itemdata.letter.configID = log.itemdata.letter.configID
		end
	end
	if(log.itemdata.letter ~= nil )then
		if(log.itemdata.letter.content ~= nil )then
			msg.log.itemdata.letter.content = log.itemdata.letter.content
		end
	end
	if(log.itemdata.letter ~= nil )then
		if(log.itemdata.letter.content2 ~= nil )then
			msg.log.itemdata.letter.content2 = log.itemdata.letter.content2
		end
	end
	if(log.itemdata.code ~= nil )then
		if(log.itemdata.code.code ~= nil )then
			msg.log.itemdata.code.code = log.itemdata.code.code
		end
	end
	if(log.itemdata.code ~= nil )then
		if(log.itemdata.code.used ~= nil )then
			msg.log.itemdata.code.used = log.itemdata.code.used
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.id ~= nil )then
			msg.log.itemdata.wedding.id = log.itemdata.wedding.id
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.zoneid ~= nil )then
			msg.log.itemdata.wedding.zoneid = log.itemdata.wedding.zoneid
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.charid1 ~= nil )then
			msg.log.itemdata.wedding.charid1 = log.itemdata.wedding.charid1
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.charid2 ~= nil )then
			msg.log.itemdata.wedding.charid2 = log.itemdata.wedding.charid2
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.weddingtime ~= nil )then
			msg.log.itemdata.wedding.weddingtime = log.itemdata.wedding.weddingtime
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.photoidx ~= nil )then
			msg.log.itemdata.wedding.photoidx = log.itemdata.wedding.photoidx
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.phototime ~= nil )then
			msg.log.itemdata.wedding.phototime = log.itemdata.wedding.phototime
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.myname ~= nil )then
			msg.log.itemdata.wedding.myname = log.itemdata.wedding.myname
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.partnername ~= nil )then
			msg.log.itemdata.wedding.partnername = log.itemdata.wedding.partnername
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.starttime ~= nil )then
			msg.log.itemdata.wedding.starttime = log.itemdata.wedding.starttime
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.endtime ~= nil )then
			msg.log.itemdata.wedding.endtime = log.itemdata.wedding.endtime
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.notified ~= nil )then
			msg.log.itemdata.wedding.notified = log.itemdata.wedding.notified
		end
	end
	if(log.itemdata.sender ~= nil )then
		if(log.itemdata.sender.charid ~= nil )then
			msg.log.itemdata.sender.charid = log.itemdata.sender.charid
		end
	end
	if(log.itemdata.sender ~= nil )then
		if(log.itemdata.sender.name ~= nil )then
			msg.log.itemdata.sender.name = log.itemdata.sender.name
		end
	end
	if(log ~= nil )then
		if(log.receiverid ~= nil )then
			msg.log.receiverid = log.receiverid
		end
	end
	if(log ~= nil )then
		if(log.receivername ~= nil )then
			msg.log.receivername = log.receivername
		end
	end
	if(log ~= nil )then
		if(log.receiverzoneid ~= nil )then
			msg.log.receiverzoneid = log.receiverzoneid
		end
	end
	if(log ~= nil )then
		if(log.quota ~= nil )then
			msg.log.quota = log.quota
		end
	end
	if(log ~= nil )then
		if(log.background ~= nil )then
			msg.log.background = log.background
		end
	end
	if(log ~= nil )then
		if(log.expiretime ~= nil )then
			msg.log.expiretime = log.expiretime
		end
	end
	if(log ~= nil )then
		if(log.ret_cost ~= nil )then
			msg.log.ret_cost = log.ret_cost
		end
	end
	if(log ~= nil )then
		if(log.cangive ~= nil )then
			msg.log.cangive = log.cangive
		end
	end
	if(log ~= nil )then
		if(log.trade_type ~= nil )then
			msg.log.trade_type = log.trade_type
		end
	end
	if(log ~= nil )then
		if(log.is_public ~= nil )then
			msg.log.is_public = log.is_public
		end
	end
	if(log ~= nil )then
		if(log.quota_cost ~= nil )then
			msg.log.quota_cost = log.quota_cost
		end
	end
	if(success ~= nil )then
		msg.success = success
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallAddNewLog(charid, log, total_page_count) 
	local msg = RecordTrade_pb.AddNewLog()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(log ~= nil )then
		if(log.id ~= nil )then
			msg.log.id = log.id
		end
	end
	if(log ~= nil )then
		if(log.status ~= nil )then
			msg.log.status = log.status
		end
	end
	if(log ~= nil )then
		if(log.logtype ~= nil )then
			msg.log.logtype = log.logtype
		end
	end
	if(log ~= nil )then
		if(log.itemid ~= nil )then
			msg.log.itemid = log.itemid
		end
	end
	if(log ~= nil )then
		if(log.refine_lv ~= nil )then
			msg.log.refine_lv = log.refine_lv
		end
	end
	if(log ~= nil )then
		if(log.damage ~= nil )then
			msg.log.damage = log.damage
		end
	end
	if(log ~= nil )then
		if(log.tradetime ~= nil )then
			msg.log.tradetime = log.tradetime
		end
	end
	if(log ~= nil )then
		if(log.count ~= nil )then
			msg.log.count = log.count
		end
	end
	if(log ~= nil )then
		if(log.price ~= nil )then
			msg.log.price = log.price
		end
	end
	if(log ~= nil )then
		if(log.tax ~= nil )then
			msg.log.tax = log.tax
		end
	end
	if(log ~= nil )then
		if(log.getmoney ~= nil )then
			msg.log.getmoney = log.getmoney
		end
	end
	if(log ~= nil )then
		if(log.costmoney ~= nil )then
			msg.log.costmoney = log.costmoney
		end
	end
	if(log ~= nil )then
		if(log.failcount ~= nil )then
			msg.log.failcount = log.failcount
		end
	end
	if(log ~= nil )then
		if(log.retmoney ~= nil )then
			msg.log.retmoney = log.retmoney
		end
	end
	if(log ~= nil )then
		if(log.totalcount ~= nil )then
			msg.log.totalcount = log.totalcount
		end
	end
	if(log ~= nil )then
		if(log.endtime ~= nil )then
			msg.log.endtime = log.endtime
		end
	end
	if(log.name_info ~= nil )then
		if(log.name_info.name ~= nil )then
			msg.log.name_info.name = log.name_info.name
		end
	end
	if(log.name_info ~= nil )then
		if(log.name_info.zoneid ~= nil )then
			msg.log.name_info.zoneid = log.name_info.zoneid
		end
	end
	if(log.name_info ~= nil )then
		if(log.name_info.count ~= nil )then
			msg.log.name_info.count = log.name_info.count
		end
	end
	if(log ~= nil )then
		if(log.is_many_people ~= nil )then
			msg.log.is_many_people = log.is_many_people
		end
	end
	if(log ~= nil )then
		if(log.name_list.name_infos ~= nil )then
			for i=1,#log.name_list.name_infos do 
				table.insert(msg.log.name_list.name_infos, log.name_list.name_infos[i])
			end
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.guid ~= nil )then
			msg.log.itemdata.base.guid = log.itemdata.base.guid
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.id ~= nil )then
			msg.log.itemdata.base.id = log.itemdata.base.id
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.count ~= nil )then
			msg.log.itemdata.base.count = log.itemdata.base.count
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.index ~= nil )then
			msg.log.itemdata.base.index = log.itemdata.base.index
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.createtime ~= nil )then
			msg.log.itemdata.base.createtime = log.itemdata.base.createtime
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.cd ~= nil )then
			msg.log.itemdata.base.cd = log.itemdata.base.cd
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.type ~= nil )then
			msg.log.itemdata.base.type = log.itemdata.base.type
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.bind ~= nil )then
			msg.log.itemdata.base.bind = log.itemdata.base.bind
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.expire ~= nil )then
			msg.log.itemdata.base.expire = log.itemdata.base.expire
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.quality ~= nil )then
			msg.log.itemdata.base.quality = log.itemdata.base.quality
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.equipType ~= nil )then
			msg.log.itemdata.base.equipType = log.itemdata.base.equipType
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.source ~= nil )then
			msg.log.itemdata.base.source = log.itemdata.base.source
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.isnew ~= nil )then
			msg.log.itemdata.base.isnew = log.itemdata.base.isnew
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.maxcardslot ~= nil )then
			msg.log.itemdata.base.maxcardslot = log.itemdata.base.maxcardslot
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.ishint ~= nil )then
			msg.log.itemdata.base.ishint = log.itemdata.base.ishint
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.isactive ~= nil )then
			msg.log.itemdata.base.isactive = log.itemdata.base.isactive
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.source_npc ~= nil )then
			msg.log.itemdata.base.source_npc = log.itemdata.base.source_npc
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.refinelv ~= nil )then
			msg.log.itemdata.base.refinelv = log.itemdata.base.refinelv
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.chargemoney ~= nil )then
			msg.log.itemdata.base.chargemoney = log.itemdata.base.chargemoney
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.overtime ~= nil )then
			msg.log.itemdata.base.overtime = log.itemdata.base.overtime
		end
	end
	if(log.itemdata.base ~= nil )then
		if(log.itemdata.base.quota ~= nil )then
			msg.log.itemdata.base.quota = log.itemdata.base.quota
		end
	end
	if(log.itemdata ~= nil )then
		if(log.itemdata.equiped ~= nil )then
			msg.log.itemdata.equiped = log.itemdata.equiped
		end
	end
	if(log.itemdata ~= nil )then
		if(log.itemdata.battlepoint ~= nil )then
			msg.log.itemdata.battlepoint = log.itemdata.battlepoint
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.strengthlv ~= nil )then
			msg.log.itemdata.equip.strengthlv = log.itemdata.equip.strengthlv
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.refinelv ~= nil )then
			msg.log.itemdata.equip.refinelv = log.itemdata.equip.refinelv
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.strengthCost ~= nil )then
			msg.log.itemdata.equip.strengthCost = log.itemdata.equip.strengthCost
		end
	end
	if(log ~= nil )then
		if(log.itemdata.equip.refineCompose ~= nil )then
			for i=1,#log.itemdata.equip.refineCompose do 
				table.insert(msg.log.itemdata.equip.refineCompose, log.itemdata.equip.refineCompose[i])
			end
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.cardslot ~= nil )then
			msg.log.itemdata.equip.cardslot = log.itemdata.equip.cardslot
		end
	end
	if(log ~= nil )then
		if(log.itemdata.equip.buffid ~= nil )then
			for i=1,#log.itemdata.equip.buffid do 
				table.insert(msg.log.itemdata.equip.buffid, log.itemdata.equip.buffid[i])
			end
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.damage ~= nil )then
			msg.log.itemdata.equip.damage = log.itemdata.equip.damage
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.lv ~= nil )then
			msg.log.itemdata.equip.lv = log.itemdata.equip.lv
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.color ~= nil )then
			msg.log.itemdata.equip.color = log.itemdata.equip.color
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.breakstarttime ~= nil )then
			msg.log.itemdata.equip.breakstarttime = log.itemdata.equip.breakstarttime
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.breakendtime ~= nil )then
			msg.log.itemdata.equip.breakendtime = log.itemdata.equip.breakendtime
		end
	end
	if(log.itemdata.equip ~= nil )then
		if(log.itemdata.equip.strengthlv2 ~= nil )then
			msg.log.itemdata.equip.strengthlv2 = log.itemdata.equip.strengthlv2
		end
	end
	if(log ~= nil )then
		if(log.itemdata.equip.strengthlv2cost ~= nil )then
			for i=1,#log.itemdata.equip.strengthlv2cost do 
				table.insert(msg.log.itemdata.equip.strengthlv2cost, log.itemdata.equip.strengthlv2cost[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.card ~= nil )then
			for i=1,#log.itemdata.card do 
				table.insert(msg.log.itemdata.card, log.itemdata.card[i])
			end
		end
	end
	if(log.itemdata.enchant ~= nil )then
		if(log.itemdata.enchant.type ~= nil )then
			msg.log.itemdata.enchant.type = log.itemdata.enchant.type
		end
	end
	if(log ~= nil )then
		if(log.itemdata.enchant.attrs ~= nil )then
			for i=1,#log.itemdata.enchant.attrs do 
				table.insert(msg.log.itemdata.enchant.attrs, log.itemdata.enchant.attrs[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.enchant.extras ~= nil )then
			for i=1,#log.itemdata.enchant.extras do 
				table.insert(msg.log.itemdata.enchant.extras, log.itemdata.enchant.extras[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.enchant.patch ~= nil )then
			for i=1,#log.itemdata.enchant.patch do 
				table.insert(msg.log.itemdata.enchant.patch, log.itemdata.enchant.patch[i])
			end
		end
	end
	if(log.itemdata.previewenchant ~= nil )then
		if(log.itemdata.previewenchant.type ~= nil )then
			msg.log.itemdata.previewenchant.type = log.itemdata.previewenchant.type
		end
	end
	if(log ~= nil )then
		if(log.itemdata.previewenchant.attrs ~= nil )then
			for i=1,#log.itemdata.previewenchant.attrs do 
				table.insert(msg.log.itemdata.previewenchant.attrs, log.itemdata.previewenchant.attrs[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.previewenchant.extras ~= nil )then
			for i=1,#log.itemdata.previewenchant.extras do 
				table.insert(msg.log.itemdata.previewenchant.extras, log.itemdata.previewenchant.extras[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.previewenchant.patch ~= nil )then
			for i=1,#log.itemdata.previewenchant.patch do 
				table.insert(msg.log.itemdata.previewenchant.patch, log.itemdata.previewenchant.patch[i])
			end
		end
	end
	if(log.itemdata.refine ~= nil )then
		if(log.itemdata.refine.lastfail ~= nil )then
			msg.log.itemdata.refine.lastfail = log.itemdata.refine.lastfail
		end
	end
	if(log.itemdata.refine ~= nil )then
		if(log.itemdata.refine.repaircount ~= nil )then
			msg.log.itemdata.refine.repaircount = log.itemdata.refine.repaircount
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.exp ~= nil )then
			msg.log.itemdata.egg.exp = log.itemdata.egg.exp
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.friendexp ~= nil )then
			msg.log.itemdata.egg.friendexp = log.itemdata.egg.friendexp
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.rewardexp ~= nil )then
			msg.log.itemdata.egg.rewardexp = log.itemdata.egg.rewardexp
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.id ~= nil )then
			msg.log.itemdata.egg.id = log.itemdata.egg.id
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.lv ~= nil )then
			msg.log.itemdata.egg.lv = log.itemdata.egg.lv
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.friendlv ~= nil )then
			msg.log.itemdata.egg.friendlv = log.itemdata.egg.friendlv
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.body ~= nil )then
			msg.log.itemdata.egg.body = log.itemdata.egg.body
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.relivetime ~= nil )then
			msg.log.itemdata.egg.relivetime = log.itemdata.egg.relivetime
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.hp ~= nil )then
			msg.log.itemdata.egg.hp = log.itemdata.egg.hp
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.restoretime ~= nil )then
			msg.log.itemdata.egg.restoretime = log.itemdata.egg.restoretime
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_happly ~= nil )then
			msg.log.itemdata.egg.time_happly = log.itemdata.egg.time_happly
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_excite ~= nil )then
			msg.log.itemdata.egg.time_excite = log.itemdata.egg.time_excite
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_happiness ~= nil )then
			msg.log.itemdata.egg.time_happiness = log.itemdata.egg.time_happiness
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_happly_gift ~= nil )then
			msg.log.itemdata.egg.time_happly_gift = log.itemdata.egg.time_happly_gift
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_excite_gift ~= nil )then
			msg.log.itemdata.egg.time_excite_gift = log.itemdata.egg.time_excite_gift
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.time_happiness_gift ~= nil )then
			msg.log.itemdata.egg.time_happiness_gift = log.itemdata.egg.time_happiness_gift
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.touch_tick ~= nil )then
			msg.log.itemdata.egg.touch_tick = log.itemdata.egg.touch_tick
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.feed_tick ~= nil )then
			msg.log.itemdata.egg.feed_tick = log.itemdata.egg.feed_tick
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.name ~= nil )then
			msg.log.itemdata.egg.name = log.itemdata.egg.name
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.var ~= nil )then
			msg.log.itemdata.egg.var = log.itemdata.egg.var
		end
	end
	if(log ~= nil )then
		if(log.itemdata.egg.skillids ~= nil )then
			for i=1,#log.itemdata.egg.skillids do 
				table.insert(msg.log.itemdata.egg.skillids, log.itemdata.egg.skillids[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.egg.equips ~= nil )then
			for i=1,#log.itemdata.egg.equips do 
				table.insert(msg.log.itemdata.egg.equips, log.itemdata.egg.equips[i])
			end
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.buff ~= nil )then
			msg.log.itemdata.egg.buff = log.itemdata.egg.buff
		end
	end
	if(log ~= nil )then
		if(log.itemdata.egg.unlock_equip ~= nil )then
			for i=1,#log.itemdata.egg.unlock_equip do 
				table.insert(msg.log.itemdata.egg.unlock_equip, log.itemdata.egg.unlock_equip[i])
			end
		end
	end
	if(log ~= nil )then
		if(log.itemdata.egg.unlock_body ~= nil )then
			for i=1,#log.itemdata.egg.unlock_body do 
				table.insert(msg.log.itemdata.egg.unlock_body, log.itemdata.egg.unlock_body[i])
			end
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.version ~= nil )then
			msg.log.itemdata.egg.version = log.itemdata.egg.version
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.skilloff ~= nil )then
			msg.log.itemdata.egg.skilloff = log.itemdata.egg.skilloff
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.exchange_count ~= nil )then
			msg.log.itemdata.egg.exchange_count = log.itemdata.egg.exchange_count
		end
	end
	if(log.itemdata.egg ~= nil )then
		if(log.itemdata.egg.guid ~= nil )then
			msg.log.itemdata.egg.guid = log.itemdata.egg.guid
		end
	end
	if(log.itemdata.letter ~= nil )then
		if(log.itemdata.letter.sendUserName ~= nil )then
			msg.log.itemdata.letter.sendUserName = log.itemdata.letter.sendUserName
		end
	end
	if(log.itemdata.letter ~= nil )then
		if(log.itemdata.letter.bg ~= nil )then
			msg.log.itemdata.letter.bg = log.itemdata.letter.bg
		end
	end
	if(log.itemdata.letter ~= nil )then
		if(log.itemdata.letter.configID ~= nil )then
			msg.log.itemdata.letter.configID = log.itemdata.letter.configID
		end
	end
	if(log.itemdata.letter ~= nil )then
		if(log.itemdata.letter.content ~= nil )then
			msg.log.itemdata.letter.content = log.itemdata.letter.content
		end
	end
	if(log.itemdata.letter ~= nil )then
		if(log.itemdata.letter.content2 ~= nil )then
			msg.log.itemdata.letter.content2 = log.itemdata.letter.content2
		end
	end
	if(log.itemdata.code ~= nil )then
		if(log.itemdata.code.code ~= nil )then
			msg.log.itemdata.code.code = log.itemdata.code.code
		end
	end
	if(log.itemdata.code ~= nil )then
		if(log.itemdata.code.used ~= nil )then
			msg.log.itemdata.code.used = log.itemdata.code.used
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.id ~= nil )then
			msg.log.itemdata.wedding.id = log.itemdata.wedding.id
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.zoneid ~= nil )then
			msg.log.itemdata.wedding.zoneid = log.itemdata.wedding.zoneid
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.charid1 ~= nil )then
			msg.log.itemdata.wedding.charid1 = log.itemdata.wedding.charid1
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.charid2 ~= nil )then
			msg.log.itemdata.wedding.charid2 = log.itemdata.wedding.charid2
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.weddingtime ~= nil )then
			msg.log.itemdata.wedding.weddingtime = log.itemdata.wedding.weddingtime
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.photoidx ~= nil )then
			msg.log.itemdata.wedding.photoidx = log.itemdata.wedding.photoidx
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.phototime ~= nil )then
			msg.log.itemdata.wedding.phototime = log.itemdata.wedding.phototime
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.myname ~= nil )then
			msg.log.itemdata.wedding.myname = log.itemdata.wedding.myname
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.partnername ~= nil )then
			msg.log.itemdata.wedding.partnername = log.itemdata.wedding.partnername
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.starttime ~= nil )then
			msg.log.itemdata.wedding.starttime = log.itemdata.wedding.starttime
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.endtime ~= nil )then
			msg.log.itemdata.wedding.endtime = log.itemdata.wedding.endtime
		end
	end
	if(log.itemdata.wedding ~= nil )then
		if(log.itemdata.wedding.notified ~= nil )then
			msg.log.itemdata.wedding.notified = log.itemdata.wedding.notified
		end
	end
	if(log.itemdata.sender ~= nil )then
		if(log.itemdata.sender.charid ~= nil )then
			msg.log.itemdata.sender.charid = log.itemdata.sender.charid
		end
	end
	if(log.itemdata.sender ~= nil )then
		if(log.itemdata.sender.name ~= nil )then
			msg.log.itemdata.sender.name = log.itemdata.sender.name
		end
	end
	if(log ~= nil )then
		if(log.receiverid ~= nil )then
			msg.log.receiverid = log.receiverid
		end
	end
	if(log ~= nil )then
		if(log.receivername ~= nil )then
			msg.log.receivername = log.receivername
		end
	end
	if(log ~= nil )then
		if(log.receiverzoneid ~= nil )then
			msg.log.receiverzoneid = log.receiverzoneid
		end
	end
	if(log ~= nil )then
		if(log.quota ~= nil )then
			msg.log.quota = log.quota
		end
	end
	if(log ~= nil )then
		if(log.background ~= nil )then
			msg.log.background = log.background
		end
	end
	if(log ~= nil )then
		if(log.expiretime ~= nil )then
			msg.log.expiretime = log.expiretime
		end
	end
	if(log ~= nil )then
		if(log.ret_cost ~= nil )then
			msg.log.ret_cost = log.ret_cost
		end
	end
	if(log ~= nil )then
		if(log.cangive ~= nil )then
			msg.log.cangive = log.cangive
		end
	end
	if(log ~= nil )then
		if(log.trade_type ~= nil )then
			msg.log.trade_type = log.trade_type
		end
	end
	if(log ~= nil )then
		if(log.is_public ~= nil )then
			msg.log.is_public = log.is_public
		end
	end
	if(log ~= nil )then
		if(log.quota_cost ~= nil )then
			msg.log.quota_cost = log.quota_cost
		end
	end
	if(total_page_count ~= nil )then
		msg.total_page_count = total_page_count
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallFetchNameInfoCmd(id, type, index, total_page_count, name_list) 
	local msg = RecordTrade_pb.FetchNameInfoCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(index ~= nil )then
		msg.index = index
	end
	if(total_page_count ~= nil )then
		msg.total_page_count = total_page_count
	end
	if(name_list ~= nil )then
		if(name_list.name_infos ~= nil )then
			for i=1,#name_list.name_infos do 
				table.insert(msg.name_list.name_infos, name_list.name_infos[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallReqServerPriceRecordTradeCmd(charid, itemData, price, issell, statetype, count, buyer_count, end_time) 
	local msg = RecordTrade_pb.ReqServerPriceRecordTradeCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(itemData.base ~= nil )then
		if(itemData.base.guid ~= nil )then
			msg.itemData.base.guid = itemData.base.guid
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.id ~= nil )then
			msg.itemData.base.id = itemData.base.id
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.count ~= nil )then
			msg.itemData.base.count = itemData.base.count
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.index ~= nil )then
			msg.itemData.base.index = itemData.base.index
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.createtime ~= nil )then
			msg.itemData.base.createtime = itemData.base.createtime
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.cd ~= nil )then
			msg.itemData.base.cd = itemData.base.cd
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.type ~= nil )then
			msg.itemData.base.type = itemData.base.type
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.bind ~= nil )then
			msg.itemData.base.bind = itemData.base.bind
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.expire ~= nil )then
			msg.itemData.base.expire = itemData.base.expire
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.quality ~= nil )then
			msg.itemData.base.quality = itemData.base.quality
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.equipType ~= nil )then
			msg.itemData.base.equipType = itemData.base.equipType
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.source ~= nil )then
			msg.itemData.base.source = itemData.base.source
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.isnew ~= nil )then
			msg.itemData.base.isnew = itemData.base.isnew
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.maxcardslot ~= nil )then
			msg.itemData.base.maxcardslot = itemData.base.maxcardslot
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.ishint ~= nil )then
			msg.itemData.base.ishint = itemData.base.ishint
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.isactive ~= nil )then
			msg.itemData.base.isactive = itemData.base.isactive
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.source_npc ~= nil )then
			msg.itemData.base.source_npc = itemData.base.source_npc
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.refinelv ~= nil )then
			msg.itemData.base.refinelv = itemData.base.refinelv
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.chargemoney ~= nil )then
			msg.itemData.base.chargemoney = itemData.base.chargemoney
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.overtime ~= nil )then
			msg.itemData.base.overtime = itemData.base.overtime
		end
	end
	if(itemData.base ~= nil )then
		if(itemData.base.quota ~= nil )then
			msg.itemData.base.quota = itemData.base.quota
		end
	end
	if(itemData ~= nil )then
		if(itemData.equiped ~= nil )then
			msg.itemData.equiped = itemData.equiped
		end
	end
	if(itemData ~= nil )then
		if(itemData.battlepoint ~= nil )then
			msg.itemData.battlepoint = itemData.battlepoint
		end
	end
	if(itemData.equip ~= nil )then
		if(itemData.equip.strengthlv ~= nil )then
			msg.itemData.equip.strengthlv = itemData.equip.strengthlv
		end
	end
	if(itemData.equip ~= nil )then
		if(itemData.equip.refinelv ~= nil )then
			msg.itemData.equip.refinelv = itemData.equip.refinelv
		end
	end
	if(itemData.equip ~= nil )then
		if(itemData.equip.strengthCost ~= nil )then
			msg.itemData.equip.strengthCost = itemData.equip.strengthCost
		end
	end
	if(itemData ~= nil )then
		if(itemData.equip.refineCompose ~= nil )then
			for i=1,#itemData.equip.refineCompose do 
				table.insert(msg.itemData.equip.refineCompose, itemData.equip.refineCompose[i])
			end
		end
	end
	if(itemData.equip ~= nil )then
		if(itemData.equip.cardslot ~= nil )then
			msg.itemData.equip.cardslot = itemData.equip.cardslot
		end
	end
	if(itemData ~= nil )then
		if(itemData.equip.buffid ~= nil )then
			for i=1,#itemData.equip.buffid do 
				table.insert(msg.itemData.equip.buffid, itemData.equip.buffid[i])
			end
		end
	end
	if(itemData.equip ~= nil )then
		if(itemData.equip.damage ~= nil )then
			msg.itemData.equip.damage = itemData.equip.damage
		end
	end
	if(itemData.equip ~= nil )then
		if(itemData.equip.lv ~= nil )then
			msg.itemData.equip.lv = itemData.equip.lv
		end
	end
	if(itemData.equip ~= nil )then
		if(itemData.equip.color ~= nil )then
			msg.itemData.equip.color = itemData.equip.color
		end
	end
	if(itemData.equip ~= nil )then
		if(itemData.equip.breakstarttime ~= nil )then
			msg.itemData.equip.breakstarttime = itemData.equip.breakstarttime
		end
	end
	if(itemData.equip ~= nil )then
		if(itemData.equip.breakendtime ~= nil )then
			msg.itemData.equip.breakendtime = itemData.equip.breakendtime
		end
	end
	if(itemData.equip ~= nil )then
		if(itemData.equip.strengthlv2 ~= nil )then
			msg.itemData.equip.strengthlv2 = itemData.equip.strengthlv2
		end
	end
	if(itemData ~= nil )then
		if(itemData.equip.strengthlv2cost ~= nil )then
			for i=1,#itemData.equip.strengthlv2cost do 
				table.insert(msg.itemData.equip.strengthlv2cost, itemData.equip.strengthlv2cost[i])
			end
		end
	end
	if(itemData ~= nil )then
		if(itemData.card ~= nil )then
			for i=1,#itemData.card do 
				table.insert(msg.itemData.card, itemData.card[i])
			end
		end
	end
	if(itemData.enchant ~= nil )then
		if(itemData.enchant.type ~= nil )then
			msg.itemData.enchant.type = itemData.enchant.type
		end
	end
	if(itemData ~= nil )then
		if(itemData.enchant.attrs ~= nil )then
			for i=1,#itemData.enchant.attrs do 
				table.insert(msg.itemData.enchant.attrs, itemData.enchant.attrs[i])
			end
		end
	end
	if(itemData ~= nil )then
		if(itemData.enchant.extras ~= nil )then
			for i=1,#itemData.enchant.extras do 
				table.insert(msg.itemData.enchant.extras, itemData.enchant.extras[i])
			end
		end
	end
	if(itemData ~= nil )then
		if(itemData.enchant.patch ~= nil )then
			for i=1,#itemData.enchant.patch do 
				table.insert(msg.itemData.enchant.patch, itemData.enchant.patch[i])
			end
		end
	end
	if(itemData.previewenchant ~= nil )then
		if(itemData.previewenchant.type ~= nil )then
			msg.itemData.previewenchant.type = itemData.previewenchant.type
		end
	end
	if(itemData ~= nil )then
		if(itemData.previewenchant.attrs ~= nil )then
			for i=1,#itemData.previewenchant.attrs do 
				table.insert(msg.itemData.previewenchant.attrs, itemData.previewenchant.attrs[i])
			end
		end
	end
	if(itemData ~= nil )then
		if(itemData.previewenchant.extras ~= nil )then
			for i=1,#itemData.previewenchant.extras do 
				table.insert(msg.itemData.previewenchant.extras, itemData.previewenchant.extras[i])
			end
		end
	end
	if(itemData ~= nil )then
		if(itemData.previewenchant.patch ~= nil )then
			for i=1,#itemData.previewenchant.patch do 
				table.insert(msg.itemData.previewenchant.patch, itemData.previewenchant.patch[i])
			end
		end
	end
	if(itemData.refine ~= nil )then
		if(itemData.refine.lastfail ~= nil )then
			msg.itemData.refine.lastfail = itemData.refine.lastfail
		end
	end
	if(itemData.refine ~= nil )then
		if(itemData.refine.repaircount ~= nil )then
			msg.itemData.refine.repaircount = itemData.refine.repaircount
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.exp ~= nil )then
			msg.itemData.egg.exp = itemData.egg.exp
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.friendexp ~= nil )then
			msg.itemData.egg.friendexp = itemData.egg.friendexp
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.rewardexp ~= nil )then
			msg.itemData.egg.rewardexp = itemData.egg.rewardexp
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.id ~= nil )then
			msg.itemData.egg.id = itemData.egg.id
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.lv ~= nil )then
			msg.itemData.egg.lv = itemData.egg.lv
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.friendlv ~= nil )then
			msg.itemData.egg.friendlv = itemData.egg.friendlv
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.body ~= nil )then
			msg.itemData.egg.body = itemData.egg.body
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.relivetime ~= nil )then
			msg.itemData.egg.relivetime = itemData.egg.relivetime
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.hp ~= nil )then
			msg.itemData.egg.hp = itemData.egg.hp
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.restoretime ~= nil )then
			msg.itemData.egg.restoretime = itemData.egg.restoretime
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.time_happly ~= nil )then
			msg.itemData.egg.time_happly = itemData.egg.time_happly
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.time_excite ~= nil )then
			msg.itemData.egg.time_excite = itemData.egg.time_excite
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.time_happiness ~= nil )then
			msg.itemData.egg.time_happiness = itemData.egg.time_happiness
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.time_happly_gift ~= nil )then
			msg.itemData.egg.time_happly_gift = itemData.egg.time_happly_gift
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.time_excite_gift ~= nil )then
			msg.itemData.egg.time_excite_gift = itemData.egg.time_excite_gift
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.time_happiness_gift ~= nil )then
			msg.itemData.egg.time_happiness_gift = itemData.egg.time_happiness_gift
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.touch_tick ~= nil )then
			msg.itemData.egg.touch_tick = itemData.egg.touch_tick
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.feed_tick ~= nil )then
			msg.itemData.egg.feed_tick = itemData.egg.feed_tick
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.name ~= nil )then
			msg.itemData.egg.name = itemData.egg.name
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.var ~= nil )then
			msg.itemData.egg.var = itemData.egg.var
		end
	end
	if(itemData ~= nil )then
		if(itemData.egg.skillids ~= nil )then
			for i=1,#itemData.egg.skillids do 
				table.insert(msg.itemData.egg.skillids, itemData.egg.skillids[i])
			end
		end
	end
	if(itemData ~= nil )then
		if(itemData.egg.equips ~= nil )then
			for i=1,#itemData.egg.equips do 
				table.insert(msg.itemData.egg.equips, itemData.egg.equips[i])
			end
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.buff ~= nil )then
			msg.itemData.egg.buff = itemData.egg.buff
		end
	end
	if(itemData ~= nil )then
		if(itemData.egg.unlock_equip ~= nil )then
			for i=1,#itemData.egg.unlock_equip do 
				table.insert(msg.itemData.egg.unlock_equip, itemData.egg.unlock_equip[i])
			end
		end
	end
	if(itemData ~= nil )then
		if(itemData.egg.unlock_body ~= nil )then
			for i=1,#itemData.egg.unlock_body do 
				table.insert(msg.itemData.egg.unlock_body, itemData.egg.unlock_body[i])
			end
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.version ~= nil )then
			msg.itemData.egg.version = itemData.egg.version
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.skilloff ~= nil )then
			msg.itemData.egg.skilloff = itemData.egg.skilloff
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.exchange_count ~= nil )then
			msg.itemData.egg.exchange_count = itemData.egg.exchange_count
		end
	end
	if(itemData.egg ~= nil )then
		if(itemData.egg.guid ~= nil )then
			msg.itemData.egg.guid = itemData.egg.guid
		end
	end
	if(itemData.letter ~= nil )then
		if(itemData.letter.sendUserName ~= nil )then
			msg.itemData.letter.sendUserName = itemData.letter.sendUserName
		end
	end
	if(itemData.letter ~= nil )then
		if(itemData.letter.bg ~= nil )then
			msg.itemData.letter.bg = itemData.letter.bg
		end
	end
	if(itemData.letter ~= nil )then
		if(itemData.letter.configID ~= nil )then
			msg.itemData.letter.configID = itemData.letter.configID
		end
	end
	if(itemData.letter ~= nil )then
		if(itemData.letter.content ~= nil )then
			msg.itemData.letter.content = itemData.letter.content
		end
	end
	if(itemData.letter ~= nil )then
		if(itemData.letter.content2 ~= nil )then
			msg.itemData.letter.content2 = itemData.letter.content2
		end
	end
	if(itemData.code ~= nil )then
		if(itemData.code.code ~= nil )then
			msg.itemData.code.code = itemData.code.code
		end
	end
	if(itemData.code ~= nil )then
		if(itemData.code.used ~= nil )then
			msg.itemData.code.used = itemData.code.used
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.id ~= nil )then
			msg.itemData.wedding.id = itemData.wedding.id
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.zoneid ~= nil )then
			msg.itemData.wedding.zoneid = itemData.wedding.zoneid
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.charid1 ~= nil )then
			msg.itemData.wedding.charid1 = itemData.wedding.charid1
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.charid2 ~= nil )then
			msg.itemData.wedding.charid2 = itemData.wedding.charid2
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.weddingtime ~= nil )then
			msg.itemData.wedding.weddingtime = itemData.wedding.weddingtime
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.photoidx ~= nil )then
			msg.itemData.wedding.photoidx = itemData.wedding.photoidx
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.phototime ~= nil )then
			msg.itemData.wedding.phototime = itemData.wedding.phototime
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.myname ~= nil )then
			msg.itemData.wedding.myname = itemData.wedding.myname
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.partnername ~= nil )then
			msg.itemData.wedding.partnername = itemData.wedding.partnername
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.starttime ~= nil )then
			msg.itemData.wedding.starttime = itemData.wedding.starttime
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.endtime ~= nil )then
			msg.itemData.wedding.endtime = itemData.wedding.endtime
		end
	end
	if(itemData.wedding ~= nil )then
		if(itemData.wedding.notified ~= nil )then
			msg.itemData.wedding.notified = itemData.wedding.notified
		end
	end
	if(itemData.sender ~= nil )then
		if(itemData.sender.charid ~= nil )then
			msg.itemData.sender.charid = itemData.sender.charid
		end
	end
	if(itemData.sender ~= nil )then
		if(itemData.sender.name ~= nil )then
			msg.itemData.sender.name = itemData.sender.name
		end
	end
	if(price ~= nil )then
		msg.price = price
	end
	if(issell ~= nil )then
		msg.issell = issell
	end
	if(statetype ~= nil )then
		msg.statetype = statetype
	end
	if(count ~= nil )then
		msg.count = count
	end
	if(buyer_count ~= nil )then
		msg.buyer_count = buyer_count
	end
	if(end_time ~= nil )then
		msg.end_time = end_time
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallBuyItemRecordTradeCmd(item_info, charid, ret, type) 
	local msg = RecordTrade_pb.BuyItemRecordTradeCmd()
	if(item_info ~= nil )then
		if(item_info.itemid ~= nil )then
			msg.item_info.itemid = item_info.itemid
		end
	end
	if(item_info ~= nil )then
		if(item_info.price ~= nil )then
			msg.item_info.price = item_info.price
		end
	end
	if(item_info ~= nil )then
		if(item_info.count ~= nil )then
			msg.item_info.count = item_info.count
		end
	end
	if(item_info ~= nil )then
		if(item_info.guid ~= nil )then
			msg.item_info.guid = item_info.guid
		end
	end
	if(item_info ~= nil )then
		if(item_info.order_id ~= nil )then
			msg.item_info.order_id = item_info.order_id
		end
	end
	if(item_info ~= nil )then
		if(item_info.refine_lv ~= nil )then
			msg.item_info.refine_lv = item_info.refine_lv
		end
	end
	if(item_info ~= nil )then
		if(item_info.overlap ~= nil )then
			msg.item_info.overlap = item_info.overlap
		end
	end
	if(item_info ~= nil )then
		if(item_info.is_expired ~= nil )then
			msg.item_info.is_expired = item_info.is_expired
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.guid ~= nil )then
			msg.item_info.item_data.base.guid = item_info.item_data.base.guid
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.id ~= nil )then
			msg.item_info.item_data.base.id = item_info.item_data.base.id
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.count ~= nil )then
			msg.item_info.item_data.base.count = item_info.item_data.base.count
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.index ~= nil )then
			msg.item_info.item_data.base.index = item_info.item_data.base.index
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.createtime ~= nil )then
			msg.item_info.item_data.base.createtime = item_info.item_data.base.createtime
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.cd ~= nil )then
			msg.item_info.item_data.base.cd = item_info.item_data.base.cd
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.type ~= nil )then
			msg.item_info.item_data.base.type = item_info.item_data.base.type
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.bind ~= nil )then
			msg.item_info.item_data.base.bind = item_info.item_data.base.bind
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.expire ~= nil )then
			msg.item_info.item_data.base.expire = item_info.item_data.base.expire
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.quality ~= nil )then
			msg.item_info.item_data.base.quality = item_info.item_data.base.quality
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.equipType ~= nil )then
			msg.item_info.item_data.base.equipType = item_info.item_data.base.equipType
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.source ~= nil )then
			msg.item_info.item_data.base.source = item_info.item_data.base.source
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.isnew ~= nil )then
			msg.item_info.item_data.base.isnew = item_info.item_data.base.isnew
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.maxcardslot ~= nil )then
			msg.item_info.item_data.base.maxcardslot = item_info.item_data.base.maxcardslot
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.ishint ~= nil )then
			msg.item_info.item_data.base.ishint = item_info.item_data.base.ishint
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.isactive ~= nil )then
			msg.item_info.item_data.base.isactive = item_info.item_data.base.isactive
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.source_npc ~= nil )then
			msg.item_info.item_data.base.source_npc = item_info.item_data.base.source_npc
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.refinelv ~= nil )then
			msg.item_info.item_data.base.refinelv = item_info.item_data.base.refinelv
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.chargemoney ~= nil )then
			msg.item_info.item_data.base.chargemoney = item_info.item_data.base.chargemoney
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.overtime ~= nil )then
			msg.item_info.item_data.base.overtime = item_info.item_data.base.overtime
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.quota ~= nil )then
			msg.item_info.item_data.base.quota = item_info.item_data.base.quota
		end
	end
	if(item_info.item_data ~= nil )then
		if(item_info.item_data.equiped ~= nil )then
			msg.item_info.item_data.equiped = item_info.item_data.equiped
		end
	end
	if(item_info.item_data ~= nil )then
		if(item_info.item_data.battlepoint ~= nil )then
			msg.item_info.item_data.battlepoint = item_info.item_data.battlepoint
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthlv ~= nil )then
			msg.item_info.item_data.equip.strengthlv = item_info.item_data.equip.strengthlv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.refinelv ~= nil )then
			msg.item_info.item_data.equip.refinelv = item_info.item_data.equip.refinelv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthCost ~= nil )then
			msg.item_info.item_data.equip.strengthCost = item_info.item_data.equip.strengthCost
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.refineCompose ~= nil )then
			for i=1,#item_info.item_data.equip.refineCompose do 
				table.insert(msg.item_info.item_data.equip.refineCompose, item_info.item_data.equip.refineCompose[i])
			end
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.cardslot ~= nil )then
			msg.item_info.item_data.equip.cardslot = item_info.item_data.equip.cardslot
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.buffid ~= nil )then
			for i=1,#item_info.item_data.equip.buffid do 
				table.insert(msg.item_info.item_data.equip.buffid, item_info.item_data.equip.buffid[i])
			end
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.damage ~= nil )then
			msg.item_info.item_data.equip.damage = item_info.item_data.equip.damage
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.lv ~= nil )then
			msg.item_info.item_data.equip.lv = item_info.item_data.equip.lv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.color ~= nil )then
			msg.item_info.item_data.equip.color = item_info.item_data.equip.color
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.breakstarttime ~= nil )then
			msg.item_info.item_data.equip.breakstarttime = item_info.item_data.equip.breakstarttime
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.breakendtime ~= nil )then
			msg.item_info.item_data.equip.breakendtime = item_info.item_data.equip.breakendtime
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthlv2 ~= nil )then
			msg.item_info.item_data.equip.strengthlv2 = item_info.item_data.equip.strengthlv2
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.strengthlv2cost ~= nil )then
			for i=1,#item_info.item_data.equip.strengthlv2cost do 
				table.insert(msg.item_info.item_data.equip.strengthlv2cost, item_info.item_data.equip.strengthlv2cost[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.card ~= nil )then
			for i=1,#item_info.item_data.card do 
				table.insert(msg.item_info.item_data.card, item_info.item_data.card[i])
			end
		end
	end
	if(item_info.item_data.enchant ~= nil )then
		if(item_info.item_data.enchant.type ~= nil )then
			msg.item_info.item_data.enchant.type = item_info.item_data.enchant.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.attrs ~= nil )then
			for i=1,#item_info.item_data.enchant.attrs do 
				table.insert(msg.item_info.item_data.enchant.attrs, item_info.item_data.enchant.attrs[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.extras ~= nil )then
			for i=1,#item_info.item_data.enchant.extras do 
				table.insert(msg.item_info.item_data.enchant.extras, item_info.item_data.enchant.extras[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.patch ~= nil )then
			for i=1,#item_info.item_data.enchant.patch do 
				table.insert(msg.item_info.item_data.enchant.patch, item_info.item_data.enchant.patch[i])
			end
		end
	end
	if(item_info.item_data.previewenchant ~= nil )then
		if(item_info.item_data.previewenchant.type ~= nil )then
			msg.item_info.item_data.previewenchant.type = item_info.item_data.previewenchant.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.attrs ~= nil )then
			for i=1,#item_info.item_data.previewenchant.attrs do 
				table.insert(msg.item_info.item_data.previewenchant.attrs, item_info.item_data.previewenchant.attrs[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.extras ~= nil )then
			for i=1,#item_info.item_data.previewenchant.extras do 
				table.insert(msg.item_info.item_data.previewenchant.extras, item_info.item_data.previewenchant.extras[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.patch ~= nil )then
			for i=1,#item_info.item_data.previewenchant.patch do 
				table.insert(msg.item_info.item_data.previewenchant.patch, item_info.item_data.previewenchant.patch[i])
			end
		end
	end
	if(item_info.item_data.refine ~= nil )then
		if(item_info.item_data.refine.lastfail ~= nil )then
			msg.item_info.item_data.refine.lastfail = item_info.item_data.refine.lastfail
		end
	end
	if(item_info.item_data.refine ~= nil )then
		if(item_info.item_data.refine.repaircount ~= nil )then
			msg.item_info.item_data.refine.repaircount = item_info.item_data.refine.repaircount
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.exp ~= nil )then
			msg.item_info.item_data.egg.exp = item_info.item_data.egg.exp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.friendexp ~= nil )then
			msg.item_info.item_data.egg.friendexp = item_info.item_data.egg.friendexp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.rewardexp ~= nil )then
			msg.item_info.item_data.egg.rewardexp = item_info.item_data.egg.rewardexp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.id ~= nil )then
			msg.item_info.item_data.egg.id = item_info.item_data.egg.id
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.lv ~= nil )then
			msg.item_info.item_data.egg.lv = item_info.item_data.egg.lv
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.friendlv ~= nil )then
			msg.item_info.item_data.egg.friendlv = item_info.item_data.egg.friendlv
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.body ~= nil )then
			msg.item_info.item_data.egg.body = item_info.item_data.egg.body
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.relivetime ~= nil )then
			msg.item_info.item_data.egg.relivetime = item_info.item_data.egg.relivetime
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.hp ~= nil )then
			msg.item_info.item_data.egg.hp = item_info.item_data.egg.hp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.restoretime ~= nil )then
			msg.item_info.item_data.egg.restoretime = item_info.item_data.egg.restoretime
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happly ~= nil )then
			msg.item_info.item_data.egg.time_happly = item_info.item_data.egg.time_happly
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_excite ~= nil )then
			msg.item_info.item_data.egg.time_excite = item_info.item_data.egg.time_excite
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happiness ~= nil )then
			msg.item_info.item_data.egg.time_happiness = item_info.item_data.egg.time_happiness
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happly_gift ~= nil )then
			msg.item_info.item_data.egg.time_happly_gift = item_info.item_data.egg.time_happly_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_excite_gift ~= nil )then
			msg.item_info.item_data.egg.time_excite_gift = item_info.item_data.egg.time_excite_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happiness_gift ~= nil )then
			msg.item_info.item_data.egg.time_happiness_gift = item_info.item_data.egg.time_happiness_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.touch_tick ~= nil )then
			msg.item_info.item_data.egg.touch_tick = item_info.item_data.egg.touch_tick
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.feed_tick ~= nil )then
			msg.item_info.item_data.egg.feed_tick = item_info.item_data.egg.feed_tick
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.name ~= nil )then
			msg.item_info.item_data.egg.name = item_info.item_data.egg.name
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.var ~= nil )then
			msg.item_info.item_data.egg.var = item_info.item_data.egg.var
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.skillids ~= nil )then
			for i=1,#item_info.item_data.egg.skillids do 
				table.insert(msg.item_info.item_data.egg.skillids, item_info.item_data.egg.skillids[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.equips ~= nil )then
			for i=1,#item_info.item_data.egg.equips do 
				table.insert(msg.item_info.item_data.egg.equips, item_info.item_data.egg.equips[i])
			end
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.buff ~= nil )then
			msg.item_info.item_data.egg.buff = item_info.item_data.egg.buff
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.unlock_equip ~= nil )then
			for i=1,#item_info.item_data.egg.unlock_equip do 
				table.insert(msg.item_info.item_data.egg.unlock_equip, item_info.item_data.egg.unlock_equip[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.unlock_body ~= nil )then
			for i=1,#item_info.item_data.egg.unlock_body do 
				table.insert(msg.item_info.item_data.egg.unlock_body, item_info.item_data.egg.unlock_body[i])
			end
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.version ~= nil )then
			msg.item_info.item_data.egg.version = item_info.item_data.egg.version
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.skilloff ~= nil )then
			msg.item_info.item_data.egg.skilloff = item_info.item_data.egg.skilloff
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.exchange_count ~= nil )then
			msg.item_info.item_data.egg.exchange_count = item_info.item_data.egg.exchange_count
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.guid ~= nil )then
			msg.item_info.item_data.egg.guid = item_info.item_data.egg.guid
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.sendUserName ~= nil )then
			msg.item_info.item_data.letter.sendUserName = item_info.item_data.letter.sendUserName
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.bg ~= nil )then
			msg.item_info.item_data.letter.bg = item_info.item_data.letter.bg
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.configID ~= nil )then
			msg.item_info.item_data.letter.configID = item_info.item_data.letter.configID
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.content ~= nil )then
			msg.item_info.item_data.letter.content = item_info.item_data.letter.content
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.content2 ~= nil )then
			msg.item_info.item_data.letter.content2 = item_info.item_data.letter.content2
		end
	end
	if(item_info.item_data.code ~= nil )then
		if(item_info.item_data.code.code ~= nil )then
			msg.item_info.item_data.code.code = item_info.item_data.code.code
		end
	end
	if(item_info.item_data.code ~= nil )then
		if(item_info.item_data.code.used ~= nil )then
			msg.item_info.item_data.code.used = item_info.item_data.code.used
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.id ~= nil )then
			msg.item_info.item_data.wedding.id = item_info.item_data.wedding.id
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.zoneid ~= nil )then
			msg.item_info.item_data.wedding.zoneid = item_info.item_data.wedding.zoneid
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.charid1 ~= nil )then
			msg.item_info.item_data.wedding.charid1 = item_info.item_data.wedding.charid1
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.charid2 ~= nil )then
			msg.item_info.item_data.wedding.charid2 = item_info.item_data.wedding.charid2
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.weddingtime ~= nil )then
			msg.item_info.item_data.wedding.weddingtime = item_info.item_data.wedding.weddingtime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.photoidx ~= nil )then
			msg.item_info.item_data.wedding.photoidx = item_info.item_data.wedding.photoidx
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.phototime ~= nil )then
			msg.item_info.item_data.wedding.phototime = item_info.item_data.wedding.phototime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.myname ~= nil )then
			msg.item_info.item_data.wedding.myname = item_info.item_data.wedding.myname
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.partnername ~= nil )then
			msg.item_info.item_data.wedding.partnername = item_info.item_data.wedding.partnername
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.starttime ~= nil )then
			msg.item_info.item_data.wedding.starttime = item_info.item_data.wedding.starttime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.endtime ~= nil )then
			msg.item_info.item_data.wedding.endtime = item_info.item_data.wedding.endtime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.notified ~= nil )then
			msg.item_info.item_data.wedding.notified = item_info.item_data.wedding.notified
		end
	end
	if(item_info.item_data.sender ~= nil )then
		if(item_info.item_data.sender.charid ~= nil )then
			msg.item_info.item_data.sender.charid = item_info.item_data.sender.charid
		end
	end
	if(item_info.item_data.sender ~= nil )then
		if(item_info.item_data.sender.name ~= nil )then
			msg.item_info.item_data.sender.name = item_info.item_data.sender.name
		end
	end
	if(item_info ~= nil )then
		if(item_info.publicity_id ~= nil )then
			msg.item_info.publicity_id = item_info.publicity_id
		end
	end
	if(item_info ~= nil )then
		if(item_info.end_time ~= nil )then
			msg.item_info.end_time = item_info.end_time
		end
	end
	if(item_info ~= nil )then
		if(item_info.key ~= nil )then
			msg.item_info.key = item_info.key
		end
	end
	if(item_info ~= nil )then
		if(item_info.charid ~= nil )then
			msg.item_info.charid = item_info.charid
		end
	end
	if(item_info ~= nil )then
		if(item_info.name ~= nil )then
			msg.item_info.name = item_info.name
		end
	end
	if(item_info ~= nil )then
		if(item_info.type ~= nil )then
			msg.item_info.type = item_info.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.up_rate ~= nil )then
			msg.item_info.up_rate = item_info.up_rate
		end
	end
	if(item_info ~= nil )then
		if(item_info.down_rate ~= nil )then
			msg.item_info.down_rate = item_info.down_rate
		end
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	if(type ~= nil )then
		msg.type = type
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallSellItemRecordTradeCmd(item_info, charid, ret, type) 
	local msg = RecordTrade_pb.SellItemRecordTradeCmd()
	if(item_info ~= nil )then
		if(item_info.itemid ~= nil )then
			msg.item_info.itemid = item_info.itemid
		end
	end
	if(item_info ~= nil )then
		if(item_info.price ~= nil )then
			msg.item_info.price = item_info.price
		end
	end
	if(item_info ~= nil )then
		if(item_info.count ~= nil )then
			msg.item_info.count = item_info.count
		end
	end
	if(item_info ~= nil )then
		if(item_info.guid ~= nil )then
			msg.item_info.guid = item_info.guid
		end
	end
	if(item_info ~= nil )then
		if(item_info.order_id ~= nil )then
			msg.item_info.order_id = item_info.order_id
		end
	end
	if(item_info ~= nil )then
		if(item_info.refine_lv ~= nil )then
			msg.item_info.refine_lv = item_info.refine_lv
		end
	end
	if(item_info ~= nil )then
		if(item_info.overlap ~= nil )then
			msg.item_info.overlap = item_info.overlap
		end
	end
	if(item_info ~= nil )then
		if(item_info.is_expired ~= nil )then
			msg.item_info.is_expired = item_info.is_expired
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.guid ~= nil )then
			msg.item_info.item_data.base.guid = item_info.item_data.base.guid
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.id ~= nil )then
			msg.item_info.item_data.base.id = item_info.item_data.base.id
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.count ~= nil )then
			msg.item_info.item_data.base.count = item_info.item_data.base.count
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.index ~= nil )then
			msg.item_info.item_data.base.index = item_info.item_data.base.index
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.createtime ~= nil )then
			msg.item_info.item_data.base.createtime = item_info.item_data.base.createtime
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.cd ~= nil )then
			msg.item_info.item_data.base.cd = item_info.item_data.base.cd
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.type ~= nil )then
			msg.item_info.item_data.base.type = item_info.item_data.base.type
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.bind ~= nil )then
			msg.item_info.item_data.base.bind = item_info.item_data.base.bind
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.expire ~= nil )then
			msg.item_info.item_data.base.expire = item_info.item_data.base.expire
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.quality ~= nil )then
			msg.item_info.item_data.base.quality = item_info.item_data.base.quality
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.equipType ~= nil )then
			msg.item_info.item_data.base.equipType = item_info.item_data.base.equipType
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.source ~= nil )then
			msg.item_info.item_data.base.source = item_info.item_data.base.source
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.isnew ~= nil )then
			msg.item_info.item_data.base.isnew = item_info.item_data.base.isnew
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.maxcardslot ~= nil )then
			msg.item_info.item_data.base.maxcardslot = item_info.item_data.base.maxcardslot
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.ishint ~= nil )then
			msg.item_info.item_data.base.ishint = item_info.item_data.base.ishint
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.isactive ~= nil )then
			msg.item_info.item_data.base.isactive = item_info.item_data.base.isactive
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.source_npc ~= nil )then
			msg.item_info.item_data.base.source_npc = item_info.item_data.base.source_npc
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.refinelv ~= nil )then
			msg.item_info.item_data.base.refinelv = item_info.item_data.base.refinelv
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.chargemoney ~= nil )then
			msg.item_info.item_data.base.chargemoney = item_info.item_data.base.chargemoney
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.overtime ~= nil )then
			msg.item_info.item_data.base.overtime = item_info.item_data.base.overtime
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.quota ~= nil )then
			msg.item_info.item_data.base.quota = item_info.item_data.base.quota
		end
	end
	if(item_info.item_data ~= nil )then
		if(item_info.item_data.equiped ~= nil )then
			msg.item_info.item_data.equiped = item_info.item_data.equiped
		end
	end
	if(item_info.item_data ~= nil )then
		if(item_info.item_data.battlepoint ~= nil )then
			msg.item_info.item_data.battlepoint = item_info.item_data.battlepoint
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthlv ~= nil )then
			msg.item_info.item_data.equip.strengthlv = item_info.item_data.equip.strengthlv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.refinelv ~= nil )then
			msg.item_info.item_data.equip.refinelv = item_info.item_data.equip.refinelv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthCost ~= nil )then
			msg.item_info.item_data.equip.strengthCost = item_info.item_data.equip.strengthCost
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.refineCompose ~= nil )then
			for i=1,#item_info.item_data.equip.refineCompose do 
				table.insert(msg.item_info.item_data.equip.refineCompose, item_info.item_data.equip.refineCompose[i])
			end
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.cardslot ~= nil )then
			msg.item_info.item_data.equip.cardslot = item_info.item_data.equip.cardslot
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.buffid ~= nil )then
			for i=1,#item_info.item_data.equip.buffid do 
				table.insert(msg.item_info.item_data.equip.buffid, item_info.item_data.equip.buffid[i])
			end
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.damage ~= nil )then
			msg.item_info.item_data.equip.damage = item_info.item_data.equip.damage
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.lv ~= nil )then
			msg.item_info.item_data.equip.lv = item_info.item_data.equip.lv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.color ~= nil )then
			msg.item_info.item_data.equip.color = item_info.item_data.equip.color
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.breakstarttime ~= nil )then
			msg.item_info.item_data.equip.breakstarttime = item_info.item_data.equip.breakstarttime
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.breakendtime ~= nil )then
			msg.item_info.item_data.equip.breakendtime = item_info.item_data.equip.breakendtime
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthlv2 ~= nil )then
			msg.item_info.item_data.equip.strengthlv2 = item_info.item_data.equip.strengthlv2
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.strengthlv2cost ~= nil )then
			for i=1,#item_info.item_data.equip.strengthlv2cost do 
				table.insert(msg.item_info.item_data.equip.strengthlv2cost, item_info.item_data.equip.strengthlv2cost[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.card ~= nil )then
			for i=1,#item_info.item_data.card do 
				table.insert(msg.item_info.item_data.card, item_info.item_data.card[i])
			end
		end
	end
	if(item_info.item_data.enchant ~= nil )then
		if(item_info.item_data.enchant.type ~= nil )then
			msg.item_info.item_data.enchant.type = item_info.item_data.enchant.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.attrs ~= nil )then
			for i=1,#item_info.item_data.enchant.attrs do 
				table.insert(msg.item_info.item_data.enchant.attrs, item_info.item_data.enchant.attrs[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.extras ~= nil )then
			for i=1,#item_info.item_data.enchant.extras do 
				table.insert(msg.item_info.item_data.enchant.extras, item_info.item_data.enchant.extras[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.patch ~= nil )then
			for i=1,#item_info.item_data.enchant.patch do 
				table.insert(msg.item_info.item_data.enchant.patch, item_info.item_data.enchant.patch[i])
			end
		end
	end
	if(item_info.item_data.previewenchant ~= nil )then
		if(item_info.item_data.previewenchant.type ~= nil )then
			msg.item_info.item_data.previewenchant.type = item_info.item_data.previewenchant.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.attrs ~= nil )then
			for i=1,#item_info.item_data.previewenchant.attrs do 
				table.insert(msg.item_info.item_data.previewenchant.attrs, item_info.item_data.previewenchant.attrs[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.extras ~= nil )then
			for i=1,#item_info.item_data.previewenchant.extras do 
				table.insert(msg.item_info.item_data.previewenchant.extras, item_info.item_data.previewenchant.extras[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.patch ~= nil )then
			for i=1,#item_info.item_data.previewenchant.patch do 
				table.insert(msg.item_info.item_data.previewenchant.patch, item_info.item_data.previewenchant.patch[i])
			end
		end
	end
	if(item_info.item_data.refine ~= nil )then
		if(item_info.item_data.refine.lastfail ~= nil )then
			msg.item_info.item_data.refine.lastfail = item_info.item_data.refine.lastfail
		end
	end
	if(item_info.item_data.refine ~= nil )then
		if(item_info.item_data.refine.repaircount ~= nil )then
			msg.item_info.item_data.refine.repaircount = item_info.item_data.refine.repaircount
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.exp ~= nil )then
			msg.item_info.item_data.egg.exp = item_info.item_data.egg.exp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.friendexp ~= nil )then
			msg.item_info.item_data.egg.friendexp = item_info.item_data.egg.friendexp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.rewardexp ~= nil )then
			msg.item_info.item_data.egg.rewardexp = item_info.item_data.egg.rewardexp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.id ~= nil )then
			msg.item_info.item_data.egg.id = item_info.item_data.egg.id
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.lv ~= nil )then
			msg.item_info.item_data.egg.lv = item_info.item_data.egg.lv
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.friendlv ~= nil )then
			msg.item_info.item_data.egg.friendlv = item_info.item_data.egg.friendlv
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.body ~= nil )then
			msg.item_info.item_data.egg.body = item_info.item_data.egg.body
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.relivetime ~= nil )then
			msg.item_info.item_data.egg.relivetime = item_info.item_data.egg.relivetime
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.hp ~= nil )then
			msg.item_info.item_data.egg.hp = item_info.item_data.egg.hp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.restoretime ~= nil )then
			msg.item_info.item_data.egg.restoretime = item_info.item_data.egg.restoretime
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happly ~= nil )then
			msg.item_info.item_data.egg.time_happly = item_info.item_data.egg.time_happly
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_excite ~= nil )then
			msg.item_info.item_data.egg.time_excite = item_info.item_data.egg.time_excite
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happiness ~= nil )then
			msg.item_info.item_data.egg.time_happiness = item_info.item_data.egg.time_happiness
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happly_gift ~= nil )then
			msg.item_info.item_data.egg.time_happly_gift = item_info.item_data.egg.time_happly_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_excite_gift ~= nil )then
			msg.item_info.item_data.egg.time_excite_gift = item_info.item_data.egg.time_excite_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happiness_gift ~= nil )then
			msg.item_info.item_data.egg.time_happiness_gift = item_info.item_data.egg.time_happiness_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.touch_tick ~= nil )then
			msg.item_info.item_data.egg.touch_tick = item_info.item_data.egg.touch_tick
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.feed_tick ~= nil )then
			msg.item_info.item_data.egg.feed_tick = item_info.item_data.egg.feed_tick
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.name ~= nil )then
			msg.item_info.item_data.egg.name = item_info.item_data.egg.name
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.var ~= nil )then
			msg.item_info.item_data.egg.var = item_info.item_data.egg.var
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.skillids ~= nil )then
			for i=1,#item_info.item_data.egg.skillids do 
				table.insert(msg.item_info.item_data.egg.skillids, item_info.item_data.egg.skillids[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.equips ~= nil )then
			for i=1,#item_info.item_data.egg.equips do 
				table.insert(msg.item_info.item_data.egg.equips, item_info.item_data.egg.equips[i])
			end
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.buff ~= nil )then
			msg.item_info.item_data.egg.buff = item_info.item_data.egg.buff
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.unlock_equip ~= nil )then
			for i=1,#item_info.item_data.egg.unlock_equip do 
				table.insert(msg.item_info.item_data.egg.unlock_equip, item_info.item_data.egg.unlock_equip[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.unlock_body ~= nil )then
			for i=1,#item_info.item_data.egg.unlock_body do 
				table.insert(msg.item_info.item_data.egg.unlock_body, item_info.item_data.egg.unlock_body[i])
			end
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.version ~= nil )then
			msg.item_info.item_data.egg.version = item_info.item_data.egg.version
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.skilloff ~= nil )then
			msg.item_info.item_data.egg.skilloff = item_info.item_data.egg.skilloff
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.exchange_count ~= nil )then
			msg.item_info.item_data.egg.exchange_count = item_info.item_data.egg.exchange_count
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.guid ~= nil )then
			msg.item_info.item_data.egg.guid = item_info.item_data.egg.guid
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.sendUserName ~= nil )then
			msg.item_info.item_data.letter.sendUserName = item_info.item_data.letter.sendUserName
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.bg ~= nil )then
			msg.item_info.item_data.letter.bg = item_info.item_data.letter.bg
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.configID ~= nil )then
			msg.item_info.item_data.letter.configID = item_info.item_data.letter.configID
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.content ~= nil )then
			msg.item_info.item_data.letter.content = item_info.item_data.letter.content
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.content2 ~= nil )then
			msg.item_info.item_data.letter.content2 = item_info.item_data.letter.content2
		end
	end
	if(item_info.item_data.code ~= nil )then
		if(item_info.item_data.code.code ~= nil )then
			msg.item_info.item_data.code.code = item_info.item_data.code.code
		end
	end
	if(item_info.item_data.code ~= nil )then
		if(item_info.item_data.code.used ~= nil )then
			msg.item_info.item_data.code.used = item_info.item_data.code.used
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.id ~= nil )then
			msg.item_info.item_data.wedding.id = item_info.item_data.wedding.id
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.zoneid ~= nil )then
			msg.item_info.item_data.wedding.zoneid = item_info.item_data.wedding.zoneid
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.charid1 ~= nil )then
			msg.item_info.item_data.wedding.charid1 = item_info.item_data.wedding.charid1
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.charid2 ~= nil )then
			msg.item_info.item_data.wedding.charid2 = item_info.item_data.wedding.charid2
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.weddingtime ~= nil )then
			msg.item_info.item_data.wedding.weddingtime = item_info.item_data.wedding.weddingtime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.photoidx ~= nil )then
			msg.item_info.item_data.wedding.photoidx = item_info.item_data.wedding.photoidx
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.phototime ~= nil )then
			msg.item_info.item_data.wedding.phototime = item_info.item_data.wedding.phototime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.myname ~= nil )then
			msg.item_info.item_data.wedding.myname = item_info.item_data.wedding.myname
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.partnername ~= nil )then
			msg.item_info.item_data.wedding.partnername = item_info.item_data.wedding.partnername
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.starttime ~= nil )then
			msg.item_info.item_data.wedding.starttime = item_info.item_data.wedding.starttime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.endtime ~= nil )then
			msg.item_info.item_data.wedding.endtime = item_info.item_data.wedding.endtime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.notified ~= nil )then
			msg.item_info.item_data.wedding.notified = item_info.item_data.wedding.notified
		end
	end
	if(item_info.item_data.sender ~= nil )then
		if(item_info.item_data.sender.charid ~= nil )then
			msg.item_info.item_data.sender.charid = item_info.item_data.sender.charid
		end
	end
	if(item_info.item_data.sender ~= nil )then
		if(item_info.item_data.sender.name ~= nil )then
			msg.item_info.item_data.sender.name = item_info.item_data.sender.name
		end
	end
	if(item_info ~= nil )then
		if(item_info.publicity_id ~= nil )then
			msg.item_info.publicity_id = item_info.publicity_id
		end
	end
	if(item_info ~= nil )then
		if(item_info.end_time ~= nil )then
			msg.item_info.end_time = item_info.end_time
		end
	end
	if(item_info ~= nil )then
		if(item_info.key ~= nil )then
			msg.item_info.key = item_info.key
		end
	end
	if(item_info ~= nil )then
		if(item_info.charid ~= nil )then
			msg.item_info.charid = item_info.charid
		end
	end
	if(item_info ~= nil )then
		if(item_info.name ~= nil )then
			msg.item_info.name = item_info.name
		end
	end
	if(item_info ~= nil )then
		if(item_info.type ~= nil )then
			msg.item_info.type = item_info.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.up_rate ~= nil )then
			msg.item_info.up_rate = item_info.up_rate
		end
	end
	if(item_info ~= nil )then
		if(item_info.down_rate ~= nil )then
			msg.item_info.down_rate = item_info.down_rate
		end
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	if(type ~= nil )then
		msg.type = type
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallCancelItemRecordTrade(item_info, charid, ret, order_id, type, quota) 
	local msg = RecordTrade_pb.CancelItemRecordTrade()
	if(item_info ~= nil )then
		if(item_info.itemid ~= nil )then
			msg.item_info.itemid = item_info.itemid
		end
	end
	if(item_info ~= nil )then
		if(item_info.price ~= nil )then
			msg.item_info.price = item_info.price
		end
	end
	if(item_info ~= nil )then
		if(item_info.count ~= nil )then
			msg.item_info.count = item_info.count
		end
	end
	if(item_info ~= nil )then
		if(item_info.guid ~= nil )then
			msg.item_info.guid = item_info.guid
		end
	end
	if(item_info ~= nil )then
		if(item_info.order_id ~= nil )then
			msg.item_info.order_id = item_info.order_id
		end
	end
	if(item_info ~= nil )then
		if(item_info.refine_lv ~= nil )then
			msg.item_info.refine_lv = item_info.refine_lv
		end
	end
	if(item_info ~= nil )then
		if(item_info.overlap ~= nil )then
			msg.item_info.overlap = item_info.overlap
		end
	end
	if(item_info ~= nil )then
		if(item_info.is_expired ~= nil )then
			msg.item_info.is_expired = item_info.is_expired
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.guid ~= nil )then
			msg.item_info.item_data.base.guid = item_info.item_data.base.guid
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.id ~= nil )then
			msg.item_info.item_data.base.id = item_info.item_data.base.id
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.count ~= nil )then
			msg.item_info.item_data.base.count = item_info.item_data.base.count
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.index ~= nil )then
			msg.item_info.item_data.base.index = item_info.item_data.base.index
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.createtime ~= nil )then
			msg.item_info.item_data.base.createtime = item_info.item_data.base.createtime
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.cd ~= nil )then
			msg.item_info.item_data.base.cd = item_info.item_data.base.cd
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.type ~= nil )then
			msg.item_info.item_data.base.type = item_info.item_data.base.type
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.bind ~= nil )then
			msg.item_info.item_data.base.bind = item_info.item_data.base.bind
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.expire ~= nil )then
			msg.item_info.item_data.base.expire = item_info.item_data.base.expire
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.quality ~= nil )then
			msg.item_info.item_data.base.quality = item_info.item_data.base.quality
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.equipType ~= nil )then
			msg.item_info.item_data.base.equipType = item_info.item_data.base.equipType
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.source ~= nil )then
			msg.item_info.item_data.base.source = item_info.item_data.base.source
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.isnew ~= nil )then
			msg.item_info.item_data.base.isnew = item_info.item_data.base.isnew
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.maxcardslot ~= nil )then
			msg.item_info.item_data.base.maxcardslot = item_info.item_data.base.maxcardslot
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.ishint ~= nil )then
			msg.item_info.item_data.base.ishint = item_info.item_data.base.ishint
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.isactive ~= nil )then
			msg.item_info.item_data.base.isactive = item_info.item_data.base.isactive
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.source_npc ~= nil )then
			msg.item_info.item_data.base.source_npc = item_info.item_data.base.source_npc
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.refinelv ~= nil )then
			msg.item_info.item_data.base.refinelv = item_info.item_data.base.refinelv
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.chargemoney ~= nil )then
			msg.item_info.item_data.base.chargemoney = item_info.item_data.base.chargemoney
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.overtime ~= nil )then
			msg.item_info.item_data.base.overtime = item_info.item_data.base.overtime
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.quota ~= nil )then
			msg.item_info.item_data.base.quota = item_info.item_data.base.quota
		end
	end
	if(item_info.item_data ~= nil )then
		if(item_info.item_data.equiped ~= nil )then
			msg.item_info.item_data.equiped = item_info.item_data.equiped
		end
	end
	if(item_info.item_data ~= nil )then
		if(item_info.item_data.battlepoint ~= nil )then
			msg.item_info.item_data.battlepoint = item_info.item_data.battlepoint
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthlv ~= nil )then
			msg.item_info.item_data.equip.strengthlv = item_info.item_data.equip.strengthlv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.refinelv ~= nil )then
			msg.item_info.item_data.equip.refinelv = item_info.item_data.equip.refinelv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthCost ~= nil )then
			msg.item_info.item_data.equip.strengthCost = item_info.item_data.equip.strengthCost
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.refineCompose ~= nil )then
			for i=1,#item_info.item_data.equip.refineCompose do 
				table.insert(msg.item_info.item_data.equip.refineCompose, item_info.item_data.equip.refineCompose[i])
			end
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.cardslot ~= nil )then
			msg.item_info.item_data.equip.cardslot = item_info.item_data.equip.cardslot
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.buffid ~= nil )then
			for i=1,#item_info.item_data.equip.buffid do 
				table.insert(msg.item_info.item_data.equip.buffid, item_info.item_data.equip.buffid[i])
			end
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.damage ~= nil )then
			msg.item_info.item_data.equip.damage = item_info.item_data.equip.damage
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.lv ~= nil )then
			msg.item_info.item_data.equip.lv = item_info.item_data.equip.lv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.color ~= nil )then
			msg.item_info.item_data.equip.color = item_info.item_data.equip.color
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.breakstarttime ~= nil )then
			msg.item_info.item_data.equip.breakstarttime = item_info.item_data.equip.breakstarttime
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.breakendtime ~= nil )then
			msg.item_info.item_data.equip.breakendtime = item_info.item_data.equip.breakendtime
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthlv2 ~= nil )then
			msg.item_info.item_data.equip.strengthlv2 = item_info.item_data.equip.strengthlv2
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.strengthlv2cost ~= nil )then
			for i=1,#item_info.item_data.equip.strengthlv2cost do 
				table.insert(msg.item_info.item_data.equip.strengthlv2cost, item_info.item_data.equip.strengthlv2cost[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.card ~= nil )then
			for i=1,#item_info.item_data.card do 
				table.insert(msg.item_info.item_data.card, item_info.item_data.card[i])
			end
		end
	end
	if(item_info.item_data.enchant ~= nil )then
		if(item_info.item_data.enchant.type ~= nil )then
			msg.item_info.item_data.enchant.type = item_info.item_data.enchant.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.attrs ~= nil )then
			for i=1,#item_info.item_data.enchant.attrs do 
				table.insert(msg.item_info.item_data.enchant.attrs, item_info.item_data.enchant.attrs[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.extras ~= nil )then
			for i=1,#item_info.item_data.enchant.extras do 
				table.insert(msg.item_info.item_data.enchant.extras, item_info.item_data.enchant.extras[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.patch ~= nil )then
			for i=1,#item_info.item_data.enchant.patch do 
				table.insert(msg.item_info.item_data.enchant.patch, item_info.item_data.enchant.patch[i])
			end
		end
	end
	if(item_info.item_data.previewenchant ~= nil )then
		if(item_info.item_data.previewenchant.type ~= nil )then
			msg.item_info.item_data.previewenchant.type = item_info.item_data.previewenchant.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.attrs ~= nil )then
			for i=1,#item_info.item_data.previewenchant.attrs do 
				table.insert(msg.item_info.item_data.previewenchant.attrs, item_info.item_data.previewenchant.attrs[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.extras ~= nil )then
			for i=1,#item_info.item_data.previewenchant.extras do 
				table.insert(msg.item_info.item_data.previewenchant.extras, item_info.item_data.previewenchant.extras[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.patch ~= nil )then
			for i=1,#item_info.item_data.previewenchant.patch do 
				table.insert(msg.item_info.item_data.previewenchant.patch, item_info.item_data.previewenchant.patch[i])
			end
		end
	end
	if(item_info.item_data.refine ~= nil )then
		if(item_info.item_data.refine.lastfail ~= nil )then
			msg.item_info.item_data.refine.lastfail = item_info.item_data.refine.lastfail
		end
	end
	if(item_info.item_data.refine ~= nil )then
		if(item_info.item_data.refine.repaircount ~= nil )then
			msg.item_info.item_data.refine.repaircount = item_info.item_data.refine.repaircount
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.exp ~= nil )then
			msg.item_info.item_data.egg.exp = item_info.item_data.egg.exp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.friendexp ~= nil )then
			msg.item_info.item_data.egg.friendexp = item_info.item_data.egg.friendexp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.rewardexp ~= nil )then
			msg.item_info.item_data.egg.rewardexp = item_info.item_data.egg.rewardexp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.id ~= nil )then
			msg.item_info.item_data.egg.id = item_info.item_data.egg.id
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.lv ~= nil )then
			msg.item_info.item_data.egg.lv = item_info.item_data.egg.lv
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.friendlv ~= nil )then
			msg.item_info.item_data.egg.friendlv = item_info.item_data.egg.friendlv
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.body ~= nil )then
			msg.item_info.item_data.egg.body = item_info.item_data.egg.body
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.relivetime ~= nil )then
			msg.item_info.item_data.egg.relivetime = item_info.item_data.egg.relivetime
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.hp ~= nil )then
			msg.item_info.item_data.egg.hp = item_info.item_data.egg.hp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.restoretime ~= nil )then
			msg.item_info.item_data.egg.restoretime = item_info.item_data.egg.restoretime
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happly ~= nil )then
			msg.item_info.item_data.egg.time_happly = item_info.item_data.egg.time_happly
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_excite ~= nil )then
			msg.item_info.item_data.egg.time_excite = item_info.item_data.egg.time_excite
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happiness ~= nil )then
			msg.item_info.item_data.egg.time_happiness = item_info.item_data.egg.time_happiness
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happly_gift ~= nil )then
			msg.item_info.item_data.egg.time_happly_gift = item_info.item_data.egg.time_happly_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_excite_gift ~= nil )then
			msg.item_info.item_data.egg.time_excite_gift = item_info.item_data.egg.time_excite_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happiness_gift ~= nil )then
			msg.item_info.item_data.egg.time_happiness_gift = item_info.item_data.egg.time_happiness_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.touch_tick ~= nil )then
			msg.item_info.item_data.egg.touch_tick = item_info.item_data.egg.touch_tick
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.feed_tick ~= nil )then
			msg.item_info.item_data.egg.feed_tick = item_info.item_data.egg.feed_tick
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.name ~= nil )then
			msg.item_info.item_data.egg.name = item_info.item_data.egg.name
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.var ~= nil )then
			msg.item_info.item_data.egg.var = item_info.item_data.egg.var
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.skillids ~= nil )then
			for i=1,#item_info.item_data.egg.skillids do 
				table.insert(msg.item_info.item_data.egg.skillids, item_info.item_data.egg.skillids[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.equips ~= nil )then
			for i=1,#item_info.item_data.egg.equips do 
				table.insert(msg.item_info.item_data.egg.equips, item_info.item_data.egg.equips[i])
			end
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.buff ~= nil )then
			msg.item_info.item_data.egg.buff = item_info.item_data.egg.buff
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.unlock_equip ~= nil )then
			for i=1,#item_info.item_data.egg.unlock_equip do 
				table.insert(msg.item_info.item_data.egg.unlock_equip, item_info.item_data.egg.unlock_equip[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.unlock_body ~= nil )then
			for i=1,#item_info.item_data.egg.unlock_body do 
				table.insert(msg.item_info.item_data.egg.unlock_body, item_info.item_data.egg.unlock_body[i])
			end
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.version ~= nil )then
			msg.item_info.item_data.egg.version = item_info.item_data.egg.version
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.skilloff ~= nil )then
			msg.item_info.item_data.egg.skilloff = item_info.item_data.egg.skilloff
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.exchange_count ~= nil )then
			msg.item_info.item_data.egg.exchange_count = item_info.item_data.egg.exchange_count
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.guid ~= nil )then
			msg.item_info.item_data.egg.guid = item_info.item_data.egg.guid
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.sendUserName ~= nil )then
			msg.item_info.item_data.letter.sendUserName = item_info.item_data.letter.sendUserName
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.bg ~= nil )then
			msg.item_info.item_data.letter.bg = item_info.item_data.letter.bg
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.configID ~= nil )then
			msg.item_info.item_data.letter.configID = item_info.item_data.letter.configID
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.content ~= nil )then
			msg.item_info.item_data.letter.content = item_info.item_data.letter.content
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.content2 ~= nil )then
			msg.item_info.item_data.letter.content2 = item_info.item_data.letter.content2
		end
	end
	if(item_info.item_data.code ~= nil )then
		if(item_info.item_data.code.code ~= nil )then
			msg.item_info.item_data.code.code = item_info.item_data.code.code
		end
	end
	if(item_info.item_data.code ~= nil )then
		if(item_info.item_data.code.used ~= nil )then
			msg.item_info.item_data.code.used = item_info.item_data.code.used
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.id ~= nil )then
			msg.item_info.item_data.wedding.id = item_info.item_data.wedding.id
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.zoneid ~= nil )then
			msg.item_info.item_data.wedding.zoneid = item_info.item_data.wedding.zoneid
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.charid1 ~= nil )then
			msg.item_info.item_data.wedding.charid1 = item_info.item_data.wedding.charid1
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.charid2 ~= nil )then
			msg.item_info.item_data.wedding.charid2 = item_info.item_data.wedding.charid2
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.weddingtime ~= nil )then
			msg.item_info.item_data.wedding.weddingtime = item_info.item_data.wedding.weddingtime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.photoidx ~= nil )then
			msg.item_info.item_data.wedding.photoidx = item_info.item_data.wedding.photoidx
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.phototime ~= nil )then
			msg.item_info.item_data.wedding.phototime = item_info.item_data.wedding.phototime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.myname ~= nil )then
			msg.item_info.item_data.wedding.myname = item_info.item_data.wedding.myname
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.partnername ~= nil )then
			msg.item_info.item_data.wedding.partnername = item_info.item_data.wedding.partnername
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.starttime ~= nil )then
			msg.item_info.item_data.wedding.starttime = item_info.item_data.wedding.starttime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.endtime ~= nil )then
			msg.item_info.item_data.wedding.endtime = item_info.item_data.wedding.endtime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.notified ~= nil )then
			msg.item_info.item_data.wedding.notified = item_info.item_data.wedding.notified
		end
	end
	if(item_info.item_data.sender ~= nil )then
		if(item_info.item_data.sender.charid ~= nil )then
			msg.item_info.item_data.sender.charid = item_info.item_data.sender.charid
		end
	end
	if(item_info.item_data.sender ~= nil )then
		if(item_info.item_data.sender.name ~= nil )then
			msg.item_info.item_data.sender.name = item_info.item_data.sender.name
		end
	end
	if(item_info ~= nil )then
		if(item_info.publicity_id ~= nil )then
			msg.item_info.publicity_id = item_info.publicity_id
		end
	end
	if(item_info ~= nil )then
		if(item_info.end_time ~= nil )then
			msg.item_info.end_time = item_info.end_time
		end
	end
	if(item_info ~= nil )then
		if(item_info.key ~= nil )then
			msg.item_info.key = item_info.key
		end
	end
	if(item_info ~= nil )then
		if(item_info.charid ~= nil )then
			msg.item_info.charid = item_info.charid
		end
	end
	if(item_info ~= nil )then
		if(item_info.name ~= nil )then
			msg.item_info.name = item_info.name
		end
	end
	if(item_info ~= nil )then
		if(item_info.type ~= nil )then
			msg.item_info.type = item_info.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.up_rate ~= nil )then
			msg.item_info.up_rate = item_info.up_rate
		end
	end
	if(item_info ~= nil )then
		if(item_info.down_rate ~= nil )then
			msg.item_info.down_rate = item_info.down_rate
		end
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	if(order_id ~= nil )then
		msg.order_id = order_id
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(quota ~= nil )then
		msg.quota = quota
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallResellPendingRecordTrade(item_info, charid, ret, order_id, type, quota) 
	local msg = RecordTrade_pb.ResellPendingRecordTrade()
	if(item_info ~= nil )then
		if(item_info.itemid ~= nil )then
			msg.item_info.itemid = item_info.itemid
		end
	end
	if(item_info ~= nil )then
		if(item_info.price ~= nil )then
			msg.item_info.price = item_info.price
		end
	end
	if(item_info ~= nil )then
		if(item_info.count ~= nil )then
			msg.item_info.count = item_info.count
		end
	end
	if(item_info ~= nil )then
		if(item_info.guid ~= nil )then
			msg.item_info.guid = item_info.guid
		end
	end
	if(item_info ~= nil )then
		if(item_info.order_id ~= nil )then
			msg.item_info.order_id = item_info.order_id
		end
	end
	if(item_info ~= nil )then
		if(item_info.refine_lv ~= nil )then
			msg.item_info.refine_lv = item_info.refine_lv
		end
	end
	if(item_info ~= nil )then
		if(item_info.overlap ~= nil )then
			msg.item_info.overlap = item_info.overlap
		end
	end
	if(item_info ~= nil )then
		if(item_info.is_expired ~= nil )then
			msg.item_info.is_expired = item_info.is_expired
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.guid ~= nil )then
			msg.item_info.item_data.base.guid = item_info.item_data.base.guid
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.id ~= nil )then
			msg.item_info.item_data.base.id = item_info.item_data.base.id
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.count ~= nil )then
			msg.item_info.item_data.base.count = item_info.item_data.base.count
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.index ~= nil )then
			msg.item_info.item_data.base.index = item_info.item_data.base.index
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.createtime ~= nil )then
			msg.item_info.item_data.base.createtime = item_info.item_data.base.createtime
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.cd ~= nil )then
			msg.item_info.item_data.base.cd = item_info.item_data.base.cd
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.type ~= nil )then
			msg.item_info.item_data.base.type = item_info.item_data.base.type
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.bind ~= nil )then
			msg.item_info.item_data.base.bind = item_info.item_data.base.bind
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.expire ~= nil )then
			msg.item_info.item_data.base.expire = item_info.item_data.base.expire
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.quality ~= nil )then
			msg.item_info.item_data.base.quality = item_info.item_data.base.quality
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.equipType ~= nil )then
			msg.item_info.item_data.base.equipType = item_info.item_data.base.equipType
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.source ~= nil )then
			msg.item_info.item_data.base.source = item_info.item_data.base.source
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.isnew ~= nil )then
			msg.item_info.item_data.base.isnew = item_info.item_data.base.isnew
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.maxcardslot ~= nil )then
			msg.item_info.item_data.base.maxcardslot = item_info.item_data.base.maxcardslot
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.ishint ~= nil )then
			msg.item_info.item_data.base.ishint = item_info.item_data.base.ishint
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.isactive ~= nil )then
			msg.item_info.item_data.base.isactive = item_info.item_data.base.isactive
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.source_npc ~= nil )then
			msg.item_info.item_data.base.source_npc = item_info.item_data.base.source_npc
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.refinelv ~= nil )then
			msg.item_info.item_data.base.refinelv = item_info.item_data.base.refinelv
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.chargemoney ~= nil )then
			msg.item_info.item_data.base.chargemoney = item_info.item_data.base.chargemoney
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.overtime ~= nil )then
			msg.item_info.item_data.base.overtime = item_info.item_data.base.overtime
		end
	end
	if(item_info.item_data.base ~= nil )then
		if(item_info.item_data.base.quota ~= nil )then
			msg.item_info.item_data.base.quota = item_info.item_data.base.quota
		end
	end
	if(item_info.item_data ~= nil )then
		if(item_info.item_data.equiped ~= nil )then
			msg.item_info.item_data.equiped = item_info.item_data.equiped
		end
	end
	if(item_info.item_data ~= nil )then
		if(item_info.item_data.battlepoint ~= nil )then
			msg.item_info.item_data.battlepoint = item_info.item_data.battlepoint
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthlv ~= nil )then
			msg.item_info.item_data.equip.strengthlv = item_info.item_data.equip.strengthlv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.refinelv ~= nil )then
			msg.item_info.item_data.equip.refinelv = item_info.item_data.equip.refinelv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthCost ~= nil )then
			msg.item_info.item_data.equip.strengthCost = item_info.item_data.equip.strengthCost
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.refineCompose ~= nil )then
			for i=1,#item_info.item_data.equip.refineCompose do 
				table.insert(msg.item_info.item_data.equip.refineCompose, item_info.item_data.equip.refineCompose[i])
			end
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.cardslot ~= nil )then
			msg.item_info.item_data.equip.cardslot = item_info.item_data.equip.cardslot
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.buffid ~= nil )then
			for i=1,#item_info.item_data.equip.buffid do 
				table.insert(msg.item_info.item_data.equip.buffid, item_info.item_data.equip.buffid[i])
			end
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.damage ~= nil )then
			msg.item_info.item_data.equip.damage = item_info.item_data.equip.damage
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.lv ~= nil )then
			msg.item_info.item_data.equip.lv = item_info.item_data.equip.lv
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.color ~= nil )then
			msg.item_info.item_data.equip.color = item_info.item_data.equip.color
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.breakstarttime ~= nil )then
			msg.item_info.item_data.equip.breakstarttime = item_info.item_data.equip.breakstarttime
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.breakendtime ~= nil )then
			msg.item_info.item_data.equip.breakendtime = item_info.item_data.equip.breakendtime
		end
	end
	if(item_info.item_data.equip ~= nil )then
		if(item_info.item_data.equip.strengthlv2 ~= nil )then
			msg.item_info.item_data.equip.strengthlv2 = item_info.item_data.equip.strengthlv2
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.equip.strengthlv2cost ~= nil )then
			for i=1,#item_info.item_data.equip.strengthlv2cost do 
				table.insert(msg.item_info.item_data.equip.strengthlv2cost, item_info.item_data.equip.strengthlv2cost[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.card ~= nil )then
			for i=1,#item_info.item_data.card do 
				table.insert(msg.item_info.item_data.card, item_info.item_data.card[i])
			end
		end
	end
	if(item_info.item_data.enchant ~= nil )then
		if(item_info.item_data.enchant.type ~= nil )then
			msg.item_info.item_data.enchant.type = item_info.item_data.enchant.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.attrs ~= nil )then
			for i=1,#item_info.item_data.enchant.attrs do 
				table.insert(msg.item_info.item_data.enchant.attrs, item_info.item_data.enchant.attrs[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.extras ~= nil )then
			for i=1,#item_info.item_data.enchant.extras do 
				table.insert(msg.item_info.item_data.enchant.extras, item_info.item_data.enchant.extras[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.enchant.patch ~= nil )then
			for i=1,#item_info.item_data.enchant.patch do 
				table.insert(msg.item_info.item_data.enchant.patch, item_info.item_data.enchant.patch[i])
			end
		end
	end
	if(item_info.item_data.previewenchant ~= nil )then
		if(item_info.item_data.previewenchant.type ~= nil )then
			msg.item_info.item_data.previewenchant.type = item_info.item_data.previewenchant.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.attrs ~= nil )then
			for i=1,#item_info.item_data.previewenchant.attrs do 
				table.insert(msg.item_info.item_data.previewenchant.attrs, item_info.item_data.previewenchant.attrs[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.extras ~= nil )then
			for i=1,#item_info.item_data.previewenchant.extras do 
				table.insert(msg.item_info.item_data.previewenchant.extras, item_info.item_data.previewenchant.extras[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.previewenchant.patch ~= nil )then
			for i=1,#item_info.item_data.previewenchant.patch do 
				table.insert(msg.item_info.item_data.previewenchant.patch, item_info.item_data.previewenchant.patch[i])
			end
		end
	end
	if(item_info.item_data.refine ~= nil )then
		if(item_info.item_data.refine.lastfail ~= nil )then
			msg.item_info.item_data.refine.lastfail = item_info.item_data.refine.lastfail
		end
	end
	if(item_info.item_data.refine ~= nil )then
		if(item_info.item_data.refine.repaircount ~= nil )then
			msg.item_info.item_data.refine.repaircount = item_info.item_data.refine.repaircount
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.exp ~= nil )then
			msg.item_info.item_data.egg.exp = item_info.item_data.egg.exp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.friendexp ~= nil )then
			msg.item_info.item_data.egg.friendexp = item_info.item_data.egg.friendexp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.rewardexp ~= nil )then
			msg.item_info.item_data.egg.rewardexp = item_info.item_data.egg.rewardexp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.id ~= nil )then
			msg.item_info.item_data.egg.id = item_info.item_data.egg.id
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.lv ~= nil )then
			msg.item_info.item_data.egg.lv = item_info.item_data.egg.lv
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.friendlv ~= nil )then
			msg.item_info.item_data.egg.friendlv = item_info.item_data.egg.friendlv
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.body ~= nil )then
			msg.item_info.item_data.egg.body = item_info.item_data.egg.body
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.relivetime ~= nil )then
			msg.item_info.item_data.egg.relivetime = item_info.item_data.egg.relivetime
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.hp ~= nil )then
			msg.item_info.item_data.egg.hp = item_info.item_data.egg.hp
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.restoretime ~= nil )then
			msg.item_info.item_data.egg.restoretime = item_info.item_data.egg.restoretime
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happly ~= nil )then
			msg.item_info.item_data.egg.time_happly = item_info.item_data.egg.time_happly
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_excite ~= nil )then
			msg.item_info.item_data.egg.time_excite = item_info.item_data.egg.time_excite
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happiness ~= nil )then
			msg.item_info.item_data.egg.time_happiness = item_info.item_data.egg.time_happiness
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happly_gift ~= nil )then
			msg.item_info.item_data.egg.time_happly_gift = item_info.item_data.egg.time_happly_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_excite_gift ~= nil )then
			msg.item_info.item_data.egg.time_excite_gift = item_info.item_data.egg.time_excite_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.time_happiness_gift ~= nil )then
			msg.item_info.item_data.egg.time_happiness_gift = item_info.item_data.egg.time_happiness_gift
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.touch_tick ~= nil )then
			msg.item_info.item_data.egg.touch_tick = item_info.item_data.egg.touch_tick
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.feed_tick ~= nil )then
			msg.item_info.item_data.egg.feed_tick = item_info.item_data.egg.feed_tick
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.name ~= nil )then
			msg.item_info.item_data.egg.name = item_info.item_data.egg.name
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.var ~= nil )then
			msg.item_info.item_data.egg.var = item_info.item_data.egg.var
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.skillids ~= nil )then
			for i=1,#item_info.item_data.egg.skillids do 
				table.insert(msg.item_info.item_data.egg.skillids, item_info.item_data.egg.skillids[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.equips ~= nil )then
			for i=1,#item_info.item_data.egg.equips do 
				table.insert(msg.item_info.item_data.egg.equips, item_info.item_data.egg.equips[i])
			end
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.buff ~= nil )then
			msg.item_info.item_data.egg.buff = item_info.item_data.egg.buff
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.unlock_equip ~= nil )then
			for i=1,#item_info.item_data.egg.unlock_equip do 
				table.insert(msg.item_info.item_data.egg.unlock_equip, item_info.item_data.egg.unlock_equip[i])
			end
		end
	end
	if(item_info ~= nil )then
		if(item_info.item_data.egg.unlock_body ~= nil )then
			for i=1,#item_info.item_data.egg.unlock_body do 
				table.insert(msg.item_info.item_data.egg.unlock_body, item_info.item_data.egg.unlock_body[i])
			end
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.version ~= nil )then
			msg.item_info.item_data.egg.version = item_info.item_data.egg.version
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.skilloff ~= nil )then
			msg.item_info.item_data.egg.skilloff = item_info.item_data.egg.skilloff
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.exchange_count ~= nil )then
			msg.item_info.item_data.egg.exchange_count = item_info.item_data.egg.exchange_count
		end
	end
	if(item_info.item_data.egg ~= nil )then
		if(item_info.item_data.egg.guid ~= nil )then
			msg.item_info.item_data.egg.guid = item_info.item_data.egg.guid
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.sendUserName ~= nil )then
			msg.item_info.item_data.letter.sendUserName = item_info.item_data.letter.sendUserName
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.bg ~= nil )then
			msg.item_info.item_data.letter.bg = item_info.item_data.letter.bg
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.configID ~= nil )then
			msg.item_info.item_data.letter.configID = item_info.item_data.letter.configID
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.content ~= nil )then
			msg.item_info.item_data.letter.content = item_info.item_data.letter.content
		end
	end
	if(item_info.item_data.letter ~= nil )then
		if(item_info.item_data.letter.content2 ~= nil )then
			msg.item_info.item_data.letter.content2 = item_info.item_data.letter.content2
		end
	end
	if(item_info.item_data.code ~= nil )then
		if(item_info.item_data.code.code ~= nil )then
			msg.item_info.item_data.code.code = item_info.item_data.code.code
		end
	end
	if(item_info.item_data.code ~= nil )then
		if(item_info.item_data.code.used ~= nil )then
			msg.item_info.item_data.code.used = item_info.item_data.code.used
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.id ~= nil )then
			msg.item_info.item_data.wedding.id = item_info.item_data.wedding.id
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.zoneid ~= nil )then
			msg.item_info.item_data.wedding.zoneid = item_info.item_data.wedding.zoneid
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.charid1 ~= nil )then
			msg.item_info.item_data.wedding.charid1 = item_info.item_data.wedding.charid1
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.charid2 ~= nil )then
			msg.item_info.item_data.wedding.charid2 = item_info.item_data.wedding.charid2
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.weddingtime ~= nil )then
			msg.item_info.item_data.wedding.weddingtime = item_info.item_data.wedding.weddingtime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.photoidx ~= nil )then
			msg.item_info.item_data.wedding.photoidx = item_info.item_data.wedding.photoidx
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.phototime ~= nil )then
			msg.item_info.item_data.wedding.phototime = item_info.item_data.wedding.phototime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.myname ~= nil )then
			msg.item_info.item_data.wedding.myname = item_info.item_data.wedding.myname
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.partnername ~= nil )then
			msg.item_info.item_data.wedding.partnername = item_info.item_data.wedding.partnername
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.starttime ~= nil )then
			msg.item_info.item_data.wedding.starttime = item_info.item_data.wedding.starttime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.endtime ~= nil )then
			msg.item_info.item_data.wedding.endtime = item_info.item_data.wedding.endtime
		end
	end
	if(item_info.item_data.wedding ~= nil )then
		if(item_info.item_data.wedding.notified ~= nil )then
			msg.item_info.item_data.wedding.notified = item_info.item_data.wedding.notified
		end
	end
	if(item_info.item_data.sender ~= nil )then
		if(item_info.item_data.sender.charid ~= nil )then
			msg.item_info.item_data.sender.charid = item_info.item_data.sender.charid
		end
	end
	if(item_info.item_data.sender ~= nil )then
		if(item_info.item_data.sender.name ~= nil )then
			msg.item_info.item_data.sender.name = item_info.item_data.sender.name
		end
	end
	if(item_info ~= nil )then
		if(item_info.publicity_id ~= nil )then
			msg.item_info.publicity_id = item_info.publicity_id
		end
	end
	if(item_info ~= nil )then
		if(item_info.end_time ~= nil )then
			msg.item_info.end_time = item_info.end_time
		end
	end
	if(item_info ~= nil )then
		if(item_info.key ~= nil )then
			msg.item_info.key = item_info.key
		end
	end
	if(item_info ~= nil )then
		if(item_info.charid ~= nil )then
			msg.item_info.charid = item_info.charid
		end
	end
	if(item_info ~= nil )then
		if(item_info.name ~= nil )then
			msg.item_info.name = item_info.name
		end
	end
	if(item_info ~= nil )then
		if(item_info.type ~= nil )then
			msg.item_info.type = item_info.type
		end
	end
	if(item_info ~= nil )then
		if(item_info.up_rate ~= nil )then
			msg.item_info.up_rate = item_info.up_rate
		end
	end
	if(item_info ~= nil )then
		if(item_info.down_rate ~= nil )then
			msg.item_info.down_rate = item_info.down_rate
		end
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	if(order_id ~= nil )then
		msg.order_id = order_id
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(quota ~= nil )then
		msg.quota = quota
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallPanelRecordTrade(charid, oper, trade_type) 
	local msg = RecordTrade_pb.PanelRecordTrade()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(oper ~= nil )then
		msg.oper = oper
	end
	if(trade_type ~= nil )then
		msg.trade_type = trade_type
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallListNtfRecordTrade(charid, type, trade_type) 
	local msg = RecordTrade_pb.ListNtfRecordTrade()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(trade_type ~= nil )then
		msg.trade_type = trade_type
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallHotItemidRecordTrade(charid, job, pub_lists, lists) 
	local msg = RecordTrade_pb.HotItemidRecordTrade()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(job ~= nil )then
		msg.job = job
	end
	if( pub_lists ~= nil )then
		for i=1,#pub_lists do 
			table.insert(msg.pub_lists, pub_lists[i])
		end
	end
	if( lists ~= nil )then
		for i=1,#lists do 
			table.insert(msg.lists, lists[i])
		end
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallNtfCanTakeCountTradeCmd(count, trade_type) 
	local msg = RecordTrade_pb.NtfCanTakeCountTradeCmd()
	if(count ~= nil )then
		msg.count = count
	end
	if(trade_type ~= nil )then
		msg.trade_type = trade_type
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallGiveTradeCmd(id, logtype, friendid, content, anonymous, background, success) 
	local msg = RecordTrade_pb.GiveTradeCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(logtype ~= nil )then
		msg.logtype = logtype
	end
	if(friendid ~= nil )then
		msg.friendid = friendid
	end
	if(content ~= nil )then
		msg.content = content
	end
	if(anonymous ~= nil )then
		msg.anonymous = anonymous
	end
	if(background ~= nil )then
		msg.background = background
	end
	if(success ~= nil )then
		msg.success = success
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallAcceptTradeCmd(id, success) 
	local msg = RecordTrade_pb.AcceptTradeCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(success ~= nil )then
		msg.success = success
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallRefuseTradeCmd(id, success) 
	local msg = RecordTrade_pb.RefuseTradeCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(success ~= nil )then
		msg.success = success
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallReqGiveItemInfoCmd(id, iteminfo) 
	local msg = RecordTrade_pb.ReqGiveItemInfoCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(iteminfo ~= nil )then
		if(iteminfo.id ~= nil )then
			msg.iteminfo.id = iteminfo.id
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.status ~= nil )then
			msg.iteminfo.status = iteminfo.status
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemid ~= nil )then
			msg.iteminfo.itemid = iteminfo.itemid
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.count ~= nil )then
			msg.iteminfo.count = iteminfo.count
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.guid ~= nil )then
			msg.iteminfo.itemdata.base.guid = iteminfo.itemdata.base.guid
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.id ~= nil )then
			msg.iteminfo.itemdata.base.id = iteminfo.itemdata.base.id
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.count ~= nil )then
			msg.iteminfo.itemdata.base.count = iteminfo.itemdata.base.count
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.index ~= nil )then
			msg.iteminfo.itemdata.base.index = iteminfo.itemdata.base.index
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.createtime ~= nil )then
			msg.iteminfo.itemdata.base.createtime = iteminfo.itemdata.base.createtime
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.cd ~= nil )then
			msg.iteminfo.itemdata.base.cd = iteminfo.itemdata.base.cd
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.type ~= nil )then
			msg.iteminfo.itemdata.base.type = iteminfo.itemdata.base.type
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.bind ~= nil )then
			msg.iteminfo.itemdata.base.bind = iteminfo.itemdata.base.bind
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.expire ~= nil )then
			msg.iteminfo.itemdata.base.expire = iteminfo.itemdata.base.expire
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.quality ~= nil )then
			msg.iteminfo.itemdata.base.quality = iteminfo.itemdata.base.quality
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.equipType ~= nil )then
			msg.iteminfo.itemdata.base.equipType = iteminfo.itemdata.base.equipType
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.source ~= nil )then
			msg.iteminfo.itemdata.base.source = iteminfo.itemdata.base.source
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.isnew ~= nil )then
			msg.iteminfo.itemdata.base.isnew = iteminfo.itemdata.base.isnew
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.maxcardslot ~= nil )then
			msg.iteminfo.itemdata.base.maxcardslot = iteminfo.itemdata.base.maxcardslot
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.ishint ~= nil )then
			msg.iteminfo.itemdata.base.ishint = iteminfo.itemdata.base.ishint
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.isactive ~= nil )then
			msg.iteminfo.itemdata.base.isactive = iteminfo.itemdata.base.isactive
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.source_npc ~= nil )then
			msg.iteminfo.itemdata.base.source_npc = iteminfo.itemdata.base.source_npc
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.refinelv ~= nil )then
			msg.iteminfo.itemdata.base.refinelv = iteminfo.itemdata.base.refinelv
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.chargemoney ~= nil )then
			msg.iteminfo.itemdata.base.chargemoney = iteminfo.itemdata.base.chargemoney
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.overtime ~= nil )then
			msg.iteminfo.itemdata.base.overtime = iteminfo.itemdata.base.overtime
		end
	end
	if(iteminfo.itemdata.base ~= nil )then
		if(iteminfo.itemdata.base.quota ~= nil )then
			msg.iteminfo.itemdata.base.quota = iteminfo.itemdata.base.quota
		end
	end
	if(iteminfo.itemdata ~= nil )then
		if(iteminfo.itemdata.equiped ~= nil )then
			msg.iteminfo.itemdata.equiped = iteminfo.itemdata.equiped
		end
	end
	if(iteminfo.itemdata ~= nil )then
		if(iteminfo.itemdata.battlepoint ~= nil )then
			msg.iteminfo.itemdata.battlepoint = iteminfo.itemdata.battlepoint
		end
	end
	if(iteminfo.itemdata.equip ~= nil )then
		if(iteminfo.itemdata.equip.strengthlv ~= nil )then
			msg.iteminfo.itemdata.equip.strengthlv = iteminfo.itemdata.equip.strengthlv
		end
	end
	if(iteminfo.itemdata.equip ~= nil )then
		if(iteminfo.itemdata.equip.refinelv ~= nil )then
			msg.iteminfo.itemdata.equip.refinelv = iteminfo.itemdata.equip.refinelv
		end
	end
	if(iteminfo.itemdata.equip ~= nil )then
		if(iteminfo.itemdata.equip.strengthCost ~= nil )then
			msg.iteminfo.itemdata.equip.strengthCost = iteminfo.itemdata.equip.strengthCost
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.equip.refineCompose ~= nil )then
			for i=1,#iteminfo.itemdata.equip.refineCompose do 
				table.insert(msg.iteminfo.itemdata.equip.refineCompose, iteminfo.itemdata.equip.refineCompose[i])
			end
		end
	end
	if(iteminfo.itemdata.equip ~= nil )then
		if(iteminfo.itemdata.equip.cardslot ~= nil )then
			msg.iteminfo.itemdata.equip.cardslot = iteminfo.itemdata.equip.cardslot
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.equip.buffid ~= nil )then
			for i=1,#iteminfo.itemdata.equip.buffid do 
				table.insert(msg.iteminfo.itemdata.equip.buffid, iteminfo.itemdata.equip.buffid[i])
			end
		end
	end
	if(iteminfo.itemdata.equip ~= nil )then
		if(iteminfo.itemdata.equip.damage ~= nil )then
			msg.iteminfo.itemdata.equip.damage = iteminfo.itemdata.equip.damage
		end
	end
	if(iteminfo.itemdata.equip ~= nil )then
		if(iteminfo.itemdata.equip.lv ~= nil )then
			msg.iteminfo.itemdata.equip.lv = iteminfo.itemdata.equip.lv
		end
	end
	if(iteminfo.itemdata.equip ~= nil )then
		if(iteminfo.itemdata.equip.color ~= nil )then
			msg.iteminfo.itemdata.equip.color = iteminfo.itemdata.equip.color
		end
	end
	if(iteminfo.itemdata.equip ~= nil )then
		if(iteminfo.itemdata.equip.breakstarttime ~= nil )then
			msg.iteminfo.itemdata.equip.breakstarttime = iteminfo.itemdata.equip.breakstarttime
		end
	end
	if(iteminfo.itemdata.equip ~= nil )then
		if(iteminfo.itemdata.equip.breakendtime ~= nil )then
			msg.iteminfo.itemdata.equip.breakendtime = iteminfo.itemdata.equip.breakendtime
		end
	end
	if(iteminfo.itemdata.equip ~= nil )then
		if(iteminfo.itemdata.equip.strengthlv2 ~= nil )then
			msg.iteminfo.itemdata.equip.strengthlv2 = iteminfo.itemdata.equip.strengthlv2
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.equip.strengthlv2cost ~= nil )then
			for i=1,#iteminfo.itemdata.equip.strengthlv2cost do 
				table.insert(msg.iteminfo.itemdata.equip.strengthlv2cost, iteminfo.itemdata.equip.strengthlv2cost[i])
			end
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.card ~= nil )then
			for i=1,#iteminfo.itemdata.card do 
				table.insert(msg.iteminfo.itemdata.card, iteminfo.itemdata.card[i])
			end
		end
	end
	if(iteminfo.itemdata.enchant ~= nil )then
		if(iteminfo.itemdata.enchant.type ~= nil )then
			msg.iteminfo.itemdata.enchant.type = iteminfo.itemdata.enchant.type
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.enchant.attrs ~= nil )then
			for i=1,#iteminfo.itemdata.enchant.attrs do 
				table.insert(msg.iteminfo.itemdata.enchant.attrs, iteminfo.itemdata.enchant.attrs[i])
			end
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.enchant.extras ~= nil )then
			for i=1,#iteminfo.itemdata.enchant.extras do 
				table.insert(msg.iteminfo.itemdata.enchant.extras, iteminfo.itemdata.enchant.extras[i])
			end
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.enchant.patch ~= nil )then
			for i=1,#iteminfo.itemdata.enchant.patch do 
				table.insert(msg.iteminfo.itemdata.enchant.patch, iteminfo.itemdata.enchant.patch[i])
			end
		end
	end
	if(iteminfo.itemdata.previewenchant ~= nil )then
		if(iteminfo.itemdata.previewenchant.type ~= nil )then
			msg.iteminfo.itemdata.previewenchant.type = iteminfo.itemdata.previewenchant.type
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.previewenchant.attrs ~= nil )then
			for i=1,#iteminfo.itemdata.previewenchant.attrs do 
				table.insert(msg.iteminfo.itemdata.previewenchant.attrs, iteminfo.itemdata.previewenchant.attrs[i])
			end
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.previewenchant.extras ~= nil )then
			for i=1,#iteminfo.itemdata.previewenchant.extras do 
				table.insert(msg.iteminfo.itemdata.previewenchant.extras, iteminfo.itemdata.previewenchant.extras[i])
			end
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.previewenchant.patch ~= nil )then
			for i=1,#iteminfo.itemdata.previewenchant.patch do 
				table.insert(msg.iteminfo.itemdata.previewenchant.patch, iteminfo.itemdata.previewenchant.patch[i])
			end
		end
	end
	if(iteminfo.itemdata.refine ~= nil )then
		if(iteminfo.itemdata.refine.lastfail ~= nil )then
			msg.iteminfo.itemdata.refine.lastfail = iteminfo.itemdata.refine.lastfail
		end
	end
	if(iteminfo.itemdata.refine ~= nil )then
		if(iteminfo.itemdata.refine.repaircount ~= nil )then
			msg.iteminfo.itemdata.refine.repaircount = iteminfo.itemdata.refine.repaircount
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.exp ~= nil )then
			msg.iteminfo.itemdata.egg.exp = iteminfo.itemdata.egg.exp
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.friendexp ~= nil )then
			msg.iteminfo.itemdata.egg.friendexp = iteminfo.itemdata.egg.friendexp
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.rewardexp ~= nil )then
			msg.iteminfo.itemdata.egg.rewardexp = iteminfo.itemdata.egg.rewardexp
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.id ~= nil )then
			msg.iteminfo.itemdata.egg.id = iteminfo.itemdata.egg.id
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.lv ~= nil )then
			msg.iteminfo.itemdata.egg.lv = iteminfo.itemdata.egg.lv
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.friendlv ~= nil )then
			msg.iteminfo.itemdata.egg.friendlv = iteminfo.itemdata.egg.friendlv
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.body ~= nil )then
			msg.iteminfo.itemdata.egg.body = iteminfo.itemdata.egg.body
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.relivetime ~= nil )then
			msg.iteminfo.itemdata.egg.relivetime = iteminfo.itemdata.egg.relivetime
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.hp ~= nil )then
			msg.iteminfo.itemdata.egg.hp = iteminfo.itemdata.egg.hp
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.restoretime ~= nil )then
			msg.iteminfo.itemdata.egg.restoretime = iteminfo.itemdata.egg.restoretime
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.time_happly ~= nil )then
			msg.iteminfo.itemdata.egg.time_happly = iteminfo.itemdata.egg.time_happly
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.time_excite ~= nil )then
			msg.iteminfo.itemdata.egg.time_excite = iteminfo.itemdata.egg.time_excite
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.time_happiness ~= nil )then
			msg.iteminfo.itemdata.egg.time_happiness = iteminfo.itemdata.egg.time_happiness
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.time_happly_gift ~= nil )then
			msg.iteminfo.itemdata.egg.time_happly_gift = iteminfo.itemdata.egg.time_happly_gift
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.time_excite_gift ~= nil )then
			msg.iteminfo.itemdata.egg.time_excite_gift = iteminfo.itemdata.egg.time_excite_gift
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.time_happiness_gift ~= nil )then
			msg.iteminfo.itemdata.egg.time_happiness_gift = iteminfo.itemdata.egg.time_happiness_gift
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.touch_tick ~= nil )then
			msg.iteminfo.itemdata.egg.touch_tick = iteminfo.itemdata.egg.touch_tick
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.feed_tick ~= nil )then
			msg.iteminfo.itemdata.egg.feed_tick = iteminfo.itemdata.egg.feed_tick
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.name ~= nil )then
			msg.iteminfo.itemdata.egg.name = iteminfo.itemdata.egg.name
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.var ~= nil )then
			msg.iteminfo.itemdata.egg.var = iteminfo.itemdata.egg.var
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.egg.skillids ~= nil )then
			for i=1,#iteminfo.itemdata.egg.skillids do 
				table.insert(msg.iteminfo.itemdata.egg.skillids, iteminfo.itemdata.egg.skillids[i])
			end
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.egg.equips ~= nil )then
			for i=1,#iteminfo.itemdata.egg.equips do 
				table.insert(msg.iteminfo.itemdata.egg.equips, iteminfo.itemdata.egg.equips[i])
			end
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.buff ~= nil )then
			msg.iteminfo.itemdata.egg.buff = iteminfo.itemdata.egg.buff
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.egg.unlock_equip ~= nil )then
			for i=1,#iteminfo.itemdata.egg.unlock_equip do 
				table.insert(msg.iteminfo.itemdata.egg.unlock_equip, iteminfo.itemdata.egg.unlock_equip[i])
			end
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.itemdata.egg.unlock_body ~= nil )then
			for i=1,#iteminfo.itemdata.egg.unlock_body do 
				table.insert(msg.iteminfo.itemdata.egg.unlock_body, iteminfo.itemdata.egg.unlock_body[i])
			end
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.version ~= nil )then
			msg.iteminfo.itemdata.egg.version = iteminfo.itemdata.egg.version
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.skilloff ~= nil )then
			msg.iteminfo.itemdata.egg.skilloff = iteminfo.itemdata.egg.skilloff
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.exchange_count ~= nil )then
			msg.iteminfo.itemdata.egg.exchange_count = iteminfo.itemdata.egg.exchange_count
		end
	end
	if(iteminfo.itemdata.egg ~= nil )then
		if(iteminfo.itemdata.egg.guid ~= nil )then
			msg.iteminfo.itemdata.egg.guid = iteminfo.itemdata.egg.guid
		end
	end
	if(iteminfo.itemdata.letter ~= nil )then
		if(iteminfo.itemdata.letter.sendUserName ~= nil )then
			msg.iteminfo.itemdata.letter.sendUserName = iteminfo.itemdata.letter.sendUserName
		end
	end
	if(iteminfo.itemdata.letter ~= nil )then
		if(iteminfo.itemdata.letter.bg ~= nil )then
			msg.iteminfo.itemdata.letter.bg = iteminfo.itemdata.letter.bg
		end
	end
	if(iteminfo.itemdata.letter ~= nil )then
		if(iteminfo.itemdata.letter.configID ~= nil )then
			msg.iteminfo.itemdata.letter.configID = iteminfo.itemdata.letter.configID
		end
	end
	if(iteminfo.itemdata.letter ~= nil )then
		if(iteminfo.itemdata.letter.content ~= nil )then
			msg.iteminfo.itemdata.letter.content = iteminfo.itemdata.letter.content
		end
	end
	if(iteminfo.itemdata.letter ~= nil )then
		if(iteminfo.itemdata.letter.content2 ~= nil )then
			msg.iteminfo.itemdata.letter.content2 = iteminfo.itemdata.letter.content2
		end
	end
	if(iteminfo.itemdata.code ~= nil )then
		if(iteminfo.itemdata.code.code ~= nil )then
			msg.iteminfo.itemdata.code.code = iteminfo.itemdata.code.code
		end
	end
	if(iteminfo.itemdata.code ~= nil )then
		if(iteminfo.itemdata.code.used ~= nil )then
			msg.iteminfo.itemdata.code.used = iteminfo.itemdata.code.used
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.id ~= nil )then
			msg.iteminfo.itemdata.wedding.id = iteminfo.itemdata.wedding.id
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.zoneid ~= nil )then
			msg.iteminfo.itemdata.wedding.zoneid = iteminfo.itemdata.wedding.zoneid
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.charid1 ~= nil )then
			msg.iteminfo.itemdata.wedding.charid1 = iteminfo.itemdata.wedding.charid1
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.charid2 ~= nil )then
			msg.iteminfo.itemdata.wedding.charid2 = iteminfo.itemdata.wedding.charid2
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.weddingtime ~= nil )then
			msg.iteminfo.itemdata.wedding.weddingtime = iteminfo.itemdata.wedding.weddingtime
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.photoidx ~= nil )then
			msg.iteminfo.itemdata.wedding.photoidx = iteminfo.itemdata.wedding.photoidx
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.phototime ~= nil )then
			msg.iteminfo.itemdata.wedding.phototime = iteminfo.itemdata.wedding.phototime
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.myname ~= nil )then
			msg.iteminfo.itemdata.wedding.myname = iteminfo.itemdata.wedding.myname
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.partnername ~= nil )then
			msg.iteminfo.itemdata.wedding.partnername = iteminfo.itemdata.wedding.partnername
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.starttime ~= nil )then
			msg.iteminfo.itemdata.wedding.starttime = iteminfo.itemdata.wedding.starttime
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.endtime ~= nil )then
			msg.iteminfo.itemdata.wedding.endtime = iteminfo.itemdata.wedding.endtime
		end
	end
	if(iteminfo.itemdata.wedding ~= nil )then
		if(iteminfo.itemdata.wedding.notified ~= nil )then
			msg.iteminfo.itemdata.wedding.notified = iteminfo.itemdata.wedding.notified
		end
	end
	if(iteminfo.itemdata.sender ~= nil )then
		if(iteminfo.itemdata.sender.charid ~= nil )then
			msg.iteminfo.itemdata.sender.charid = iteminfo.itemdata.sender.charid
		end
	end
	if(iteminfo.itemdata.sender ~= nil )then
		if(iteminfo.itemdata.sender.name ~= nil )then
			msg.iteminfo.itemdata.sender.name = iteminfo.itemdata.sender.name
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.senderid ~= nil )then
			msg.iteminfo.senderid = iteminfo.senderid
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.sendername ~= nil )then
			msg.iteminfo.sendername = iteminfo.sendername
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.anonymous ~= nil )then
			msg.iteminfo.anonymous = iteminfo.anonymous
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.expiretime ~= nil )then
			msg.iteminfo.expiretime = iteminfo.expiretime
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.content ~= nil )then
			msg.iteminfo.content = iteminfo.content
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.quota ~= nil )then
			msg.iteminfo.quota = iteminfo.quota
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.receivername ~= nil )then
			msg.iteminfo.receivername = iteminfo.receivername
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.background ~= nil )then
			msg.iteminfo.background = iteminfo.background
		end
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallCheckPackageSizeTradeCmd(items, ret) 
	local msg = RecordTrade_pb.CheckPackageSizeTradeCmd()
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallQucikTakeLogTradeCmd(trade_type) 
	local msg = RecordTrade_pb.QucikTakeLogTradeCmd()
	if(trade_type ~= nil )then
		msg.trade_type = trade_type
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallQueryItemCountTradeCmd(charid, items, res_items) 
	local msg = RecordTrade_pb.QueryItemCountTradeCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	if( res_items ~= nil )then
		for i=1,#res_items do 
			table.insert(msg.res_items, res_items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallLotteryGiveCmd(iteminfo) 
	local msg = RecordTrade_pb.LotteryGiveCmd()
	if(iteminfo ~= nil )then
		if(iteminfo.year ~= nil )then
			msg.iteminfo.year = iteminfo.year
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.month ~= nil )then
			msg.iteminfo.month = iteminfo.month
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.count ~= nil )then
			msg.iteminfo.count = iteminfo.count
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.content ~= nil )then
			msg.iteminfo.content = iteminfo.content
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.configid ~= nil )then
			msg.iteminfo.configid = iteminfo.configid
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.receiverid ~= nil )then
			msg.iteminfo.receiverid = iteminfo.receiverid
		end
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallTodayFinanceRank(rank_type, date_type, lists) 
	local msg = RecordTrade_pb.TodayFinanceRank()
	if(rank_type ~= nil )then
		msg.rank_type = rank_type
	end
	if(date_type ~= nil )then
		msg.date_type = date_type
	end
	if( lists ~= nil )then
		for i=1,#lists do 
			table.insert(msg.lists, lists[i])
		end
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallTodayFinanceDetail(item_id, rank_type, date_type, lists) 
	local msg = RecordTrade_pb.TodayFinanceDetail()
	if(item_id ~= nil )then
		msg.item_id = item_id
	end
	if(rank_type ~= nil )then
		msg.rank_type = rank_type
	end
	if(date_type ~= nil )then
		msg.date_type = date_type
	end
	if( lists ~= nil )then
		for i=1,#lists do 
			table.insert(msg.lists, lists[i])
		end
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallBoothPlayerPendingListCmd(charid, lists) 
	local msg = RecordTrade_pb.BoothPlayerPendingListCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if( lists ~= nil )then
		for i=1,#lists do 
			table.insert(msg.lists, lists[i])
		end
	end
	self:SendProto(msg)
end

function ServiceRecordTradeAutoProxy:CallUpdateOrderTradeCmd(charid, info, type) 
	local msg = RecordTrade_pb.UpdateOrderTradeCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(info ~= nil )then
		if(info.itemid ~= nil )then
			msg.info.itemid = info.itemid
		end
	end
	if(info ~= nil )then
		if(info.price ~= nil )then
			msg.info.price = info.price
		end
	end
	if(info ~= nil )then
		if(info.count ~= nil )then
			msg.info.count = info.count
		end
	end
	if(info ~= nil )then
		if(info.guid ~= nil )then
			msg.info.guid = info.guid
		end
	end
	if(info ~= nil )then
		if(info.order_id ~= nil )then
			msg.info.order_id = info.order_id
		end
	end
	if(info ~= nil )then
		if(info.refine_lv ~= nil )then
			msg.info.refine_lv = info.refine_lv
		end
	end
	if(info ~= nil )then
		if(info.overlap ~= nil )then
			msg.info.overlap = info.overlap
		end
	end
	if(info ~= nil )then
		if(info.is_expired ~= nil )then
			msg.info.is_expired = info.is_expired
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.guid ~= nil )then
			msg.info.item_data.base.guid = info.item_data.base.guid
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.id ~= nil )then
			msg.info.item_data.base.id = info.item_data.base.id
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.count ~= nil )then
			msg.info.item_data.base.count = info.item_data.base.count
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.index ~= nil )then
			msg.info.item_data.base.index = info.item_data.base.index
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.createtime ~= nil )then
			msg.info.item_data.base.createtime = info.item_data.base.createtime
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.cd ~= nil )then
			msg.info.item_data.base.cd = info.item_data.base.cd
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.type ~= nil )then
			msg.info.item_data.base.type = info.item_data.base.type
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.bind ~= nil )then
			msg.info.item_data.base.bind = info.item_data.base.bind
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.expire ~= nil )then
			msg.info.item_data.base.expire = info.item_data.base.expire
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.quality ~= nil )then
			msg.info.item_data.base.quality = info.item_data.base.quality
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.equipType ~= nil )then
			msg.info.item_data.base.equipType = info.item_data.base.equipType
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.source ~= nil )then
			msg.info.item_data.base.source = info.item_data.base.source
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.isnew ~= nil )then
			msg.info.item_data.base.isnew = info.item_data.base.isnew
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.maxcardslot ~= nil )then
			msg.info.item_data.base.maxcardslot = info.item_data.base.maxcardslot
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.ishint ~= nil )then
			msg.info.item_data.base.ishint = info.item_data.base.ishint
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.isactive ~= nil )then
			msg.info.item_data.base.isactive = info.item_data.base.isactive
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.source_npc ~= nil )then
			msg.info.item_data.base.source_npc = info.item_data.base.source_npc
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.refinelv ~= nil )then
			msg.info.item_data.base.refinelv = info.item_data.base.refinelv
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.chargemoney ~= nil )then
			msg.info.item_data.base.chargemoney = info.item_data.base.chargemoney
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.overtime ~= nil )then
			msg.info.item_data.base.overtime = info.item_data.base.overtime
		end
	end
	if(info.item_data.base ~= nil )then
		if(info.item_data.base.quota ~= nil )then
			msg.info.item_data.base.quota = info.item_data.base.quota
		end
	end
	if(info.item_data ~= nil )then
		if(info.item_data.equiped ~= nil )then
			msg.info.item_data.equiped = info.item_data.equiped
		end
	end
	if(info.item_data ~= nil )then
		if(info.item_data.battlepoint ~= nil )then
			msg.info.item_data.battlepoint = info.item_data.battlepoint
		end
	end
	if(info.item_data.equip ~= nil )then
		if(info.item_data.equip.strengthlv ~= nil )then
			msg.info.item_data.equip.strengthlv = info.item_data.equip.strengthlv
		end
	end
	if(info.item_data.equip ~= nil )then
		if(info.item_data.equip.refinelv ~= nil )then
			msg.info.item_data.equip.refinelv = info.item_data.equip.refinelv
		end
	end
	if(info.item_data.equip ~= nil )then
		if(info.item_data.equip.strengthCost ~= nil )then
			msg.info.item_data.equip.strengthCost = info.item_data.equip.strengthCost
		end
	end
	if(info ~= nil )then
		if(info.item_data.equip.refineCompose ~= nil )then
			for i=1,#info.item_data.equip.refineCompose do 
				table.insert(msg.info.item_data.equip.refineCompose, info.item_data.equip.refineCompose[i])
			end
		end
	end
	if(info.item_data.equip ~= nil )then
		if(info.item_data.equip.cardslot ~= nil )then
			msg.info.item_data.equip.cardslot = info.item_data.equip.cardslot
		end
	end
	if(info ~= nil )then
		if(info.item_data.equip.buffid ~= nil )then
			for i=1,#info.item_data.equip.buffid do 
				table.insert(msg.info.item_data.equip.buffid, info.item_data.equip.buffid[i])
			end
		end
	end
	if(info.item_data.equip ~= nil )then
		if(info.item_data.equip.damage ~= nil )then
			msg.info.item_data.equip.damage = info.item_data.equip.damage
		end
	end
	if(info.item_data.equip ~= nil )then
		if(info.item_data.equip.lv ~= nil )then
			msg.info.item_data.equip.lv = info.item_data.equip.lv
		end
	end
	if(info.item_data.equip ~= nil )then
		if(info.item_data.equip.color ~= nil )then
			msg.info.item_data.equip.color = info.item_data.equip.color
		end
	end
	if(info.item_data.equip ~= nil )then
		if(info.item_data.equip.breakstarttime ~= nil )then
			msg.info.item_data.equip.breakstarttime = info.item_data.equip.breakstarttime
		end
	end
	if(info.item_data.equip ~= nil )then
		if(info.item_data.equip.breakendtime ~= nil )then
			msg.info.item_data.equip.breakendtime = info.item_data.equip.breakendtime
		end
	end
	if(info.item_data.equip ~= nil )then
		if(info.item_data.equip.strengthlv2 ~= nil )then
			msg.info.item_data.equip.strengthlv2 = info.item_data.equip.strengthlv2
		end
	end
	if(info ~= nil )then
		if(info.item_data.equip.strengthlv2cost ~= nil )then
			for i=1,#info.item_data.equip.strengthlv2cost do 
				table.insert(msg.info.item_data.equip.strengthlv2cost, info.item_data.equip.strengthlv2cost[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.item_data.card ~= nil )then
			for i=1,#info.item_data.card do 
				table.insert(msg.info.item_data.card, info.item_data.card[i])
			end
		end
	end
	if(info.item_data.enchant ~= nil )then
		if(info.item_data.enchant.type ~= nil )then
			msg.info.item_data.enchant.type = info.item_data.enchant.type
		end
	end
	if(info ~= nil )then
		if(info.item_data.enchant.attrs ~= nil )then
			for i=1,#info.item_data.enchant.attrs do 
				table.insert(msg.info.item_data.enchant.attrs, info.item_data.enchant.attrs[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.item_data.enchant.extras ~= nil )then
			for i=1,#info.item_data.enchant.extras do 
				table.insert(msg.info.item_data.enchant.extras, info.item_data.enchant.extras[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.item_data.enchant.patch ~= nil )then
			for i=1,#info.item_data.enchant.patch do 
				table.insert(msg.info.item_data.enchant.patch, info.item_data.enchant.patch[i])
			end
		end
	end
	if(info.item_data.previewenchant ~= nil )then
		if(info.item_data.previewenchant.type ~= nil )then
			msg.info.item_data.previewenchant.type = info.item_data.previewenchant.type
		end
	end
	if(info ~= nil )then
		if(info.item_data.previewenchant.attrs ~= nil )then
			for i=1,#info.item_data.previewenchant.attrs do 
				table.insert(msg.info.item_data.previewenchant.attrs, info.item_data.previewenchant.attrs[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.item_data.previewenchant.extras ~= nil )then
			for i=1,#info.item_data.previewenchant.extras do 
				table.insert(msg.info.item_data.previewenchant.extras, info.item_data.previewenchant.extras[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.item_data.previewenchant.patch ~= nil )then
			for i=1,#info.item_data.previewenchant.patch do 
				table.insert(msg.info.item_data.previewenchant.patch, info.item_data.previewenchant.patch[i])
			end
		end
	end
	if(info.item_data.refine ~= nil )then
		if(info.item_data.refine.lastfail ~= nil )then
			msg.info.item_data.refine.lastfail = info.item_data.refine.lastfail
		end
	end
	if(info.item_data.refine ~= nil )then
		if(info.item_data.refine.repaircount ~= nil )then
			msg.info.item_data.refine.repaircount = info.item_data.refine.repaircount
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.exp ~= nil )then
			msg.info.item_data.egg.exp = info.item_data.egg.exp
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.friendexp ~= nil )then
			msg.info.item_data.egg.friendexp = info.item_data.egg.friendexp
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.rewardexp ~= nil )then
			msg.info.item_data.egg.rewardexp = info.item_data.egg.rewardexp
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.id ~= nil )then
			msg.info.item_data.egg.id = info.item_data.egg.id
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.lv ~= nil )then
			msg.info.item_data.egg.lv = info.item_data.egg.lv
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.friendlv ~= nil )then
			msg.info.item_data.egg.friendlv = info.item_data.egg.friendlv
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.body ~= nil )then
			msg.info.item_data.egg.body = info.item_data.egg.body
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.relivetime ~= nil )then
			msg.info.item_data.egg.relivetime = info.item_data.egg.relivetime
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.hp ~= nil )then
			msg.info.item_data.egg.hp = info.item_data.egg.hp
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.restoretime ~= nil )then
			msg.info.item_data.egg.restoretime = info.item_data.egg.restoretime
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.time_happly ~= nil )then
			msg.info.item_data.egg.time_happly = info.item_data.egg.time_happly
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.time_excite ~= nil )then
			msg.info.item_data.egg.time_excite = info.item_data.egg.time_excite
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.time_happiness ~= nil )then
			msg.info.item_data.egg.time_happiness = info.item_data.egg.time_happiness
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.time_happly_gift ~= nil )then
			msg.info.item_data.egg.time_happly_gift = info.item_data.egg.time_happly_gift
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.time_excite_gift ~= nil )then
			msg.info.item_data.egg.time_excite_gift = info.item_data.egg.time_excite_gift
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.time_happiness_gift ~= nil )then
			msg.info.item_data.egg.time_happiness_gift = info.item_data.egg.time_happiness_gift
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.touch_tick ~= nil )then
			msg.info.item_data.egg.touch_tick = info.item_data.egg.touch_tick
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.feed_tick ~= nil )then
			msg.info.item_data.egg.feed_tick = info.item_data.egg.feed_tick
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.name ~= nil )then
			msg.info.item_data.egg.name = info.item_data.egg.name
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.var ~= nil )then
			msg.info.item_data.egg.var = info.item_data.egg.var
		end
	end
	if(info ~= nil )then
		if(info.item_data.egg.skillids ~= nil )then
			for i=1,#info.item_data.egg.skillids do 
				table.insert(msg.info.item_data.egg.skillids, info.item_data.egg.skillids[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.item_data.egg.equips ~= nil )then
			for i=1,#info.item_data.egg.equips do 
				table.insert(msg.info.item_data.egg.equips, info.item_data.egg.equips[i])
			end
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.buff ~= nil )then
			msg.info.item_data.egg.buff = info.item_data.egg.buff
		end
	end
	if(info ~= nil )then
		if(info.item_data.egg.unlock_equip ~= nil )then
			for i=1,#info.item_data.egg.unlock_equip do 
				table.insert(msg.info.item_data.egg.unlock_equip, info.item_data.egg.unlock_equip[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.item_data.egg.unlock_body ~= nil )then
			for i=1,#info.item_data.egg.unlock_body do 
				table.insert(msg.info.item_data.egg.unlock_body, info.item_data.egg.unlock_body[i])
			end
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.version ~= nil )then
			msg.info.item_data.egg.version = info.item_data.egg.version
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.skilloff ~= nil )then
			msg.info.item_data.egg.skilloff = info.item_data.egg.skilloff
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.exchange_count ~= nil )then
			msg.info.item_data.egg.exchange_count = info.item_data.egg.exchange_count
		end
	end
	if(info.item_data.egg ~= nil )then
		if(info.item_data.egg.guid ~= nil )then
			msg.info.item_data.egg.guid = info.item_data.egg.guid
		end
	end
	if(info.item_data.letter ~= nil )then
		if(info.item_data.letter.sendUserName ~= nil )then
			msg.info.item_data.letter.sendUserName = info.item_data.letter.sendUserName
		end
	end
	if(info.item_data.letter ~= nil )then
		if(info.item_data.letter.bg ~= nil )then
			msg.info.item_data.letter.bg = info.item_data.letter.bg
		end
	end
	if(info.item_data.letter ~= nil )then
		if(info.item_data.letter.configID ~= nil )then
			msg.info.item_data.letter.configID = info.item_data.letter.configID
		end
	end
	if(info.item_data.letter ~= nil )then
		if(info.item_data.letter.content ~= nil )then
			msg.info.item_data.letter.content = info.item_data.letter.content
		end
	end
	if(info.item_data.letter ~= nil )then
		if(info.item_data.letter.content2 ~= nil )then
			msg.info.item_data.letter.content2 = info.item_data.letter.content2
		end
	end
	if(info.item_data.code ~= nil )then
		if(info.item_data.code.code ~= nil )then
			msg.info.item_data.code.code = info.item_data.code.code
		end
	end
	if(info.item_data.code ~= nil )then
		if(info.item_data.code.used ~= nil )then
			msg.info.item_data.code.used = info.item_data.code.used
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.id ~= nil )then
			msg.info.item_data.wedding.id = info.item_data.wedding.id
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.zoneid ~= nil )then
			msg.info.item_data.wedding.zoneid = info.item_data.wedding.zoneid
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.charid1 ~= nil )then
			msg.info.item_data.wedding.charid1 = info.item_data.wedding.charid1
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.charid2 ~= nil )then
			msg.info.item_data.wedding.charid2 = info.item_data.wedding.charid2
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.weddingtime ~= nil )then
			msg.info.item_data.wedding.weddingtime = info.item_data.wedding.weddingtime
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.photoidx ~= nil )then
			msg.info.item_data.wedding.photoidx = info.item_data.wedding.photoidx
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.phototime ~= nil )then
			msg.info.item_data.wedding.phototime = info.item_data.wedding.phototime
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.myname ~= nil )then
			msg.info.item_data.wedding.myname = info.item_data.wedding.myname
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.partnername ~= nil )then
			msg.info.item_data.wedding.partnername = info.item_data.wedding.partnername
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.starttime ~= nil )then
			msg.info.item_data.wedding.starttime = info.item_data.wedding.starttime
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.endtime ~= nil )then
			msg.info.item_data.wedding.endtime = info.item_data.wedding.endtime
		end
	end
	if(info.item_data.wedding ~= nil )then
		if(info.item_data.wedding.notified ~= nil )then
			msg.info.item_data.wedding.notified = info.item_data.wedding.notified
		end
	end
	if(info.item_data.sender ~= nil )then
		if(info.item_data.sender.charid ~= nil )then
			msg.info.item_data.sender.charid = info.item_data.sender.charid
		end
	end
	if(info.item_data.sender ~= nil )then
		if(info.item_data.sender.name ~= nil )then
			msg.info.item_data.sender.name = info.item_data.sender.name
		end
	end
	if(info ~= nil )then
		if(info.publicity_id ~= nil )then
			msg.info.publicity_id = info.publicity_id
		end
	end
	if(info ~= nil )then
		if(info.end_time ~= nil )then
			msg.info.end_time = info.end_time
		end
	end
	if(info ~= nil )then
		if(info.key ~= nil )then
			msg.info.key = info.key
		end
	end
	if(info ~= nil )then
		if(info.charid ~= nil )then
			msg.info.charid = info.charid
		end
	end
	if(info ~= nil )then
		if(info.name ~= nil )then
			msg.info.name = info.name
		end
	end
	if(info ~= nil )then
		if(info.type ~= nil )then
			msg.info.type = info.type
		end
	end
	if(info ~= nil )then
		if(info.up_rate ~= nil )then
			msg.info.up_rate = info.up_rate
		end
	end
	if(info ~= nil )then
		if(info.down_rate ~= nil )then
			msg.info.down_rate = info.down_rate
		end
	end
	if(type ~= nil )then
		msg.type = type
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceRecordTradeAutoProxy:RecvBriefPendingListRecordTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeBriefPendingListRecordTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvDetailPendingListRecordTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeDetailPendingListRecordTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvItemSellInfoRecordTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeItemSellInfoRecordTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvMyPendingListRecordTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeMyPendingListRecordTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvMyTradeLogRecordTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeMyTradeLogRecordTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvTakeLogCmd(data) 
	self:Notify(ServiceEvent.RecordTradeTakeLogCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvAddNewLog(data) 
	self:Notify(ServiceEvent.RecordTradeAddNewLog, data)
end

function ServiceRecordTradeAutoProxy:RecvFetchNameInfoCmd(data) 
	self:Notify(ServiceEvent.RecordTradeFetchNameInfoCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvReqServerPriceRecordTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeReqServerPriceRecordTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvBuyItemRecordTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeBuyItemRecordTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvSellItemRecordTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeSellItemRecordTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvCancelItemRecordTrade(data) 
	self:Notify(ServiceEvent.RecordTradeCancelItemRecordTrade, data)
end

function ServiceRecordTradeAutoProxy:RecvResellPendingRecordTrade(data) 
	self:Notify(ServiceEvent.RecordTradeResellPendingRecordTrade, data)
end

function ServiceRecordTradeAutoProxy:RecvPanelRecordTrade(data) 
	self:Notify(ServiceEvent.RecordTradePanelRecordTrade, data)
end

function ServiceRecordTradeAutoProxy:RecvListNtfRecordTrade(data) 
	self:Notify(ServiceEvent.RecordTradeListNtfRecordTrade, data)
end

function ServiceRecordTradeAutoProxy:RecvHotItemidRecordTrade(data) 
	self:Notify(ServiceEvent.RecordTradeHotItemidRecordTrade, data)
end

function ServiceRecordTradeAutoProxy:RecvNtfCanTakeCountTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeNtfCanTakeCountTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvGiveTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeGiveTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvAcceptTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeAcceptTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvRefuseTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeRefuseTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvReqGiveItemInfoCmd(data) 
	self:Notify(ServiceEvent.RecordTradeReqGiveItemInfoCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvCheckPackageSizeTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeCheckPackageSizeTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvQucikTakeLogTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeQucikTakeLogTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvQueryItemCountTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeQueryItemCountTradeCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvLotteryGiveCmd(data) 
	self:Notify(ServiceEvent.RecordTradeLotteryGiveCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvTodayFinanceRank(data) 
	self:Notify(ServiceEvent.RecordTradeTodayFinanceRank, data)
end

function ServiceRecordTradeAutoProxy:RecvTodayFinanceDetail(data) 
	self:Notify(ServiceEvent.RecordTradeTodayFinanceDetail, data)
end

function ServiceRecordTradeAutoProxy:RecvBoothPlayerPendingListCmd(data) 
	self:Notify(ServiceEvent.RecordTradeBoothPlayerPendingListCmd, data)
end

function ServiceRecordTradeAutoProxy:RecvUpdateOrderTradeCmd(data) 
	self:Notify(ServiceEvent.RecordTradeUpdateOrderTradeCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.RecordTradeBriefPendingListRecordTradeCmd = "ServiceEvent_RecordTradeBriefPendingListRecordTradeCmd"
ServiceEvent.RecordTradeDetailPendingListRecordTradeCmd = "ServiceEvent_RecordTradeDetailPendingListRecordTradeCmd"
ServiceEvent.RecordTradeItemSellInfoRecordTradeCmd = "ServiceEvent_RecordTradeItemSellInfoRecordTradeCmd"
ServiceEvent.RecordTradeMyPendingListRecordTradeCmd = "ServiceEvent_RecordTradeMyPendingListRecordTradeCmd"
ServiceEvent.RecordTradeMyTradeLogRecordTradeCmd = "ServiceEvent_RecordTradeMyTradeLogRecordTradeCmd"
ServiceEvent.RecordTradeTakeLogCmd = "ServiceEvent_RecordTradeTakeLogCmd"
ServiceEvent.RecordTradeAddNewLog = "ServiceEvent_RecordTradeAddNewLog"
ServiceEvent.RecordTradeFetchNameInfoCmd = "ServiceEvent_RecordTradeFetchNameInfoCmd"
ServiceEvent.RecordTradeReqServerPriceRecordTradeCmd = "ServiceEvent_RecordTradeReqServerPriceRecordTradeCmd"
ServiceEvent.RecordTradeBuyItemRecordTradeCmd = "ServiceEvent_RecordTradeBuyItemRecordTradeCmd"
ServiceEvent.RecordTradeSellItemRecordTradeCmd = "ServiceEvent_RecordTradeSellItemRecordTradeCmd"
ServiceEvent.RecordTradeCancelItemRecordTrade = "ServiceEvent_RecordTradeCancelItemRecordTrade"
ServiceEvent.RecordTradeResellPendingRecordTrade = "ServiceEvent_RecordTradeResellPendingRecordTrade"
ServiceEvent.RecordTradePanelRecordTrade = "ServiceEvent_RecordTradePanelRecordTrade"
ServiceEvent.RecordTradeListNtfRecordTrade = "ServiceEvent_RecordTradeListNtfRecordTrade"
ServiceEvent.RecordTradeHotItemidRecordTrade = "ServiceEvent_RecordTradeHotItemidRecordTrade"
ServiceEvent.RecordTradeNtfCanTakeCountTradeCmd = "ServiceEvent_RecordTradeNtfCanTakeCountTradeCmd"
ServiceEvent.RecordTradeGiveTradeCmd = "ServiceEvent_RecordTradeGiveTradeCmd"
ServiceEvent.RecordTradeAcceptTradeCmd = "ServiceEvent_RecordTradeAcceptTradeCmd"
ServiceEvent.RecordTradeRefuseTradeCmd = "ServiceEvent_RecordTradeRefuseTradeCmd"
ServiceEvent.RecordTradeReqGiveItemInfoCmd = "ServiceEvent_RecordTradeReqGiveItemInfoCmd"
ServiceEvent.RecordTradeCheckPackageSizeTradeCmd = "ServiceEvent_RecordTradeCheckPackageSizeTradeCmd"
ServiceEvent.RecordTradeQucikTakeLogTradeCmd = "ServiceEvent_RecordTradeQucikTakeLogTradeCmd"
ServiceEvent.RecordTradeQueryItemCountTradeCmd = "ServiceEvent_RecordTradeQueryItemCountTradeCmd"
ServiceEvent.RecordTradeLotteryGiveCmd = "ServiceEvent_RecordTradeLotteryGiveCmd"
ServiceEvent.RecordTradeTodayFinanceRank = "ServiceEvent_RecordTradeTodayFinanceRank"
ServiceEvent.RecordTradeTodayFinanceDetail = "ServiceEvent_RecordTradeTodayFinanceDetail"
ServiceEvent.RecordTradeBoothPlayerPendingListCmd = "ServiceEvent_RecordTradeBoothPlayerPendingListCmd"
ServiceEvent.RecordTradeUpdateOrderTradeCmd = "ServiceEvent_RecordTradeUpdateOrderTradeCmd"
