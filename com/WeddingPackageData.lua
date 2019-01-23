WeddingPackageData = class("WeddingPackageData")

local _ArrayPushBack = TableUtility.ArrayPushBack

function WeddingPackageData:ctor(data)
	self:SetData(data)
end

function WeddingPackageData:SetData(data)
	if data then
		self.id = data

		self.descList = nil
		self.serviceMap = nil
	end
end

function WeddingPackageData:InitService()
	self.descList = {}
	self.serviceMap = {}

	local _Table_WeddingService = Table_WeddingService
	local data = _Table_WeddingService[self.id]
	if data ~= nil then
		for i=1,#data.Service do
			local service = data.Service[i]
			local serviceData = _Table_WeddingService[service]
			if serviceData ~= nil then
				_ArrayPushBack(self.descList, serviceData.Desc)

				self.serviceMap[service] = serviceData.Price
			end
		end
	end
end

function WeddingPackageData:SetPurchase(isPurchased)
	self.isPurchased = isPurchased
end

function WeddingPackageData:GetDescList()
	if self.descList == nil then
		self:InitService()
	end

	return self.descList
end

function WeddingPackageData:GetServiceMap()
	if self.serviceMap == nil then
		self:InitService()
	end

	return self.serviceMap
end

function WeddingPackageData:GetServicePriceById(id)
	return self:GetServiceMap()[id]
end

function WeddingPackageData:GetPriceList()
	return WeddingProxy.Instance:GetWeddingPackagePrice(self.id)
end

function WeddingPackageData:GetPrice()
	local list = self:GetPriceList()
	if list ~= nil and #list > 0 then
		return list[1]
	end
end