autoImport("ServantContainerData")
ServantCalendarProxy = class("ServantCalendarProxy", pm.Proxy)
ServantCalendarProxy.Instance = nil
ServantCalendarProxy.NAME = "ServantCalendarProxy"
local MATCH_FORMAT = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local DAY_SECOND = 86400
ServantCalendarProxy.WeekSingleContainerSize = 50
ServantCalendarProxy.reservation_day = GameConfig.Servant.reservation_day or 2
ServantCalendarProxy.EViewStatus = {
  NONE = 0,
  WEEK = 1,
  MONTH = 2,
  DAY = 3
}
ServantCalendarProxy.ESEASON = {
  WINTER = 1,
  SPRING = 2,
  SUMMER = 3,
  AUTUMN = 4
}
function ServantCalendarProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ServantCalendarProxy.NAME
  if ServantCalendarProxy.Instance == nil then
    ServantCalendarProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function ServantCalendarProxy:Init()
  self.viewStatus = ServantCalendarProxy.EViewStatus.NONE
  self.viewWeekIndex = 1
  self.viewMonthIndex = 1
  self.calendarDatas = {}
  self.reservations = {}
  self.weekCalendar = {}
  self.uiWeekCalendar = {}
  self.monthCalendar = {}
end
function ServantCalendarProxy:InitCalendar()
  if self.isInit then
    return
  end
  local cur_year, cur_month, cur_day = ServantCalendarProxy.GetCurDate()
  local _, startDateWeek = ServantCalendarProxy.get_days(cur_year, cur_month)
  local startDateInterval = startDateWeek == 7 and 0 or -startDateWeek
  local StartYear, StartMonth, StartDay = ServantCalendarProxy.GetChangeDate(cur_year, cur_month, 1, startDateInterval)
  local lastYear = cur_year
  local lastMonth = cur_month + ServantCalendarProxy.reservation_day
  if lastMonth > 12 then
    lastMonth = lastMonth - 12
    lastYear = cur_year + 1
  end
  local lastMonthDayNum = ServantCalendarProxy.get_days(lastYear, lastMonth)
  local lastDayWeek = ServantCalendarProxy.getWday(lastYear, lastMonth, lastMonthDayNum)
  local endDateInterval = lastDayWeek == 7 and 6 or 6 - lastDayWeek
  local EndYear, EndMonth, EndDay = ServantCalendarProxy.GetChangeDate(lastYear, lastMonth, lastMonthDayNum, endDateInterval)
  local totalInterval = os.time({
    year = EndYear,
    month = EndMonth,
    day = EndDay
  }) - os.time({
    year = StartYear,
    month = StartMonth,
    day = StartDay
  }) + DAY_SECOND
  self.totalDay = totalInterval / DAY_SECOND
  self.totalWeek = self.totalDay / 7
  for i = 0, self.totalDay - 1 do
    local y, m, d = ServantCalendarProxy.GetChangeDate(StartYear, StartMonth, StartDay, i)
    self.calendarDatas[#self.calendarDatas + 1] = ServantContainerData.new(y, m, d)
  end
  self:SetWeekCalendar()
  self:SetMonthCalendar()
  self.isInit = true
end
function ServantCalendarProxy:GetNearlyData(y, m, d, isforward)
  local index = 0
  for i = 1, #self.calendarDatas do
    local data = self.calendarDatas[i]
    if data.year == y and data.month == m and data.day == d then
      index = i
      break
    end
  end
  if 0 ~= index then
    index = isforward and index + 1 or index - 1
    return self.calendarDatas[index]
  end
end
function ServantCalendarProxy:SetWeekCalendar()
  for index = 1, self.totalWeek do
    if nil == self.weekCalendar[index] then
      self.weekCalendar[index] = {}
    end
    for i = 1, 7 do
      local dataIndex = i + 7 * (index - 1)
      TableUtility.ArrayPushBack(self.weekCalendar[index], self.calendarDatas[dataIndex])
    end
  end
  local cur_year, cur_month, cur_day = ServantCalendarProxy.GetCurDate()
  local curWeekIndex = self:FindWeekIndex(cur_year, cur_month, cur_day)
  for i = curWeekIndex, self.totalWeek do
    local wData = self.weekCalendar[i]
    local ddd = {}
    for i = 1, #wData do
      ddd[#ddd + 1] = wData[i]
    end
    self.uiWeekCalendar[#self.uiWeekCalendar + 1] = ddd
  end
end
function ServantCalendarProxy:SetMonthCalendar()
  local cur_year, cur_month, cur_day = ServantCalendarProxy.GetCurDate()
  for i = 0, ServantCalendarProxy.reservation_day do
    local month = cur_month + i
    local year = cur_year
    if month > 12 then
      month = month - 12
      year = year + 1
    end
    local monthdays = ServantCalendarProxy.get_days(year, month)
    local startWeekIndex = self:FindWeekIndex(year, month, 1)
    local endWeekIndex = self:FindWeekIndex(year, month, monthdays)
    local monthIndex = i + 1
    if nil == self.monthCalendar[monthIndex] then
      self.monthCalendar[monthIndex] = {}
    end
    for j = startWeekIndex, endWeekIndex do
      for windex = 1, #self.weekCalendar[j] do
        TableUtility.ArrayPushBack(self.monthCalendar[monthIndex], self.weekCalendar[j][windex])
      end
    end
  end
end
function ServantCalendarProxy:SetViewStatus(var)
  self.viewStatus = var
end
function ServantCalendarProxy:GetViewStatus()
  return self.viewStatus
end
function ServantCalendarProxy:SetWeekIndex(i)
  self.viewWeekIndex = i
end
function ServantCalendarProxy:SetMonthIndex(i)
  self.viewMonthIndex = i
end
function ServantCalendarProxy:ViewDate()
  local cur_year, cur_month, cur_day = ServantCalendarProxy.GetCurDate()
  if self.viewStatus == ServantCalendarProxy.EViewStatus.WEEK then
    local data = self:GetCurWeekData()
    return data[1].year, data[1].month
  elseif self.viewStatus == ServantCalendarProxy.EViewStatus.MONTH then
    if self.viewMonthIndex ~= 1 then
      cur_month = cur_month + self.viewMonthIndex - 1
      if cur_month > 12 then
        cur_month = cur_month - 12
        cur_year = cur_year + 1
      end
    end
    return cur_year, cur_month
  else
    return nil
  end
end
function ServantCalendarProxy:GetViewData(index)
  if self.viewStatus == ServantCalendarProxy.EViewStatus.WEEK then
    return self:GetWeekCalendar(index)
  elseif self.viewStatus == ServantCalendarProxy.EViewStatus.MONTH then
    return self:GetMonthCalendar(index)
  elseif self.viewStatus == ServantCalendarProxy.EViewStatus.DAY then
  end
end
function ServantCalendarProxy:GetMonthCalendar(index)
  return self.monthCalendar[index]
end
function ServantCalendarProxy:GetWeekCalendar(index)
  return self.uiWeekCalendar[index]
end
function ServantCalendarProxy:FindWeekIndex(year, month, day)
  for k, v in pairs(self.weekCalendar) do
    for i = 1, #v do
      if v[i].year == year and v[i].month == month and v[i].day == day then
        return k
      end
    end
  end
end
function ServantCalendarProxy:UpdateReservation(opt, server_data)
  if 0 == opt then
    TableUtility.ArrayClear(self.reservations)
  end
  for i = 1, #server_data do
    local datekey = server_data[i].date
    local acts = server_data[i].actids
    if opt == 1 or opt == 0 then
      if nil == self.reservations[datekey] then
        self.reservations[datekey] = {}
      end
      for a = 1, #acts do
        TableUtility.ArrayPushBack(self.reservations[datekey], acts[a])
      end
    elseif opt == 2 then
      if nil == self.reservations[datekey] then
        redlog("\229\165\179\228\187\134\230\151\165\229\142\134\230\156\141\229\138\161\229\153\168\229\136\160\228\186\134\228\184\170\228\184\141\229\173\152\229\156\168\231\154\132\230\180\187\229\138\168 \230\151\182\233\151\180\230\136\179\239\188\154 ", datekey)
        return
      end
      if #acts <= 0 then
        return
      end
      TableUtility.ArrayRemove(self.reservations[datekey], acts[1])
    end
  end
end
function ServantCalendarProxy:CheckReservationDateValid()
  local servantID = Game.Myself.data.userdata:Get(UDEnum.SERVANTID)
  if not servantID or 0 == servantID then
    return false
  end
  if table.IsEmpty(self.reservations) then
    return false
  end
  local curServerTime = ServerTime.CurServerTime() / 1000
  for timeKey, acts in pairs(self.reservations) do
    for i = 1, #acts do
      local y = tonumber(os.date("%Y", timeKey))
      local m = tonumber(os.date("%m", timeKey))
      local d = tonumber(os.date("%d", timeKey))
      local actData = CalendarActivityData.new(acts[i], y, m, d)
      local starttimestamp = actData:GetStartTimeStamp()
      if curServerTime < starttimestamp then
        return true
      end
    end
  end
end
function ServantCalendarProxy:GetBookingData()
  return self.reservations
end
function ServantCalendarProxy:GetBookingDataByDate(date)
  return self.reservations[date]
end
function ServantCalendarProxy:GetWeekContainerSize()
  return weekSingleContainerSize
end
function ServantCalendarProxy:GetWeekLastestTime()
end
function ServantCalendarProxy.getWday(year, month, day)
  local week = os.date("*t", os.time({
    year = year,
    month = month,
    day = day
  })).wday
  week = week - 1
  if 0 == week then
    week = 7
  end
  return week
end
function ServantCalendarProxy:SetChooseDayData(d)
  self.ChooseDayData = d
end
function ServantCalendarProxy:GetChooseDayData()
  return self.ChooseDayData
end
function ServantCalendarProxy.get_days(year, month)
  local bigMonth = "(1)(3)(5)(7)(8)(10)(12)"
  local strMonth = "(" .. month .. ")"
  local week = ServantCalendarProxy.getWday(year, month, 1)
  if 2 == month then
    if year % 400 == 0 or year % 4 == 0 and year % 100 ~= 0 then
      return 29, week
    else
      return 28, week
    end
  elseif nil ~= string.find(bigMonth, strMonth) then
    return 31, week
  else
    return 30, week
  end
end
function ServantCalendarProxy.GetChangeDate(year, month, day, dayInterval)
  local time = os.time({
    year = year,
    month = month,
    day = day
  }) + dayInterval * DAY_SECOND
  local Y = tonumber(os.date("%Y", time))
  local M = tonumber(os.date("%m", time))
  local D = tonumber(os.date("%d", time))
  return Y, M, D
end
function ServantCalendarProxy.GetCurDate()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local curYear = tonumber(os.date("%Y", curServerTime))
  local curMonth = tonumber(os.date("%m", curServerTime))
  local curDay = tonumber(os.date("%d", curServerTime))
  return curYear, curMonth, curDay
end
function ServantCalendarProxy:getWeekNum(strDate)
  local ymd = string.split(strDate, "-")
  t = os.time({
    year = ymd[1],
    month = ymd[2],
    day = 1
  })
  local weekNum = os.date("*t", t).wday - 1
  if weekNum == 0 then
    weekNum = 7
  end
  return weekNum
end
function ServantCalendarProxy:GetMinMaxTimeGap(weekData)
  local minArray = {}
  local maxArray = {}
  for i = 1, #weekData do
    minArray[#minArray + 1] = weekData[i]:GetMinTimeInterval()
    maxArray[#maxArray + 1] = weekData[i]:GetMaxTimeInterval()
  end
  local gapMin = math.min(unpack(minArray))
  local gapMax = math.max(unpack(maxArray))
  return math.min(unpack(minArray)), math.max(unpack(maxArray))
end
function ServantCalendarProxy:GetWeekDayIntervalDatas()
  local weekData = self:GetWeekCalendar(self.viewWeekIndex)
  local minValue, maxValue = self:GetMinMaxTimeGap(weekData)
  local gap = maxValue - minValue
  local weekDisplayData = {}
  for i = 1, #weekData do
    local weekActiveData = weekData[i].weekActiveData
    for j = minValue, maxValue do
      if nil == weekActiveData[j] then
        weekDisplayData[i] = {}
      else
        weekDisplayData[i] = weekActiveData[j]
      end
    end
  end
  return weekDisplayData
end
function ServantCalendarProxy:GetCurWeekData()
  return self:GetWeekCalendar(self.viewWeekIndex)
end
function ServantCalendarProxy:IsTodayForeachWeek()
  local weeks = self:GetCurWeekData()
  for i = 1, #weeks do
    if weeks[i]:IsToday() then
      return true
    end
  end
end
function ServantCalendarProxy:GetWeekDays()
  local days = {}
  local data = self:GetWeekCalendar(self.viewWeekIndex)
  for i = 1, #data do
    days[#days + 1] = data[i]:GetUIDisplayDay()
  end
  return days
end
function ServantCalendarProxy.GetSeason(month)
  local seasonCFG = GameConfig.Servant.Season
  if not seasonCFG then
    redlog("\230\156\170\230\137\190\229\136\176GameConfig.Servant.Season")
    return ServantCalendarProxy.ESEASON.SPRING
  end
  local strMonth = "(" .. month .. ")"
  if nil ~= string.find(seasonCFG.winter, strMonth) then
    return ServantCalendarProxy.ESEASON.WINTER
  elseif nil ~= string.find(seasonCFG.spring, strMonth) then
    return ServantCalendarProxy.ESEASON.SPRING
  elseif nil ~= string.find(seasonCFG.summer, strMonth) then
    return ServantCalendarProxy.ESEASON.SUMMER
  else
    return ServantCalendarProxy.ESEASON.AUTUMN
  end
end
