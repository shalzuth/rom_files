ZoneData = class("ZoneData")

ZoneData.ZoneStatus = {
	None = SceneUser2_pb.EZONESTATUS_MIN,
	Free = SceneUser2_pb.EZONESTATUS_FREE,
	Busy = SceneUser2_pb.EZONESTATUS_BUSY,
	VeryBusy = SceneUser2_pb.EZONESTATUS_VERYBUSY,
}

-- 对应Table_GFaithUIColorConfig表
ZoneData.ZoneColor = {
	None = 8,
	Free = 3,
	Busy = 4,
	VeryBusy = 1,
}

ZoneData.JumpZone = {
	Guild = SceneUser2_pb.EJUMPZONE_GUILD,
	Team = SceneUser2_pb.EJUMPZONE_TEAM,
	User = SceneUser2_pb.EJUMPZONE_USER,
}

function ZoneData:ctor(data)
	self:SetData(data)
end

function ZoneData:SetData(data)
	self.zoneid = data.zoneid
	self.status = data.status
	self.type = data.type
	self.maxbaselv = data.maxbaselv
end