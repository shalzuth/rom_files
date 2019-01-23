autoImport("BaseCombineCell");
BagCombineDragItemCell = class("BagCombineDragItemCell", BaseCombineCell);

autoImport("BagDragItemCell");

function BagCombineDragItemCell:Init()
	self:InitCells(5, "BagItemCell", BagDragItemCell);
end
