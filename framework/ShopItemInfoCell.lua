autoImport("ItemTipBaseCell")
ShopItemInfoCell = class("ShopItemInfoCell", ItemTipBaseCell)

function ShopItemInfoCell:Exit()
	ShopItemInfoCell.super.Exit(self)
	TimeTickManager.Me():ClearTick(self)
end

function ShopItemInfoCell:Init()
	ShopItemInfoCell.super.Init(self)

	self:FindObjs()
	self:AddEvts()
end

function ShopItemInfoCell:FindObjs()
	self.price = self:FindGO("Price"):GetComponent(UILabel)
	self.confirmButton = self:FindGO("ConfirmButton")
	self.confirmLabel = self:FindGO("Label",self.confirmButton):GetComponent(UILabel)
	self.cancelButton = self:FindGO("CancelButton")
	self.cancelLabel = self:FindGO("Label",self.cancelButton):GetComponent(UILabel)
	self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
	self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
	self.countPlus = self:FindGO("Plus",self.countPlusBg.gameObject):GetComponent(UISprite)
	self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
	self.countSubtract = self:FindGO("Subtract",self.countSubtractBg.gameObject):GetComponent(UISprite)
	self.priceIcon = self:FindGO("PriceIcon"):GetComponent(UISprite)
	self.totalPrice = self:FindGO("TotalPrice"):GetComponent(UILabel)
	self.totalPriceIcon = self:FindGO("TotalPriceIcon"):GetComponent(UISprite)
	self.salePrice = self:FindGO("SalePrice")
	self.salePriceTip = self:FindGO("Tip", self.salePrice):GetComponent(UILabel)

	UIUtil.LimitInputCharacter(self.countInput, 8)
end

function ShopItemInfoCell:AddEvts()
	self:AddClickEvent(self.confirmButton.gameObject,function (g)
		self:Confirm()
	end)
	self:AddClickEvent(self.cancelButton.gameObject,function (g)
		self:Cancel()
	end)
	self:AddPressEvent(self.countPlusBg.gameObject,function (g,b)
		self:PlusPressCount(b)
	end)
	self:AddPressEvent(self.countSubtractBg.gameObject,function (g,b)
		self:SubtractPressCount(b)
	end)
	EventDelegate.Set(self.countInput.onChange,function ()
		self:InputOnChange()
	end)
	EventDelegate.Set(self.countInput.onSubmit,function ()
		self:InputOnSubmit()
	end)
end

function ShopItemInfoCell:SetData(data)
	self.itemData = data
	self.gameObject:SetActive(data ~= nil)
	
	if data then
		self:UpdateAttriContext()
		self:UpdateTopInfo()

		if self.maxcount == nil then
			self.maxcount = 999
		end

		if self.moneycount == nil then
			self.moneycount = 0
			errorLog(string.format("Table_Item[%s].SellPrice == nil",tostring(self.data.staticData.id)))
		end

		self.countInput.value = 1
		self:UpdatePrice()
		self:InputOnChange()
	end
end

function ShopItemInfoCell:Confirm()
	self.gameObject:SetActive(false)
end

function ShopItemInfoCell:Cancel()
	self.gameObject:SetActive(false)
end

function ShopItemInfoCell:PlusPressCount(isPressed)
	if isPressed then
		self.countChangeRate = 1
		if self.plusTick == nil then
			self.plusTick = TimeTickManager.Me():CreateTick(0, 150, function (self, deltatime)
				self:UpdateCount(1) end, 
					self, 1)
		else
			self.plusTick:Restart()
		end
	else
		if self.plusTick then
			self.plusTick:StopTick()
		end
	end	
end

function ShopItemInfoCell:SubtractPressCount(isPressed)
	if isPressed then
		self.countChangeRate = 1
		if self.subtractTick == nil then
			self.subtractTick = TimeTickManager.Me():CreateTick(0, 150, function (self, deltatime)
				self:UpdateCount(-1) end, 
					self, 2)
		else
			self.subtractTick:Restart()
		end
	else
		if self.subtractTick then
			self.subtractTick:StopTick()
		end
	end
end

function ShopItemInfoCell:UpdateCount(change)

	if tonumber(self.countInput.value) == nil then
		self.countInput.value = self.count
	end

	local count = tonumber(self.countInput.value) + self.countChangeRate * change

	if count < 1 then
		self.countChangeRate = 1
		return
	elseif count > self.maxcount then
		self.countChangeRate = 1
		return
	end

	self:UpdateTotalPrice(count)

	if self.countChangeRate <= 3 then
		self.countChangeRate = self.countChangeRate + 1
	end
end

function ShopItemInfoCell:InputOnChange()
	local count = tonumber(self.countInput.value)

	if count == nil then
		return
	end

	if self.maxcount == 0 then
		count = 0
		self:SetCountPlus(0.5)
		self:SetCountSubtract(0.5)
	else
		if count <= 1 then
			count = 1
			self:SetCountPlus(1)
			self:SetCountSubtract(0.5)
		elseif count >= self.maxcount then
			count = self.maxcount
			self:SetCountPlus(0.5)
			self:SetCountSubtract(1)
		else
			self:SetCountPlus(1)
			self:SetCountSubtract(1)
		end
	end

	self:UpdateTotalPrice(count)
end

function ShopItemInfoCell:UpdatePrice()
	self.price.text = StringUtil.NumThousandFormat(self.moneycount)
end

function ShopItemInfoCell:UpdateTotalPrice(count)
	self.count = count
	self:CalcTotalPrice(count)
	self.totalPrice.text = StringUtil.NumThousandFormat(self.discountTotal)
	self:UpdateSale(self.discount, self.discountCount)
	if(self.countInput.value ~= tostring(count))then
		self.countInput.value = count
	end
end

function ShopItemInfoCell:InputOnSubmit()
	local count = tonumber(self.countInput.value)

	if count == nil then
		self.countInput.value = self.count
	end
end

function ShopItemInfoCell:SetCountPlus(alpha)
	if self.countPlusBg.color.a ~= alpha then
		self:SetSpritAlpha(self.countPlusBg,alpha)
		self:SetSpritAlpha(self.countPlus,alpha)
	end
end

function ShopItemInfoCell:SetCountSubtract(alpha)
	if self.countSubtractBg.color.a ~= alpha then
		self:SetSpritAlpha(self.countSubtractBg,alpha)
		self:SetSpritAlpha(self.countSubtract,alpha)
	end
end

function ShopItemInfoCell:SetSpritAlpha(sprit,alpha)
	sprit.color = Color(sprit.color.r,sprit.color.g,sprit.color.b,alpha)
end

--参数：数量
--返回：折扣前的总价格
function ShopItemInfoCell:CalcTotalPrice(count)
	local totalCost = self.moneycount * count
	return totalCost
end