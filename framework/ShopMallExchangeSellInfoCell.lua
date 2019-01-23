ShopMallExchangeSellInfoCell = class("ShopMallExchangeSellInfoCell", ItemTipBaseCell)

local temp = {}

function ShopMallExchangeSellInfoCell:Init()
	ShopMallExchangeSellInfoCell.super.Init(self)
	self:FindObjs()
	self:AddEvts()
end

function ShopMallExchangeSellInfoCell:FindObjs()
	self.sellPrice = self:FindGO("Price"):GetComponent(UILabel)
	self.confirmButton = self:FindGO("ConfirmButton"):GetComponent(UISprite)
	self.confirmLabel = self:FindGO("Label",self.confirmButton.gameObject):GetComponent(UILabel)
	self.cancelButton = self:FindGO("CancelButton")
	self.cancelLabel = self:FindGO("Label",self.cancelButton):GetComponent(UILabel)

	self.boothfee = self:FindGO("Boothfee")
	if self.boothfee then
		self.boothfee = self.boothfee:GetComponent(UILabel)
	end
	----[[ todo xde 改为  交易所上架道具界面，上架费用的字体大小不一致
	local boothfeeBg = self:FindGO("BoothfeeBg")
	local boothfeeTitle = self:FindGO("Title", boothfeeBg):GetComponent(UILabel)
	boothfeeTitle.overflowMethod = 3
	--]]
	self.ownLabel = self:FindGO("OwnLabel")
	if self.ownLabel then
		self.ownLabel = self.ownLabel:GetComponent(UILabel)
		local ownTitle = self:FindGO("OwnTitle")
		OverseaHostHelper:FixAnchor(self.ownLabel.leftAnchor, ownTitle.transform, 1, 4)
		
	end
	self.sellPricePlusBg = self:FindGO("SellPricePlusBg")
	if self.sellPricePlusBg then
		self.sellPricePlusBg = self.sellPricePlusBg:GetComponent(UISprite)
		self.sellPricePlus = self:FindGO("SellPlus",self.sellPricePlusBg.gameObject):GetComponent(UISprite)
	end
	self.sellPriceSubtractBg = self:FindGO("SellPriceSubtractBg")
	if self.sellPriceSubtractBg then
		self.sellPriceSubtractBg = self.sellPriceSubtractBg:GetComponent(UISprite)
		self.sellPriceSubtract = self:FindGO("SellSubtract",self.sellPriceSubtractBg.gameObject):GetComponent(UISprite)
	end
	self.sellPriceTip = self:FindGO("SellPriceTip")
	if self.sellPriceTip then
		self.sellPriceTip = self.sellPriceTip:GetComponent(UILabel)
	end
	self.sellCountInput = self:FindGO("SellCountBg")
	if self.sellCountInput then
		self.sellCountInput = self.sellCountInput:GetComponent(UIInput)
		if self.sellCountInput then
			UIUtil.LimitInputCharacter(self.sellCountInput, 6)
		end
	end
	self.sellCountLabel = self:FindGO("SellCount")
	if self.sellCountLabel then
		self.sellCountLabel = self.sellCountLabel:GetComponent(UILabel)
	end
	self.sellCountPlusBg = self:FindGO("SellCountPlusBg")
	if self.sellCountPlusBg then
		self.sellCountPlusBg = self.sellCountPlusBg:GetComponent(UISprite)
		self.sellCountPlus = self:FindGO("SellPlus",self.sellCountPlusBg.gameObject):GetComponent(UISprite)
	end
	self.sellCountSubtractBg = self:FindGO("SellCountSubtractBg")
	if self.sellCountSubtractBg then
		self.sellCountSubtractBg = self.sellCountSubtractBg:GetComponent(UISprite)
		self.sellCountSubtract = self:FindGO("SellSubtract",self.sellCountSubtractBg.gameObject):GetComponent(UISprite)
	end
	self.totalPrice = self:FindGO("TotalPrice")
	if self.totalPrice then
		self.totalPrice = self.totalPrice:GetComponent(UILabel)
	end
	self.closeBtn = self:FindGO("CloseButton")
