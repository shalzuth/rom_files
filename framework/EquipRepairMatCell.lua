autoImport("BaseItemCell");
EquipRepairMatCell = class("EquipRepairMatCell", BaseItemCell)

function EquipRepairMatCell:Init()
	EquipRepairMatCell.super.Init(self);
	self.nameTip = self:FindComponent("NameTip", UILabel);
	self.forbidTip = self:FindGO("ForbidTip");
end

function EquipRepairMatCell:SetData(data)
	EquipRepairMatCell.super.SetData(self, data);
	
	if(not data.equipInfo)then
		return;
	end

	if(data and data.id == "None")then
		self:SetNoMatState();
	else
		self:SetNormalState();
	end
end

function EquipRepairMatCell:SetNormalState()
	self.icon.color = Color(1,1,1);
	self.forbidTip:SetActive(false);

	self.nameTip.color = ColorUtil.NGUILabelBlueBlack
end

function EquipRepairMatCell:SetNoMatState()
	self.icon.color = Color(1,1,1,0.5);

	self.nameTip.color = ColorUtil.NGUILabelRed
end

function EquipRepairMatCell:SetForbidState()
	self.forbidTip:SetActive(true);
end