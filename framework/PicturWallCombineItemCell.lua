autoImport("BaseCombineCell");
PicturWallCombineItemCell = class("PicturWallCombineItemCell",BaseCombineCell);

autoImport("PictureWallCell");

function PicturWallCombineItemCell:Init()
	self:InitCells(1, "PictureWallCell", PictureWallCell);
end
