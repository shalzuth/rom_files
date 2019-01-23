autoImport("BagCombineItemCell");
ShopSaleCombineBagCell = class("ShopSaleCombineBagCell", BagCombineItemCell);

autoImport("ShopSaleBagCell");

function ShopSaleCombineBagCell:Init()
	self:InitCells(5, "ShopSaleBagCell", ShopSaleBagCell);
end