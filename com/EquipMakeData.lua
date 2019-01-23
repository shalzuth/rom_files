EquipMakeData = class("EquipMakeData")

function EquipMakeData:ctor(data)
	self:Init()
	self:SetData(data)
end

function EquipMakeData:Init()
	self.isChoose = false
end

function EquipMakeData:SetData(data)
	self.composeId = data

	local composeData = Table_Compose[data]
	if composeData then
		self.itemData = ItemData.new(nil,composeData.Product.id)
	end
end

function EquipMakeData:SetChoose(isChoose)
	self.isChoose = isChoose
end

function EquipMakeData:IsLock()
	local composeData = Table_Compose[self.composeId]
	if composeData.MenuID and not FunctionUnLockFunc.Me():CheckCanOpen(composeData.MenuID) then
		return true
	end

	return false
end

function EquipMakeData:IsChoose()
	return self.isChoose
end