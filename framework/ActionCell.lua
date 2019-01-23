local BaseCell = autoImport("BaseCell") 
ActionCell = class("ActionCell", BaseCell)

function ActionCell:Init()
	self.sprite = self:FindComponent("Symbol", UISprite);
	-- self.label = self:FindGO("Label"):GetComponent(UILabel);
	self:AddCellClickEvent();
end

function ActionCell:SetData(data)
	self.data = data;
	if(data and self.sprite)then
		if(IconManager:SetActionIcon(data.Name, self.sprite))then
			self.sprite:MakePixelPerfect();
		end
		-- self.label.text = "/"..data.Action;
	end
end

