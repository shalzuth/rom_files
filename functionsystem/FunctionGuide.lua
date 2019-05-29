FunctionGuide = class("FunctionGuide", EventDispatcher)
autoImport("GuideMaskView")
autoImport("FunctionGuide_Map")
function FunctionGuide.Me()
  if nil == FunctionGuide.me then
    FunctionGuide.me = FunctionGuide.new()
  end
  return FunctionGuide.me
end
function FunctionGuide:ctor()
end
function FunctionGuide:stopGuide()
  if GuideMaskView.Instance then
    GuideMaskView.Instance:CloseSelf()
  end
end
function FunctionGuide:skillPointCheck(value)
  self:checkQuestGuide(3, value)
end
function FunctionGuide:buyItemCheck(value)
  self:checkQuestGuide(2, value)
end
function FunctionGuide:attrPointCheck(value)
  self:checkQuestGuide(1, value)
end
function FunctionGuide:checkQuestGuide(optionId, value)
  local instance = GuideMaskView.Instance
  if instance and instance.guideData then
    do
      local guideData = instance.guideData
      if guideData and guideData.optionId and guideData.optionId == optionId then
        local optionData = Table_GuideOption[optionId]
        if optionData then
          local type = optionData.content.type
          local dataValue = optionData.content.value
          local complete = false
          if type == ">" then
            if value > dataValue then
              complete = true
            end
          elseif type == "<" then
            if value < dataValue then
              complete = true
            end
          else
            if type == "==" and value == dataValue then
              complete = true
            else
            end
          end
          if complete then
            if instance.lastOption == optionId then
              return
            end
            instance.lastOption = optionId
            local questData = instance.questData
            QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
          end
        else
        end
      else
      end
    end
  else
  end
end
function FunctionGuide:checkGuideStateWhenExit(singleOrList)
  local instance = GuideMaskView.Instance
  if instance and instance.questData then
    local questData = instance.questData
    local currentGuideId = instance.currentGuideId
    local curBtnId = instance.currentTriggerId or -1
    if type(singleOrList) == "table" then
      for i = 1, #singleOrList do
        local single = singleOrList[i]
        if currentGuideId == single.id then
          if curBtnId == instance.guideData.ButtonID and instance.guideData.ButtonID == 202 then
            instance:restoreParent(true)
          else
            instance:restoreParent()
          end
          if curBtnId ~= instance.guideData.ButtonID then
            if instance.questData then
              QuestProxy.Instance:notifyQuestState(instance.questData.scope, instance.questData.id, instance.questData.staticData.FailJump)
            else
              helplog("instance.questData nil!")
            end
            instance:CloseSelf()
            return
          end
        else
        end
      end
      return
    else
      if currentGuideId == singleOrList and curBtnId ~= instance.guideData.ButtonID then
        QuestProxy.Instance:notifyQuestState(instance.questData.scope, instance.questData.id, instance.questData.staticData.FailJump)
        instance:CloseSelf()
      else
      end
    end
  else
  end
end
function FunctionGuide:triggerWithTag(tag)
  local instance = GuideMaskView.Instance
  if instance and instance.questData and instance.guideData then
    local guideData = instance.guideData
    local btnId = guideData.ButtonID
    if btnId and btnId == tag then
      local sameButton = instance.currentTriggerId and instance.currentTriggerId == btnId or false
      local clickCauseComplete = guideData.press
      clickCauseComplete = clickCauseComplete and clickCauseComplete == 1
      if clickCauseComplete and not sameButton then
        local jumpId = instance.questData.staticData.FinishJump
        local questId = instance.questData.id
        instance.currentTriggerId = btnId
        local questData = instance.questData
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
        local guideType = instance.questData.params.type
        if guideType == QuestDataGuideType.QuestDataGuideType_force then
          instance:restoreParent()
        end
        instance:Show(instance.mask)
      else
      end
    else
    end
  else
  end
