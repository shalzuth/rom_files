autoImport("UIModelZenyShop")
UIListItemCtrlLuckyBag = class("UIListItemCtrlLuckyBag", BaseCell)
local gReusableTable = {}
local gReusableLuaColor = LuaColor(0, 0, 0, 0)
local viewPrefabPath = ResourcePathHelper.UICell("UIListItemLuckyBag")
function UIListItemCtrlLuckyBag:CreateView(parent)
  return self:CreateObj(viewPrefabPath, parent)
end
function UIListItemCtrlLuckyBag:Init()
  if self.gameObject ~= nil then
    self:GetGameObjects()
    self:RegisterButtonClickEvent()
    self:RegisterViewClickEvent()
  end
  self.purchaseLimit_N = 0
  self:ListenServerResponse()
end
function UIListItemCtrlLuckyBag:GetGameObjects()
  self.goItemIcon = self:FindGO("Icon", self.gameObject)
  self.spItemIcon = self.goItemIcon:GetComponent(UISprite)
  self.goLuckyBagPurchaseTimes = self:FindGO("PurchaseTimes", self.gameObject)
  self.labLuckyBagPurchaseTimes = self:FindGO("Lab", self.goLuckyBagPurchaseTimes):GetComponent(UILabel)
  self.goBTNPurchaseLuckyBag = self:FindGO("BTN_Purchase", self.gameObject)
  self.bcBTNPurchaseLuckyBag = self.goBTNPurchaseLuckyBag:GetComponent(BoxCollider)
  self.labTitleBTNPurchaseLuckyBag = self:FindGO("Title", self.goBTNPurchaseLuckyBag):GetComponent(UILabel)
  self.spNormalBTNPurchaseLuckyBag = self:FindGO("Normal", self.goBTNPurchaseLuckyBag):GetComponent(UISprite)
  self.goCurrency = self:FindGO("Currency", self.goBTNPurchaseLuckyBag)
  self.spCurrency = self:FindGO("Icon", self.goCurrency):GetComponent(UISprite)
  self.labCurrency = self:FindGO("Count", self.goCurrency):GetComponent(UILabel)
  self.goProductName = self:FindGO("Name", self.gameObject)
  self.goLabProductName = self:FindGO("Lab", self.goProductName)
  self.labProductName = self.goLabProductName:GetComponent(UILabel)
  self.goComingSoon = self:FindGO("ComingSoon", self.gameObject)
  self.goDiscount = self:FindGO("Discount", self.gameObject)
  self.goPercent = self:FindGO("Percent", self.goDiscount)
  self.labPercent = self:FindGO("Value1", self.goPercent):GetComponent(UILabel)
  self.goGainMore = self:FindGO("GainMore", self.gameObject)
  self.labMultipleNumber = self:FindGO("Value", self.goGainMore):GetComponent(UILabel)
  local sprite = self:FindGO("SaleIcon", self.goDiscount):GetComponent(UISprite)
  sprite.spriteName = "shop_icon_off"
end
function UIListItemCtrlLuckyBag:SetData(data)
  self.confType = data.confType
  self.id = data.id
  if data.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    self.productID = data.productID
  elseif data.confType == UIModelZenyShop.luckyBagConfType.Shop then
    self.shopItemData = data.shopItemData
  end
  self:GetModelSet()
  if data.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    FuncZenyShop.Instance():AddProductPurchase(self.productConf.ProductID, function()
      self:OnClickForButtonPurchase()
    end)
    EventManager.Me():PassEvent(ZenyShopEvent.CanPurchase, self.productConf.ProductID)
  end
  self:LoadView()
  if data.confType == UIModelZenyShop.luckyBagConfType.Deposit and self:IsOnSale() then
    self:OpenPurchaseSwitch()
  end
end
function UIListItemCtrlLuckyBag:RegisterButtonClickEvent()
  self:AddClickEvent(self.goBTNPurchaseLuckyBag, function()
    if not self.id or ShopProxy.Instance:IsThisItemCanBuyNow(self.id) then
    else
      MsgManager.ShowMsgByID(25833)
      do return end
      break
    end
    local productID = self.productConf.ProductID
    if productID then
      local productName = OverSea.LangManager.Instance():GetLangByKey(Table_Item[self.productConf.ItemId].NameZh)
      local productPrice = self.productConf.Rmb
      local productCount = self.productConf.Count
      local currencyType = self.productConf.CurrencyType
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ShopConfirmPanel,
        viewdata = {
          data = {
            title = string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", " [0075BCFF]" .. productCount .. "[-] " .. productName, currencyType, FuncZenyShop.FormatMilComma(productPrice)),
            desc = ZhString.ShopConfirmDes,
            callback = function()
              self:OnClickForButtonPurchaseLuckyBag()
            end
          }
        }
      })
    end
  end)
