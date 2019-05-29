PackageMainPage = class("PackageMainPage", SubView)
autoImport("ItemNormalList")
autoImport("BagCombineDragItemCell")
autoImport("QuestPackagePart")
autoImport("FoodPackagePart")
autoImport("PetPackagePart")
local addFavoriteItems = {}
local delFavoriteItems = {}
function PackageMainPage:Init()
  self:AddViewEvts()
  self:InitUI()
end
function PackageMainPage:OnEnter()
  PackageMainPage.super.OnEnter(self)
  TableUtility.ArrayClear(addFavoriteItems)
  TableUtility.ArrayClear(delFavoriteItems)
  self:UpdateCoins()
  self.itemlist:ChooseTab(1)
  if self.markingFavoriteMode then
    self:SwitchMarkingFavoriteMode()
    self.itemlist:ResetPosition()
  end
end
local tabDatas = {}
function PackageMainPage:InitUI()
  self.normalStick = self:FindComponent("NormalStick", UISprite)
  self:InitItemList()
  self:InitRefreshSymbol()
  local coins = self:FindChild("TopCoins")
  self.lottery = self:FindChild("Lottery", coins)
  self.lotterylabel = self:FindComponent("Label", UILabel, self.lottery)
  local icon = self:FindComponent("symbol", UISprite, self.lottery)
  IconManager:SetItemIcon(Table_Item[151].Icon, icon)
  self.userRob = self:FindChild("Silver", coins)
  self.robLabel = self:FindComponent("Label", UILabel, self.userRob)
end
function PackageMainPage:InitItemList()
  local listObj = self:FindGO("ItemNormalList")
  self.itemlist = ItemNormalList.new(listObj, BagCombineDragItemCell, nil, PullStopScrollView, true)
  self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.DoubleClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.ClickItemTab, self.ClickItemTab, self)
  self.itemlist.GetTabDatas = PackageMainPage.GetTabDatas
  function self.itemlist.scrollView.onDragStarted()
    self:ShowItemTip()
    self:SetItemDragEnabled(false)
  end
  function self.itemlist.scrollView.onDragFinished()
    if self.markingFavoriteMode then
      return
    end
    self:SetItemDragEnabled(true)
  end
  self.itemListScrollPanel = self.itemlist.scrollView.panel
  self.itemCells = self.itemlist:GetItemCells()
end
function PackageMainPage:InitRefreshSymbol()
  self:FindAndAddClickEvent("StoreButton", function(go)
    self:TryeDoQuick()
  end)
  self:FindAndAddClickEvent("SaleButton", function(go)
    self:DoSaleButton()
  end)
  self:FindAndAddClickEvent("RearrayButton", function(go)
    self:DoRearrayButton()
  end)
  self:FindAndAddClickEvent("MarkFavoriteButton", function(go)
    local switchModeOnAction = function()
      self:SwitchMarkingFavoriteMode(true)
    end
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(32500)
    if not dont then
      MsgManager.DontAgainConfirmMsgByID(32500, switchModeOnAction, switchModeOnAction)
    else
      switchModeOnAction()
    end
  end)
  self:FindAndAddClickEvent("MarkFavoriteButtonFake", function(go)
    self:SwitchMarkingFavoriteMode()
  end)
  self.refreshSymbol = self:FindGO("RefreshSymbol")
  self.refreshSymbol:SetActive(true)
  self.markFavoriteControls = self:FindGO("MarkFavoriteControls")
  self.markFavoriteControls:SetActive(false)
end
function PackageMainPage:TryeDoQuick()
  if self.markingFavoriteMode then
    return
  end
  self.st = ReusableTable.CreateArray()
  if not GameConfig.PackageMaterialCheck.quick_store then
    local bagTypes = {1, 8}
  end
  for i = 1, #bagTypes do
    BagProxy.Instance:CollectQuickStorageItems(self.st, bagTypes[i])
  end
  if #self.st == 0 then
    TableUtility.ArrayClear(self.st)
    ReusableTable.DestroyArray(self.st)
    MsgManager.ShowMsgByIDTable(25426)
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(25424)
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByID(25424, function()
      self:DoQuickStore()
    end, nil, nil)
  else
    self:DoQuickStore()
  end
end
function PackageMainPage:DoQuickStore()
  self.st = ReusableTable.CreateArray()
  if not GameConfig.PackageMaterialCheck.quick_store then
    local bagTypes = {1, 8}
  end
  for i = 1, #bagTypes do
    BagProxy.Instance:CollectQuickStorageItems(self.st, bagTypes[i])
  end
  helplog("Do QuickStore", #self.st)
  local items = ReusableTable.CreateArray()
  for i = 1, #self.st do
    local item = self.st[i]
    local sitem = SceneItem_pb.SItem()
    sitem.guid, sitem.count = item.id, item.num or 0
    table.insert(items, sitem)
  end
  ServiceItemProxy.Instance:CallQuickStoreItemCmd(items)
  ReusableTable.DestroyArray(items)
  TableUtility.ArrayClear(self.st)
  ReusableTable.DestroyArray(self.st)
end
function PackageMainPage:DoSaleButton()
  if self.markingFavoriteMode then
    return
  end
  helplog("DoSaleButton In")
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.CollectSaleConfirmPopUp
  })
