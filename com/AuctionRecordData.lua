AuctionRecordData = class("AuctionRecordData")

function AuctionRecordData:ctor(data)
	self:SetData(data)
end

function AuctionRecordData:SetData(data)
	if data then
		self.id = data.id
		self.type = data.type
		self.status = data.take_status
		self.itemid = data.itemid
		self.price = data.price
		self.seller = data.seller
		self.buyer = data.buyer
		self.zoneid = data.zoneid
		self.costMoney = data.cost_money
		self.getMoney = data.get_money
		self.tax = data.tax
		self.batchid = data.batchid
		self.time = data.time
	end
end

function AuctionRecordData:SetStatus(status)
	self.status = status
end

function AuctionRecordData:CanReceive()
	return self.status == AuctionRecordTakeState.CanTake
end

function AuctionRecordData:GetItemString()
	if self.itemString == nil then
		self.itemString = ""
		local itemData = Table_Item[self.itemid]
		if itemData then
			local iconInfo = string.format("{itemicon=%s}",self.itemid)
			local itemName = itemData.NameZh

			self.itemString = iconInfo..itemName
		end
	end

	return self.itemString
end

function AuctionRecordData:GetZoneid()
	if self.zoneid then
		local zoneid = self.zoneid % 10000
		return ChangeZoneProxy.Instance:ZoneNumToString(zoneid)
	end

	return 0
end