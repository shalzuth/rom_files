local baseCell = autoImport("BaseCell")
AchievementPreQuestCell = class("AchievementPreQuestCell", baseCell)
function AchievementPreQuestCell:Init()
  self:initView()
end
function AchievementPreQuestCell:initView()
  self.questStatus = self:FindComponent("questStatus", UILabel)
end
function AchievementPreQuestCell:SetData(data)
  local name = data.name
  local hasAccept, hasSubmit = self:GetQuestType(data)
  local questListType
  if hasAccept then
    questListType = SceneQuest_pb.EQUESTLIST_ACCEPT
  elseif hasSubmit then
    questListType = SceneQuest_pb.EQUESTLIST_SUBMIT
  end
  local statusStr
  if questListType == SceneQuest_pb.EQUESTLIST_SUBMIT then
    statusStr = ZhString.AdventureAchievePage_Finish
    self.questStatus.color = LuaColor.black
  elseif questListType == SceneQuest_pb.EQUESTLIST_ACCEPT then
    statusStr = ZhString.AdventureAchievePage_Accept
  else
    statusStr = ZhString.AdventureAchievePage_UnAccept
  end
  self.questStatus.text = string.format(ZhString.AdventureAchievePage_PreFinishQuestText, name, statusStr)
end
function AchievementPreQuestCell:GetQuestType(data)
  local preAccept
  local hasAccept = false
  local hasSubmit = false
  local exsitQuestData = QuestProxy.Instance:getQuestDataByIdAndType(data.id)
  if exsitQuestData then
    hasAccept = true
  end
  if not exsitQuestData then
    exsitQuestData = QuestProxy.Instance:getQuestDataByIdAndType(data.id, SceneQuest_pb.EQUESTLIST_SUBMIT)
    if exsitQuestData then
      hasSubmit = true
    end
  end
  return hasAccept, hasSubmit
end
