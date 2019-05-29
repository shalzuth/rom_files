autoImport("UITableListCtrl")
autoImport("UIModelMonthlyVIP")
autoImport("UIModelZenyShop")
autoImport("UIListItemViewControllerVIPDescription")
autoImport("UIListItemModelVIPDescription")
autoImport("UIListItemViewControllerItem")
autoImport("UIPriceDiscount")
autoImport("FunctionADBuiltInTyrantdb")
autoImport("FuncZenyShop")
autoImport("PurchaseDeltaTimeLimit")
autoImport("ChargeComfirmPanel")
UISubViewControllerMonthlyVIP = class("UISubViewControllerMonthlyVIP", SubView)
UISubViewControllerMonthlyVIP.instance = nil
local gReusableTable = {}
function UISubViewControllerMonthlyVIP:Init()
end
function UISubViewControllerMonthlyVIP:OnExit()
  self:CancelListenServerResponse()
end
function UISubViewControllerMonthlyVIP:MyInit()
  UISubViewControllerMonthlyVIP.instance = self
  self.gameObject = self:LoadPreferb("view/UISubViewMonthlyVIP", nil, true)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:RegisterClickEvent()
  self:GetModelSet()
  FuncZenyShop.Instance():AddProductPurchase(self.monthlyVIPShopItemConf.ProductID, function()
    self:OnClickForButtonPurchaseCard(0)
  end)
  EventManager.Me():PassEvent(ZenyShopEvent.CanPurchase, self.monthlyVIPShopItemConf.ProductID)
  for i = 1, #self.epVIPCards do
    do
      local epVIPCard = self.epVIPCards[i]
      local productConfID = epVIPCard.id2
      if productConfID == nil or productConfID == 0 then
        productConfID = epVIPCard.id1
      end
      local productID = Table_Deposit[productConfID].ProductID
      FuncZenyShop.Instance():AddProductPurchase(productID, function()
        self:OnClickForButtonPurchaseCard(i)
      end)
      EventManager.Me():PassEvent(ZenyShopEvent.CanPurchase, productID)
    end
    break
  end
  self:OnScrollViewDragFinished()
  self.showCardIndex = 0
  self.showContentIndex = 1
  self:LoadView()
  self:ListenServerResponse()
  self.isInit = true
  self:RefreshZenyCell()
  self:ShowCard(self.showCardIndex)
end
function UISubViewControllerMonthlyVIP:GetVipCardId(card)
  if card == nil then
    return nil
  end
  if card.id2 ~= nil and card.id2 ~= 0 then
    return card.id2
  end
  return card.id1
