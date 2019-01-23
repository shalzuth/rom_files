local BaseCell = autoImport("BaseCell");
AdvTipRewardCell = class("AdvTipRewardCell", BaseCell);

function AdvTipRewardCell:Init()
	self.icon = self:FindComponent("Icon", UISprite);
	self.label = self:FindComponent("Label", UILabel);
	self.preLabel = self:FindComponent("preLabel", UILabel);
	self.grid = self.gameObject:GetComponent(UITable)
	self:AddCellClickEvent()
end

-- type value
function AdvTipRewardCell:SetData(data)
	self.data = data;

	if(data)then
		self:Show(self.gameObject);
		if(data.type == "item")then
			local itemData = Table_Item[data.value[1]]
			local icon = itemData.Icon;
			local str
			if(itemData.Type == 10)then
				local atlas = RO.AtlasMap.GetAtlas("NewUI1")
				self.icon.atlas = atlas
				self.icon.spriteName = "Adventure_icon_badge"
			else
				IconManager:SetItemIcon(icon, self.icon)
			end
			if(data.showName)then
				if(data.addbracket)then
					str = "["..itemData.NameZh.."]".."x"..tostring(data.value[2]);
				else
					str = itemData.NameZh.."x"..tostring(data.value[2]);
				end
			else
				str = "x"..tostring(data.value[2]);
			end

			if(data.color)then
				self.label.color = data.color
			end

			self.label.text = str
		elseif(data.type == "buffid")then
			IconManager:SetUIIcon("76", self.icon);
			self.label.text = ItemUtil.getBufferDescByIdNotConfigDes(data.value);
		elseif(data.type == "AdvPoints")then
			IconManager:SetUIIcon("Adventure_icon_06", self.icon);
			self.label.text = "x"..tostring(data.value);
		elseif(data.type == "text")then
			self.label.text = tostring(data.value);
			self.icon.spriteName = "nil"
		elseif(data.type == "AdventureValue")then
			if(data.color)then
				self.label.color = data.color
			end
			IconManager:SetUIIcon("Adventure_icon_05", self.icon);
			local str = "x"
			if(data.showName)then
				if(data.addbracket)then
					str = "["..ZhString.AdventureRewardPanel_AdventureExp.."]"..str
				end
			end
			self.label.text = str..tostring(data.value);
		end

		if(data.preLabelTxt)then
			self:Show(self.preLabel.gameObject)
			self.preLabel.text = data.preLabelTxt
		else
			self:Hide(self.preLabel.gameObject)
		end
		self.icon:MakePixelPerfect();

		local width = self.icon.width;
		if(width>40)then
			self.icon.width = 35;
			self.icon.height = self.icon.height*35/width;
		end
		self.grid:Reposition()
	else
		self:Hide(self.gameObject);
	end
end