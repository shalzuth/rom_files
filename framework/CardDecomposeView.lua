CardDecomposeView = class("CardDecomposeView", ContainerView)
CardDecomposeView.ViewType = UIViewType.NormalLayer
local zeroVector3 = LuaVector3.zero
local skipType = SKIPTYPE.CardDecompose
function CardDecomposeView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function CardDecomposeView:FindObjs()
  self.addItemBtn = self:FindGO("AddItemBtn")
  self.itemRoot = self:FindGO("ItemRoot")
  self.materialRoot = self:FindGO("MaterialRoot")
  self.materialNum = self:FindGO("MaterialNum"):GetComponent(UILabel)
  self.targetRoot = self:FindGO("TargetRoot")
  self.itemName = self:FindGO("ItemName"):GetComponent(UILabel)
  self.totalCost = self:FindGO("TotalCost"):GetComponent(UILabel)
  self.chooseBord = self:FindGO("ChooseBord")
  self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  if OverseaHostHelper:isJP() then
    local tiipLabel = self:FindGO("TipLabel")
    local tipS = self:FindGO("Sprite", tiipLabel)
    tipS.transform.localPosition = Vector3(-210, 0, 0)
  end
end
function CardDecomposeView:AddEvts()
  local closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(closeButton, function()
    SceneUIManager.Instance:PlayerSpeak(self.npcId, ZhString.CardMark_EndDialog)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.addItemBtn, function()
    local data = CardMakeProxy.Instance:GetDecomposeCard()
    if #data > 0 then
      self.chooseBord:SetActive(true)
    else
      MsgManager.ShowMsgByID(391)
      self.chooseBord:SetActive(false)
    end
  end)
  local closeBtn = self:FindGO("CloseBtn")
  self:AddClickEvent(closeBtn, function()
    self.chooseBord:SetActive(false)
  end)
  EventDelegate.Add(self.filter.onChange, function()
    if self.filter.data == nil then
      return
    end
    if self.filterData ~= self.filter.data then
      self.filterData = self.filter.data
      self:ResetCard()
    end
  end)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:Skip()
  end)
  self:AddClickEvent(self.targetRoot, function()
    self.tipData.itemdata = self.targetCell.data
    self:ShowItemTip(self.tipData, self.targetCell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end)
  self:AddClickEvent(self.materialRoot, function()
    self.tipData.itemdata = self.materialCell.data
    self:ShowItemTip(self.tipData, self.materialCell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end)
  local decomposeBtn = self:FindGO("DecomposeBtn")
  self:AddClickEvent(decomposeBtn, function()
    self:Decompose()
  end)
  self:AddHelpButtonEvent()
end
function CardDecomposeView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateTotalCost)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemExchangeCardItemCmd, self.HandleExchangeCardItem)
end
function CardDecomposeView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.npcId = self.viewdata.viewdata.npcdata.data.id
  local wrapConfig = ReusableTable.CreateTable()
  wrapConfig.wrapObj = self:FindGO("Container")
  wrapConfig.pfbNum = 6
  wrapConfig.cellName = "EquipChooseCell"
  wrapConfig.control = EquipChooseCell
  wrapConfig.dir = 1
  self.wrapHelper = WrapCellHelper.new(wrapConfig)
  self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self.wrapHelper:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.ClickItemIcon, self)
  ReusableTable.DestroyAndClearTable(wrapConfig)
  local obj = self:LoadPreferb("cell/ItemCell", self.targetRoot)
  obj.transform.localPosition = zeroVector3
  self.targetCell = ItemCell.new(obj)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)
  local material = self:LoadPreferb("cell/ItemCell", self.materialRoot)
  material.transform.localPosition = zeroVector3
  self.materialCell = ItemCell.new(material)
  local _CardConfig = GameConfig.Card
  local moneyIcon = self:FindGO("Sprite", self.totalCost.gameObject):GetComponent(UISprite)
  local money = Table_Item[_CardConfig.decompose_price_id]
  if money then
    IconManager:SetItemIcon(money.Icon, moneyIcon)
  end
  self:UpdateTotalCost()
  CardMakeProxy.Instance:InitDecomposeCard()
  self:InitFilter()
  self:InitMaterial()
  self:UpdateCard()
  self:UpdateSkip()
