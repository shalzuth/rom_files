EnchantTransferView = class("EnchantView", BaseView)
autoImport("EnchantTransferCell")
EnchantTransferView.ViewType = UIViewType.NormalLayer
local PERSENT_FORMAT = "%s    [c][1B5EB1]+%s%%[-][/c]"
local VALUE_FORMAT = "%s    [c][1B5EB1]+%s[-][/c]"
local WORKTIP_FORMAT = "[c][9c9c9c]%s:%s(%s)[-][/c]"
local COMBINE_FORMAT = "[c][222222]%s:%s[-][/c]"
local NOENCHANT_FORMAT = "[c][9c9c9c]%s[-][/c]"
local STR_FORMAT = string.format
local _WhiteUIWidget = ColorUtil.WhiteUIWidget
local tempColor = LuaColor.white
local _ArrayClear = TableUtility.ArrayClear
local COST_CFG = GameConfig.Lottery.TransferCost
function EnchantTransferView:Init()
  self:FindObjs()
  self:LisEvent()
  self:AddEvts()
  self:InitView()
  self:UpdataMainBord()
  OverseaHostHelper:FixLabelOverV1(self.transferDesc, 3, 180)
  if OverseaHostHelper:isJP() then
    self.tipLabel.transform.localPosition = Vector3(280, -60, 0)
    local Sprite = self:FindGO("Sprite", self.tipLabel)
    Sprite.transform.localPosition = Vector3(-92, 0, 0)
    local TipLabel = self:FindGO("TipLabel", self.tipLabel)
    TipLabel.transform.localPosition = Vector3(12, -47, 0)
  end
  OverseaHostHelper:FixLabelOverV1(self.filterName, 3, 100)
end
function EnchantTransferView:FindObjs()
  self.transferText = self:FindComponent("TransferText", UILabel)
  self.cost = self:FindComponent("Cost", UISprite)
  self.costNum = self:FindComponent("CostNum", UILabel)
  self.transferDesc = self:FindComponent("TransferDesc", UILabel)
  self.filterName = self:FindComponent("FilterName", UILabel)
  self.addItemInButton = self:FindComponent("AddItemInButton", UISprite)
  self:AddClickEvent(self.addItemInButton.gameObject, function(go)
    self:clickTargetInItem()
  end)
  self.addItemOutButton = self:FindComponent("AddItemOutButton", UISprite)
  self:AddClickEvent(self.addItemOutButton.gameObject, function(go)
    self:clickTargetOutItem()
  end)
  self.targetInGo = self:FindGO("TargetInCell")
  self.targetInItemCell = BaseItemCell.new(self.targetInGo)
  self.targetInItemCell:AddEventListener(MouseEvent.MouseClick, self.clickTargetInItem, self)
  self.targetOutGo = self:FindGO("TargetOutCell")
  self.targetOutItemCell = BaseItemCell.new(self.targetOutGo)
  self.targetOutItemCell:AddEventListener(MouseEvent.MouseClick, self.clickTargetOutItem, self)
  self.scrollView = self:FindGO("EnchantScrollView")
  local enchantInfoTable = self:FindGO("EnchantInfoTable")
  local wrapConfig = {
    wrapObj = enchantInfoTable,
    pfbNum = 5,
    cellName = "EnchantTransferCell",
    control = EnchantTransferCell
  }
  self.chooseCtl = WrapCellHelper.new(wrapConfig)
  self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleChooseItem, self)
  self.chooseCtl:AddEventListener(EnchantTransferCellEvent.ClickItemIcon, self.ClickItemIcon, self)
  self.chooseBord = self:FindGO("EnchantInfoBord")
  self.tipLabel = self:FindGO("TipLabel")
  local table = self:FindComponent("previewTable", UITable)
  self.attrPreviewCtl = UIGridListCtrl.new(table, TipLabelCell, "TipLabelCell")
  self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
  self.closecomp = self.chooseBord:GetComponent(CloseWhenClickOtherPlace)
  self.empty = self:FindComponent("Empty", UILabel)
  self.btn = self:FindComponent("TransferBtn", UISprite)
  self.effContainer = self:FindGO("EffContainer")
