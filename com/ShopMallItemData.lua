ShopMallItemData = class("ShopMallItemData")

function ShopMallItemData:ctor(data)
	self:SetData(data)
end

function ShopMallItemData:SetData(data)
	self.itemid = data.itemid
	self.price = data.price
	self.count = data.count
	self.orderId = data.order_id
	self.overlap = data.overlap
	self.isExpired = data.is_expired
	if data.refine_lv then
		self.refineLv = data.refine_lv
	end
	if data.item_data and data.item_data.base and data.item_data.base.id ~= 0 then
		self.itemData = ItemData.new(data.item_data.base.guid , data.item_data.base.id)
		self.itemData:ParseFromServerData(data.item_data)

		local equip = data.item_data.equip
		if equip ~= nil then
			self.refineLv = equip.refinelv
		end
	end
	self.publicityId = data.publicity_id
	self.endTime = data.end_time

	-- 摆摊
	self.charid = data.charid
	self.name = data.name
	self.type = data.type
	self.isBooth = data.type == BoothProxy.TradeType.Booth
	self.upRate = data.up_rate
	self.downRate = data.down_rate

	self:UpdateItemData()
end

function ShopMallItemData:CanExchange()
	if self.itemid then
		return ItemData.CheckItemCanTrade(self.itemid)
	end

	return false
end

function ShopMallItemData:UpdateItemData()
	if self.itemData ~= nil then
		self.itemData.num = self.count
		if self.refineLv and self.itemData.equipInfo then
			self.itemData.equipInfo.refinelv = self.refineLv
		end
	end
end

function ShopMallItemData:GetItemData()
	if self.itemData == nil then
		self.itemData = ItemData.new("Booth", self.itemid)
		self:UpdateItemData()
	end
	return self.itemData
end

function ShopMallItemData:GetPriceRate()
	return 1 + self.upRate / 1000 - self.downRate / 1000
end

function ShopMallItemData:GetPrice()
	return self.isBooth and self.price * self:GetPriceRate() or self.price
end