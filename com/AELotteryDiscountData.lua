AELotteryDiscountData = class("AELotteryDiscountData")
AELotteryDiscountData.CoinType = {
  Coin = ActivityEvent_pb.ECoinType_Coin,
  Ticket = ActivityEvent_pb.ECoinType_Ticket
}
function AELotteryDiscountData:ctor(data)
  self:SetData(data)
end
function AELotteryDiscountData:SetData(data)
  if data ~= nil then
    self.id = data.id
    self.beginTime = data.begintime
    self.endTime = data.endtime
    local discount = data.lotterydiscount
    self.type = discount.lotterytype
    self.cointype = discount.cointype
    self.usertype = discount.usertype
    self.discount = discount.discount
    self.count = discount.count
    self.yearmonth = discount.yearmonth
    self.year = math.floor(self.yearmonth / 100)
    self.month = self.yearmonth % 100
    self.usedCount = 0
  end
end
function AELotteryDiscountData:SetUsedCount(count)
  self.usedCount = count
end
function AELotteryDiscountData:IsInActivity()
  if self.beginTime ~= nil and self.endTime ~= nil then
    local server = ServerTime.CurServerTime() / 1000
    return server >= self.beginTime and server <= self.endTime
  else
    return true
  end
end
function AELotteryDiscountData:GetDiscount()
  if self:IsInActivity() and self.count ~= 0 and self.usedCount < self.count then
    return self.discount
  end
  return 100
end
