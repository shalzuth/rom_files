autoImport('ServiceGuildSCmdAutoProxy')
ServiceGuildSCmdProxy = class('ServiceGuildSCmdProxy', ServiceGuildSCmdAutoProxy)
ServiceGuildSCmdProxy.Instance = nil
ServiceGuildSCmdProxy.NAME = 'ServiceGuildSCmdProxy'

function ServiceGuildSCmdProxy:ctor(proxyName)
	if ServiceGuildSCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceGuildSCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceGuildSCmdProxy.Instance = self
	end
end
