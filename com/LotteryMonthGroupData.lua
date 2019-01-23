autoImport("LotteryData")

LotteryMonthGroupData = class("LotteryMonthGroupData")

function LotteryMonthGroupData:ctor(data)
	self.month = {}

	self:SetData(data)
end

function LotteryMonthGroupData:SetData(data)
	if data then
		self.id = data

		local flag = data % 10
		local year = (data - flag) / 10
		if flag == 1 then
			self.name = string.format(ZhString.Lottery_MonthGroupFirst, year)
		else
			self.name = string.format(ZhString.Lottery_MonthGroupSecond, year)
		end
	end
end

function LotteryMonthGroupData:AddMonth(servicedata)
	local data = LotteryData.new(servicedata)
	data:SortItemsByRate()
	data:SetBgName()
	TableUtility.ArrayPushBack(self.month, data)
end

function LotteryMonthGroupData:GetName()
	return self.name
end

function LotteryMonthGroupData:GetMonth()
	return self.month
end

function LotteryMonthGroupData:GetLotteryItemData(itemid)
	for i=1,#self.month do
		local lotteryItemData = self.month[i]:GetLotteryItemData(itemid)
		if lotteryItemData ~= nil then
			return lotteryItemData
		end
	end

	return nil
end