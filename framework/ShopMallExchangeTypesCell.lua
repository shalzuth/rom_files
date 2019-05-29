local baseCell = autoImport("BaseCell")
ShopMallExchangeTypesCell = class("ShopMallExchangeTypesCell", baseCell)
function ShopMallExchangeTypesCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self:AddCellClickEvent()
  self.ChooseColor = Color(0.10588235294117647, 0.3686274509803922, 0.6941176470588235)
  self.NormalColor = Color(0.13333333333333333, 0.13333333333333333, 0.13333333333333333)
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
