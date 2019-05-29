PoemStoryPage = class("PoemStoryPage", SubView)
autoImport("PoemQuestListCell")
autoImport("PoemAwardCell")
autoImport("PoemstoryLockCell")
local reusableArray = {}
local questInstance = QuestProxy.Instance
local Offset = 50
local tempVector3 = LuaVector3.zero
function PoemStoryPage:Init()
  self:initView()
  self:addViewEventListener()
  self:AddListenerEvts()
  self:initData()
end
function PoemStoryPage:initView()
  self.gameObject = self:FindGO("PoemStoryPage")
  self.questDescription = self:FindComponent("QuestDescription", UILabel)
  self.storyName = self:FindComponent("StoryName", UILabel)
  self.storyListGrid = self:FindGO("storyListGrid")
  self.storylistSV = self:FindGO("ScrollView_StoryList"):GetComponent(UIScrollView)
  self.uiGridOfStoryList = self.storyListGrid:GetComponent(UIGrid)
  if self.listControllerOfStoryList == nil then
    self.listControllerOfStoryList = UIGridListCtrl.new(self.uiGridOfStoryList, PoemQuestListCell, "PoemQuestListCell")
  end
  self.poemAward = self:FindGO("PoemAward")
  self.poemAwardGrid = self:FindGO("poemAwardGrid")
  self.uiGridOfPoemAward = self.poemAwardGrid:GetComponent(UIGrid)
  if self.listControllerOfPoemAward == nil then
    self.listControllerOfPoemAward = UIGridListCtrl.new(self.uiGridOfPoemAward, PoemAwardCell, "PoemAwardCell")
  end
  self.modeltexture = self:FindComponent("ModelTexture", UITexture)
  self.nPCName = self:FindComponent("NPCName", UILabel)
  self.progressScrollView = self:FindGO("ProgressScrollView")
  self.scrollview = self:FindComponent("ScrollView", UIScrollView)
  self.table = self:FindComponent("Table", UITable)
  self.poemAwardScrollView = self:FindComponent("PoemAwardScrollView", UIScrollView)
  self.panel = self:FindGO("panel")
  self.noData = self:FindGO("NoData")
  self.locklistGrid = self:FindGO("LockList"):GetComponent(UIGrid)
  self.locklistCtr = UIGridListCtrl.new(self.locklistGrid, PoemstoryLockCell, "PoemstoryLockCell")
  self.locktip = self:FindGO("LockTip")
  self.bgtexture = self:FindGO("BGTexture"):GetComponent(UITexture)
end
function PoemStoryPage:Show(target)
  PoemStoryPage.super.Show(self, target)
  PictureManager.Instance:SetPuzzleBG("taskmanual_bg_bottom4_new", self.bgtexture)
end
function BranchQuestPage:Hide(target)
  BranchQuestPage.super.Hide(self, target)
end
function PoemStoryPage:initData()
end
function PoemStoryPage:SetData(version)
  self.currentVersion = version
  local manualQuestDatas = QuestManualProxy.Instance:GetManualQuestDatas(version)
  poemStorys = manualQuestDatas.storyQuestList
  if poemStorys and #poemStorys > 1 then
    self.panel:SetActive(true)
    self.noData:SetActive(false)
    self.listControllerOfStoryList:ResetDatas(poemStorys)
    self.storylistSV:ResetPosition()
    self.currentSelectedCell = nil
    local cells = self.listControllerOfStoryList:GetCells()
    local firstCell = cells[1]
    if firstCell then
      self:UpdatePoemDetails(firstCell)
    end
  else
    self.panel:SetActive(false)
    self.noData:SetActive(true)
  end
end
function PoemStoryPage:OnEnter()
end
function PoemStoryPage:OnExit()
end
function PoemStoryPage:addViewEventListener()
end
function PoemStoryPage:AddListenerEvts()
  self.listControllerOfStoryList:AddEventListener(QuestManualEvent.PoemClick, self.UpdatePoemDetails, self)
