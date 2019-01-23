ShopMallExchangeBuyCell = class("ShopMallExchangeBuyCell", ItemTipBaseCell)

local temp = {}

function ShopMallExchangeBuyCell:Init()

	-- local cellContainer = self:FindGO("CellContainer")
	-- if cellContainer then
	-- 	local obj = self:LoadPreferb("cell/ItemCell", cellContainer)
	-- 	obj.transform.localPosition = Vector3.zero
	-- end

	ShopMallExchangeBuyCell.super.Init(self)

	self:FindObjs()
	self:AddEvts()
end

function ShopMallExchangeBuyCell:FindObjs()
	self.closeBtn = self:FindGO("CancelButton")
	-- self.name = self:FindGO("ItemName"):GetComponent(UILabel)
	self.price = self:FindGO("Price"):GetComponent(UILabel)
	self.buyButton = self:FindGO("ConfirmButton"):GetComponent(UISprite)
	self.buyLabel = self:FindGO("Label", self.buyButton.gameObject):GetComponent(UILabel)

	-- for BuyOverLapCell
	self.sellCount = self:FindGO("SellCount")
	if self.sellCount then
		self.sellCount = self.sellCount:GetComponent(UILabel)

        --todo xde
        local SellCountTitle = self:FindGO("SellCountTitle"):GetComponent(UILabel)
        SellCountTitle.pivot = UIWidget.Pivot.Left
        SellCountTitle.transform.localPosition = Vector3(-270,242,0)
        self.sellCount.pivot = UIWidget.Pivot.Left
        OverseaHostHelper:FixAnchor(self.sellCount.leftAnchor,SellCountTitle.transform,1,10)
        
	end
	self.buyCountInput = self:FindGO("CountInput")
	if self.buyCountInput then
		self.buyCountInput = self.buyCountInput:GetComponent(UIInput)
		UIUtil.LimitInputCharacter(self.buyCountInput, 6)
	end
	self.buyPlusBg = self:FindGO("CountPlusBg")
	if self.buyPlusBg then
		self.buyPlusBg = self.buyPlusBg:GetComponent(UISprite)
	end
	self.buySubtractBg = self:FindGO("CountSubtractBg")
	if self.buySubtractBg then
		self.buySubtractBg = self.buySubtractBg:GetComponent(UISprite)
	end
	self.money = self:FindGO("Money")
	if self.money then
		self.money = self.money:GetComponent(UILabel)
	end
	self.ownCount = self:FindGO("OwnCount")
	if self.ownCount then
		self.ownCount = self.ownCount:GetComponent(UILabel)

        local OwnInfo = self:FindGO("OwnInfo"):GetComponent(UILabel)
        OwnInfo.pivot = UIWidget.Pivot.Left
        OwnInfo.transform.localPosition = Vector3(-270,214,0)
        self.ownCount.pivot = UIWidget.Pivot.Left
        OverseaHostHelper:FixAnchor(self.ownCount.leftAnchor,OwnInfo.transform,1,10)
    end
end

function ShopMallExchangeBuyCell:AddEvts()
	self:SetEvent(self.closeBtn,function (g)
		self:PassEvent(ShopMallEvent.ExchangeCloseBuyInfo, self)
	end)
	self:AddClickEvent(self.buyButton.gameObject,function (g)
		--todo xde
		if OverseaHostHelper:GuestExchangeForbid() ~= 1 then
			self:BuyItem()
		end
	end)
	if self.buyPlusBg then
		self:AddPressEvent(self.buyPlusBg.gameObject,function (g,b)
			self:PressCount(g,b,1)
		end)
	end
	if self.buySubtractBg then
		self:AddPressEvent(self.buySubtractBg.gameObject,function (g,b)
			self:PressCount(g,b,-1)
		end)
	end	
	if self.buyCountInput then
		EventDelegate.Set(self.buyCountInput.onChange,function ()
			self:InputOnChange()
		end)
	end
end

function ShopMallExchangeBuyCell:SetData(data)
	if data then
		if data.itemid then
			self.itemData = Table_Item[data.itemid]
			if self.itemData ~= nil then

				-- self.name.text = self.itemData.NameZh

				local itemData = data:GetItemData()
				if itemData then
					-- ShopMallExchangeBuyCell.super.SetData(self,itemData)
					self.data = itemData
					self:UpdateAttriContext()
					self:UpdateTopInfo()
				end

				if data.price then
					self:UpdateMoney(data:GetPrice())
					self:SetCanExpress(data:GetPrice())

					self.price.text = StringUtil.NumThousandFormat(data:GetPrice())
				else
					errorLog("ShopMallExchangeBuyCell SetData : data.price is nil")
				end

				if data.overlap and data.count and self.sellCount then
					self.sellCount.text = data.count
				end
				if self.buyCountInput then
					self.buyCountInput.value = 1
					self:UpdateBuyPlusSubtract(1,data.count)
				end
			else
				errorLog(string.format("ShopMallExchangeBuyCell SetData : Table_Item[%s] is nil",tostring(data.itemid)))
			end

			if self.ownCount then
				local own = BagProxy.Instance:GetItemNumByStaticID(data.itemid)
				if own then
					self.ownCount.text = own
				else
					self.ownCount.text = 0
				end
			end
		else
			errorLog("ShopMallExchangeBuyCell SetData : data.itemid is nil")
		end
	end

	self.infoData = data
end

