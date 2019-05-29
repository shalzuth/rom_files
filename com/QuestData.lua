QuestData = reusableClass("QuestData")
autoImport("QuestStep")
autoImport("QuestReward")
autoImport("QuestDataUtil")
local ArrayClear = TableUtility.ArrayClear
autoImport("QuestTypeConfig")
QuestDataScopeType = {QuestDataScopeType_FUBEN = "fubenScope", QuestDataScopeType_CITY = "cityScope"}
QuestDataGuideType = {
  QuestDataGuideType_explain = 1,
  QuestDataGuideType_force = 2,
  QuestDataGuideType_unforce = 3,
  QuestDataGuideType_showDialog = 4,
  QuestDataGuideType_showDialog_Repeat = 5,
  QuestDataGuideType_showDialog_Anim = 6
}
QuestData.AutoExecuteQuestAtInit = {
  QuestDataStepType.QuestDataStepType_CLIENT_PLOT,
  QuestDataStepType.QuestDataStepType_TALK,
  QuestDataStepType.QuestDataStepType_GUIDE,
  QuestDataStepType.QuestDataStepType_RAID,
  QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER
}
QuestData.AutoTriggerQuest = {
  QuestDataStepType.QuestDataStepType_SELFIE,
  QuestDataStepType.QuestDataStepType_USE,
  QuestDataStepType.QuestDataStepType_PURIFY,
  QuestDataStepType.QuestDataStepType_MOVE,
  QuestDataStepType.QuestDataStepType_TALK,
  QuestDataStepType.QuestDataStepType_RAID,
  QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER
}
QuestData.NoTraceQuestDataType = {
  QuestDataType.QuestDataType_TALK,
  QuestDataType.QuestDataType_MANUAL
}
QuestData.NoDirAndDisStepType = {
  QuestDataStepType.QuestDataStepType_CAMERA,
  QuestDataStepType.QuestDataStepType_LEVEL,
  QuestDataStepType.QuestDataStepType_INVADE,
  QuestDataStepType.QuestDataStepType_WAIT,
  QuestDataStepType.QuestDataStepType_PURIFY,
  QuestDataStepType.QuestDataStepType_REWARD,
  QuestDataStepType.QuestDataStepType_GUIDE,
  QuestDataStepType.QuestDataStepType_MEDIA,
  QuestDataStepType.QuestDataStepType_RAID,
  QuestDataStepType.QuestDataStepType_ILLUSTRATION
}
QuestData.EffectTriggerStepType = {
  QuestDataStepType.QuestDataStepType_MOVE,
  QuestDataStepType.QuestDataStepType_USE,
  QuestDataStepType.QuestDataStepType_SELFIE,
  QuestDataStepType.QuestDataStepType_TALK
}
QuestData.CanExecuteWhenDeadStepType = {
  QuestDataStepType.QuestDataStepType_GUIDE
}
QuestData.ShowTargetNamePrefixStepType = {
  QuestDataStepType.QuestDataStepType_KILL,
  QuestDataStepType.QuestDataStepType_GATHER,
  QuestDataStepType.QuestDataStepType_COLLECT
}
QuestData.ItemUpdateStepType = {
  QuestDataStepType.QuestDataStepType_ITEM,
  QuestDataStepType.QuestDataStepType_MONEY
}
function QuestData:DoConstruct(asArray, scope)
  self.scope = scope
  self.process = 1
  self.steps = ReusableTable.CreateArray()
  self.names = ReusableTable.CreateArray()
  self.serverParams = ReusableTable.CreateArray()
  self.allrewardid = ReusableTable.CreateArray()
  self.preQuest = ReusableTable.CreateArray()
  self.mustPreQuest = ReusableTable.CreateArray()
  self.staticData = nil
  self.pos = nil
end
function QuestData:Deconstruct()
  self._alive = false
  self.type = nil
  self.questDataStepType = nil
  self.scope = nil
  self.process = 0
  self.pos = VectorUtility.Destroy(self.pos)
  self:DestroyRewards()
  self:DestroySteps()
  self:DestroyNames()
  self:DestroyServerParams()
  self:DestroyAllRewards()
  self:DestroyPreRewards()
  self:DestroyMustRewards()
