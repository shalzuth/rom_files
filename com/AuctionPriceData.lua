AuctionPriceData = class("AuctionPriceData")

function AuctionPriceData:ctor(level)
	self.level = level
end

function AuctionPriceData:SetPrice(price)
	self.price = price
end

function AuctionPriceData:SetDisable(disable)
	self.disable = disable
end

function AuctionPriceData:SetMask(mask)
	self.mask = mask
end