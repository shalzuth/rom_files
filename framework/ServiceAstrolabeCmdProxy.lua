autoImport('ServiceAstrolabeCmdAutoProxy')
ServiceAstrolabeCmdProxy = class('ServiceAstrolabeCmdProxy', ServiceAstrolabeCmdAutoProxy)
ServiceAstrolabeCmdProxy.Instance = nil
ServiceAstrolabeCmdProxy.NAME = 'ServiceAstrolabeCmdProxy'

function ServiceAstrolabeCmdProxy:ctor(proxyName)
	if ServiceAstrolabeCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceAstrolabeCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceAstrolabeCmdProxy.Instance = self
	end
end

function ServiceAstrolabeCmdProxy:CallAstrolabeQueryCmd(stars) 
	ServiceAstrolabeCmdProxy.super.CallAstrolabeQueryCmd(self, stars);
end

function ServiceAstrolabeCmdProxy:RecvAstrolabeQueryCmd(data) 
	AstrolabeProxy.Instance:Server_SetActivePoints(data.stars);
	self:Notify(ServiceEvent.AstrolabeCmdAstrolabeQueryCmd, data)
end

function ServiceAstrolabeCmdProxy:CallAstrolabeActivateStarCmd(stars, success)
	ServiceAstrolabeCmdProxy.super.CallAstrolabeActivateStarCmd(self, stars, success);

	-- self:RecvAstrolabeActivateStarCmd({stars = stars, success = true});
end

function ServiceAstrolabeCmdProxy:RecvAstrolabeActivateStarCmd(data)
	if(data.success)then
		AstrolabeProxy.Instance:Server_SetActivePoints(data.stars);
	end
	self:Notify(ServiceEvent.AstrolabeCmdAstrolabeActivateStarCmd, data)
end

function ServiceAstrolabeCmdProxy:CallAstrolabeQueryResetCmd(items) 
	ServiceAstrolabeCmdProxy.super.CallAstrolabeQueryResetCmd(self, items);
end

function ServiceAstrolabeCmdProxy:RecvAstrolabeQueryResetCmd(data) 
	self:Notify(ServiceEvent.AstrolabeCmdAstrolabeQueryResetCmd, data)
end

function ServiceAstrolabeCmdProxy:CallAstrolabeResetCmd(stars, success) 
	ServiceAstrolabeCmdProxy.super.CallAstrolabeResetCmd(self, stars, success);
	-- self:RecvAstrolabeResetCmd({success = true, stars = stars});
end

function ServiceAstrolabeCmdProxy:RecvAstrolabeResetCmd(data) 
	if(data.success)then
		-- helplog("Recv-->AstrolabeResetCmd", data.stars);
		AstrolabeProxy.Instance:Server_ResetPoints(data.stars);
	end
	self:Notify(ServiceEvent.AstrolabeCmdAstrolabeResetCmd, data)
end