end
function UIListItemCtrlLuckyBag:RegisterViewClickEvent()
  self:AddClickEvent(self.gameObject, function()
    self:OnClickForViewSelf()
  end)
end
function UIListItemCtrlLuckyBag:UpPurchaseLimit(productConf)
  if productConf then
    local id = productConf.id
    local limit = UIModelZenyShop.Ins():GetLuckyBagPurchaseLimit(id)
    self.purchaseLimit_N = limit ~= 0 and limit or self.productConf.MonthLimit
    self.purchaseLimit_N = self.purchaseLimit_N or 0
  end
end
function UIListItemCtrlLuckyBag:GetModelSet()
  if self.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    local curDepositTable = Table_Deposit_ios_kr
    local runtimePlatform = ApplicationInfo.GetRunPlatform()
    if runtimePlatform == RuntimePlatform.Android and Table_Deposit_and_kr ~= nil then
      curDepositTable = Table_Deposit_and_kr
    end
    self.productConf = curDepositTable[self.productID]
    if self:IsOnSale() then
      self.itemID = self.productConf.ItemId
      self.useItemConf = Table_UseItem[self.itemID]
      self.itemConf = Table_Item[self.itemID]
      self.purchaseTimes = UIModelZenyShop.Ins():GetLuckyBagPurchaseTimes(self.productID)
    end
    self.activity = UIModelZenyShop.Ins():GetProductActivity(self.productID)
    if self.activity ~= nil then
      self.discountActivity = self.activity[1]
      if self.discountActivity ~= nil then
        local dActivityEndTime = self.discountActivity[5]
        local serverTime = ServerTime.CurServerTime() / 1000
        if dActivityEndTime > serverTime then
          local activityTimes = self.discountActivity[1]
          local activityUsedTimes = self.discountActivity[3]
          if activityTimes > activityUsedTimes then
            self.activityProductID = self.discountActivity[2]
            self.productConf = Table_Deposit[self.activityProductID]
          end
        end
      end
      self.gainMoreActivity = self.activity[2]
      self.moreTimesActivity = self.activity[3]
    end
    self:UpPurchaseLimit(self.productConf)
  elseif self.confType == UIModelZenyShop.luckyBagConfType.Shop then
    local itemConfID = self.shopItemData.goodsID
    self.itemConf = Table_Item[itemConfID]
    local cachedHaveBoughtItemCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount()
    if cachedHaveBoughtItemCount ~= nil then
      self.purchaseTimes = cachedHaveBoughtItemCount[self.shopItemData.id]
      self.purchaseTimes = self.purchaseTimes or 0
    else
      self.purchaseTimes = 0
    end
  end
