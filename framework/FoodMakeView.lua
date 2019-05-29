ChooseBordGrid = class("ChooseBordGrid")
function ChooseBordGrid:ctor(gameObject, cellWidth, cellHeight)
  self.gameObject = gameObject
  self.transform = gameObject.transform
  self.cellWidth = cellWidth
  self.cellHeight = cellHeight
end
local tempV3 = LuaVector3()
function ChooseBordGrid:Reposition()
  local childCount = self.transform.childCount
  if childCount <= 0 then
    return
  end
  local col = math.ceil(math.sqrt(childCount))
  local row = math.ceil(childCount / col)
  local startPos_x = -self.cellWidth * (col - 1) / 2
  local startPos_y = self.cellHeight * (row - 1) / 2
  local x, y
  for j = 1, row do
    for i = 1, col do
      if j == row then
        startPos_x = -(childCount - 1 - (j - 1) * col) * self.cellWidth / 2
      end
      x = startPos_x + self.cellWidth * (i - 1)
      y = startPos_y - self.cellHeight * (j - 1)
      local index = i + (j - 1) * col
      if childCount >= index then
        local childTrans = self.transform:GetChild(index - 1)
        if childTrans then
          tempV3:Set(x, y, 0)
          childTrans.localPosition = tempV3
        end
      end
    end
  end
end
FoodMakeView = class("FoodMakeView", ContainerView)
FoodMakeView.ViewType = UIViewType.NormalLayer
autoImport("FoodItemCell")
autoImport("CookRecipeCell")
autoImport("FoodMaterilaCell")
autoImport("FoodRecipePage")
local BagData = BagProxy.Instance.foodBagData
function FoodMakeView:Init()
  self:InitView()
  self:MapEvent()
end
function FoodMakeView:InitView()
  self.recipePage = self:AddSubView("FoodRecipePage", FoodRecipePage)
  self.content = self:FindGO("Content")
  self.foodTog = self:FindComponent("FoodTog", UIToggle)
  self.recipeTog = self:FindComponent("RecipeTog", UIToggle)
  self.cookInfoBord = self:FindGO("CookInfoBord")
  self.cookInfo_TipLabel = self:FindComponent("TipLabel", UILabel, self.cookInfoBord)
  self.cookButton = self:FindGO("StartCookButton", self.cookInfoBord)
  self.cookPotNotice = self:FindGO("CookPotNotice", self.cookInfoBord)
  self.cookButton_Sprite = self.cookButton:GetComponent(UISprite)
  self.cookButton_Label = self:FindComponent("Label", UILabel, self.cookButton)
  self.cookButton_Collider = self.cookButton:GetComponent(BoxCollider)
  self:AddClickEvent(self.cookButton, function(go)
    self:DoServerCook()
  end)
  local wrapObj = self:FindGO("FoodBagWrap")
  local wrapConfig = {
    wrapObj = wrapObj,
    pfbNum = 12,
    cellName = "FoodItemCell",
    control = FoodItemCell,
    dir = 2
  }
  self.foodBagCtl = WrapCellHelper.new(wrapConfig)
  self.foodBagCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.foodBagCtl:AddEventListener(FoodItemEvent.Remove, self.HandleClickRemove, self)
  self.foodBagCtl:AddEventListener(FoodItemEvent.LongPress, self.HandleItemLongPress, self)
  self.foodBagCtl:AddEventListener(FoodItemEvent.RemoveLongPress, self.HandleRemoveLongPress, self)
  self.choose_material_guids = {}
  self.choose_material_itemids = {}
  self.itemIdCountList = {}
  self.bagCells = self.foodBagCtl:GetCellCtls()
  for i = 1, #self.bagCells do
    self.bagCells[i]:UpdateRemoveState(self.choose_material_guids)
  end
  self.potTween = self:FindComponent("PotChooseButton", UIPlayTween)
  for i = 1, 4 do
    do
      local go = self:FindGO("Pot_" .. i)
      self:AddClickEvent(go, function(go)
        self:ChoosePot(i)
        self.potTween:Play(false)
      end)
    end
    break
  end
  self.chooseBord = self:FindGO("ChooseBord")
  self.chooseBord_Bg1 = self:FindComponent("Bg1", Transform, self.chooseBord)
  self.chooseBord_Bg2 = self:FindComponent("Bg2", Transform, self.chooseBord)
  self.chooseBord_Bg3 = self:FindComponent("Bg3", Transform, self.chooseBord)
  local materialGO = self:FindGO("FoodMaterialGrid", self.chooseBord)
  local materialGrid = ChooseBordGrid.new(materialGO, 68, 68)
  self.materialCtl = UIGridListCtrl.new(materialGrid, FoodMaterilaCell, "FoodMaterilaCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickMaterial, self)
  self.materialCtl:AddEventListener(FoodMaterilEvent.LongPress, self.HandleMaterialLongPress, self)
  self.cookLevel = self:FindComponent("CookLevel", UILabel)
  self.foodStars = {}
  self.foodStars[0] = self:FindGO("CookInfo_FoodStars")
  for i = 1, 5 do
    self.foodStars[i] = self:FindComponent("Star" .. i, UISprite, self.foodStars[0])
  end
  self.skipButton = self:FindGO("SkipBtn")
  self.skip_sprite = self.skipButton:GetComponent(UISprite)
  self:AddClickEvent(self.skipButton, function(go)
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.FoodMake, self.skip_sprite, NGUIUtil.AnchorSide.Left, {-150, -5})
  end)
  self:AddButtonEvent("Test", function(go)
    self:DoTest()
  end)
  self.panel = self.gameObject:GetComponent(UIPanel)
  self.uiGridOfRecipes = self:FindComponent("RecipeItemsRoot", UIGrid)
  if self.listControllerOfRecipes == nil then
    self.listControllerOfRecipes = UIGridListCtrl.new(self.uiGridOfRecipes, CookRecipeCell, "CookRecipeCell")
  end