end
function UISubViewControllerMonthlyVIP:GetGameObjects()
  self.goMonthlyVIPDesp = self:FindGO("MonthlyVIPDesp", self.gameObject)
  self.goDescriptionsList = self:FindGO("DescriptionsList", self.goMonthlyVIPDesp)
  self.goSv = self:FindGO("DescriptionsList"):GetComponent(UIScrollView)
  self.goPanel = self:FindGO("DescriptionsList"):GetComponent(UIPanel)
  self.goListArrow = self:FindGO("Arrow", self.goMonthlyVIPDesp)
  self.goCard = self:FindGO("Card", self.gameObject)
  self.texCard = self.goCard:GetComponent(UITexture)
  self.goBoardM = self:FindGO("Board_MonthlyVIPCard", self.gameObject)
  self.goBoardE = self:FindGO("Board_EPVIPCard", self.gameObject)
  self.goBoard1E = self:FindGO("Board1_EPVIPCard", self.gameObject)
  self.goValidTime = self:FindGO("ValidTime", self.gameObject)
  self:Hide(self.goValidTime)
  self.goBTNPurchaseMonthlyVIP = self:FindGO("BTN_Purchase", self.gameObject)
  self.goBTNTitlePurchaseMonthlyVIP = self:FindGO("Title", self.goBTNPurchaseMonthlyVIP)
  self.labBTNTitlePurchaseMonthlyVIP = self.goBTNTitlePurchaseMonthlyVIP:GetComponent(UILabel)
  self.goTip = self:FindGO("Tip", self.gameObject)
  self.goExpirationTime = self:FindGO("ExpirationTime", self.gameObject)
  self.labExpirationTime = self.goExpirationTime:GetComponent(UILabel)
  self.goYearAndMonth = self:FindGO("YearAndMonth", self.gameObject)
  self.goLabYear = self:FindGO("Year", self.goYearAndMonth)
  self.labYear = self.goLabYear:GetComponent(UILabel)
  self.goMonth = self:FindGO("Month", self.goYearAndMonth)
  self.goLabMonth = self:FindGO("Lab", self.goMonth)
  self.labYear.transform.localPosition = Vector3(0, -4, 0)
  self.goLabMonth.transform.localPosition = Vector3(10, -10, 0)
  self.labMonth = self.goLabMonth:GetComponent(UILabel)
  self.goEPVIPReward = self:FindGO("EPVIPReward", self.gameObject)
  self.goRewardList = self:FindGO("ItemsList", self.goEPVIPReward)
  self.goRewardRoot = self:FindGO("ItemsRoot", self.goEPVIPReward)
  self.goBTN_LeftPage = self:FindGO("BTN_LeftPage", self.gameObject)
  self.goBGBTN_LeftPage = self:FindGO("BG", self.goBTN_LeftPage)
  self.goBTN_RightPage = self:FindGO("BTN_RightPage", self.gameObject)
  self.goBGBTN_RightPage = self:FindGO("BG", self.goBTN_RightPage)
  self.goBCForScrollDesp = self:FindGO("BCForScroll", self.goMonthlyVIPDesp)
  self.goBCForScrollReward = self:FindGO("BCForScroll", self.goEPVIPReward)
  self.goEPNumber = self:FindGO("EPNumber", self.goBoard1E)
  self.labEP = self.goEPNumber:GetComponent(UILabel)
  self.goDiscount = self:FindGO("Discount")
  self.goPercent = self:FindGO("Percent", self.goDiscount)
  self.spPercentBG = self:FindGO("BG", self.goPercent):GetComponent(UISprite)
  self.labPercent = self:FindGO("Value1", self.goPercent):GetComponent(UILabel)
  self.labPercentSymbol = self:FindGO("Value2", self.goPercent):GetComponent(UILabel)
  local sprite = self:FindGO("SaleIcon", self.goDiscount):GetComponent(UISprite)
  sprite.spriteName = "shop_icon_off"
  self.goOriginPrice = self:FindGO("OriginPrice")
  self.labOriginPrice = self:FindGO("Lab", self.goOriginPrice):GetComponent(UILabel)
  self.scrollViewReward = self.goRewardList:GetComponent(UIScrollView)
  local goDescriptionsRoot = self:FindGO("DescriptionsRoot")
  local wrapConfig = {
    wrapObj = goDescriptionsRoot,
    pfbNum = 7,
    cellName = "UIListItemMonthlyVIPDescription",
    control = UIListItemViewControllerVIPDescription
  }
  goDescriptionsRoot:GetComponent(UIWrapContent).itemSize = 90
  self.listControllerOfVIPDescriptions = WrapCellHelper.new(wrapConfig)
  self.helpButton = self:FindGO("HelpButton")
  self:AddClickEvent(self.helpButton, function()
    helplog("Click HelpButton")
    self:OpenHelpView()
  end)
end
function UISubViewControllerMonthlyVIP:RegisterButtonClickEvent()
  self:AddClickEvent(self.goBTNPurchaseMonthlyVIP, function()
    self:OnClickForButtonPurchaseCard()
  end)
  self:AddClickEvent(self.goBGBTN_LeftPage, function()
    self:OnClickForButtonLeftPage()
    self:RefreshZenyCell()
  end)
  self:AddClickEvent(self.goBGBTN_RightPage, function()
    self:OnClickForButtonRightPage()
    self:RefreshZenyCell()
  end)
end
function UISubViewControllerMonthlyVIP:RegisterClickEvent()
  self:AddClickEvent(self.goCard, function()
    self:OnClickForViewCard()
  end)
  self:AddClickEvent(self.goBCForScrollDesp, function()
    self:ShowCard(self.showCardIndex)
  end)
  self:AddClickEvent(self.goBCForScrollReward, function()
    self:ShowCard(self.showCardIndex)
  end)
