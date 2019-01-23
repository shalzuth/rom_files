DojoRewardData = class("DojoRewardData")

function DojoRewardData:ctor(data)
	self:SetData(data)
end

function DojoRewardData:SetData(data)
	self.id = data.id
	self.count = data.count
end