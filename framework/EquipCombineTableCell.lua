autoImport("EquipComposeItemCell")
EquipCombineTableCell = class("EquipCombineTableCell", BaseCell)
function EquipCombineTableCell:Init()
  self:FindObj()
  self:InitCell()
end
function EquipCombineTableCell:FindObj()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.name = self:FindComponent("Name", UILabel)
end
function EquipCombineTableCell:InitCell()
  self.equipCtl = UIGridListCtrl.new(self.grid, EquipComposeItemCell, "EquipComposeItemCell")
  self.equipCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenCell, self)
end
function EquipCombineTableCell:ClickChoosenCell(cellctl)
  if cellctl and cellctl.data then
    self:PassEvent(MouseEvent.MouseClick, cellctl)
  end
end
function EquipCombineTableCell:SetData(data)
  self.data = data
  if data then
    self.name.text = data.name
    self.equipCtl:ResetDatas(data)
  end
end
function EquipCombineTableCell:GetCells()
  return self.equipCtl:GetCells()
end
