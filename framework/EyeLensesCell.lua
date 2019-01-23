local BaseCell = autoImport("BaseCell");
EyeLensesCell = class("EyeLensesCell", BaseCell);

function EyeLensesCell:Init()
	EyeLensesCell.super.Init(self)
	self:FindObjs()
	self:AddCellClickEvent()
end

function EyeLensesCell:FindObjs()
	self.empty = self:FindGO("empty");
	self.item = self:FindGO("Item");
	self.chooseImg = self:FindGO("chooseImg");
	self.icon = self:FindComponent("icon",UISprite);
	self.lockFlag = self:FindGO("lockFlag");
	self.eyeName = self:FindComponent("eyeName",UILabel);
end

function EyeLensesCell:Choose()
	self:Show(self.chooseImg);
end

function EyeLensesCell:UnChoose()
	self:Hide(self.chooseImg);
end

local eyeColor = nil
function EyeLensesCell:SetData(data)
	self.data = data;
	if(data and data.id) then
		self:Show(self.item);
		self:Hide(self.empty);
		local shopType = ShopDressingProxy.Instance:GetShopType()
		local shopid = ShopDressingProxy.Instance:GetShopId()
		local tableData = ShopProxy.Instance:GetShopItemDataByTypeId(shopType,shopid,data.id)
		if(nil ~= tableData) then
			local eyeID = tableData.goodsID
			if(eyeID) then
				self.eyeName.text = Table_Item[eyeID].NameZh
				local unlock = ShopDressingProxy.Instance:bActived(eyeID,ShopDressingProxy.DressingType.EYE)
				if(unlock) then
					self:Hide(self.lockFlag)
					self:SetTextureWhite(self.icon.gameObject)
				else
					self:Show(self.lockFlag)
					self:SetTextureGrey(self.icon.gameObject)
				end
				local csvData = Table_Eye[eyeID]
				if (csvData and csvData.Icon) then
					IconManager:SetHairStyleIcon(csvData.Icon , self.icon)
					local csvColor = csvData.EyeColor
					if(csvColor and #csvColor>0)then
						local hasColor = false
						hasColor,eyeColor = ColorUtil.TryParseFromNumber(csvColor[1])
						self.icon.color = eyeColor
					end
				end
			end
		end
	else
		self:Hide(self.item);
		self:Show(self.empty);
	end
end
