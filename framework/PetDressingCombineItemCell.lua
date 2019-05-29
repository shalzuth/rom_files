autoImport("BaseCombineCell")
PetDressingCombineItemCell = class("PetDressingCombineItemCell", BaseCombineCell)
autoImport("PetDressingItemCell")
function PetDressingCombineItemCell:Init()
  self:InitCells(4, "PetDressingItemCell", PetDressingItemCell)
end
