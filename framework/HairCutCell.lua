local BaseCell = autoImport("BaseCell");
HairCutCell = class("HairCutCell", BaseCell);

function HairCutCell:Init()
	HairCutCell.super.Init(self)
	self:FindObjs()
	self:AddCellClickEvent()
end

function HairCutCell:FindObjs()
	self.empty = self:FindGO("empty");
	self.item = self:FindGO("Item");
	self.chooseImg = self:FindGO("chooseImg");
	self.icon = self:FindComponent("icon",UISprite);
	self.newFlag = self:FindGO("NewFlag");
	self.lockFlag = self:FindGO("lockFlag");
	self.hairName = self:FindComponent("hairName",UILabel);
end

function HairCutCell:Choose()
	self:Show(self.chooseImg);
end

function HairCutCell:UnChoose()
	self:Hide(self.chooseImg);
end

function HairCutCell:SetData(data)
	self.data = data;
	if(data and data.id) then
		self:Show(self.item);
		self:Hide(self.empty);
		local shopType = ShopDressingProxy.Instance:GetShopType()
		local shopid = ShopDressingProxy.Instance:GetShopId()
		local tableData = ShopProxy.Instance:GetShopItemDataByTypeId(shopType,shopid,data.id)
		if(nil ~= tableData) then
			if(tableData.goodsID) then
				self.hairName.text = Table_Item[tableData.goodsID].NameZh
				local hairstyleID = ShopDressingProxy.Instance:GetHairStyleIDByItemID(tableData.goodsID);
				if(nil==hairstyleID)then return end
				local unlock = ShopDressingProxy.Instance:bActived(hairstyleID,ShopDressingProxy.DressingType.HAIR);
				if(unlock) then
					self:Hide(self.lockFlag)
					self:SetTextureWhite(self.icon.gameObject)
				else
					self:Show(self.lockFlag)
					self:SetTextureGrey(self.icon.gameObject)
				end
				local hairTableData = Table_HairStyle[hairstyleID]
				if (hairTableData and hairTableData.Icon) then
					IconManager:SetHairStyleIcon(hairTableData.Icon , self.icon)
				end
			end
		end
	else
		self:Hide(self.item);
		self:Show(self.empty);
	end
end


