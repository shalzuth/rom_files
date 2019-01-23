autoImport("BoothInfoBaseCell")

BoothResellInfoCell = class("BoothResellInfoCell", BoothInfoBaseCell)

local _itemInfo = {}

function BoothResellInfoCell:Init()
	BoothResellInfoCell.super.Init(self)
	self:FindObjs()
	self:AddEvts()
end

function BoothResellInfoCell:FindObjs()
	BoothResellInfoCell.super.FindObjs(self)
	self.own = self:FindGO("OwnLabel"):GetComponent(UILabel)
	self.sellCount = self:FindGO("SellCount"):GetComponent(UILabel)
	self.sellPriceSubtract = self:FindGO("SellPriceSubtractBg"):GetComponent(UISprite)
	self.sellPricePlus = self:FindGO("SellPricePlusBg"):GetComponent(UISprite)
	self.sellPriceTip = self:FindGO("SellPriceTip"):GetComponent(UILabel)
	self.totalPrice = self:FindGO("TotalPrice"):GetComponent(UILabel)
	self.boothfee = self:FindGO("Boothfee"):GetComponent(UILabel)
	self.quota = self:FindGO("Quota"):GetComponent(UILabel)
	self.quotaTitle = self:FindGO("QuotaTitle"):GetComponent(UILabel)
end

function BoothResellInfoCell:AddEvts()
	BoothResellInfoCell.super.AddEvts(self)
	self:AddClickEvent(self.sellPriceSubtract.gameObject,function (g)
		self:ClickPrice(-10)
	end)
	self:AddClickEvent(self.sellPricePlus.gameObject,function (g)
		self:ClickPrice(10)
	end)
end

function BoothResellInfoCell:SetData(data)
	BoothResellInfoCell.super.SetData(self, data)
	
	if data then
		self.count = data.num
		self.priceRate = 0

		self.own.text = data.num
		
		self:UpdateSellCount()
		self:SetInvalidBtn(true)
	end
end

function BoothResellInfoCell:UpdateSellCount()
	self.sellCount.text = self.count
end

function BoothResellInfoCell:UpdateSellPrice()
	if self.price ~= nil then
		self.priceLabel.text = StringUtil.NumThousandFormat(self:GetPrice())
	end
end

function BoothResellInfoCell:UpdateTotalPrice()
	if self.price ~= nil then
		self.totalPrice.text = StringUtil.NumThousandFormat(self:GetPrice() * self.count)
	end
end

function BoothResellInfoCell:UpdateQuota()
	if self.price ~= nil then
		local offsetQuota = self:GetOffsetQuota()
		if offsetQuota ~= nil then
			if offsetQuota > 0 then
				self.quotaTitle.text = ZhString.Booth_ExchangeResellAdd
			else
				self.quotaTitle.text = ZhString.Booth_ExchangeResellReduce
			end
			self.quota.text = StringUtil.NumThousandFormat(math.abs(offsetQuota))
		end
	end
end

function BoothResellInfoCell:UpdateBoothFee()
	if self.price ~= nil then
		self.boothfee.text = StringUtil.NumThousandFormat(ShopMallProxy.Instance:GetBoothfee(self:GetPrice(), self.count))
	end
end

function BoothResellInfoCell:UpdatePriceRate()
	if self.priceRate == 0 then
		ColorUtil.DeepGrayUIWidget(self.sellPriceTip)
		self.sellPriceTip.text = ZhString.Booth_ExchangeSellPriceRateTip
	elseif self.priceRate < 0 then
		self.sellPriceTip.color = ColorUtil.NGUILabelRed

		local sb = LuaStringBuilder.CreateAsTable()
		sb:Append(ZhString.Booth_ExchangeSellPriceRateTip)
		sb:Append(self.priceRate)
		sb:Append("%")
		self.sellPriceTip.text = sb:ToString()
		sb:Destroy()
	elseif self.priceRate > 0 then
		self.sellPriceTip.color = ColorUtil.ButtonLabelGreen

		local sb = LuaStringBuilder.CreateAsTable()
		sb:Append(ZhString.Booth_ExchangeSellPriceRateTip)
		sb:Append("+")
		sb:Append(self.priceRate)
		sb:Append("%")
		self.sellPriceTip.text = sb:ToString()
		sb:Destroy()
	end
end

