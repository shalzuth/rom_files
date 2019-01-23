autoImport("BaseCombineCell");
PersonalPicturCombineItemCell = class("PersonalPicturCombineItemCell",BaseCombineCell);

autoImport("PersonalPictureCell");

function PersonalPicturCombineItemCell:Init()
	self:InitCells(4, "PersonalPictureCell", PersonalPictureCell);
end