end
function UISubViewControllerMonthlyVIP:GetModelSet()
  for _, v in pairs(Table_Deposit) do
    if v.Type == 2 then
      self.monthlyVIPShopItemConf = v
      break
    end
  end
  self.epVIPCards = UIModelZenyShop.Ins():GetEPVIPCards()
end
function UISubViewControllerMonthlyVIP:GetMonthCardConfigure()
  local year = UIModelMonthlyVIP.YearOfServer(-18000)
  local month = UIModelMonthlyVIP.MonthOfServer(-18000)
  for _, v in pairs(Table_MonthCard) do
    if v.Year == year and v.Month == month then
      return v
    end
  end
  return nil
end
function UISubViewControllerMonthlyVIP:LoadView()
  if self.showContentIndex == 1 or self.showContentIndex == 3 then
    self:ShowCard(self.showCardIndex)
  elseif self.showContentIndex == 2 then
    self:ShowMonthlyVIPDesp()
  elseif self.showContentIndex == 4 then
    self:ShowEPVIPReward()
  end
end
function UISubViewControllerMonthlyVIP:SetActive_Card(b)
  self.goCard:SetActive(b)
end
function UISubViewControllerMonthlyVIP:SetActive_MonthlyVIPDesp(b)
  self.goMonthlyVIPDesp:SetActive(b)
  self.goBoardM:SetActive(b)
  self.goYearAndMonth:SetActive(b)
end
function UISubViewControllerMonthlyVIP:SetActive_EPVIPReward(b)
  self.goEPVIPReward:SetActive(b)
end
function UISubViewControllerMonthlyVIP:SetActive_EPBoard(b)
  self.goBoard1E:SetActive(b)
  self.goBoardE:SetActive(b)
  self.goEPNumber:SetActive(b)
  self.helpButton:SetActive(false)
end
function UISubViewControllerMonthlyVIP:SetActive_ExpirationTime(b)
  self.goExpirationTime:SetActive(b)
end
function UISubViewControllerMonthlyVIP:SetActive_Discount(b)
  self.goDiscount:SetActive(b)
  self.goOriginPrice:SetActive(b)
end
function UISubViewControllerMonthlyVIP:ShowCard(show_index)
  self:SetActive_MonthlyVIPDesp(false)
  self:SetActive_EPVIPReward(false)
  self:SetActive_Card(true)
  if show_index == 0 then
    self:SetActive_EPBoard(false)
    self:SetActive_ExpirationTime(true)
    self:ShowMonthlyVIPTime()
    local monthCardConfigure = self:GetMonthCardConfigure()
    PictureManager.Instance:SetMonthCardUI(monthCardConfigure.Picture, self.texCard)
    self.labBTNTitlePurchaseMonthlyVIP.text = self:GetPriceString(self.monthlyVIPShopItemConf.Rmb)
    self:SetActive_Discount(false)
    self.showContentIndex = 1
    self.productConf = self.monthlyVIPShopItemConf
    helplog("UISubViewControllerMonthlyVIP:ShowCard 0")
  else
    helplog("UISubViewControllerMonthlyVIP:ShowCard 1")
    self:SetActive_EPBoard(true)
    self:SetActive_ExpirationTime(false)
    self:SetPurchaseBTNPos(true)
    local ep = self.epVIPCards[show_index].version
    helplog(self.epVIPCards[show_index])
    self.labEP.text = "EP " .. ep
    if math.floor(ep) == ep then
      self.labEP.text = "EP " .. ep .. ".0"
    end
    self.epCardConf = Table_Deposit[self.epVIPCards[show_index].id1]
    self.productConf = self.epCardConf
    PictureManager.Instance:SetEPCardUI(self.epCardConf.Picture, self.texCard)
    if self:IsDiscount() then
      self.discountEPCardConf = Table_Deposit[self.epVIPCards[show_index].id2]
      self.labBTNTitlePurchaseMonthlyVIP.text = self:GetPriceString(self.discountEPCardConf.Rmb)
      self.labOriginPrice.text = ZhString.HappyShop_originalCost .. self:GetPriceString(self.epCardConf.Rmb)
      local percent = math.ceil(self.discountEPCardConf.Rmb * 100 / self.epCardConf.Rmb)
      percent = 100 - percent
      UIPriceDiscount.SetDiscount(percent, self.spPercentBG, self.labPercent, self.labPercentSymbol)
      if percent == 0 or percent == 100 then
        self.goDiscount:SetActive(false)
      end
      self.productConf = self.discountEPCardConf
    else
      self.labBTNTitlePurchaseMonthlyVIP.text = self:GetPriceString(self.epCardConf.Rmb)
    end
    self.showContentIndex = 3
  end
