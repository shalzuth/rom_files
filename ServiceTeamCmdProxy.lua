autoImport('ServiceTeamCmdAutoProxy')
ServiceTeamCmdProxy = class('ServiceTeamCmdProxy', ServiceTeamCmdAutoProxy)
ServiceTeamCmdProxy.Instance = nil
ServiceTeamCmdProxy.NAME = 'ServiceTeamCmdProxy'

function ServiceTeamCmdProxy:ctor(proxyName)
	if ServiceTeamCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceTeamCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceTeamCmdProxy.Instance = self
	end
end
