local baseCell = autoImport("BaseCell")
ExchangeSellIntroduceCell = class("ExchangeSellIntroduceCell", baseCell)

function ExchangeSellIntroduceCell:Init()
	self:FindObjs()
	self:InitShow()
end

function ExchangeSellIntroduceCell:FindObjs()
	self.countDown = self:FindGO("CountDown")
	if self.countDown then
		self.countDown = self.countDown:GetComponent(UILabel)
	end
	self.count = self:FindGO("Count")
	if self.count then
		self.count = self.count:GetComponent(UILabel)
	end
	self.buyerCount = self:FindGO("BuyerCount")
	if self.buyerCount then
		self.buyerCount = self.buyerCount:GetComponent(UILabel)
	end
	self.info = self:FindGO("Info")
	if self.info then
		self.info = self.info:GetComponent(UILabel)
	end
	self.info2 = self:FindGO("Info2")
	if self.info2 then
		self.info2 = self.info2:GetComponent(UILabel)
	end
	self.info3 = self:FindGO("Info3")
	if self.info3 then
		self.info3 = self.info3:GetComponent(UILabel)
	end
	self.table = self:FindGO("Table")
	if self.table then
		self.table = self.table:GetComponent(UITable)
	end
	self.rate = self:FindGO("Rate")
	if self.rate then
		self.rate = self.rate:GetComponent(UILabel)
	end
	self.tip = self:FindGO("Tip")
end

function ExchangeSellIntroduceCell:InitShow()
	-- body
end

function ExchangeSellIntroduceCell:SetData(data)
	self.data = data
	if data then
		local type = data.type
		local itemData = data.itemData
		local staticData = itemData.staticData
		local isShowEnchant = self:IsShowEnchant(itemData)

		if self.rate then
			self.rate.text = string.format(ZhString.ShopMall_ExchangeRateTitle , CommonFun.calcTradeTax(data.price))
		end

		if type == ShopMallStateTypeEnum.WillPublicity then		
			local showTime = Table_Exchange[staticData.id] and Table_Exchange[staticData.id].ShowTime or 0

			if self.info then
				self.info.text = string.format( GameConfig.Exchange.SellShow1 , staticData.NameZh )
			end
			if self.info2 then
				self.info2.text = string.format( GameConfig.Exchange.SellShow3 , staticData.NameZh , math.ceil(showTime/60))
			end

			if self.info3 then
				self.info3.gameObject:SetActive(isShowEnchant)
				if isShowEnchant then
					self:SetEnchantLabel(itemData,self.info3)
				end			
			end
			if self.tip then
				self.tip:SetActive(isShowEnchant)
			end

			if self.table then
				self.table:Reposition()
			end

		elseif type == ShopMallStateTypeEnum.InPublicity then
			if self.timeTick == nil then
				self.timeTick = TimeTickManager.Me():CreateTick(0,1000,self.UpdateCountDown,self)
			end
			if self.count then
				self.count.text = string.format(ZhString.ShopMall_IntroduceCount, data.count)
			end
			if self.buyerCount then
				self.buyerCount.text = string.format(ZhString.ShopMall_IntroduceBuyerCount, data.buyerCount)
			end
			if self.info then
				self.info.text = string.format( GameConfig.Exchange.SellShow4 , staticData.NameZh )
			end

			if self.info2 then
				self.info2.gameObject:SetActive(isShowEnchant)
				if isShowEnchant then
					self:SetEnchantLabel(itemData,self.info2)
				end
			end
			if self.tip then
				self.tip:SetActive(isShowEnchant)
			end

			if self.table then
				self.table:Reposition()
			end

		else
			if self.count then
				self.count.text = data.count
			end
			--拥有附魔装备
			if self.info then
				if isShowEnchant then
					self:SetEnchantLabel(itemData,self.info)
				end
			end
		end
	end
end

function ExchangeSellIntroduceCell:UpdateCountDown()
	if self.data then
		local time = self.data.endTime - ServerTime.CurServerTime()/1000
		local min,sec
		if time > 0 then
			min,sec = ClientTimeUtil.GetFormatSecTimeStr( time )
		else
			min = 0
			sec = 0
		end
		self.countDown.text = string.format( ZhString.ShopMall_ExchangePublicityCountDown , min , sec )
	end
end

function ExchangeSellIntroduceCell:OnDestroy() 
	TimeTickManager.Me():ClearTick(self)
end

function ExchangeSellIntroduceCell:IsShowEnchant(itemData)
	return itemData and itemData.enchantInfo and #itemData.enchantInfo:GetEnchantAttrs() > 0 or false
end

function ExchangeSellIntroduceCell:SetEnchantLabel(itemData,uiLabel)
	if itemData.enchantInfo:IsShowWhenTrade() then
		uiLabel.text = ZhString.ShopMall_ExchangeEnchant
	else
		uiLabel.text = ZhString.ShopMall_ExchangeHideEnchant
	end
end