end
function FoodMakeView:HandleClickItem(cellCtl)
  local canAdd = false
  if #self.itemIdCountList >= 5 then
    for i = 1, #self.itemIdCountList do
      local item = BagData:GetItemByGuid(cellCtl.data.id)
      local itemId = item.staticData.id
      if self.itemIdCountList[i].itemId == itemId then
        canAdd = true
      end
    end
  else
    canAdd = true
  end
  if not canAdd then
    return
  end
  local cellData = cellCtl.data
  local item = BagData:GetItemByGuid(cellData.id)
  local itemId = item.staticData.id
  for i = 1, #self.itemIdCountList do
    local itemIdCount = self.itemIdCountList[i]
    if itemIdCount.itemId == itemId and itemIdCount.num >= 999 then
      return
    end
  end
  if cellData then
    self:UpdateChoose_material_guids_Table(cellData.id, 1)
  end
end
function FoodMakeView:HandleItemLongPress(param)
  local state, cellCtl = param[1], param[2]
  local canAdd = false
  if #self.itemIdCountList >= 5 then
    for i = 1, #self.itemIdCountList do
      local item = BagData:GetItemByGuid(cellCtl.data.id)
      local itemId = item.staticData.id
      local itemIdCount = self.itemIdCountList[i]
      if itemIdCount.itemId == itemId then
        canAdd = true
      end
    end
  else
    canAdd = true
  end
  if not canAdd then
    return
  end
  local cellData = cellCtl.data
  if state and cellData then
    self.startPressTime = ServerTime.CurServerTime()
    self.currentPressCell = cellCtl
    if self.tickMg then
      self.tickMg:ClearTick(self)
    else
      self.tickMg = TimeTickManager.Me()
    end
    self.tickMg:CreateTick(0, 100, self.updatePressItemCount, self)
  elseif self.tickMg then
    self.tickMg:ClearTick(self)
    self.tickMg = nil
  end
end
function FoodMakeView:updatePressItemCount()
  local holdTime = ServerTime.CurServerTime() - self.startPressTime
  local changeCount = 1
  if holdTime < 200 then
    return
  elseif holdTime > 3000 and holdTime <= 6000 then
    changeCount = 10
  elseif holdTime > 6000 then
    changeCount = 50
  end
  local cellData = self.currentPressCell.data
  local item = BagData:GetItemByGuid(cellData.id)
  if item then
    local itemId = item.staticData.id
    for i = 1, #self.itemIdCountList do
      local itemIdCount = self.itemIdCountList[i]
      if itemIdCount.itemId == itemId then
        changeCount = math.min(999 - itemIdCount.num, changeCount)
      end
    end
    self:UpdateChoose_material_guids_Table(cellData.id, changeCount, cellData.num)
  end
