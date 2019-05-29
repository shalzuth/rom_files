autoImport("CardNCell")
autoImport("CardMakeCell")
autoImport("CardMakeMaterialCell")
CardMakeView = class("CardMakeView", ContainerView)
CardMakeView.ViewType = UIViewType.NormalLayer
CardMakeView.CardNCellResPath = ResourcePathHelper.UICell("CardNCell")
local tempVector3 = LuaVector3.zero
local skipType = SKIPTYPE.CardMake
function CardMakeView:OnExit()
  self:ClearChooseData()
  CardMakeProxy.Instance:SetChoose(nil)
  CardMakeView.super.OnExit(self)
end
function CardMakeView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function CardMakeView:FindObjs()
  self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
  self.targetName = self:FindGO("TargetName"):GetComponent(UILabel)
  self.tip = self:FindGO("Tip"):GetComponent(UILabel)
  self.tipIcon = self:FindGO("TipIcon"):GetComponent(UISprite)
  self.confirmButton = self:FindGO("ConfirmButton"):GetComponent(UIMultiSprite)
  self.confirmLabel = self:FindGO("Label", self.confirmButton.gameObject):GetComponent(UILabel)
  self.cost = self:FindGO("Cost"):GetComponent(UILabel)
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  local fLabel = self:FindGO("Label", self.filter.gameObject):GetComponent(UILabel)
  fLabel.fontSize = 21
end
function CardMakeView:AddEvts()
  EventDelegate.Add(self.filter.onChange, function()
    if self.filter.data == nil then
      return
    end
    if self.filterData ~= self.filter.data then
      self.filterData = self.filter.data
      self:ResetCard()
      self:SelectFirst()
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
function CardMakeView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemExchangeCardItemCmd, self.HandleExchangeCardItem)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end
function CardMakeView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.canMake = false
  self.npcId = self.viewdata.viewdata.npcdata.data.id
  local container = self:FindGO("CardContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 6,
    cellName = "CardMakeCell",
    control = CardMakeCell,
    dir = 1
  }
  self.wrapHelper = WrapCellHelper.new(wrapConfig)
  self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickCell, self)
  self.wrapHelper:AddEventListener(CardMakeEvent.Select, self.HandleSelect, self)
  local materialGrid = self:FindGO("MaterialGrid"):GetComponent(UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, CardMakeMaterialCell, "CardMakeMaterialCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.HandleMaterialTip, self)
  local targetCard = self:FindGO("TargetCard")
  obj = Game.AssetManager_UI:CreateAsset(CardMakeView.CardNCellResPath, targetCard)
  tempVector3:Set(0, 0, 0)
  obj.transform.localPosition = tempVector3
  tempVector3:Set(1, 1, 1)
  obj.transform.localScale = tempVector3
  self.targetCardCell = CardNCell.new(obj)
  self.targetCardCell:Hide(self.targetCardCell.useButton.gameObject)
  self:InitFilter()
  self:UpdateCard()
  self:UpdateSkip()
  self:SelectFirst()
end
function CardMakeView:InitFilter()
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
function CardMakeView:SelectFirst()
  local first = self.wrapHelper:GetCellCtls()[1]
  if first then
    self:HandleClickCell(first)
  end
end
function CardMakeView:HandleClickCell(cell)
  local data = cell.data
  if data then
    local _CardMakeProxy = CardMakeProxy.Instance
    local chooseData = _CardMakeProxy:GetChoose()
    if chooseData and chooseData.id == data.id then
      return
    end
    self:ClearChooseCard()
    self:ClearChooseData()
    cell:SetChoose(true)
    _CardMakeProxy:SetChoose(cell.data)
    self.targetName.text = data.itemData.staticData.NameZh
    self.targetCardCell:SetData(data.itemData)
    self:UpdateMaterial(data)
    local isLock = data:IsLock()
    self.tip.gameObject:SetActive(isLock)
    local composeData = Table_Compose[data.id]
    if isLock then
      self.tip.text = composeData.MenuDes or ""
      self.tipIcon:UpdateAnchors()
    end
    self.cost.text = StringUtil.NumThousandFormat(composeData.ROB)
    self:UpdateConfirmBtn()
  end
end
function CardMakeView:HandleSelect(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data.itemData
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end
function CardMakeView:HandleMaterialTip(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data.itemData
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
function CardMakeView:HandleItemUpdate()
  local chooseData = CardMakeProxy.Instance:GetChoose()
  if chooseData then
    self:UpdateMaterial(chooseData)
    self:UpdateConfirmBtn()
  end
end
function CardMakeView:HandleExchangeCardItem(note)
  local data = note.body
  if data and data.charid == Game.Myself.data.id then
    self:CloseSelf()
  end
end
function CardMakeView:HandleRemoveNpc(note)
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
function CardMakeView:UpdateCard()
  local data = CardMakeProxy.Instance:FilterCard(self.filterData)
  if data then
    self.wrapHelper:UpdateInfo(data)
  end
end
function CardMakeView:UpdateMaterial(data)
  if data then
    data:ClearCount()
    self.materialCtl:ResetDatas(data.materialItems)
  end
end
function CardMakeView:ResetCard()
  self:UpdateCard()
  self.wrapHelper:ResetPosition()
end
function CardMakeView:UpdateConfirmBtn()
  self.canMake = CardMakeProxy.Instance:CanMake()
  self:SetConfirm(not self.canMake)
end
function CardMakeView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.ComposeCard)
  self.skipBtn.gameObject:SetActive(not isShow)
end
function CardMakeView:Confirm()
  if self.canMake then
    local chooseData = CardMakeProxy.Instance:GetChoose()
    local data = Table_Compose[chooseData.id]
    if MyselfProxy.Instance:GetROB() < data.ROB then
      MsgManager.ShowMsgByID(1)
      return
    end
    if CardMakeProxy.Instance:IsCostGreatCard(chooseData.id) then
      MsgManager.ConfirmMsgByID(1150, function()
        self:CallExchangeCardItem()
      end)
    else
      self:CallExchangeCardItem()
    end
  end
end
function CardMakeView:Skip()
  TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn, NGUIUtil.AnchorSide.Right, {200, 0})
end
function CardMakeView:CallExchangeCardItem()
  local chooseData = CardMakeProxy.Instance:GetChoose()
  local skipValue = CardMakeProxy.Instance:IsSkipGetEffect(skipType)
  ServiceItemProxy.Instance:CallExchangeCardItemCmd(CardMakeProxy.MakeType.Compose, self.npcId, nil, nil, chooseData.itemData.staticData.id, skipValue)
end
function CardMakeView:SetConfirm(isGray)
  if isGray then
    self.confirmButton.CurrentState = 1
    self.confirmLabel.effectStyle = UILabel.Effect.None
  else
    self.confirmButton.CurrentState = 0
    self.confirmLabel.effectStyle = UILabel.Effect.Outline
  end
end
function CardMakeView:ClearChooseCard()
  local chooseData = CardMakeProxy.Instance:GetChoose()
  if chooseData then
    local cell
    local cells = self.wrapHelper:GetCellCtls()
    for i = 1, #cells do
      cell = cells[i]
      if cell.data and cell.data.id == chooseData.id then
        cell:SetChoose(false)
        break
      end
    end
  end
end
function CardMakeView:ClearChooseData()
  local chooseData = CardMakeProxy.Instance:GetChoose()
  if chooseData then
    local data = CardMakeProxy.Instance:GetCard()
    if data then
      for i = 1, #data do
        if data[i].id == chooseData.id then
          data[i]:SetChoose(false)
          break
        end
      end
    end
  end
end
