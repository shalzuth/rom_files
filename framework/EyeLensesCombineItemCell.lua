autoImport("DressingCombineItemCell")
autoImport("EyeLensesCell")
local baseCell = autoImport("BaseCell")
EyeLensesCombineItemCell = class("EyeLensesCombineItemCell",DressingCombineItemCell)

function EyeLensesCombineItemCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("EyeLensesCell"..i);
		self.childrenObjs[i] = EyeLensesCell.new(go)
	end
end