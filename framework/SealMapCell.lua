local BaseCell = autoImport("BaseCell");
SealMapCell = class("SealMapCell", BaseCell)

function SealMapCell:Init()
	self:InitCell();
	self:AddCellClickEvent();
end

function SealMapCell:InitCell()
	self.multiSymbol = self:FindComponent("SealSymbol", UIMultiSprite);
end

-- data{ mapData, sealData, acceptSeal}
function SealMapCell:SetData(data)
	self.data = data;
	if(data.sealData)then
		self.multiSymbol.gameObject:SetActive(true);
		if(data.acceptSeal)then
			self.multiSymbol.CurrentState = 1
		else
			self.multiSymbol.CurrentState = 0
		end
	else
		self.multiSymbol.gameObject:SetActive(false);
	end
end