end
function UIListItemCtrlLuckyBag:LoadView()
  if self.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    if self:IsOnSale() then
      self.spItemIcon.spriteName = self.productConf.Picture
    else
      self.spItemIcon.spriteName = "fudai_02"
    end
    self.spItemIcon:MakePixelPerfect()
    self.labProductName.text = self.productConf.Desc
    local limitStr = self.purchaseLimit_N
    if self:IsOnSale() then
      if self.purchaseTimes ~= nil then
        self.labLuckyBagPurchaseTimes.text = string.format(ZhString.LuckyBag_PurchaseTimesMonth, self.purchaseTimes, UIListItemCtrlLuckyBag.PaintColorPurchaseTimes(limitStr))
      end
    else
      self.labLuckyBagPurchaseTimes.text = ""
    end
    if self:IsOnSale() then
      self.goBTNPurchaseLuckyBag:SetActive(true)
      self.goCurrency:SetActive(false)
      self.labTitleBTNPurchaseLuckyBag.enabled = true
      self.goComingSoon:SetActive(false)
      self.currency = self.productConf.Rmb
      local strCurrency = tostring(self.productConf.Rmb)
      if math.floor(self.currency) == self.currency then
        strCurrency = strCurrency .. ".00"
      end
      self.labTitleBTNPurchaseLuckyBag.text = self.productConf.CurrencyType .. " " .. FuncZenyShop.FormatMilComma(self.productConf.Rmb)
    else
      self.goBTNPurchaseLuckyBag:SetActive(false)
      self.goComingSoon:SetActive(true)
    end
    if self.purchaseTimes ~= nil then
      if self.purchaseTimes >= self.purchaseLimit_N then
        ColorUtil.ShaderGrayUIWidget(self.spNormalBTNPurchaseLuckyBag)
        gReusableLuaColor:Set(0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
        self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
        self.bcBTNPurchaseLuckyBag.enabled = false
      else
        self.spNormalBTNPurchaseLuckyBag.color = Color.white
        gReusableLuaColor:Set(0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
        self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
        self.bcBTNPurchaseLuckyBag.enabled = true
      end
    end
    self.goDiscount:SetActive(false)
    if self.discountActivity ~= nil then
      local dActivityEndTime = self.discountActivity[5]
      local serverTime = ServerTime.CurServerTime() / 1000
      if dActivityEndTime > serverTime then
        self.activityTimes = self.discountActivity[1]
        self.activityUsedTimes = self.discountActivity[3]
        local purchaseTimes = self.purchaseTimes or 0
        self.labLuckyBagPurchaseTimes.text = string.format(ZhString.LuckyBag_PurchaseTimesMonth, self.activityUsedTimes + purchaseTimes, UIListItemCtrlLuckyBag.PaintColorMorePurchaseTimes(self.activityTimes + self.purchaseLimit_N))
        if self.activityTimes > self.activityUsedTimes then
          self.goDiscount:SetActive(true)
          local originPrice = Table_Deposit[self.productID].Rmb
          local discount = math.ceil(self.currency / originPrice * 100)
          discount = 100 - discount
          self.labPercent.text = discount
          self.spNormalBTNPurchaseLuckyBag.color = Color.white
          gReusableLuaColor:Set(0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
          self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
          self.bcBTNPurchaseLuckyBag.enabled = true
        end
      end
    end
  elseif self.confType == UIModelZenyShop.luckyBagConfType.Shop then
    self.labProductName.text = self.itemConf.NameZh
    self.spItemIcon.spriteName = self.itemConf.Icon
    self.goComingSoon:SetActive(false)
    local zhstring
    if self.shopItemData:CheckLimitType(HappyShopProxy.LimitType.OneDay) then
      zhstring = ZhString.LuckyBag_PurchaseTimesDay
    end
    self.labLuckyBagPurchaseTimes.text = string.format(zhstring, self.purchaseTimes, self.shopItemData.LimitNum)
    self.goBTNPurchaseLuckyBag:SetActive(true)
    self.goCurrency:SetActive(true)
    self.labTitleBTNPurchaseLuckyBag.enabled = false
    self.spCurrency.spriteName = Table_Item[self.shopItemData.ItemID].Icon
    self.labCurrency.text = self.shopItemData.ItemCount
    if self.purchaseTimes >= self.shopItemData.LimitNum then
      ColorUtil.ShaderGrayUIWidget(self.spNormalBTNPurchaseLuckyBag)
      ColorUtil.ShaderGrayUIWidget(self.spCurrency)
      self.bcBTNPurchaseLuckyBag.enabled = false
    else
      self.spNormalBTNPurchaseLuckyBag.color = Color.white
      self.spCurrency.color = Color.white
      self.bcBTNPurchaseLuckyBag.enabled = true
    end
  end
  self.goGainMore:SetActive(false)
  if self.gainMoreActivity ~= nil then
    local gActivityEndTime = self.gainMoreActivity[5]
    local serverTime = ServerTime.CurServerTime() / 1000
    if gActivityEndTime > serverTime then
      self.activityTimes = self.gainMoreActivity[1]
      self.activityUsedTimes = self.gainMoreActivity[3]
      local purchaseTimes = self.purchaseTimes or 0
      self.labLuckyBagPurchaseTimes.text = string.format(ZhString.LuckyBag_PurchaseTimesMonth, self.activityUsedTimes + purchaseTimes, UIListItemCtrlLuckyBag.PaintColorMorePurchaseTimes(self.activityTimes + self.purchaseLimit_N))
      if self.activityTimes > self.activityUsedTimes then
        self.goGainMore:SetActive(true)
        self.labMultipleNumber.text = "x" .. self.gainMoreActivity[2]
        self.spNormalBTNPurchaseLuckyBag.color = Color.white
        gReusableLuaColor:Set(0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
        self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
        self.bcBTNPurchaseLuckyBag.enabled = true
      end
    end
  end
  if self.moreTimesActivity ~= nil then
    local mActivityEndTime = self.moreTimesActivity[3]
    local serverTime = ServerTime.CurServerTime() / 1000
    if mActivityEndTime > serverTime then
      local mActivityTimes = self.moreTimesActivity[1]
      local mActivityUsedTimes = self.moreTimesActivity[5]
      if self.activityTimes == nil then
        self.activityTimes = mActivityTimes
        self.activityUsedTimes = mActivityUsedTimes
      else
        self.activityTimes = self.activityTimes + mActivityTimes
        self.activityUsedTimes = self.activityUsedTimes + mActivityUsedTimes
      end
      local purchaseTimes = self.purchaseTimes or 0
      if self.activityTimes > 0 then
        self.labLuckyBagPurchaseTimes.text = string.format(ZhString.LuckyBag_PurchaseTimesMonth, self.activityUsedTimes + purchaseTimes, UIListItemCtrlLuckyBag.PaintColorMorePurchaseTimes(self.activityTimes + self.purchaseLimit_N))
        if self.activityTimes > self.activityUsedTimes then
          self.spNormalBTNPurchaseLuckyBag.color = Color.white
          gReusableLuaColor:Set(0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
          self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
          self.bcBTNPurchaseLuckyBag.enabled = true
        end
      end
    end
  end
end
function UIListItemCtrlLuckyBag:IsOnSale()
  return self.productConf.Switch == 1
end
function UIListItemCtrlLuckyBag:OnClickForButtonPurchaseLuckyBag()
  if self.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    local runtimePlatform = ApplicationInfo.GetRunPlatform()
    if runtimePlatform == RuntimePlatform.IPhonePlayer and BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
      MsgManager.ConfirmMsgByID(3555, function()
        AppBundleConfig.JumpToIOSAppStore()
      end, nil)
      return
    end
    if self.activityTimes and self.activityTimes > 0 and self.activityTimes > self.activityUsedTimes then
      if self.purchaseSwitch then
        self:ClosePurchaseSwitch()
        self:PurchaseLuckyBag()
        self.isActivity = true
        if self.timerForPurchaseSwitch == nil then
          local interval = GameConfig.PurchaseMonthlyVIP.interval or 30000
          self.timerForPurchaseSwitch = TimeTickManager.Me():CreateTick(interval, interval, function()
            self.timerForPurchaseSwitch:StopTick()
            self:OpenPurchaseSwitch()
          end, self, 1)
        else
          self.timerForPurchaseSwitch:Restart()
        end
      else
        MsgManager.ShowMsgByID(49)
      end
    else
      self:RequestQueryChargeCnt()
      self.requestIsForVerifyPurchase = true
    end
  elseif self.confType == UIModelZenyShop.luckyBagConfType.Shop and not self.shopItemData:CheckCanRemove() and self:IsHaveEnoughVirtualCurrency() then
    self:RequestBuyLuckyBag(self.shopItemData.id)
  end
end
function UIListItemCtrlLuckyBag:OnClickForViewSelf()
  local itemConfID
  if self.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    if self:IsOnSale() then
      itemConfID = self.productConf.ItemId
    end
  elseif self.confType == UIModelZenyShop.luckyBagConfType.Shop then
    itemConfID = self.itemConf.id
  end
  if itemConfID ~= nil then
    local itemData = ItemData.new(nil, itemConfID)
    TipManager.Instance:ShowFormulaTip(itemData, UIViewControllerZenyShop.instance.widgetTipRelative, NGUIUtil.AnchorSide.Center, {110, 128})
  end
end
function UIListItemCtrlLuckyBag:ListenServerResponse()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
end
function UIListItemCtrlLuckyBag:OnReceivePurchaseSuccess(message)
  local confID = message.dataid
  if confID == self.productID then
    self:OpenPurchaseSwitch()
    if self.timerForPurchaseSwitch then
      self.timerForPurchaseSwitch:StopTick()
    end
    if not self.isActivity then
      UIModelZenyShop.Ins():AddLuckyBagPurchaseTimes(self.productID)
    end
  end
  self:GetModelSet()
  self:LoadView()
end
function UIListItemCtrlLuckyBag:OnPaySuccess(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPaySuccess, " .. strResult)
  if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
    local runtimePlatform = ApplicationInfo.GetRunPlatform()
    if runtimePlatform == RuntimePlatform.IPhonePlayer then
      FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(OverseaHostHelper:GetRoleIde(), self.productConf.Rmb)
    elseif runtimePlatform == RuntimePlatform.Android then
      if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
        FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(OverseaHostHelper:GetRoleIde(), self.productConf.Rmb)
      else
        FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(OverseaHostHelper:GetRoleIde(), self.productConf.Rmb)
      end
    end
  end
end
function UIListItemCtrlLuckyBag:OnPayFail(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPayFail, " .. strResult)
  self:OpenPurchaseSwitch()
  self.timerForPurchaseSwitch:StopTick()
end
function UIListItemCtrlLuckyBag:OnPayTimeout(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPayTimeout, " .. strResult)
  self:OpenPurchaseSwitch()
  self.timerForPurchaseSwitch:StopTick()
end
function UIListItemCtrlLuckyBag:OnPayCancel(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPayCancel, " .. strResult)
  self:OpenPurchaseSwitch()
  self.timerForPurchaseSwitch:StopTick()
end
function UIListItemCtrlLuckyBag:OnPayProductIllegal(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPayProductIllegal, " .. strResult)
  self:OpenPurchaseSwitch()
  self.timerForPurchaseSwitch:StopTick()
end
function UIListItemCtrlLuckyBag:OnPayPaying(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPayPaying, " .. strResult)
end
function UIListItemCtrlLuckyBag:PurchaseLuckyBag()
  if self.productConf then
    local productID = self.productConf.ProductID
    if productID then
      local productName = self.productConf.Desc
      local productPrice = self.productConf.Rmb
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
          local runtimePlatform = ApplicationInfo.GetRunPlatform()
          if false then
            TableUtility.TableClear(gReusableTable)
            gReusableTable.productGameID = tostring(self.productConf.id)
            gReusableTable.serverID = tostring(serverID)
            gReusableTable.payCallbackCode = 1
            local ext = json.encode(gReusableTable)
            FunctionXDSDK.Ins:Pay(productName, productID, productPrice * 100, serverID, tostring(roleID), "", ext, function(x)
              self:OnPaySuccess(x)
            end, function(x)
              self:OnPayFail(x)
            end, function(x)
              self:OnPayCancel(x)
            end)
          elseif FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.Any then
            if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V8) then
              FunctionSDK.Instance:ResetPayState()
            end
            TableUtility.TableClear(gReusableTable)
            gReusableTable.productGameID = self.productConf.id
            local custom = json.encode(gReusableTable)
            FunctionSDK.Instance:AnySDKPay(productID, productName, productPrice, productCount, tostring(roleID), roleName, roleGrade, roleBalance, tostring(serverID), custom, function(x)
              self:OnPaySuccess(x)
            end, function(x)
              self:OnPayFail(x)
            end, function(x)
              self:OnPayTimeout(x)
            end, function(x)
              self:OnPayCancel(x)
            end, function(x)
              self:OnPayProductIllegal(x)
            end, function(x)
              self:OnPayPaying(x)
            end)
          elseif FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.TXWY then
            TableUtility.TableClear(gReusableTable)
            FunctionSDK.Instance:TXWYPay(productID, productCount, serverID, "{\"charid\":" .. roleID .. "}", roleGrade, function(x)
              self:OnPaySuccess(x)
            end, function(x)
              self:OnPayCancel(x)
            end)
          elseif FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.XD then
            TableUtility.TableClear(gReusableTable)
            gReusableTable.productGameID = tostring(self.productConf.id)
            gReusableTable.serverID = tostring(serverID)
            local runtimePlatform = ApplicationInfo.GetRunPlatform()
            if runtimePlatform == RuntimePlatform.WindowsPlayer or runtimePlatform == RuntimePlatform.WindowsEditor then
              gReusableTable.payCallbackCode = 1
            end
            local ext = json.encode(gReusableTable)
            if not BackwardCompatibilityUtil.CompatibilityMode_V17 then
              local roleAndServerTime = roleID .. "_" .. currentServerTime
              self.orderIDOfXDSDKPay = MyMD5.HashString(roleAndServerTime)
              ShopProxy.Instance:XDSDKPay(productPrice * 100, tostring(serverID), productID, productName, tostring(roleID), ext, productCount, self.orderIDOfXDSDKPay, function(x)
                self:OnPaySuccess(x)
              end, function(x)
                self:OnPayFail(x)
              end, function(x)
                self:OnPayTimeout(x)
              end, function(x)
                self:OnPayCancel(x)
              end, function(x)
                self:OnPayProductIllegal(x)
              end)
            else
              self.orderIDOfXDSDKPay = ShopProxy.Instance:XDSDKPay(productPrice * 100, tostring(serverID), productID, productName, tostring(roleID), ext, productCount, function(x)
                self:OnPaySuccess(x)
              end, function(x)
                self:OnPayFail(x)
              end, function(x)
                self:OnPayTimeout(x)
              end, function(x)
                self:OnPayCancel(x)
              end, function(x)
                self:OnPayProductIllegal(x)
              end)
            end
          end
        end
      end
    end
  end
end
function UIListItemCtrlLuckyBag:OpenPurchaseSwitch()
  self.purchaseSwitch = true
end
function UIListItemCtrlLuckyBag:ClosePurchaseSwitch()
  self.purchaseSwitch = false
end
function UIListItemCtrlLuckyBag:OnExit()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
  if self.timerForPurchaseSwitch ~= nil then
    self.timerForPurchaseSwitch:ClearTick()
    self.timerForPurchaseSwitch = nil
  end
end
function UIListItemCtrlLuckyBag:RequestBuyLuckyBag(shop_item_id)
  ServiceSessionShopProxy.Instance:CallBuyShopItem(shop_item_id, 1)
end
function UIListItemCtrlLuckyBag:IsHaveEnoughVirtualCurrency()
  local gachaCoin = MyselfProxy.Instance:GetLottery()
  local needCount = self.shopItemData.ItemCount
  local retValue = gachaCoin >= needCount
  if not retValue then
    local sysMsgID = 3551
    MsgManager.ShowMsgByID(sysMsgID)
  end
  return retValue
end
function UIListItemCtrlLuckyBag:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end
function UIListItemCtrlLuckyBag:OnReceiveQueryChargeCnt(data)
  if self.requestIsForVerifyPurchase then
    self:UpPurchaseLimit(self.productConf)
    self:GetModelSet()
    self:LoadView()
    if self.purchaseTimes < self.purchaseLimit_N then
      if self.purchaseSwitch then
        self:ClosePurchaseSwitch()
        self:PurchaseLuckyBag()
        self.isActivity = false
        if self.timerForPurchaseSwitch == nil then
          local interval = GameConfig.PurchaseMonthlyVIP.interval or 30000
          self.timerForPurchaseSwitch = TimeTickManager.Me():CreateTick(interval, interval, function()
            self.timerForPurchaseSwitch:StopTick()
            self:OpenPurchaseSwitch()
          end, self, 1)
        else
          self.timerForPurchaseSwitch:Restart()
        end
      else
        MsgManager.ShowMsgByID(49)
      end
    else
      local purchaseLimit = self.purchaseLimit_N
      local tabFormatParams = {purchaseLimit}
      MsgManager.ShowMsgByIDTable(31020, tabFormatParams)
    end
    self.requestIsForVerifyPurchase = false
  end
end
function UIListItemCtrlLuckyBag:OnReceiveUpdateActivityCnt(data)
  self:GetModelSet()
  self:LoadView()
end
UIListItemCtrlLuckyBag.colorPurchaseTimes = "4185C6FF"
UIListItemCtrlLuckyBag.colorMorePurchaseTimes = "41c419"
function UIListItemCtrlLuckyBag.PaintColorPurchaseTimes(str)
  return "[" .. UIListItemCtrlLuckyBag.colorPurchaseTimes .. "]" .. str .. "[-]"
end
function UIListItemCtrlLuckyBag.PaintColorMorePurchaseTimes(str)
  return "[" .. UIListItemCtrlLuckyBag.colorMorePurchaseTimes .. "]" .. str .. "[-]"
end