function ShopMallExchangeBuyCell:PressCount(go,isPressed,change)
	if isPressed then
		self.countChangeRate = 1
		TimeTickManager.Me():CreateTick(0, 150, function (self, deltatime)
			self:UpdateBuyCount(change) end, 
				self, 3);
	else
		TimeTickManager.Me():ClearTick(self,3)	
	end	
end

function ShopMallExchangeBuyCell:UpdateBuyCount(change)
	local count = tonumber(self.buyCountInput.value) + self.countChangeRate * change

	if count < 1 then
		self.countChangeRate = 1
		return
	elseif count > self.infoData.count then
		self.countChangeRate = 1
		return
	end

	self:UpdateBuyPlusSubtract(count,self.infoData.count)

	self.buyCountInput.value = count
	local totalPrice = self.infoData:GetPrice() * count
	self:UpdateMoney(totalPrice)

	if self.countChangeRate <= 3 then
		self.countChangeRate = self.countChangeRate + 1
	end

	if self.countChangeCallback then
		self:SetCanExpress(totalPrice)
		self.countChangeCallback( self:CanExpress())
	end
end

function ShopMallExchangeBuyCell:InputOnChange()
	local count = tonumber(self.buyCountInput.value)

	if count == nil then
		-- self.buyCountInput.value = 1
		return
	end

	if self.infoData then
		if count < 1 then
			self.buyCountInput.value = 1
		elseif count > self.infoData.count then
			self.buyCountInput.value = self.infoData.count
		end

		count = tonumber(self.buyCountInput.value)
		self:UpdateBuyPlusSubtract(count,self.infoData.count)

		local totalPrice
		if self.infoData.price then
			totalPrice = self.infoData:GetPrice() * count
			self:UpdateMoney(totalPrice)
		end

		if self.countChangeCallback then
			self:SetCanExpress(totalPrice)
			self.countChangeCallback( self:CanExpress())
		end
	end
end

function ShopMallExchangeBuyCell:SetSpritAlpha(sprit,alpha)
	sprit.color = Color(sprit.color.r,sprit.color.g,sprit.color.b,alpha)
end

function ShopMallExchangeBuyCell:SetBuyPlus(alpha)
	if self.buyPlusBg then
		if self.buyPlusBg.color.a ~= alpha then
			self:SetSpritAlpha(self.buyPlusBg,alpha)
		end
	end
end

function ShopMallExchangeBuyCell:SetBuySubtract(alpha)
	if self.buySubtractBg then
		if self.buySubtractBg.color.a ~= alpha then
			self:SetSpritAlpha(self.buySubtractBg,alpha)
		end
	end
end

function ShopMallExchangeBuyCell:UpdateBuyPlusSubtract(count,infoCount)
	if infoCount > 1 then
		if count <= 1 then
			self:SetBuyPlus(1)
			self:SetBuySubtract(0.5)
		elseif count >= infoCount then
			self:SetBuyPlus(0.5)
			self:SetBuySubtract(1)
		else
			self:SetBuyPlus(1)
			self:SetBuySubtract(1)
		end
	else
		self:SetBuyPlus(0.5)
		self:SetBuySubtract(0.5)
	end
end

function ShopMallExchangeBuyCell:UpdateMoney(price)
	if self.money then
		self.money.text = StringUtil.NumThousandFormat(price)
	end
end

local itemInfo = {}
function ShopMallExchangeBuyCell:BuyItem()
	if self.isBuy then
		return
	end

	TableUtility.TableClear(itemInfo)
	itemInfo.itemid = self.infoData.itemid
	itemInfo.price = self.infoData.price
	if self.buyCountInput then
		itemInfo.count = tonumber(self.buyCountInput.value)
	else
		itemInfo.count = 1
	end
	itemInfo.publicity_id = self.infoData.publicityId

	if not overlap then
		print("self.infoData.orderId : "..self.infoData.orderId)
		itemInfo.order_id = self.infoData.orderId
	end
	itemInfo.charid = self.infoData.charid
	itemInfo.type = self.infoData.type

	if self.infoData.itemData and self.infoData.itemData.equipInfo and self.infoData.itemData.equipInfo.damage then
		MsgManager.ConfirmMsgByID(10155,function ()
			self:CallBuyItemRecordTradeCmd(itemInfo)
		end , nil , nil)
	else
		self:CallBuyItemRecordTradeCmd(itemInfo)
	end
end

function ShopMallExchangeBuyCell:CallBuyItemRecordTradeCmd(itemInfo)
	ShopMallProxy.Instance:CallBuyItemRecordTradeCmd(itemInfo, function ()
		self:SetBuyBtn(true)
	end)
end

function ShopMallExchangeBuyCell:SetBuyBtn(isBuy)
	if isBuy then
		self.buyButton.color = ColorUtil.NGUIShaderGray
		self.buyLabel.effectColor = ColorUtil.NGUIGray
	else
		self.buyButton.color = ColorUtil.NGUIWhite
		self.buyLabel.effectColor = ColorUtil.ButtonLabelOrange
	end

	self.isBuy = isBuy
end

function ShopMallExchangeBuyCell:SetCountChangeCallback(callback)
	self.countChangeCallback = callback

	callback( self:CanExpress() )
end

function ShopMallExchangeBuyCell:SetCanExpress(needCredit)
	self.canExpress = needCredit >= GameConfig.Exchange.SendMoneyLimit
	self.isQuotaEnough = MyselfProxy.Instance:GetQuota() >= needCredit
end

function ShopMallExchangeBuyCell:CanExpress()
	return self.canExpress, self.isQuotaEnough
end