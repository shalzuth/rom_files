autoImport("BaseItemCell");
EquipAlchemyItemCell = class("EquipAlchemyItemCell", BaseItemCell)

function EquipAlchemyItemCell:Init()
	self.itemCell = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemCell"), self.gameObject);

	EquipAlchemyItemCell.super.Init(self);

	self.countRange = self:FindComponent("CountRange", UILabel);
end

function EquipAlchemyItemCell:SetMinDepth(minDepth)
	local widgets = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIWidget, true)
	for i=1,#widgets do
		widgets[i].depth = minDepth + widgets[i].depth;
	end
end

function EquipAlchemyItemCell:SetData(data)
	if(data)then
		self.gameObject:SetActive(true);

		if(self.itemData == nil)then
			self.itemData = ItemData.new("Alchemy", data.ProductId);
		else
			self.itemData:ResetData("Alchemy", data.ProductId);
		end

		EquipAlchemyItemCell.super.SetData(self, self.itemData);

		self.data = data;

		self.countRange.text = data.Count[1] .. "~" .. data.Count[2];
	else
		self.gameObject:SetActive(false);
	end
end