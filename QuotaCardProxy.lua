autoImport("QuotaLogData")
autoImport("QuotaDetailData")

QuotaCardProxy = class('QuotaCardProxy', pm.Proxy)
QuotaCardProxy.Instance = nil;
QuotaCardProxy.NAME = "QuotaCardProxy"

QuotaCardProxy.Type = {
	Charge = SceneItem_pb.EQuotaType_G_Charge,			--????????????
	Give = SceneItem_pb.EQuotaType_C_Give,				--????????????
	Auction = SceneItem_pb.EQuotaType_C_Auction,		--????????????
	AuctionBack = SceneItem_pb.EQuotaType_G_Auction,	--??????????????????
	Lottery = SceneItem_pb.EQuotaType_C_Lottery,        --??????????????????
	GuildBox = SceneItem_pb.EQuotaType_C_GuildBox,		--???????????? 	
	WeddingDress = SceneItem_pb.EQuotaType_C_WeddingDress,-- //??????????????????
	BoothLock = SceneItem_pb.EQuotaType_L_Booth,		--????????????
	BoothUnLock = SceneItem_pb.EQuotaType_U_Booth,		--????????????
	BoothCost = SceneItem_pb.EQuotaType_C_Booth,		--????????????
	ChargeLock = SceneItem_pb.EQuotaType_L_Charge,		--????????????
	ChargeUnLock = SceneItem_pb.EQuotaType_U_Charge,	--????????????
}

function QuotaCardProxy:ctor(proxyName, data)
	self.proxyName = proxyName or QuotaCardProxy.NAME
	if(QuotaCardProxy.Instance == nil) then
		QuotaCardProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
end

function QuotaCardProxy:Init()
	self.quotaLogData = {}
	self.quotaDetailData = {}
end

function QuotaCardProxy:UpdateLog(service_LogData)
	self.quotaLogData = {}
	for i=1,#service_LogData do
		local data = QuotaLogData.new();
		data:SetLogData(service_LogData[i])
		table.insert(self.quotaLogData, data); 
	end
end

function QuotaCardProxy:UpdateDetail(service_DetailData)
	self.quotaDetailData = {}
	for i=1,#service_DetailData do
		local data = QuotaDetailData.new();
		data:SetDetailData(service_DetailData[i]);
		table.insert(self.quotaDetailData, data); 
	end
end

function QuotaCardProxy:GetLogData()
	return self.quotaLogData
end

function QuotaCardProxy:GetDetailData()
	return self.quotaDetailData
end
