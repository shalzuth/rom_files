ExchangeShopItemData = class("ExchangeShopItemData")
function ExchangeShopItemData:ctor(data)
  self:Init()
  self:SetData(data)
end
function ExchangeShopItemData:Init()
end
function ExchangeShopItemData:SetData(data)
  self.goodsId = data.id
  self.staticData = Table_ExchangeShop[data.id]
  if nil == self.staticData then
    errorLog("ExchangeShopItemData ---> cannot find staticData ,errorID: " .. data.id)
  end
  self.status = data.status
  self.progress = data.progress or 1
  self.exchangeCount = data.exchange_count or 0
  self.leftTime = data.left_time and ServerTime.CurServerTime() / 1000 + data.left_time or 0
  self.isGift = self.staticData.Type == 1 or self.staticData.Type == 2
  self.isKapulaExchangeType = self.staticData.Type == 3 and self.staticData.ExchangeType == 1
end
function ExchangeShopItemData:GetLeftTime()
  return self.leftTime - ServerTime.CurServerTime() / 1000
end
function ExchangeShopItemData:IsExchangeShop()
  return nil ~= self.staticData and self.staticData.Source == 1
end
ExchangeItemInfo = class("ExchangeItemInfo")
function ExchangeItemInfo:ctor(id, num)
  self.id = id
  self.num = num
end
