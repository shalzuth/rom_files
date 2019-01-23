autoImport("AELotteryDiscountData")
autoImport("AELotteryBannerData")

AELotteryData = class("AELotteryData")

function AELotteryData:ctor(data)
	self.discountMap = {}
	self.bannerMap = {}
end

function AELotteryData:SetDiscount(data)
	if data ~= nil then
		local lotterydiscount = data.lotterydiscount
		local lotterytype = lotterydiscount.lotterytype

		local info = self:CheckIsExistDiscount(lotterydiscount)
		if info == nil then
			local discount = AELotteryDiscountData.new(data)
			TableUtility.ArrayPushBack(self.discountMap[lotterytype], discount)
		else
			info:SetData(data)
		end
	end
end

function AELotteryData:SetBanner(data)
	if data ~= nil then
		local lotterytype = data.lotterybanner.lotterytype

		if self.bannerMap[lotterytype] == nil then
			self.bannerMap[lotterytype] = AELotteryBannerData.new()
		end
		self.bannerMap[lotterytype]:SetData(data)
	end
end

function AELotteryData:CheckIsExistDiscount(data)
	local lotterytype = data.lotterytype

	if self.discountMap[lotterytype] == nil then
		self.discountMap[lotterytype] = {}
		return
	end

	for i=1,#self.discountMap[lotterytype] do
		local info = self.discountMap[lotterytype][i]
		if data.yearmonth ~= 0 then
			if info.yearmonth == data.yearmonth and info.cointype == data.cointype then
				return info
			end
		elseif info.cointype == data.cointype then
			return info
		end
	end
end

function AELotteryData:GetDiscount(lotterytype)
	return self.discountMap[lotterytype]
end

function AELotteryData:GetDiscountByCoinType(lotterytype, cointype, year, month)
	local list = self:GetDiscount(lotterytype)
	if list ~= nil then
		for i=1,#list do
			local data = list[i]
			if month ~= nil and year ~= nil then
				if data.month == month and data.year == year and data.cointype == cointype then
					return data
				end
			elseif data.cointype == cointype then
				return data
			end
		end
	end
end

function AELotteryData:GetBannerPath(lotterytype)
	local data = self.bannerMap[lotterytype]
	if data ~= nil and data:IsInActivity() then
		return data:GetPath()
	end
end

function AELotteryData:GetDiscountDataById(id)
	for k,v in pairs(self.discountMap) do
		for i=1,#v do
			local data = v[i]
			if data.id == id then
				return data
			end
		end
	end
end