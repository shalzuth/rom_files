AEResetData = class("AEResetData")

function AEResetData:ctor(data)
	self.map = {}
end

function AEResetData:SetData(data)
	if data ~= nil then
		local mode = data.mode
		if mode == AERewardType.Tower then
			if self.rewardMap[mode] == nil then
				self.rewardMap[mode] = data.times
			end
		end
	end
end

function AEResetData:GetDataByType(type)
	return self.map[type]
end