autoImport("FinanceItemDetailData")

FinanceItemData = class("FinanceItemData")

local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack

function FinanceItemData:ctor(data)
	self.detailList = {}

	self:SetData(data)
end

function FinanceItemData:SetData(data)
	self.itemid = data.item_id
	self.ratio = data.ratio
end

function FinanceItemData:SetInfo(rankType, dateType)
	self.rankType = rankType
	self.dateType = dateType
end

function FinanceItemData:SetDetail(list)
	self.maxDetailRatio = nil
	self.minDetailRatio = nil
	_ArrayClear(self.detailList)

	for i=1,#list do
		local data = FinanceItemDetailData.new(list[i])
		data:SetRankType(self.rankType)
		_ArrayPushBack(self.detailList, data)

		local ratio = data.ratio
		if self.maxDetailRatio == nil or ratio > self.maxDetailRatio then
			self.maxDetailRatio = ratio
		end
		if self.minDetailRatio == nil or ratio < self.minDetailRatio then
			self.minDetailRatio = ratio
		end
	end
end

--详情请求时间
function FinanceItemData:SetNextValidTime(time)
	self.callTime = Time.unscaledTime + time
end

function FinanceItemData:CheckCanCall()
	if self.callTime == nil or self.callTime <= Time.unscaledTime then
		return true
	end

	return false
end

function FinanceItemData:GetItemData()
	if self.itemData == nil then
		self.itemData = ItemData.new("FinanceItemData", self.itemid)
	end

	return self.itemData
end

function FinanceItemData:GetDetailList()
	return self.detailList
end

function FinanceItemData:GetMaxDetailRatio()
	return self.maxDetailRatio or 0
end

function FinanceItemData:GetMinDetailRatio()
	return self.minDetailRatio or 0
end

function FinanceItemData:GetMiddleDetailRatio()
	if self.maxDetailRatio ~= nil and self.minDetailRatio ~= nil then
		return (self.maxDetailRatio + self.minDetailRatio) / 2
	end

	return 0
end