function BoothResellInfoCell:UpdatePrice()
	self:UpdateSellPrice()
	self:UpdateTotalPrice()
	self:UpdateQuota()
	self:UpdateBoothFee()
end

function BoothResellInfoCell:ClickPrice(change)
	if self.isInvalid then
		return
	end

	local priceRate = self.priceRate + change
	if priceRate <= self.minPriceRate then
		priceRate = self.minPriceRate
	elseif priceRate >= self.maxPriceRate then
		priceRate = self.maxPriceRate		
	end
	local alpha = priceRate <= self.minPriceRate and 0.5 or 1
	self:SetAlpha(self.sellPriceSubtract, alpha)
	alpha = priceRate >= self.maxPriceRate and 0.5 or 1
	self:SetAlpha(self.sellPricePlus, alpha)

	self.priceRate = priceRate

	self:UpdatePrice()
	self:UpdatePriceRate()
end

function BoothResellInfoCell:Confirm()
	if self.isInvalid then
		return
	end

	if self.data == nil then
		return
	end

	local _MyselfProxy = MyselfProxy.Instance
	local totalPrice = self:GetPrice() * self.count
	if _MyselfProxy:GetROB() < totalPrice + ShopMallProxy.Instance:GetBoothfee(self:GetPrice(), self.count) then
		MsgManager.ShowMsgByID(10109)
		return
	end

	local offsetQuota = self:GetOffsetQuota()
	if offsetQuota == nil then
		return
	end
	if offsetQuota > 0 and _MyselfProxy:GetQuota() < offsetQuota then
		MsgManager.ShowMsgByID(25703)
		return
	end

	TableUtility.TableClear(_itemInfo)
	_itemInfo.itemid = self.data.staticData.id
	_itemInfo.price = self.price
	_itemInfo.publicity_id = self:GetPublicityId()
	if self.priceRate > 0 then
		_itemInfo.up_rate = self.priceRate * 10
	elseif self.priceRate < 0 then
		_itemInfo.down_rate = math.abs(self.priceRate) * 10
	end
	ServiceRecordTradeProxy.Instance:CallResellPendingRecordTrade(_itemInfo, Game.Myself.data.id, nil, self.orderId, BoothProxy.TradeType.Booth)	
	self:PassEvent(BoothEvent.CloseInfo, self)
end

function BoothResellInfoCell:Cancel()
	ServiceRecordTradeProxy.Instance:CallCancelItemRecordTrade(nil, Game.Myself.data.id, nil, self.orderId, BoothProxy.TradeType.Booth)
	BoothResellInfoCell.super.Cancel(self)
end

function BoothResellInfoCell:SetOrderId(orderId)
	self.orderId = orderId
end

function BoothResellInfoCell:SetPrice(price, priceRate, statetype)
	self.price = price

	self:SetInvalidBtn(false)
	if self.stateType == ShopMallStateTypeEnum.WillPublicity or self.stateType == ShopMallStateTypeEnum.InPublicity then
		self:ClickPrice(10)
		self.publicityId = 1
	else
		self:ClickPrice(-10)
		self.publicityId = 0
	end
end

function BoothResellInfoCell:SetPriceRate(minRate, maxRate)
	self.minPriceRate = minRate
	self.maxPriceRate = maxRate
end

function BoothResellInfoCell:GetPublicityId()
	return self.publicityId or 0
end

function BoothResellInfoCell:SetOriginalQuota(quota)
	self.originalQuota = quota
end

function BoothResellInfoCell:SetAlpha(sprite, alpha)
	if sprite.color.a ~= alpha then
		sprite.alpha = alpha
	end
end

function BoothResellInfoCell:GetPrice()
	return self.price * (1 + self.priceRate / 100)
end

function BoothResellInfoCell:GetOffsetQuota()
	if self.price ~= nil and self.originalQuota ~= nil then
		local _BoothProxy = BoothProxy.Instance
		local quota = _BoothProxy:GetQuota(self:GetPrice() * self.count, self:GetPublicityId())
		local originalQuota = _BoothProxy:GetValidQuota(self.originalQuota * self.count)
		local offsetQuota = quota - originalQuota
		if offsetQuota < 0 then
			local isChange = false
			offsetQuota, isChange = _BoothProxy:GetValidQuota(offsetQuota)
			if isChange then
				return offsetQuota * -1
			end
		end
		return offsetQuota
	end
end