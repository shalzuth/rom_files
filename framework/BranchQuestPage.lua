BranchQuestPage = class("BranchQuestPage", SubView)
autoImport("BranchAwardListCell")
autoImport("QuestTraceCell")
autoImport("BlankItemCell")
function BranchQuestPage:Init()
  self:initView()
  self:addViewEventListener()
  self:initData()
end
function BranchQuestPage:initView()
  self.gameObject = self:FindGO("BranchQuestPage")
  self.questListGrid = self:FindGO("questListGrid")
  self.uiGridOfQuestList = self.questListGrid:GetComponent(UIGrid)
  if self.listControllerOfQuestList == nil then
    self.listControllerOfQuestList = UIGridListCtrl.new(self.uiGridOfQuestList, QuestTraceCell, "QuestTraceLongCell")
  end
  self.awardListGrid = self:FindGO("awardListGrid")
  self.uiGridOfAwardList = self.awardListGrid:GetComponent(UIGrid)
  if self.listControllerOfAwardList == nil then
    self.listControllerOfAwardList = UIGridListCtrl.new(self.uiGridOfAwardList, BranchAwardListCell, "BranchAwardListCell")
  end
  self.awardBackListGrid = self:FindGO("awardBackListGrid")
  self.uiGridOfAwardBackList = self.awardBackListGrid:GetComponent(UIGrid)
  if self.listControllerOfAwardBackList == nil then
    self.listControllerOfAwardBackList = UIGridListCtrl.new(self.uiGridOfAwardBackList, BlankItemCell, "BlankItemCell")
  end
  self.modelStage = self:FindGO("ModelStage")
  self.itemmodel = self:FindGO("PlayerModelContainer")
  self.itemmodeltexture = self:FindComponent("ModelTexture", UITexture, self.itemmodel)
  self.scrollViewAwardList = self:FindComponent("ScrollView_AwardList", UIScrollView)
  self.modelStageProgress = self:FindComponent("ModelStageProgress", UISprite)
  self.modelStageProgressLabel = self:FindComponent("ModelStageProgressLabel", UILabel)
  self.modelStageName = self:FindComponent("ModelStageName", UILabel)
  self.back = self:FindGO("Back", self.modelStage)
  self.panel = self:FindGO("panel")
  self.noData = self:FindGO("NoData")
  self.bgtexture = self:FindGO("BGTexture"):GetComponent(UITexture)
  local modelBg = self:FindGO("ModelBg")
  self:AddDragEvent(modelBg, function(go, delta)
    if self.model then
      self.model:RotateDelta(-delta.x)
    else
    end
  end)
end
function BranchQuestPage:Show(target)
  BranchQuestPage.super.Show(self, target)
end
function BranchQuestPage:Hide(target)
  BranchQuestPage.super.Hide(self, target)
  if self.currentSelectedCell then
    self.currentSelectedCell:setIsSelected(false)
  end
