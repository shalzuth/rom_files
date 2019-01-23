AuctionEventData = reusableClass("AuctionEventData")
AuctionEventData.PoolSize = 50

function AuctionEventData:SetData(data)
	if data then
		self.time = data.time
		self.event = data.event
		self.price = data.price
		self.playerName = data.player_name
		self.playerid = data.player_id
		self.zoneid = data.zoneid
		self.maxPrice = data.max_price
	end
end

function AuctionEventData:SetInfo(batchid, itemid)
	self.batchid = batchid
	self.itemid = itemid
	self.itemName = ""
	local itemData = Table_Item[itemid]
	if itemData then
		self.itemName = itemData.NameZh
	end
end

function AuctionEventData:GetTimeString()
	if self.timeString == nil then
		local time = os.date("*t", self.time or 0)
		self.timeString = string.format("%02d:%02d:%02d", time.hour, time.min, time.sec)
	end

	return self.timeString
end

function AuctionEventData:GetContent()
	if self.content == nil then
		self.content = ""
		if self.event then
			if self.event == AuctionEventState.Start then
				self.content = string.format(ZhString.Auction_EventStart, self.itemName, self:GetPriceString())

			elseif self.event == AuctionEventState.OfferPrice then
				self.content = string.format(ZhString.Auction_EventOfferPrice, self.playerid, self.playerName, self:GetZoneString(), self:GetPriceString())

			elseif self.event == AuctionEventState.Result1 then
				self.content = string.format(ZhString.Auction_EventResult1, self.playerid, self.playerName, self:GetZoneString())

			elseif self.event == AuctionEventState.Result2 then
				self.content = ZhString.Auction_EventResult2

			elseif self.event == AuctionEventState.Result3 then
				self.content = string.format(ZhString.Auction_EventResult3, self.playerid, self.playerName, self:GetZoneString())

			elseif self.event == AuctionEventState.ResultSuccess then
				local str = ""
				if AuctionProxy.Instance:CheckEndItem(self.batchid, self.itemid) then
					str = ZhString.Auction_EventEnd
				else
					str = ZhString.Auction_EventNext
				end
				self.content = string.format(ZhString.Auction_EventResultSuccess, self.playerid, self.playerName, self:GetZoneString(), self.itemName)..str

			elseif self.event == AuctionEventState.ResultFail then
				self.content = string.format(ZhString.Auction_EventResultFail, self.itemName)
			end
		end
	end

	return self.content
end

function AuctionEventData:GetZoneString()
	if self.zoneid then
		local zoneid = self.zoneid % 10000
		return ChangeZoneProxy.Instance:ZoneNumToString(zoneid)
	end

	return 0
end

function AuctionEventData:GetPriceString()
	if self.price then
		return StringUtil.NumThousandFormat(self.price)
	end

	return 0
end

-- override begin
function AuctionEventData:DoConstruct(asArray, serverData)
	AuctionEventData.super.DoConstruct(self,asArray,serverData)
	self:SetData(serverData)
end

function AuctionEventData:DoDeconstruct(asArray)
	AuctionEventData.super.DoDeconstruct(self,asArray)

	self.time = nil
	self.event = nil
	self.price = nil
	self.playerName = nil
	self.zoneid = nil
	self.maxPrice = nil

	self.batchid = nil
	self.itemid = nil
	self.itemName = nil
	self.timeString = nil
	self.content = nil
end
-- override end