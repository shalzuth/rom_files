ExchangeBriefBuyData = class("ExchangeBriefBuyData")

function ExchangeBriefBuyData:ctor(data)
	self:SetData(data)
end

function ExchangeBriefBuyData:SetData(data)
	self.name = data.name
	self.time = data.time
end