end
function QuestData:ClearRewards()
  for i = #self.rewards, 1, -1 do
    ReusableTable.DestroyAndClearTable(self.rewards[i])
    self.rewards[i] = nil
  end
end
function QuestData:ClearSteps()
  for i = #self.steps, 1, -1 do
    local stepData = self.steps[i]
    local staticData = stepData.staticData
    ReusableTable.DestroyAndClearTable(staticData)
    stepData.staticData = nil
    ReusableTable.DestroyAndClearTable(stepData)
    self.steps[i] = nil
  end
  self.staticData = nil
end
function QuestData:DestroyRewards()
  if self.rewards then
    self:ClearRewards()
    ReusableTable.DestroyAndClearArray(self.rewards)
    self.rewards = nil
  end
end
function QuestData:DestroyPreRewards()
  if self.preQuest then
    ReusableTable.DestroyAndClearArray(self.preQuest)
    self.preQuest = nil
  end
end
function QuestData:DestroyMustRewards()
  if self.mustPreQuest then
    ReusableTable.DestroyAndClearArray(self.mustPreQuest)
    self.mustPreQuest = nil
  end
end
function QuestData:DestroySteps()
  if self.steps then
    self:ClearSteps()
    ReusableTable.DestroyAndClearArray(self.steps)
    self.steps = nil
  end
end
function QuestData:DestroyNames()
  if self.names then
    ReusableTable.DestroyAndClearArray(self.names)
    self.names = nil
  end
end
function QuestData:DestroyServerParams()
  if self.serverParams then
    ReusableTable.DestroyAndClearArray(self.serverParams)
    self.serverParams = nil
  end
end
function QuestData:DestroyAllRewards()
  if self.allrewardid then
    ReusableTable.DestroyAndClearArray(self.allrewardid)
    self.allrewardid = nil
  end
end
function QuestData:setQuestData(questData)
  self:update(questData.id, questData.step, questData.time, questData.steps, questData.complete, questData.trace, questData.detailid, questData.rewards, questData.acceptlv, questData.finishcount)
