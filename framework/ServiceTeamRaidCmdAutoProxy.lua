ServiceTeamRaidCmdAutoProxy = class('ServiceTeamRaidCmdAutoProxy', ServiceProxy)

ServiceTeamRaidCmdAutoProxy.Instance = nil

ServiceTeamRaidCmdAutoProxy.NAME = 'ServiceTeamRaidCmdAutoProxy'

function ServiceTeamRaidCmdAutoProxy:ctor(proxyName)
	if ServiceTeamRaidCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceTeamRaidCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceTeamRaidCmdAutoProxy.Instance = self
	end
end

function ServiceTeamRaidCmdAutoProxy:Init()
end

function ServiceTeamRaidCmdAutoProxy:onRegister()
	self:Listen(67, 1, function (data)
		self:RecvTeamRaidInviteCmd(data) 
	end)
	self:Listen(67, 2, function (data)
		self:RecvTeamRaidReplyCmd(data) 
	end)
	self:Listen(67, 3, function (data)
		self:RecvTeamRaidEnterCmd(data) 
	end)
	self:Listen(67, 4, function (data)
		self:RecvTeamRaidAltmanShowCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceTeamRaidCmdAutoProxy:CallTeamRaidInviteCmd(iscancel, raid_type) 
	local msg = TeamRaidCmd_pb.TeamRaidInviteCmd()
	if(iscancel ~= nil )then
		msg.iscancel = iscancel
	end
	if(raid_type ~= nil )then
		msg.raid_type = raid_type
	end
	self:SendProto(msg)
end

function ServiceTeamRaidCmdAutoProxy:CallTeamRaidReplyCmd(reply, charid, raid_type) 
	local msg = TeamRaidCmd_pb.TeamRaidReplyCmd()
	if(reply ~= nil )then
		msg.reply = reply
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(raid_type ~= nil )then
		msg.raid_type = raid_type
	end
	self:SendProto(msg)
end

function ServiceTeamRaidCmdAutoProxy:CallTeamRaidEnterCmd(raid_type, userid, zoneid, time, sign) 
	local msg = TeamRaidCmd_pb.TeamRaidEnterCmd()
	if(raid_type ~= nil )then
		msg.raid_type = raid_type
	end
	if(userid ~= nil )then
		msg.userid = userid
	end
	if(zoneid ~= nil )then
		msg.zoneid = zoneid
	end
	if(time ~= nil )then
		msg.time = time
	end
	if(sign ~= nil )then
		msg.sign = sign
	end
	self:SendProto(msg)
end

function ServiceTeamRaidCmdAutoProxy:CallTeamRaidAltmanShowCmd(lefttime, killcount, selfkill) 
	local msg = TeamRaidCmd_pb.TeamRaidAltmanShowCmd()
	if(lefttime ~= nil )then
		msg.lefttime = lefttime
	end
	if(killcount ~= nil )then
		msg.killcount = killcount
	end
	if(selfkill ~= nil )then
		msg.selfkill = selfkill
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceTeamRaidCmdAutoProxy:RecvTeamRaidInviteCmd(data) 
	self:Notify(ServiceEvent.TeamRaidCmdTeamRaidInviteCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvTeamRaidReplyCmd(data) 
	self:Notify(ServiceEvent.TeamRaidCmdTeamRaidReplyCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvTeamRaidEnterCmd(data) 
	self:Notify(ServiceEvent.TeamRaidCmdTeamRaidEnterCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvTeamRaidAltmanShowCmd(data) 
	self:Notify(ServiceEvent.TeamRaidCmdTeamRaidAltmanShowCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.TeamRaidCmdTeamRaidInviteCmd = "ServiceEvent_TeamRaidCmdTeamRaidInviteCmd"
ServiceEvent.TeamRaidCmdTeamRaidReplyCmd = "ServiceEvent_TeamRaidCmdTeamRaidReplyCmd"
ServiceEvent.TeamRaidCmdTeamRaidEnterCmd = "ServiceEvent_TeamRaidCmdTeamRaidEnterCmd"
ServiceEvent.TeamRaidCmdTeamRaidAltmanShowCmd = "ServiceEvent_TeamRaidCmdTeamRaidAltmanShowCmd"