end
function FunctionGuide:showGuideByQuestData(questData)
  if not questData then
    return
  end
  local instance = GuideMaskView.getInstance()
  if instance and instance.forbid then
    return
  end
  instance:restoreParent()
  instance:resetData()
  local guideId = questData.params.guideID
  local guideType = questData.params.type
  local guideData = Table_GuideID[guideId]
  if guideId == 66 then
    QuestProxy.Instance:SelfDebug("showGuideByQuestData\232\191\153\228\184\170\230\152\175\232\131\140\229\140\133\228\184\173\231\154\132\228\184\156\232\165\191 \232\166\129\229\141\129\229\136\134\232\176\168\230\133\142\231\154\132\229\164\132\231\144\134guideId:" .. guideId)
  end
  if guideData then
    local tag = guideData.ButtonID
    if guideData.Preguide and guideData.Preguide ~= instance.currentGuideId then
      QuestProxy.Instance:SelfDebug("\229\189\147\229\137\141\228\187\187\229\138\161\231\154\132\229\137\141\231\189\174\229\188\149\229\175\188\230\156\170\229\174\140\230\136\144\233\156\128\232\166\129\229\155\158\233\128\128  guideData.Preguide\239\188\154" .. tostring(guideData.Preguide) .. "instance.currentGuideId:" .. tostring(instance.currentGuideId))
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      return
    end
    if tag then
      local tagObj = GuideTagCollection.getGuideItemById(tag)
      if tagObj and not GameObjectUtil.Instance:ObjectIsNULL(tagObj) and tagObj.gameObject.activeInHierarchy then
        QuestProxy.Instance:SelfDebug("instance:showGuideByQuestData(questData)")
        instance:showGuideByQuestData(questData)
      elseif not tagObj and guideData.ServerEvent ~= "" then
        helplog("wait ServerEvent:", guideData.ServerEvent)
        instance:waitServerEvent(guideData.ServerEvent, questData)
      else
        if tagObj then
          helplog("obj activeInHierarchy:", tagObj.gameObject.activeInHierarchy)
        end
        QuestProxy.Instance:SelfDebug("can't find obj by tag:", tag, questData.staticData.FailJump)
        local FailJump = guideData.FailJump
        QuestProxy.Instance:SelfDebug("can't find obj by tag:1")
        if FailJump == 1 then
          if tag == 201 and BagProxy.Instance:GetItemsByStaticID(5400) ~= nil then
            QuestProxy.Instance:SelfDebug("\232\175\180\230\152\142\232\191\153\228\184\170\230\151\182\229\128\153\229\156\168\232\131\140\229\140\133\229\134\133\228\189\134\230\152\175\230\178\161\230\152\190\231\164\186 \230\137\128\228\187\165\232\166\129\230\140\129\231\187\173\230\163\128\230\159\165")
            FunctionGuideChecker.Me():AddGuideCheck(questData)
          else
            QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
            QuestProxy.Instance:SelfDebug("can't find obj by tag:2")
          end
        else
          FunctionGuideChecker.Me():AddGuideCheck(questData)
          QuestProxy.Instance:SelfDebug("can't find obj by tag:3")
        end
        return
      end
    elseif guideType == QuestDataGuideType.QuestDataGuideType_showDialog then
      if self:checkGuideMap(questData.map) then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
        GameFacade.Instance:sendNotification(GuideEvent.ShowBubble, guideData.BubbleID)
        helplog("QuestDataGuideType_showDialog Show Bubble guide !FinishJump:", questData.staticData.FinishJump, guideData.BubbleID)
      else
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
        helplog("QuestDataGuideType_showDialog Show Bubble guide !FailJump:", questData.staticData.FailJump, guideData.BubbleID)
      end
      instance:CloseSelf()
    elseif guideType == QuestDataGuideType.QuestDataGuideType_showDialog_Repeat then
      if self:checkGuideMap(questData.map) then
        local bubbleId = guideData.BubbleID
        if bubbleId and Table_BubbleID[bubbleId] then
          GameFacade.Instance:sendNotification(GuideEvent.ShowBubble, bubbleId)
          local bubbleData = Table_BubbleID[bubbleId]
          local delayTime = bubbleData.RepeatDeltaTime or 60
          local questId = questData.id
          local step = questData.step
          self:CheckBubbleGuideRepeat(questId, step, delayTime)
        end
      else
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      end
      instance:CloseSelf()
    elseif guideType == QuestDataGuideType.QuestDataGuideType_showDialog_Anim then
      if self:checkGuideMap(questData.map) then
        local bubbleId = guideData.BubbleID
        GameFacade.Instance:sendNotification(GuideEvent.MiniMapAnim, {questData = questData, bubbleId = bubbleId})
      else
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      end
      instance:CloseSelf()
    else
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      return
    end
  else
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
    return
  end
end
function FunctionGuide:setGuideUIActive(tag, bRet)
  local instance = GuideMaskView.Instance
  if instance and instance.questData and instance.guideData then
    local guideData = instance.guideData
    local btnId = guideData.ButtonID
    if btnId and btnId == tag then
      instance:setGuideUIActive(bRet)
      break
    else
    end
  else
  end
end
function FunctionGuide:checkGuideMap(map)
  local currentMapID = Game.MapManager:GetMapID()
  if currentMapID == map then
    return true
  else
    return false
  end
end
function FunctionGuide:CheckBubbleGuideRepeat(questId, step, delayTime)
  LeanTween.delayedCall(delayTime, function()
    local data = QuestProxy.Instance:getQuestDataByIdAndType(questId)
    local count = QuestProxy.Instance:GetTraceCellCount()
    local noTraceCells = not count or count <= 0
    if data and data.step == step and noTraceCells then
      QuestProxy.Instance:notifyQuestState(data.scope, questId, data.staticData.FailJump)
    elseif data then
      QuestProxy.Instance:notifyQuestState(data.scope, questId, data.staticData.FinishJump)
    end
  end)
end