end
function UISubViewControllerMonthlyVIP:ShowMonthlyVIPDesp(show_index)
  self:SetActive_MonthlyVIPDesp(true)
  self:SetActive_EPVIPReward(false)
  self:SetActive_Card(false)
  self:SetActive_EPBoard(false)
  self.listControllerOfVIPDescriptions:UpdateInfo(self:GetUIData())
  self.listControllerOfVIPDescriptions:ResetPosition()
  self:ShowMonthlyVIPTime()
  self.showContentIndex = 2
end
local SQR_MAGNITUDE = LuaVector3.SqrMagnitude
function UISubViewControllerMonthlyVIP:OnScrollViewDragFinished()
  self.InitScrollViewLocalPos = self.goSv.gameObject.transform.localPosition.y
  function self.goSv.onDragFinished()
    local b = self.goSv.bounds
    local constraint = self.goPanel:CalculateConstrainOffset(b.min, b.max)
    local curPos = self.goSv.gameObject.transform.localPosition.y
    if SQR_MAGNITUDE(constraint) > 0.1 and curPos > self.InitScrollViewLocalPos then
      self.goListArrow:SetActive(false)
    else
      self.goListArrow:SetActive(true)
    end
  end
end
function UISubViewControllerMonthlyVIP:GetUIData()
  monthlyVIPInfosForUITableListCtrl = {}
  local dynamicVIPDescription
  for _, v in pairs(GameConfig.DepositCard) do
    if v.type1 == 2 then
      dynamicVIPDescription = v.funcs
      break
    end
  end
  local monthConf = self:GetMonthCardConfigure()
  for k, _ in pairs(Table_DepositFunction) do
    local vipDescriptionConfID = k
    if table.ContainsValue(dynamicVIPDescription, vipDescriptionConfID) then
      local uiListItemModelVIPDescription = UIListItemModelVIPDescription.new(monthConf)
      uiListItemModelVIPDescription:SetDescriptionConfigID(vipDescriptionConfID)
      table.insert(monthlyVIPInfosForUITableListCtrl, uiListItemModelVIPDescription)
    end
  end
  return monthlyVIPInfosForUITableListCtrl
end
function UISubViewControllerMonthlyVIP:ShowEPVIPReward()
  self:SetActive_Card(false)
  self:SetActive_EPVIPReward(true)
  if self.listControllerOfReward == nil then
    self.uiGridOfReward = self.goRewardRoot:GetComponent(UIGrid)
    self.listControllerOfReward = UIGridListCtrl.new(self.uiGridOfReward, UIListItemViewControllerItem, "UIListItemItem")
  end
  local items
  local useItemID = self.epCardConf.ItemId
  local team = Table_UseItem[useItemID].UseEffect.id
  local items = ItemUtil.GetRewardItemIdsByTeamId(team)
  if items then
    self.listControllerOfReward:ResetDatas(items)
    self.itemsController = self.listControllerOfReward:GetCells()
    self.scrollViewReward:ResetPosition()
    self.showContentIndex = 4
  end
end
function UISubViewControllerMonthlyVIP:ShowMonthlyVIPTime()
  local year = UIModelMonthlyVIP.YearOfServer(-18000)
  local month = UIModelMonthlyVIP.MonthOfServer(-18000)
  self.labYear.text = tostring(year)
  if month < 10 then
    self.labMonth.text = "0" .. tostring(month)
  else
    self.labMonth.text = tostring(month)
  end
  local expirationTime = UIModelMonthlyVIP.Instance():Get_TimeOfExpirationMonthlyVIP()
  if expirationTime ~= nil then
    expirationTime = expirationTime - 18001
    local year = UIModelMonthlyVIP.YearOfUnixTimestamp(expirationTime)
    local month = UIModelMonthlyVIP.MonthOfUnixTimestamp(expirationTime)
    local day = UIModelMonthlyVIP.DayOfUnixTimestamp(expirationTime)
    self.labExpirationTime.text = string.format(ZhString.MouthCard_End, year, month, day)
    self:SetPurchaseBTNPos(false)
  else
    self.labExpirationTime.text = ""
  end
