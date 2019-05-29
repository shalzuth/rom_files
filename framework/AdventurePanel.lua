AdventurePanel = class("AdventurePanel", ContainerView)
AdventurePanel.ViewType = UIViewType.NormalLayer
autoImport("AdventureCategoryCell")
autoImport("AdventureHomePage")
autoImport("AdventureResearchPage")
autoImport("AdventureItemNormalListPage")
autoImport("BeautifulAreaPhotoNetIngManager")
autoImport("AdventureAchievementPage")
autoImport("AdventureFoodPage")
autoImport("AdventureNpcListPage")
AdventurePanel.Category = GameConfig.AdventureCategoryConfig
function AdventurePanel:GetShowHideMode()
  return PanelShowHideMode.MoveOutAndMoveIn
end
function AdventurePanel:Init()
  self:initView()
end
function AdventurePanel:OnEnter()
  self.super.OnEnter(self)
  self:initData()
  BeautifulAreaPhotoNetIngManager.Ins():OnSwitchOn()
  self:RegistRedTip()
  self:resetCategory()
  self.bgTex = self:FindComponent("bgTexture", UITexture)
  self.bgTexName = "bg_view_1"
  if self.bgTex then
    PictureManager.Instance:SetUI(self.bgTexName, self.bgTex)
    PictureManager.ReFitFullScreen(self.bgTex, 1)
    LogUtility.Info("Picture of bgTex has been set and refitted")
  end
end
function AdventurePanel:RegistRedTip()
  if self.redData then
    for i = 1, #self.redData do
      local single = self.redData[i]
      self:RegisterRedTipCheck(single.id, single.obj, nil, single.offset)
    end
  end
end
function AdventurePanel:OnExit()
  self.super.OnExit(self)
  BeautifulAreaPhotoNetIngManager.Ins():OnSwitchOff()
  self.currentKey = nil
  if self.bgTex then
    PictureManager.Instance:UnLoadUI(self.bgTexName, self.bgTex)
    LogUtility.Info("Picture of bgTex has been unloaded")
  end
end
function AdventurePanel:handleRegistRedTip(data)
  if data then
  end
end
function AdventurePanel:initView()
  self.adventureHomePage = self:AddSubView("AdventureHomePage", AdventureHomePage)
  self.itemListPage = self:AddSubView("SceneryNormalListPage", AdventureItemNormalListPage)
  self.researchPage = self:AddSubView("AdventureResearchPage", AdventureResearchPage)
  self.achievePage = self:AddSubView("AdventureAchievementPage", AdventureAchievementPage)
  self.adventureFoodPage = self:AddSubView("AdventureFoodPage", AdventureFoodPage)
  self.npcListPage = self:AddSubView("AdventureNpcListPage", AdventureNpcListPage)
  local CategoryListTable = self:FindGO("categoryList"):GetComponent(UIGrid)
  self.categoryList = UIGridListCtrl.new(CategoryListTable, AdventureCategoryCell, "AdventureCategoryCell")
  self.categorSv = self:FindComponent("ScrollView", UIScrollView, self:FindGO("toggles"))
end
function AdventurePanel:initData()
  local list = {}
  for k, v in pairs(AdventureDataProxy.Instance.categoryDatas) do
    local menuId = v.staticData.MenuID
    if v.staticData.Position and v.staticData.Position > 1 and (menuId and FunctionUnLockFunc.Me():CheckCanOpen(menuId) or not menuId) then
      table.insert(list, v)
    end
  end
  table.sort(list, function(l, r)
    return l.staticData.Order < r.staticData.Order
  end)
  self.categoryList:ResetDatas(list)
  local cells = self.categoryList:GetCells()
  self.redData = {}
  for i = 1, #cells do
    local singleCell = cells[i]
    self:AddTabChangeEvent(singleCell.gameObject, nil, singleCell)
    local redTipIds = AdventureDataProxy.Instance:getRidTipsByCategoryId(singleCell.data.staticData.id)
    for j = 1, #redTipIds do
      local single = redTipIds[j]
      local data = {}
      data.id = single
      data.obj = singleCell.icon
      data.offset = {-5, -5}
      table.insert(self.redData, data)
    end
  end
