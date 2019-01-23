local BaseCell = autoImport("BaseCell");
ActivityMapSymbolCell = class("ActivityMapSymbolCell", BaseCell)

function ActivityMapSymbolCell:Init()
	self.icon = self:FindComponent("Icon", UISprite);
end

function ActivityMapSymbolCell:SetData(data)
	if(data)then
		local mapSymbol = data:GetMapSymbol();
		if(mapSymbol)then
			self.icon.spriteName = mapSymbol.SpriteName;
			if(mapSymbol.Size)then
				self.icon.width = mapSymbol.Size[1];
				self.icon.height = mapSymbol.Size[2];
			end
		end
	end
end