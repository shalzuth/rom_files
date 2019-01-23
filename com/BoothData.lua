BoothData = reusableClass("BoothData")
BoothData.PoolSize = 10

function BoothData:SetData(data)
	self.name = data.name
	self.sign = data.sign
end

function BoothData:GetName()
	return self.name
end

function BoothData:GetSign()
	return self.sign
end

function BoothData:DoConstruct(asArray, serverData)
	BoothData.super.DoConstruct(self, asArray, serverData)

	self:SetData(serverData)
end

function BoothData:DoDeconstruct(asArray)
	self.name = nil

	BoothData.super.DoDeconstruct(self, asArray)
end