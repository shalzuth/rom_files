autoImport("DressingCombineItemCell")
autoImport("HairDyeCell")
local baseCell = autoImport("BaseCell")
DyeHairCombineItemCell = class("DyeHairCombineItemCell",DressingCombineItemCell)

function DyeHairCombineItemCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("HairDyeCell"..i);
		self.childrenObjs[i] = HairDyeCell.new(go)
	end
end