end

function ShopMallExchangeSellInfoCell:AddEvts()
	self:AddClickEvent(self.confirmButton.gameObject,function (g)
		self:Confirm()
	end)
	self:AddClickEvent(self.cancelButton.gameObject,function (g)
		self:Cancel()
	end)
	if self.sellPricePlusBg then
		self:AddClickEvent(self.sellPricePlusBg.gameObject,function (g)
			self:UpdateSellPrice(10)
		end)
	end
	if self.sellPriceSubtractBg then
		self:AddClickEvent(self.sellPriceSubtractBg.gameObject,function (g)
			self:UpdateSellPrice(-10)
		end)
	end	
	if self.sellCountPlusBg then
		self:AddPressEvent(self.sellCountPlusBg.gameObject,function (g,b)
			self:PressCount(g,b,1)
		end)
	end
	if self.sellCountSubtractBg then
		self:AddPressEvent(self.sellCountSubtractBg.gameObject,function (g,b)
			self:PressCount(g,b,-1)
		end)
	end
	if self.sellCountInput then
		EventDelegate.Set(self.sellCountInput.onChange,function ()
			self:InputOnChange()
		end)
	end
	if self.closeBtn then
		self:SetEvent(self.closeBtn,function (g)
			self:PassEvent(ShopMallEvent.ExchangeCloseSellInfo, self)
		end)
	end
end

function ShopMallExchangeSellInfoCell:SetData(data)
	self.data = data
	
	if data then
		self:UpdateAttriContext()
		self:UpdateTopInfo()

		self.recommendPrice = 0
		self.count = 1
		if self.sellCountInput then
			self.sellCountInput.value = self.count
		end
		if self.sellPriceTip then
			self:ShowSellPriceTip(false)
			self.sellPriceRate = 0
		end

		if self.ownLabel then
			self.ownLabel.text = data.num
		end

		-- if self.data.sellType == ShopMallExchangeSellEnum.Sell then
		-- 	self.confirmLabel.text = ZhString.ShopMall_ExchangeSell
		-- 	self.cancelLabel.text = ZhString.ShopMall_ExchangeCancel

		-- elseif self.data.sellType == ShopMallExchangeSellEnum.Cancel then
		-- 	self.cancelLabel.text = ZhString.ShopMall_ExchangeCancel

 	-- 	elseif self.data.sellType == ShopMallExchangeSellEnum.Resell then
 	-- 		self.confirmLabel.text = ZhString.ShopMall_ExchangeResell
 	-- 		self.cancelLabel.text = ZhString.ShopMall_ExchangeCancelSell

 	-- 		if self.sellCountInput then
 	-- 			self.sellCountInput.enabled = false
 	-- 		end
	 -- 		self:SetSellCountPlus(0.5)
		-- 	self:SetSellCountSubtract(0.5)
 	-- 	end		

 		if data.shopMallItemData then
 			-- if self.data.sellType == ShopMallExchangeSellEnum.Cancel then
 			-- 	self:SetPrice(data.shopMallItemData.price)
 			-- end
 			-- if self.data.sellType == ShopMallExchangeSellEnum.Cancel and data.shopMallItemData.publicityId ~= 0 then
 			-- 	self:SetInvalidBtn(true)
 			-- end
 			if self.sellCountLabel then
 				self.sellCountLabel.text = data.shopMallItemData.count
 			end
			if self.sellCountInput then
				self.sellCountInput.value = data.shopMallItemData.count
			end
 		end

 		self.sellPrice.text = ZhString.ShopMall_ExchangePriceWait
 		if self.totalPrice then
 			self.totalPrice.text = ZhString.ShopMall_ExchangePriceWait
 		end
 		if self.boothfee then
 			self.boothfee.text = ZhString.ShopMall_ExchangePriceWait
 		end
 		if data.sellType ~= ShopMallExchangeSellEnum.Cancel then
 			self:SetInvalidBtn(true)
 		end
	end
end

