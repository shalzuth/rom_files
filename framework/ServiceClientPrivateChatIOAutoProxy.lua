ServiceClientPrivateChatIOAutoProxy = class('ServiceClientPrivateChatIOAutoProxy', ServiceProxy)

ServiceClientPrivateChatIOAutoProxy.Instance = nil

ServiceClientPrivateChatIOAutoProxy.NAME = 'ServiceClientPrivateChatIOAutoProxy'

function ServiceClientPrivateChatIOAutoProxy:ctor(proxyName)
	if ServiceClientPrivateChatIOAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceClientPrivateChatIOAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceClientPrivateChatIOAutoProxy.Instance = self
	end
end

function ServiceClientPrivateChatIOAutoProxy:Init()
end

function ServiceClientPrivateChatIOAutoProxy:onRegister()
end

-- *********************************************** Call ***********************************************
-- *********************************************** Recv ***********************************************
ServiceEvent = _G["ServiceEvent"] or {}
