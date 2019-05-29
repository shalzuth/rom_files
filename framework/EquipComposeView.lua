autoImport("EquipCombineTableCell")
autoImport("EquipComposeCell")
autoImport("EquipChooseBord")
autoImport("EquipComposeBagCombineItemCell")
EquipComposeView = class("EquipComposeView", BaseView)
EquipComposeView.ViewType = UIViewType.NormalLayer
local CLASSIFIED_CFG = GameConfig.EquipComposeType
local _ColorBlue = LuaColor.New(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)
local _ColorTitleGray = ColorUtil.TitleGray
local EFF_BG_TEXTURE_NAME = "perfusion_bg_04"
local ACTION_NAME = "functional_action"
function EquipComposeView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitView()
  self:InitFilter()
end
function EquipComposeView:FindObjs()
  self.btn = self:FindComponent("Btn", UISprite)
  self.btnName = self:FindComponent("BtnName", UILabel)
  self.toggleName = self:FindComponent("ToggleName", UILabel)
  self.profressionToggle = self:FindComponent("Toggle", UIToggle)
  self.matToggle = self:FindComponent("MatToggle", UIToggle)
  self.bagToggle = self:FindComponent("BagToggle", UIToggle)
  self.matToggleLab = self.matToggle.gameObject:GetComponent(UILabel)
  self.bagToggleLab = self.bagToggle.gameObject:GetComponent(UILabel)
  self.typeFilter = self:FindComponent("typeFilter", UIPopupList)
  self.equipTable = self:FindComponent("EquipTable", UITable)
  self.bagItemContainer = self:FindGO("BagEquipContainer")
  self.bagProductContainer = self:FindGO("BagEquipProductContainer")
  self.equipScrollview = self:FindComponent("EquipScroll", UIScrollView)
  self.bagScrollview = self:FindComponent("BagScrollView", UIScrollView)
  self.matScrollView = self:FindComponent("MatScrollView", UIScrollView)
  self.costScrollView = self:FindComponent("CostScrollView", UIScrollView)
  self.zenyLab = self:FindComponent("CostLab", UILabel)
  self.filterPanel = self:FindGO("filterPanel")
  self.equipPos = self:FindGO("EquipPos")
  self.bagPos = self:FindGO("BagPos")
  self.emptyBagProduct = self:FindComponent("EmptyBagProduct", UILabel)
  self.targetObj = self:FindGO("TargetCell")
  self.targetCell = EquipComposeCell.new(self.targetObj)
  self.targetMainObj = self:FindGO("TargetMainMatCell")
  self.targetMainCell = EquipComposeCell.new(self.targetMainObj)
  self.effectPos = self:FindGO("effectPos")
  self.effContainer = self:FindGO("EffContainer")
end
function EquipComposeView:InitView()
  for i = 1, 4 do
    local effectBgTexture = self:FindComponent("perfusion_bg_04_" .. i, UITexture)
    PictureManager.Instance:SetUI(EFF_BG_TEXTURE_NAME, effectBgTexture)
  end
  local matGrid = self:FindComponent("MatGrid", UIGrid)
  self.matCtl = UIGridListCtrl.new(matGrid, EquipComposeCell, "EquipComposeCell")
  self.matCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMatCell, self)
  local costGrid = self:FindComponent("CostGrid", UIGrid)
  self.costCtl = UIGridListCtrl.new(costGrid, EquipComposeCell, "EquipComposeCell")
  self.costCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCostItem, self)
  if not self.equipTableCtl then
    self.equipTableCtl = UIGridListCtrl.new(self.equipTable, EquipCombineTableCell, "EquipCombineTableCell")
    self.equipTableCtl:AddEventListener(MouseEvent.MouseClick, self.ClickTabItem, self)
  end
  local allData = EquipComposeProxy.Instance:GetTypeFilterData(1)
  self.equipTableCtl:ResetDatas(allData)
  local chooseContaienr = self:FindGO("ChooseContainer")
  local chooseBordDataFunc = function()
    return self:GetComposeEquips(self.curMatItemData.staticData.id)
  end
  self.chooseBord = EquipChooseBord.new(chooseContaienr, chooseBordDataFunc)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  local wrapConfig = {
    wrapObj = self.bagItemContainer,
    pfbNum = 5,
    cellName = "EquipComposeBagCombineItemCell",
    control = EquipComposeBagCombineItemCell,
    dir = 1
  }
  self.bagWraplist = WrapCellHelper.new(wrapConfig)
  self.bagWraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickBagItem, self)
  local wrapConfig = {
    wrapObj = self.bagProductContainer,
    pfbNum = 5,
    cellName = "EquipComposeItemCell",
    control = EquipComposeItemCell,
    dir = 2
  }
  self.bagProductWraplist = WrapCellHelper.new(wrapConfig)
  self.bagProductWraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickBagProductItem, self)
  self:PlayUIEffect(EffectMap.UI.EquipCompose, self.effContainer, false)
  self:Show(self.effectPos)
