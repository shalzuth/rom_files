local baseCell = autoImport("BaseCell")
BoothIntroduceCell = class("BoothIntroduceCell", baseCell)
function BoothIntroduceCell:Init()
  self:FindObjs()
  self:InitShow()
end
function BoothIntroduceCell:FindObjs()
  self.rate = self:FindGO("Rate")
  if self.rate then
    self.rate = self.rate:GetComponent(UILabel)
  end
  self.countDown = self:FindGO("CountDown")
  if self.countDown then
    self.countDown = self.countDown:GetComponent(UILabel)
  end
  self.count = self:FindGO("Count")
  if self.count then
    self.count = self.count:GetComponent(UILabel)
  end
  self.buyerCount = self:FindGO("BuyerCount")
  if self.buyerCount then
    self.buyerCount = self.buyerCount:GetComponent(UILabel)
  end
  self.info = self:FindGO("Info")
  if self.info then
    self.info = self.info:GetComponent(UILabel)
  end
  self.info2 = self:FindGO("Info2")
  if self.info2 then
    self.info2 = self.info2:GetComponent(UILabel)
  end
  self.table = self:FindGO("Table")
  if self.table then
    self.table = self.table:GetComponent(UITable)
  end
  self.rate = self:FindGO("Rate")
  if self.rate then
    self.rate = self.rate:GetComponent(UILabel)
  end
  self.sendRoot = self:FindGO("SendRoot")
  self.boothFrom = self:FindGO("BoothFrom")
  if self.boothFrom then
    self.boothFrom = self.boothFrom:GetComponent(UILabel)
  end
  self.boothTip = self:FindGO("BoothTip")
  if self.boothTip then
    self.boothTip = self.boothTip:GetComponent(UILabel)
  end
  self.tipQuota = self:FindGO("TipQuota")
  self.quota = self:FindGO("Quota")
  if self.quota then
    self.quota = self.quota:GetComponent(UILabel)
  end
end
function BoothIntroduceCell:InitShow()
  if self.tipQuota then
    local quotaIcon = self:FindGO("Icon", self.tipQuota):GetComponent(UISprite)
    local quota = Table_Item[GameConfig.Booth.quota_itemid]
    if quota ~= nil then
      IconManager:SetItemIcon(quota.Icon, quotaIcon)
    end
  end
end
function BoothIntroduceCell:SetData(data)
  self.data = data
  if data then
    if self.rate then
      self.rate.text = string.format(ZhString.ShopMall_ExchangeRateTitle, CommonFun.calcTradeTax(data:GetPrice()))
    end
    local itemid = data:GetItemId()
    local statetype = data.type
    if statetype == ShopMallStateTypeEnum.WillPublicity then
      local item = Table_Item[itemid]
      if item ~= nil then
        if self.info then
          local sb = LuaStringBuilder.CreateAsTable()
          sb:AppendLine(string.format(ZhString.Booth_IntroduceWillPublicity, item.NameZh))
          sb:AppendLine(ZhString.Booth_IntroducePublicityTip)
          sb:AppendLine(ZhString.Booth_IntroduceSendTip)
          sb:Append(self:GetPublicityTip())
          self.info.text = sb:ToString()
          sb:Destroy()
        end
        local exchange = Table_Exchange[itemid]
        local showTime = 0
        if exchange ~= nil then
          showTime = exchange.ShowTime
        end
        if self.info2 then
          self.info2.text = string.format(ZhString.Booth_IntroducePublicityTime, item.NameZh, math.ceil(showTime / 60))
        end
      end
    elseif statetype == ShopMallStateTypeEnum.InPublicity then
      if self.timeTick == nil then
        self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountDown, self)
      end
      if self.count then
        self.count.text = string.format(ZhString.Booth_IntroduceCount, data.count)
      end
      self:UpdateBuyerCount()
      if self.info then
        local item = Table_Item[itemid]
        if item ~= nil then
          local sb = LuaStringBuilder.CreateAsTable()
          sb:AppendLine(string.format(ZhString.Booth_IntroducePublicity, item.NameZh))
          sb:AppendLine(ZhString.Booth_IntroducePublicityTip)
          sb:AppendLine(ZhString.Booth_IntroduceSendTip)
          sb:Append(self:GetPublicityTip())
          self.info.text = sb:ToString()
          sb:Destroy()
        end
      end
    else
      if self.count then
        self.count.text = string.format(ZhString.Booth_IntroduceCount, data.count)
      end
      if self.boothTip then
        local sb = LuaStringBuilder.CreateAsTable()
        sb:AppendLine(ZhString.Booth_IntroduceSendTip)
        sb:Append(self:GetPublicityTip())
        self.boothTip.text = sb:ToString()
        sb:Destroy()
      end
    end
    if self.sendRoot then
      self.sendRoot:SetActive(false)
    end
    if self.boothFrom then
      self.boothFrom.text = string.format(ZhString.Booth_IntroduceFrom, data.boothName)
    end
    local exchangeType = data.exchangeType
    if exchangeType == ShopMallExchangeSellEnum.Sell then
      self:ShowQuotaTip(true)
    elseif exchangeType == ShopMallExchangeSellEnum.Cancel then
      self:ShowQuotaTip(false)
    elseif exchangeType == ShopMallExchangeSellEnum.Resell then
      self:ShowQuotaTip(true)
    end
    if self.table then
      self.table:Reposition()
    end
  end
end
function BoothIntroduceCell:UpdateCountDown()
  if self.data.endTime then
    local time = self.data.endTime - ServerTime.CurServerTime() / 1000
    local min, sec
    if time > 0 then
      min, sec = ClientTimeUtil.GetFormatSecTimeStr(time)
    else
      min = 0
      sec = 0
    end
    self.countDown.text = string.format(ZhString.ShopMall_ExchangePublicityCountDown, min, sec)
  end
end
function BoothIntroduceCell:UpdateQuota(price, count)
  if self.quota then
    local statetype = self.data.type
    local publicityId = (statetype == ShopMallStateTypeEnum.WillPublicity or statetype == ShopMallStateTypeEnum.InPublicity) and 1 or 0
    local quota = BoothProxy.Instance:GetQuota(price * count, publicityId)
    if quota ~= nil then
      self.quota.text = StringUtil.NumThousandFormat(quota)
    end
  end
end
function BoothIntroduceCell:UpdateBuyerCount()
  if self.buyerCount then
    self.buyerCount.text = string.format(ZhString.Booth_IntroduceBuyerCount, self.data.buyerCount)
  end
end
function BoothIntroduceCell:GetPublicityTip()
  local exchangeType = self.data.exchangeType
  local _ShopMallExchangeSellEnum = ShopMallExchangeSellEnum
  if exchangeType == _ShopMallExchangeSellEnum.Sell or exchangeType == _ShopMallExchangeSellEnum.Cancel or exchangeType == _ShopMallExchangeSellEnum.Resell then
    return ZhString.Booth_IntroducePublicitySellTip
  else
    return string.format(ZhString.Booth_IntroduceBuyTip, 1 / GameConfig.Booth.quota_zeny_discount * 100)
  end
end
function BoothIntroduceCell:ShowQuotaTip(isShow)
  if self.tipQuota then
    self.tipQuota:SetActive(isShow)
  end
end
function BoothIntroduceCell:OnDestroy()
  if self.timeTick ~= nil then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end
