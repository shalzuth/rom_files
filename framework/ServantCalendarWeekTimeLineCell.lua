autoImport("BaseCell")
ServantCalendarWeekTimeLineCell = class("ServantCalendarWeekTimeLineCell", ItemCell)
function ServantCalendarWeekTimeLineCell:Init()
  self.timeLab = self:FindComponent("TimeLab", UILabel)
end
local FORMAT = "%s:00"
function ServantCalendarWeekTimeLineCell:SetData(data)
  self.timeLab.text = string.format(FORMAT, data)
end
