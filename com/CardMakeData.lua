autoImport("CardMakeMaterialData")

CardMakeData = class("CardMakeData")

function CardMakeData:ctor(data)
	self:SetData(data)
end

function CardMakeData:SetData(data)
	if data then
		self.id = data

		local compose = Table_Compose[data]
		if compose then
			if compose.Product and compose.Product.id then
				self.itemData = ItemData.new("CardMake", compose.Product.id)
			end

			local beCostItem = compose.BeCostItem
			if beCostItem then
				self.materialItems = {}

				for i=1,#beCostItem do
					local data = CardMakeMaterialData.new(beCostItem[i])
					TableUtility.ArrayPushBack(self.materialItems, data)
				end
			end
		end

		self:SetChoose(false)
	end
end

function CardMakeData:IsLock()
	local compose = Table_Compose[self.id]
	if compose.MenuID and not FunctionUnLockFunc.Me():CheckCanOpen(compose.MenuID) then
		return true
	end

	return false
end

function CardMakeData:SetChoose(isChoose)
	self.isChoose = isChoose
end

function CardMakeData:CanMake()
	if self:IsLock() then
		return false
	end
	
	self:ClearCount()
	if self.materialItems then
		local material
		for i=1,#self.materialItems do
			material = self.materialItems[i]
			if not self:CheckCanMake(material) then
				return false
			end
		end
	end

	return true
end

function CardMakeData:CheckCanMake(materialData)
	if materialData then
		local id = materialData.id
		if self.cardCount == nil then
			self.cardCount = {}
		end
		if self.cardCount[id] == nil then
			self.cardCount[id] = 0
		end
		self.cardCount[id] = self.cardCount[id] + materialData.itemData.num
		
		return CardMakeProxy.Instance:GetItemNumByStaticID(id) >= self.cardCount[id]
	end

	return false
end

function CardMakeData:ClearCount()
	if self.cardCount then
		for k,v in pairs(self.cardCount) do
			self.cardCount[k] = 0
		end
	end
end