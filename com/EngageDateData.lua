autoImport("EngageDayData")

EngageDateData = class("EngageDateData")

EngageDateData.Status = {
	None = WeddingCCmd_pb.EDateStatus_None,
	Full = WeddingCCmd_pb.EDateStatus_Full,
	Hot = WeddingCCmd_pb.EdateStatus_Hot,
}

local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack

function EngageDateData:ctor(data)
	self.dayList = {}

	self:SetData(data)
end

function EngageDateData:SetData(data)
	if data then
		self.timeStamp = data.date
		self.time = os.date("*t", self.timeStamp)
		self.status = data.status
		self.count = data.count

		self.dateStr = nil
	end
end

function EngageDateData:SetDayList(list)
	_ArrayClear(self.dayList)
	
	for i=1,#list do
		local data = EngageDayData.new(list[i])
		_ArrayPushBack(self.dayList, data)
	end
end

function EngageDateData:GetDateString()
	if self.dateStr == nil then
		self.dateStr = string.format(ZhString.Wedding_EngageDate, self.time.year, self.time.month, self.time.day)
	end

	return self.dateStr
end

function EngageDateData:GetDayList()
	return self.dayList
end