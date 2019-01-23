autoImport('ServicePvpCmdAutoProxy')
ServicePvpCmdProxy = class('ServicePvpCmdProxy', ServicePvpCmdAutoProxy)
ServicePvpCmdProxy.Instance = nil
ServicePvpCmdProxy.NAME = 'ServicePvpCmdProxy'

function ServicePvpCmdProxy:ctor(proxyName)
	if ServicePvpCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServicePvpCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServicePvpCmdProxy.Instance = self
	end
end

function ServicePvpCmdProxy:RecvNtfPvpStatus(data)
	helplog("PvpCmd s2c NtfPvpStatus", data.pvp_type, data.status);

	PvpProxy.Instance:SetPvpStatus(data.pvp_type, data.status);
	self:Notify(ServiceEvent.PvpCmdNtfPvpStatus, data)
end

function ServicePvpCmdProxy:CallJoinTeamMatch(pvp_type) 
	helplog("PvpCmd c2s JoinTeamMatch", pvp_type);
	ServicePvpCmdProxy.super.CallJoinTeamMatch(self, pvp_type);
end
