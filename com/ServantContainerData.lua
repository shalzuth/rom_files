CalendarActivityData = class("CalendarActivityData")
CalendarActivityData.STATUS = {
  GO = 1,
  CANBOOK = 2,
  BOOKED = 3
}
function CalendarActivityData:ctor(id, y, m, d)
  self.staticData = Table_ServantCalendar[id]
  self.year = y
  self.month = m
  self.day = d
  self.startHour = tonumber(string.sub(self.staticData.StartTime, 1, 2))
  self.endHour = tonumber(string.sub(self.staticData.EndTime, 1, 2))
  self.startMin = tonumber(string.sub(self.staticData.StartTime, 4, 5))
  self.endMin = tonumber(string.sub(self.staticData.EndTime, 4, 5))
end
function CalendarActivityData:IsBooked()
  local datekey = self:GetStartTimeStamp(5)
  local books = ServantCalendarProxy.Instance:GetBookingDataByDate(datekey)
  if not books then
    return false
  end
  return 0 ~= TableUtility.ArrayFindIndex(books, self.staticData.id)
end
function CalendarActivityData:GetDuringHour()
  local data = self.staticData
  local sh = tonumber(string.sub(data.StartTime, 1, 2))
  local eh = tonumber(string.sub(data.EndTime, 1, 2))
  local sm = tonumber(string.sub(data.StartTime, 4, 5))
  local em = tonumber(string.sub(data.EndTime, 4, 5))
  if sm ~= em or not (eh - sh) then
  end
  return eh - sh + (em - sm) / 60
end
function CalendarActivityData:IsExpired()
  return ServerTime.CurServerTime() / 1000 > self:GetEndTimeStamp()
end
local INTERVAL_STAMP = GameConfig.Servant.playNpcTalkTimeStamp
function CalendarActivityData:IsComming()
  return self:GetStartTimeStamp() > ServerTime.CurServerTime() / 1000
end
function CalendarActivityData:GetActName()
  return self.staticData.Name
end
function CalendarActivityData:GetStatus()
  if self:IsOnGoing() then
    return CalendarActivityData.STATUS.GO
  elseif self:IsBooked() then
    return CalendarActivityData.STATUS.BOOKED
  elseif self:IsComming() then
    return CalendarActivityData.STATUS.CANBOOK
  end
end
function CalendarActivityData:GetStartTimeStamp(FlagForServer)
  local h = FlagForServer or self.startHour
  local m = FlagForServer and 0 or self.startMin
  local timestamp = os.time({
    year = self.year,
    month = self.month,
    day = self.day,
    hour = h,
    min = m,
    sec = 0
  })
  return timestamp
end
function CalendarActivityData:GetEndTimeStamp()
  local timestamp = os.time({
    year = self.year,
    month = self.month,
    day = self.day,
    hour = self.endHour,
    min = self.endMin,
    sec = 0
  })
  return timestamp
end
function CalendarActivityData:IsOnGoing(ignoreInterval)
  local curStamp = ServerTime.CurServerTime() / 1000
  local startStamp = ignoreInterval and self:GetStartTimeStamp() - INTERVAL_STAMP or self:GetStartTimeStamp()
  local endStamp = self:GetEndTimeStamp()
  if curStamp < endStamp and curStamp > startStamp then
    return true
  end
  return false
end
ServantContainerData = class("ServantContainerData")
function ServantContainerData:ctor(year, month, day)
  self.activeData = {}
  self.weekActiveData = {}
  self.year = year
  self.month = month
  self.day = day
  self.weekday = os.date("%a", os.time({
    year = year,
    month = month,
    day = day
  }))
  self.timeIntervalArray = {}
  self:SetActivityData()
  self.weekDisplayData = {}
end
function ServantContainerData:IsToday()
  local y, m, d = ServantCalendarProxy.GetCurDate()
  return self.year == y and self.month == m and self.day == d
end
function ServantContainerData:GetUIDisplayDay()
  return self.day
end
function ServantContainerData:IsExpired()
  local lastStamp = os.time({
    year = self.year,
    month = self.month,
    day = self.day,
    hour = 23,
    min = 59,
    sec = 59
  })
  return lastStamp < ServerTime.CurServerTime() / 1000
