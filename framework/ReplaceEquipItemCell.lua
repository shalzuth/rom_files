ReplaceEquipItemCell = class("ReplaceEquipItemCell", BaseItemCell)

function ReplaceEquipItemCell:SetData(data)
	ReplaceEquipItemCell.super.SetData(self, data);

	if(not self.invalid.activeSelf and data.id == "LackItem")then
		self.invalid:SetActive(true);
	end
end