end
function CardDecomposeView:InitFilter()
  self.filter:Clear()
  local decomposeFilter = GameConfig.CardMake.DecomposeFilter
  local rangeList = CardMakeProxy.Instance:GetFilter(decomposeFilter)
  for i = 1, #rangeList do
    local rangeData = decomposeFilter[rangeList[i]]
    self.filter:AddItem(rangeData, rangeList[i])
  end
  if #rangeList > 0 then
    local range = rangeList[1]
    self.filterData = range
    local rangeData = decomposeFilter[range]
    self.filter.value = rangeData
  end
end
function CardDecomposeView:InitMaterial()
  self.materialCell:SetData(CardMakeProxy.Instance:GetDecomposeMaterialItemData())
end
function CardDecomposeView:UpdateCard()
  local data = CardMakeProxy.Instance:FilterDecomposeCard(self.filterData)
  if data then
    self.wrapHelper:UpdateInfo(data)
  end
end
function CardDecomposeView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.DecomposeCard)
  self.skipBtn.gameObject:SetActive(not isShow)
end
function CardDecomposeView:UpdateMaterial(data)
  local num = 0
  if data ~= nil then
    num = GameConfig.Card.decompose_base[data.staticData.Quality] or 0
  end
  self.materialNum.text = string.format(ZhString.CardDecompose_Material, num)
end
function CardDecomposeView:UpdateTotalCost()
  self.totalCost.text = StringUtil.NumThousandFormat(GameConfig.Card.decompose_price_count)
  if self:CheckEnoughMoney() then
    ColorUtil.DeepGrayUIWidget(self.totalCost)
  else
    ColorUtil.RedLabel(self.totalCost)
  end
end
function CardDecomposeView:ResetCard()
  self:UpdateCard()
  self.wrapHelper:ResetPosition()
end
function CardDecomposeView:ClickTargetCell(cell)
  local data = cell.data
  if data ~= nil then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
function CardDecomposeView:ClickItem(cell)
  local data = cell.data
  if data ~= nil then
    self.addItemBtn:SetActive(false)
    self.itemRoot:SetActive(true)
    self.targetCell:SetData(data)
    self.targetCell:UpdateNumLabel(1)
    self.itemName.text = data:GetName()
    self:UpdateMaterial(data)
  end
end
function CardDecomposeView:ClickItemIcon(cell)
  local data = cell.data
  if data ~= nil then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end
function CardDecomposeView:Skip()
  TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn, NGUIUtil.AnchorSide.Right, {150, 0})
end
function CardDecomposeView:Decompose()
  if not self:CheckEnoughMoney() then
    MsgManager.ShowMsgByID(1)
    return
  end
  if self:CheckConfirm(self.targetCell.data) then
    local id = 1151
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
    if dont == nil then
      MsgManager.DontAgainConfirmMsgByID(id, function()
        self:CallDecompose()
      end)
    else
      self:CallDecompose()
    end
  else
    self:CallDecompose()
  end
end
function CardDecomposeView:CallDecompose()
  local skipValue = CardMakeProxy.Instance:IsSkipGetEffect(skipType)
  local material = ReusableTable.CreateArray()
  material[1] = self.targetCell.data.id
  ServiceItemProxy.Instance:CallExchangeCardItemCmd(CardMakeProxy.MakeType.Decompose, self.npcId, material, nil, nil, skipValue)
  ReusableTable.DestroyAndClearArray(material)
end
function CardDecomposeView:CheckEnoughMoney()
  local _CardConfig = GameConfig.Card
  local priceId = _CardConfig.decompose_price_id
  local money = HappyShopProxy.Instance:GetItemNum(priceId)
  if money >= _CardConfig.decompose_price_count then
    return true
  end
  return false
end
function CardDecomposeView:CheckConfirm(data)
  local quality = data.staticData.Quality
  local config = GameConfig.Card.confirm_quality
  for i = 1, #config do
    if quality == config[i] then
      return true
    end
  end
  return false
end
function CardDecomposeView:HandleItemUpdate()
  CardMakeProxy.Instance:InitDecomposeCard()
  self:ResetCard()
end
function CardDecomposeView:HandleExchangeCardItem(note)
  local data = note.body
  if data ~= nil and data.charid == Game.Myself.data.id then
    self:CloseSelf()
  end
end
