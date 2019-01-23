autoImport("DressingCombineItemCell")
autoImport("HairCutCell")
local baseCell = autoImport("BaseCell")
CutHairCombineItemCell = class("CutHairCombineItemCell",DressingCombineItemCell)

function CutHairCombineItemCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("HairCutCell"..i);
		self.childrenObjs[i] = HairCutCell.new(go)
	end
end