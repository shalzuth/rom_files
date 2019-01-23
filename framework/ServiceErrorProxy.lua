local ServiceErrorProxy = class('ServiceErrorProxy', ServiceProxy)

ServiceErrorProxy.Instance = nil;

ServiceErrorProxy.NAME = "ServiceErrorProxy"

function ServiceErrorProxy:ctor(proxyName)	
	if ServiceErrorProxy.Instance == nil then		
		self.proxyName = proxyName or ServiceErrorProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		ServiceErrorProxy.Instance = self
	end
end

function ServiceErrorProxy:onRegister()
	self:Listen(1, 4, function (data)
		MsgManager.ShowMsgByID(data.id)
		
		self:Notify(ServiceEvent.Error)
	end)	
end

return ServiceErrorProxy