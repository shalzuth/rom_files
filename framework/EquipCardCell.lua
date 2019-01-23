autoImport("ItemCardCell");
EquipCardCell = class("EquipCardCell", ItemCardCell);

EquipCardCell.Empty = 0;

function EquipCardCell:Init()
	EquipCardCell.super.Init(self);

	self.cardBg = self:FindGO("CardBg");
	self.normalCard = self:FindGO("NormalCard");
	self.chooseSymbol = self:FindGO("ChooseSymbol");

	self:AddCellClickEvent();
end

function EquipCardCell:SetData(data)
	if(data~=nil)then
		self.data = data;
		if(data == EquipCardCell.Empty)then
			self.normalCard:SetActive(false);
			self.cardBg:SetActive(true);
		else
			self.normalCard:SetActive(true);
			self.cardBg:SetActive(false);
			EquipCardCell.super.SetData(self, data);
		end
	end
end

function EquipCardCell:SetChoose(b)
	self.chooseSymbol:SetActive(b);
end