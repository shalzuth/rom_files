autoImport("BaseCombineCell");
MaterialChooseCombineCell = class("MaterialChooseCombineCell",BaseCombineCell);

autoImport("MaterialChooseCell");

function MaterialChooseCombineCell:Init()
	self:InitCells(4, "MaterialChooseCell", MaterialChooseCell);
end
