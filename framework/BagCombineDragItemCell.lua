autoImport("BaseCombineCell")
BagCombineDragItemCell = class("BagCombineDragItemCell", BaseCombineCell)
autoImport("BagDragItemCell")
function BagCombineDragItemCell:Init()
  self:InitCells(5, "BagItemCell", BagDragItemCell)
end
function BagCombineDragItemCell:SetData(data)
  if self.childCells then
    for k, v in pairs(self.childCells) do
      v:AddOrRemoveGuideId(v.gameObject)
    end
  end
  BagCombineDragItemCell.super.SetData(self, data)
end
