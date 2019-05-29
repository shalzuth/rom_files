local BaseCell = autoImport("BaseCell")
ActionCell = class("ActionCell", BaseCell)
function ActionCell:Init()
  self.sprite = self:FindComponent("Symbol", UISprite)
  self:AddCellClickEvent()
end
function ActionCell:SetData(data)
  self.data = data
  if data and self.sprite and IconManager:SetActionIcon(data.Name, self.sprite) then
    self.sprite:MakePixelPerfect()
  end
end
