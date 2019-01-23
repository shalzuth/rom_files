ServiceAuctionCCmdAutoProxy = class('ServiceAuctionCCmdAutoProxy', ServiceProxy)

ServiceAuctionCCmdAutoProxy.Instance = nil

ServiceAuctionCCmdAutoProxy.NAME = 'ServiceAuctionCCmdAutoProxy'

function ServiceAuctionCCmdAutoProxy:ctor(proxyName)
	if ServiceAuctionCCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceAuctionCCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceAuctionCCmdAutoProxy.Instance = self
	end
end

function ServiceAuctionCCmdAutoProxy:Init()
end

function ServiceAuctionCCmdAutoProxy:onRegister()
	self:Listen(63, 1, function (data)
		self:RecvNtfAuctionStateCCmd(data) 
	end)
	self:Listen(63, 2, function (data)
		self:RecvOpenAuctionPanelCCmd(data) 
	end)
	self:Listen(63, 3, function (data)
		self:RecvNtfSignUpInfoCCmd(data) 
	end)
	self:Listen(63, 14, function (data)
		self:RecvNtfMySignUpInfoCCmd(data) 
	end)
	self:Listen(63, 12, function (data)
		self:RecvSignUpItemCCmd(data) 
	end)
	self:Listen(63, 4, function (data)
		self:RecvNtfAuctionInfoCCmd(data) 
	end)
	self:Listen(63, 5, function (data)
		self:RecvUpdateAuctionInfoCCmd(data) 
	end)
	self:Listen(63, 6, function (data)
		self:RecvReqAuctionFlowingWaterCCmd(data) 
	end)
	self:Listen(63, 7, function (data)
		self:RecvUpdateAuctionFlowingWaterCCmd(data) 
	end)
	self:Listen(63, 8, function (data)
		self:RecvReqLastAuctionInfoCCmd(data) 
	end)
	self:Listen(63, 9, function (data)
		self:RecvOfferPriceCCmd(data) 
	end)
	self:Listen(63, 10, function (data)
		self:RecvReqAuctionRecordCCmd(data) 
	end)
	self:Listen(63, 11, function (data)
		self:RecvTakeAuctionRecordCCmd(data) 
	end)
	self:Listen(63, 13, function (data)
		self:RecvNtfCanTakeCntCCmd(data) 
	end)
	self:Listen(63, 15, function (data)
		self:RecvNtfMyOfferPriceCCmd(data) 
	end)
	self:Listen(63, 16, function (data)
		self:RecvNtfNextAuctionInfoCCmd(data) 
	end)
	self:Listen(63, 17, function (data)
		self:RecvReqAuctionInfoCCmd(data) 
	end)
	self:Listen(63, 18, function (data)
		self:RecvNtfCurAuctionInfoCCmd(data) 
	end)
	self:Listen(63, 19, function (data)
		self:RecvNtfOverTakePriceCCmd(data) 
	end)
	self:Listen(63, 20, function (data)
		self:RecvReqMyTradedPriceCCmd(data) 
	end)
	self:Listen(63, 21, function (data)
		self:RecvNtfMaskPriceCCmd(data) 
	end)
	self:Listen(63, 22, function (data)
		self:RecvAuctionDialogCCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceAuctionCCmdAutoProxy:CallNtfAuctionStateCCmd(state, batchid, auctiontime, delay) 
	local msg = AuctionCCmd_pb.NtfAuctionStateCCmd()
	if(state ~= nil )then
		msg.state = state
	end
	if(batchid ~= nil )then
		msg.batchid = batchid
	end
	if(auctiontime ~= nil )then
		msg.auctiontime = auctiontime
	end
	if(delay ~= nil )then
		msg.delay = delay
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallOpenAuctionPanelCCmd(open) 
	local msg = AuctionCCmd_pb.OpenAuctionPanelCCmd()
	if(open ~= nil )then
		msg.open = open
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallNtfSignUpInfoCCmd(iteminfos) 
	local msg = AuctionCCmd_pb.NtfSignUpInfoCCmd()
	if( iteminfos ~= nil )then
		for i=1,#iteminfos do 
			table.insert(msg.iteminfos, iteminfos[i])
		end
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallNtfMySignUpInfoCCmd(signuped) 
	local msg = AuctionCCmd_pb.NtfMySignUpInfoCCmd()
	if( signuped ~= nil )then
		for i=1,#signuped do 
			table.insert(msg.signuped, signuped[i])
		end
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallSignUpItemCCmd(iteminfo, ret, guid) 
	local msg = AuctionCCmd_pb.SignUpItemCCmd()
	if(iteminfo ~= nil )then
		if(iteminfo.itemid ~= nil )then
			msg.iteminfo.itemid = iteminfo.itemid
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.price ~= nil )then
			msg.iteminfo.price = iteminfo.price
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.auction ~= nil )then
			msg.iteminfo.auction = iteminfo.auction
		end
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	if(guid ~= nil )then
		msg.guid = guid
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallNtfAuctionInfoCCmd(iteminfos, batchid) 
	local msg = AuctionCCmd_pb.NtfAuctionInfoCCmd()
	if( iteminfos ~= nil )then
		for i=1,#iteminfos do 
			table.insert(msg.iteminfos, iteminfos[i])
		end
	end
	if(batchid ~= nil )then
		msg.batchid = batchid
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallUpdateAuctionInfoCCmd(iteminfo, batchid) 
	local msg = AuctionCCmd_pb.UpdateAuctionInfoCCmd()
	if(iteminfo ~= nil )then
		if(iteminfo.itemid ~= nil )then
			msg.iteminfo.itemid = iteminfo.itemid
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.price ~= nil )then
			msg.iteminfo.price = iteminfo.price
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.seller ~= nil )then
			msg.iteminfo.seller = iteminfo.seller
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.sellerid ~= nil )then
			msg.iteminfo.sellerid = iteminfo.sellerid
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.result ~= nil )then
			msg.iteminfo.result = iteminfo.result
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.people_cnt ~= nil )then
			msg.iteminfo.people_cnt = iteminfo.people_cnt
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.trade_price ~= nil )then
			msg.iteminfo.trade_price = iteminfo.trade_price
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.auction_time ~= nil )then
			msg.iteminfo.auction_time = iteminfo.auction_time
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.my_price ~= nil )then
			msg.iteminfo.my_price = iteminfo.my_price
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.cur_price ~= nil )then
			msg.iteminfo.cur_price = iteminfo.cur_price
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.mask_price ~= nil )then
			msg.iteminfo.mask_price = iteminfo.mask_price
		end
	end
	if(iteminfo ~= nil )then
		if(iteminfo.signup_id ~= nil )then
			msg.iteminfo.signup_id = iteminfo.signup_id
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
	if(batchid ~= nil )then
		msg.batchid = batchid
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallReqAuctionFlowingWaterCCmd(batchid, itemid, page_index, flowingwater, signup_id) 
	local msg = AuctionCCmd_pb.ReqAuctionFlowingWaterCCmd()
	if(batchid ~= nil )then
		msg.batchid = batchid
	end
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	if(page_index ~= nil )then
		msg.page_index = page_index
	end
	if( flowingwater ~= nil )then
		for i=1,#flowingwater do 
			table.insert(msg.flowingwater, flowingwater[i])
		end
	end
	if(signup_id ~= nil )then
		msg.signup_id = signup_id
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallUpdateAuctionFlowingWaterCCmd(batchid, itemid, flowingwater, signup_id) 
	local msg = AuctionCCmd_pb.UpdateAuctionFlowingWaterCCmd()
	if(batchid ~= nil )then
		msg.batchid = batchid
	end
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	if(flowingwater ~= nil )then
		if(flowingwater.time ~= nil )then
			msg.flowingwater.time = flowingwater.time
		end
	end
	if(flowingwater ~= nil )then
		if(flowingwater.event ~= nil )then
			msg.flowingwater.event = flowingwater.event
		end
	end
	if(flowingwater ~= nil )then
		if(flowingwater.price ~= nil )then
			msg.flowingwater.price = flowingwater.price
		end
	end
	if(flowingwater ~= nil )then
		if(flowingwater.player_name ~= nil )then
			msg.flowingwater.player_name = flowingwater.player_name
		end
	end
	if(flowingwater ~= nil )then
		if(flowingwater.zoneid ~= nil )then
			msg.flowingwater.zoneid = flowingwater.zoneid
		end
	end
	if(flowingwater ~= nil )then
		if(flowingwater.max_price ~= nil )then
			msg.flowingwater.max_price = flowingwater.max_price
		end
	end
	if(flowingwater ~= nil )then
		if(flowingwater.player_id ~= nil )then
			msg.flowingwater.player_id = flowingwater.player_id
		end
	end
	if(signup_id ~= nil )then
		msg.signup_id = signup_id
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallReqLastAuctionInfoCCmd() 
	local msg = AuctionCCmd_pb.ReqLastAuctionInfoCCmd()
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallOfferPriceCCmd(itemid, max_price, add_price, level, signup_id) 
	local msg = AuctionCCmd_pb.OfferPriceCCmd()
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	if(max_price ~= nil )then
		msg.max_price = max_price
	end
	if(add_price ~= nil )then
		msg.add_price = add_price
	end
	if(level ~= nil )then
		msg.level = level
	end
	if(signup_id ~= nil )then
		msg.signup_id = signup_id
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallReqAuctionRecordCCmd(index, total_page_cnt, records) 
	local msg = AuctionCCmd_pb.ReqAuctionRecordCCmd()
	if(index ~= nil )then
		msg.index = index
	end
	if(total_page_cnt ~= nil )then
		msg.total_page_cnt = total_page_cnt
	end
	if( records ~= nil )then
		for i=1,#records do 
			table.insert(msg.records, records[i])
		end
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallTakeAuctionRecordCCmd(id, type, ret) 
	local msg = AuctionCCmd_pb.TakeAuctionRecordCCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallNtfCanTakeCntCCmd(count) 
	local msg = AuctionCCmd_pb.NtfCanTakeCntCCmd()
	if(count ~= nil )then
		msg.count = count
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallNtfMyOfferPriceCCmd(batchid, itemid, my_price, signup_id) 
	local msg = AuctionCCmd_pb.NtfMyOfferPriceCCmd()
	if(batchid ~= nil )then
		msg.batchid = batchid
	end
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	if(my_price ~= nil )then
		msg.my_price = my_price
	end
	if(signup_id ~= nil )then
		msg.signup_id = signup_id
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallNtfNextAuctionInfoCCmd(batchid, itemid, last_itemid, base_price, start_time, signup_id, last_signup_id) 
	local msg = AuctionCCmd_pb.NtfNextAuctionInfoCCmd()
	if(batchid ~= nil )then
		msg.batchid = batchid
	end
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	if(last_itemid ~= nil )then
		msg.last_itemid = last_itemid
	end
	if(base_price ~= nil )then
		msg.base_price = base_price
	end
	if(start_time ~= nil )then
		msg.start_time = start_time
	end
	if(signup_id ~= nil )then
		msg.signup_id = signup_id
	end
	if(last_signup_id ~= nil )then
		msg.last_signup_id = last_signup_id
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallReqAuctionInfoCCmd() 
	local msg = AuctionCCmd_pb.ReqAuctionInfoCCmd()
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallNtfCurAuctionInfoCCmd(itemid) 
	local msg = AuctionCCmd_pb.NtfCurAuctionInfoCCmd()
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallNtfOverTakePriceCCmd() 
	local msg = AuctionCCmd_pb.NtfOverTakePriceCCmd()
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallReqMyTradedPriceCCmd(batchid, itemid, my_price, signup_id) 
	local msg = AuctionCCmd_pb.ReqMyTradedPriceCCmd()
	if(batchid ~= nil )then
		msg.batchid = batchid
	end
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	if(my_price ~= nil )then
		msg.my_price = my_price
	end
	if(signup_id ~= nil )then
		msg.signup_id = signup_id
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallNtfMaskPriceCCmd(batchid, itemid, mask_price, signup_id) 
	local msg = AuctionCCmd_pb.NtfMaskPriceCCmd()
	if(batchid ~= nil )then
		msg.batchid = batchid
	end
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	if(mask_price ~= nil )then
		msg.mask_price = mask_price
	end
	if(signup_id ~= nil )then
		msg.signup_id = signup_id
	end
	self:SendProto(msg)
