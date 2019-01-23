autoImport("BaseItemCell");
EquipAlchemyMakeCell = class("EquipAlchemyMakeCell", BaseItemCell)

function EquipAlchemyMakeCell:Init()
	self.itemCell = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemCell"), self.gameObject);

	EquipAlchemyMakeCell.super.Init(self);

	self.chooseSymbol = self:FindGO("ChooseSymbol");

	self:AddCellClickEvent();
end

function EquipAlchemyMakeCell:SetMinDepth(minDepth)
	local widgets = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIWidget, true)
	for i=1,#widgets do
		widgets[i].depth = minDepth + widgets[i].depth;
	end
end

function EquipAlchemyMakeCell:SetData(data)
	if(data)then
		self.gameObject:SetActive(true);

		if(self.itemData == nil)then
			self.itemData = ItemData.new("AlchemyMake", data.ProductId);
		else
			self.itemData:ResetData("AlchemyMake", data.ProductId);
		end

		EquipAlchemyMakeCell.super.SetData(self, self.itemData);

		self.data = data;

		self:UpdateChoose();
	else
		self.gameObject:SetActive(false);
	end

end

function EquipAlchemyMakeCell:SetChooseId(chooseId)
	self.chooseId = chooseId;
	self:UpdateChoose();
end

function EquipAlchemyMakeCell:UpdateChoose()
	local dataid = self.data and self.data.id;
	if(dataid and dataid == self.chooseId)then
		self.chooseSymbol:SetActive(true);
	else
		self.chooseSymbol:SetActive(false);
	end
end