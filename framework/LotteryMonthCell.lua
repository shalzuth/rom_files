local baseCell = autoImport("BaseCell")
LotteryMonthCell = class("LotteryMonthCell", baseCell)

function LotteryMonthCell:Init()
	self:FindObjs()
end

function LotteryMonthCell:FindObjs()
	self.bg = self:FindGO("Bg"):GetComponent(UITexture)
	self.year = self:FindGO("Year"):GetComponent(UILabel)
	self.month = self:FindGO("Month"):GetComponent(UILabel)
	self.discountRoot = self:FindGO("DiscountRoot")
	self.discount = self:FindGO("Discount"):GetComponent(UILabel)
	self.discountTime = self:FindGO("DiscountTime"):GetComponent(UILabel)
end

function LotteryMonthCell:SetData(data)
	self.data = data
	if data then
		self.year.text = data.year
		self.month.text = string.format("%02d", data.month)

		self:RefreshDiscount()
	end
end

function LotteryMonthCell:RefreshDiscount()
	if self.data ~= nil then
		local discount = self.data.discount
		local aeDiscount = ActivityEventProxy.Instance:GetLotteryDiscountByCoinType(LotteryType.Head, AELotteryDiscountData.CoinType.Coin, self.data.year, self.data.month)
		if aeDiscount ~= nil then
			discount = 100 - aeDiscount:GetDiscount()

			if discount ~= 0 then
				local beginTime = os.date("*t", aeDiscount.beginTime)
				local endTime = os.date("*t", aeDiscount.endTime)
				self.discountTime.text = string.format(ZhString.Lottery_DiscountTime, beginTime.month, beginTime.day, endTime.month, endTime.day)
			end
		else
			self.discountTime.text = ""
		end

		if discount == 0 then
			self.discountRoot:SetActive(false)
		else
			self.discountRoot:SetActive(true)
			self.discount.text = string.format(ZhString.Lottery_Discount, discount)
		end
	end
end

function LotteryMonthCell:UpdatePicture(bytes)
	local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
	local ret = ImageConversion.LoadImage(texture, bytes)
	if ret then
		self:DestroyPicture()

		self.bg.mainTexture = texture
	end
end

function LotteryMonthCell:DestroyPicture()
	local texture = self.bg.mainTexture
	if texture ~= nil then
		self.bg.mainTexture = nil
		GameObject.DestroyImmediate(texture)
	end
end