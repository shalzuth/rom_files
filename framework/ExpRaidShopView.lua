autoImport("ExpRaidShopItemCell")
autoImport("ExpRaidBuyItemCell")
autoImport("HappyShop")
ExpRaidShopView = class("ExpRaidShopView", HappyShop)
function ExpRaidShopView:FindObjs()
  ExpRaidShopView.super.FindObjs(self)
  self:InitInRaidLabelCell()
end
function ExpRaidShopView:InitInRaidLabelCell()
  local go = self:LoadCellPfb("ExpRaidShopInRaidLabelCell")
  go.transform:SetParent(self.moneySprite[2].gameObject.transform, false)
  self.inRaidLabel = go:GetComponent(UILabel)
end
function ExpRaidShopView:InitBuyItemCell()
  local go = self:LoadCellPfb("HappyShopBuyItemCell")
  self.buyCell = ExpRaidBuyItemCell.new(go)
  self.closeWhenClickOtherPlace = self.buyCell.gameObject:GetComponent(CloseWhenClickOtherPlace)
end
function ExpRaidShopView:AddEvts()
  function self.ItemScrollView.onDragStarted()
    self.selectedGO = nil
    self.buyCell.gameObject:SetActive(false)
    TipsView.Me():HideCurrent()
  end
  function self.closeWhenClickOtherPlace.callBack()
    if self.selectedGO then
      local size = NGUIMath.CalculateAbsoluteWidgetBounds(self.selectedGO.transform)
      if not self.uiCamera then
        self.uiCamera = NGUITools.FindCameraForLayer(self.selectedGO.layer)
      end
      local pos = self.uiCamera:ScreenToWorldPoint(Input.mousePosition)
      if not size:Contains(Vector3(pos.x, pos.y, pos.z)) then
        self.selectedGO = nil
      elseif not self.buyCell.gameObject.activeSelf then
        self.buyCell.gameObject:SetActive(true)
      end
    end
  end
end
function ExpRaidShopView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateExpRaidScore)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
end
function ExpRaidShopView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local itemContainer = self:FindGO("shop_itemContainer")
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = 6,
    cellName = "ShopItemCell",
    control = ExpRaidShopItemCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.itemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
end
function ExpRaidShopView:OnEnter()
  ExpRaidShopView.super.super.OnEnter(self)
  self:HandleCameraQuestStart()
  self:InitUI()
end
function ExpRaidShopView:OnExit()
  self:CameraReset()
  self.buyCell:Exit()
  TipsView.Me():HideCurrent()
  ExpRaidShopView.super.super.OnExit(self)
end
function ExpRaidShopView:InitUI()
  self:UpdateShopInfo(true)
  self:UpdateExpRaidScore()
  self.buyCell.gameObject:SetActive(false)
  self.ItemScrollView.gameObject:SetActive(true)
  self.specialRoot:SetActive(false)
  self.skipBtn.gameObject:SetActive(false)
  self.toggleRoot:SetActive(false)
  if self.showtoggle then
    self.showtoggle:SetActive(false)
  end
  self.inRaidLabel.text = ZhString.ExpRaid_ShopInRaidLabel
  for _, sprite in pairs(self.moneySprite) do
    IconManager:SetUIIcon("exp_integral", sprite)
    sprite.gameObject:SetActive(true)
  end
end
function ExpRaidShopView:HandleClickItem(cellctl)
  if self.selectedCellCtl ~= cellctl then
    if self.selectedCellCtl then
      self.selectedCellCtl:SetChoose(false)
    end
    cellctl:SetChoose(true)
    self.selectedCellCtl = cellctl
  end
  if self.selectedGO == cellctl.gameObject then
    self.selectedGO = nil
    return
  end
  self.selectedGO = cellctl.gameObject
  if cellctl.data then
    self:UpdateBuyItemInfo(cellctl.data)
  end
end
function ExpRaidShopView:HandleClickIconSprite(cellctl)
  self.tipData.itemdata = cellctl.data
  self:ShowItemTip(self.tipData, self.LeftStick)
  self.buyCell.gameObject:SetActive(false)
  self.selectedGO = nil
end
function ExpRaidShopView:HandleCameraQuestStart()
  local npcData = ExpRaidProxy.Instance:GetShopNpc()
  if npcData then
    self:CameraFaceTo(npcData.assetRole.completeTransform, CameraConfig.HappyShop_ViewPort, CameraConfig.HappyShop_Rotation)
  end
end
function ExpRaidShopView:UpdateShopInfo(isReset)
  local data = ExpRaidProxy.Instance:GetShopItemDataOfCurrentNpc()
  if data then
    self.itemWrapHelper:UpdateInfo(data)
  else
    LogUtility.Error("ExpRaidShopView.UpdateShopInfo:data is nil")
  end
  if isReset == true then
    self.itemWrapHelper:ResetPosition()
  end
end
function ExpRaidShopView:UpdateExpRaidScore()
  self.moneyLabel[1].text = ExpRaidProxy.Instance:GetExpRaidScore()
  self.moneyLabel[2].text = ExpRaidProxy.Instance:GetExpRaidScoreInRaid()
end
function ExpRaidShopView:UpdateBuyItemInfo(data)
  if data then
    self.buyCell:SetData(data)
    TipsView.Me():HideCurrent()
  end
end
function ExpRaidShopView:RecvBuyShopItem(note)
  self:UpdateShopInfo()
end
