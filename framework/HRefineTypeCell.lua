autoImport("ItemCell");
HRefineTypeCell = class("HRefineTypeCell", ItemCell)

local HRIC_TypeBgMap = 
{
	[1] = "refine_bg_green",
	[2] = "refine_bg_blue",
	[3] = "refine_bg_purple",
	[4] = "refine_bg_orange",
}

function HRefineTypeCell:Init()
	self.icon = self:FindComponent("Icon", UISprite);
	self.typeBg = self:FindComponent("TypeBg", UISprite);
end

function HRefineTypeCell:SetData(data)
	if(data)then
		self.gameObject:SetActive(true);

		local pos = data[1];
		local spriteName = "bag_equip_" .. pos;
		if(pos == 5)then
			spriteName = "bag_equip_6"
		end
		IconManager:SetUIIcon(spriteName, self.icon)

		local levelType = data[2];
		local atlas = RO.AtlasMap.GetAtlas("NEWUI_Equip")
		self.typeBg.atlas = atlas;
		self.typeBg.spriteName = HRIC_TypeBgMap[levelType] or HRIC_TypeBgMap[2];
	else
		self.gameObject:SetActive(false);
	end
end