local BaseCell = autoImport("BaseCell")
RecommendEquipCell = class("RecommendEquipCell", BaseCell)
function RecommendEquipCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end
function RecommendEquipCell:FindObjs()
  self.item = self:FindGO("ItemCell")
  self.itemCell = ItemCell.new(self.item)
end
function RecommendEquipCell:SetData(data)
  self.data = data
  self.itemCell:SetData(data)
end
