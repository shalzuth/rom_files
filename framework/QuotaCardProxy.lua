autoImport("QuotaLogData")
autoImport("QuotaDetailData")

QuotaCardProxy = class('QuotaCardProxy', pm.Proxy)
QuotaCardProxy.Instance = nil;
QuotaCardProxy.NAME = "QuotaCardProxy"

QuotaCardProxy.Type = {
	Charge = SceneItem_pb.EQuotaType_G_Charge,			--充值获得
	Give = SceneItem_pb.EQuotaType_C_Give,				--赠送消耗
	Auction = SceneItem_pb.EQuotaType_C_Auction,		--拍卖消耗
	AuctionBack = SceneItem_pb.EQuotaType_G_Auction,	--拍卖失败返回
	Lottery = SceneItem_pb.EQuotaType_C_Lottery,        --扭蛋赠送消耗
	GuildBox = SceneItem_pb.EQuotaType_C_GuildBox,		--公会宝箱 	
	WeddingDress = SceneItem_pb.EQuotaType_C_WeddingDress,-- //赠送婚纱消耗
	BoothLock = SceneItem_pb.EQuotaType_L_Booth,		--摆摊锁定
	BoothUnLock = SceneItem_pb.EQuotaType_U_Booth,		--摆摊解锁
	BoothCost = SceneItem_pb.EQuotaType_C_Booth,		--摆摊消耗
	ChargeLock = SceneItem_pb.EQuotaType_L_Charge,		--充值锁定
	ChargeUnLock = SceneItem_pb.EQuotaType_U_Charge,	--充值解锁
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
