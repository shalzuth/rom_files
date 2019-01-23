autoImport("ItemCell")
EnchantTransferCell = class("EnchantTransferCell",ItemCell)

local PERSENT_FORMAT = "%s    [c][1B5EB1]+%s%%[-][/c]"
local VALUE_FORMAT = "%s    [c][1B5EB1]+%s[-][/c]"
local WORKTIP_FORMAT = "[c][9c9c9c]%s:%s(%s)[-][/c]"
local COMBINE_FORMAT = "[c][222222]%s:%s[-][/c]"
local NOENCHANT_FORMAT = "[c][9c9c9c]%s[-][/c]"
local SEPARATOR = "\n"
local STR_FORMAT = string.format

EnchantTransferCellEvent = {
	ClickItemIcon = "EnchantTransferCell_ClickItemIcon",
}

function EnchantTransferCell:Init()
	EnchantTransferCell.super.Init(self);
	self.attrLab = self:FindComponent("AttrLab",UILabel)
	self.chooseSymbol = self:FindGO("ChooseSymbol");
	self:AddClickEvent(self.gameObject, function ()
		self:PassEvent(MouseEvent.MouseClick, self);
	end);
	local itemIcon = self:FindGO("Item");
	self:AddClickEvent(itemIcon, function ()
		self:PassEvent(EnchantTransferCellEvent.ClickItemIcon, self);
	end);
end

function EnchantTransferCell:SetData(data)
	EnchantTransferCell.super.SetData(self, data)
	self:UpdateMyselfInfo();

	if(data)then
		self:Show(self.nameLab);
	 	self:SetIconGrey(data.id == "NoGet")
	else
	 	if(self.nameLab)then
			self:Hide(self.nameLab);
		end
	end
	self:SetAttr()
	self:UpdateChoose();
end

function EnchantTransferCell:SetChooseId(chooseId)
	self.chooseId = chooseId;
	self:UpdateChoose();
end

function EnchantTransferCell:UpdateChoose()
	if(self.chooseSymbol)then
		if(self.chooseId and self.data and self.data.id == self.chooseId)then
			self.chooseSymbol:SetActive(true)
		else
			self.chooseSymbol:SetActive(false)
		end
	end
end

-- 待优化
function EnchantTransferCell:SetAttr()
	local enchantAttrText = ""
	if(self.data and self.data.enchantInfo)then
		local attri = self.data.enchantInfo:GetEnchantAttrs()
		if(0<#attri)then
			for i=1,#attri do
				if(attri[i].propVO.isPercent)then
					enchantAttrText = enchantAttrText..STR_FORMAT(PERSENT_FORMAT, attri[i].name, attri[i].value)
				else
					enchantAttrText = enchantAttrText..STR_FORMAT(VALUE_FORMAT, attri[i].name, attri[i].value)
				end
				if(i<#attri)then
					enchantAttrText = enchantAttrText..SEPARATOR
				end
			end
			local combineEffects = self.data.enchantInfo:GetCombineEffects()
			for i=1,#combineEffects do
				local combineEffect = combineEffects[i]
				local buffData = combineEffect and combineEffect.buffData
				if(buffData)then
					if(combineEffect.isWork)then
						enchantAttrText = enchantAttrText..STR_FORMAT(WORKTIP_FORMAT, buffData.BuffName, buffData.BuffDesc)
					else
						enchantAttrText = enchantAttrText..STR_FORMAT(COMBINE_FORMAT, buffData.BuffName, buffData.BuffDesc, combineEffect.WorkTip)
					end
				end
			end
		end
		self:Show(self.attrLab)
		self.attrLab.text = StringUtil.IsEmpty(enchantAttrText) and STR_FORMAT(NOENCHANT_FORMAT,ZhString.EnchantTransferView_NoEnchant) or enchantAttrText
	else
		self:Hide(self.attrLab)
	end
end
