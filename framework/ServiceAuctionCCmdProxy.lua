autoImport('ServiceAuctionCCmdAutoProxy')
ServiceAuctionCCmdProxy = class('ServiceAuctionCCmdProxy', ServiceAuctionCCmdAutoProxy)
ServiceAuctionCCmdProxy.Instance = nil
ServiceAuctionCCmdProxy.NAME = 'ServiceAuctionCCmdProxy'

function ServiceAuctionCCmdProxy:ctor(proxyName)
	if ServiceAuctionCCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceAuctionCCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceAuctionCCmdProxy.Instance = self
	end
end

function ServiceAuctionCCmdProxy:RecvNtfAuctionStateCCmd(data) 
	-- helplog("RecvNtfAuctionStateCCmd")
	AuctionProxy.Instance:RecvNtfAuctionStateCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdNtfAuctionStateCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvNtfSignUpInfoCCmd(data)
	-- helplog("RecvNtfSignUpInfoCCmd")
	AuctionProxy.Instance:RecvNtfSignUpInfoCCmd(data)
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AuctionSignUpView})
	self:Notify(ServiceEvent.AuctionCCmdNtfSignUpInfoCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvNtfMySignUpInfoCCmd(data) 
	AuctionProxy.Instance:RecvNtfMySignUpInfoCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdNtfMySignUpInfoCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvSignUpItemCCmd(data) 
	-- helplog("RecvSignUpItemCCmd")
	AuctionProxy.Instance:RecvSignUpItemCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdSignUpItemCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvNtfAuctionInfoCCmd(data) 
	-- helplog("RecvNtfAuctionInfoCCmd")
	AuctionProxy.Instance:RecvNtfAuctionInfoCCmd(data)
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AuctionView})
	self:Notify(ServiceEvent.AuctionCCmdNtfAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvUpdateAuctionInfoCCmd(data) 
	-- helplog("RecvUpdateAuctionInfoCCmd")
	AuctionProxy.Instance:RecvUpdateAuctionInfoCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdUpdateAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvReqAuctionFlowingWaterCCmd(data) 
	-- helplog("RecvReqAuctionFlowingWaterCCmd")
	AuctionProxy.Instance:RecvReqAuctionFlowingWaterCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdReqAuctionFlowingWaterCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvUpdateAuctionFlowingWaterCCmd(data) 
	-- helplog("RecvUpdateAuctionFlowingWaterCCmd")
	AuctionProxy.Instance:RecvUpdateAuctionFlowingWaterCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdUpdateAuctionFlowingWaterCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvNtfMyOfferPriceCCmd(data) 
	-- helplog("RecvNtfMyOfferPriceCCmd")
	AuctionProxy.Instance:RecvNtfMyOfferPriceCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdNtfMyOfferPriceCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvNtfNextAuctionInfoCCmd(data) 
	-- helplog("RecvNtfNextAuctionInfoCCmd")
	AuctionProxy.Instance:RecvNtfNextAuctionInfoCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdNtfNextAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvReqAuctionRecordCCmd(data) 
	-- helplog("RecvReqAuctionRecordCCmd")
	AuctionProxy.Instance:RecvReqAuctionRecordCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdReqAuctionRecordCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvTakeAuctionRecordCCmd(data) 
	-- helplog("RecvTakeAuctionRecordCCmd")
	AuctionProxy.Instance:RecvTakeAuctionRecordCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdTakeAuctionRecordCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvNtfCanTakeCntCCmd(data) 
	-- helplog("RecvNtfCanTakeCntCCmd")
	AuctionProxy.Instance:RecvNtfCanTakeCntCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdNtfCanTakeCntCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvReqMyTradedPriceCCmd(data) 
	-- helplog("RecvReqMyTradedPriceCCmd")
	AuctionProxy.Instance:RecvReqMyTradedPriceCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdReqMyTradedPriceCCmd, data)
end

function ServiceAuctionCCmdProxy:RecvNtfMaskPriceCCmd(data) 
	AuctionProxy.Instance:RecvNtfMaskPriceCCmd(data)
	self:Notify(ServiceEvent.AuctionCCmdNtfMaskPriceCCmd, data)
end