local BaseCell = autoImport("BaseCell");
ClothDressingCell = class("ClothDressingCell", BaseCell);

function ClothDressingCell:Init()
	ClothDressingCell.super.Init(self)
	self:FindObjs()
	self:AddCellClickEvent()
end

function ClothDressingCell:FindObjs()
	self.empty = self:FindGO("empty");
	self.item = self:FindGO("Item");
	self.chooseImg = self:FindGO("chooseImg");
	self.lockFlag = self:FindGO("lockFlag");
	self.iconColor = self:FindGO("iconColor"):GetComponent(GradientUISprite);
end

function ClothDressingCell:Choose()
	self:Show(self.chooseImg);
end

function ClothDressingCell:UnChoose()
	self:Hide(self.chooseImg);
end

function ClothDressingCell:SetData(data)
	self.data = data;
	if(data and data.id) then
		self:Show(self.item);
		self:Hide(self.empty);
		local shopType = ShopDressingProxy.Instance:GetShopType()
		local shopid = ShopDressingProxy.Instance:GetShopId()
		local tableData = ShopProxy.Instance:GetShopItemDataByTypeId(shopType,shopid,data.id)
		if(nil ~= tableData) then
			local clothColorID = tableData.clothColorID
			local csvData = clothColorID and Table_Couture[clothColorID]
			if(csvData) then
				local unlock = 0==data.MenuID or FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID)
				self.lockFlag:SetActive(not unlock)
				local topColor = csvData.ColorH
				local buttomColor = csvData.ColorD
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
		end
	else
		self:Hide(self.item);
		self:Show(self.empty);
	end
end
