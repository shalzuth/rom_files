autoImport('ServiceRedisAutoProxy')
ServiceRedisProxy = class('ServiceRedisProxy', ServiceRedisAutoProxy)
ServiceRedisProxy.Instance = nil
ServiceRedisProxy.NAME = 'ServiceRedisProxy'

function ServiceRedisProxy:ctor(proxyName)
	if ServiceRedisProxy.Instance == nil then
		self.proxyName = proxyName or ServiceRedisProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceRedisProxy.Instance = self
	end
end