function ShopMallExchangeSellInfoCell:SetPrice(price)
	self.recommendPrice = price
	self.sellPrice.text = StringUtil.NumThousandFormat( price )
	self.sellPriceNum = price
	local count = 1
	if self.data.shopMallItemData then
		count = self.data.shopMallItemData.count
	end
	if self.totalPrice then
		self.totalPriceNum = price * count
		self.totalPrice.text = StringUtil.NumThousandFormat( self.totalPriceNum )
	end
	if self.boothfee then
		self.boothfee.text = StringUtil.NumThousandFormat( ShopMallProxy.Instance:GetBoothfee(price,count) )
	end

	local equipInfo = self.data.equipInfo
	if self.data.sellType == ShopMallExchangeSellEnum.Resell and equipInfo and equipInfo.equiplv > 0 then
		self:SetInvalidBtn(true)
	else
		self:SetInvalidBtn(self.data.shopMallItemData and self.data.sellType == ShopMallExchangeSellEnum.Cancel and self.data.shopMallItemData.publicityId ~= 0)
	end
end

function ShopMallExchangeSellInfoCell:SetPublicity(statetype)
	if statetype == ShopMallStateTypeEnum.WillPublicity or statetype == ShopMallStateTypeEnum.InPublicity then
		self.publicityId = 1
	else
		self.publicityId = 0
	end
end

function ShopMallExchangeSellInfoCell:Confirm()
	if self.isInvalid then
		return
	end

 	if self.data then
 		if self.data.sellType == ShopMallExchangeSellEnum.Sell then

 		-- 	if ShopMallProxy.Instance:JudgeSpecialEquip(self.data) then
 		-- 		MsgManager.ConfirmMsgByID(10110, function ()
			-- 		self:SellOrder()
			-- 	end, nil ,nil)
			-- else
				-- self:SellOrder()
			-- end

			local id = 10301
			local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
			if dont == nil then
				MsgManager.DontAgainConfirmMsgByID(id, function ()
					self:CheckSellItem()
				end)
			else
				self:CheckSellItem()
			end

 		elseif self.data.sellType == ShopMallExchangeSellEnum.Cancel then

 			self:CancelOrder()

 		elseif self.data.sellType == ShopMallExchangeSellEnum.Resell then 

 			if self.data.shopMallItemData then
 				local itemInfo = {}
 				itemInfo.itemid = self.data.staticData.id
 				itemInfo.price = self.sellPriceNum
 				itemInfo.publicity_id = self.publicityId
 				ServiceRecordTradeProxy.Instance:CallResellPendingRecordTrade( itemInfo , Game.Myself.data.id , nil , self.data.shopMallItemData.orderId)
 			 else
 				errorLog("ShopMallExchangeSellInfoCell Confirm : self.data.shopMallItemData == nil")
 			end
 		end
 	end
end

function ShopMallExchangeSellInfoCell:CheckSellItem()
	local equipInfo = self.data.equipInfo
	if equipInfo and equipInfo.equiplv > 0 then
		local cost = GameConfig.EquipRecover.Upgrade[equipInfo.equiplv] or 0
		MsgManager.ConfirmMsgByID(10302, function ()
			-- self:SellOrder()
			ServiceItemProxy.Instance:CallRestoreEquipItemCmd(self.data.id , false , nil , false, true)
			self:PassEvent(ShopMallEvent.ExchangeCloseSellInfo, self)
		end, nil, nil, cost)
	else
		self:SellOrder()
	end
end

function ShopMallExchangeSellInfoCell:SellOrder()
	if self.sellPriceNum and self.sellPriceNum ~= 0 then
		local itemInfo = {}
		itemInfo.itemid = self.data.staticData.id
		itemInfo.price = self.sellPriceNum
		itemInfo.count = self.count
		itemInfo.guid = self.data.id
		itemInfo.publicity_id = self.publicityId
		-- if self.data.equipInfo then
		-- 	itemInfo.refine_lv = self.data.equipInfo.refinelv
		-- end
		itemInfo.item_data = self.data:ExportServerItem()

		TableUtility.TableClear(temp)
		temp.itemData = self.data
		temp.itemInfo = itemInfo

		FunctionSecurity.Me():Exchange_SellOrBuyItem(function (arg)
			ServiceRecordTradeProxy.Instance:CallSellItemRecordTradeCmd( arg.itemInfo , Game.Myself.data.id)
			
			LeanTween.delayedCall(1, function ()
					ServiceRecordTradeProxy.Instance:CallMyPendingListRecordTradeCmd( nil , Game.Myself.data.id)
					end)
			self:PassEvent(ShopMallEvent.ExchangeCloseSellInfo, self)

			local sellingData = ShopMallProxy.Instance:GetExchangeSelfSelling()
			if #sellingData < GameConfig.Exchange.MaxPendingCount then
				MsgManager.ShowMsgByID(10406)
			end
		end, temp)
	end
