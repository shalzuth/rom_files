ServiceRedisAutoProxy = class('ServiceRedisAutoProxy', ServiceProxy)

ServiceRedisAutoProxy.Instance = nil

ServiceRedisAutoProxy.NAME = 'ServiceRedisAutoProxy'

function ServiceRedisAutoProxy:ctor(proxyName)
	if ServiceRedisAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceRedisAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceRedisAutoProxy.Instance = self
	end
end

function ServiceRedisAutoProxy:Init()
end

function ServiceRedisAutoProxy:onRegister()
end

-- *********************************************** Call ***********************************************
-- *********************************************** Recv ***********************************************
ServiceEvent = _G["ServiceEvent"] or {}
