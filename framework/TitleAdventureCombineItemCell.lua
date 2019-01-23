autoImport("TitleAdventureCell");
autoImport("TitleCombineItemCell")
local BaseCell = autoImport("BaseCell");
TitleAdventureCombineItemCell = class("TitleAdventureCombineItemCell",TitleCombineItemCell);

function TitleAdventureCombineItemCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("TitleAdventureCell");
		self.childrenObjs[i] = TitleAdventureCell.new(go)
	end

end