end
function EnchantTransferView:AddEvts()
  self:AddClickEvent(self.btn.gameObject, function(go)
    self:OnTransfer()
  end)
  EventDelegate.Add(self.filter.onChange, function()
    if self.filter.data == nil then
      return
    end
    if self.filterData ~= self.filter.data then
      local data = EnchantTransferProxy.Instance:GetFilterData(self.filter.data)
      if #data > 0 then
        self.filterData = self.filter.data
        self.chooseCtl:UpdateInfo(data)
        self.chooseCtl:ResetPosition()
        self.curFilterValue = self.filter.value
      else
        self.filterName.text = self.curFilterValue
        MsgManager.ShowMsgByID(290)
      end
    end
  end)
end
function EnchantTransferView:SelectFirst()
  local first = self.chooseCtl:GetCellCtls()[1]
  if first then
    self:HandleChooseItem(first)
  end
end
function EnchantTransferView:ClickItemIcon(cell)
  local data = cell.data
  if nil ~= data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end
local filter = {}
local _getFilter = function(filterData)
  _ArrayClear(filter)
  for k, v in pairs(filterData) do
    table.insert(filter, k)
  end
  return filter
end
function EnchantTransferView:InitFilter()
  self.filter:Clear()
  local makeFilter = GameConfig.Lottery.TransferFilter
  local rangeList = _getFilter(makeFilter)
  for i = 1, #rangeList do
    local rangeData = makeFilter[rangeList[i]]
    self.filter:AddItem(rangeData, rangeList[i])
  end
  if #rangeList > 0 then
    local range = rangeList[1]
    self.filterData = range
    local rangeData = makeFilter[range]
    self.filter.value = rangeData
    self.curFilterValue = self.filter.value
  end
