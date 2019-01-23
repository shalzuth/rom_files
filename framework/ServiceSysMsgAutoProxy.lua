ServiceSysMsgAutoProxy = class('ServiceSysMsgAutoProxy', ServiceProxy)

ServiceSysMsgAutoProxy.Instance = nil

ServiceSysMsgAutoProxy.NAME = 'ServiceSysMsgAutoProxy'

function ServiceSysMsgAutoProxy:ctor(proxyName)
	if ServiceSysMsgAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSysMsgAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSysMsgAutoProxy.Instance = self
	end
end

function ServiceSysMsgAutoProxy:Init()
end

function ServiceSysMsgAutoProxy:onRegister()
end

-- *********************************************** Call ***********************************************
-- *********************************************** Recv ***********************************************
ServiceEvent = _G["ServiceEvent"] or {}
