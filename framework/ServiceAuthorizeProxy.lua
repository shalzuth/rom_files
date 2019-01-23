autoImport('ServiceAuthorizeAutoProxy')
ServiceAuthorizeProxy = class('ServiceAuthorizeProxy', ServiceAuthorizeAutoProxy)
ServiceAuthorizeProxy.Instance = nil
ServiceAuthorizeProxy.NAME = 'ServiceAuthorizeProxy'

function ServiceAuthorizeProxy:ctor(proxyName)
	if ServiceAuthorizeProxy.Instance == nil then
		self.proxyName = proxyName or ServiceAuthorizeProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceAuthorizeProxy.Instance = self
	end
end

function ServiceAuthorizeProxy:RecvNotifyAuthorizeUserCmd()
	MsgManager.ShowMsgByIDTable(6013)
	self:Notify(ServiceEvent.AuthorizeNotifyAuthorizeUserCmd, data)
end