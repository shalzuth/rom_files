local ServiceGMProxy = class('ServiceGMProxy', ServiceProxy)

ServiceGMProxy.Instance = nil;

ServiceGMProxy.NAME = "ServiceGMProxy"

function ServiceGMProxy:ctor(proxyName)	
	if ServiceGMProxy.Instance == nil then		
		self.proxyName = proxyName or ServiceGMProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceGMProxy.Instance = self
	end
end

function ServiceGMProxy:Init()	

end

function ServiceGMProxy:onRegister()
	
end

function ServiceGMProxy:Call(command)
	local msg = SceneUser_pb.UserGMCommand()
	msg.command = command
	self:SendProto(msg)
end

return ServiceGMProxy