end
function QuestData:update(id, step, time, steps, complete, trace, detailid, rewards, acceptlv, finishcount)
  self.time = time
  self.complete = complete
  self.trace = trace
  self.detailid = detailid
  self.acceptlv = acceptlv
  self.finishcount = finishcount
  if self.steps then
    self:ClearSteps()
  end
  if steps and #steps > 0 then
    for i = 1, #steps do
      local stepData = self:parseStaticDataByStepData(steps[i])
      self.steps[#self.steps + 1] = stepData
    end
  end
  if rewards and #rewards > 0 then
    if self.rewards then
      self:ClearRewards()
    else
      self.rewards = ReusableTable.CreateArray()
    end
    for i = 1, #rewards do
      local single = rewards[i]
      local reward = ReusableTable.CreateTable()
      reward.id = single.id
      reward.count = single.count
      self.rewards[#self.rewards + 1] = reward
    end
  else
    self:DestroyRewards()
  end
  if steps and step >= #steps then
    step = #steps - 1
  end
  if not steps or not steps[step + 1] then
    local stepData
  end
  self:updateByIdAndStep(id, step, stepData)
end
function QuestData:updateProcess()
  if self.steps and self.step then
    local stepData = self.steps[self.step + 1]
    if stepData then
      self.process = stepData.process
    end
  end
end
function QuestData:setIfShowAppearAnm(bArg)
  self.ifShowAppearAnm = bArg
end
function QuestData:getIfShowAppearAnm()
  return self.ifShowAppearAnm
end
function QuestData:updateRaidData(id, RaidServerData)
  self.id = id
  local stepData = self:parseRaidStaticDataByStepData(RaidServerData)
  self.staticData = stepData.staticData
  if self.staticData == nil then
    helplog("error table_raid id:", id)
    return
  end
  if self.staticData ~= nil then
    self.params = self.staticData.Params
  end
  if self.params ~= nil then
    local vect = self.params.pos
    if vect ~= nil then
      if vect[1] and vect[2] and vect[3] then
        if not self.pos then
          self.pos = LuaVector3.zero
        end
        self.pos:Set(vect[1], vect[2], vect[3])
      else
        self.pos = VectorUtility.Destroy(self.pos)
        printRed("questData pox x or y or z is nil")
      end
    else
      self.pos = VectorUtility.Destroy(self.pos)
    end
  end
  if self.staticData.Map == 0 then
    self.staticData.Map = nil
  end
  self.map = self.staticData.Map
  self.questDataStepType = self.staticData.Content
  self.traceTitle = self.staticData.Name
  self.whetherTrace = self.staticData.WhetherTrace
  self.traceInfo = self.staticData.TraceInfo
end
function QuestData:updateByIdAndStep(id, step, stepDataServer)
  self.id = id
  self.step = step
  local stepData = self:parseStaticDataByStepData(stepDataServer)
  if not stepData or not stepData.staticData then
    return
  end
  local delData = self.steps[step + 1]
  if delData then
    ReusableTable.DestroyAndClearTable(delData.staticData)
    delData.staticData = nil
    ReusableTable.DestroyAndClearTable(delData)
    self.steps[step + 1] = nil
    self.staticData = nil
  end
  self.steps[step + 1] = stepData
  if self.names then
    ArrayClear(self.names)
  end
  transArray(stepDataServer.names)
  local names = stepDataServer.names
  if names and #names > 0 then
    for i = 1, #names do
      local single = names[i]
      self.names[#self.names + 1] = single
    end
  end
  if self.serverParams then
    ArrayClear(self.serverParams)
  end
  local params = stepDataServer.params
  if params and #params > 0 then
    for i = 1, #params do
      local single = params[i]
      self.serverParams[#self.serverParams + 1] = single
    end
  end
  if self.allrewardid then
    ArrayClear(self.allrewardid)
  end
  local allrewardid = stepDataServer.config.allrewardid
  if allrewardid and #allrewardid > 0 then
    for i = 1, #allrewardid do
      local single = allrewardid[i]
      self.allrewardid[#self.allrewardid + 1] = single
    end
  end
  if self.preQuest then
    ArrayClear(self.preQuest)
  end
  local preQuests = stepDataServer.config.PreQuest
  if preQuests and #preQuests > 0 then
    for i = 1, #preQuests do
      local single = preQuests[i]
      self.preQuest[#self.preQuest + 1] = single
    end
  end
  if self.mustPreQuest then
    ArrayClear(self.mustPreQuest)
  end
  local mustPreQuests = stepDataServer.config.MustPreQuest
  if mustPreQuests and #mustPreQuests > 0 then
    for i = 1, #mustPreQuests do
      local single = mustPreQuests[i]
      self.mustPreQuest[#self.mustPreQuest + 1] = single
    end
  end
  self.orderId = id
  if self.scope == QuestDataScopeType.QuestDataScopeType_FUBEN then
    return
  else
    self.staticData = stepData.staticData
    self.type = self.staticData.Type
    if self.type == QuestDataType.QuestDataType_WANTED then
      self.wantedData = Table_WantedQuest[id]
    else
      self.wantedData = nil
    end
  end
  self.params = self.staticData.Params
  if self.params ~= nil then
    local vect = self.params.pos
    if vect ~= nil then
      if vect[1] and vect[2] and vect[3] then
        if not self.pos then
          self.pos = LuaVector3.zero
        end
        self.pos:Set(vect[1], vect[2], vect[3])
      else
        self.pos = VectorUtility.Destroy(self.pos)
      end
    else
      self.pos = VectorUtility.Destroy(self.pos)
    end
  end
  if self.staticData.Map == 0 then
    self.staticData.Map = nil
  end
  self.map = self.staticData.Map
  self.questDataStepType = self.staticData.Content
  self.traceTitle = self.staticData.Name
  self.whetherTrace = self.staticData.WhetherTrace
  self.traceInfo = self.staticData.TraceInfo
  self:updateProcess()
  self:processParams()
end
function QuestData:processParams()
  if self.questDataStepType == QuestDataStepType.QuestDataStepType_TALK and self.staticData.Params.method == "1" and #self.serverParams > 0 and self.staticData.Params.dialog then
    TableUtility.ArrayClear(self.staticData.Params.dialog)
    for i = 2, #self.serverParams do
      local single = self.serverParams[i]
      self.staticData.Params.dialog[#self.staticData.Params.dialog + 1] = single
    end
  else
  end
end
function QuestData:parseRaidStaticDataByStepData(RaidPConfig)
  if not RaidPConfig then
    return
  end
  local staticData = ReusableTable.CreateTable()
  staticData.RaidID = RaidPConfig.RaidID
  staticData.starID = RaidPConfig.starID
  staticData.Auto = RaidPConfig.Auto
  staticData.DescInfo = RaidPConfig.DescInfo
  staticData.Content = RaidPConfig.Content
  staticData.TraceInfo = RaidPConfig.TraceInfo
  staticData.WhetherTrace = RaidPConfig.WhetherTrace
  staticData.Params = QuestDataUtil.parseParams(RaidPConfig.params.params, staticData.Content)
  local stepData = ReusableTable.CreateTable()
  stepData.staticData = staticData
  stepData.process = stepData.process
  stepData.EndTime = stepData.EndTime or 0
  return stepData
end
function QuestData:parseStaticDataByStepData(stepDataServer)
  if not stepDataServer then
    return
  end
  local config = stepDataServer.config
  local staticData = ReusableTable.CreateTable()
  staticData.RewardGroup = config.RewardGroup
  staticData.SubGroup = config.SubGroup
  staticData.FinishJump = config.FinishJump
  staticData.FailJump = config.FailJump
  staticData.Map = config.Map
  staticData.WhetherTrace = config.WhetherTrace
  staticData.Auto = config.Auto
  staticData.FirstClass = config.FirstClass
  staticData.Class = config.Class
  staticData.Type = config.Type
  staticData.QuestName = config.QuestName
  staticData.Name = config.Name
  staticData.Content = config.Content
  staticData.TraceInfo = config.TraceInfo
  staticData.Level = config.Level
  staticData.Prefixion = config.Prefixion
  staticData.PreNoShow = config.PreNoShow
  staticData.Risklevel = config.Risklevel
  staticData.Joblevel = config.Joblevel
  staticData.CookerLv = config.CookerLv
  staticData.TasterLv = config.TasterLv
  staticData.EndTime = config.EndTime or 0
  staticData.IconFromServer = config.Icon
  staticData.ColorFromServer = config.Color
  staticData.Params = QuestDataUtil.parseParams(config.params.params, staticData.Content)
  local stepData = ReusableTable.CreateTable()
  stepData.staticData = staticData
  stepData.process = stepDataServer.process
  return stepData
end
function QuestData:setQuestListType(questListType)
  self.questListType = questListType
end
function QuestData:cloneSelf()
  local data = QuestData.new()
  data.scope = self.scope
  data.questListType = self.questListType
  data.questDataStepType = self.questDataStepType
  data.traceTitle = self.traceTitle
  data.whetherTrace = self.whetherTrace
  data.traceInfo = self.traceInfo
  data.pos = self.pos and self.pos:Clone() or nil
  data.map = self.map
  data.type = self.type
  data.orderId = self.orderId
  data.params = self.params
  data.id = self.id
  data.names = self.names
  data.step = self.step
  data.ifShowAppearAnm = self.ifShowAppearAnm
  data.time = self.time
  data.complete = self.complete
  data.trace = self.trace
  data.detailid = self.detailid
  data.rewards = self.rewards
  data.steps = self.steps
  data.acceptlv = self.acceptlv
  data.finishcount = self.finishcount
  data.scope = self.scope
  data.process = self.process
  data.staticData = self.staticData
  return data
end
function QuestData:getQuestListType()
  return self.questListType
end
function QuestData:checkWantedQuestStep()
  if self.type == QuestDataType.QuestDataType_WANTED then
    local params = self.params and self.params or {}
    local isComplete = params.mark_team_wanted == 1
    if isComplete then
      return true
    end
  end
end
function QuestData:parseTranceInfo(step)
  self.traceInfo = OverSea.LangManager.Instance():GetLangByKey(self.traceInfo)
  local tableValue = QuestDataUtil.getTranceInfoTable(self, self.params, nil)
  if tableValue == nil then
    return "parse table text is nil:" .. self.traceInfo
  end
  local result = self.traceInfo and string.gsub(self.traceInfo, "%[(%w+)]", tableValue) or ""
  if self:checkWantedQuestStep() then
    local currentComple = ShareAnnounceQuestProxy.Instance:getCurrentCompleteMember(self.id)
    local totalCount = ShareAnnounceQuestProxy.Instance:getTotalCountMenber(self.id)
    if totalCount > 0 then
      local process = currentComple .. "/" .. totalCount
      result = string.format(ZhString.MainViewAddTrace_HelpTeamTraceInfo, result, process)
    end
  end
  local index = 1
  result = string.gsub(result, "%[(%w+)]", function(str)
    local value = self.names[index]
    index = index + 1
    return value
  end)
  if self.type == QuestDataType.QuestDataType_GUILDQUEST and self.time then
    local deltaTime = self.time - ServerTime.CurServerTime() / 1000
    if deltaTime >= 0 and deltaTime <= 3600 then
      result = string.format(ZhString.TaskQuestCell_GuildTimeOut, result, math.floor(deltaTime / 60))
    end
  end
  if QuestProxy.Instance:isCountDownQuest(self) then
    local deltaTime = self.staticData.EndTime - ServerTime.CurServerTime() / 1000
    if deltaTime >= 0 and deltaTime <= 3600 then
      result = string.format(ZhString.TaskQuestCell_GuildTimeOut, result, math.floor(deltaTime / 60))
    end
  end
  return result
end
local tRet = {}
function QuestData:getProcessInfo()
  TableUtility.TableClear(tRet)
  local questType = self.questDataStepType
  if questType == QuestDataStepType.QuestDataStepType_KILL then
    local process = self.process
    local id = self.params.monster
    local groupId = self.params.groupId
    local totalNum = self.params.num
    local infoTable = Table_Monster[id]
    if infoTable == nil then
      infoTable = Table_Npc[id]
    end
    tRet.process = process
    tRet.totalNum = totalNum
    if infoTable ~= nil then
      tRet.name = infoTable.NameZh
    else
      if groupId then
      else
      end
    end
    return tRet
  elseif questType == QuestDataStepType.QuestDataStepType_COLLECT then
    local id = self.params.monster
    local process = self.process
    local totalNum = self.params.num
    local infoTable = Table_Monster[id]
    if infoTable == nil then
      infoTable = Table_Npc[id]
    end
    tRet.process = process
    tRet.totalNum = totalNum
    if infoTable ~= nil then
      tRet.name = infoTable.NameZh
    else
    end
    return tRet
  elseif questType == QuestDataStepType.QuestDataStepType_GATHER then
    local process = self.process
    local rewards = ItemUtil.GetRewardItemIdsByTeamId(self.params.reward)
    if not rewards or not rewards[1] then
      errorLog("questId:" .. self.id .. "rewardId:" .. (self.params.reward or 0) .. " \232\175\165\229\165\150\229\138\177\228\187\187\229\138\161\228\184\141\229\173\152\229\156\168\230\173\164\229\165\150\229\138\177")
      return nil
    end
    local itemId = rewards[1].id
    local totalNum = self.params.num
    local infoTable = Table_Item[tonumber(itemId)]
    tRet.process = process
    tRet.totalNum = totalNum
    if infoTable ~= nil then
      tRet.name = infoTable.NameZh
    else
    end
    return tRet
  elseif questType == QuestDataStepType.QuestDataStepType_ITEM then
    local item = self.params.item and self.params.item[1]
    local itemId = item and item.id or 0
    local totalNum = item and item.num or 0
    local process = BagProxy.Instance:GetItemNumByStaticID(itemId) or 0
    local infoTable = Table_Item[tonumber(itemId)]
    tRet.process = process
    tRet.totalNum = totalNum
    if infoTable ~= nil then
      tRet.name = infoTable.NameZh
    else
    end
    return tRet
  end
end
