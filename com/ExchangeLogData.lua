autoImport("ExchangeLogNameData")

ExchangeLogData = class("ExchangeLogData")

ExchangeLogData.ReceiveEnum = {
	Money = 0,
	Goods = 1,
	All = 2,
}

function ExchangeLogData:ctor(data)
	self:SetData(data)
end

function ExchangeLogData:SetData(data)
	self.id = data.id
	self.status = data.status	--领取装备
	self.type = data.logtype	--日志类型
	self.itemid = data.itemid
	self.refineLv = data.refine_lv	--精炼等级
	self.damage = data.damage	--是否损坏
	self.tradetime = data.tradetime	--交易时间
	self.count = data.count 	--成功的个数
	self.price = data.price		--单价
	self.tax = data.tax		--出售扣费
	self.getmoney = data.getmoney	--出售获得的总钱
	self.costmoney = data.costmoney	--购买花费
	self.failcount = data.failcount	--公示期购买失败的个数
	self.retmoney = data.retmoney	--公示期抢购退款
	self.totalcount = data.totalcount	--公示期总抢购个数
	self.endtime = data.endtime		--公示期结束时间

	if data.name_info then
		----[[ todo xde 不翻译玩家名字
		data.name_info.name = AppendSpace2Str(data.name_info.name)
		--]]
		self.nameInfo = ExchangeLogNameData.new(data.name_info)	--一个名字
	end
	self.isManyPeople = data.is_many_people	--是否有多人
	self.receiverid = data.receiverid 		--赠送接收者id
	self.receivername = data.receivername	--赠送接受者姓名
	----[[ todo xde 不翻译玩家名字
	self.receivername = AppendSpace2Str(self.receivername)
	--]]
	self.receiverzoneid = data.receiverzoneid	--赠送接收者线
	self.quota = data.quota					--赠送花费额度
	self.background = data.background				--赠送背景色
	self.cangive = data.cangive				--是否可以赠送

	if data.itemdata and data.itemdata.base and data.itemdata.base.id ~= 0 then
		self.itemData = ItemData.new(data.itemdata.base.guid , data.itemdata.base.id)
		self.itemData:ParseFromServerData(data.itemdata)
	else
		self.itemData = ItemData.new("ExchangeLog", self.itemid)
	end
	self.itemData.num = data.count

	--判断领取金额或商品
	if self.type == ShopMallLogTypeEnum.NormalSell or self.type == ShopMallLogTypeEnum.PublicitySellSuccess then
		self.receiveEnum = self.ReceiveEnum.Money
	elseif self.type == ShopMallLogTypeEnum.NormalBuy then
		self.receiveEnum = self.ReceiveEnum.Goods
	elseif self.type == ShopMallLogTypeEnum.PublicityBuySuccess then
		self.receiveEnum = self.ReceiveEnum.Goods
	elseif self.type == ShopMallLogTypeEnum.PublicityBuyFail then
		self.receiveEnum = self.ReceiveEnum.Money
	elseif self.type == ShopMallLogTypeEnum.AutoOff then
		self.receiveEnum = self.ReceiveEnum.All
	end

	self.tradeType = data.trade_type
	self.quotaCost = data.quota_cost
end

function ExchangeLogData:SetStatus(status)
	self.status = status
end

function ExchangeLogData:GetRefineLvString()
	if self.refineLv and self.refineLv > 0 then
		return "+"..self.refineLv
	end
	return ""
end

function ExchangeLogData:GetCount()
	return self.count or 0
end

function ExchangeLogData:GetTax()
	return self.tax or 0
end

function ExchangeLogData:GetGetmoney()
	return self.getmoney or 0
end

function ExchangeLogData:GetCostmoney()
	return self.costmoney or 0
end

function ExchangeLogData:GetFailcount()
	return self.failcount or 0
end

function ExchangeLogData:GetRetmoney()
	return self.retmoney or 0
end

function ExchangeLogData:GetTotalcount()
	return self.totalcount or 0
end

function ExchangeLogData:CanReceive()
	return self.type ~= ShopMallLogTypeEnum.PublicityBuying and self.status == ShopMallLogReceiveEnum.ReceiveGive
end

function ExchangeLogData:GetExchangeFirstNameData()
	return self.nameInfo
end

function ExchangeLogData:IsManyPeople()
	return self.isManyPeople or false
end

function ExchangeLogData:GetReceiverName()
	return self.receivername or ""
end

function ExchangeLogData:GetReceiverZoneid()
	if self.receiverzoneid then
		local zoneid = self.receiverzoneid % 10000
		return ChangeZoneProxy.Instance:ZoneNumToString(zoneid)
	end

	return 0
end

function ExchangeLogData:GetBg()
	return self.background or 0
end

function ExchangeLogData:GetItemData()
	return self.itemData
end

function ExchangeLogData:GetTotalQuota()
	return self.quotaCost * self.count
end