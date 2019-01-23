AERewardItemData = class("AERewardItemData")

function AERewardItemData:ctor(data)
	self:SetData(data)
end

function AERewardItemData:SetData(data)
	if data ~= nil then
		self.multipledaycount = data.multipledaycount
		self.multipleacclimitcharid = data.multipleacclimitcharid
	end
end

function AERewardItemData:GetMultipleDayCount()
	return self.multipledaycount
end

function AERewardItemData:GetMultipleAcclimitCharid()
	return self.multipleacclimitcharid
end