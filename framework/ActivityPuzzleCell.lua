local baseCell = autoImport("BaseCell")
ActivityPuzzleCell = class("ActivityPuzzleCell", baseCell)
function ActivityPuzzleCell:Init()
  self:initView()
end
function ActivityPuzzleCell:initView()
  self.tabName = self:FindComponent("TabName", UILabel)
  self.tabTime = self:FindComponent("TabTime", UILabel)
end
function ActivityPuzzleCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.tabName.color = ActivityPuzzleView.ColorTheme[5].color
      self.tabTime.color = ActivityPuzzleView.ColorTheme[5].color
    else
      self.tabName.color = ActivityPuzzleView.ColorTheme[1].color
      self.tabTime.color = ActivityPuzzleView.ColorTheme[1].color
    end
  end
end
local tempVector3 = LuaVector3.zero
function ActivityPuzzleCell:SetData(data)
  self.data = data
  self.staticData = Table_ActivityInfo[data.actid]
  self.tabName.text = self.staticData.ActivityName
  local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(self.staticData.StartTime)
  local end_year, end_month, end_day, end_hour, end_min, end_sec = StringUtil.GetDateData(self.staticData.EndTime)
  self.tabTime.text = string.format(ZhString.TimePeriodFormat, st_month, st_day, end_month, end_day)
end
