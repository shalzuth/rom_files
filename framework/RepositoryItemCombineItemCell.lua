autoImport("BaseCombineCell")
RepositoryItemCombineItemCell = class("RepositoryItemCombineItemCell", BaseCombineCell)

autoImport("RepositoryItemCell")

function RepositoryItemCombineItemCell:Init()
	self:InitCells(5, "BagItemCell", RepositoryItemCell)
	
	if(self.childCells)then
		for i=1,#self.childCells do
			self.childCells[i]:UpdateEquipUpgradeTip();
			self.childCells[i]:RemoveUnuseObj("upgradeTip");
		end
	end
end