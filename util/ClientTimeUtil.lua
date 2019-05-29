ClientTimeUtil = {}
DATA_FORMAT = "%y-%m-%d %H:%M:%S"
function ClientTimeUtil.IsCurTimeInRegion(startStrTime, endStrTime)
  return DateTimeHelper.IsCurTimeInRegion(startStrTime, endStrTime)
end
function ClientTimeUtil.FormatTimeTick(secend, format)
  format = format or "yyyy-MM-dd"
  return DateTimeHelper.FormatTimeTick(secend, format)
end
function ClientTimeUtil.TransTimeStrToTimeTick(startStrTime, compTick, deltaDay)
  return DateTimeHelper.IsTimeInRegionByDeltaDay(startStrTime, compTick, deltaDay)
end
local SysNow = DateTimeHelper.SysNow
function ClientTimeUtil.GetNowHourMinStr()
  local now = SysNow()
  return string.format("%02d:%02d", now.Hour, now.Minute)
end
function ClientTimeUtil.GetFormatOfflineTimeStr(serverTime)
  if serverTime == 0 then
    return ZhString.ClientTimeUtil_Online
  end
  local offlineSec = ServerTime.CurServerTime() / 1000 - serverTime
  if offlineSec >= 0 then
    return ClientTimeUtil.GetFormatTimeStr(serverTime)
  else
    return ZhString.ClientTimeUtil_Online
  end
end
function ClientTimeUtil.GetFormatTimeStr(serverTime)
  local offlineSec = ServerTime.CurServerTime() / 1000 - serverTime
  local offlineMin = math.floor(offlineSec / 60)
  if offlineSec >= 0 then
    if offlineMin < 1 then
      return ZhString.ClientTimeUtil_OfflineSecond
    elseif offlineMin < 60 then
      return string.format(ZhString.ClientTimeUtil_OfflineMinute, offlineMin)
    else
      local offlineHour = math.floor(offlineMin / 60)
      if offlineHour < 24 then
        return string.format(ZhString.ClientTimeUtil_OfflineHour, offlineHour)
      else
        local offlineDay = math.floor(offlineHour / 24)
        if offlineDay < 7 then
          return string.format(ZhString.ClientTimeUtil_OfflineDay, offlineDay)
        else
          local offlineWeek = math.floor(offlineDay / 7)
          if offlineWeek < 4 or offlineDay < 30 then
            return string.format(ZhString.ClientTimeUtil_OfflineWeek, offlineWeek)
          else
            local offlineMonth = math.floor(offlineWeek / 4)
            return string.format(ZhString.ClientTimeUtil_OfflineMonth, offlineMonth)
          end
        end
      end
    end
  end
  return ZhString.ClientTimeUtil_OfflineSecond
end
function ClientTimeUtil.GetFormatDayTimeStr(serverTime)
  local offlineSec = ServerTime.CurServerTime() / 1000 - serverTime
  local offlineDay = math.floor(offlineSec / 86400)
  if offlineDay < 1 then
    return ZhString.ClientTimeUtil_OfflineToday
  else
    return string.format(ZhString.ClientTimeUtil_OfflineDay, offlineDay)
  end
end
function ClientTimeUtil.GetFormatRefreshTimeStr(refreshtime)
  if refreshtime == 0 then
    return ZhString.ClientTimeUtil_Online
  end
  return ClientTimeUtil.FormatTimeBySec(refreshtime - ServerTime.CurServerTime() / 1000)
end
function ClientTimeUtil.GetFormatSecTimeStr(totalSec)
  local minSec = 60
  local min = math.floor(totalSec / minSec)
  local sec = math.floor(totalSec - min * minSec)
  return min, sec
end
function ClientTimeUtil.FormatTimeBySec(totalSec)
  local daySec = 86400
  local hourSec = 3600
  local minSec = 60
  local day = math.floor(totalSec / daySec)
  local hour = math.floor((totalSec - daySec * day) / hourSec)
  local min = math.floor((totalSec - daySec * day - hour * hourSec) / minSec)
  local sec = math.floor(totalSec - daySec * day - hour * hourSec - min * minSec)
  return day, hour, min, sec
end