end

function ServiceAuctionCCmdAutoProxy:CallAuctionDialogCCmd(type, msg_id, params) 
	local msg = AuctionCCmd_pb.AuctionDialogCCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(msg_id ~= nil )then
		msg.msg_id = msg_id
	end
	if( params ~= nil )then
		for i=1,#params do 
			table.insert(msg.params, params[i])
		end
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceAuctionCCmdAutoProxy:RecvNtfAuctionStateCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdNtfAuctionStateCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvOpenAuctionPanelCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdOpenAuctionPanelCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfSignUpInfoCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdNtfSignUpInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfMySignUpInfoCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdNtfMySignUpInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvSignUpItemCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdSignUpItemCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfAuctionInfoCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdNtfAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvUpdateAuctionInfoCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdUpdateAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvReqAuctionFlowingWaterCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdReqAuctionFlowingWaterCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvUpdateAuctionFlowingWaterCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdUpdateAuctionFlowingWaterCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvReqLastAuctionInfoCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdReqLastAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvOfferPriceCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdOfferPriceCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvReqAuctionRecordCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdReqAuctionRecordCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvTakeAuctionRecordCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdTakeAuctionRecordCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfCanTakeCntCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdNtfCanTakeCntCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfMyOfferPriceCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdNtfMyOfferPriceCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfNextAuctionInfoCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdNtfNextAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvReqAuctionInfoCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdReqAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfCurAuctionInfoCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdNtfCurAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfOverTakePriceCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdNtfOverTakePriceCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvReqMyTradedPriceCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdReqMyTradedPriceCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfMaskPriceCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdNtfMaskPriceCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvAuctionDialogCCmd(data) 
	self:Notify(ServiceEvent.AuctionCCmdAuctionDialogCCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.AuctionCCmdNtfAuctionStateCCmd = "ServiceEvent_AuctionCCmdNtfAuctionStateCCmd"
ServiceEvent.AuctionCCmdOpenAuctionPanelCCmd = "ServiceEvent_AuctionCCmdOpenAuctionPanelCCmd"
ServiceEvent.AuctionCCmdNtfSignUpInfoCCmd = "ServiceEvent_AuctionCCmdNtfSignUpInfoCCmd"
ServiceEvent.AuctionCCmdNtfMySignUpInfoCCmd = "ServiceEvent_AuctionCCmdNtfMySignUpInfoCCmd"
ServiceEvent.AuctionCCmdSignUpItemCCmd = "ServiceEvent_AuctionCCmdSignUpItemCCmd"
ServiceEvent.AuctionCCmdNtfAuctionInfoCCmd = "ServiceEvent_AuctionCCmdNtfAuctionInfoCCmd"
ServiceEvent.AuctionCCmdUpdateAuctionInfoCCmd = "ServiceEvent_AuctionCCmdUpdateAuctionInfoCCmd"
ServiceEvent.AuctionCCmdReqAuctionFlowingWaterCCmd = "ServiceEvent_AuctionCCmdReqAuctionFlowingWaterCCmd"
ServiceEvent.AuctionCCmdUpdateAuctionFlowingWaterCCmd = "ServiceEvent_AuctionCCmdUpdateAuctionFlowingWaterCCmd"
ServiceEvent.AuctionCCmdReqLastAuctionInfoCCmd = "ServiceEvent_AuctionCCmdReqLastAuctionInfoCCmd"
ServiceEvent.AuctionCCmdOfferPriceCCmd = "ServiceEvent_AuctionCCmdOfferPriceCCmd"
ServiceEvent.AuctionCCmdReqAuctionRecordCCmd = "ServiceEvent_AuctionCCmdReqAuctionRecordCCmd"
ServiceEvent.AuctionCCmdTakeAuctionRecordCCmd = "ServiceEvent_AuctionCCmdTakeAuctionRecordCCmd"
ServiceEvent.AuctionCCmdNtfCanTakeCntCCmd = "ServiceEvent_AuctionCCmdNtfCanTakeCntCCmd"
ServiceEvent.AuctionCCmdNtfMyOfferPriceCCmd = "ServiceEvent_AuctionCCmdNtfMyOfferPriceCCmd"
ServiceEvent.AuctionCCmdNtfNextAuctionInfoCCmd = "ServiceEvent_AuctionCCmdNtfNextAuctionInfoCCmd"
ServiceEvent.AuctionCCmdReqAuctionInfoCCmd = "ServiceEvent_AuctionCCmdReqAuctionInfoCCmd"
ServiceEvent.AuctionCCmdNtfCurAuctionInfoCCmd = "ServiceEvent_AuctionCCmdNtfCurAuctionInfoCCmd"
ServiceEvent.AuctionCCmdNtfOverTakePriceCCmd = "ServiceEvent_AuctionCCmdNtfOverTakePriceCCmd"
ServiceEvent.AuctionCCmdReqMyTradedPriceCCmd = "ServiceEvent_AuctionCCmdReqMyTradedPriceCCmd"
ServiceEvent.AuctionCCmdNtfMaskPriceCCmd = "ServiceEvent_AuctionCCmdNtfMaskPriceCCmd"
ServiceEvent.AuctionCCmdAuctionDialogCCmd = "ServiceEvent_AuctionCCmdAuctionDialogCCmd"
