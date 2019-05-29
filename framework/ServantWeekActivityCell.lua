ServantWeekActivityCell = class("ServantWeekActivityCell", ItemCell)
local spriteName_Unbook = "calendar_bg_icon"
local spriteName_booked = "calendar_bg_icon_booked"
function ServantWeekActivityCell:Init()
  self.icon = self:FindComponent("ActIcon", UISprite)
  self.nameLab = self:FindComponent("Name", UILabel)
  self.startTimeLab = self:FindComponent("StartTime", UILabel)
  self.duringTimeLab = self:FindComponent("DuringTime", UILabel)
  self.servantImg = self:FindComponent("bg", UISprite)
end
local FORMAT = "%sh"
function ServantWeekActivityCell:SetData(data)
  self.data = data
  if data then
    local staticData = data.staticData
    self.gameObject:SetActive(true)
    local exitIcon = IconManager:SetUIIcon(staticData.Icon, self.icon)
    exitIcon = exitIcon or IconManager:SetItemIcon(staticData.Icon, self.icon)
    self.icon:MakePixelPerfect()
    self.nameLab.text = staticData.Name
    UIUtil.WrapLabel(self.nameLab)
    self.startTimeLab.text = staticData.StartTime
    self.duringTimeLab.text = string.format(FORMAT, data:GetDuringHour())
    self.servantImg.spriteName = data:IsBooked() and spriteName_booked or spriteName_Unbook
  else
    self.gameObject:SetActive(false)
  end
end
