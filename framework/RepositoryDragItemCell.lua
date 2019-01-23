autoImport("BagItemCell");
autoImport("DragDropCell")

RepositoryDragItemCell = class("RepositoryDragItemCell", BagItemCell);

function RepositoryDragItemCell:Init()

	local itemCell = self:FindGO("Common_ItemCell");
	if(not itemCell)then
		local go = self:LoadPreferb("cell/ItemCell", self.gameObject);
		go.name = "Common_ItemCell";
	end

	RepositoryDragItemCell.super.Init(self);
	self.chooseSymbol = self:FindGO("ChooseSymbol")
	self.emptyTip = self:FindGO("EmptyTip")
end

function RepositoryDragItemCell:SetData(data)
	RepositoryDragItemCell.super.SetData(self, data);
	self:UpdateChoose();
end

function RepositoryDragItemCell:SetChooseId(chooseId)
	self.chooseId = chooseId;
	self:UpdateChoose();
end

function RepositoryDragItemCell:UpdateChoose()
	if(self.chooseSymbol)then
		if(self.chooseId and self.data and self.data.id == self.chooseId)then
			self.chooseSymbol:SetActive(true);
		else
			self.chooseSymbol:SetActive(false);
		end
	end
end