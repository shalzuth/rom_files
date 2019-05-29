autoImport("BaseCombineCell")
AdventureResearchCombineItemCellForER = class("AdventureResearchCombineItemCellForER", BaseCombineCell)
autoImport("AdventrueResearchItemCell")
autoImport("AdventrueResearchItemCellForER")
function AdventureResearchCombineItemCellForER:Init()
  self:InitCells(10, "AdventrueResearchItemCellForER", AdventrueResearchItemCellForER)
end
