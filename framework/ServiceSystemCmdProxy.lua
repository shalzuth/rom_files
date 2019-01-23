autoImport('ServiceSystemCmdAutoProxy')
ServiceSystemCmdProxy = class('ServiceSystemCmdProxy', ServiceSystemCmdAutoProxy)
ServiceSystemCmdProxy.Instance = nil
ServiceSystemCmdProxy.NAME = 'ServiceSystemCmdProxy'

function ServiceSystemCmdProxy:ctor(proxyName)
	if ServiceSystemCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSystemCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSystemCmdProxy.Instance = self
	end
end
