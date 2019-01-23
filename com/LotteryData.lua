autoImport("LotteryItemData")

LotteryData = class("LotteryData")

function LotteryData:ctor(data)
	self.items = {}
	self.itemMap = {}

	self:SetData(data)
end

function LotteryData:SetData(data)
	if data then
		self.year = data.year
		self.month = data.month
		self.price = data.price
		self.discount = data.discount
		self.boxItemid = data.lotterybox

		for i=1,#data.subInfo do
			local item = LotteryItemData.new(data.subInfo[i])
			if item.rate > 0 then
				TableUtility.ArrayPushBack(self.items, item)
			end
			self.itemMap[item.itemid] = item

			if(item.female_itemid)then
				self.itemMap[item.female_itemid] = item
			end
		end
	end
end

function LotteryData:SetBgName()
	local temp = self.year * 100 + self.month
	self.bgName = "lottery_"..temp
end

function LotteryData:SetTodayCount(todayCount, maxCount)
	self.todayCount = todayCount

	if maxCount ~= nil then
		self.maxCount = maxCount
	end
end

function LotteryData:SortItemsByRate()
	table.sort(self.items, LotteryData._SortItemByRate)
end

function LotteryData:SortItemsByQuality()
	table.sort(self.items, LotteryData.SortItemByQuality)
end

function LotteryData._SortItemByRate(l, r)
	if l.rate and r.rate then
		return l.rate < r.rate
	end

	return false
end

function LotteryData.SortItemByQuality(l, r)
	local staticDatal = Table_Item[l.itemid]
	local staticDatar = Table_Item[r.itemid]
	if staticDatal and staticDatar then
		if staticDatal.Quality == staticDatar.Quality then
			return staticDatal.id < staticDatar.id
		else
			return staticDatal.Quality > staticDatar.Quality
		end
	end
end

function LotteryData:GetLotteryItemData(itemid)
	return self.itemMap[itemid]
end