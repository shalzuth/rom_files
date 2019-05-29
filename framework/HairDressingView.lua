autoImport("ShopDressingView")
HairDressingView = class("HairDressingView", ShopDressingView)
HairDressingView.ViewType = UIViewType.NormalLayer
autoImport("HairCutPage")
autoImport("HairDyePage")
local shoptype = ShopDressingProxy.Instance:GetShopType()
local shopID = ShopDressingProxy.Instance:GetShopId()
HairDressingView.TabName = {
  [1] = ZhString.HairDressingView_HairCutPageTitle,
  [2] = ZhString.HairDressingView_HairDyePageTitle
}
function HairDressingView:FindObjs()
  HairDressingView.super.FindObjs(self)
  self.pageDragScrollView = self:FindGO("page"):GetComponent(UIDragScrollView)
  self.cutPage = self:FindGO("cutPage")
  self.cutScrollView = self.cutPage:GetComponent(UIScrollView)
  self.dyePage = self:FindGO("dyePage")
  self.dyeScrollView = self.dyePage:GetComponent(UIScrollView)
  self.headgearToggle = self:FindGO("headgearToggle"):GetComponent(UIToggle)
  self.HideHeadgearLabel = self:FindGO("HideHeadgearLabel"):GetComponent(UILabel)
  self.hairCutToggle = self:FindGO("hairCutToggle")
  self.hairDyeToggle = self:FindGO("hairDyeToggle")
  self.hairCutLabel = self:FindGO("NameLabel", self.hairCutToggle):GetComponent(UILabel)
  self.hairDyeLabel = self:FindGO("NameLabel", self.hairDyeToggle):GetComponent(UILabel)
  self.hairCutTabIconSp = self:FindGO("Icon", self.hairCutToggle):GetComponent(UISprite)
  self.hairDyeTabIconSp = self:FindGO("Icon", self.hairDyeToggle):GetComponent(UISprite)
  self:Hide(self.dyePage)
  self.chargeNum.transform.localPosition = Vector3(102, 0, 0)
  OverseaHostHelper:FixLabelOverV1(self.chargeNum, 3, 130)
end
function HairDressingView:InitUIView()
  self.super.InitUIView(self)
  self.HairCutPage = self:AddSubView("HairCutPage", HairCutPage)
  self.HairDyePage = self:AddSubView("HairDyePage", HairDyePage)
  self.hairCutLabel.text = ZhString.HairDressingView_HairCutPageTitle
  self.hairDyeLabel.text = ZhString.HairDressingView_HairDyePageTitle
  self.HideHeadgearLabel.text = ZhString.HairDressingView_HideHeadgear
  self.pageType = 1
  local iconActive, nameLabelActive
  if not GameConfig.SystemForbid.TabNameTip then
    iconActive = true
    nameLabelActive = false
  else
    iconActive = false
    nameLabelActive = true
  end
  self.hairCutTabIconSp.gameObject:SetActive(iconActive)
  self.hairDyeTabIconSp.gameObject:SetActive(iconActive)
  self.hairCutLabel.gameObject:SetActive(nameLabelActive)
  self.hairDyeLabel.gameObject:SetActive(nameLabelActive)
  self:SetCurrentTabIconColor(self.hairCutToggle)
end
function HairDressingView:AddEvts()
  self.super.AddEvts(self)
  self:AddClickEvent(self.headgearToggle.gameObject, function(g)
    self:ClickHeadGearToggle()
  end)
  self:AddTabChangeEvent(self.hairCutToggle, self.cutPage, PanelConfig.HairCutPage)
  self:AddTabChangeEvent(self.hairDyeToggle, self.dyePage, PanelConfig.HairDyePage)
  local toggleList = {
    self.hairCutToggle,
    self.hairDyeToggle
  }
  for i, v in ipairs(toggleList) do
    do
      local longPress = v:GetComponent(UILongPress)
      function longPress.pressEvent(obj, state)
        self:PassEvent(TipLongPressEvent.HairDressingView, {state, i})
      end
    end
    break
  end
  self:AddEventListener(TipLongPressEvent.HairDressingView, self.HandleLongPress, self)
