autoImport('ServiceWeddingCCmdAutoProxy')
ServiceWeddingCCmdProxy = class('ServiceWeddingCCmdProxy', ServiceWeddingCCmdAutoProxy)
ServiceWeddingCCmdProxy.Instance = nil
ServiceWeddingCCmdProxy.NAME = 'ServiceWeddingCCmdProxy'

function ServiceWeddingCCmdProxy:ctor(proxyName)
	if ServiceWeddingCCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceWeddingCCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceWeddingCCmdProxy.Instance = self
	end
end

function ServiceWeddingCCmdProxy:RecvReqWeddingDateListCCmd(data) 
	WeddingProxy.Instance:RecvReqWeddingDateListCCmd(data)
	self:Notify(ServiceEvent.WeddingCCmdReqWeddingDateListCCmd, data)
end

function ServiceWeddingCCmdProxy:RecvReqWeddingOneDayListCCmd(data) 
	WeddingProxy.Instance:RecvReqWeddingOneDayListCCmd(data)
	self:Notify(ServiceEvent.WeddingCCmdReqWeddingOneDayListCCmd, data)
end

function ServiceWeddingCCmdProxy:RecvReqWeddingInfoCCmd(data) 
	WeddingProxy.Instance:RecvReqWeddingInfoCCmd(data)
	EventManager.Me():DispatchEvent(ServiceEvent.WeddingCCmdReqWeddingInfoCCmd, data)
end

function ServiceWeddingCCmdProxy:RecvNtfWeddingInfoCCmd(data) 
	WeddingProxy.Instance:RecvNtfWeddingInfoCCmd(data)
	self:Notify(ServiceEvent.WeddingCCmdNtfWeddingInfoCCmd, data)
end

function ServiceWeddingCCmdProxy:RecvUpdateWeddingManualCCmd(data) 
	WeddingProxy.Instance:RecvUpdateWeddingManualCCmd(data)
	self:Notify(ServiceEvent.WeddingCCmdUpdateWeddingManualCCmd, data)
end

function ServiceWeddingCCmdProxy:RecvInviteBeginWeddingCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdInviteBeginWeddingCCmd, data)
end

function ServiceWeddingCCmdProxy:RecvGoToWeddingPosCCmd(data) 
	FunctionWedding.Me():StartWeddingCememony();
	self:Notify(ServiceEvent.WeddingCCmdGoToWeddingPosCCmd, data)
end

function ServiceWeddingCCmdProxy:RecvWeddingSwitchQuestionCCmd(data) 
	WeddingProxy.Instance:RecvWeddingSwitchQuestionCCmd(data)
	self:Notify(ServiceEvent.WeddingCCmdWeddingSwitchQuestionCCmd, data)
end

function ServiceWeddingCCmdProxy:CallReqWeddingInfoCCmd(id, info) 
	local msg = WeddingCCmd_pb.ReqWeddingInfoCCmd()
	if(id ~= nil )then
		msg.id = id
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdProxy:RecvWeddingOverCCmd(data) 
	FunctionWedding.Me():EndWeddingCememony()
	self:Notify(ServiceEvent.WeddingCCmdWeddingOverCCmd, data)
end
