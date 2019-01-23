UIModelMonthlyVIP = class('UIModelMonthlyVIP')

UIModelMonthlyVIP.instance = nil
function UIModelMonthlyVIP.Instance()
	if UIModelMonthlyVIP.instance == nil then
		UIModelMonthlyVIP.instance = UIModelMonthlyVIP.new()
	end
	return UIModelMonthlyVIP.instance
end

function UIModelMonthlyVIP:AmIMonthlyVIP()
	local currentServerTime = ServerTime.CurServerTime()
	if currentServerTime ~= nil then
		currentServerTime = currentServerTime / 1000
		local timeOfExpirationMonthlyVIP = self:Get_TimeOfExpirationMonthlyVIP()
		if timeOfExpirationMonthlyVIP ~= nil then
			if timeOfExpirationMonthlyVIP > currentServerTime then
				return true
			end
		end
	end
	return false
end

function UIModelMonthlyVIP:Set_TimeOfLatestPurchaseMonthlyVIP(unix_time)
	self.timeOfLatestPurchaseMonthlyVIP = unix_time
end

function UIModelMonthlyVIP:Get_TimeOfLatestPurchaseMonthlyVIP()
	return self.timeOfLatestPurchaseMonthlyVIP
end

function UIModelMonthlyVIP:Set_TimeOfExpirationMonthlyVIP(unix_time)
	self.timeOfExpirationMonthlyVIP = unix_time
end

function UIModelMonthlyVIP:Get_TimeOfExpirationMonthlyVIP()
	return self.timeOfExpirationMonthlyVIP
end

function UIModelMonthlyVIP:GetMonthCardLeftDays()
	if(self.timeOfExpirationMonthlyVIP)then
		local currentServerTime = ServerTime.CurServerTime()
		if currentServerTime ~= nil then
			currentServerTime = currentServerTime / 1000
			local timeOfExpirationMonthlyVIP = self:Get_TimeOfExpirationMonthlyVIP()
			local delta = timeOfExpirationMonthlyVIP - currentServerTime
			if  delta < 0 then
				return 0
			else
				local days = delta/3600/24
				days = math.ceil(days)
				return days
			end
		end
		return 0
	end
	return nil
end

-- delta second
function UIModelMonthlyVIP.YearOfServer(delta)
	local year = 0
	local currentTime = ServerTime.CurServerTime()
	if currentTime ~= nil then
		currentTime = currentTime / 1000
	else
		currentTime = os.time()
	end
	if delta ~= nil then
		currentTime = currentTime + delta
	end
	return UIModelMonthlyVIP.YearOfUnixTimestamp(currentTime)
end

function UIModelMonthlyVIP.MonthOfServer(delta)
	local month = 0
	local currentTime = ServerTime.CurServerTime()
	if currentTime ~= nil then
		currentTime = currentTime / 1000
	else
		currentTime = os.time()
	end
	if delta ~= nil then
		currentTime = currentTime + delta
	end
	return UIModelMonthlyVIP.MonthOfUnixTimestamp(currentTime)
end

function UIModelMonthlyVIP.YearOfUnixTimestamp(timestamp)
	local strYear = os.date('%Y', timestamp)
	return tonumber(strYear)
end

function UIModelMonthlyVIP.MonthOfUnixTimestamp(timestamp)
	local strMonth = os.date('%m', timestamp)
	return tonumber(strMonth)
end

function UIModelMonthlyVIP.DayOfUnixTimestamp(timestamp)
	local strDay = os.date('%d', timestamp)
	return tonumber(strDay)
end

function UIModelMonthlyVIP.HourOfUnixTimestamp(timestamp)
	local strHour = os.date('%H', timestamp)
	return tonumber(strHour)
end

function UIModelMonthlyVIP.MinuteOfUnixTimestamp(timestamp)
	local strMinute = os.date('%M', timestamp)
	return tonumber(strMinute)
end

function UIModelMonthlyVIP.SecondOfUnixTimestamp(timestamp)
	local strSecond = os.date('%S', timestamp)
	return tonumber(strSecond)
end