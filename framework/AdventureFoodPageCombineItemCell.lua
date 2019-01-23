autoImport("BaseCombineCell");
AdventureFoodPageCombineItemCell = class("AdventureFoodPageCombineItemCell",BaseCombineCell);

function AdventureFoodPageCombineItemCell:Init()
	self:InitCells(5, "AdventureFoodItemCell", AdventureFoodItemCell);
end
