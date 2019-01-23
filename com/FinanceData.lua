autoImport("FinanceItemData")

FinanceData = class("FinanceData")

local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack

function FinanceData:ctor()
	self.itemList = {}
end

function FinanceData:SetData(serviceData)
	self.rankType = serviceData.rank_type
	self.dateType = serviceData.date_type

	_ArrayClear(self.itemList)
	for i=1,#serviceData.lists do
		local data = FinanceItemData.new(serviceData.lists[i])
		data:SetInfo(self.rankType, self.dateType)
		_ArrayPushBack(self.itemList, data)
	end
end

--列表请求时间
function FinanceData:SetNextValidTime(time)
	self.callTime = Time.unscaledTime + time
end

function FinanceData:CheckCanCall()
	if self.callTime == nil or self.callTime <= Time.unscaledTime then
		return true
	end

	return false
end

function FinanceData:GetItemList()
	return self.itemList
end

function FinanceData:GetItemById(itemid)
	for i=1,#self.itemList do
		local item = self.itemList[i]
		if item.itemid == itemid then
			return item
		end
	end
end