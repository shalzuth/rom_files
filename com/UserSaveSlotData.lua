UserSaveSlotData = class("UserSaveSlotData")

function UserSaveSlotData:ctor(data)
	self.id = data.id
	self.type = data.type
	if data.active then
		self.status = 1
	else
		self.status = 0
	end
	self.costid = data.costid
	self.costnum = data.costnum
	self.recordTime = 0
end

function UserSaveSlotData:UpdateSlotStatus(newStatus)
	self.status = newStatus
end

function UserSaveSlotData:ResetRecordTime(time)
	self.recordTime = time
end

function UserSaveSlotData:SetRecordName(name)
	self.recordName = name
end
