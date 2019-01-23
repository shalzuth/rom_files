local baseCell = autoImport("BaseCell")
ShopMallExchangeTypesCell = class("ShopMallExchangeTypesCell",baseCell)

function ShopMallExchangeTypesCell:Init()
	self.label = self:FindComponent("Label", UILabel)
	self:AddCellClickEvent()

	self.ChooseColor = Color(27/255,94/255,177/255)
	self.NormalColor = Color(34/255,34/255,34/255)
	self.choose = false
end

function ShopMallExchangeTypesCell:SetData(data)
	self.data = data
	if data then
		self.label.text = data.name
	end
end

function ShopMallExchangeTypesCell:SetChoose(choose)
	self.choose = choose
	self.label.color = self.choose and self.ChooseColor or self.NormalColor
end