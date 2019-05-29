autoImport("SkillCell")
autoImport("SkillItemData")
TalentSkillCell = class("TalentSkillCell", SkillCell)
function TalentSkillCell:Init()
  TalentSkillCell.super.Init(self)
end
function TalentSkillCell:SetData(data)
  self.layer = data.layer
  self.maxLevel = data.maxLevel
  TalentSkillCell.super.SetData(self, data.skill)
  self:SetLevel(data.level)
  self:EnableGray(false)
end
function TalentSkillCell:SetLevel(curLevel)
  TalentSkillCell.super.SetLevel(self, curLevel, nil, false)
  self.curLevel = curLevel
  self.simulateLevel = curLevel
  self:SetLevelText()
end
function TalentSkillCell:ResetLevel()
  self.simulateLevel = self.curLevel
  self:SetLevelText()
end
function TalentSkillCell:GetCurLevel()
  return self.curLevel
end
function TalentSkillCell:GetSimulateLevel()
  return self.simulateLevel
end
function TalentSkillCell:SetLevelText()
  local color = self.simulateLevel > self.curLevel and "[54B30AFF]" or "[000000]"
  self.skillLevel.text = string.format("%s%d[-]/%d", color, self.simulateLevel, self.maxLevel)
end
function TalentSkillCell:TrySimulateUpgrade()
  if self.simulateLevel < self.maxLevel then
    self.simulateLevel = self.simulateLevel + 1
    self:SetLevelText()
    if self.simulateLevel >= self.maxLevel then
      self:ShowUpgrade(false)
    end
    self:ShowDowngrade(true)
    return true
  else
    return false
  end
end
function TalentSkillCell:TrySimulateDowngrade()
  if self.simulateLevel > self.curLevel then
    self.simulateLevel = self.simulateLevel - 1
    self:SetLevelText()
    if self.simulateLevel <= self.curLevel then
      self:ShowDowngrade(false)
    end
    self:ShowUpgrade(true)
    return true
  else
    return false
  end
end
function TalentSkillCell:SetCellEnable(isEnable)
  self:ShowUpgrade(isEnable and self.simulateLevel < self.maxLevel)
  self:ShowDowngrade(isEnable and self.simulateLevel > self.curLevel)
  if isEnable then
    self:SetTextureWhite(self.gameObject)
  else
    self:ResetLevel()
    self:SetTextureGrey(self.gameObject)
  end
end
function TalentSkillCell:IsChanged()
  return self.simulateLevel > self.curLevel
end
function TalentSkillCell:SetDisableOperate()
  self:ShowUpgrade(false)
  self:ShowDowngrade(false)
  self:EnableGray(self.simulateLevel < 1)
end
function TalentSkillCell:TryGetSimulateSkillID()
  if not self:IsChanged() then
    return nil
  end
  local id = self.data.id
  local skillData
  for i = math.max(self.curLevel, 1), self.simulateLevel - 1 do
    skillData = Table_Skill[id]
    if skillData and skillData.NextID then
      id = skillData.NextID
    end
  end
  return id
end
function TalentSkillCell:GetSimulateSkillItemData()
  if self:IsChanged() then
    local simulateID = self:TryGetSimulateSkillID()
    if not self.simulateData then
      self.simulateData = SkillItemData.new(simulateID, 0, 0, self.data.profession)
      self.simulateData:SetLearned(0 < self.simulateLevel)
    elseif self.simulateData.id ~= simulateID then
      self.simulateData:Reset(simulateID, 0, 0, 0, 0)
    end
    return self.simulateData
  else
    return self.data
  end
end