end
function PackageMainPage:DoRearrayButton()
  if self.markingFavoriteMode then
    return
  end
  helplog("DoRearrayButton In")
  ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_MAIN)
end
function PackageMainPage:SwitchMarkingFavoriteMode(on)
  local isOn = on == true and true or false
  self.markingFavoriteMode = on
  self.itemlist.isMarkingFavorite = on
  self.markFavoriteControls:SetActive(isOn)
  self.refreshSymbol:SetActive(not isOn)
  self.container:PassEvent(PackageEvent.SwitchMarkingFavoriteMode, self.markingFavoriteMode)
  if not self.itemlist.scrollView.isDragging then
    self:SetItemDragEnabled(not isOn)
  end
  if not on and (next(addFavoriteItems) or next(delFavoriteItems)) then
    local msgId = 32002
    if not LocalSaveProxy.Instance:GetDontShowAgain(msgId) then
      MsgManager.DontAgainConfirmMsgByID(msgId, function()
        self:TrySendFavorite()
      end, function()
        self:UpdateList()
      end)
    else
      self:TrySendFavorite()
    end
  end
  local tmpClipRegion = self.itemListScrollPanel.baseClipRegion
  local refreshSymbolHeight = 101
  tmpClipRegion.y = on and -refreshSymbolHeight / 2 or 0
  tmpClipRegion.w = tmpClipRegion.w + refreshSymbolHeight * (on and -1 or 1)
  self.itemListScrollPanel.baseClipRegion = tmpClipRegion
end
function PackageMainPage:TrySendFavorite()
  local bagIns = BagProxy.Instance
  if next(addFavoriteItems) then
    bagIns:CallAddFavoriteItems(addFavoriteItems)
  end
  if next(delFavoriteItems) then
    bagIns:CallDelFavoriteItems(delFavoriteItems)
  end
  self.delayedUpdateList = LeanTween.delayedCall(3, function()
    self:UpdateList()
    self.delayedUpdateList = nil
  end)
  for _, cell in pairs(self.itemCells) do
    cell:HideMask()
  end
  TableUtility.ArrayClear(addFavoriteItems)
  TableUtility.ArrayClear(delFavoriteItems)
end
function PackageMainPage:GetQuestPackageBord()
  if self.init_questPacakgeBord then
    return self.questPackageBord
  end
  self.init_questPacakgeBord = true
  local qpParent = self:FindGO("QuestPackageParent")
  self.questPackageBord = QuestPackagePart.new()
  self.questPackageBord:CreateSelf(qpParent)
  self.questPackageBord:Hide()
  return self.questPackageBord
end
function PackageMainPage:GetFoodPackageBord()
  if self.init_foodPacakgeBord then
    return self.foodPackageBord
  end
  self.init_foodPacakgeBord = true
  local qpParent = self:FindGO("QuestPackageParent")
  self.foodPackageBord = FoodPackagePart.new()
  self.foodPackageBord:CreateSelf(qpParent)
  self.foodPackageBord:Hide()
  return self.foodPackageBord
end
function PackageMainPage:GetPetPackageBord()
  if self.init_petPackageBord then
    return self.petPackageBord
  end
  self.init_petPackageBord = true
  local qpParent = self:FindGO("QuestPackageParent")
  self.petPackageBord = PetPackagePart.new()
  self.petPackageBord:CreateSelf(qpParent)
  return self.petPackageBord
