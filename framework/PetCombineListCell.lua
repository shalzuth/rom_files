autoImport("BaseCombineCell")
PetCombineListCell = class("PetCombineListCell", BaseCombineCell)
autoImport("PetComposeItemCell")
function PetCombineListCell:Init()
  self:InitCells(3, "PetComposeItemCell", PetComposeItemCell)
end
