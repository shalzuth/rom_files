autoImport("ItemTipBaseCell");
EquipTipCell = class("EquipTipCell", ItemTipBaseCell);

function EquipTipCell:Init()
	EquipTipCell.super.Init(self);
	self:AddButtonEvent("CardUseButton", function (go)
		self:PassEvent(MouseEvent.MouseClick, self);
	end);
end

function EquipTipCell:SetData(data)
	EquipTipCell.super.SetData(self, data);
	self.gameObject:SetActive( data~=nil );
end