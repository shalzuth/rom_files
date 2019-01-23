BusinessmanMakeData = class("BusinessmanMakeData")

function BusinessmanMakeData:ctor(data)
	self:SetData(data)
end

function BusinessmanMakeData:SetData(data)
	self.id = data

	local compose = Table_Compose[data]
	if compose then
		if compose.Product and compose.Product.id then
			self.itemData = ItemData.new(nil, compose.Product.id)
			self.productNum = compose.Product.num or 1
		end
		if compose.GreatProduct and compose.GreatProduct.id then
			self.produceItemData = ItemData.new(nil, compose.GreatProduct.id)
			self.greatProductNum = compose.GreatProduct.num
		end
	end
end

function BusinessmanMakeData:IsLock()
	local composeData = Table_Compose[self.id]
	if composeData.MenuID and not FunctionUnLockFunc.Me():CheckCanOpen(composeData.MenuID) then
		return true
	end

	return false
end

function BusinessmanMakeData.GetCanMakeTimes(id)
	local times
	local compose = Table_Compose[id]
	if compose and compose.BeCostItem then
		local _BagProxy = BagProxy.Instance
		for i=1,#compose.BeCostItem do
			local item = compose.BeCostItem[i]
			local haveCount = _BagProxy:GetItemNumByStaticID(item.id)
			local itemTimes = math.floor(haveCount/item.num)
			if times == nil or itemTimes < times then
				times = itemTimes
			end
		end
	end

	return times or 0
end

function BusinessmanMakeData:GetCanMakeNum()
	if self:IsLock() then
		return 0
	end
	
	if self.productNum ~= nil then
		return self.productNum * BusinessmanMakeData.GetCanMakeTimes(self.id)
	end

	return 0
end

function BusinessmanMakeData:GetProductNum()
	return self.productNum or 0
end