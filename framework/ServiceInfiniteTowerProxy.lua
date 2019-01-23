autoImport('ServiceInfiniteTowerAutoProxy')
ServiceInfiniteTowerProxy = class('ServiceInfiniteTowerProxy', ServiceInfiniteTowerAutoProxy)
ServiceInfiniteTowerProxy.Instance = nil
ServiceInfiniteTowerProxy.NAME = 'ServiceInfiniteTowerProxy'

function ServiceInfiniteTowerProxy:ctor(proxyName)
	if ServiceInfiniteTowerProxy.Instance == nil then
		self.proxyName = proxyName or ServiceInfiniteTowerProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceInfiniteTowerProxy.Instance = self
	end
end

function ServiceInfiniteTowerProxy:RecvTeamTowerSummaryCmd(data) 
	EndlessTowerProxy.Instance:RecvTeamTowerSummary(data)
	self:Notify(ServiceEvent.InfiniteTowerTeamTowerSummaryCmd, data)
end

function ServiceInfiniteTowerProxy:RecvUserTowerInfoCmd(data) 
	EndlessTowerProxy.Instance:RecvUserTowerInfo(data)
	self:Notify(ServiceEvent.InfiniteTowerUserTowerInfoCmd, data)
end

function ServiceInfiniteTowerProxy:RecvTowerInfoCmd(data) 
	EndlessTowerProxy.Instance:RecvTowerInfo(data)
	self:Notify(ServiceEvent.InfiniteTowerTowerInfoCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTowerLayerSyncTowerCmd(data) 
	EndlessTowerProxy.Instance:RecvTowerLayerSyncTowerCmd(data)
	FunctionTeam.Me():ChangeEndlessTowerGoal();
	self:Notify(ServiceEvent.InfiniteTowerTowerLayerSyncTowerCmd, data)
end