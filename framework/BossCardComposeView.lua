autoImport("CardNCell")
autoImport("BossCardMakeCell")
autoImport("CardMakeMaterialCell")
autoImport("CardMakeData")
BossCardComposeView = class("BossCardComposeView", ContainerView)
BossCardComposeView.ViewType = UIViewType.NormalLayer
BossCardComposeView.CardNCellResPath = ResourcePathHelper.UICell("CardNCell")
local tempVector3 = LuaVector3.zero
local skipType = SKIPTYPE.CardMake
local composeid = GameConfig.Card.composeid
function BossCardComposeView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function BossCardComposeView:FindObjs()
  self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
  self.targetName = self:FindGO("TargetName"):GetComponent(UILabel)
  self.confirmButton = self:FindGO("ConfirmButton"):GetComponent(UIMultiSprite)
  self.confirmLabel = self:FindGO("Label", self.confirmButton.gameObject):GetComponent(UILabel)
  self.cost = self:FindGO("Cost"):GetComponent(UILabel)
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  self.tip = self:FindGO("Tip"):GetComponent(UILabel)
end
function BossCardComposeView:AddEvts()
  EventDelegate.Add(self.filter.onChange, function()
    if self.filter.data == nil then
      return
    end
    if self.filterData ~= self.filter.data then
      self.filterData = self.filter.data
      self:ResetCard()
    end
  end)
  self:AddClickEvent(self.confirmButton.gameObject, function()
    self:Confirm()
  end)
  local closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(closeButton, function()
    SceneUIManager.Instance:PlayerSpeak(self.npcId, ZhString.CardMark_EndDialog)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:Skip()
  end)
