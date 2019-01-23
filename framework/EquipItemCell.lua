autoImport("BaseItemCell");
EquipItemCell = class("EquipItemCell", BaseItemCell);

function EquipItemCell:Init()
	self:FindObjs();
	self:AddCellClickEvent();
	self:AddCellDoubleClickEvt();
end

function EquipItemCell:SetData(data)
	self.data = data;
	self.super.SetData(self, data);
end