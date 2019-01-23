autoImport('ServiceSessionCmdAutoProxy')
ServiceSessionCmdProxy = class('ServiceSessionCmdProxy', ServiceSessionCmdAutoProxy)
ServiceSessionCmdProxy.Instance = nil
ServiceSessionCmdProxy.NAME = 'ServiceSessionCmdProxy'

function ServiceSessionCmdProxy:ctor(proxyName)
	if ServiceSessionCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSessionCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSessionCmdProxy.Instance = self
	end
end
