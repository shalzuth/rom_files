ServiceAstrolabeCmdAutoProxy = class('ServiceAstrolabeCmdAutoProxy', ServiceProxy)

ServiceAstrolabeCmdAutoProxy.Instance = nil

ServiceAstrolabeCmdAutoProxy.NAME = 'ServiceAstrolabeCmdAutoProxy'

function ServiceAstrolabeCmdAutoProxy:ctor(proxyName)
	if ServiceAstrolabeCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceAstrolabeCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceAstrolabeCmdAutoProxy.Instance = self
	end
end

function ServiceAstrolabeCmdAutoProxy:Init()
end

function ServiceAstrolabeCmdAutoProxy:onRegister()
	self:Listen(28, 1, function (data)
		self:RecvAstrolabeQueryCmd(data) 
	end)
	self:Listen(28, 2, function (data)
		self:RecvAstrolabeActivateStarCmd(data) 
	end)
	self:Listen(28, 3, function (data)
		self:RecvAstrolabeQueryResetCmd(data) 
	end)
	self:Listen(28, 4, function (data)
		self:RecvAstrolabeResetCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceAstrolabeCmdAutoProxy:CallAstrolabeQueryCmd(stars) 
	local msg = AstrolabeCmd_pb.AstrolabeQueryCmd()
	if( stars ~= nil )then
		for i=1,#stars do 
			table.insert(msg.stars, stars[i])
		end
	end
	self:SendProto(msg)
end

function ServiceAstrolabeCmdAutoProxy:CallAstrolabeActivateStarCmd(stars, success) 
	local msg = AstrolabeCmd_pb.AstrolabeActivateStarCmd()
	if( stars ~= nil )then
		for i=1,#stars do 
			table.insert(msg.stars, stars[i])
		end
	end
	if(success ~= nil )then
		msg.success = success
	end
	self:SendProto(msg)
end

function ServiceAstrolabeCmdAutoProxy:CallAstrolabeQueryResetCmd(type, items) 
	local msg = AstrolabeCmd_pb.AstrolabeQueryResetCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceAstrolabeCmdAutoProxy:CallAstrolabeResetCmd(stars, success) 
	local msg = AstrolabeCmd_pb.AstrolabeResetCmd()
	if( stars ~= nil )then
		for i=1,#stars do 
			table.insert(msg.stars, stars[i])
		end
	end
	if(success ~= nil )then
		msg.success = success
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceAstrolabeCmdAutoProxy:RecvAstrolabeQueryCmd(data) 
	self:Notify(ServiceEvent.AstrolabeCmdAstrolabeQueryCmd, data)
end

function ServiceAstrolabeCmdAutoProxy:RecvAstrolabeActivateStarCmd(data) 
	self:Notify(ServiceEvent.AstrolabeCmdAstrolabeActivateStarCmd, data)
end

function ServiceAstrolabeCmdAutoProxy:RecvAstrolabeQueryResetCmd(data) 
	self:Notify(ServiceEvent.AstrolabeCmdAstrolabeQueryResetCmd, data)
end

function ServiceAstrolabeCmdAutoProxy:RecvAstrolabeResetCmd(data) 
	self:Notify(ServiceEvent.AstrolabeCmdAstrolabeResetCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.AstrolabeCmdAstrolabeQueryCmd = "ServiceEvent_AstrolabeCmdAstrolabeQueryCmd"
ServiceEvent.AstrolabeCmdAstrolabeActivateStarCmd = "ServiceEvent_AstrolabeCmdAstrolabeActivateStarCmd"
ServiceEvent.AstrolabeCmdAstrolabeQueryResetCmd = "ServiceEvent_AstrolabeCmdAstrolabeQueryResetCmd"
ServiceEvent.AstrolabeCmdAstrolabeResetCmd = "ServiceEvent_AstrolabeCmdAstrolabeResetCmd"
