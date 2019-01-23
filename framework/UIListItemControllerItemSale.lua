autoImport('IconManager')
autoImport('UIPriceDiscount')
autoImport('FuncZenyShop')

UIListItemControllerItemSale = class('UIListItemControllerItemSale', BaseCell)

function UIListItemControllerItemSale:Init()
	self:GetGameObjects()
end

function UIListItemControllerItemSale:SetData(data)
	self.shopItemData = data

	self:GetModelSet()
	self:LoadView()
	self:RegisterClickEvent()
end

function UIListItemControllerItemSale:GetGameObjects()
	self.spIcon = self:FindGO('Icon', self.gameObject):GetComponent(UISprite)
	self.labCount = self:FindGO('Count'):GetComponent(UILabel)
	self.labName = self:FindGO('Name', self.gameObject):GetComponent(UILabel)
	self.goPrice = self:FindGO('Price')
	self.labPrice = self:FindGO('Lab', self.goPrice):GetComponent(UILabel)
	self.spGoldIcon = self:FindGO('Icon', self.goPrice):GetComponent(UISprite)
	IconManager:SetItemIcon('item_151', self.spGoldIcon)
	self.goOriginPrice = self:FindGO('OriginPrice')
	self.labOriginPrice = self:FindGO('Lab', self.goOriginPrice):GetComponent(UILabel)
	self.goPriceBG = self:FindGO('BG', self.goPrice)
	self.goDiscount = self:FindGO('Discount', self.gameObject)
	self.goPercent = self:FindGO('Percent', self.goDiscount)
	self.labPercent = self:FindGO('Value1', self.goPercent):GetComponent(UILabel)
	self.labPercentSymbol = self:FindGO('Value2', self.goPercent):GetComponent(UILabel)
	self.spPercentBG = self:FindGO('BG', self.goPercent):GetComponent(UIMultiSprite)
	self.goSoldOut = self:FindGO('SoldOut')
end

function UIListItemControllerItemSale:RegisterClickEvent()
	self:AddClickEvent(self.gameObject, function ()
		self:OnClickForSelf()
	end)
	self:AddClickEvent(self.goPriceBG, function ()
		self:OnClickForPriceView()
	end)
	self:AddClickEvent(self.spIcon.gameObject, function ()
		self:OnClickForIconView()
	end)
end

function UIListItemControllerItemSale:GetModelSet()
	self.itemID = self.shopItemData.goodsID
	self.itemConf = Table_Item[self.itemID]
	self.canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(self.shopItemData)
end

function UIListItemControllerItemSale:LoadView()
	if(self.itemConf == nil)then
		redlog("Good Is Nil:", self.itemID);
		return;
	end
	IconManager:SetItemIcon(self.itemConf.Icon, self.spIcon)
	self.labCount.text = self.shopItemData.goodsCount
	self.labName.text = self.itemConf.NameZh
	self.price = self:GetDiscountPrice()
	self.labPrice.text = FuncZenyShop.FormatMilComma(self.price)
	local canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(self.shopItemData)
	if self:IsSoldOut() then
		self.goSoldOut:SetActive(true)
	else
		self.goSoldOut:SetActive(false)
	end
	if self:IsDiscount() then
		self.goOriginPrice:SetActive(true)
		self.labOriginPrice.text = ZhString.HappyShop_originalCost .. FuncZenyShop.FormatMilComma(self.shopItemData.ItemCount)
		self.goDiscount:SetActive(true)
		self.labPercent.text = self.shopItemData.actDiscount
		local mulSpriteState, color = UIPriceDiscount.GetDiscountColor(self.shopItemData.actDiscount)
		self.labPercent.effectColor = color
		self.labPercentSymbol.effectColor = color
		self.spPercentBG.CurrentState = mulSpriteState
	else
		self.goOriginPrice:SetActive(false)
		self.goDiscount:SetActive(false)
	end

	--todo xde
	self.nameBG = self:FindComponent("NameBG",UISprite)
	self.nameBG.transform.localPosition = Vector3(361.5,-30,0)
	self.nameBG.height = 60
	self.labName.fontSize = 23
	self.labName.spacingY = 1
	self.labName.transform.localPosition = Vector3(243.2,-32,0)
	OverseaHostHelper:FixLabelOverV1(self.labName,3,220)
end

function UIListItemControllerItemSale:OnClickForSelf()
	UISubViewControllerZenyShopItem.instance:LoadPurchaseDetailView(self.shopItemData)
	HappyShopProxy.Instance:SetSelectId(self.shopItemData.id)
end

function UIListItemControllerItemSale:OnClickForPriceView()
	if self:IsHaveEnoughCostForBuy() then
		if not self.shopItemData:CheckCanRemove() then
			ServiceSessionShopProxy.Instance:CallBuyShopItem(self.shopItemData.id, 1)
		end
	end
end

function UIListItemControllerItemSale:OnClickForIconView()
	local itemData = ItemData.new(nil, self.itemID)
	local tab = ReusableTable.CreateTable()
	tab.itemdata = itemData
	self:ShowItemTip(tab, UISubViewControllerZenyShopItem.instance.widgetTipRelative, NGUIUtil.AnchorSide.Center, {-148, -37})
	ReusableTable.DestroyAndClearTable(tab)
end

function UIListItemControllerItemSale:IsHaveEnoughCostForBuy()
	local bCatGold = MyselfProxy.Instance:GetLottery()
	if bCatGold < self.price then
		local sysMsgID = 3634
		MsgManager.ShowMsgByID(sysMsgID)
		return false
	else
		return true
	end
end

function UIListItemControllerItemSale:GetDiscountPrice()
	local retValue = nil
	if self.shopItemData.actDiscount == 0 then
		retValue = self.shopItemData.ItemCount
	else
		retValue = self.shopItemData.ItemCount * self.shopItemData.actDiscount / 100
	end
	return math.ceil(retValue)
end

function UIListItemControllerItemSale:IsDiscount()
	return self:GetDiscountPrice() < self.shopItemData.ItemCount
end

function UIListItemControllerItemSale:IsSoldOut()
	return self.canBuyCount ~= nil and self.canBuyCount <= 0
end