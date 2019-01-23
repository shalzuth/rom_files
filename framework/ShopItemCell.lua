ShopItemCell = class("ShopItemCell", ItemCell)

function ShopItemCell:Init()

	self.cellContainer = self:FindGO("CellContainer")
	if self.cellContainer then
		local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
		obj.transform.localPosition = Vector3.zero

		self.cellContainer:AddComponent(UIDragScrollView)
	end

	ShopItemCell.super.Init(self)
	self:FindObjs()
	self:AddEvts()

	self.NormalColor = "[ffffff]"
	self.WarnColor = "[FF3B0D]"
end

function ShopItemCell:FindObjs()
	self.itemName = self:FindGO("itemName"):GetComponent(UILabel)

	self.costGrid = self:FindGO("CostGrid"):GetComponent(UIGrid)

	self.costMoneySprite = {}
	self.costMoneySprite[1] = self:FindGO("costMoneySprite"):GetComponent(UISprite)
	self.costMoneySprite[2] = self:FindGO("costMoneySprite1"):GetComponent(UISprite)

	self.costMoneyNums = {}
	self.costMoneyNums[1] = self:FindGO("costMoneyNums"):GetComponent(UILabel)
	self.costMoneyNums[2] = self:FindGO("costMoneyNums1"):GetComponent(UILabel)

	self.buyCondition = self:FindGO("buyCondition"):GetComponent(UILabel)
	self.sellDiscount = self:FindGO("sellDiscount"):GetComponent(UILabel)
	--todo xde
	self.sellDiscount.spacingX = 0
	self.sellDiscountSp = self:FindGO("sellDiscountBg"):GetComponent(UIMultiSprite)

	self.primeCost = self:FindGO("primeCost"):GetComponent(UILabel)
	self.choose = self:FindGO("Choose")
	self.lock = self:FindGO("Lock")
	self.soldout = self:FindGO("Soldout")
end

function ShopItemCell:AddEvts()
	self:AddCellClickEvent()
	self:SetEvent(self.cellContainer, function ()
		self:PassEvent(HappyShopEvent.SelectIconSprite, self)
	end)
end

