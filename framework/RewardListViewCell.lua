RewardListViewCell = class("RewardListViewCell",BaseCell)

function RewardListViewCell:Init()
	self:GetGameObjects()
end

function RewardListViewCell:GetGameObjects()
	self.icon = self:FindGO('Icon', self.gameObject):GetComponent(UISprite)
	self.itemName = self:FindGO('ItemName', self.gameObject):GetComponent(UILabel)
	self.count = self:FindGO('Count', self.gameObject):GetComponent(UILabel)
end

function RewardListViewCell:SetData(data)
	-- self.itemIcon.text = data[itemid]
	-- helplog(data.itemid)
	local itemStaticData = Table_Item[data.itemid]

	if(self.icon)then
		local setSuc, scale = false, Vector3.one;
		if(dType == 1200)then
			setSuc = IconManager:SetFaceIcon(itemStaticData.Icon, self.icon)
			-- 如果没有图标 默认显示波利
			if(not setSuc)then
				setSuc = IconManager:SetFaceIcon("boli", self.icon)
			end
			scale = Vector3.one*0.53;
		else
			setSuc = IconManager:SetItemIcon(itemStaticData.Icon, self.icon)
			-- 如果没有图标 默认显示波利帽
			if(not setSuc)then
				setSuc = IconManager:SetItemIcon("item_45001", self.icon)
			end
			scale = Vector3.one*0.75;
		end
		if(setSuc)then
			self.icon.gameObject:SetActive(true);
			self.icon:MakePixelPerfect()
			self.icon.transform.localScale = scale
		else
			self.icon.gameObject:SetActive(false);
		end
	end

	self.itemName.text = itemStaticData.NameZh
	self.count.text = "x " .. data.count
end
