autoImport("WeddingCharData")

WeddingInfoData = class("WeddingInfoData")

WeddingInfoData.Status = {
	Reserve = WeddingCCmd_pb.EWeddingStatus_Reserve,	--预定
	Married = WeddingCCmd_pb.EWeddingStatus_Married,	--结婚成功
	Divorce = WeddingCCmd_pb.EWeddingStatus_Divorce,	--离婚
}

local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack

function WeddingInfoData:ctor(data)
	self.charList = {}
	self.charMap = {}

	self:SetData(data)
end

function WeddingInfoData:SetData(data)
	if data then
		self.id = data.id
		self.status = data.status
		self.zoneid = data.zoneid
		self.starttime = data.starttime
		self.endtime = data.endtime
		self.canSingleDivorce = data.can_single_divorce

		_ArrayClear(self.charList)
		local char1 = WeddingCharData.new(data.char1)
		local char2 = WeddingCharData.new(data.char2)
		_ArrayPushBack(self.charList, char1)
		_ArrayPushBack(self.charList, char2)
		self.charMap[char1.charid] = char1
		self.charMap[char2.charid] = char2

		self.startTimeData = nil
		self.endTimeData = nil
		self.partnerGuid = nil
		self.zoneStr = nil
	end
end

function WeddingInfoData:IsWeddingTime(year, month, day, hour)
	local startData = self:GetStartTimeData()

	local checkHour = true
	if hour ~= nil then
		checkHour = startData.hour == hour
	end
	
	return startData.year == year and startData.month == month and startData.day == day and checkHour
end

function WeddingInfoData:GetStartTimeData()
	if self.startTimeData == nil then
		self.startTimeData = os.date("*t", self.starttime)
	end

	return self.startTimeData
end

function WeddingInfoData:GetEndTimeData()
	if self.endTimeData == nil then
		self.endTimeData = os.date("*t", self.endtime)
	end

	return self.endTimeData
end

function WeddingInfoData:GetCharList()
	return self.charList
end

function WeddingInfoData:GetCharData(guid)
	return self.charMap[guid]
end

function WeddingInfoData:GetPartnerGuid()
	if self.partnerGuid == nil then
		for i=1,#self.charList do
			local charid = self.charList[i].charid
			if charid ~= Game.Myself.data.id then
				self.partnerGuid = charid
			end
		end
	end

	return self.partnerGuid
end

function WeddingInfoData:GetPartnerData()
	for i=1,#self.charList do
		local data = self.charList[i]
		if data.charid ~= Game.Myself.data.id then
			return data
		end
	end
end

function WeddingInfoData:GetZoneStr()
	if self.zoneStr == nil then
		local zoneid = self.zoneid % 10000
		self.zoneStr = ChangeZoneProxy.Instance:ZoneNumToString(zoneid)
	end

	return self.zoneStr
end