function ShopItemCell:SetData(data)
	local id = data
	data = HappyShopProxy.Instance:GetShopItemDataByTypeId(id)
	self.gameObject:SetActive(data ~= nil)
	
	if data then
		local itemData = data:GetItemData()
		local goodsCount = data.goodsCount
		if goodsCount and goodsCount > 1 then
			itemData.num = goodsCount
		end
		ShopItemCell.super.SetData(self, itemData)

	 	self.choose:SetActive(false)
	 	self:AddOrRemoveGuideId(self.gameObject)

	 	local itemId = data.goodsID
 		if itemId ~= nil then
			self:Show(self.itemName.gameObject)
			
			if(itemId == 12001)then
				self:AddOrRemoveGuideId(self.gameObject,11)
			end
			if(itemId == 14076)then
				self:AddOrRemoveGuideId(self.gameObject,19)
			end

			local goodsData = Table_Item[itemId]
			if goodsData then
				self.itemName.text = goodsData.NameZh
			end
		else
			errorLog("ShopItemCell data.goodsID = nil")
		end

	 	if data.Discount ~= nil and data.ItemCount ~= nil and data.ItemID ~= nil then
	 		local _HappyShopProxy = HappyShopProxy.Instance
	 		local totalPrice, discount = data:GetBuyDiscountPrice(data.ItemCount, 1)
			if discount < 100 then
		 		self:Show(self.sellDiscount.gameObject)

		 		local state, color = self:GetDiscountColor(discount)
		 		self.sellDiscountSp.CurrentState = state
		 		self.sellDiscount.effectColor = color
		 		self.sellDiscount.text= string.format(ZhString.HappyShop_discount, discount)

		 		self:Show(self.primeCost.gameObject)
		 		self.primeCost.text= ZhString.HappyShop_originalCost..StringUtil.NumThousandFormat(data.ItemCount)
			else
		 		self:Hide(self.sellDiscount.gameObject)
		 		self:Hide(self.primeCost.gameObject)
			end

			for i=1,#self.costMoneySprite do
				local temp = i
				if temp == 1 then
					temp = ""
				end
				local moneyId = data["ItemID"..temp]
				local icon = Table_Item[moneyId] and Table_Item[moneyId].Icon
				if icon then
					self.costMoneySprite[i].gameObject:SetActive(true)

					IconManager:SetItemIcon(icon,self.costMoneySprite[i])

					local totalPrice = data:GetBuyDiscountPrice(data["ItemCount"..temp], 1)
	 				self.costMoneyNums[i].text= StringUtil.NumThousandFormat(totalPrice)
				else
					self.costMoneySprite[i].gameObject:SetActive(false)
				end
			end
			self.costGrid:Reposition()
		else
			errorLog(string.format("ShopItemCell data.Discount = %s , data.ItemCount = %s , data.ItemID = %s",
				tostring(data.Discount),tostring(data.ItemCount),tostring(data.ItemID)))
		end

		if data:GetLock() then
			self:SetIconGrey(true)
			self.lock:SetActive(true)
			for i=1,#self.costMoneySprite do
				self.costMoneySprite[i].gameObject:SetActive(false)
			end

			local menuDes = data:GetMenuDes()
			if menuDes and #menuDes > 0 then
				self.buyCondition.text = menuDes
			end
		else
			self:SetIconGrey(false)
			self.lock:SetActive(false)

			self:RefreshBuyCondition(data);
			-- local str = data.des
			-- local levelDes = data.LevelDes
			-- local produceNum = data.produceNum
 		-- 	if #str > 0 then
 		-- 		self.buyCondition.text=str
 		-- 	elseif #levelDes > 0 then
 		-- 		local temp = levelDes
 		-- 		local useLv = 1

 		-- 		if itemId ~= nil and Table_Item[itemId] then
 		-- 			useLv = Table_Item[itemId].Level or 1
 		-- 		else
 		-- 			errorLog("ShopItemCell data.goodsID = nil")
 		-- 		end

 		-- 		local lvEnough = MyselfProxy.Instance:RoleLevel() >= useLv
 		-- 		if lvEnough then
 		-- 			temp = self.NormalColor..levelDes.."[-]"
 		-- 		else
 		-- 			temp = self.WarnColor..levelDes.."[-]"
 		-- 		end
 		-- 		self.buyCondition.text = temp
 		-- 	elseif produceNum ~= nil and produceNum > 0 then
			-- 	self.buyCondition.text = string.format(ZhString.HappyShop_ProduceNum, data.soldCount, produceNum)
			-- else
			-- 	self.buyCondition.text = ""
			-- end
		end

		local b = HappyShopProxy.Instance:JudgeCanBuy(data)
		self:SetActive(self.invalid,not b or itemData:IsJobLimit())

		--todo xde 售罄图标
		local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(data)
		self.soldout:SetActive(canBuyCount == 0)
	end

	self.data = id
end

function ShopItemCell:RefreshBuyCondition(data)
	if(data == nil)then
		data = HappyShopProxy.Instance:GetShopItemDataByTypeId(self.data)
	end
	if(data == nil)then
		return;
	end

	local str = data.des
	local levelDes = data.LevelDes
	local produceNum = data.produceNum
	if #str > 0 then
		self.buyCondition.text=str
	elseif #levelDes > 0 then
		local temp = levelDes
		local useLv = 1

		if itemId ~= nil and Table_Item[itemId] then
			useLv = Table_Item[itemId].Level or 1
		else
			errorLog("ShopItemCell data.goodsID = nil")
		end

		-- todo xde 翻译 xx级可装备
		levelDes = OverSea.LangManager.Instance():GetLangByKey(levelDes)
		local lvEnough = MyselfProxy.Instance:RoleLevel() >= useLv
		if lvEnough then
			temp = self.NormalColor..levelDes.."[-]"
		else
			temp = self.WarnColor..levelDes.."[-]"
		end
		self.buyCondition.text = temp
	elseif produceNum ~= nil and produceNum > 0 then
		local soldCount = data.soldCount or 0;
		self.buyCondition.text = string.format(ZhString.HappyShop_ProduceNum, produceNum - soldCount, produceNum)
	else
		self.buyCondition.text = ""
	end

end

function ShopItemCell:SetChoose(isChoose)
	if isChoose then
		self.choose:SetActive(true)
	else
		self.choose:SetActive(false)
	end
end

function ShopItemCell:GetDiscountColor(discount)
	if discount >= 0 and discount <= 20 then
		return 0, ColorUtil.DiscountLabel_Green
	elseif discount > 20 and discount <= 30 then
		return 1, ColorUtil.DiscountLabel_Blue
	elseif discount > 30 and discount <= 50 then
		return 2, ColorUtil.DiscountLabel_Purple
	elseif discount > 50 and discount <= 100 then
		return 3, ColorUtil.DiscountLabel_Yellow
	end
end