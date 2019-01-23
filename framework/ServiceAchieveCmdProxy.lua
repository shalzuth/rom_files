autoImport('ServiceAchieveCmdAutoProxy')
ServiceAchieveCmdProxy = class('ServiceAchieveCmdProxy', ServiceAchieveCmdAutoProxy)
ServiceAchieveCmdProxy.Instance = nil
ServiceAchieveCmdProxy.NAME = 'ServiceAchieveCmdProxy'

function ServiceAchieveCmdProxy:ctor(proxyName)
	if ServiceAchieveCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceAchieveCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceAchieveCmdProxy.Instance = self
	end
end

function ServiceAchieveCmdProxy:RecvQueryUserResumeAchCmd(data) 
	AdventureAchieveProxy.Instance:QueryUserResumeAchCmd(data)
	self:Notify(ServiceEvent.AchieveCmdQueryUserResumeAchCmd, data)
end

function ServiceAchieveCmdProxy:RecvQueryAchieveDataAchCmd(data)
	AdventureAchieveProxy.Instance:QueryAchieveDataAchCmd(data)
	self:Notify(ServiceEvent.AchieveCmdQueryAchieveDataAchCmd, data)
end

function ServiceAchieveCmdProxy:RecvNewAchieveNtfAchCmd(data) 
	AdventureAchieveProxy.Instance:QueryAchieveDataAchCmd(data)
	self:Notify(ServiceEvent.AchieveCmdNewAchieveNtfAchCmd, data)
end