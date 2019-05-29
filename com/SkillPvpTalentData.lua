SkillPvpTalentData = class("SkillPvpTalentData")
function SkillPvpTalentData:ctor(points)
  self.skills = {}
  self:UpdatePoints(points)
end
function SkillPvpTalentData:UpdatePoints(points)
  self.usedPoints = points
end
function SkillPvpTalentData:UpdateSkill(serverSkillItem)
  local skill = self:FindSkillById(serverSkillItem.id)
  if skill then
    skill:Reset(serverSkillItem.id, serverSkillItem.pos, serverSkillItem.autopos, serverSkillItem.cd, serverSkillItem.sourceid, serverSkillItem.extendpos, serverSkillItem.shortcuts)
    self:UpdateSingleSkill(skill, serverSkillItem)
  else
    skill = self:AddSkill(serverSkillItem)
  end
  if not Table_TalentSkill[skill.sortID] then
    LogUtility.Error(string.format("\230\178\161\230\156\137\229\156\168Table_TalentSkill\228\184\173\230\137\190\229\136\176\230\138\128\232\131\189%s\231\154\132\229\175\185\229\186\148\233\133\141\231\189\174\239\188\129", skill.id))
  end
  return skill
end
function SkillPvpTalentData:UpdateSingleSkill(skillItemData, serverSkillItem)
  if skillItemData then
    skillItemData:SetActive(serverSkillItem.active)
    skillItemData:SetLearned(serverSkillItem.learn)
    skillItemData:SetSource(serverSkillItem.source)
    skillItemData:SetShadow(serverSkillItem.shadow)
    skillItemData:SetSpecialID(serverSkillItem.runespecid)
    skillItemData:SetReplaceID(serverSkillItem.replaceid)
    skillItemData:SetEnableSpecialEffect(serverSkillItem.selectswitch)
    skillItemData:SetExtraLevel(serverSkillItem.extralv)
    skillItemData:SetOwnerId(serverSkillItem.ownerid)
    local consume = serverSkillItem.consume
    if consume then
      skillItemData:ResetUseTimes(consume.curvalue, consume.maxvalue, consume.nexttime)
    end
  end
end
function SkillPvpTalentData:AddSkill(serverSkillItem)
  local skillItemData = SkillItemData.new(serverSkillItem.id, serverSkillItem.pos, serverSkillItem.autopos, SkillProxy.Instance:GetMyProfession(), serverSkillItem.sourceid, serverSkillItem.extendpos, serverSkillItem.shortcuts)
  self:UpdateSingleSkill(skillItemData, serverSkillItem)
  self.skills[skillItemData.sortID] = skillItemData
  return skillItemData
end
function SkillPvpTalentData:RemoveSkill(serverSkillItem)
  local sortID = math.floor(serverSkillItem.id / 1000)
  local skill = self.skills[sortID]
  self.skills[sortID] = nil
  return skill
end
function SkillPvpTalentData:FindSkillById(id)
  return self.skills[math.floor(id / 1000)]
end
