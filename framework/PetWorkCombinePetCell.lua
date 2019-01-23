autoImport("BaseCombineCell");
PetWorkCombinePetCell = class("PetWorkCombinePetCell",BaseCombineCell);
autoImport("PetWorkSpacePetHeadCell")

function PetWorkCombinePetCell:Init()
	self:InitCells(4, "PetWorkSpacePetHeadCell", PetWorkSpacePetHeadCell);
end