end

function ShopMallExchangeSellInfoCell:CancelOrder()
	 if self.data.shopMallItemData then
 		local order_id = self.data.shopMallItemData.orderId
 		ServiceRecordTradeProxy.Instance:CallCancelItemRecordTrade(nil , Game.Myself.data.id , nil , order_id)
 		printOrange("CallCancelItemRecordTrade~~~~~~~~~")
 	else
 		errorLog("ShopMallExchangeSellInfoCell CancelOrder : self.data.shopMallItemData == nil")
 	end
end

function ShopMallExchangeSellInfoCell:Cancel()
	if self.data.sellType == ShopMallExchangeSellEnum.Resell then
		self:CancelOrder()
	else
 		self:PassEvent(ShopMallEvent.ExchangeCloseSellInfo, self)
 	end
end

function ShopMallExchangeSellInfoCell:UpdateSellPrice(change)

	local priceRate = self.sellPriceRate + change

	if priceRate <= -50 then
		self:SetSellPricePlus(1)
		self:SetSellPriceSubtract(0.5)
	elseif priceRate >= 50 then
		self:SetSellPricePlus(0.5)
		self:SetSellPriceSubtract(1)
	else
		self:SetSellPricePlus(1)
		self:SetSellPriceSubtract(1)
	end

	if priceRate > 50 then
		return
	elseif priceRate < -50 then
		return
	end

	self.sellPriceRate = priceRate

	self.sellPriceNum = math.ceil(self.recommendPrice + self.recommendPrice * self.sellPriceRate / 100)
	self.sellPrice.text = StringUtil.NumThousandFormat( self.sellPriceNum )
	
	if self.sellPriceRate == 0 then
		self:ShowSellPriceTip(false)
	else
		self:ShowSellPriceTip(true)
	end

	local symbol = "+"
	if self.sellPriceRate < 0 then
		symbol = ""
	end
	local rate = symbol..tostring(self.sellPriceRate).."%"
	self.sellPriceTip.text = string.format(ZhString.ShopMall_ExchangeSellPriceRate,rate)

	if self.totalPrice then
		self.totalPriceNum = self.sellPriceNum * self.count
		self.totalPrice.text = StringUtil.NumThousandFormat( self.totalPriceNum )
	end
	if self.boothfee then
		self.boothfee.text = StringUtil.NumThousandFormat( ShopMallProxy.Instance:GetBoothfee(self.sellPriceNum,self.count) )
	end
end

function ShopMallExchangeSellInfoCell:PressCount(go,isPressed,change)
	if isPressed then
		self.countChangeRate = 1
		TimeTickManager.Me():CreateTick(0, 150, function (self, deltatime)
			self:UpdateSellCount(change) end, 
				self, 3);
	else
		TimeTickManager.Me():ClearTick(self,3)	
	end	
end

function ShopMallExchangeSellInfoCell:UpdateSellCount(change)
	local count = tonumber(self.sellCountInput.value) + self.countChangeRate * change

	if count < 1 then
		self.countChangeRate = 1
		return
	elseif count > self.data.num then
		self.countChangeRate = 1
		return
	end

	if count <= 1 then
		self:SetSellCountPlus(1)
		self:SetSellCountSubtract(0.5)
	elseif count >= self.data.num then
		self:SetSellCountPlus(0.5)
		self:SetSellCountSubtract(1)
	else
		self:SetSellCountPlus(1)
		self:SetSellCountSubtract(1)
	end

	self.count = count
	self.sellCountInput.value = count
	local price = self.sellPriceNum and self.sellPriceNum or 0
	self.totalPriceNum = price * count
	self.totalPrice.text = StringUtil.NumThousandFormat( self.totalPriceNum )
	self.boothfee.text = StringUtil.NumThousandFormat( ShopMallProxy.Instance:GetBoothfee(price,count) )

	if self.countChangeRate <= 3 then
		self.countChangeRate = self.countChangeRate + 1
	end
