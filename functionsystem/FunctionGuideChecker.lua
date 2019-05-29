FunctionGuideChecker = class("FunctionGuideChecker")
function FunctionGuideChecker.Me()
  if nil == FunctionGuideChecker.me then
    FunctionGuideChecker.me = FunctionGuideChecker.new()
  end
  return FunctionGuideChecker.me
end
function FunctionGuideChecker:ctor()
  self.quests = {}
  TimeTickManager.Me():CreateTick(0, 1000, self.Update, self)
end
function FunctionGuideChecker:AddGuideCheck(questData)
  QuestProxy.Instance:SelfDebug("FunctionGuideChecker:AddGuideCheck(questData)")
  local id = questData.id
  self.quests[id] = questData
end
function FunctionGuideChecker:CreateTickAgain()
  TimeTickManager.Me():CreateTick(0, 1000, self.Update, self)
end
function FunctionGuideChecker.RemoveGuideCheck(id)
  QuestProxy.Instance:SelfDebug("before stop1")
  if FunctionGuideChecker.me then
    FunctionGuideChecker.Me():RemoveGuideCheckById(id)
  end
end
function FunctionGuideChecker:RemoveGuideCheckById(id)
  self.quests[id] = nil
  local count = 0
  for _ in pairs(self.quests) do
    count = count + 1
  end
  if count < 1 then
    QuestProxy.Instance:SelfDebug("before stop")
    self:stopChecker()
  end
end
function FunctionGuideChecker:stopChecker()
  QuestProxy.Instance:SelfDebug("FunctionGuideChecker:stopChecker()")
  TimeTickManager.Me():ClearTick(self)
  FunctionGuideChecker.me = nil
end
function FunctionGuideChecker:Update(deltaTime)
  for _, questData in pairs(self.quests) do
    self:tryStartGuide(questData)
  end
end
function FunctionGuideChecker:tryStartGuide(questData)
  local guideId = questData.params.guideID
  local guideData = Table_GuideID[guideId]
  if guideData then
    local tag = guideData.ButtonID
    if tag then
      local tagObj = GuideTagCollection.getGuideItemById(tag)
      if tagObj and not GameObjectUtil.Instance:ObjectIsNULL(tagObj) and tagObj.gameObject.activeInHierarchy then
        if tag == 201 then
          QuestProxy.Instance:SelfDebug("unctionGuideChecker:tryStartGuide(questData)\t")
          FunctionGuide.Me():showGuideByQuestData(questData)
          self:RemoveGuideCheckById(questData.id)
        else
          FunctionGuide.Me():showGuideByQuestData(questData)
          self:RemoveGuideCheckById(questData.id)
          else
            self:RemoveGuideCheckById(questData.id)
          end
          else
            self:RemoveGuideCheckById(questData.id)
          end
        end
      else
      end
end
