ExchangeExpressData = class("ExchangeExpressData")

function ExchangeExpressData:ctor(data)
	self:SetData(data)
end

function ExchangeExpressData:SetData(data)
	self.id = data.id
	self.itemid = data.itemid

	if data.itemdata and data.itemdata.base and data.itemdata.base.id ~= 0 then
		self.itemData = ItemData.new(data.itemdata.base.guid , data.itemdata.base.id)
		self.itemData:ParseFromServerData(data.itemdata)
	else
		self.itemData = ItemData.new("ExchangeLog", self.itemid)
	end
	self.itemData.num = data.count

	self.sendername = data.sendername
	self.anonymous = data.anonymous
	self.content = data.content
	self.background = data.background
end

function ExchangeExpressData:GetId()
	return self.id
end

function ExchangeExpressData:GetItemData()
	return self.itemData
end

function ExchangeExpressData:GetSenderName()
	return self.sendername or ""
end

function ExchangeExpressData:GetAnonymous()
	return self.anonymous
end

function ExchangeExpressData:GetContent()
	return self.content or ""
end

function ExchangeExpressData:GetBg()
	return self.background or 1
end