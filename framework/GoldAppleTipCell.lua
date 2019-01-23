GoldAppleTipCell = class("GoldAppleTipCell", BaseCell)

local goldAppleId = 157;

function GoldAppleTipCell:Init()
	self.symbol = self:FindComponent("Symbol", UISprite);

	local itemData = Table_Item[ goldAppleId ];
	if(itemData)then
		local appleIcon = itemData.Icon
		IconManager:SetItemIcon(appleIcon, self.symbol);
	end
end

function GoldAppleTipCell:SetData(data)
	self:Active( data == true );	
end

function GoldAppleTipCell:Active(b)
	if b then
		self.symbol.color = ColorUtil.NGUIWhite
	else
		self.symbol.color = ColorUtil.NGUIShaderGray
	end
end