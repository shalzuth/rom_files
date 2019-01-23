local baseCell = autoImport("BaseCell")
BoothIntroduceCell = class("BoothIntroduceCell", baseCell)

function BoothIntroduceCell:Init()
	self:FindObjs()
end

function BoothIntroduceCell:FindObjs()
	self.rate = self:FindGO("Rate")
	if self.rate then
		self.rate = self.rate:GetComponent(UILabel)
	end
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
	self.table = self:FindGO("Table")
	if self.table then
		self.table = self.table:GetComponent(UITable)
	end
	self.rate = self:FindGO("Rate")
	if self.rate then
		self.rate = self.rate:GetComponent(UILabel)
	end
	self.sendRoot = self:FindGO("SendRoot")
	self.boothFrom = self:FindGO("BoothFrom")
	if self.boothFrom then
		self.boothFrom = self.boothFrom:GetComponent(UILabel)
	end
	self.tipQuota = self:FindGO("TipQuota")
	self.tipQuota1 = self:FindGO("TipQuota1")
	self.quota = self:FindGO("Quota")
	if self.quota then
		self.quota = self.quota:GetComponent(UILabel)
	end
end

function BoothIntroduceCell:SetData(data)
	self.data = data

	if data then
		if self.rate then
			self.rate.text = string.format(ZhString.ShopMall_ExchangeRateTitle, CommonFun.calcTradeTax(data:GetPrice()))
		end

		local itemid = data:GetItemId()
		local statetype = data.type
		if statetype == ShopMallStateTypeEnum.WillPublicity then
			local item = Table_Item[itemid]
			if item ~= nil then
				if self.info then
					local sb = LuaStringBuilder.CreateAsTable()
					sb:AppendLine(string.format(ZhString.Booth_IntroduceWillPublicity, item.NameZh))
					sb:Append(ZhString.Booth_IntroducePublicityTip)
					self.info.text = sb:ToString()
					sb:Destroy()
				end

				local exchange = Table_Exchange[itemid]
				local showTime = 0
				if exchange ~= nil then
					showTime = exchange.ShowTime
				end
				if self.info2 then
					self.info2.text = string.format(ZhString.Booth_IntroducePublicityTime, item.NameZh, math.ceil(showTime/60))
				end
			end
		elseif statetype == ShopMallStateTypeEnum.InPublicity then
			if self.timeTick == nil then
				self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountDown, self)
			end
			if self.count then
				self.count.text = string.format(ZhString.Booth_IntroduceCount, data.count)
			end
			self:UpdateBuyerCount()
			if self.info then
				local item = Table_Item[itemid]
				if item ~= nil then
					local sb = LuaStringBuilder.CreateAsTable()
					sb:AppendLine(string.format(ZhString.Booth_IntroducePublicity, item.NameZh))
					sb:Append(ZhString.Booth_IntroducePublicityTip)
					self.info.text = sb:ToString()
					sb:Destroy()
				end
			end
		else
			if self.count then
				self.count.text = string.format(ZhString.Booth_IntroduceCount, data.count)
			end
		end

		if self.sendRoot then
			self.sendRoot:SetActive(false)
		end

		if self.boothFrom then
			self.boothFrom.text = string.format(ZhString.Booth_IntroduceFrom, data.boothName)
		end

		local exchangeType = data.exchangeType
		if exchangeType == ShopMallExchangeSellEnum.Sell then
			self:ShowQuotaTip(true)
		elseif exchangeType == ShopMallExchangeSellEnum.Cancel then
			self:ShowQuotaTip(false)
			self:UpdateQuota()
		elseif exchangeType == ShopMallExchangeSellEnum.Resell then
			self:ShowQuotaTip(false)
			self:UpdateQuota()
		end

		if self.table then
			self.table:Reposition()
		end
	end
end

function BoothIntroduceCell:UpdateCountDown()
	if self.data.endTime then
		local time = self.data.endTime - ServerTime.CurServerTime()/1000
		local min,sec
		if time > 0 then
			min,sec = ClientTimeUtil.GetFormatSecTimeStr(time)
		else
			min = 0
			sec = 0
		end
		self.countDown.text = string.format(ZhString.ShopMall_ExchangePublicityCountDown, min, sec)
	end
end

function BoothIntroduceCell:UpdateQuota()
	if self.quota then
		local quota = self.data:GetQuota()
		if quota ~= nil then
			self.quota.text = StringUtil.NumThousandFormat(quota)
		end
	end
end

function BoothIntroduceCell:UpdateBuyerCount()
	if self.buyerCount then
		self.buyerCount.text = string.format(ZhString.Booth_IntroduceBuyerCount, self.data.buyerCount)
	end
end

function BoothIntroduceCell:ShowQuotaTip(isShow)
	if self.tipQuota then
		self.tipQuota:SetActive(isShow)
	end
	if self.tipQuota1 then
		self.tipQuota1:SetActive(not isShow)
	end
end

function BoothIntroduceCell:OnDestroy()
	if self.timeTick ~= nil then
		TimeTickManager.Me():ClearTick(self)
		self.timeTick = nil
	end
end