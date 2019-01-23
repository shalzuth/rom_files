ExchangeLogNameData = class("ExchangeLogNameData")

function ExchangeLogNameData:ctor(data)
	self:SetData(data)
end

function ExchangeLogNameData:SetData(data)
	self.name = data.name
	self.zoneid = data.zoneid
	self.count = data.count
end

function ExchangeLogNameData:GetName()
	return self.name or ""
end

function ExchangeLogNameData:GetZoneString()
	if self.zoneid then
		local zoneid = self.zoneid % 10000
		return ChangeZoneProxy.Instance:ZoneNumToString(zoneid)
	end

	return 0
end

function ExchangeLogNameData:GetCount()
	return self.count or 0
end