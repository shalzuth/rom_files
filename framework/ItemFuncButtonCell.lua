local BaseCell = autoImport("BaseCell")
ItemFuncButtonCell = class("ItemFuncButtonCell", BaseCell)
function ItemFuncButtonCell:Init()
  self.bg = self:FindComponent("Background", UILabel)
  self.label = self:FindComponent("Label", UILabel)
  self:AddCellClickEvent()
  self.label.fontSize = 21
  OverseaHostHelper:FixLabelOverV1(self.label, 3, 180)
end
function ItemFuncButtonCell:SetData(data)
  if data then
    self.data = data
    if data.name then
      self.label.text = tostring(data.name)
    end
  end
end
