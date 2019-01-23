autoImport("BoothInfoBaseCell")

BoothSellInfoCell = class("BoothSellInfoCell", BoothInfoBaseCell)

local _itemInfo = {}

function BoothSellInfoCell:Init()
	BoothSellInfoCell.super.Init(self)
	self:FindObjs()
	self:AddEvts()
end

function BoothSellInfoCell:FindObjs()
	BoothSellInfoCell.super.FindObjs(self)
	self.own = self:FindGO("OwnLabel"):GetComponent(UILabel)
	self.sellPriceSubtract = self:FindGO("SellPriceSubtractBg"):GetComponent(UISprite)
	self.sellPricePlus = self:FindGO("SellPricePlusBg"):GetComponent(UISprite)
	self.sellPriceTip = self:FindGO("SellPriceTip"):GetComponent(UILabel)
	self.totalPrice = self:FindGO("TotalPrice"):GetComponent(UILabel)
	self.boothfee = self:FindGO("Boothfee"):GetComponent(UILabel)
	self.quota = self:FindGO("Quota"):GetComponent(UILabel)
end

function BoothSellInfoCell:AddEvts()
	BoothSellInfoCell.super.AddEvts(self)
	self:AddClickEvent(self.sellPriceSubtract.gameObject,function (g)
		self:ClickPrice(-10)
	end)
	self:AddClickEvent(self.sellPricePlus.gameObject,function (g)
		self:ClickPrice(10)
	end)
end

function BoothSellInfoCell:SetData(data)
	BoothSellInfoCell.super.SetData(self, data)
	
	if data then
		self.count = 1
		self.maxCount = data.num
		self.priceRate = 0

		self.own.text = data.num
		
		self:UpdateSellCount()
		self:SetInvalidBtn(true)
	end
end

function BoothSellInfoCell:UpdateSellCount()
	self.countInput.value = self.count
end

function BoothSellInfoCell:UpdateSellPrice()
	if self.price ~= nil then
		self.priceLabel.text = StringUtil.NumThousandFormat(self:GetPrice())
	end
end

function BoothSellInfoCell:UpdateTotalPrice()
	if self.price ~= nil then
		self.totalPrice.text = StringUtil.NumThousandFormat(self:GetPrice() * self.count)
	end
end

function BoothSellInfoCell:UpdateQuota()
	if self.price ~= nil then
		self.quota.text = StringUtil.NumThousandFormat(BoothProxy.Instance:GetQuota(self:GetPrice() * self.count, self:GetPublicityId()))
	end
end

function BoothSellInfoCell:UpdateBoothFee()
	if self.price ~= nil then
		self.boothfee.text = StringUtil.NumThousandFormat(ShopMallProxy.Instance:GetBoothfee(self:GetPrice(), self.count))
	end
end

function BoothSellInfoCell:UpdatePriceRate()
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

function BoothSellInfoCell:UpdatePrice()
	self:UpdateSellPrice()
	self:UpdateTotalPrice()
	self:UpdateQuota()
	self:UpdateBoothFee()
end

function BoothSellInfoCell:ClickPrice(change)
	if self.isInvalid then
		return
	end

	local priceRate = self.priceRate + change
	if (self.stateType == ShopMallStateTypeEnum.WillPublicity or self.stateType == ShopMallStateTypeEnum.InPublicity) and priceRate == 0 then
		priceRate = priceRate + change
	end
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

function BoothSellInfoCell:Confirm()
	if self.isInvalid then
		return
	end

	if self.data == nil then
		return
	end

	local _MyselfProxy = MyselfProxy.Instance
	if _MyselfProxy:GetROB() < ShopMallProxy.Instance:GetBoothfee(self:GetPrice(), self.count) then
		MsgManager.ShowMsgByID(10109)
		return
	end

	if _MyselfProxy:GetQuota() < BoothProxy.Instance:GetQuota(self:GetPrice() * self.count, self:GetPublicityId()) then
		MsgManager.ShowMsgByID(25703)
		return
	end

	local id = 10301
	local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
	if dont == nil then
		MsgManager.DontAgainConfirmMsgByID(id, function ()
			self:CheckSellItem()
		end)
	else
		self:CheckSellItem()
	end
end

function BoothSellInfoCell:CheckSellItem()
	local equipInfo = self.data.equipInfo
	if equipInfo and equipInfo.equiplv > 0 then
		local cost = GameConfig.EquipRecover.Upgrade[equipInfo.equiplv] or 0
		MsgManager.ConfirmMsgByID(10302, function ()
			ServiceItemProxy.Instance:CallRestoreEquipItemCmd(self.data.id, false, nil, false, true)
			self:PassEvent(BoothEvent.CloseInfo, self)
		end, nil, nil, cost)
	else
		if self.price ~= nil then
			TableUtility.TableClear(_itemInfo)
			_itemInfo.itemid = self.data.staticData.id
			_itemInfo.price = self.price
			_itemInfo.count = self.count
			_itemInfo.guid = self.data.id
			_itemInfo.item_data = self.data:ExportServerItem()
			_itemInfo.publicity_id = self:GetPublicityId()
			if self.priceRate > 0 then
				_itemInfo.up_rate = self.priceRate * 10
			elseif self.priceRate < 0 then
				_itemInfo.down_rate = math.abs(self.priceRate) * 10
			end

			FunctionSecurity.Me():Exchange_SellOrBuyItem(function (arg)
				ServiceRecordTradeProxy.Instance:CallSellItemRecordTradeCmd(arg, Game.Myself.data.id, nil, BoothProxy.TradeType.Booth)
				self:PassEvent(BoothEvent.CloseInfo, self)
			end, _itemInfo)
		end
	end
end

function BoothSellInfoCell:SetPrice(price, priceRate, statetype)
	self.price = price

	self:SetInvalidBtn(false)
	if self.stateType == ShopMallStateTypeEnum.WillPublicity or self.stateType == ShopMallStateTypeEnum.InPublicity then
		self.publicityId = 1
		self:ClickPrice(10)
	else
		self.publicityId = 0
		self:ClickPrice(-10)
	end
end

function BoothSellInfoCell:SetPriceRate(minRate, maxRate)
	self.minPriceRate = minRate
	self.maxPriceRate = maxRate
end

function BoothSellInfoCell:GetPublicityId()
	return self.publicityId or 0
end

function BoothSellInfoCell:SetAlpha(sprite, alpha)
	if sprite.color.a ~= alpha then
		sprite.alpha = alpha
	end
end

function BoothSellInfoCell:GetPrice()
	return self.price * (1 + self.priceRate / 100)
end