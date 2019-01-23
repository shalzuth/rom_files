autoImport('ServiceSysMsgAutoProxy')
ServiceSysMsgProxy = class('ServiceSysMsgProxy', ServiceSysMsgAutoProxy)
ServiceSysMsgProxy.Instance = nil
ServiceSysMsgProxy.NAME = 'ServiceSysMsgProxy'

function ServiceSysMsgProxy:ctor(proxyName)
	if ServiceSysMsgProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSysMsgProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSysMsgProxy.Instance = self
	end
end