end
function PoemStoryPage:UpdatePoemDetails(cell)
  if self.currentSelectedCell then
    if self.currentSelectedCell == cell then
      return
    else
      self.currentSelectedCell:setIsSelected(false)
    end
  end
  self.currentSelectedCell = cell
  self.currentSelectedCell:setIsSelected(true)
  local poemData = Table_PomeStory[self.currentSelectedCell.data.questid]
  if poemData then
    self.storyName.text = poemData.QuestName
    self.questDescription.text = ZhString.QuestManual_TwoSpace
    tempVector3:Set(0, poemData.NpcSpace or 0, 0)
    self.modeltexture.gameObject.transform.localPosition = tempVector3
    local poemDialogList = {}
    local poemDialogLockList = {}
    local currentStep = 0
    local currentManual = QuestManualProxy.Instance:GetManualQuestDatas(self.currentVersion)
    local showlist = self:CheckList(poemData, currentManual)
    poemDialogLockList, poemDialogList = self:CheckStep(showlist, currentManual)
    local count = #poemDialogList
    for i = 1, count do
      local dialogData = DialogUtil.GetDialogData(poemDialogList[i])
      if dialogData then
        self.questDescription.text = self.questDescription.text .. dialogData.Text .. "\n\227\128\128\227\128\128"
      end
      if i == count then
        function self.questDescription.onChange()
          self.table:Reposition()
        end
      end
    end
    self.progressScrollView:SetActive(#poemDialogList ~= 0)
    self.locktip:SetActive(#poemDialogLockList ~= 0 and #poemDialogList ~= 0)
    self.scrollview:ResetPosition()
    local datalist = {}
    for i = 1, #poemDialogLockList do
      local single = {}
      local ps = Table_PoemStep[poemDialogLockList[i]]
      single.name = ps.name
      single.QuestName = ps.TraceInfo
      datalist[#datalist + 1] = single
    end
    self.locklistCtr:ResetDatas(datalist)
    self:Show3DModel(poemData.Npcid)
    self.table:Reposition()
    self.scrollview:ResetPosition()
  end
  if cell.data.complete then
    self.poemAward:SetActive(false)
    self:ResizeScrollview(true)
  else
    self.poemAward:SetActive(true)
    self:ResizeScrollview(false)
    TableUtility.ArrayClear(reusableArray)
    local rewardIds = self.currentSelectedCell.data.allrewardid
    if rewardIds and #rewardIds > 0 then
      for i = 1, #rewardIds do
        local rewardId = rewardIds[i]
        local rewards = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
        if rewards and #rewards > 0 then
          for i = 1, #rewards do
            table.insert(reusableArray, rewards[i])
          end
        end
      end
    end
    self.listControllerOfPoemAward:ResetDatas(reusableArray)
    self.poemAwardScrollView:ResetPosition()
  end
end
function PoemStoryPage:Show3DModel(npcid)
  local sdata = Table_Npc[npcid]
  if sdata then
    local otherScale = 1
    otherScale = not sdata.Shape or GameConfig.UIModelScale[sdata.Shape] or 1
    do break end
    if sdata.Scale then
      otherScale = sdata.Scale
    end
    self.nPCName.text = sdata.NameZh
    self.nPCName.gameObject:SetActive(sdata.ShowName == 2)
    self.model = UIModelUtil.Instance:SetNpcModelTexture(self.modeltexture, sdata.id)
    UIModelUtil.Instance:SetCellTransparent(self.modeltexture)
    local showPos = sdata.LoadShowPose
    if showPos and #showPos == 3 then
      tempVector3:Set(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
      self.model:SetPosition(tempVector3)
    end
    if sdata.LoadShowRotate then
      self.model:SetEulerAngleY(sdata.LoadShowRotate)
    end
    if sdata.LoadShowSize then
      otherScale = sdata.LoadShowSize
    end
    self.model:SetScale(otherScale)
  end
end
function PoemStoryPage:CheckList(poemData, currentManualdata)
  if #poemData.ShowList ~= 0 then
    return poemData.ShowList
  else
    return poemData.Option1
  end
  if poemData.NoMustQuestID and poemData.NoMustQuestID[2] then
    local op2 = poemData.NoMustQuestID[2]
    for k, v in pairs(op2) do
      if currentManualdata.poemCompleteList[v] then
        return poemData.Option2
      end
      if questInstance:getQuestDataByIdAndType(v) then
        return poemData.Option2
      end
    end
  end
end
function PoemStoryPage:CheckStep(checklist, currentManualdata)
  local locklist = {}
  local dialoglist = {}
  for i = 1, #checklist do
    local stepData = Table_PoemStep[checklist[i]]
    local flag = true
    if currentManualdata.poemCompleteList[stepData.Questid] then
      flag = false
    end
    local questdata = questInstance:getQuestDataByIdAndType(stepData.Questid)
    if questdata and questdata.step > stepData.step then
      flag = false
    end
    if stepData.SubQuestid and stepData.SubStep then
      flag = true
      if currentManualdata.poemCompleteList[stepData.SubQuestid] then
        flag = false
      end
      local subQuestdata = questInstance:getQuestDataByIdAndType(stepData.SubQuestid)
      if subQuestdata and subQuestdata.step > stepData.SubStep then
        flag = false
      end
    end
    if flag then
      locklist[#locklist + 1] = checklist[i]
    else
      for i = 1, #stepData.Descrip do
        dialoglist[#dialoglist + 1] = stepData.Descrip[i]
      end
    end
  end
  return locklist, dialoglist
end
function PoemStoryPage:ResizeScrollview(isExtended)
  if self.scrollview.panel then
    if isExtended then
      self.scrollview.panel.baseClipRegion = Vector4(0, -50, 414, 358 + Offset * 2)
    else
      self.scrollview.panel.baseClipRegion = Vector4(0, 0, 414, 358)
    end
  end
end
