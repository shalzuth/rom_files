autoImport("UserSaveInfoData")
autoImport("UserSaveSlotData")

UserSaveData = class("UserSaveData")

function UserSaveData:ctor(data)
	self.userSaveInfoData = UserSaveInfoData.new(data.record)
	self.userSaveSlotData = UserSaveSlotData.new(data.slot)
end

function UserSaveData:UpdateSlotStatus(newStatus)
	self.userSaveSlotData:UpdateSlotStatus(newStatus)
end

function UserSaveData:UpdateRecordTime(newTime)
	self.userSaveInfoData:UpdateRecordTime(newTime)
end

function UserSaveData:UpdateName(newName)
	self.userSaveInfoData:UpdateName(newName)
end