QuotaDetailData = class("QuotaDetailData");

function QuotaDetailData:SetDetailData(data)
	self.value = data.value
	self.balance = data.left
	self.expire_time = data.expire_time
	self.time = data.time
end

function QuotaDetailData:bUsedUp()
	return self.balance<=0
end

function QuotaDetailData:bOverDue()
	return self.expire_time <= ServerTime.CurServerTime()/1000
end