end
function FoodMakeView:HandleClickRemove(cellCtl)
  local cellData = cellCtl.data
  if cellData then
    local id = cellData.id
    self:UpdateChoose_material_guids_Table(id, -1)
  end
end
function FoodMakeView:HandleRemoveLongPress(param)
  local state, cellCtl = param[1], param[2]
  local cellData = cellCtl.data
  if state and cellData then
    self.startPressTime = ServerTime.CurServerTime()
    self.currentPressCell = cellCtl
    if self.tickMg then
      self.tickMg:ClearTick(self)
    else
      self.tickMg = TimeTickManager.Me()
    end
    self.tickMg:CreateTick(0, 100, self.updatePressRemoveCount, self)
  elseif self.tickMg then
    self.tickMg:ClearTick(self)
    self.tickMg = nil
  end
end
function FoodMakeView:updatePressRemoveCount()
  local holdTime = ServerTime.CurServerTime() - self.startPressTime
  local changeCount = -1
  if holdTime < 200 then
    return
  elseif holdTime > 3000 and holdTime <= 6000 then
    changeCount = -10
  elseif holdTime > 6000 then
    changeCount = -50
  end
  local cellData = self.currentPressCell.data
  self:UpdateChoose_material_guids_Table(cellData.id, changeCount)
end
function FoodMakeView:HandleClickMaterial(cellCtl)
  local itemId = cellCtl.data.itemId
  local guid = self:getOneGuidbyItemId(itemId)
  if guid then
    self:UpdateChoose_material_guids_Table(guid, -1)
  end
end
function FoodMakeView:HandleMaterialLongPress(param)
  local state, cellCtl = param[1], param[2]
  local cellData = cellCtl.data
  if state and cellData then
    self.startPressTime = ServerTime.CurServerTime()
    self.currentPressCell = cellCtl
    if self.tickMg then
      self.tickMg:ClearTick(self)
    else
      self.tickMg = TimeTickManager.Me()
    end
    self.tickMg:CreateTick(0, 100, self.updatePressMaterialCount, self)
  elseif self.tickMg then
    self.tickMg:ClearTick(self)
    self.tickMg = nil
  end
end
function FoodMakeView:updatePressMaterialCount()
  local holdTime = ServerTime.CurServerTime() - self.startPressTime
  local changeCount = -1
  if holdTime < 200 then
    return
  elseif holdTime > 3000 and holdTime <= 6000 then
    changeCount = -10
  elseif holdTime > 6000 then
    changeCount = -50
  end
  local guid = self:getOneGuidbyItemId(self.currentPressCell.data.itemId)
  if guid then
    self:UpdateChoose_material_guids_Table(guid, changeCount)
  end
end
function FoodMakeView:getOneGuidbyItemId(itemid)
  for i = 1, #self.choose_material_guids do
    local item = BagData:GetItemByGuid(self.choose_material_guids[i].guid)
    local itemId = item.staticData.id
    if itemid == itemId then
      return self.choose_material_guids[i].guid
    end
  end
  return nil
end
function FoodMakeView:UpdateChoose_material_guids_Table(guid, changeNum, maxCount)
  local mGuids = self.choose_material_guids
  local hasId = false
  local removeIndex = -1
  for i = 1, #mGuids do
    if mGuids[i].guid == guid then
      hasId = true
      local newNum = mGuids[i].num + changeNum
      if maxCount then
        newNum = math.min(maxCount, newNum)
      end
      newNum = math.max(0, newNum)
      if newNum ~= 0 then
        mGuids[i].num = newNum
      else
        removeIndex = i
      end
    end
  end
  if hasId then
    if removeIndex ~= -1 then
      table.remove(self.choose_material_guids, removeIndex)
    end
  elseif changeNum > 0 then
    table.insert(self.choose_material_guids, {guid = guid, num = changeNum})
  else
    return
  end
  self:PlayChooseBgAnim()
  self:UpdateChoose_material_guids(true)
