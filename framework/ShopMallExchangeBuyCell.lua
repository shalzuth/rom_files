ShopMallExchangeBuyCell = class("ShopMallExchangeBuyCell", ItemTipBaseCell)
local temp = {}
function ShopMallExchangeBuyCell:Init()
  ShopMallExchangeBuyCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self:InitShow()
end
function ShopMallExchangeBuyCell:FindObjs()
  self.closeBtn = self:FindGO("CancelButton")
  self.price = self:FindGO("Price"):GetComponent(UILabel)
  self.buyButton = self:FindGO("ConfirmButton"):GetComponent(UISprite)
  self.buyLabel = self:FindGO("Label", self.buyButton.gameObject):GetComponent(UILabel)
  self.sellCount = self:FindGO("SellCount")
  if self.sellCount then
    self.sellCount = self.sellCount:GetComponent(UILabel)
  end
  self.buyCountInput = self:FindGO("CountInput")
  if self.buyCountInput then
    self.buyCountInput = self.buyCountInput:GetComponent(UIInput)
    UIUtil.LimitInputCharacter(self.buyCountInput, 6)
  end
  self.buyPlusBg = self:FindGO("CountPlusBg")
  if self.buyPlusBg then
    self.buyPlusBg = self.buyPlusBg:GetComponent(UISprite)
  end
  self.buySubtractBg = self:FindGO("CountSubtractBg")
  if self.buySubtractBg then
    self.buySubtractBg = self.buySubtractBg:GetComponent(UISprite)
  end
  self.money = self:FindGO("Money")
  if self.money then
    self.money = self.money:GetComponent(UILabel)
  end
  self.ownCount = self:FindGO("OwnCount")
  if self.ownCount then
    self.ownCount = self.ownCount:GetComponent(UILabel)
  end
  self.discountMoney = self:FindGO("DiscountMoney")
  if self.discountMoney then
    self.discountMoney = self.discountMoney:GetComponent(UILabel)
  end
  self.quota = self:FindGO("Quota")
  if self.quota then
    self.quota = self.quota:GetComponent(UILabel)
  end
end
function ShopMallExchangeBuyCell:AddEvts()
  self:SetEvent(self.closeBtn, function(g)
    self:PassEvent(ShopMallEvent.ExchangeCloseBuyInfo, self)
  end)
  self:AddClickEvent(self.buyButton.gameObject, function(g)
    if OverseaHostHelper:GuestExchangeForbid() ~= 1 then
      self:BuyItem()
    end
  end)
  if self.buyPlusBg then
    self:AddPressEvent(self.buyPlusBg.gameObject, function(g, b)
      self:PressCount(g, b, 1)
    end)
  end
  if self.buySubtractBg then
    self:AddPressEvent(self.buySubtractBg.gameObject, function(g, b)
      self:PressCount(g, b, -1)
    end)
  end
  if self.buyCountInput then
    EventDelegate.Set(self.buyCountInput.onChange, function()
      self:InputOnChange()
    end)
  end
end
function ShopMallExchangeBuyCell:InitShow()
  if self.quota then
    local quotaIcon = self:FindGO("QuotaIcon"):GetComponent(UISprite)
    if quotaIcon then
      local quota = Table_Item[GameConfig.Booth.quota_itemid]
      if quota ~= nil then
        IconManager:SetItemIcon(quota.Icon, quotaIcon)
      end
    end
  end
end
function ShopMallExchangeBuyCell:SetData(data)
  self.infoData = data
  if data then
    if data.itemid then
      self.itemData = Table_Item[data.itemid]
      if self.itemData ~= nil then
        local itemData = data:GetItemData()
        if itemData then
          self.data = itemData
          self:UpdateAttriContext()
          self:UpdateTopInfo()
        end
        if data.price then
          self:UpdateMoney(data:GetPrice())
          self:SetCanExpress(data:GetPrice())
          self.price.text = StringUtil.NumThousandFormat(data:GetPrice())
        else
          errorLog("ShopMallExchangeBuyCell SetData : data.price is nil")
        end
        if data.overlap and data.count and self.sellCount then
          self.sellCount.text = data.count
        end
        if self.buyCountInput then
          self.buyCountInput.value = 1
          self:UpdateBuyPlusSubtract(1, data.count)
        end
      else
        errorLog(string.format("ShopMallExchangeBuyCell SetData : Table_Item[%s] is nil", tostring(data.itemid)))
      end
      if self.ownCount then
        local own = BagProxy.Instance:GetItemNumByStaticID(data.itemid)
        if own then
          self.ownCount.text = own
        else
          self.ownCount.text = 0
        end
      end
    else
      errorLog("ShopMallExchangeBuyCell SetData : data.itemid is nil")
    end
  end
end
function ShopMallExchangeBuyCell:PressCount(go, isPressed, change)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(self, deltatime)
      self:UpdateBuyCount(change)
    end, self, 3)
  else
    TimeTickManager.Me():ClearTick(self, 3)
  end
end
function ShopMallExchangeBuyCell:UpdateBuyCount(change)
  local count = tonumber(self.buyCountInput.value) + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  elseif count > self.infoData.count then
    self.countChangeRate = 1
    return
  end
  self:UpdateBuyPlusSubtract(count, self.infoData.count)
  self.buyCountInput.value = count
  local totalPrice = self.infoData:GetPrice() * count
  self:UpdateMoney(totalPrice)
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
  if self.countChangeCallback then
    self:SetCanExpress(totalPrice)
    self.countChangeCallback(self:CanExpress())
  end
