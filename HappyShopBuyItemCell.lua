autoImport("ShopItemInfoCell")
autoImport("ShopMultiplePriceCell")

HappyShopBuyItemCell = class("HappyShopBuyItemCell", ShopItemInfoCell)

function HappyShopBuyItemCell:FindObjs()
	HappyShopBuyItemCell.super.FindObjs(self)

	self.priceTitle = self:FindGO("PriceTitle"):GetComponent(UILabel)
	self.totalPriceTitle = self:FindGO("TotalPriceTitle"):GetComponent(UILabel)
	self.ownInfo = self:FindGO("OwnInfo"):GetComponent(UILabel)
	self.limitCount = self:FindGO("LimitCount"):GetComponent(UILabel)
	self.todayCanBuy = self:FindGO("TodayCanBuy"):GetComponent(UILabel)
	self.priceRoot = self:FindGO("PriceRoot")
	self.multiplePriceRoot = self:FindGO("MultiplePriceRoot")
end

function HappyShopBuyItemCell:SetData(data)
	if data then
		local _HappyShopProxy = HappyShopProxy.Instance
		local _HappyShopProxyLimitType = HappyShopProxy.LimitType

		self.shopdata = data;

		self.data = data:GetItemData()

		local moneyID = data.ItemID
		self.moneycount = data.ItemCount
		self.maxcount = nil

		--??????
		if data.ItemID2 then
			--?????????
			self:ShowMultiplePrice(true)

			if self.multiplePriceCtl == nil then
				local grid = self.multiplePriceRoot:GetComponent(UIGrid)
				self.multiplePriceCtl = UIGridListCtrl.new(grid, ShopMultiplePriceCell, "ShopMultiplePriceCell")
			end

			local list = ReusableTable.CreateArray()
			list[1] = moneyID
			list[2] = data.ItemID2
			self.multiplePriceCtl:ResetDatas(list)
			ReusableTable.DestroyArray(list)
		else
			--????????????
			self:ShowMultiplePrice(false)

			local moneyData = Table_Item[moneyID]
			if moneyData ~= nil then
				local icon = moneyData.Icon
				if icon ~= nil then
					IconManager:SetItemIcon(icon, self.priceIcon)
					IconManager:SetItemIcon(icon, self.totalPriceIcon)
				end
			end	
		end

		--???????????? ????????????
		local discountTotal
		self.discount, self.discountCount, discountTotal = data:GetTotalBuyDiscount(self.moneycount)
		if self.discount ~= 0 then
			self.salePrice:SetActive(true)
			self:UpdateSale(self.discount, self.discountCount)
		else
			self.salePrice:SetActive(false)
		end

		--?????????
		self:UpdateOwnInfo()

		local canBuyCount, limitType = _HappyShopProxy:GetCanBuyCount(data)
		if canBuyCount ~= nil then
			self.maxcount = canBuyCount

			self.todayCanBuy.gameObject:SetActive(true)
			local repStr
			if limitType == _HappyShopProxyLimitType.OneDay then
				repStr = ZhString.HappyShop_todayCanBuy
			elseif limitType == _HappyShopProxyLimitType.AccUser then
				repStr = ZhString.HappyShop_AccUserCanBuy
			elseif limitType == _HappyShopProxyLimitType.AccUserAlways then
				repStr = ZhString.HappyShop_AlwaysCanBuy
			elseif limitType == _HappyShopProxyLimitType.AccWeek then
				repStr = ZhString.HappyShop_AccWeekCanBuy
			elseif limitType == _HappyShopProxyLimitType.AccMonth then
				repStr = ZhString.HappyShop_AccMonthCanBuy
			elseif limitType == _HappyShopProxyLimitType.UserWeek then
				repStr = ZhString.HappyShop_AccUserWeekCanBuy
			end
			if(repStr)then
				self.todayCanBuy.text = string.format(repStr,self.maxcount,data.LimitNum)
			else
				self.todayCanBuy.text = ""
			end
		elseif data.discountMax ~= 0 then
			self.todayCanBuy.gameObject:SetActive(true)

			local leftCount = data.discountMax - _HappyShopProxy:GetDiscountItemCount(data.id)
			if leftCount < 0 then
				leftCount = 0
			end
			self.todayCanBuy.text = string.format(ZhString.HappyShop_ActivityCanBuy, data.actDiscount / 10, leftCount, data.discountMax)
		else
			self.todayCanBuy.gameObject:SetActive(false)
		end

		--????????????
		local limitCfg = data:GetItemData().staticData.GetLimit
		if _HappyShopProxy:CheckLimitCount(limitCfg) then
			self.canBuy = false
		else
			self.canBuy = true
		end

		self.limitCount.text = ""

		self:UpdateSoldCountInfo(data);
	end

	HappyShopBuyItemCell.super.SetData(self, data)
end

