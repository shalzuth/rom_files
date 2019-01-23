AERewardInfoData = class("AERewardInfoData")

function AERewardInfoData:ctor(data,begintime,endtime)
	self:SetData(data)
	self:SetTime(begintime,endtime)
end

function AERewardInfoData:SetData(data)
	if data ~= nil then
		self.mode = data.mode
		self.multiple = data.multiplereward.multiple
		self.multipleDaylimit = data.multiplereward.daylimit
		self.multipleAcclimit = data.multiplereward.acclimit
		self.extratimes = data.extratimes
	end
end

function AERewardInfoData:SetTime(begintime,endtime)
	self.beginTime = begintime
	self.endTime = endtime
end

function AERewardInfoData:IsInActivity()
	if self.beginTime ~= nil and self.endTime ~= nil then
		local server = ServerTime.CurServerTime()/1000
		return server >= self.beginTime and server <= self.endTime
	else
		return true
	end
end

function AERewardInfoData:CheckMultipleReward()
	local _ActivityEventProxy = ActivityEventProxy.Instance
	local userData = _ActivityEventProxy:GetUserDataByType(self.mode)
	local multipledaycount = userData and userData:GetMultipleDayCount() or 0
	if multipledaycount >= self.multipleDaylimit then
		return false
	end

	if self.multipleAcclimit then
		local multipleacclimitcharid = userData and userData:GetMultipleAcclimitCharid() or 0
		if multipleacclimitcharid ~= 0 and multipleacclimitcharid ~= Game.Myself.data.id then
			return false
		end
	end
	return true
end

--翻倍奖励
function AERewardInfoData:GetMultiple()
	if self:CheckMultipleReward() then
		return self.multiple
	else
		return 0
	end
end

--额外次数
function AERewardInfoData:GetExtraTimes()
	return self.extratimes
end