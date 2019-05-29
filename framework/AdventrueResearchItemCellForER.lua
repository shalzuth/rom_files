autoImport("ItemCell")
autoImport("BagItemCell")
autoImport("DragDropCell")
AdventrueResearchItemCellForER = class("AdventrueResearchItemCellForER", AdventrueResearchItemCell)
function AdventrueResearchItemCellForER:Init()
  AdventrueResearchItemCellForER.super.Init(self)
  self:InitDragEvent()
end
function AdventrueResearchItemCellForER:InitDragEvent()
  if self.gameObject:GetComponent(UIDragItem) == nil then
    self.gameObject:AddComponent(UIDragItem)
  end
  self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
  self.dragDrop.dragDropComponent.OnCursor = DragCursorPanel.Instance.ShowItemCell
end
function AdventrueResearchItemCellForER:SetData(data)
  AdventrueResearchItemCellForER.super.SetData(self, data)
  if data and data ~= "Grey" and data ~= "Empty" then
    self.dragDrop.dragDropComponent.data = {itemdata = data}
  else
    self.dragDrop.dragDropComponent.data = nil
  end
end
function AdventrueResearchItemCellForER:CanDrag(value)
  self.dragDrop:SetDragEnable(value)
end
