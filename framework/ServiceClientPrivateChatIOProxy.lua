autoImport('ServiceClientPrivateChatIOAutoProxy')
ServiceClientPrivateChatIOProxy = class('ServiceClientPrivateChatIOProxy', ServiceClientPrivateChatIOAutoProxy)
ServiceClientPrivateChatIOProxy.Instance = nil
ServiceClientPrivateChatIOProxy.NAME = 'ServiceClientPrivateChatIOProxy'

function ServiceClientPrivateChatIOProxy:ctor(proxyName)
	if ServiceClientPrivateChatIOProxy.Instance == nil then
		self.proxyName = proxyName or ServiceClientPrivateChatIOProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceClientPrivateChatIOProxy.Instance = self
	end
end