end
local lineTab = {453, 229}
function EnchantTransferView:SetBordAttr()
  if nil == self.contextDatas then
    self.contextDatas = {}
  else
    _ArrayClear(self.contextDatas)
  end
  if self.transferInData and self.transferInData.enchantInfo then
    local attri = self.transferInData.enchantInfo:GetEnchantAttrs()
    if #attri > 0 then
      for i = 1, #attri do
        local content = {}
        if attri[i].propVO.isPercent then
          content.label = STR_FORMAT(PERSENT_FORMAT, attri[i].name, attri[i].value)
        else
          content.label = STR_FORMAT(VALUE_FORMAT, attri[i].name, attri[i].value)
        end
        content.hideline = false
        content.lineTab = lineTab
        self.contextDatas[#self.contextDatas + 1] = content
      end
      local combineEffects = self.transferInData.enchantInfo:GetCombineEffects()
      for i = 1, #combineEffects do
        local content = {}
        local combineEffect = combineEffects[i]
        local buffData = combineEffect and combineEffect.buffData
        if buffData then
          if combineEffect.isWork then
            content.label = STR_FORMAT(COMBINE_FORMAT, buffData.BuffName, buffData.BuffDesc)
          else
            content.label = STR_FORMAT(WORKTIP_FORMAT, buffData.BuffName, buffData.BuffDesc, combineEffect.WorkTip)
          end
          content.hideline = false
          content.lineTab = lineTab
          self.contextDatas[#self.contextDatas + 1] = content
        end
      end
    end
  end
  if #self.contextDatas > 0 then
    self.contextDatas[#self.contextDatas].hideline = true
  end
  self.attrPreviewCtl:ResetDatas(self.contextDatas)
end
function EnchantTransferView:LisEvent()
  self:AddListenEvt(ServiceEvent.ItemEnchantTransItemCmd, self.HandleTransfer)
end
function EnchantTransferView:HandleTransfer(note)
  local data = note.body
  if true == data.success then
    self:PlayUIEffect(EffectMap.UI.EnchantTransfer, self.effContainer, true, self.SuccessEffectHandle, self)
  end
end
function EnchantTransferView:_CloseUI()
  MsgManager.ShowMsgByID(293)
  LeanTween.cancel(self.gameObject)
  LeanTween.delayedCall(self.gameObject, 3, function()
    self:CloseSelf()
    self.forbiddenFlag = false
  end)
end
function EnchantTransferView.SuccessEffectHandle(effectHandle, owner)
  if owner then
    owner:_CloseUI()
  end
end
function EnchantTransferView:InitView()
  ServiceItemProxy.Instance:CallQueryLotteryHeadItemCmd()
  local iconName = Table_Item[COST_CFG.itemid] and Table_Item[COST_CFG.itemid].Icon or ""
  IconManager:SetItemIcon(iconName, self.cost)
  self.costNum.text = COST_CFG.num
  self.transferText.text = ZhString.EnchantTransferView_BtnName
  self.empty.text = ZhString.EnchantTransferView_Empty
  self.tipData = {}
  tempColor:Set(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
  self:InitFilter()
  self:SelectFirst()
end
function EnchantTransferView:HandleChooseItem(cellctl)
  local data = cellctl and cellctl.data
  if EnchantTransferProxy.Instance.chooseTransferInData then
    EnchantTransferProxy.Instance:ResetChooseData(data)
    self.transferInData = data
    self.targetInItemCell:SetData(data)
    self.targetInItemCell:UpdateMyselfInfo(data)
    self:Show(self.targetInGo)
    self:ResetTransOutData()
  else
    self.transferOutData = data
    self.targetOutItemCell:SetData(data)
    self.targetOutItemCell:UpdateMyselfInfo(data)
    self:Show(self.targetOutGo)
  end
  self:Hide(self.chooseBord)
  self:UpdataMainBord()
  self:SetBordAttr()
end
function EnchantTransferView:ResetTransOutData()
  if self.transferOutData and self.transferOutData.staticData.Type ~= self.transferInData.staticData.Type then
    self.transferOutData = nil
    self:Hide(self.targetOutGo)
  end
end
function EnchantTransferView:UpdataMainBord()
  if self.transferInData then
    self:Hide(self.tipLabel)
    self.addItemInButton.enabled = false
  else
    self:Show(self.tipLabel)
    self.addItemInButton.enabled = true
    _WhiteUIWidget(self.addItemInButton)
  end
  if self.transferOutData then
    self.addItemOutButton.enabled = false
  else
    self.addItemOutButton.enabled = true
    if self.transferInData then
      _WhiteUIWidget(self.addItemOutButton)
    else
      self.addItemOutButton.color = tempColor
    end
  end
  if self.transferInData and self.transferOutData then
    _WhiteUIWidget(self.btn)
    _WhiteUIWidget(self.cost)
    self.transferText.effectStyle = UILabel.Effect.Outline
  else
    self.btn.color = tempColor
    self.cost.color = tempColor
    self.transferText.effectStyle = UILabel.Effect.None
  end
end
function EnchantTransferView:clickTargetInItem(cellCtl)
  EnchantTransferProxy.Instance:ResetPhase(true)
  self:Show(self.filter.gameObject)
  local data = EnchantTransferProxy.Instance:GetEnchantInData()
  self:_resetChooseInfo(data)
end
function EnchantTransferView:clickTargetOutItem(cellCtl)
  if not self.transferInData then
    return
  end
  EnchantTransferProxy.Instance:ResetPhase(false)
  self:Hide(self.filter.gameObject)
  local data = EnchantTransferProxy.Instance:GetEnchantOutData()
  self:_resetChooseInfo(data)
end
function EnchantTransferView:_resetChooseInfo(data)
  self:Show(self.chooseBord)
  self.chooseCtl:UpdateInfo(data)
  self.chooseCtl:ResetPosition()
  self.scrollView:SetActive(#data > 0)
  self.empty.gameObject:SetActive(#data == 0)
end
function EnchantTransferView:OnTransfer()
  if self.forbiddenFlag then
    return
  end
  if not self.transferInData or not self.transferOutData then
    return
  end
  if BagProxy.Instance:GetItemNumByStaticID(COST_CFG.itemid) < COST_CFG.num then
    MsgManager.ShowMsgByID(292)
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(291)
  if nil == dont then
    MsgManager.DontAgainConfirmMsgByID(291, function()
      ServiceItemProxy.Instance:CallEnchantTransItemCmd(self.transferInData.id, self.transferOutData.id)
      self.forbiddenFlag = true
    end)
  else
    ServiceItemProxy.Instance:CallEnchantTransItemCmd(self.transferInData.id, self.transferOutData.id)
    self.forbiddenFlag = true
  end
end