end
function PackageMainPage.GetTabDatas(itemTabConfig, tabData)
  TableUtility.ArrayClear(tabDatas)
  local bagData = BagProxy.Instance.bagData
  local datas = tabData.index ~= -1 and bagData:GetItems(itemTabConfig) or BagProxy.Instance:GetFavoriteItemDatas()
  if datas then
    for i = 1, #datas do
      table.insert(tabDatas, datas[i])
    end
  end
  local uplimit = bagData:GetUplimit()
  if uplimit > 0 then
    for i = #tabDatas + 1, uplimit do
      table.insert(tabDatas, BagItemEmptyType.Empty)
    end
  elseif uplimit == 0 then
    local leftEmpty = (5 - #tabDatas % 5) % 5
    for i = 1, leftEmpty do
      table.insert(tabDatas, BagItemEmptyType.Empty)
    end
  end
  local unlockData = BagProxy.Instance:GetBagUnlockSpaceData()
  if unlockData then
    table.insert(tabDatas, {
      id = BagItemEmptyType.Unlock,
      unlockData = unlockData
    })
  end
  local leftEmpty = (5 - #tabDatas % 5) % 5
  for i = 1, 10 + leftEmpty do
    table.insert(tabDatas, BagItemEmptyType.Grey)
  end
  for i = #tabDatas + 1, 35 do
    table.insert(tabDatas, BagItemEmptyType.Grey)
  end
  return tabDatas
end
function PackageMainPage:RemoveReArrageSafeLT()
  self:RemoveDelayedCall("reArrageSafeLT")
end
function PackageMainPage:PullDownPackage()
  self:RemoveReArrageSafeLT()
  self.reArrageSafeLT = LeanTween.delayedCall(3, function()
    self:HandleItemReArrage()
  end)
  ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_MAIN)
end
function PackageMainPage:ClickItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey then
    data = nil
  end
  if data ~= nil and data.id == BagItemEmptyType.Unlock then
    MsgManager.ShowMsgByIDTable(3107, {
      data.unlockData.id,
      data.unlockData.pack
    })
    return
  end
  local go = cellCtl and cellCtl.gameObject
  if self.markingFavoriteMode then
    if BagProxy.CheckIfCanDoFavoriteActions(data) then
      cellCtl:NegateFavoriteTip()
      TableUtility.ArrayRemove(addFavoriteItems, data.id)
      TableUtility.ArrayRemove(delFavoriteItems, data.id)
      local wasFavorite = BagProxy.Instance:CheckIsFavorite(data)
      local newFavorite = cellCtl:GetFavoriteTipActive()
      if wasFavorite ~= newFavorite then
        local arrToAdd = newFavorite and addFavoriteItems or delFavoriteItems
        TableUtility.ArrayPushBack(arrToAdd, data.id)
        cellCtl:ShowMask()
      else
        cellCtl:HideMask()
      end
    end
    return
  end
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    if type(data) == "table" then
      local sid = data.staticData.id
      if sid == 5045 then
        self:CloseOtherPackage("quest")
        self:ShowQuestPackage()
      elseif sid == 5047 then
        self:CloseOtherPackage("food")
        self:ShowFoodPackage()
      elseif sid == 5640 then
        self:CloseOtherPackage("pet")
        self:ShowPetPackage()
      else
        self:ShowPackageItemTip(data, {go})
      end
    else
      self:ShowPackageItemTip(data, {go})
    end
  else
    self.chooseId = 0
    self:ShowPackageItemTip()
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end
function PackageMainPage:DoubleClickItem(cellCtl)
  local data = cellCtl.data
  if data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey then
    data = nil
  end
  if data ~= nil and data.id == BagItemEmptyType.Unlock then
    return
  end
  if self.markingFavoriteMode then
    return
  end
  if data then
    local func, funcId
    if self.container.viewState == PackageView.LeftViewState.BarrowBag then
      func, funcId = FunctionItemFunc.Me():GetFuncById(37), 37
    else
      func, funcId = self.container:GetItemDefaultFunc(data, FunctionItemFunc_Source.MainBag)
    end
    if func then
      if self.container.viewState ~= PackageView.LeftViewState.Default and funcId == 4 then
        self.container:SetLeftViewState(PackageView.LeftViewState.Default)
      end
      if data.staticData.ExistTimeType ~= 3 or data.deltime == nil or not (data.deltime <= ServerTime.CurServerTime() / 1000) then
        func(data)
      end
    end
    self:ShowPackageItemTip()
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChooseId(self.chooseId)
    end
  end
end
function PackageMainPage:ClickItemTab()
  self:TryUpdateTemporarilyMarkFavorite()
end
function PackageMainPage:ShowPackageItemTip(data, ignoreBounds)
  if data == nil then
    self:ShowItemTip()
    return
  end
  local callback = function()
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChooseId(self.chooseId)
    end
  end
  local sdata = {
    itemdata = data,
    showUpTip = true,
    funcConfig = self.container:GetDataFuncs(data),
    ignoreBounds = ignoreBounds,
    callback = callback
  }
  local comps, offset = {}, {-210, 0}
  if self.container.viewState ~= PackageView.LeftViewState.BarrowBag and (data.equipInfo or data:IsMount()) then
    local site = data.equipInfo:GetEquipSite()
    for i = 1, #site do
      local comp = BagProxy.Instance.roleEquip:GetEquipBySite(site[i])
      if comp then
        table.insert(comps, comp)
      end
    end
  end
  sdata.compdata1 = comps[1]
  sdata.compdata2 = comps[2]
  if comps[1] then
    offset = {0, 0}
  end
  self:ShowItemTip(sdata, self.normalStick, nil, offset)
  local tip = TipsView.Me().currentTip
  if tip and TipsView.Me():IsCurrentTip(ItemFloatTip) and tip.ActiveFavorite then
    tip:ActiveFavorite()
  end
end
function PackageMainPage:ShowQuestPackage()
  local bord = self:GetQuestPackageBord()
  bord:UpdateInfo()
  bord:Show()
end
function PackageMainPage:ShowFoodPackage()
  local bord = self:GetFoodPackageBord()
  bord:UpdateInfo()
  bord:Show()
end
function PackageMainPage:ShowPetPackage()
  local bord = self:GetPetPackageBord()
  bord:UpdateInfo()
  bord:Show()
end
function PackageMainPage:SetItemDragEnabled(b)
  for i = 1, #self.itemCells do
    self.itemCells[i]:CanDrag(b)
  end
end
function PackageMainPage:UpdateList()
  self.itemlist:UpdateList(true)
  GuideMaskView.getInstance():showGuideByQuestDataRepeat()
end
function PackageMainPage:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
  self.lotterylabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
end
function PackageMainPage:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.ItemReArrage, self.HandleItemReArrage)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemPackSlotNtfItemCmd, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemPackageSort, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.UseTimeUpdate, self.HandleItemUpdate)
end
function PackageMainPage:HandleItemUpdate(note)
  self:RemoveDelayedCall("delayedUpdateList")
  self:UpdateList()
  local tip = TipsView.Me().currentTip
  if tip and TipsView.Me():IsCurrentTip(ItemFloatTip) and tip.UpdateFavorite then
    tip:UpdateFavorite()
  end