end
function FoodMakeView:UpdateChoose_material_guids(matchRecipe)
  self.chooseBord:SetActive(#self.choose_material_guids > 0)
  for i = 1, #self.bagCells do
    self.bagCells[i]:UpdateRemoveState(self.choose_material_guids)
  end
  local totallv = 0
  local itemIDCountMap = {}
  TableUtility.TableClear(self.choose_material_itemids)
  for i = 1, #self.choose_material_guids do
    local item = BagData:GetItemByGuid(self.choose_material_guids[i].guid)
    local itemId = item.staticData.id
    itemIDCountMap[itemId] = (itemIDCountMap[itemId] or 0) + self.choose_material_guids[i].num
  end
  TableUtility.TableClear(self.itemIdCountList)
  for k, v in pairs(itemIDCountMap) do
    self.itemIdCountList[#self.itemIdCountList + 1] = {itemId = k, num = v}
  end
  self.materialCtl:ResetDatas(self.itemIdCountList)
  self:UpdateCookInfo(matchRecipe)
end
function FoodMakeView:UpdateCookInfo(matchRecipe)
  if #self.choose_material_guids > 0 then
    self.cookInfoBord:SetActive(true)
    if self.selectPot then
      if matchRecipe then
        if self.recipeMap then
          TableUtility.TableClear(self.recipeMap)
        end
        self.recipeMap = FunctionFood.Me():MatchRecipe(self.selectPot, self.itemIdCountList)
      end
      if self.recipeMap and 0 < #self.recipeMap then
        self.listControllerOfRecipes:ResetDatas(self.recipeMap)
        self:ActiveCookButton(true)
      else
        self.listControllerOfRecipes:RemoveAll()
        self:ActiveCookButton(false)
      end
    else
      self.recipeMap = nil
      self.listControllerOfRecipes:RemoveAll()
      self:ActiveCookButton(false)
    end
  else
    self.cookInfoBord:SetActive(false)
  end
  self:UpdateChooseBordPosition()
end
function FoodMakeView:UpdateChooseBordPosition()
  if self.init_chooseBord == true then
    return
  end
  self.init_chooseBord = true
  local uicam = NGUIUtil:GetCameraByLayername("UI")
  local gcam = NGUIUtil:GetCameraByLayername("Default")
  local epTrans = Game.Myself.assetRole:GetEP(RoleDefines_EP.Top)
  if epTrans ~= nil then
    local sp_x, sp_y, sp_z = LuaGameObject.WorldToViewportPointByTransform(gcam, epTrans, Space.World)
    tempV3:Set(sp_x, sp_y, sp_z)
    self.chooseBord.transform.position = uicam:ViewportToWorldPoint(tempV3)
  end
  self.panel:ConstrainTargetToBounds(self.chooseBord.gameObject.transform, true)
end
function FoodMakeView:PlayChooseBgAnim()
  self.animCount = 2
  self:_PlayChooseBgAnim()
end
function FoodMakeView:_PlayChooseBgAnim()
  if self.animCount <= 0 then
    return
  end
  if self.lt then
    self.lt:cancel()
    self.lt = nil
  end
  self.lt = LeanTween.value(self.gameObject, FoodMakeView._ScaleTo, 0, 0.1, 0.2)
  self.lt.onUpdateParam = self
  self.lt.onCompleteObject = FoodMakeView._ScaleBack
  self.lt.onCompleteParam = self
end
function FoodMakeView._ScaleTo(f, self)
  tempV3:Set(1 + f, 1 - f, 1)
  self.chooseBord_Bg1.localScale = tempV3
  self.chooseBord_Bg2.localScale = tempV3
  self.chooseBord_Bg3.localScale = tempV3
end
function FoodMakeView:_ScaleBack()
  if self.lt then
    self.lt:cancel()
    self.lt = nil
  end
  self.lt = LeanTween.value(self.gameObject, FoodMakeView._ScaleTo, 0.1, 0, 0.2)
  self.lt.onUpdateParam = self
  self.lt.onCompleteObject = FoodMakeView._AnimEnd
  self.lt.onCompleteParam = self
end
function FoodMakeView:_AnimEnd()
  if self.lt then
    self.lt:cancel()
    self.lt = nil
  end
  self.animCount = self.animCount - 1
  self:_PlayChooseBgAnim()
end
local tempColor = LuaColor.New(1, 1, 1, 1)
function FoodMakeView:ActiveCookButton(b)
  if self.selectPot then
    self.cookButton:SetActive(true)
  elseif #self.itemIdCountList > 0 then
    self.cookPotNotice:SetActive(true)
  end
  if not b then
    tempColor:Set(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
    self.cookButton_Sprite.color = tempColor
    tempColor:Set(0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
    self.cookButton_Label.effectColor = tempColor
    self.cookButton_Collider.enabled = false
  else
    tempColor:Set(1, 1, 1, 1)
    self.cookButton_Sprite.color = tempColor
    tempColor:Set(0.08627450980392157, 0.4235294117647059, 0.00392156862745098, 1)
    self.cookButton_Label.effectColor = tempColor
    self.cookButton_Collider.enabled = true
  end
end
function FoodMakeView:ChoosePot(index)
  self.selectPot = index
  self:UpdateCookInfo(true)
  self.cookPotNotice:SetActive(false)
  ServiceSceneFoodProxy.Instance:CallSelectCookType(index)
end
function FoodMakeView:DoServerCook()
  if self.recipeMap and #self.recipeMap > 0 then
    self.skipAnim = LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.FoodMake)
    FunctionFood.Me():DoMakeFood(self.selectPot, self.choose_material_guids, self.skipAnim, self.recipeMap)
    self.cacheItemId = Table_Recipe[self.recipeMap[1].recipeId].Product
    self:ClearMaterials()
    self.content:SetActive(false)
  end
end
function FoodMakeView:MapEvent()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateFoodBag)
  self:AddListenEvt(ServiceEvent.SceneFoodCookStateNtf, self.HandleCookStateChange)
  self:AddListenEvt(FoodEvent.PutMaterials, self.HandlePutMaterials)
  self:AddListenEvt(FoodEvent.FoodGetPopUp_Enter, self.HandleFoodGetEnter)
  self:AddListenEvt(FoodEvent.FoodGetPopUp_Exit, self.HandleFoodGetExit)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.CloseSelf)
  self:AddListenEvt(MyselfEvent.TwinActionStart, self.HandleTwinActionStart)
end
function FoodMakeView:HandleTwinActionStart(note)
  self:CloseSelf()
end
function FoodMakeView:HandleCookStateChange(note)
  local server_data = note.body
  local charid, server_CookStateMsg = server_data.charid, server_data.state
  if charid == Game.Myself.data.id then
    local state = server_CookStateMsg.state
    if state == SceneFood_pb.ECOOKSTATE_COOKING then
      FunctionBGMCmd.Me():PlayUIBgm("cooking", 1)
    elseif state == SceneFood_pb.ECOOKSTATE_COMPLETE then
      self:UpdateCookInfo()
      local itemData = self.cacheItemId and Table_Item[self.cacheItemId]
      if not itemData or not BagProxy.CheckIsFoodTypeItem(itemData.Type) then
        self.content:SetActive(true)
        return
      end
      self:RemoveDelayCloselt()
      self.delayCloselt = LeanTween.delayedCall(8, function()
        self.delayCloselt = nil
        self.content:SetActive(true)
      end)
      FunctionBGMCmd.Me():StopUIBgm(5, 0.1)
    elseif state == SceneFood_pb.ECOOKSTATE_PREPAREING and self.skipAnim then
      self.content:SetActive(true)
    end
  end
end
function FoodMakeView:RemoveDelayCloselt()
  if self.delayCloselt then
    self.delayCloselt:cancel()
    self.delayCloselt = nil
  end
end
function FoodMakeView:HandleFoodGetEnter(note)
  self:RemoveDelayCloselt()
end
function FoodMakeView:HandleFoodGetExit(note)
  self:UpdateFoodBag()
  self.content:SetActive(true)
end
function FoodMakeView:ClearMaterials()
  self.recipeMap = nil
  TableUtility.ArrayClear(self.choose_material_guids)
  self:UpdateChoose_material_guids(false)
end
local foodMaterialDatas = {}
function FoodMakeView:UpdateFoodBag()
  TableUtility.ArrayClear(foodMaterialDatas)
  local datas = BagData:GetItems(GameConfig.FoodPackPage[2])
  if datas then
    for j = 1, #datas do
      table.insert(foodMaterialDatas, datas[j])
    end
  end
  self.foodBagCtl:UpdateInfo(foodMaterialDatas)
end
function FoodMakeView:DoTest()
  local testData = {}
  for i = 1, 5 do
    local index = math.random(1, #foodMaterialDatas)
    table.insert(testData, foodMaterialDatas[index])
  end
  for i = 1, #testData do
    local cellData = testData[i]
    if cellData then
      table.insert(self.choose_material_guids, {
        guid = cellData.id,
        num = maxNum
      })
      self:PlayChooseBgAnim()
      self:UpdateChoose_material_guids(true)
    end
  end
  self:DoServerCook()
end
function FoodMakeView:UpdateCookerLevel()
  local cooklv = self.myUserData:Get(UDEnum.COOKER_LV) or 1
  self.cookLevel.text = "Lv." .. cooklv
end
function FoodMakeView:HandlePutMaterials(note)
  local data = note.body
  local recipeSData = data.recipeData.staticData
  local recipeCount = data.matchNum
  TableUtility.ArrayClear(self.choose_material_guids)
  local material = recipeSData.Material
  local m, item
  local bagProxy = BagProxy.Instance
  for i = 1, #material do
    m = material[i]
    if m[1] == 1 then
      local leftNum = m[3] * recipeCount
      for j = 1, #foodMaterialDatas do
        item = foodMaterialDatas[j]
        if item.staticData.id == m[2] then
          local maxNum = math.min(leftNum, item.num)
          table.insert(self.choose_material_guids, {
            guid = item.id,
            num = maxNum
          })
          leftNum = leftNum - maxNum
        end
      end
    elseif not (leftNum <= 0) and m[1] == 2 then
      local filterItems = {}
      for j = 1, #foodMaterialDatas do
        item = foodMaterialDatas[j]
        if item.staticData.Type == m[2] then
          table.insert(filterItems, item)
        end
      end
      table.sort(filterItems, FoodMakeView._FliterItemMaterialsSort)
      local leftNum = m[3] * recipeCount
      for j = 1, #filterItems do
        item = filterItems[j]
        local maxNum = math.min(leftNum, item.num)
        table.insert(self.choose_material_guids, {
          guid = item.id,
          num = maxNum
        })
        leftNum = leftNum - maxNum
        if not (leftNum <= 0) then
        end
      end
    end
  end
  self.foodTog:Set(true)
  self:ChoosePot(recipeSData.Type)
  local totallv = 0
  local totalCount = 0
  for i = 1, #self.choose_material_guids do
    local guidNum = self.choose_material_guids[i]
    local item = BagData:GetItemByGuid(guidNum.guid)
    local itemId = item.staticData.id
    totalCount = totalCount + guidNum.num
    local materialInfo = FoodProxy.Instance:Get_MaterialExpInfo(itemId)
    if materialInfo then
      totallv = materialInfo.level * guidNum.num + totallv
    else
      totallv = totallv + guidNum.num
    end
  end
  if totalCount > 0 then
    local avgmateriallv = totallv / totalCount
    TableUtility.TableClear(self.recipeMap)
    self.recipeMap[1] = {
      recipeId = recipeSData.id,
      num = recipeCount,
      avgMatLevel = avgmateriallv
    }
    self:UpdateChoose_material_guids(false)
  end
end
function FoodMakeView._FliterItemMaterialsSort(a, b)
  return a.staticData.id < b.staticData.id
end
local rot_V3 = LuaVector3()
function FoodMakeView:PreView()
  local myTrans = Game.Myself.assetRole.completeTransform
  if myTrans then
    rot_V3:Set(CameraConfig.FoodMake_Rotation_OffsetX, CameraConfig.FoodMake_Rotation_OffsetY, 0)
    self:CameraFaceTo(myTrans, CameraConfig.FoodMake_ViewPort, nil, nil, rot_V3)
  end
  FunctionSystem.InterruptMyself()
  Game.Myself:Client_PauseIdleAI()
end
function FoodMakeView:OnEnter()
  FoodMakeView.super.OnEnter(self)
  self:PreView()
  ServiceSceneFoodProxy.Instance:CallPrepareCook(true)
  self.myUserData = Game.Myself.data.userdata
  if FunctionFirstTime.Me():IsFirstTime(UserEvent_pb.EFIRSTACTION_COOKFOOD - 1) == true then
    self.skipButton:SetActive(false)
  else
    self.skipButton:SetActive(true)
  end
  self:UpdateFoodBag()
  self:UpdateCookerLevel()
  FunctionBGMCmd.Me():PlayUIBgm("cook_wait", 0)
end
function FoodMakeView:OnExit()
  FoodMakeView.super.OnExit(self)
  Game.Myself:Client_ResumeIdleAI()
  self:CameraReset()
  self:ClearMaterials()
  ServiceSceneFoodProxy.Instance:CallPrepareCook(false)
  local fake_msg = {
    state = SceneFood_pb.ECOOKSTATE_NONE
  }
  FunctionFood.Me():UpdateMakeState(Game.Myself.data.id, fake_msg)
  FunctionBGMCmd.Me():StopUIBgm()
end
