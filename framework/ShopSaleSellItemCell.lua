autoImport("ShopItemInfoCell")
ShopSaleSellItemCell = class("ShopSaleSellItemCell", ShopItemInfoCell)

function ShopSaleSellItemCell:SetData(data)
	if data then
		self.data = data

		local moneytype = data.moneytype
		self.moneycount = ShopSaleProxy.Instance:GetPrice(data)
		self.maxcount = data.maxcount

		IconManager:SetMoneyIcon(moneytype, self.priceIcon)
		IconManager:SetMoneyIcon(moneytype, self.totalPriceIcon)

		--低价买进 高价卖出
		self.discount, self.discountCount, self.discountTotal = ShopSaleProxy.Instance:GetTotalSellDiscount(self.moneycount)
		if self.discount ~= 0 then
			self.salePrice:SetActive(true)
			self:UpdateSale(self.discount, self.discountCount)
		else
			self.salePrice:SetActive(false)
		end
	end

	ShopSaleSellItemCell.super.SetData(self, data)
end

function ShopSaleSellItemCell:Confirm()
	local nums = self.count
	if(nums>0)then
		self:CalcTotalPrice(nums)
		ShopSaleProxy.Instance:AddToWaitSaleItems(self.data.id,nums,self.totalCost)
		self:PassEvent(ShopSaleEvent.SaleSuccess)
	end	

	ShopSaleSellItemCell.super.Confirm(self)
end

--参数：数量
function ShopSaleSellItemCell:CalcTotalPrice(count)
	self.totalCost = ShopSaleSellItemCell.super.CalcTotalPrice(self, count)	--折扣前的总价格
	--折扣，多得的总金额，折扣后的总价格
	self.discount, self.discountCount, self.discountTotal = ShopSaleProxy.Instance:GetTotalSellDiscount(self.totalCost)
end

function ShopSaleSellItemCell:UpdateSale(discount, totalCost)
	self.salePriceTip.text = string.format(ZhString.ShopSale_SellExpensive, 
				discount * 100, 
				StringUtil.NumThousandFormat(totalCost))
end