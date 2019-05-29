local baseCell = autoImport("BaseCell")
AdventureAchievementCell = class("AdventureAchievementCell", baseCell)
function AdventureAchievementCell:Init()
  self:initView()
end
function AdventureAchievementCell:initView()
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
end
function AdventureAchievementCell:SetData(data)
  IconManager:SetUIIcon(data.staticData.Icon, self.icon)
end
