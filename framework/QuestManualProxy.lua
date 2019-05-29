QuestManualProxy = class("QuestManualProxy", pm.Proxy)
QuestManualProxy.Instance = nil
QuestManualProxy.NAME = "QuestManualProxy"
function QuestManualProxy:ctor(proxyName, data)
  self.proxyName = proxyName or QuestManualProxy.NAME
  if QuestManualProxy.Instance == nil then
    QuestManualProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end
function QuestManualProxy:InitProxy()
  self.manualDataVersionMap = {}
  self.lastVersion = 1
  self.lastTab = 1
end
function QuestManualProxy:InitProxyData()
  TableUtility.TableClear(self.manualDataVersionMap)
end
function QuestManualProxy:GetManualQuestDatas(version)
  self.recentVersion = version
  return self.manualDataVersionMap[version]
end
function QuestManualProxy:GetQuestNameById(questId)
  local questName = ""
  if self.recentVersion then
    local versionData = self.manualDataVersionMap[self.recentVersion]
    if versionData then
      questName = versionData.prequest[questId]
    end
  end
  return questName
end
function QuestManualProxy:HandleRecvQueryManualQuestCmd(data)
  local version = data.version
  local manual = data.manual
  if manual then
    local oldData = self.manualDataVersionMap[version]
    if not oldData then
      manualData = ManualData.new(manual)
      self.manualDataVersionMap[version] = manualData
    end
  end
end
function QuestManualProxy:OpenPuzzle(version, index)
  local versionData = self.manualDataVersionMap[version]
  if versionData then
    local openPuzzles = versionData.main.puzzle.open_puzzles
    openPuzzles[#openPuzzles + 1] = index
    local curentPuzzleCount = #openPuzzles
    local colectAwardList = self:GetQuestPuzzleCollectListByVersion(version)
    local unlockPuzzles = versionData.main.puzzle.unlock_puzzles
    for i = 1, #colectAwardList do
      if curentPuzzleCount == colectAwardList[i].indexss then
        unlockPuzzles[#unlockPuzzles + 1] = curentPuzzleCount
      end
    end
  end
end
function QuestManualProxy:CheckPuzzleAwardLock(version, index)
  local versionData = self.manualDataVersionMap[version]
  if versionData then
    local unlockPuzzles = versionData.main.puzzle.unlock_puzzles
    for i = 1, #unlockPuzzles do
      if unlockPuzzles[i] == index then
        return false
      end
    end
  end
  return true
end
function QuestManualProxy:GetQuestPuzzleCollectListByVersion(version)
  local puzzleList = {}
  for k, v in pairs(Table_QuestPuzzle) do
    if v.version == version and v.type == "collect" then
      puzzleList[#puzzleList + 1] = v
    end
  end
  return puzzleList
end
ManualData = class("ManualData")
function ManualData:ctor(data)
  self:updata(data)
end
function ManualData:updata(data)
  self.prequest = {}
  if data.prequest and #data.prequest > 0 then
    for i = 1, #data.prequest do
      local quest = data.prequest[i]
      self.prequest[quest.id] = quest.name
    end
  end
  if data.main then
    self.main = {}
    self.main.questList = {}
    local mainItems = data.main.items
    if mainItems and #mainItems > 0 then
      for i = 1, #mainItems do
        self.main.questList[#self.main.questList + 1] = QuestManualItem.new(mainItems[i], self.prequest)
      end
    end
    if data.main.puzzle then
      self.main.puzzle = QuestPuzzle.new(data.main.puzzle)
    end
    self.main.mainstoryid = data.main.mainstoryid
    if data.main.previews then
      self.main.questPreviewList = {}
      local previewItems = data.main.previews
      if previewItems and #previewItems > 0 then
        for i = 1, #previewItems do
          self.main.questPreviewList[#self.main.questPreviewList + 1] = QuestPreviewItem.new(previewItems[i])
        end
        table.sort(self.main.questPreviewList, function(l, r)
          if l and r and l.index and r.index then
            return l.index < r.index
          else
            return false
          end
        end)
      end
    end
  end
  if data.branch then
    self.branch = {}
    local questShops = data.branch.shops
    for i = 1, #questShops do
      self.branch[#self.branch + 1] = BranchQuestManualItem.new(questShops[i], self.prequest)
    end
  end
  if data.story and data.story.previews then
    self.storyQuestList = {}
    local storyItems = data.story.previews
    if storyItems and #storyItems > 0 then
      for i = 1, #storyItems do
        self.storyQuestList[#self.storyQuestList + 1] = QuestPreviewItem.new(storyItems[i])
      end
    end
    self.poemCompleteList = {}
    local completelist = data.story.submit_ids
    local len = #completelist
    local k = 0
    for i = 1, len do
      k = completelist[i]
      self.poemCompleteList[k] = k
    end
  end
end
QuestManualItem = class("QuestManualItem")
function QuestManualItem:ctor(data, questNames)
  self:updata(data, questNames)
end
function QuestManualItem:updata(data, questNames)
  self.type = data.type
  if data.data then
    local questData = QuestData.new()
    questData:DoConstruct(false, QuestDataScopeType.QuestDataScopeType_CITY)
    questData:setQuestData(data.data)
    questData:setQuestListType(data.type)
    self.questData = questData
    if questNames then
      self.questPreName = questNames[data.data.id]
    end
  end
  local questSubs = data.subs
  if questSubs and #questSubs > 0 then
    self.questSubs = {}
    for i = 1, #questSubs do
      self.questSubs[#self.questSubs + 1] = QuestManualItem.new(questSubs[i], questNames)
    end
  end
end
QuestPuzzle = class("QuestPuzzle")
function QuestPuzzle:ctor(data)
  self:updata(data)
end
function QuestPuzzle:updata(data)
  self.version = data.version
  self.open_puzzles = {}
  local openedPuzzles = data.open_puzzles
  if openedPuzzles and #openedPuzzles > 0 then
    for i = 1, #openedPuzzles do
      self.open_puzzles[#self.open_puzzles + 1] = openedPuzzles[i]
    end
  end
  self.unlock_puzzles = {}
  local unlockPuzzles = data.unlock_puzzles
  if unlockPuzzles and #unlockPuzzles > 0 then
    for i = 1, #unlockPuzzles do
      self.unlock_puzzles[#self.unlock_puzzles + 1] = unlockPuzzles[i]
    end
  end
end
BranchQuestManualItem = class("BranchQuestManualItem")
function BranchQuestManualItem:ctor(data, prequest)
  self:updata(data, prequest)
end
function BranchQuestManualItem:updata(data, prequest)
  self.itemid = data.itemid
  local questList = data.quests
  if questList and #questList > 0 then
    self.questList = {}
    for i = 1, #questList do
      self.questList[#self.questList + 1] = QuestManualItem.new(questList[i], prequest)
    end
  end
end
QuestPreviewItem = class("QuestPreviewItem")
function QuestPreviewItem:ctor(data)
  self:updata(data)
end
function QuestPreviewItem:updata(data)
  self.questid = data.questid
  self.name = data.name
  self.complete = data.complete
  self.RewardGroup = data.RewardGroup
  local rewardIds = data.allrewardid
  self.allrewardid = {}
  if rewardIds and #rewardIds > 0 then
    for i = 1, #rewardIds do
      self.allrewardid[#self.allrewardid + 1] = rewardIds[i]
    end
  end
  self.index = data.index or 0
end