end
function ServantContainerData:SetActivityData()
  if not Table_ServantCalendar then
    return
  end
  local server = FunctionLogin.Me():getCurServerData()
  local linegroup = 0
  linegroup = server and (server.linegroup or 1)
  for k, v in pairs(Table_ServantCalendar) do
    if 0 == TableUtility.ArrayFindIndex(v.ServerID, linegroup) then
      local acData = CalendarActivityData.new(v.id, self.year, self.month, self.day)
      if 1 == v.TimeUnit then
        self.activeData[#self.activeData + 1] = acData
      elseif 2 == v.TimeUnit and self.weekday == v.Wday then
        self.activeData[#self.activeData + 1] = acData
      end
    end
  end
  table.sort(self.activeData, function(l, r)
    if l == nil or r == nil then
      return false
    end
    local lh = tonumber(string.sub(l.staticData.StartTime, 1, 2))
    local rh = tonumber(string.sub(r.staticData.StartTime, 1, 2))
    local lm = tonumber(string.sub(l.staticData.StartTime, 4, 5))
    local rm = tonumber(string.sub(r.staticData.StartTime, 4, 5))
    if lh ~= rh then
      return lh < rh
    elseif lm ~= rm then
      return lm < rm
    else
      return l.staticData.id < r.staticData.id
    end
  end)
  self:SetWeekData()
end
function ServantContainerData:GetActiveData(ignoreExpired)
  if ignoreExpired then
    return self.activeData
  end
  local validAcData = {}
  for i = 1, #self.activeData do
    if not self.activeData[i]:IsExpired() then
      validAcData[#validAcData + 1] = self.activeData[i]
    end
  end
  return validAcData
end
function ServantContainerData:GetCommingActData()
  local data = {}
  local acData = self:GetActiveData()
  for i = 1, #acData do
    if acData[i]:IsComming() then
      data[#data + 1] = acData[i]
    end
  end
  return data
end
function ServantContainerData:GetOnGoingActData(ignoreInterval)
  local data = {}
  local acData = self:GetActiveData()
  for i = 1, #acData do
    if acData[i]:IsOnGoing(ignoreInterval) then
      data[#data + 1] = acData[i]
    end
  end
  return data
end
function ServantContainerData:GetBookActData()
  local data = {}
  local acData = self:GetActiveData()
  for i = 1, #acData do
    if acData[i]:IsBooked() then
      data[#data + 1] = acData[i]
    end
  end
  return data
end
function ServantContainerData:SetWeekData()
  for i = 1, #self.activeData do
    local act = self.activeData[i]
    local key = tonumber(string.sub(act.staticData.StartTime, 1, 2))
    if nil == self.weekActiveData[key] then
      self.weekActiveData[key] = {}
      self.timeIntervalArray[#self.timeIntervalArray + 1] = key
    end
    TableUtility.ArrayPushBack(self.weekActiveData[key], act)
  end
end
function ServantContainerData:GetMinTimeInterval()
  return math.min(unpack(self.timeIntervalArray))
end
function ServantContainerData:GetMaxTimeInterval()
  return math.max(unpack(self.timeIntervalArray))
end
function ServantContainerData:CheckTransparent()
  local status = ServantCalendarProxy.Instance:GetViewStatus()
  if status == ServantCalendarProxy.EViewStatus.WEEK then
    return self:IsExpired()
  else
    local _, viewMon = ServantCalendarProxy.Instance:ViewDate()
    return viewMon ~= self.month
  end
end
function ServantContainerData:GetWeekDisplayData()
  local intervalData = {}
  local weekData = ServantCalendarProxy.Instance:GetCurWeekData()
  local minValue, maxValue = ServantCalendarProxy.Instance:GetMinMaxTimeGap(weekData)
  for i = minValue, maxValue do
    if nil == self.weekActiveData[i] then
      intervalData[#intervalData + 1] = {}
    else
      intervalData[#intervalData + 1] = self.weekActiveData[i]
    end
  end
  return intervalData
end
local DATE_FORMAT = "%s\229\185\180%s\230\156\136%s\230\151\165"
function ServantContainerData:GetUIDisplayDate()
  return string.format(DATE_FORMAT, self.year, self.month, self.day)
end
