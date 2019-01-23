autoImport('ServiceTeamRaidCmdAutoProxy')
ServiceTeamRaidCmdProxy = class('ServiceTeamRaidCmdProxy', ServiceTeamRaidCmdAutoProxy)
ServiceTeamRaidCmdProxy.Instance = nil
ServiceTeamRaidCmdProxy.NAME = 'ServiceTeamRaidCmdProxy'

function ServiceTeamRaidCmdProxy:ctor(proxyName)
	if ServiceTeamRaidCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceTeamRaidCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceTeamRaidCmdProxy.Instance = self
	end
end

function ServiceTeamRaidCmdProxy:CallTeamRaidInviteCmd(iscancel, raid_type) 
	helplog("Call-->TeamRaidInviteCmd", iscancel, raid_type);
	ServiceTeamRaidCmdProxy.super.CallTeamRaidInviteCmd(self, iscancel, raid_type);
end

function ServiceTeamRaidCmdProxy:CallTeamRaidReplyCmd(reply, charid, raid_type) 
	helplog("Call-->TeamRaidReplyCmd", reply);
	ServiceTeamRaidCmdProxy.super.CallTeamRaidReplyCmd(self, reply, charid, raid_type);
end

function ServiceTeamRaidCmdProxy:CallTeamRaidEnterCmd(raid_type, userid, zoneid, time, sign) 
	helplog("Call-->TeamRaidEnterCmd", raid_type);
	ServiceTeamRaidCmdProxy.super.CallTeamRaidEnterCmd(self, raid_type, userid, zoneid, time, sign);
end



function ServiceTeamRaidCmdProxy:RecvTeamRaidReplyCmd(data) 
	helplog("Recv-->TeamRaidReplyCmd");
	self:Notify(ServiceEvent.TeamRaidCmdTeamRaidReplyCmd, data)
end

function ServiceTeamRaidCmdProxy:RecvTeamRaidEnterCmd(data) 
	self:Notify(ServiceEvent.TeamRaidCmdTeamRaidEnterCmd, data)
end

function ServiceTeamRaidCmdProxy:RecvTeamRaidAltmanShowCmd(data) 
	helplog("Recv-->TeamRaidAltmanShowCmd", data.lefttime, data.killcount, data.selfkill);
	DungeonProxy.Instance:UpdateAltManRaidInfo(data.lefttime, data.killcount, data.selfkill);
	self:Notify(ServiceEvent.TeamRaidCmdTeamRaidAltmanShowCmd, data)
end