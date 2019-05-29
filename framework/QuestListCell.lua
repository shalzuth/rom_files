local baseCell = autoImport("BaseCell")
QuestListCell = class("QuestListCell", baseCell)
function QuestListCell:Init()
  self:initView()
end
function QuestListCell:initView()
  self.questMark = self:FindGO("mark")
  self.questName = self:FindComponent("questName", UILabel)
end
function QuestListCell:setIsSelected(isSelected)
end
function QuestListCell:SetData(data)
  self.data = data
  if data.complete then
    self.questMark:SetActive(true)
    self.questName.color = QuestManualView.ColorTheme[4].color
  else
    self.questMark:SetActive(false)
    self.questName.color = QuestManualView.ColorTheme[2].color
  end
  self.questName.text = data.name
end
