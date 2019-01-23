CardRandomMakeData = class("CardRandomMakeData")

function CardRandomMakeData:ctor(data)
	self:SetData(data)
end

function CardRandomMakeData:SetData(data)
	if data then
		self.itemData = data
		self.itemData.num = 1
		self.isChoose = false
	end
end

function CardRandomMakeData:SetChoose()
	self.isChoose = not self.isChoose
end