end
function PackageMainPage:HandleItemReArrage(note)
  local arrageType = note.body
  if arrageType == SceneItem_pb.EPACKTYPE_PET then
    if self.petPackageBord then
      self.petPackageBord:UpdateInfo()
    end
  elseif arrageType == SceneItem_pb.EPACKTYPE_FOOD then
    if self.foodPackageBord then
      self.foodPackageBord:UpdateInfo()
    end
  elseif arrageType == SceneItem_pb.EPACKTYPE_QUEST then
    if self.questPackageBord then
      self.questPackageBord:UpdateInfo()
    end
  else
    self:RemoveReArrageSafeLT()
    AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.ReArrage))
    local callback = function()
      self:UpdateList()
    end
    self.itemlist:ScrollViewRevert(callback)
  end
end
function PackageMainPage:CloseOtherPackage(package)
  if self.petPackageBord and self.petPackageBord.gameObject.activeSelf and "pet" ~= package then
    self.petPackageBord:Hide()
  end
  if self.foodPackageBord and self.foodPackageBord.gameObject.activeSelf and "food" ~= package then
    self.foodPackageBord:Hide()
  end
  if self.questPackageBord and self.questPackageBord.gameObject.activeSelf and "quest" ~= package then
    self.questPackageBord:Hide()
  end
end
function PackageMainPage:TryUpdateTemporarilyMarkFavorite()
  if not self.markingFavoriteMode then
    return
  end
  self:UpdateTemporarilyMarkFavoriteByArray(addFavoriteItems)
  self:UpdateTemporarilyMarkFavoriteByArray(delFavoriteItems)
end
function PackageMainPage:UpdateTemporarilyMarkFavoriteByArray(arr)
  for _, tempMarkId in pairs(arr) do
    for _, cell in pairs(self.itemCells) do
      if cell.data and cell.data.id == tempMarkId then
        cell:ShowMask()
        cell:NegateFavoriteTip()
      end
    end
  end
end
function PackageMainPage:CheckFavoriteModeOnExit(checkCompleteHandler)
  if self.markingFavoriteMode and (next(addFavoriteItems) or next(delFavoriteItems)) then
    MsgManager.ConfirmMsgByID(32002, function()
      self:TrySendFavorite()
      checkCompleteHandler()
    end, checkCompleteHandler)
  else
    checkCompleteHandler()
  end
end
function PackageMainPage:FindAndAddClickEvent(name, event, parent, hideType)
  local go = self:FindGO(name, parent)
  self:AddClickEvent(go, event, hideType)
end
function PackageMainPage:RemoveDelayedCall(keyOfCall)
  if self[keyOfCall] and self[keyOfCall].cancel then
    self[keyOfCall]:cancel()
    self[keyOfCall] = nil
  end
end
function PackageMainPage:OnShow()
  if self.itemlist == nil then
    return
  end
  if self.itemlist.panel then
    self.itemlist.panel:SetDirty()
  end
  self.itemlist:ResetPosition()
end
function PackageMainPage:OnExit()
  self:RemoveReArrageSafeLT()
  self:RemoveDelayedCall("delayedUpdateList")
  self.chooseId = 0
  self:ShowPackageItemTip()
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
  PackageMainPage.super.OnExit(self)
end
function PackageMainPage:OnDestroy()
  self.itemlist:OnExit()
  self.itemlist = nil
end
