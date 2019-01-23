AuctionItemData = class("AuctionItemData")

function AuctionItemData:ctor(data)
	self:SetData(data)
end

function AuctionItemData:SetData(data)
	if data then
		self.itemid = data.itemid
		if data.price then
			self.price = data.price		--起拍价
		end
		if data.seller then
			self.seller = data.seller	--卖者名
		end
		if data.sellerid then
			self.sellerid = data.sellerid
		end
		if data.result then
			self.result = data.result
		end
		if data.trade_price then
			self.tradePrice = data.trade_price	--成交价格
		end
		if data.auction_time then
			self.auctionTime = data.auction_time	--拍卖时间
		end
		if data.cur_price then
			self.currentPrice = data.cur_price	--当前出价
		end
		if data.mask_price then
			self.maskPrice = data.mask_price	--出价档位被禁止，二进制
		end
		if data.signup_id then
			self.orderid = data.signup_id	--订单id，用于标识唯一
		end
		local itemData = data.itemdata
		if itemData and itemData.base and itemData.base.id ~= 0 then
			self.itemData = ItemData.new(itemData.base.guid , itemData.base.id)
			self.itemData:ParseFromServerData(itemData)
		end
	end
end

function AuctionItemData:SetMyPrice(myPrice)
	self.myPrice = myPrice
end

function AuctionItemData:SetMaskPrice(maskPrice)
	self.maskPrice = maskPrice
end

function AuctionItemData:CheckOverTakePrice()
	if self.myPrice and self.myPrice ~= 0 then
		return self.currentPrice > self.myPrice
	end

	return false
end

function AuctionItemData:CheckAtAuction()
	return self.result == AuctionItemState.AtAuction
end

function AuctionItemData:CheckAuctionEnd()
	return self.result == AuctionItemState.Fail or self.result == AuctionItemState.Sucess
end

function AuctionItemData:CheckMask(level)
	if self.maskPrice then
		return self.maskPrice & level > 0
	end

	return false
end

function AuctionItemData:GetItemData()
	if self.itemData == nil then
		self.itemData = ItemData.new("Auction", self.itemid)
	end

	return self.itemData
end

function AuctionItemData:GetPriceString()
	if self.price then
		return StringUtil.NumThousandFormat(self.price)
	end

	return 0
end

function AuctionItemData:GetCurrentPriceString()
	if self.currentPrice then
		return StringUtil.NumThousandFormat(self.currentPrice)
	end

	return 0
end

function AuctionItemData:GetTradePriceString()
	if self.tradePrice then
		return StringUtil.NumThousandFormat(self.tradePrice)
	end

	return 0
end

function AuctionItemData:GetMyPrice()
	return self.myPrice
end