local BaseCell = autoImport("BaseCell");
ItemNTipCell = class("ItemNTipCell", BaseCell);

autoImport("TipCardEquipCell");
autoImport("PicMakeTipCell");

ItemNTipCell.Type = {
	Normal = {},
	Card = {},
	Compose = {},
}

function ItemNTipCell:Init()
	self.table = self.gameObject:GetComponent(UITable);

	self.label = self:FindComponent("M_Label", UILabel);

	self.line = self:FindGO("Z_Line");
end

function ItemNTipCell:Reset()
	if(self.cellCtl)then
		self.cellCtl:RemoveAll();
	end
	if(self.composeCtl)then
		self.composeCtl:RemoveAll();
	end
	self.label.gameObject:SetActive(false);
	if(self.spritelabel)then
		self.spritelabel:Reset();
	end
end

-- type, label, celldatas, hideline, labelConfig
function ItemNTipCell:SetData(data)
	self:Reset();

	self.data = data;
	if(data)then
		self.line:SetActive(not data.hideline);
		-- 更新label
		if(data.label and data.label~="")then
			local width,height;
			if(data.labelConfig)then
				width,height = data.labelConfig.iconwidth, data.labelConfig.iconheight;
			end
			self.spritelabel = SpriteLabel.new(self.label, 325, width, height);
			self.label.gameObject:SetActive(true);
			self.spritelabel:SetText(data.label, true);
		end
		-- 更新图纸或者合成信息
		if(data.celldatas)then
			if(data.type == ItemNTipCell.Type.Card)then
				self:UpdateCardCell(data.celldatas);
			elseif(data.type == ItemNTipCell.Type.Compose)then
				self:UpdateComposeCell(data.celldatas);
			end
		end
	end
	self.table:Reposition();
end

function ItemNTipCell:UpdateCardCell(celldatas)
	if(celldatas)then
		if(not self.cellCtl)then
			self.cellCtl = UIGridListCtrl.new(self.table , TipCardEquipCell, "TipCardEquipCell");
		end
		self.cellCtl:ResetDatas(celldatas);
	end
end

function ItemNTipCell:UpdateComposeCell(celldatas)
	if(celldatas)then
		if(not self.cellCtl)then
			self.cellCtl = UIGridListCtrl.new(self.table , PicMakeTipCell, "PicMakeTipCell");
		end
		self.cellCtl:ResetDatas(celldatas);
	end
end