end
function ShopMallExchangeBuyCell:InputOnChange()
  local count = tonumber(self.buyCountInput.value)
  if count == nil then
    return
  end
  if self.infoData then
    if count < 1 then
      self.buyCountInput.value = 1
    elseif count > self.infoData.count then
      self.buyCountInput.value = self.infoData.count
    end
    count = tonumber(self.buyCountInput.value)
    self:UpdateBuyPlusSubtract(count, self.infoData.count)
    local totalPrice
    if self.infoData.price then
      totalPrice = self.infoData:GetPrice() * count
      self:UpdateMoney(totalPrice)
    end
    if self.countChangeCallback then
      self:SetCanExpress(totalPrice)
      self.countChangeCallback(self:CanExpress())
    end
  end
end
function ShopMallExchangeBuyCell:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end
function ShopMallExchangeBuyCell:SetBuyPlus(alpha)
  if self.buyPlusBg and self.buyPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.buyPlusBg, alpha)
  end
end
function ShopMallExchangeBuyCell:SetBuySubtract(alpha)
  if self.buySubtractBg and self.buySubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.buySubtractBg, alpha)
  end
end
function ShopMallExchangeBuyCell:UpdateBuyPlusSubtract(count, infoCount)
  if infoCount > 1 then
    if count <= 1 then
      self:SetBuyPlus(1)
      self:SetBuySubtract(0.5)
    elseif infoCount <= count then
      self:SetBuyPlus(0.5)
      self:SetBuySubtract(1)
    else
      self:SetBuyPlus(1)
      self:SetBuySubtract(1)
    end
  else
    self:SetBuyPlus(0.5)
    self:SetBuySubtract(0.5)
  end
end
function ShopMallExchangeBuyCell:UpdateMoney(price)
  if self.money then
    self.money.text = StringUtil.NumThousandFormat(price)
  end
  self:UpdateDiscountMoney(price)
  self:UpdateQuota(price)
end
function ShopMallExchangeBuyCell:UpdateDiscountMoney(price)
  if self.discountMoney then
    self.discountMoney.text = StringUtil.NumThousandFormat(BoothProxy.Instance:GetDiscountMoney(price))
  end
end
function ShopMallExchangeBuyCell:UpdateQuota(price)
  if self.quota then
    if BoothProxy.Instance:IsMaintenance() then
      self.quota.text = ZhString.Booth_Maintenance
    else
      self.quota.text = StringUtil.NumThousandFormat(BoothProxy.Instance:GetQuota(price, self.infoData.publicityId))
    end
  end
end
local itemInfo = {}
function ShopMallExchangeBuyCell:BuyItem()
  if self.isBuy then
    return
  end
  local infoData = self.infoData
  local _TradeType = BoothProxy.TradeType
  local _MyselfProxy = MyselfProxy.Instance
  local _BoothProxy = BoothProxy.Instance
  local count = self.buyCountInput and tonumber(self.buyCountInput.value) or 1
  local totalPrice = infoData:GetPrice() * count
  if infoData.type == _TradeType.Exchange then
    if totalPrice > _MyselfProxy:GetROB() then
      MsgManager.ShowMsgByID(10154)
      return
    end
  elseif infoData.type == _TradeType.Booth then
    if BoothProxy.Instance:IsMaintenance() then
      MsgManager.ShowMsgByID(25692)
      return
    end
    if _MyselfProxy:GetROB() < _BoothProxy:GetDiscountMoney(totalPrice) then
      MsgManager.ShowMsgByID(10154)
      return
    end
    if _MyselfProxy:GetQuota() < _BoothProxy:GetQuota(totalPrice, self.infoData.publicityId) then
      MsgManager.ShowMsgByID(25703)
      return
    end
  end
  TableUtility.TableClear(itemInfo)
  itemInfo.itemid = infoData.itemid
  itemInfo.price = infoData.price
  itemInfo.count = count
  itemInfo.publicity_id = infoData.publicityId
  if not overlap then
    itemInfo.order_id = infoData.orderId
  end
  itemInfo.charid = infoData.charid
  itemInfo.type = infoData.type
  if infoData.itemData and infoData.itemData.equipInfo and infoData.itemData.equipInfo.damage then
    MsgManager.ConfirmMsgByID(10155, function()
      self:CallBuyItemRecordTradeCmd(itemInfo)
    end, nil, nil)
  else
    self:CallBuyItemRecordTradeCmd(itemInfo)
  end
end
function ShopMallExchangeBuyCell:CallBuyItemRecordTradeCmd(itemInfo)
  ShopMallProxy.Instance:CallBuyItemRecordTradeCmd(itemInfo, function()
    self:SetBuyBtn(true)
  end)
end
function ShopMallExchangeBuyCell:SetBuyBtn(isBuy)
  if isBuy then
    self.buyButton.color = ColorUtil.NGUIShaderGray
    self.buyLabel.effectColor = ColorUtil.NGUIGray
  else
    self.buyButton.color = ColorUtil.NGUIWhite
    self.buyLabel.effectColor = ColorUtil.ButtonLabelOrange
  end
  self.isBuy = isBuy
end
function ShopMallExchangeBuyCell:SetCountChangeCallback(callback)
  self.countChangeCallback = callback
  callback(self:CanExpress())
end
function ShopMallExchangeBuyCell:SetCanExpress(needCredit)
  self.canExpress = needCredit >= GameConfig.Exchange.SendMoneyLimit
  self.isQuotaEnough = needCredit <= MyselfProxy.Instance:GetQuota()
end
function ShopMallExchangeBuyCell:CanExpress()
  return self.canExpress, self.isQuotaEnough
end
