local baseCell = autoImport("BaseCell")
PoemQuestListCell = class("PoemQuestListCell", baseCell)
function PoemQuestListCell:Init()
  self:initView()
end
function PoemQuestListCell:initView()
  self.questName = self:FindComponent("questName", UILabel)
  self:AddButtonEvent("ActiveBtn", function()
    self:PassEvent(QuestManualEvent.PoemClick, self)
  end)
end
function PoemQuestListCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.questName.color = QuestManualView.ColorTheme[4].color
    elseif self.data.complete then
      self.questName.color = QuestManualView.ColorTheme[3].color
    else
      self.questName.color = QuestManualView.ColorTheme[2].color
    end
  end
end
function PoemQuestListCell:SetData(data)
  self.data = data
  if data.complete then
    self.questName.color = QuestManualView.ColorTheme[3].color
  else
    self.questName.color = QuestManualView.ColorTheme[2].color
  end
  self.questName.text = data.name
  self.isSelected = false
end