end
local args = {}
function HairDressingView:TabChangeHandler(key)
  HairDressingView.super.TabChangeHandler(self, key)
  if self.pageType == key then
    return
  end
  self.pageType = key
  if key == 1 then
    self.pageDragScrollView.scrollView = self.cutScrollView
    self.cutScrollView:ResetPosition()
    self.chargeTitle.text = ZhString.HairdressingView_cost
    if self.HairDyePage.chooseCtl then
      self.HairDyePage.chooseCtl = nil
      self.HairDyePage:SetChoose()
    end
    self.HairCutPage:InitPageView()
  elseif key == 2 then
    self.pageDragScrollView.scrollView = self.dyeScrollView
    self.dyeScrollView:ResetPosition()
    self.chargeTitle.text = ZhString.HairDressingView_consume
    if self.HairCutPage.chooseCtl then
      self.HairCutPage.chooseCtl = nil
      self.HairCutPage:SetChoose()
    end
    self.HairCutPage:Hide(self.HairCutPage.desc)
    self.HairCutPage:Hide(self.HairCutPage.menuDes)
    self.HairDyePage:InitPageView()
  end
  ShopDressingProxy.Instance.chooseData = {}
  TableUtility.ArrayClear(args)
  ShopDressingProxy.Instance:SetQueryData(args)
  self:DisableState()
  self:RefreshModel()
  self:SetCurrentTabIconColor(self.coreTabMap[key].go)
end
function HairDressingView:ClickHeadGearToggle()
  self:RefreshModel()
end
function HairDressingView:ClickReplaceBtn()
  local queryData = ShopDressingProxy.Instance:GetQueryData()
  local hasTicket = false
  shoptype = ShopDressingProxy.Instance:GetShopType()
  shopID = ShopDressingProxy.Instance:GetShopId()
  if queryData.type == ShopDressingProxy.DressingType.HAIR then
    if not queryData.id then
      return
    end
    local choosedata = ShopDressingProxy.Instance.chooseData
    if nil == choosedata then
      return
    end
    if ShopDressingProxy.Instance:bSameItem(ShopDressingProxy.DressingType.HAIR) then
      MsgManager.FloatMsgTableParam(nil, ZhString.HairDressingView_bSameHair)
      return
    end
    local tempcsv = ShopProxy.Instance:GetShopItemDataByTypeId(shoptype, shopID, choosedata.id)
    if tempcsv:CheckCanRemove() then
      MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_overtime)
      return
    end
    local tempId = tempcsv.goodsID
    local hairID = ShopDressingProxy.Instance:GetHairStyleIDByItemID(tempId)
    if not hairID or not ShopDressingProxy.Instance:bActived(hairID, ShopDressingProxy.DressingType.HAIR) then
      local lockmsg = tempcsv:GetQuestLockDes()
      if lockmsg then
        MsgManager.FloatMsgTableParam(nil, lockmsg)
      end
      return
    end
    local preCost = tempcsv.PreCost
    hasTicket = self:_bHasTicket(preCost)
    if not hasTicket then
      local moneyID = choosedata.ItemID
      local itemNum = choosedata.ItemCount * choosedata.Discount * 0.01
      local curMoney = ShopDressingProxy.Instance:GetCurMoneyByID(moneyID)
      if itemNum > curMoney then
        MsgManager.ShowMsgByIDTable(1)
        return
      end
    end
  elseif queryData.type == ShopDressingProxy.DressingType.HAIRCOLOR then
    if nil == ShopDressingProxy.Instance.chooseData then
      return
    end
    if not queryData.id then
      return
    end
    if ShopDressingProxy.Instance:bSameItem(ShopDressingProxy.DressingType.HAIRCOLOR) then
      MsgManager.FloatMsgTableParam(nil, ZhString.HairDressingView_bSameColor)
      return
    end
    local tempcsv = ShopProxy.Instance:GetShopItemDataByTypeId(shoptype, shopID, queryData.id)
    if tempcsv:CheckCanRemove() then
      MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_overtime)
      return
    end
    local preCost = tempcsv.PreCost
    hasTicket = self:_bHasTicket(preCost)
    if not hasTicket then
      local dyeID = tempcsv.hairColorID
      local result = ShopDressingProxy.Instance:bDyeMaterialEnough(dyeID)
      if not result then
        MsgManager.FloatMsgTableParam(nil, ZhString.HairDressingView_dyeNotEnough)
        return
      end
    end
  end
  ShopDressingProxy.Instance:CallReplaceDressing(queryData.id, queryData.count)
