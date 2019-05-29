QuestManualView = class("QuestManualView", ContainerView)
QuestManualView.ViewType = UIViewType.NormalLayer
autoImport("MainQuestPage")
autoImport("BranchQuestPage")
autoImport("PoemStoryPage")
autoImport("QuestManualVersionCell")
QuestManualView.ColorTheme = {
  [1] = {
    color = LuaColor.New(1, 1, 1, 1)
  },
  [2] = {
    color = LuaColor.New(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
  },
  [3] = {
    color = LuaColor.New(0, 0, 0, 1)
  },
  [4] = {
    color = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
  },
  [5] = {
    color = LuaColor.New(0.2549019607843137, 0.34901960784313724, 0.6666666666666666, 1)
  }
}
QuestManualView.PuzzleBlockPicPos = {
  [1] = {
    pos = Vector3(31.2, -30.4, 0),
    plusPos = Vector3(-14, 13, 0),
    plusPicName = "taskmanual_add_01"
  },
  [2] = {
    pos = Vector3(-2, -48.4, 0),
    plusPos = Vector3(0, -12.7, 0),
    plusPicName = "taskmanual_add_02"
  },
  [3] = {
    pos = Vector3(-11, -23.2, 0),
    plusPos = Vector3(0, 24.22, 0),
    plusPicName = "taskmanual_add_03"
  },
  [4] = {
    pos = Vector3(-23.7, -37.1, 0),
    plusPos = Vector3(18.12, 8.5, 0),
    plusPicName = "taskmanual_add_04"
  },
  [5] = {
    pos = Vector3(18.23, -12.5, 0),
    plusPos = Vector3(-24, -2.76, 0),
    plusPicName = "taskmanual_add_05"
  },
  [6] = {
    pos = Vector3(-3.18, -7.4, 0),
    plusPos = Vector3(26.2, -7.4, 0),
    plusPicName = "taskmanual_add_06"
  },
  [7] = {
    pos = Vector3(-9.6, 5.2, 0),
    plusPos = Vector3(0, 8.2, 0),
    plusPicName = "taskmanual_add_07"
  },
  [8] = {
    pos = Vector3(-36.1, 0.2, 0),
    plusPos = Vector3(34.68, -7.6, 0),
    plusPicName = "taskmanual_add_08"
  },
  [9] = {
    pos = Vector3(32, 6.2, 0),
    plusPos = Vector3(-1.8, -12.53, 0),
    plusPicName = "taskmanual_add_09"
  },
  [10] = {
    pos = Vector3(0.24, 5.93, 0),
    plusPos = Vector3(0, 30.48, 0),
    plusPicName = "taskmanual_add_10"
  },
  [11] = {
    pos = Vector3(-10.58, 7.19, 0),
    plusPos = Vector3(-10.71, 3.42, 0),
    plusPicName = "taskmanual_add_11"
  },
  [12] = {
    pos = Vector3(-23.9, 13.1, 0),
    plusPos = Vector3(15.15, -6.36, 0),
    plusPicName = "taskmanual_add_12"
  },
  [13] = {
    pos = Vector3(18.82, 36.7, 0),
    plusPos = Vector3(-16.71, -13.59, 0),
    plusPicName = "taskmanual_add_13"
  },
  [14] = {
    pos = Vector3(6, 28.9, 0),
    plusPos = Vector3(-3, -24, 0),
    plusPicName = "taskmanual_add_14"
  },
  [15] = {
    pos = Vector3(-13.3, 43.2, 0),
    plusPos = Vector3(9, -4, 0),
    plusPicName = "taskmanual_add_15"
  },
  [16] = {
    pos = Vector3(-36.8, 23.6, 0),
    plusPos = Vector3(17, -18, 0),
    plusPicName = "taskmanual_add_16"
  }
}
reusableArray = {}
showArray = {}
function QuestManualView:Init()
  self:GetGameObjects()
  self:InitView()
  self:addViewEventListener()
  self:addListEventListener()
  self:InitData()
  if self.defaultQuestType then
    self:QuestTypeChangeHandler(self.defaultQuestType)
  end
  if self.defaultVersion then
    self:TabChangeHandler(self.defaultVersion)
  end
end
function QuestManualView:OnEnter()
end
function QuestManualView:OnExit()
  EventManager.Me():RemoveEventListener(QuestManualEvent.GoClick, self.OnGoClick, self)
  QuestManualProxy.Instance:InitProxyData()
end
function QuestManualView:InitData()
  self.listControllerOfVersions:ResetDatas(Table_QuestVersion)
  local cells = self.listControllerOfVersions:GetCells()
  for i = 1, #cells do
    local singleCell = cells[i]
    self:AddTabChangeEvent(singleCell.gameObject, nil, singleCell)
  end
  self.defaultVersion = cells[QuestManualProxy.Instance.lastVersion]
end
function QuestManualView:GetGameObjects()
  self.versionGrid = self:FindGO("versionGrid", self.gameObject)
  self.QuestTypeMaskList = {}
  for i = 1, 3 do
    do
      local btnName = "QuestType" .. i
      local questTypeGo = self:FindGO(btnName)
      self.QuestTypeMaskList[btnName] = self:FindGO("QuestTypeMask" .. i)
      self:AddButtonEvent(btnName, function()
        QuestManualProxy.Instance.lastTab = i
        self:QuestTypeChangeHandler(questTypeGo)
      end)
      break
    end
    break
  end
  local sname = "QuestType" .. QuestManualProxy.Instance.lastTab
  self.defaultQuestType = self:FindGO(sname)
end
function QuestManualView:InitView()
  self.uiGridOfVersions = self.versionGrid:GetComponent(UIGrid)
  if self.listControllerOfVersions == nil then
    self.listControllerOfVersions = UIGridListCtrl.new(self.uiGridOfVersions, QuestManualVersionCell, "QuestManualVersionCell")
  end
  self.mainQuestPage = self:AddSubView("MainQuestPage", MainQuestPage)
  self.branchQuestPage = self:AddSubView("BranchQuestPage", BranchQuestPage)
  self.poemStoryPage = self:AddSubView("PoemStoryPage", PoemStoryPage)
end
function QuestManualView:addViewEventListener()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
end
function QuestManualView:addListEventListener()
  self:AddListenEvt(ServiceEvent.QuestQueryManualQuestCmd, self.updateManualContent)
  EventManager.Me():AddEventListener(QuestManualEvent.GoClick, self.OnGoClick, self)
end
function QuestManualView:QuestTypeChangeHandler(go)
  if self.currentQuestType ~= go then
    if self.currentQuestType then
      self.QuestTypeMaskList[self.currentQuestType.name]:SetActive(false)
    end
    self.currentQuestType = go
    local typeName = go.name
    self.QuestTypeMaskList[typeName]:SetActive(true)
    self:LoadQuestTypeContent(typeName)
  end
end
function QuestManualView:LoadQuestTypeContent(typeName)
  if typeName == "QuestType1" then
    self.mainQuestPage:Show()
    self.branchQuestPage:Hide()
    self.poemStoryPage:Hide()
  elseif typeName == "QuestType2" then
    self.mainQuestPage:Hide()
    self.branchQuestPage:Show()
    self.poemStoryPage:Hide()
  elseif typeName == "QuestType3" then
    self.mainQuestPage:Hide()
    self.branchQuestPage:Hide()
    self.poemStoryPage:Show()
  end
  self:updateManualContent()
end
function QuestManualView:TabChangeHandler(cell)
  if self.currentVersionCell ~= cell then
    QuestManualView.super.TabChangeHandler(self, cell)
    self.currentVersionCell = cell
    self:handleCategoryClick(cell)
  end
end
function QuestManualView:handleCategoryClick(cell)
  self:handleCategorySelect(cell.data)
  local cells = self.listControllerOfVersions:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single == cell then
      single:setIsSelected(true)
      QuestManualProxy.Instance.lastVersion = i
    else
      single:setIsSelected(false)
    end
  end
end
function QuestManualView:handleCategorySelect(data)
  local versionData = QuestManualProxy.Instance:GetManualQuestDatas(data.version)
  if versionData then
    self:updateManualContent()
  else
    ServiceQuestProxy.Instance:CallQueryManualQuestCmd(data.version)
  end
end
function QuestManualView:updateManualContent()
  if self.currentVersionCell then
    local currentVersion = self.currentVersionCell.data.version
    local currentTypeName = self.currentQuestType.name
    if currentTypeName == "QuestType1" then
      self.mainQuestPage:SetData(currentVersion)
    elseif currentTypeName == "QuestType2" then
      self.branchQuestPage:SetData(currentVersion)
    elseif currentTypeName == "QuestType3" then
      self.poemStoryPage:SetData(currentVersion)
    end
  end
end
function QuestManualView:OnGoClick(cell)
  self:CloseSelf()
end