end
function EquipComposeView:ClickCostItem(cellctl)
  if cellctl and cellctl.data then
    if self.curClickCost ~= cellctl.data then
      self.curClickCost = cellctl.data
      local stick = cellctl.gameObject:GetComponent(UIWidget)
      local sdata = {
        itemdata = cellctl.data,
        funcConfig = {},
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      self:ShowItemTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
    else
      self.curClickCost = nil
      TipManager.Instance:CloseTip()
    end
  else
    TipManager.Instance:CloseTip()
  end
end
function EquipComposeView:HandleClickBagProductItem(cellctl)
  local data = cellctl.data
  if not data then
    return
  end
  EquipComposeProxy.Instance:SetCurrentData(data)
  self:ClickTabItem(cellctl)
  self:ResetBagProductChoose(data.composeID)
end
function EquipComposeView:ResetBagProductChoose(composeID)
  local cells = self.bagProductWraplist:GetCellCtls()
  if cells then
    for i = 1, #cells do
      cells[i]:SetChoose(composeID)
    end
  end
end
function EquipComposeView:ReUnitData(datas, rowNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / rowNum) + 1
      local i2 = math.floor((i - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      if datas[i] == nil then
        self.unitData[i1][i2] = nil
      else
        self.unitData[i1][i2] = datas[i]
      end
    end
  end
  return self.unitData
end
function EquipComposeView:HandleClickBagItem(cellctl)
  local data = cellctl.data
  if not data then
    return
  end
  local uiData = {}
  local productData = data.staticData.id and Table_EquipComposeProduct[data.staticData.id]
  if productData then
    for i = 1, #productData.productID do
      local pData = EquipComposeItemData.new(Table_EquipCompose[productData.productID[i]])
      uiData[#uiData + 1] = pData
    end
    self:Hide(self.emptyBagProduct)
  else
    self:Show(self.emptyBagProduct)
    self:ClickTabItem()
  end
  self:ResetRightView()
  self:ResetBagProductChoose()
  self.bagProductWraplist:ResetDatas(uiData)
  self:ResetBagEquipChoose(data.id)
end
function EquipComposeView:ResetBagEquipChoose(id)
  local cellData = self.bagWraplist:GetCellCtls()
  if cellData then
    for i = 1, #cellData do
      local cells = cellData[i]:GetCells()
      for j = 1, #cells do
        cells[j]:SetChoose(id)
      end
    end
  end
end
function EquipComposeView:ChooseItem(item)
  local cardids = {}
  local equipedCards = item.equipedCardInfo
  if equipedCards then
    for j = 1, item.cardSlotNum do
      if equipedCards[j] then
        table.insert(cardids, equipedCards[j].id)
      end
    end
  end
  local equipInfo = item.equipInfo
  local hasstrength = equipInfo.strengthlv > 0
  local hasstrength2 = false
  local hasenchant = false
  local hasupgrade = false
  if #cardids > 0 or hasstrength then
    local recoverCost = EquipRecoverProxy.Instance:GetRecoverCost(item, true, hasupgrade, hasstrength, false, hasstrength2)
    MsgManager.ConfirmMsgByID(26101, function()
      ServiceItemProxy.Instance:CallRestoreEquipItemCmd(item.id, hasstrength, cardids, hasenchant, hasupgrade, hasstrength2)
    end, nil, nil, recoverCost)
    self.chooseBord:Hide()
    return
  end
  EquipComposeProxy.Instance:SetChooseMat(self.curMatIndex, item.id)
  local curData = EquipComposeProxy.Instance:GetCurData()
  if item.staticData.id == curData.mainMat.staticData.id then
    self.targetMainCell:SetData(item)
  else
    self.matCtl:ResetDatas(curData.MatArray)
  end
  self.chooseBord:Hide()
  self:ResetBtnState()
end
function EquipComposeView:GetComposeEquips(staticID)
  local result = {}
  local bagEquips = BagProxy.Instance:GetItemsByStaticID(staticID)
  local curData = EquipComposeProxy.Instance:GetCurData()
  if bagEquips then
    for i = 1, #bagEquips do
      local equipLv = bagEquips[i].equipInfo and bagEquips[i].equipInfo.equiplv
      local isDamage = bagEquips[i].equipInfo and bagEquips[i].equipInfo.damage
      local lvLimited = curData:GetMatLimitedLv(bagEquips[i].staticData.id)
      if equipLv == nil then
        redlog("GetComposeEquips error staticID: ", staticID)
      end
      if not isDamage and equipLv >= lvLimited and BagProxy.Instance:CheckIfFavoriteCanBeMaterial(bagEquips[i]) ~= false then
        result[#result + 1] = bagEquips[i]
      end
    end
  end
  return result
end
function EquipComposeView:ClickMatCell(cellctl)
  local data = cellctl and cellctl.data
  if not data then
    return
  end
  self:OnClickMat(data)
end
function EquipComposeView:OnClickMat(data)
  self.curMatItemData = data
  self.curMatIndex = data.staticData.id
  local equipdatas = self:GetComposeEquips(data.staticData.id)
  if #equipdatas > 0 then
    self.chooseBord:ResetDatas(equipdatas, false)
    self.chooseBord:Show(true)
  else
    MsgManager.ShowMsgByID(8001, {
      data.staticData.NameZh
    })
    self.chooseBord:Hide()
  end
end
function EquipComposeView:ClickTabItem(cellctl)
  local data = cellctl and cellctl.data
  if not data then
    self:ResetRightView()
    return
  end
  EquipComposeProxy.Instance:SetCurrentData(data)
  local curData = EquipComposeProxy.Instance:GetCurData()
  self.matCtl:ResetDatas(curData.MatArray)
  self.matScrollView:ResetPosition()
  self.costCtl:ResetDatas(curData.material)
  self.costScrollView:ResetPosition()
  self.zenyLab.text = StringUtil.NumThousandFormat(curData.cost)
  self:RefreshChooseCell(curData.composeID)
  self.targetCell:SetData(curData.itemdata)
  self.targetMainCell:SetData(curData.mainMat)
  self:ResetBtnState()
end
function EquipComposeView:ResetBtnState()
  local curData = EquipComposeProxy.Instance:GetCurData()
  if curData and not curData:IsMatLimited() then
    ColorUtil.WhiteUIWidget(self.btn)
    ColorUtil.WhiteUIWidget(self.btnName)
    self.btnName.effectStyle = UILabel.Effect.Outline
  else
    ColorUtil.ShaderGrayUIWidget(self.btn)
    ColorUtil.ShaderGrayUIWidget(self.btnName)
    self.btnName.effectStyle = UILabel.Effect.None
  end
end
function EquipComposeView:ResetRightView()
  self.matCtl:ResetDatas()
  self.matScrollView:ResetPosition()
  self.costCtl:ResetDatas()
  self.costScrollView:ResetPosition()
  self.zenyLab.text = ""
  self:RefreshChooseCell()
  self.targetCell:SetData()
  self.targetMainCell:SetData()
  self.bagProductWraplist:ResetDatas({})
  self:ResetBtnState()
end
function EquipComposeView:RefreshChooseCell(id)
  local Cells = self.equipTableCtl:GetCells()
  for i = 1, #Cells do
    local cell = Cells[i]:GetCells()
    for j = 1, #cell do
      cell[j]:SetChoose(id)
    end
  end
end
function EquipComposeView:OnExit()
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  EquipComposeProxy.Instance:SetCurrentData()
  PictureManager.Instance:UnLoadUI()
  EquipComposeView.super.OnExit(self)
end
function EquipComposeView:AddEvts()
  self:AddClickEvent(self.targetObj, function(go)
    local stick = self.targetObj.gameObject:GetComponent(UIWidget)
    local sdata = {
      itemdata = self.targetCell.data,
      funcConfig = {}
    }
    self:ShowItemTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
  end)
  self:AddClickEvent(self.btn.gameObject, function(g)
    self:OnBtn()
  end)
  EventDelegate.Add(self.profressionToggle.onChange, function()
    local toggleValue = self.profressionToggle.value
    self:RefreshView()
  end)
  EventDelegate.Add(self.typeFilter.onChange, function()
    if self.filterIndex ~= self.typeFilter.data then
      self.filterIndex = self.typeFilter.data
      self:RefreshView()
    end
  end)
  self:AddClickEvent(self.targetMainObj, function()
    self:OnClickMat(self.targetMainCell.data)
  end)
  self:AddToggleChange(self.matToggle, self.matToggleLab, _ColorBlue, _ColorTitleGray, self.equipScrollview, self.ClickMatToggle)
  self:AddToggleChange(self.bagToggle, self.bagToggleLab, _ColorBlue, _ColorTitleGray, self.bagScrollview, self.ClickBagToggle)
end
function EquipComposeView:AddToggleChange(toggle, label, toggleColor, normalColor, scrollView, handler)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value then
      label.color = toggleColor
      if handler ~= nil then
        handler(self)
        scrollView:ResetPosition()
      end
    else
      label.color = normalColor
    end
    self:ResetRightView()
    self:ResetBagEquipChoose()
    self:ResetBagProductChoose()
  end)
end
function EquipComposeView:ClickMatToggle()
  self:Show(self.equipPos)
  self:Hide(self.bagPos)
  self:Show(self.profressionToggle)
  self:Show(self.filterPanel)
end
function EquipComposeView:ClickBagToggle()
  self:Hide(self.equipPos)
  self:Show(self.bagPos)
  self:Hide(self.profressionToggle)
  self:Hide(self.filterPanel)
  self:ResetBagWrapData()
end
function EquipComposeView:ResetBagWrapData()
  local bagData = {}
  for k, v in pairs(GameConfig.PackageMaterialCheck.equipcompose) do
    local bagTypeData = BagProxy.Instance:GetBagItemsByTypes(CLASSIFIED_CFG[1].types, v)
    if bagTypeData then
      for i = 1, #bagTypeData do
        table.insert(bagData, bagTypeData[i])
      end
    end
  end
  local newdata = self:ReUnitData(bagData, 5)
  self.bagWraplist:UpdateInfo(newdata)
end
function EquipComposeView:RefreshView()
  local data = EquipComposeProxy.Instance:GetTypeFilterData(self.filterIndex, self.profressionToggle.value)
  self.equipTableCtl:ResetDatas(data)
  self.equipTableCtl:Layout()
  self.equipScrollview:ResetPosition()
end
function EquipComposeView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.ItemEquipComposeItemCmd, self.HandleEquipCompose)
end
function EquipComposeView:HandleEquipCompose(note)
  local msgID = note.body and note.body.retmsg
  if msgID ~= 0 then
    MsgManager.ShowMsgByID(msgID)
  else
    local npcs = NSceneNpcProxy.Instance:FindNpcs(4865)
    if npcs and #npcs > 0 then
      local npcdata = npcs[1]
      npcdata.assetRole:PlayAction_Simple(ACTION_NAME)
    end
    self:CloseSelf()
  end
end
local _getFilter = function(filterData)
  local filter = {}
  for k, v in pairs(filterData) do
    table.insert(filter, k)
  end
  return filter
end
function EquipComposeView:InitFilter()
  self.typeFilter:Clear()
  local keyArray = _getFilter(CLASSIFIED_CFG)
  for i = 1, #keyArray do
    local rangeData = CLASSIFIED_CFG[keyArray[i]].name
    self.typeFilter:AddItem(rangeData, keyArray[i])
  end
  if #keyArray > 0 then
    local range = keyArray[1]
    self.filterIndex = range
    local rangeData = CLASSIFIED_CFG[range].name
    self.typeFilter.value = rangeData
  end
end
function EquipComposeView:OnBtn()
  local curData = EquipComposeProxy.Instance:GetCurData()
  if not curData then
    return
  end
  if curData:IsMatLimited() then
    return
  end
  if curData:IsCostLimited() then
    MsgManager.ShowMsgByID(1)
    return
  end
  local chooseMat = curData:GetChooseMatArray()
  local curDataCostMat = curData.material
  local lackItems = {}
  for i = 1, #curDataCostMat do
    local costStaticID = curDataCostMat[i].staticData.id
    local costNum = curDataCostMat[i].num
    local ownNum = BagProxy.Instance:GetItemNumByStaticID(costStaticID)
    if costNum > ownNum then
      local lackItem = {
        id = costStaticID,
        count = costNum - ownNum
      }
      TableUtility.ArrayPushBack(lackItems, lackItem)
    end
  end
  if #lackItems > 0 then
    QuickBuyProxy.Instance:TryOpenView(lackItems)
    return
  end
  MsgManager.ConfirmMsgByID(26001, function()
    ServiceItemProxy.Instance:CallEquipComposeItemCmd(curData.composeID, chooseMat)
  end, nil, nil)
end
