local baseCell = autoImport("BaseCell");
HairDyeCell = class("HairDyeCell", baseCell);

function HairDyeCell:Init()
	HairDyeCell.super.Init(self)
	self:FindObjs()
	self:AddCellClickEvent()
end

function HairDyeCell:FindObjs()
	self.empty = self:FindGO("empty");
	self.item = self:FindGO("Item");
	self.iconColor = self:FindGO("iconColor"):GetComponent(GradientUISprite);
	self.chooseImg = self:FindGO("chooseImg");
end

function HairDyeCell:SetData(data)
	self.data=data
	if(self.data)then
		self:SetActive(self.item, true)
	 	self:SetActive(self.empty, false)
	 	local hairColorData = Table_HairColor[data.hairColorID]
	 	if(hairColorData)then
			local topColor = hairColorData.ColorH
			local buttomColor = hairColorData.ColorD
			 if(topColor)then
	 			local result, value = ColorUtil.TryParseHexString(topColor)
				if(result)then
					self.iconColor.gradientTop = value
				end
			 end
			 if(buttomColor)then
	 			local result, value = ColorUtil.TryParseHexString(buttomColor)
				if(result)then
					self.iconColor.gradientBottom = value
				end
			 end
		end
	else
		self:SetActive(self.item, false)
	 	self:SetActive(self.empty, true)
	end
end

function HairDyeCell:Choose()
	self:Show(self.chooseImg);
end

function HairDyeCell:UnChoose()
	self:Hide(self.chooseImg);
end

