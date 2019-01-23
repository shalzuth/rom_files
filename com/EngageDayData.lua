EngageDayData = class("EngageDayData")

EngageDayData.Status = {
	Free = 1,	--空闲
	Booked = 2,	--已预订
	Ban = 3,	--禁止
}

function EngageDayData:ctor(data)
	self:SetData(data)
end

function EngageDayData:SetData(data)
	if data then
		self.id = data.id
		self.configid = data.configid
		self.starttime = data.starttime
		self.endtime = data.endtime
		self.price = data.price

		if data.ban then
			self.status = self.Status.Ban
		else
			if data.id == 0 then
				self.status = self.Status.Free
			else
				self.status = self.Status.Booked
			end
		end
		
		self.startTimeData = nil
		self.endTimeData = nil
	end
end

function EngageDayData:SetStatus(status)
	self.status = status
end

function EngageDayData:GetStartTimeData()
	if self.startTimeData == nil then
		self.startTimeData = os.date("*t", self.starttime)
	end

	return self.startTimeData
end

function EngageDayData:GetEndTimeData()
	if self.endTimeData == nil then
		self.endTimeData = os.date("*t", self.endtime)
	end

	return self.endTimeData
end