end
function BossCardComposeView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemExchangeCardItemCmd, self.HandleExchangeCardItem)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateTipInfo)
end
function BossCardComposeView:InitShow()
  local chooseData = CardMakeData.new(2000)
  CardMakeProxy.Instance:SetChoose(chooseData)
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.canMake = false
  self.npcId = self.viewdata.viewdata.npcdata.data.id
  local container = self:FindGO("CardContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 6,
    cellName = "BossCardMakecell",
    control = BossCardMakeCell,
    dir = 1
  }
  self.wrapHelper = WrapCellHelper.new(wrapConfig)
  self.wrapHelper:AddEventListener(CardMakeEvent.Select_BossCard, self.HandleSelect, self)
  local materialGrid = self:FindGO("MaterialGrid"):GetComponent(UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, CardMakeMaterialCell, "CardMakeMaterialCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.HandleMaterialTip, self)
  local effectPic = self:FindGO("EffectPic"):GetComponent(UITexture)
  local sample = self:FindGO("sample"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("boss-card-synthesis_bg_matrix", effectPic)
  PictureManager.Instance:SetUI("boss-card-synthesis_bg_card", sample)
  local effectContainer = self:FindGO("EffectContainer")
  local btneffectContainer = self:FindGO("BtnEffectContainer")
  self:PlayUIEffect(EffectMap.UI.MVPCard_Bg, effectContainer)
  local btneffect = self:PlayUIEffect(EffectMap.UI.MVPCard_Btn, btneffectContainer)
  btneffect:ResetLocalPositionXYZ(0, 0, 0)
  CardMakeProxy.Instance:InitBossComposeCard()
  self:InitFilter()
  self:UpdateCard()
  self:UpdateSkip()
  self:InitMaterial()
  self:UpdateMaterial()
  self:UpdateTipInfo()
  self:UpdateConfirmBtn()
end
function BossCardComposeView:InitFilter()
  self.filter:Clear()
  local makeFilter = GameConfig.CardMake.MakeFilter
  local rangeList = CardMakeProxy.Instance:GetFilter(makeFilter)
  for i = 1, #rangeList do
    local rangeData = makeFilter[rangeList[i]]
    self.filter:AddItem(rangeData, rangeList[i])
  end
  if #rangeList > 0 then
    local range = rangeList[1]
    self.filterData = range
    local rangeData = makeFilter[range]
    self.filter.value = rangeData
  end
end
function BossCardComposeView:HandleSelect(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end
function BossCardComposeView:HandleMaterialTip(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data.itemData
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
function BossCardComposeView:HandleItemUpdate()
  self:UpdateMaterial(chooseData)
  self:UpdateConfirmBtn()
end
function BossCardComposeView:HandleExchangeCardItem(note)
  local data = note.body
  if data and data.charid == Game.Myself.data.id then
    self:CloseSelf()
  end
end
function BossCardComposeView:HandleRemoveNpc(note)
  local data = note.body
  if data and #data > 0 then
    for i = 1, #data do
      if self.npcId == data[i] then
        self:CloseSelf()
        break
      end
    end
  end
end
function BossCardComposeView:UpdateCard()
  local data = CardMakeProxy.Instance:FilterBossComposeCard(self.filterData)
  if data then
    self.wrapHelper:UpdateInfo(data)
  end
end
function BossCardComposeView:InitMaterial()
  local compose = Table_Compose[composeid]
  if compose then
    if compose.Product and compose.Product.id then
      self.itemData = ItemData.new("CardMake", compose.Product.id)
    end
    local beCostItem = compose.BeCostItem
    if beCostItem then
      self.materialItems = {}
      for i = 1, #beCostItem do
        local data = CardMakeMaterialData.new(beCostItem[i])
        TableUtility.ArrayPushBack(self.materialItems, data)
      end
    end
  end
end
function BossCardComposeView:UpdateMaterial()
  if self.materialItems then
    self.materialCtl:ResetDatas(self.materialItems)
  end
end
function BossCardComposeView:ResetCard()
  self:UpdateCard()
  self.wrapHelper:ResetPosition()
end
function BossCardComposeView:UpdateConfirmBtn()
  self.canMake = self:CanMake()
  self:SetConfirm(not self.canMake)
end
function BossCardComposeView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.ComposeCard)
  self.skipBtn.gameObject:SetActive(not isShow)
end
function BossCardComposeView:CanMake()
  self:ClearCount()
  if self.materialItems then
    local material
    for i = 1, #self.materialItems do
      material = self.materialItems[i]
      if not self:CheckCanMake(material) then
        return false
      end
    end
  end
  return true
end
function BossCardComposeView:ClearCount()
  if self.cardCount then
    for k, v in pairs(self.cardCount) do
      self.cardCount[k] = 0
    end
  end
end
function BossCardComposeView:CheckCanMake(materialData)
  if materialData then
    local id = materialData.id
    if self.cardCount == nil then
      self.cardCount = {}
    end
    if self.cardCount[id] == nil then
      self.cardCount[id] = 0
    end
    self.cardCount[id] = self.cardCount[id] + materialData.itemData.num
    return CardMakeProxy.Instance:GetItemNumByStaticID(id) >= self.cardCount[id]
  end
  return false
end
function BossCardComposeView:Confirm()
  self.canMake = self:CanMake()
  if self.canMake then
    local chooseData = CardMakeProxy.Instance:GetChoose()
    local data = Table_Compose[composeid]
    if MyselfProxy.Instance:GetROB() < data.ROB then
      MsgManager.ShowMsgByID(1)
      return
    end
    self:CallExchangeCardItem()
  end
end
function BossCardComposeView:Skip()
  TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn, NGUIUtil.AnchorSide.Right, {150, 0})
end
function BossCardComposeView:CallExchangeCardItem()
  local chooseData = CardMakeProxy.Instance:GetChoose()
  local skipValue = CardMakeProxy.Instance:IsSkipGetEffect(skipType)
  ServiceItemProxy.Instance:CallExchangeCardItemCmd(CardMakeProxy.MakeType.BossCompose, self.npcId, nil, nil, nil, skipValue)
end
function BossCardComposeView:SetConfirm(isGray)
  if isGray then
    self.confirmButton.CurrentState = 1
    self.confirmLabel.effectStyle = UILabel.Effect.None
  else
    self.confirmButton.CurrentState = 0
    self.confirmLabel.effectStyle = UILabel.Effect.Outline
  end
end
local maxCount = GameConfig.Card.exchangecard_boss
function BossCardComposeView:UpdateTipInfo()
  local count = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_EXCHANGECARD_BOSS) or 0
  count = maxCount - count
  if count < 0 then
    count = 0
  end
  self.tip.text = string.format(ZhString.BossCard_Tip, count, maxCount)
end