end
function AdventurePanel:resetCategory()
  local cells = self.categoryList:GetCells()
  if cells and #cells > 0 then
    if self.viewdata.viewdata.achieveData then
      for i = 1, #cells do
        if cells[i].data.staticData.id == SceneManual_pb.EMANUALTYPE_ACHIEVE then
          self:TabChangeHandler(cells[i])
          break
        end
      end
    else
      self:TabChangeHandler(cells[1])
    end
  end
  self:adjustItemPos()
end
function AdventurePanel:TabChangeHandler(cell)
  if self.currentKey ~= cell then
    AdventurePanel.super.TabChangeHandler(self, cell)
    self:handleCategoryClick(cell)
    self.currentKey = cell
  end
end
function AdventurePanel:addListEventListener()
end
function AdventurePanel:handleCategorySelect(data)
  if data.staticData.id == SceneManual_pb.EMANUALTYPE_HOMEPAGE then
    self.adventureHomePage:Show()
    self.adventureFoodPage:Hide()
    self.itemListPage:Hide()
    self.researchPage:Hide()
    self.achievePage:Hide()
    self.npcListPage:Hide()
  elseif data.staticData.id == SceneManual_pb.EMANUALTYPE_ACHIEVE then
    self.researchPage:Hide()
    self.adventureFoodPage:Hide()
    self.adventureHomePage:Hide()
    self.itemListPage:Hide()
    self.npcListPage:Hide()
    self.achievePage:ShowSelf(self.viewdata.viewdata.achieveData)
    self.viewdata.viewdata.achieveData = nil
  elseif data.staticData.id == SceneManual_pb.EMANUALTYPE_RESEARCH then
    self.adventureFoodPage:Hide()
    self.researchPage:ShowSelf()
    self.adventureHomePage:Hide()
    self.itemListPage:Hide()
    self.achievePage:Hide()
    self.npcListPage:Hide()
  elseif data.staticData.id == 18 then
    self.adventureFoodPage:ShowSelf()
    self.adventureHomePage:Hide()
    self.itemListPage:Hide()
    self.achievePage:Hide()
    self.researchPage:Hide()
    self.npcListPage:Hide()
  elseif data.staticData.id == SceneManual_pb.EMANUALTYPE_NPC or data.staticData.id == SceneManual_pb.EMANUALTYPE_MONSTER then
    self.adventureFoodPage:Hide()
    self.adventureHomePage:Hide()
    self.itemListPage:Hide()
    self.achievePage:Hide()
    self.researchPage:Hide()
    self.npcListPage:Show()
    self.npcListPage:setCategoryData(data)
  else
    self.adventureFoodPage:Hide()
    self.itemListPage:Show()
    self.researchPage:Hide()
    self.itemListPage:setCategoryData(data)
    self.adventureHomePage:Hide()
    self.achievePage:Hide()
    self.npcListPage:Hide()
  end
end
function AdventurePanel:handleCategoryClick(child)
  self:handleCategorySelect(child.data)
  local cells = self.categoryList:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single == child then
      single:setIsSelected(true)
    else
      single:setIsSelected(false)
    end
  end
end
function AdventurePanel:adjustItemPos()
  self.categorSv:ResetPosition()
end
function AdventurePanel.OpenAchievePageById(achieveId)
  local type = AdventureAchieveProxy.Instance:getTopCategoryIdByAchiveId(achieveId)
  if type then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AdventurePanel,
      viewdata = {
        achieveData = {type = type, id = achieveId}
      }
    })
  else
    helplog("can't find type:", achieveId)
  end
end
function AdventurePanel.OpenAchievePage(type, achieveId)
  if Table_Achievement[type] and Table_Achievement[achieveId] then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AdventurePanel,
      viewdata = {
        achieveData = {type = type, id = achieveId}
      }
    })
  end
end