end
function BranchQuestPage:initData()
end
function BranchQuestPage:SetData(version)
  self.currentSelectedCell = nil
  self.currentVersion = version
  local versionData = QuestManualProxy.Instance:GetManualQuestDatas(version)
  if versionData then
    if versionData.branch and #versionData.branch > 0 then
      self.panel:SetActive(true)
      self.noData:SetActive(false)
      self.listControllerOfAwardList:ResetDatas(versionData.branch)
      local backList = {}
      local backLength = math.max(8, #versionData.branch)
      for i = 1, backLength do
        backList[#backList + 1] = {id = i}
      end
      self.listControllerOfAwardBackList:ResetDatas(backList)
      self.scrollViewAwardList:ResetPosition()
      local cells = self.listControllerOfAwardList:GetCells()
      UIModelUtil.Instance:ResetTexture(self.itemmodeltexture)
      local firstCell = cells[1]
      if firstCell then
        self:LoadAwardQuestListWithoutShowTip(firstCell)
      end
      self.scrollViewAwardList:ResetPosition()
    else
      self.modelStage:SetActive(false)
      self.panel:SetActive(false)
      self.noData:SetActive(true)
      PictureManager.Instance:SetPuzzleBG("taskmanual_bg_bottom4_new", self.bgtexture)
      self.listControllerOfAwardList:RemoveAll()
    end
  end
end
function BranchQuestPage:OnEnter()
end
function BranchQuestPage:OnExit()
end
function BranchQuestPage:addViewEventListener()
  self.listControllerOfAwardList:AddEventListener(QuestManualEvent.AwardClick, self.LoadAwardQuestList, self)
end
function BranchQuestPage:LoadAwardQuestListWithoutShowTip(cell)
  if self.currentSelectedCell then
    if self.currentSelectedCell == cell then
      return
    else
      self.currentSelectedCell:setIsSelected(false)
    end
  end
  self.currentSelectedCell = cell
  self.currentSelectedCell:setIsSelected(true)
  self.modelStage:SetActive(true)
  if cell.data.questList and #cell.data.questList > 0 then
    self.listControllerOfQuestList:ResetDatas(cell.data.questList)
  else
    self.listControllerOfQuestList:RemoveAll()
  end
  local itemData = ItemData.new("", cell.data.itemid)
  local s, m = self:GetBranchCellProgress(cell.data.questList)
  if m ~= 0 then
    self.modelStageProgress.width = s / m * 180
    self.modelStageProgressLabel.text = s .. "/" .. m
  end
  self.modelStageName.text = itemData.staticData.NameZh
  self.back:SetActive(true)
  self:UpdateModelShow(itemData)
end
function BranchQuestPage:LoadAwardQuestList(cell)
  self:LoadAwardQuestListWithoutShowTip(cell)
  local itemData = ItemData.new("", cell.data.itemid)
  self:ShowAwardItemTip(itemData, cell)
end
function BranchQuestPage:ShowAwardItemTip(itemData, cell)
  local data = {
    itemdata = itemData,
    funcConfig = {},
    noSelfClose = false
  }
  if UIUtil.isClickLeftScreenArea() then
    self:ShowItemTip(data, cell.itemCell.icon, NGUIUtil.AnchorSide.Right, {210, -220})
  else
    self:ShowItemTip(data, cell.itemCell.icon, NGUIUtil.AnchorSide.Left, {-210, -220})
  end
end
function BranchQuestPage:UpdateModelShow(data)
  self.data = data
  if data and data.staticData then
    local itemType = data.staticData.Type
    if data.equipInfo and data.equipInfo.equipData then
      local ismount = data:IsMount()
      if ismount then
        self:SetMountModel(data)
      else
        self:SetNormalModel(data)
      end
      self.itemmodel:SetActive(true)
    elseif itemType == 50 then
      local composeData = Table_Compose[data.staticData.id]
      if composeData then
        local itemData = ItemData.new("", composeData.Product.id)
        self:SetNormalModel(itemData)
      end
    elseif itemType == 820 or itemType == 821 or itemType == 822 then
      local itemData = ItemData.new("", data.staticData.id)
      self:SetHairModel(itemData)
    else
      UIModelUtil.Instance:ResetTexture(self.itemmodeltexture)
    end
  end
end
function BranchQuestPage:SetMountModel()
  self.model = UIModelUtil.Instance:SetMountModelTexture(self.itemmodeltexture, data.staticData.id)
  self.model:SetSacle(0.8)
end
function BranchQuestPage:SetFashionModel(data)
  local id = data.staticId
  local args, parts = self:getArgsAndParts(true)
  local partBody = ItemUtil.getFashionItemRoleBodyPart(id, true)
  if partBody then
    parts[Asset_Role.PartIndex.Body] = partBody.Body
  end
  UIMultiModelUtil.Instance:SetModels(2, args)
  Asset_Role.DestroyPartArray(parts)
  args, parts = self:getArgsAndParts(false)
  partBody = ItemUtil.getFashionItemRoleBodyPart(id)
  if partBody then
    parts[Asset_Role.PartIndex.Body] = partBody.Body
  end
  UIMultiModelUtil.Instance:SetModels(3, args)
  Asset_Role.DestroyPartArray(parts)
end
function BranchQuestPage:getArgsAndParts(isMale)
  local parts = Asset_Role.CreatePartArray()
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  parts[partIndexEx.HairColorIndex] = self.userdata:Get(UDEnum.HAIRCOLOR) or 0
  parts[partIndex.Eye] = self.userdata:Get(UDEnum.EYE) or 0
  parts[partIndexEx.EyeColorIndex] = self.userdata:Get(UDEnum.EYECOLOR) or 0
  TableUtility.TableClear(tempTable)
  tempTable[1] = parts
  tempTable[2] = self.itemmodeltexture
  if isMale then
    parts[partIndex.Body] = Table_Class[1].MaleBody
    parts[partIndex.Hair] = 2
    tempTable[3] = ItemTipModelCell.ModelPos[1].position
    tempTable[4] = ItemTipModelCell.ModelPos[1].rotation
  else
    parts[partIndex.Body] = Table_Class[1].FemaleBody
    parts[partIndex.Hair] = 14
    tempTable[3] = ItemTipModelCell.ModelPos[2].position
    tempTable[4] = ItemTipModelCell.ModelPos[2].rotation
  end
  tempTable[5] = 1
  return tempTable, parts
end
local tempV3 = LuaVector3()
function BranchQuestPage:SetNormalModel(data)
  local sData = data.staticData
  local GroupID = data.equipInfo.equipData.GroupID
  if GroupID then
    local equipDatas = AdventureDataProxy.Instance.fashionGroupData[GroupID]
    if not equipDatas or #equipDatas == 0 then
      return
    end
    local single = equipDatas[1]
    sData = Table_Item[single.id]
  end
  local partIndex = ItemUtil.getItemRolePartIndex(sData.id)
  if partIndex == 0 then
    self.back:SetActive(false)
    UIModelUtil.Instance:ResetTexture(self.itemmodeltexture)
    return
  end
  self.model = UIModelUtil.Instance:SetRolePartModelTexture(self.itemmodeltexture, partIndex, sData.id)
  local isfashion = BagProxy.fashionType[sData.Type]
  if isfashion then
    tempV3:Set(0, 0.5, 0)
    self.model:ResetLocalPosition(tempV3)
  end
  tempV3:Set(1, 1, 1)
  self.model:ResetLocalScale(tempV3)
end
local tempV3 = LuaVector3()
function BranchQuestPage:SetHairModel(data)
  local sData = data.staticData
  local partIndex = ItemUtil.getItemRolePartIndex(sData.id)
  local hairid = ShopDressingProxy.Instance:GetHairStyleIDByItemID(sData.id)
  self.model = UIModelUtil.Instance:SetRolePartModelTexture(self.itemmodeltexture, partIndex, hairid)
  local isfashion = BagProxy.fashionType[sData.Type]
  if isfashion then
    tempV3:Set(0, 0.5, 0)
    self.model:ResetLocalPosition(tempV3)
  end
  tempV3:Set(1, 1, 1)
  self.model:ResetLocalScale(tempV3)
end
function BranchQuestPage:GetBranchCellProgress(questList)
  local finishCount = 0
  local totalCount = 0
  if questList and #questList > 0 then
    totalCount = #questList
    for i = 1, #questList do
      if questList[i].type == SceneQuest_pb.EQUESTLIST_SUBMIT then
        finishCount = finishCount + 1
      end
    end
  end
  return finishCount, totalCount
end
