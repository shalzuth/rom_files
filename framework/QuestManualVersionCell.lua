local baseCell = autoImport("BaseCell")
QuestManualVersionCell = class("QuestManualVersionCell", baseCell)
function QuestManualVersionCell:Init()
  self:initView()
end
function QuestManualVersionCell:initView()
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.tabName = self:FindComponent("TabName", UILabel)
end
function QuestManualVersionCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.icon.color = QuestManualView.ColorTheme[5].color
      self.tabName.color = QuestManualView.ColorTheme[5].color
    else
      self.icon.color = QuestManualView.ColorTheme[1].color
      self.tabName.color = QuestManualView.ColorTheme[1].color
    end
  end
end
local tempVector3 = LuaVector3.zero
function QuestManualVersionCell:SetData(data)
  self.data = data
  self.tabName.text = data.name
  self.icon.spriteName = data.icon
end
