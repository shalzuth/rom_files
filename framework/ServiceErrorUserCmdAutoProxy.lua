ServiceErrorUserCmdAutoProxy = class('ServiceErrorUserCmdAutoProxy', ServiceProxy)

ServiceErrorUserCmdAutoProxy.Instance = nil

ServiceErrorUserCmdAutoProxy.NAME = 'ServiceErrorUserCmdAutoProxy'

function ServiceErrorUserCmdAutoProxy:ctor(proxyName)
	if ServiceErrorUserCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceErrorUserCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceErrorUserCmdAutoProxy.Instance = self
	end
end

function ServiceErrorUserCmdAutoProxy:Init()
end

function ServiceErrorUserCmdAutoProxy:onRegister()
	self:Listen(2, 1, function (data)
		self:RecvRegErrUserCmd(data) 
	end)
	self:Listen(2, 2, function (data)
		self:RecvKickUserErrorCmd(data) 
	end)
	self:Listen(2, 3, function (data)
		self:RecvMaintainUserCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceErrorUserCmdAutoProxy:CallRegErrUserCmd(ret, accid, zoneID, charid, args) 
	local msg = ErrorUserCmd_pb.RegErrUserCmd()
	msg.ret = ret
	if(accid ~= nil )then
		msg.accid = accid
	end
	if(zoneID ~= nil )then
		msg.zoneID = zoneID
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	if( args ~= nil )then
		for i=1,#args do 
			table.insert(msg.args, args[i])
		end
	end
	self:SendProto(msg)
end

function ServiceErrorUserCmdAutoProxy:CallKickUserErrorCmd(accid) 
	local msg = ErrorUserCmd_pb.KickUserErrorCmd()
	if(accid ~= nil )then
		msg.accid = accid
	end
	self:SendProto(msg)
end

function ServiceErrorUserCmdAutoProxy:CallMaintainUserCmd(content, tip, picture) 
	local msg = ErrorUserCmd_pb.MaintainUserCmd()
	if(content ~= nil )then
		msg.content = content
	end
	if(tip ~= nil )then
		msg.tip = tip
	end
	if(picture ~= nil )then
		msg.picture = picture
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceErrorUserCmdAutoProxy:RecvRegErrUserCmd(data) 
	self:Notify(ServiceEvent.ErrorUserCmdRegErrUserCmd, data)
end

function ServiceErrorUserCmdAutoProxy:RecvKickUserErrorCmd(data) 
	self:Notify(ServiceEvent.ErrorUserCmdKickUserErrorCmd, data)
end

function ServiceErrorUserCmdAutoProxy:RecvMaintainUserCmd(data) 
	self:Notify(ServiceEvent.ErrorUserCmdMaintainUserCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.ErrorUserCmdRegErrUserCmd = "ServiceEvent_ErrorUserCmdRegErrUserCmd"
ServiceEvent.ErrorUserCmdKickUserErrorCmd = "ServiceEvent_ErrorUserCmdKickUserErrorCmd"
ServiceEvent.ErrorUserCmdMaintainUserCmd = "ServiceEvent_ErrorUserCmdMaintainUserCmd"