end
function UISubViewControllerMonthlyVIP:SetPurchaseBTNPos(b)
  local xValue
  if b then
    xValue = 117
  else
    xValue = 135
  end
  local posOfBTN = self.goBTNPurchaseMonthlyVIP.transform.localPosition
  posOfBTN.x = xValue
  self.goBTNPurchaseMonthlyVIP.transform.localPosition = posOfBTN
end
function UISubViewControllerMonthlyVIP:OnClickForButtonPurchaseCard()
  if self.showCardIndex == 0 then
    local productName = OverSea.LangManager.Instance():GetLangByKey(self.monthlyVIPShopItemConf.Desc)
    local productPrice = self.monthlyVIPShopItemConf.Rmb
    local productCount = self.monthlyVIPShopItemConf.Count
    local currencyType = self.monthlyVIPShopItemConf.CurrencyType
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShopConfirmPanel,
      viewdata = {
        data = {
          title = string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", "[0075BCFF]" .. productName .. "[-]", currencyType, FuncZenyShop.FormatMilComma(productPrice)),
          desc = ZhString.ShopConfirmDes,
          callback = function()
            self:RequestChargeQuery(self.monthlyVIPShopItemConf.id)
          end
        }
      }
    })
  elseif self.showCardIndex > 0 then
    local card = self.epVIPCards[self.showCardIndex]
    self.queryChargeAndPurchaseID = card.id2 or card.id1
    local cardConf = Table_Deposit[self.queryChargeAndPurchaseID]
    local productName = OverSea.LangManager.Instance():GetLangByKey(cardConf.Desc)
    local productPrice = cardConf.Rmb
    local productCount = cardConf.Count
    local currencyType = cardConf.CurrencyType
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShopConfirmPanel,
      viewdata = {
        data = {
          title = string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", "[0075BCFF]" .. productName .. "[-]", currencyType, FuncZenyShop.FormatMilComma(productPrice)),
          desc = ZhString.ShopConfirmDes,
          callback = function()
            local runtimePlatform = ApplicationInfo.GetRunPlatform()
            if runtimePlatform == RuntimePlatform.IPhonePlayer and BackwardCompatibilityUtil.CompatibilityMode_V17 then
              MsgManager.ConfirmMsgByID(3555, function()
                AppBundleConfig.JumpToIOSAppStore()
              end, nil)
              return
            end
            self:RequestQueryChargeCnt()
          end
        }
      }
    })
  end
end
function UISubViewControllerMonthlyVIP:OnClickForButtonLeftPage()
  if self.epVIPCards ~= nil then
    if self.showCardIndex <= 0 then
      self.showCardIndex = #self.epVIPCards
    else
      self.showCardIndex = self.showCardIndex - 1
    end
    self:ShowCard(self.showCardIndex)
  end
end
function UISubViewControllerMonthlyVIP:OnClickForButtonRightPage()
  if self.epVIPCards ~= nil then
    if self.showCardIndex >= #self.epVIPCards then
      self.showCardIndex = 0
    else
      self.showCardIndex = self.showCardIndex + 1
    end
    self:ShowCard(self.showCardIndex)
  end
end
function UISubViewControllerMonthlyVIP:OnClickForViewCard()
  if self.showContentIndex == 1 then
    self:ShowMonthlyVIPDesp()
  elseif self.showContentIndex == 3 then
    self:ShowEPVIPReward()
  end
