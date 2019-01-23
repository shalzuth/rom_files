autoImport("BaseCombineCell");
RepositoryBagCombineItemCell = class("RepositoryBagCombineItemCell", BaseCombineCell);

autoImport("RepositoryBagCell");

function RepositoryBagCombineItemCell:Init()
	self:InitCells(5, "BagItemCell", RepositoryBagCell)

	if(self.childCells)then
		for i=1,#self.childCells do
			self.childCells[i]:UpdateEquipUpgradeTip();
			self.childCells[i]:RemoveUnuseObj("upgradeTip");
		end
	end
end