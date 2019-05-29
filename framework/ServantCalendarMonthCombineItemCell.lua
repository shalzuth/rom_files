autoImport("BaseCombineCell")
ServantCalendarMonthCombineItemCell = class("ServantCalendarMonthCombineItemCell", BaseCombineCell)
autoImport("ServantCalendarContainerCell")
function ServantCalendarMonthCombineItemCell:Init()
  self:InitCells(7, "ServantCalendarContainerCell", ServantCalendarContainerCell)
end
