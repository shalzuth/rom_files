autoImport("BaseCombineCell");
AdventureResearchCombineItemCell = class("AdventureResearchCombineItemCell",BaseCombineCell);

autoImport("AdventrueResearchItemCell");

function AdventureResearchCombineItemCell:Init()
	self:InitCells(5, "AdventrueResearchItemCell", AdventrueResearchItemCell);
end