end

function ShopMallExchangeSellInfoCell:InputOnChange()
	local count = tonumber(self.sellCountInput.value)

	if count == nil then
		-- self.sellCountInput.value = self.count
		return
	end

	if count <= 1 then
		count = 1
		self:SetSellCountPlus(1)
		self:SetSellCountSubtract(0.5)
	elseif count >= self.data.num then
		count = self.data.num
		self:SetSellCountPlus(0.5)
		self:SetSellCountSubtract(1)
	else
		self:SetSellCountPlus(1)
		self:SetSellCountSubtract(1)
	end

	self.count = count
	self.sellCountInput.value = count
	local price = self.sellPriceNum and self.sellPriceNum or 0
	self.totalPriceNum = price * count
	self.totalPrice.text = StringUtil.NumThousandFormat( self.totalPriceNum )
	self.boothfee.text = StringUtil.NumThousandFormat( ShopMallProxy.Instance:GetBoothfee(price,count) )
end

function ShopMallExchangeSellInfoCell:ShowSellPriceTip(isShow)
	if isShow then
		if not self.sellPriceTip.gameObject.activeInHierarchy then
			self.sellPriceTip.gameObject:SetActive(true)
		end
	else
		if self.sellPriceTip.gameObject.activeInHierarchy then
			self.sellPriceTip.gameObject:SetActive(false)
		end
	end
end

function ShopMallExchangeSellInfoCell:SetSpritAlpha(sprit,alpha)
	sprit.color = Color(sprit.color.r,sprit.color.g,sprit.color.b,alpha)
end

function ShopMallExchangeSellInfoCell:SetSellPricePlus(alpha)
	if self.sellPricePlusBg and self.sellPricePlus then
		if self.sellPricePlusBg.color.a ~= alpha then
			self:SetSpritAlpha(self.sellPricePlusBg,alpha)
			self:SetSpritAlpha(self.sellPricePlus,alpha)
		end
	end
end

function ShopMallExchangeSellInfoCell:SetSellPriceSubtract(alpha)
	if self.sellPriceSubtractBg and self.sellPriceSubtract then
		if self.sellPriceSubtractBg.color.a ~= alpha then
			self:SetSpritAlpha(self.sellPriceSubtractBg,alpha)
			self:SetSpritAlpha(self.sellPriceSubtract,alpha)
		end
	end
end

function ShopMallExchangeSellInfoCell:SetSellCountPlus(alpha)
	if self.sellCountPlusBg and self.sellCountPlus then
		if self.sellCountPlusBg.color.a ~= alpha then
			self:SetSpritAlpha(self.sellCountPlusBg,alpha)
			self:SetSpritAlpha(self.sellCountPlus,alpha)
		end
	end
end

function ShopMallExchangeSellInfoCell:SetSellCountSubtract(alpha)
	if self.sellCountSubtractBg and self.sellCountSubtract then
		if self.sellCountSubtractBg.color.a ~= alpha then
			self:SetSpritAlpha(self.sellCountSubtractBg,alpha)
			self:SetSpritAlpha(self.sellCountSubtract,alpha)
		end
	end
end

function ShopMallExchangeSellInfoCell:SetInvalidBtn(isInvalid)
	if isInvalid then
		self.confirmButton.color = ColorUtil.NGUIShaderGray
		self.confirmLabel.effectColor = ColorUtil.NGUIGray
	else
		self.confirmButton.color = ColorUtil.NGUIWhite
		self.confirmLabel.effectColor = ColorUtil.ButtonLabelOrange
	end

	self.isInvalid = isInvalid
end