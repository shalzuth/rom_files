local BaseCell = autoImport("BaseCell");
GuildTreasureRewardCell = class("GuildTreasureRewardCell", BaseCell);

function GuildTreasureRewardCell:Init()
	self.content = self:FindGO("content")
	self.nameLab = self:FindComponent("Name", UILabel);
	self.icon = self:FindComponent("Icon",UISprite);
	self.num = self:FindComponent("Num",UILabel);
	self.top = self:FindGO("Top");
end

function GuildTreasureRewardCell:SetData(data)
	if(data)then
		self.content:SetActive(true)
		self.nameLab.text = data.name
		local charid = GuildTreasureProxy.Instance:GetTreasureMaxCharID()
		local isMax = charid and data.charid==charid and true or false
		self.top:SetActive(isMax)
		local itemData = data.ItemData
		if(itemData and #itemData>0)then
			local item = itemData[1]
			local icon = Table_Item[item.id] and Table_Item[item.id].Icon
			IconManager:SetItemIcon(icon,self.icon)
			self.num.text = item.num
		end
	else
		self.content:SetActive(false)
	end
end