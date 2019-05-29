local baseCell = autoImport("BaseCell")
AchievementCategoryChildCell = class("AchievementCategoryChildCell", baseCell)
AchievementCategoryChildCell.selectedColor = LuaColor(0.1411764705882353, 0.4980392156862745, 0.7529411764705882, 1)
AchievementCategoryChildCell.unselectedColor = LuaColor(0.23529411764705882, 0.23529411764705882, 0.23529411764705882, 1)
function AchievementCategoryChildCell:Init()
  self:initView()
  self:initData()
  self:AddCellClickEvent()
end
function AchievementCategoryChildCell:initData()
  self.Name.color = AchievementCategoryChildCell.unselectedColor
end
function AchievementCategoryChildCell:initView()
  self.Name = self:FindGO("Name"):GetComponent(UILabel)
  self.Value = self:FindComponent("Value", UILabel)
  self.bg = self:FindComponent("bg", UISprite)
end
function AchievementCategoryChildCell:SetData(data)
  self.data = data
  self.Name.text = data.staticData.Name
  local unlock, total = AdventureAchieveProxy.Instance:getAchieveAndTotalNum(data.staticData.SubGroup, data.staticData.id)
  self.Value.text = unlock .. "/" .. total
end
function AchievementCategoryChildCell:setSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.Name.color = AchievementCategoryChildCell.selectedColor
    else
      self.Name.color = AchievementCategoryChildCell.unselectedColor
    end
  end
end
