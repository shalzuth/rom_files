AEGuildBuildingData = class("AEGuildBuildingData")

function AEGuildBuildingData:ctor(data)
	self.types = {}

	self:SetData(data)
end

function AEGuildBuildingData:SetData(data)
	if data ~= nil then
		TableUtility.TableClear(self.types) 
		local length = #data.types
		for i=1,length do
			local typeID = data.types[i]
			self.types[typeID] = typeID
		end
		self.minlv = data.minlv
		self.maxlv = data.maxlv
		self.submitinc = data.submitinc
		self.rewardinc = data.rewardinc
		
	end
end

function AEGuildBuildingData:SetTime(data)
	self.beginTime = data.begintime
	self.endTime = data.endtime
end

--判断是否在活动时间内
function AEGuildBuildingData:IsInActivity()
	if self.beginTime ~= nil and self.endTime ~= nil then
		local server = ServerTime.CurServerTime()/1000
		return server >= self.beginTime and server <= self.endTime
	else
		return false
	end
end

-- 判断是否符合等级要求
function AEGuildBuildingData:CheckEffectByGuildBuildingLevel(gLevel)
	if gLevel >= self.minlv and gLevel <= self.maxlv then
		return true
	else
		return false
	end
end

function AEGuildBuildingData:CheckEffectByGuildBuildingType(gType)
	if self.types and self.types[gType] then
		return true
	else
		return false
	end
end

function AEGuildBuildingData:GetSubmitInc()
	return self.submitinc
end

function AEGuildBuildingData:GetRewardInc()
	return self.rewardinc
end