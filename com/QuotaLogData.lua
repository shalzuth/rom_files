QuotaLogData = class("QuotaLogData")
function QuotaLogData:SetLogData(data)
  self.value = data.value
  self.time = data.time
  self.quotaType = data.type
  local quotaType = self.quotaType
  local _QuotaType = QuotaCardProxy.Type
  if _QuotaType.Charge == quotaType then
    self.logTitle = ZhString.QuotaCard_LogDesc_Charge
  elseif _QuotaType.Give == quotaType then
    self.logTitle = ZhString.QuotaCard_LogDesc_Give
  elseif _QuotaType.Auction == quotaType then
    self.logTitle = ZhString.QuotaCard_LogDesc_Auction
  elseif _QuotaType.AuctionBack == quotaType then
    self.logTitle = ZhString.QuotaCard_LogDesc_AuctionBack
  elseif _QuotaType.Lottery == quotaType then
    self.logTitle = ZhString.QuotaCard_Lottery
  elseif _QuotaType.GuildBox == quotaType then
    self.logTitle = ZhString.QuotaCard_GuildBox
  elseif _QuotaType.WeddingDress == quotaType then
    self.logTitle = ZhString.QuotaCard_WeddingDress
  elseif _QuotaType.BoothLock == quotaType then
    self.logTitle = ZhString.QuotaCard_BoothLock
  elseif _QuotaType.BoothUnLock == quotaType then
    self.logTitle = ZhString.QuotaCard_BoothUnLock
  elseif _QuotaType.BoothCost == quotaType then
    self.logTitle = ZhString.QuotaCard_BoothCost
  elseif _QuotaType.ExchangeGiveLock == quotaType then
    self.logTitle = ZhString.QuotaCard_ExchangeGiveLock
  elseif _QuotaType.ExchangeGiveUnLock == quotaType then
    self.logTitle = ZhString.QuotaCard_ExchangeGiveUnLock
  elseif _QuotaType.ExchangeGiveCost == quotaType then
    self.logTitle = ZhString.QuotaCard_ExchangeGiveCost
  elseif _QuotaType.Reward == quotaType then
    self.logTitle = ZhString.QuotaCard_Reward
  elseif _QuotaType.GuildMaterial == quotaType then
    self.logTitle = ZhString.QuotaCard_GuildBuildingMaterial
  elseif _QuotaType.ChargeLock == quotaType then
    self.logTitle = ZhString.QuotaCard_ChargeLock
  elseif _QuotaType.ChargeUnLock == quotaType then
    self.logTitle = ZhString.QuotaCard_ChargeUnLock
  end
end
