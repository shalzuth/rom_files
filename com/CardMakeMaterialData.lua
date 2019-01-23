CardMakeMaterialData = class("CardMakeMaterialData")

function CardMakeMaterialData:ctor(data)
	self:SetData(data)
end

function CardMakeMaterialData:SetData(data)
	if data then
		self.id = data.id
		self.itemData = ItemData.new("CardMake", self.id)
		if data.num then
			self.itemData.num = data.num
		end
	end
end