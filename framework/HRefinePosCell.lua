autoImport("ItemCell");
HRefinePosCell = class("HRefinePosCell", ItemCell)

HRPC_Type_IconMap = 
{
	[1] = "121",
	[5] = "126",
}
function HRefinePosCell:Init()
	self.posBg = self:FindComponent("PosBg", UISprite);
	self.icon = self:FindComponent("Icon", UISprite);
	self.chooseSymbol = self:FindGO("ChooseSymbol");

	self:AddCellClickEvent();
end

function HRefinePosCell:SetData(data)
	self.data = data;
	
	if(data and data.pos)then
		self.gameObject:SetActive(true);

		-- local bgType = data[1];
		-- self.posBg.spriteName = HRPC_Type_IconMap[bgType] or HRPC_Type_IconMap[1];
		
		local spriteName = "bag_equip_" .. data.pos;
		if(data.pos == 5)then
			spriteName = "bag_equip_6"
		end

		IconManager:SetUIIcon(spriteName, self.icon)
	else
		self.gameObject:SetActive(false);
	end
end

function HRefinePosCell:SetChoose(pos)
	if(self.data and self.data.pos)then
		self.chooseSymbol:SetActive(self.data.pos == pos);
	else
		self.chooseSymbol:SetActive(false);
	end
end
