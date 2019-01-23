autoImport("BaseCombineCell");
PersonalPicturCombineItemWallCell = class("PersonalPicturCombineItemWallCell",BaseCombineCell);

autoImport("PersonalPictureWallCell");

function PersonalPicturCombineItemWallCell:Init()
	self:InitCells(4, "PersonalPictureWallCell", PersonalPictureWallCell);
end
