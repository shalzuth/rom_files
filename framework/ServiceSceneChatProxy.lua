autoImport('ServiceSceneChatAutoProxy')
ServiceSceneChatProxy = class('ServiceSceneChatProxy', ServiceSceneChatAutoProxy)
ServiceSceneChatProxy.Instance = nil
ServiceSceneChatProxy.NAME = 'ServiceSceneChatProxy'

function ServiceSceneChatProxy:ctor(proxyName)
	if ServiceSceneChatProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneChatProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSceneChatProxy.Instance = self
	end
end