end
function HairDressingView:_bHasTicket(id)
  if id then
    local ticketNum = BagProxy.Instance:GetAllItemNumByStaticID(id)
    return ticketNum > 0
  else
    return false
  end
end
function HairDressingView:RefreshSelectedROB(type, precost, constID, costCount, hairID)
  self:Show(self.chargeNum)
  self:RefreshMoney()
  local hasTicket = false
  if type == 1 then
    self.chargeNum.text = costCount
    self.chargeTitle.text = ZhString.HairdressingView_cost
    local curCount = ShopDressingProxy.Instance:GetCurMoneyByID(constID)
    if costCount <= curCount then
      self.chargeNum.color = ColorUtil.ButtonLabelBlue
    else
      ColorUtil.RedLabel(self.chargeWidget)
    end
    hasTicket = self:_bHasTicket(precost)
    local flag = costCount <= curCount and ShopDressingProxy.Instance:bActived(hairID, ShopDressingProxy.DressingType.HAIR)
    self:SetReplaceBtnState(hasTicket and true or flag)
    local itemStaticData = Table_Item[constID]
    if itemStaticData and itemStaticData.Icon then
      IconManager:SetItemIcon(itemStaticData.Icon, self.itemIcon)
    end
  elseif type == 2 then
    local itemData = Table_Item[constID]
    local iconName = itemData.NameZh or ""
    self.chargeNum.text = iconName .. " x " .. costCount
    local bEnough = false
    local bagItem = BagProxy.Instance:GetItemByStaticID(constID)
    if bagItem and costCount <= bagItem.num then
      bEnough = true
      self.chargeNum.color = ColorUtil.ButtonLabelBlue
    else
      bEnough = false
      ColorUtil.RedLabel(self.chargeWidget)
    end
    hasTicket = self:_bHasTicket(precost)
    self:SetReplaceBtnState(hasTicket and true or bEnough)
    self.chargeTitle.text = ZhString.HairDressingView_consume
    IconManager:SetItemIcon(itemData.Icon, self.itemIcon)
  end
  self:Show(self.itemIcon)
end
function HairDressingView:RecvUseDressing(note)
  local id = note.body.id
  local usetype = note.body.type
  if ShopDressingProxy.DressingType.HAIR == usetype then
    ShopDressingProxy.Instance.originalHair = id
  elseif ShopDressingProxy.DressingType.HAIRCOLOR == usetype then
    ShopDressingProxy.Instance.originalHairColor = id
  elseif ShopDressingProxy.DressingType.ClothColor == usetype then
    ShopDressingProxy.Instance.originalBodyColor = id
  end
  self:RefreshModel()
end
function HairDressingView:OnEnter()
  self.super.OnEnter(self)
  self:CameraRotateToMe()
end
function HairDressingView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  if not GameConfig.SystemForbid.TabNameTip then
    local name = string.gsub(HairDressingView.TabName[index], "\n", "")
    if isPressing then
      local backgroundSp = GameObjectUtil.Instance:DeepFindChild(self.coreTabMap[index].go, "Background"):GetComponent(UISprite)
      TipManager.Instance:TryShowHorizontalTabNameTip(name, backgroundSp, NGUIUtil.AnchorSide.Left)
    else
      TipManager.Instance:CloseTabNameTipWithFadeOut()
    end
  end
end
function HairDressingView:ResetTabIconColor()
  self.hairCutTabIconSp.color = ColorUtil.TabColor_White
  self.hairDyeTabIconSp.color = ColorUtil.TabColor_White
end
function HairDressingView:SetCurrentTabIconColor(currentTabGo)
  self:ResetTabIconColor()
  if not currentTabGo then
    return
  end
  local iconSp = GameObjectUtil.Instance:DeepFindChild(currentTabGo, "Icon"):GetComponent(UISprite)
  if not iconSp then
    return
  end
  iconSp.color = ColorUtil.TabColor_DeepBlue
end
