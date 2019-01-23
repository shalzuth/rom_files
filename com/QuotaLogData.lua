QuotaLogData = class("QuotaLogData");

function QuotaLogData:SetLogData(data)
	self.value = data.value
	self.time = data.time
	self.quotaType = data.type

	local quotaType = self.quotaType
	if(QuotaCardProxy.Type.Charge == quotaType)then
		self.logTitle = ZhString.QuotaCard_LogDesc_Charge
	elseif(QuotaCardProxy.Type.Give == quotaType)then
		self.logTitle = ZhString.QuotaCard_LogDesc_Give
	elseif(QuotaCardProxy.Type.Auction == quotaType)then
		self.logTitle = ZhString.QuotaCard_LogDesc_Auction
	elseif(QuotaCardProxy.Type.AuctionBack == quotaType)then
		self.logTitle = ZhString.QuotaCard_LogDesc_AuctionBack
	elseif(QuotaCardProxy.Type.Lottery ==quotaType)then
		self.logTitle = ZhString.QuotaCard_Lottery
	elseif (QuotaCardProxy.Type.GuildBox == quotaType)then
		self.logTitle = ZhString.QuotaCard_GuildBox
	elseif (QuotaCardProxy.Type.WeddingDress == quotaType)then
		self.logTitle = ZhString.QuotaCard_WeddingDress
	elseif QuotaCardProxy.Type.BoothLock == quotaType then
		self.logTitle = ZhString.QuotaCard_BoothLock
	elseif QuotaCardProxy.Type.BoothUnLock == quotaType then
		self.logTitle = ZhString.QuotaCard_BoothUnLock
	elseif QuotaCardProxy.Type.BoothCost == quotaType then
		self.logTitle = ZhString.QuotaCard_BoothCost
	elseif QuotaCardProxy.Type.ChargeLock == quotaType then
		self.logTitle = ZhString.QuotaCard_ChargeLock
	elseif QuotaCardProxy.Type.ChargeUnLock == quotaType then
		self.logTitle = ZhString.QuotaCard_ChargeUnLock
	end
end