function HappyShopBuyItemCell:UpdateOwnInfo()
	local shopdata = self.shopdata
	if shopdata then
		local own = HappyShopProxy.Instance:GetItemNum(shopdata.goodsID, shopdata.source)
		if own then
			if shopdata.source == HappyShopProxy.SourceType.Guild then
				self.ownInfo.text = string.format(ZhString.HappyShop_OwnGuild, own)
			else
				self.ownInfo.text = string.format(ZhString.HappyShop_OwnInfo, own)
			end
		else
			self.ownInfo.text = 0
		end
	end
end

function HappyShopBuyItemCell:Confirm()
	if not self.canBuy then
		MsgManager.ShowMsgByID(3242)
		return
	end

	local item = HappyShopProxy.Instance:GetSelectId()
	local count = tonumber(self.countInput.value)
	if count == nil then
		self.countInput.value = self.count
		count = self.count
	end
	if item then
		HappyShopProxy.Instance:BuyItem(item,count)
	end

	HappyShopBuyItemCell.super.Confirm(self)
end

function HappyShopBuyItemCell:UpdateCount(change)
	HappyShopBuyItemCell.super.UpdateCount(self, change)

	if change > 0 then
		FunctionGuide.Me():buyItemCheck(self.count)
	end
end

function HappyShopBuyItemCell:UpdatePrice(count)
	if count == nil then
		count = 1
	end
	local totalPrice, discount = self.itemData:GetBuyDiscountPrice(self.moneycount, count)
	local price = discount * self.moneycount / 100

	if self.itemData.ItemID2 then
		--?????????
		local moneycount2 = self.itemData.ItemCount2
		totalPrice, discount = self.itemData:GetBuyDiscountPrice(moneycount2, count)
		local price2 = discount * moneycount2 / 100

		if self.multiplePriceCtl ~= nil then
			local cells = self.multiplePriceCtl:GetCells()
			cells[1]:SetPrice(price)
			cells[2]:SetPrice(price2)
		end
	else
		--?????????
		self.price.text = StringUtil.NumThousandFormat(price)
	end
end

function HappyShopBuyItemCell:UpdateTotalPrice(count)
	self.count = count

	local discountTotal = self.itemData:GetBuyFinalPrice(self.moneycount, count)
	if self.itemData.ItemID2 then
		--?????????
		if self.multiplePriceCtl ~= nil then
			local discountTotal2 = self.itemData:GetBuyFinalPrice(self.itemData.ItemCount2, count)

			local cells = self.multiplePriceCtl:GetCells()
			cells[1]:SetTotalPrice(discountTotal)
			cells[2]:SetTotalPrice(discountTotal2)
		end
	else
		--?????????
		self.totalPrice.text = StringUtil.NumThousandFormat(discountTotal)
	end

	self:UpdateSale(self.discount, self.discountCount)
	if self.countInput.value ~= tostring(count) then
		self.countInput.value = count
	end
end

function HappyShopBuyItemCell:UpdateSale(discount, totalCost)
	self.salePriceTip.text = string.format(ZhString.HappyShop_BuyCheap, 
				discount * 100, 
				StringUtil.NumThousandFormat(totalCost))
end

function HappyShopBuyItemCell:UpdateSoldCountInfo(data)
	data = data or self.shopdata;
	if(data == nil)then
		self.soldCount_Set = false;
		return;
	end

	local soldCount, produceNum = data.soldCount or 0, data.produceNum
	if(produceNum and produceNum > 0)then
		self.soldCount_Set = true;
		self.limitCount.text = string.format(ZhString.HappyShop_SoldCount, produceNum - soldCount, produceNum)
	else
		self.soldCount_Set = false;
	end
end

function HappyShopBuyItemCell:SetItemGetCount(data)
	if self.itemData == nil then
		return
	end

	if(self.soldCount_Set)then
		return;
	end

	if data.itemid == self.itemData.goodsID then
		self.canBuy = true

		--??????????????????
		local left = ItemData.Get_GetLimitCount(self.itemData.goodsID) - data.count
		if left < 0 then
			left = 0
		end
		local limitCfg = self.itemData:GetItemData().staticData.GetLimit
		if limitCfg.type == 1 then
			str = ZhString.ItemTip_GetLimit_Day
		elseif limitCfg.type == 7 then
			str = ZhString.ItemTip_GetLimit_Weak
		end
		self.limitCount.text = string.format(ZhString.HappyShop_LimitCount, str, left)

		--???????????????????????????
		self.maxcount = left
		local count = 1
		if left == 0 then
			count = 0
		end
		self.countInput.value = count
		self:InputOnChange()
	end
end

function HappyShopBuyItemCell:SetLimitCountText(text)
	if(text ~= nil and text ~= "")then
		self.limitCount.gameObject:SetActive(true);
		self.limitCount.text = text;
	else
		self.limitCount.gameObject:SetActive(false);
	end
end

function HappyShopBuyItemCell:ShowMultiplePrice(isShow)
	self.multiplePriceRoot:SetActive(isShow)
	self.priceRoot:SetActive(not isShow)
end