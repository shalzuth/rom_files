LotteryExpressBuyView = class("LotteryExpressBuyView",SubView)

function LotteryExpressBuyView:Init()
	self:FindObj()
	self:AddBtnEvt()
	self:AddViewEvt()
	self:InitShow()
end

function LotteryExpressBuyView:FindObj()
	self.gameObject = self:FindGO("BuyRoot")
	self.NextBtn = self:FindGO("NextBtn")
	self.sellPrice = self:FindGO("SellPrice"):GetComponent(UILabel)
	self.sellCountInput = self:FindGO("CountRoot")
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
	self.sellCountPlusBg = self:FindGO("CountPlusBg")
	if self.sellCountPlusBg then
		self.sellCountPlusBg = self.sellCountPlusBg:GetComponent(UISprite)
		self.sellCountPlus = self:FindGO("SellPlus",self.sellCountPlusBg.gameObject):GetComponent(UISprite)
	end
	self.sellCountSubtractBg = self:FindGO("CountSubtractBg")
	if self.sellCountSubtractBg then
		self.sellCountSubtractBg = self.sellCountSubtractBg:GetComponent(UISprite)
		self.sellCountSubtract = self:FindGO("SellSubtract",self.sellCountSubtractBg.gameObject):GetComponent(UISprite)
	end
	self.totalPrice = self:FindGO("TotalPrice")
	if self.totalPrice then
		self.totalPrice = self.totalPrice:GetComponent(UILabel)
	end
	self.TotalPriceIcon=self:FindGO("TotalPriceIcon"):GetComponent(UISprite)
	self.PriceIcon=self:FindGO("PriceIcon"):GetComponent(UISprite)
	self.titleLab = self:FindGO("TitleLab"):GetComponent(UILabel)
	self.descLab = self:FindGO("DescLab"):GetComponent(UILabel)
	self.buyCountLab = self:FindGO("BuyCount"):GetComponent(UILabel)
end

function LotteryExpressBuyView:AddBtnEvt()
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
	self:AddClickEvent(self.NextBtn, function ()
		self:showNext()
	end)
end

function LotteryExpressBuyView:showNext()
	local c,t = LotteryProxy.Instance:GetLotteryBuyCnt()
	local selectCount = self.container:GetPresentCount()
	if(0~=t and c+selectCount>t)then
		MsgManager.ShowMsgByID(25312)
		return
	end
	local quota = MyselfProxy.Instance:GetQuota()
	if(self.sellPriceNum*selectCount*10000>quota)then
		MsgManager.ShowMsgByID(25003)
		return
	end
	local money = MyselfProxy.Instance:GetLottery()
	if(self.totalPriceNum>money)then
		MsgManager.ConfirmMsgByID(3551, function ()
			FuncZenyShop.Instance():OpenUI(PanelConfig.ZenyShopGachaCoin)
			self.container:CloseSelf()
		end)
		return
	end
	self.container:ShowBuyView(false)
end

function LotteryExpressBuyView:AddViewEvt()
	
end

function LotteryExpressBuyView:PressCount(go,isPressed,change)
	if isPressed then
		self.countChangeRate = 1
		TimeTickManager.Me():CreateTick(0, 150, function (self, deltatime)
			self:UpdateSellCount(change) end, 
				self, 3);
	else
		TimeTickManager.Me():ClearTick(self,3)	
	end	
end

function LotteryExpressBuyView:UpdateSellCount(change)
	count = tonumber(self.sellCountInput.value) + self.countChangeRate * change

	if count < 1 then
		self.countChangeRate = 1
		return
	end

	if count <= 1 then
		self:SetSellCountPlus(1)
		self:SetSellCountSubtract(0.5)
	else
		self:SetSellCountPlus(1)
		self:SetSellCountSubtract(1)
	end

	self.count = count
	self.container:SetPresentCount(count)
	self.sellCountInput.value = count
	local price = self.sellPriceNum and self.sellPriceNum or 0
	self.totalPriceNum = price * count
	self.totalPrice.text = StringUtil.NumThousandFormat( self.totalPriceNum )

	if self.countChangeRate <= 3 then
		self.countChangeRate = self.countChangeRate + 1
	end
	self:RefreshColor()
end

function LotteryExpressBuyView:InputOnChange()
	local count = tonumber(self.sellCountInput.value)
	if count == nil then return end
	if count <= 1 then
		count = 1
		self:SetSellCountPlus(1)
		self:SetSellCountSubtract(0.5)
	else
		self:SetSellCountPlus(1)
		self:SetSellCountSubtract(1)
	end

	self.count = count
	self.container:SetPresentCount(count)
	self.sellCountInput.value = count
	self.totalPriceNum = self.sellPriceNum * count
	self.totalPrice.text = StringUtil.NumThousandFormat( self.totalPriceNum )
	self:RefreshColor()
end

function LotteryExpressBuyView:RefreshColor()
	local money = MyselfProxy.Instance:GetLottery()
	if(self.totalPriceNum>money)then
		ColorUtil.RedLabel(self.totalPrice)
	else
		ColorUtil.DeepGrayUIWidget(self.totalPrice)
	end
	if(self.sellPriceNum>money)then
		ColorUtil.RedLabel(self.sellPrice)
	else
		ColorUtil.DeepGrayUIWidget(self.sellPrice)
	end
end

function LotteryExpressBuyView:SetSellCountPlus(alpha)
	if self.sellCountPlusBg and self.sellCountPlus then
		if self.sellCountPlusBg.color.a ~= alpha then
			self:SetSpritAlpha(self.sellCountPlusBg,alpha)
			self:SetSpritAlpha(self.sellCountPlus,alpha)
		end
	end
end

function LotteryExpressBuyView:SetSellCountSubtract(alpha)
	if self.sellCountSubtractBg and self.sellCountSubtract then
		if self.sellCountSubtractBg.color.a ~= alpha then
			self:SetSpritAlpha(self.sellCountSubtractBg,alpha)
			self:SetSpritAlpha(self.sellCountSubtract,alpha)
		end
	end
end

function LotteryExpressBuyView:SetSpritAlpha(sprite,alpha)
	sprite.color = Color(sprite.color.r,sprite.color.g,sprite.color.b,alpha)
end

function LotteryExpressBuyView:InitShow()
	local lotteryMoney = GameConfig.MoneyId.Lottery
	local moneyCsv = Table_Item[lotteryMoney]
	if(moneyCsv)then
		IconManager:SetItemIcon(moneyCsv.Icon,self.TotalPriceIcon)
		IconManager:SetItemIcon(moneyCsv.Icon,self.PriceIcon)
	end
	self.sellPriceNum=self.container:IsCurMonth() and GameConfig.Lottery.DiscountPrice or GameConfig.Lottery.SendPrice
	self.totalPriceNum=self.sellPriceNum
	self.sellPrice.text = StringUtil.NumThousandFormat(self.sellPriceNum)
	self.totalPrice.text = StringUtil.NumThousandFormat(self.sellPriceNum)
	self.sellCountInput.value=1
	local mData = self.container.monthData
	local year,month = mData.year,mData.month
	self.titleLab.text = string.format(ZhString.Lottery_TitleDesc,year,month)
	self.descLab.text = ZhString.Lottery_SendTip
	local c,t = LotteryProxy.Instance:GetLotteryBuyCnt()
	self.buyCountLab.gameObject:SetActive(0~=t)
	if(0~=t)then
		self.buyCountLab.text=string.format(ZhString.Lottery_BuyCount,c,t)
	end
end


