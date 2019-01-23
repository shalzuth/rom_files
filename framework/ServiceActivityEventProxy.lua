autoImport('ServiceActivityEventAutoProxy')
ServiceActivityEventProxy = class('ServiceActivityEventProxy', ServiceActivityEventAutoProxy)
ServiceActivityEventProxy.Instance = nil
ServiceActivityEventProxy.NAME = 'ServiceActivityEventProxy'

function ServiceActivityEventProxy:ctor(proxyName)
	if ServiceActivityEventProxy.Instance == nil then
		self.proxyName = proxyName or ServiceActivityEventProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceActivityEventProxy.Instance = self
	end
end

function ServiceActivityEventProxy:RecvActivityEventNtf(data) 
	ActivityEventProxy.Instance:RecvActivityEventNtf(data)
	self:Notify(ServiceEvent.ActivityEventActivityEventNtf, data)
end

function ServiceActivityEventProxy:RecvActivityEventUserDataNtf(data) 
	ActivityEventProxy.Instance:RecvActivityEventUserDataNtf(data)
	self:Notify(ServiceEvent.ActivityEventActivityEventUserDataNtf, data)
end

function ServiceActivityEventProxy:RecvActivityEventNtfEventCntCmd(data) 
	ActivityEventProxy.Instance:RecvActivityEventNtfEventCntCmd(data)
	self:Notify(ServiceEvent.ActivityEventActivityEventNtfEventCntCmd, data)
end