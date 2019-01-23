autoImport("BaseCombineCell");
BagCombineItemCell = class("BagCombineItemCell",BaseCombineCell);

autoImport("BagItemCell");

function BagCombineItemCell:Init()
	self:InitCells(5, "BagItemCell", BagItemCell);
end

function BagCombineItemCell:SetData(data)
	BagCombineItemCell.super.SetData(self, data);
	-- self:TestInfo();
end

function BagCombineItemCell:TestInfo()
	for i = 1,#self.childCells do
		local testLab = self:FindChild("TestLabel", self.childCells[i].Obj):GetComponent(UILabel);
		local cData = self:GetDataByChildIndex(i);
		if(cData~=nil)then
			testLab.gameObject:SetActive(true);
			testLab.text = "index: "..cData.index..'\n'.."type: "..cData.staticData.Type..'\n'.."id: "..cData.staticData.id..'\n'.."quality: "..cData.staticData.Quality..'\n';
		else
			testLab.gameObject:SetActive(false);
		end
	end
end
