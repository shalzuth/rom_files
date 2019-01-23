autoImport("BaseCombineCell");
AdventureCombineItemCell = class("AdventureCombineItemCell",BaseCombineCell);

autoImport("AdventrueItemCell");

function AdventureCombineItemCell:Init()
	self:InitCells(5, "AdventureItemCell", AdventrueItemCell);
end
