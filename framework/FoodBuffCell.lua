local BaseCell = autoImport("BaseCell") 
FoodBuffCell = class("FoodBuffCell",BaseCell)

function FoodBuffCell:Init()
	self:GetGameObjects()
end

function FoodBuffCell:GetGameObjects()
	-- self.bufcount = self:FindComponent("Bufcount", UILabel)
	self.icon = self:FindComponent("Icon", UISprite)
	self.scaleSet = self:FindGO("ScaleSet")
end

function FoodBuffCell:SetData(data)
	local itemStaticData = Table_Item[data.itemid]

	if(self.icon)then
		local setSuc, scale = false, Vector3.one;
		if(dType == 1200)then
			setSuc = IconManager:SetFaceIcon(itemStaticData.Icon, self.icon)
			-- 如果没有图标 默认显示波利
			if(not setSuc)then
				setSuc = IconManager:SetFaceIcon("boli", self.icon)
			end
			-- scale = Vector3.one*0.42;
		else
			setSuc = IconManager:SetItemIcon(itemStaticData.Icon, self.icon)
			-- 如果没有图标 默认显示波利帽
			if(not setSuc)then
				setSuc = IconManager:SetItemIcon("item_45001", self.icon)
			end
			-- scale = Vector3.one*0.42;
		end
		if(setSuc)then
			self.icon.gameObject:SetActive(true);
			self.icon:MakePixelPerfect()
			self.icon.transform.localScale = self.scaleSet.transform.localScale
		else
			self.icon.gameObject:SetActive(false);
		end
	end
end
