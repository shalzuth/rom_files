autoImport("BaseCell")
ServantCalendarWeekTimeLineCell = class("ServantCalendarWeekTimeLineCell", ItemCell)
function ServantCalendarWeekTimeLineCell:Init()
  self.timeLab = self:FindComponent("TimeLab", UILabel)
end
function ServantCalendarWeekTimeLineCell:SetData(data)
  self.timeLab.text = "17:00"
end
