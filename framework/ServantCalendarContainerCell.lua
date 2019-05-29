autoImport("BaseCell")
ServantCalendarContainerCell = class("ServantCalendarContainerCell", ItemCell)
local spriteName_Unbook = "calendar_bg_icon"
local spriteName_booked = "calendar_bg_icon_booked"
function ServantCalendarContainerCell:Init()
  self:FindObj()
  self:AddCellClickEvent()
  self:AddEvts()
end
function ServantCalendarContainerCell:FindObj()
  self.dayLab = self:FindComponent("Day", UILabel)
  self.bg = self:FindComponent("Bg", UISprite)
  self.iconPfb = self:FindGO("ActPfb")
  self.actIconGrid = self:FindComponent("ActGrid", UIGrid)
  self.symbol = self:FindGO("Symbol")
  self.todayFlag = self:FindGO("TodayFlag")
end
function ServantCalendarContainerCell:AddEvts()
  self:AddClickEvent(self.bg.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function ServantCalendarContainerCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.gameObject)
    self.dayLab.text = data:GetUIDisplayDay()
    self:SetActivityIcon()
    self.todayFlag:SetActive(data:IsToday())
    self.bg.alpha = data:CheckTransparent() and 0.5 or 0.9
  else
    self:Hide(self.gameObject)
  end
end
function ServantCalendarContainerCell:SetActivityIcon()
  local actDatas = self.data:GetActiveData(true)
  if not actDatas then
    return
  end
  for i = 1, math.min(#actDatas, 6) do
    local iconObj = self:FindGO("activity" .. i)
    iconObj = iconObj or self:CopyGameObject(self.iconPfb)
    iconObj:SetActive(true)
    iconObj.transform:SetParent(self.actIconGrid.gameObject.transform)
    iconObj.name = "activity" .. i
    local iconBg = self:FindComponent("ActBg", UISprite, iconObj)
    iconBg.spriteName = actDatas[i]:IsBooked() and spriteName_booked or spriteName_Unbook
    local actFather = self:FindGO("ActFather", iconObj)
    iconObj = self:FindComponent("Act", UISprite, actFather)
    IconManager:SetUIIcon(actDatas[i].staticData.Icon, iconObj)
    iconObj:MakePixelPerfect()
  end
  self.symbol:SetActive(#actDatas > 6)
  self.actIconGrid:Reposition()
end
