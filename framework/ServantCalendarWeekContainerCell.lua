autoImport("ServantWeekIntervalCell")
ServantCalendarWeekContainerCell = class("ServantCalendarWeekContainerCell", ItemCell)
local CELL_HEIGHT_CFG = 220
local MIN_HEIGHT = 400
function ServantCalendarWeekContainerCell:Init()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.bgCollider = self.gameObject:GetComponent(BoxCollider)
  self.todayFlag = self:FindGO("TodayFlag")
  self:AddCellClickEvent()
  self:AddEvts()
  self:InitView()
end
function ServantCalendarWeekContainerCell:InitView()
  self.grid = self:FindGO("IntervalContainer"):GetComponent(UIGrid)
  self.weekIntervalCtl = UIGridListCtrl.new(self.grid, ServantWeekIntervalCell, "ServantWeekIntervalCell")
end
function ServantCalendarWeekContainerCell:AddEvts()
  self:AddClickEvent(self.bg.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function ServantCalendarWeekContainerCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.gameObject)
    local displayData = data:GetWeekDisplayData()
    if not displayData then
      return
    end
    local calHeight = #displayData * CELL_HEIGHT_CFG
    self.bg.height = math.max(calHeight, MIN_HEIGHT)
    self.bg:ResizeCollider()
    self.bg.alpha = data:CheckTransparent() and 0.5 or 0.9
    self.weekIntervalCtl:ResetDatas(displayData)
    self.todayFlag:SetActive(data:IsToday())
  else
    self:Hide(self.gameObject)
  end
end
