ClientTimeUtil = {}

DATA_FORMAT = "%y-%m-%d %H:%M:%S"

--startTime,endTime为"2015-8-10-12-30-0"格式，返回bool
function ClientTimeUtil.IsCurTimeInRegion(startStrTime,endStrTime)
	return DateTimeHelper.IsCurTimeInRegion(startStrTime,endStrTime)
end

-- "yyyy-MM-dd-HH-mm-ss"
function ClientTimeUtil.FormatTimeTick(secend, format)
	format = format or "yyyy-MM-dd";
	return DateTimeHelper.FormatTimeTick(secend, format);
end

--startTime,格式为"2015-8-10"格式，返回bool
function ClientTimeUtil.TransTimeStrToTimeTick(startStrTime, compTick, deltaDay)
	return DateTimeHelper.IsTimeInRegionByDeltaDay(startStrTime, compTick, deltaDay);
end


local SysNow = DateTimeHelper.SysNow;
--startTime,格式为"2015-8-10"格式，返回bool
function ClientTimeUtil.GetNowHourMinStr()
	local now = SysNow();
	return string.format("%02d:%02d", now.Hour, now.Minute);
end

-- servertime 以秒为单位，分钟、小时、天、周、月
function ClientTimeUtil.GetFormatOfflineTimeStr(serverTime)
	if(serverTime == 0)then
		return ZhString.ClientTimeUtil_Online;
	end

	local offlineSec = ServerTime.CurServerTime()/1000 - serverTime;
	if offlineSec >= 0 then
		return ClientTimeUtil.GetFormatTimeStr(serverTime)
	else
		return ZhString.ClientTimeUtil_Online;
	end
end

function ClientTimeUtil.GetFormatTimeStr(serverTime)
	local offlineSec = ServerTime.CurServerTime()/1000 - serverTime;
	local offlineMin = math.floor(offlineSec / 60);
	if offlineSec >= 0 then
		if offlineMin < 1 then
			return ZhString.ClientTimeUtil_OfflineSecond;
		elseif offlineMin < 60 then
			return string.format(ZhString.ClientTimeUtil_OfflineMinute, offlineMin);
		else
			local offlineHour = math.floor(offlineMin / 60);
			if offlineHour < 24 then
				return string.format(ZhString.ClientTimeUtil_OfflineHour, offlineHour);
			else
				local offlineDay = math.floor(offlineHour / 24);
				if offlineDay < 7 then
					return string.format(ZhString.ClientTimeUtil_OfflineDay, offlineDay);
				else
					local offlineWeek = math.floor(offlineDay / 7);
					if offlineWeek < 4 or offlineDay < 30 then
						return string.format(ZhString.ClientTimeUtil_OfflineWeek, offlineWeek);
					else
						local offlineMonth = math.floor(offlineWeek / 4);
						return string.format(ZhString.ClientTimeUtil_OfflineMonth, offlineMonth);
					end
				end
			end
		end
	end

	return ZhString.ClientTimeUtil_OfflineSecond
end

-- servertime 以秒为单位，今天，天
function ClientTimeUtil.GetFormatDayTimeStr(serverTime)
	local offlineSec = ServerTime.CurServerTime()/1000 - serverTime
	local offlineDay = math.floor(offlineSec / 86400)
	if offlineDay < 1 then
		return ZhString.ClientTimeUtil_OfflineToday
	else
		return string.format(ZhString.ClientTimeUtil_OfflineDay, offlineDay)
	end
end

-- refreshtime 以秒为单位
function ClientTimeUtil.GetFormatRefreshTimeStr(refreshtime)
	if(refreshtime == 0)then
		return ZhString.ClientTimeUtil_Online;
	end
	return ClientTimeUtil.FormatTimeBySec(refreshtime - ServerTime.CurServerTime()/1000);
end

-- totalSec 以秒为单位, 分，秒
function ClientTimeUtil.GetFormatSecTimeStr( totalSec )
	local minSec = 60

	local min = math.floor( totalSec / minSec)
	local sec = math.floor( totalSec - min * minSec )

	return min,sec
end

function ClientTimeUtil.FormatTimeBySec( totalSec )
	local daySec = 60 * 60 * 24
	local hourSec = 60 * 60
	local minSec = 60

	local day = math.floor(totalSec / daySec)
	local hour = math.floor( (totalSec - daySec * day) / hourSec)
	local min = math.floor( (totalSec - daySec * day - hour * hourSec) / minSec)
	local sec = math.floor( totalSec - daySec * day - hour * hourSec - min * minSec );

	return day,hour,min,sec
end