end
function UISubViewControllerMonthlyVIP:ListenServerResponse()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeQueryCmd, self.OnReceiveChargeQuery, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
end
function UISubViewControllerMonthlyVIP:CancelListenServerResponse()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeQueryCmd, self.OnReceiveChargeQuery, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
end
local gReusableLuaColor = LuaColor(0, 0, 0, 0)
function UISubViewControllerMonthlyVIP:RefreshZenyCell()
  helplog("UISubViewControllerMonthlyVIP:RefreshZenyCell", self.showCardIndex)
  local left = ChargeComfirmPanel.left
  if left ~= nil then
    local currency = self.productConf and self.productConf.Rmb or 0
    helplog(currency, left)
    if left < currency then
      self:SetEnable(false)
    else
      self:SetEnable(true)
    end
  else
    helplog("unlimit")
    self:SetEnable(true)
  end
end
function UISubViewControllerMonthlyVIP:SetEnable(enable)
  local goBTNPurchaseCollider = self.goBTNPurchaseMonthlyVIP:GetComponent(BoxCollider)
  local back = self:FindGO("Normal", self.goBTNPurchaseMonthlyVIP):GetComponent(UISprite)
  if enable then
    gReusableLuaColor:Set(0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
    self.labBTNTitlePurchaseMonthlyVIP.effectColor = gReusableLuaColor
    back.color = Color.white
  else
    gReusableLuaColor:Set(0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
    self.labBTNTitlePurchaseMonthlyVIP.effectColor = gReusableLuaColor
    ColorUtil.ShaderGrayUIWidget(back)
  end
  goBTNPurchaseCollider.enabled = enable
end
function UISubViewControllerMonthlyVIP:RequestChargeQuery(shop_item_conf_id)
  ServiceUserEventProxy.Instance:CallChargeQueryCmd(shop_item_conf_id)
end
function UISubViewControllerMonthlyVIP:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end
function UISubViewControllerMonthlyVIP:OnReceiveChargeQuery(data)
  if self.monthlyVIPShopItemConf ~= nil and data.data_id == self.monthlyVIPShopItemConf.id then
    if data.ret then
      if PurchaseDeltaTimeLimit.Instance():IsEnd(self.monthlyVIPShopItemConf.ProductID) then
        self:Purchase()
        local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
        PurchaseDeltaTimeLimit.Instance():Start(self.monthlyVIPShopItemConf.ProductID, interval)
      else
        MsgManager.ShowMsgByID(49)
      end
    else
      local depositData = Table_Deposit[data.data_id]
      if depositData then
        if depositData.MonthLimit then
          local purchaseLimit = depositData.MonthLimit
          local tabFormatParams = {purchaseLimit}
          if depositData.Type == 2 then
            MsgManager.ShowMsgByIDTable(2645, tabFormatParams)
          elseif depositData.Type == 5 then
            MsgManager.ShowMsgByIDTable(31020, tabFormatParams)
          end
        end
      else
        redlog("not find dataid:" .. data.data_id)
      end
    end
  end
end
function UISubViewControllerMonthlyVIP:OnReceivePurchaseSuccess(message)
  local messageContent = message
  local confID = messageContent.dataid
  if confID and confID > 0 then
    local conf = Table_Deposit[confID]
    if conf.Type == 2 then
      PurchaseDeltaTimeLimit.Instance():End(conf.ProductID)
    elseif conf.Type == 5 then
      PurchaseDeltaTimeLimit.Instance():End(conf.ProductID)
    end
  end
end
function UISubViewControllerMonthlyVIP:OnReceiveQueryChargeCnt(data)
  if self.queryChargeAndPurchaseID ~= nil then
    local purchaseTimes = 0
    local info = data.info
    for i = 1, #info do
      local purchaseInfo = info[i]
      local productConfID = purchaseInfo.dataid
      if productConfID == self.queryChargeAndPurchaseID then
        purchaseTimes = purchaseInfo.count
      end
    end
    local productConf = Table_Deposit[self.queryChargeAndPurchaseID]
    if purchaseTimes < productConf.MonthLimit then
      if PurchaseDeltaTimeLimit.Instance():IsEnd(productConf.ProductID) then
        self:Purchase()
        local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
        PurchaseDeltaTimeLimit.Instance():Start(productConf.ProductID, interval)
      else
        MsgManager.ShowMsgByID(49)
      end
    else
      local tabFormatParams = {
        productConf.MonthLimit
      }
      if productConf.Type == 2 then
        MsgManager.ShowMsgByIDTable(2645, tabFormatParams)
      elseif productConf.Type == 5 then
        MsgManager.ShowMsgByIDTable(31020, tabFormatParams)
      end
    end
    self.queryChargeAndPurchaseID = nil
  end
end
function UISubViewControllerMonthlyVIP:IsDiscount()
  local retValue = false
  if self.showCardIndex > 0 then
    local card = self.epVIPCards[self.showCardIndex]
    retValue = 0 < card.id2
    if card.id2 == card.id1 then
      retValue = false
    end
  end
  self:SetActive_Discount(retValue)
  return retValue
end
function UISubViewControllerMonthlyVIP:GetPriceString(price)
  return self.monthlyVIPShopItemConf.CurrencyType .. " " .. FuncZenyShop.FormatMilComma(price)
end
function UISubViewControllerMonthlyVIP:Purchase()
  local productConf
  if self.showCardIndex == 0 then
    productConf = self.monthlyVIPShopItemConf
  else
    local card = self.epVIPCards[self.showCardIndex]
    local confID = self:GetVipCardId(card)
    productConf = Table_Deposit[confID]
  end
  local productID = productConf.ProductID
  if productID then
    local productName = productConf.Desc
    local productPrice = productConf.Rmb
    local productCount = 1
    if not Game.Myself or not Game.Myself.data or not Game.Myself.data.id then
      local roleID
    end
    if roleID then
      local roleInfo = ServiceUserProxy.Instance:GetRoleInfoById(roleID)
      local roleName = roleInfo and roleInfo.name or ""
      local roleGrade = MyselfProxy.Instance:RoleLevel() or 0
      local roleBalance = MyselfProxy.Instance:GetROB() or 0
      local server = FunctionLogin.Me():getCurServerData()
      if server == nil or not server.serverid then
        local serverID
      end
      if serverID then
        local currentServerTime = ServerTime.CurServerTime() / 1000
        TableUtility.TableClear(gReusableTable)
        FunctionSDK.Instance:TXWYPay(productID, productCount, serverID, "{\"charid\":" .. roleID .. "}", roleGrade, function(x)
          self:OnPaySuccess(x)
        end, function(x)
          self:OnPayCancel(x)
        end)
      end
    end
  end
end
function UISubViewControllerMonthlyVIP:OnPaySuccess(str_result)
  local str_result = x or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPaySuccess, " .. str_result)
  local currency = self.productConf and self.productConf.Rmb or 0
  ChargeComfirmPanel:ReduceLeft(tonumber(currency))
  EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
  if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
    local runtimePlatform = ApplicationInfo.GetRunPlatform()
    if runtimePlatform == RuntimePlatform.IPhonePlayer then
      if self.orderIDOfXDSDKPay ~= nil then
        FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(self.orderIDOfXDSDKPay, self.monthlyVIPShopItemConf.Rmb)
      end
    elseif runtimePlatform == RuntimePlatform.Android then
      if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
        FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd("", self.monthlyVIPShopItemConf.Rmb)
      else
        local orderID = FunctionSDK.Instance:GetOrderID()
        FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(orderID, self.monthlyVIPShopItemConf.Rmb)
      end
    end
  end
end
function UISubViewControllerMonthlyVIP:OnPayFail(product_id, str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPayFail, " .. strResult)
  PurchaseDeltaTimeLimit.Instance():End(product_id)
end
function UISubViewControllerMonthlyVIP:OnPayTimeout(product_id, str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPayTimeout, " .. strResult)
  PurchaseDeltaTimeLimit.Instance():End(product_id)
end
function UISubViewControllerMonthlyVIP:OnPayCancel(product_id, str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPayCancel, " .. strResult)
  PurchaseDeltaTimeLimit.Instance():End(product_id)
end
function UISubViewControllerMonthlyVIP:OnPayProductIllegal(product_id, str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPayProductIllegal, " .. strResult)
  PurchaseDeltaTimeLimit.Instance():End(product_id)
end
function UISubViewControllerMonthlyVIP:OnPayPaying(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPayPaying, " .. strResult)
end
