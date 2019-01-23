-- game server connect
local ServiceNpcProxy = class('ServiceNpcProxy', ServiceProxy)

ServiceNpcProxy.Instance = nil;

ServiceNpcProxy.NAME = "ServiceNpcProxy"

function ServiceNpcProxy:ctor(proxyName)	
	if ServiceNpcProxy.Instance == nil then		
		self.proxyName = proxyName or ServiceNpcProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceNpcProxy.Instance = self
	end
end

function ServiceNpcProxy:Init()	

end

function ServiceNpcProxy:onRegister()
	self:Listen(5, 32, function (data)
		self:NpcDie(data)
	end)

	self:Listen(5, 37, function (data)
		self:NpcChangeHp(data) 
	end)
end

function ServiceNpcProxy:NpcDie(data)
	-- SceneNpcProxy.Instance:Die(data.id)
	-- self:Notify(ServiceEvent.NpcDie, data)
end

function ServiceNpcProxy:NpcChangeHp(data) 
	self:Notify(ServiceEvent.NpcChangeHp, data)
end

return ServiceNpcProxy