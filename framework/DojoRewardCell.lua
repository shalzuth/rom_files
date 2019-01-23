local baseCell = autoImport("BaseCell")
DojoRewardCell = class("DojoRewardCell", baseCell)

function DojoRewardCell:Init()
	self:FindObjs()
end

function DojoRewardCell:FindObjs()
	self.icon = self:FindGO("Icon"):GetComponent(UISprite)
	self.count = self.gameObject:GetComponent(UILabel)
end

function DojoRewardCell:SetData(data)
	self.data = data

	if data then
		local itemData = Table_Item[data.id]
		if itemData then
			IconManager:SetItemIcon(itemData.Icon, self.icon)
		end

		self.count.text = data.count
	end
end