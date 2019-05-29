autoImport("BaseCombineCell")
EquipComposeBagCombineItemCell = class("EquipComposeBagCombineItemCell", BaseCombineCell)
autoImport("EquipComposeBagItemCell")
function EquipComposeBagCombineItemCell:Init()
  self:InitCells(5, "EquipComposeBagItemCell", EquipComposeBagItemCell)
end
