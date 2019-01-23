autoImport("BagItemCell");
MaterialItemCell = class("MaterialItemCell", BaseItemCell);

MaterialItemCell.TextColor_Red = "[c][FF3B35]";

MaterialItemCell.MaterialType = {
	Material = "Material",
	MaterialItem = "MaterialItem"
}

function MaterialItemCell:Init()
	self.super.Init(self);
	self:AddCellClickEvent();

	self.clickTipCt = self:FindGO("clickTip")
	self.clickTip = self:FindComponent("clickTipLabel",UILabel,self.clickTipCt)
	self.clickTip.text = ZhString.EquipRefinePage_ClickRefineTip

	self.discountTip = self:FindGO("DiscountTip");
	self.discountTip_Sp = self.discountTip:GetComponent(UISprite);
	self.discountTip_Label = self:FindComponent("Label", UILabel, self.discountTip);
end

function MaterialItemCell:SetData(data)
	self.data = data;
	
	self.super.SetData(self, data);
	if(data.neednum)then
		local colorStr = data.num>=data.neednum and "" or self.TextColor_Red;
		self.numLab.text = colorStr..data.num.."[-][/c]/"..data.neednum;
		self.numLab.gameObject:SetActive(true);
	else
		self.numLab.text = data.num
		self.numLab.gameObject:SetActive(true);
	end

	if(self.clickTipCt)then
		self:ActiveClickTip(data.id ~= MaterialItemCell.MaterialType.Material);
	end

	if(data.discount and data.discount < 100)then
		self:SetDisCountTip(true, self.data.discount);
	else
		self:SetDisCountTip(false);
	end
end

function MaterialItemCell:ActiveClickTip(b)
	if(self.clickTipCt)then
		self.clickTipCt:SetActive(b)
	end
end

function MaterialItemCell:SetDisCountTip(b, pct)
	if(self.discountTip)then
		if(b)then
			self.discountTip:SetActive(true);
			self.discountTip_Label.text = pct .. "%";

			local spname, labelColor = self:GetDiscountUIConfig(pct);
			self.discountTip_Sp.spriteName = spname;
			self.discountTip_Label.effectColor = labelColor or ColorUtil.NGUIBlack;
		else
			self.discountTip:SetActive(false);
		end
	end
end

function MaterialItemCell:GetDiscountUIConfig(pct)
	if(pct > 0 and pct <= 20)then
		return "shop_icon_sale20%", ColorUtil.DiscountLabel_Green;
	elseif(pct > 20 and pct <= 30)then
		return "shop_icon_sale30%", ColorUtil.DiscountLabel_Blue;
	elseif(pct > 30 and pct <= 50)then
		return "shop_icon_sale50%", ColorUtil.DiscountLabel_Purple;
	elseif(pct > 50 and pct <= 100)then
		return "shop_icon_sale70%", ColorUtil.DiscountLabel_Yellow;
	end
end