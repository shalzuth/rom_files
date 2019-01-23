autoImport("ExchangeBriefBuyData")

ExchangeIntroduceData = class("ExchangeIntroduceData")

function ExchangeIntroduceData:ctor(data)
	self:SetData(data)
end

function ExchangeIntroduceData:SetData(data)
	if data ~= nil then
		if data.itemData and data.itemData.base and data.itemData.base.id ~= 0 then
			self.itemData = ItemData.new(data.itemData.base.guid, data.itemData.base.id)
			self.itemData:ParseFromServerData(data.itemData)
		end
		self.price = data.price
		self.type = data.statetype
		self.count = data.count
		self.buyerCount = data.buyer_count
		self.endTime = data.end_time

		self.buyInfo = data.buy_info
		if data.buy_info then
			self.buyInfo = {}
			for i=1,#data.buy_info do
				local briefBuyInfo = ExchangeBriefBuyData.new(data.buy_info[i])
				TableUtility.ArrayPushBack(self.buyInfo , briefBuyInfo)
			end
		end
	end
end

function ExchangeIntroduceData:SetPriceRate(priceRate)
	self.priceRate = priceRate
end

function ExchangeIntroduceData:SetExchangeType(exchangeType)
	self.exchangeType = exchangeType
end

function ExchangeIntroduceData:SetCount(count)
	self.count = count
end

function ExchangeIntroduceData:SetQuota(quota)
	self.quota = quota
end

function ExchangeIntroduceData:SetBuyerCount(buyerCount)
	self.buyerCount = buyerCount
end

-- 摆摊
function ExchangeIntroduceData:SetBoothInfo(data)
	self.boothName = data.name
	self.endTime = data.endTime
	self.itemid = data.itemid
end

function ExchangeIntroduceData:GetPrice()
	if self.price ~= nil and self.priceRate ~= nil then
		return self.price * self.priceRate
	end

	return self.price
end

function ExchangeIntroduceData:GetQuota()
	local count = self.count or 1
	if self.quota ~= nil then
		return BoothProxy.Instance:GetValidQuota(self.quota * count)
	end
end

function ExchangeIntroduceData:GetItemId()
	return self.itemData and self.itemData.staticData.id or self.itemid
end