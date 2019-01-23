autoImport("DressingCombineItemCell")
autoImport("ClothDressingCell")
local baseCell = autoImport("BaseCell")
ClothDressingCombineItemCell = class("ClothDressingCombineItemCell",DressingCombineItemCell)

function ClothDressingCombineItemCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("ClothDressingCell"..i);
		self.childrenObjs[i] = ClothDressingCell.new(go)
	end
end