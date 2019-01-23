autoImport('ServiceTutorAutoProxy')
ServiceTutorProxy = class('ServiceTutorProxy', ServiceTutorAutoProxy)
ServiceTutorProxy.Instance = nil
ServiceTutorProxy.NAME = 'ServiceTutorProxy'

function ServiceTutorProxy:ctor(proxyName)
	if ServiceTutorProxy.Instance == nil then
		self.proxyName = proxyName or ServiceTutorProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceTutorProxy.Instance = self
	end
end

function ServiceTutorProxy:RecvTutorTaskUpdateNtf(data)
	TutorProxy.Instance:UpdateQuest(data.items)
	self:Notify(ServiceEvent.TutorTutorTaskUpdateNtf, data)
end

function ServiceTutorProxy:RecvTutorTaskQueryCmd(data) 
	TutorProxy.Instance:RecvTutorTaskQueryCmd(data)
	self:Notify(ServiceEvent.TutorTutorTaskQueryCmd, data)
end

function ServiceTutorProxy:RecvTutorTaskTeacherRewardCmd(data) 
	TutorProxy.Instance:RecvTutorTaskTeacherRewardCmd(data)
	self:Notify(ServiceEvent.TutorTutorTaskTeacherRewardCmd, data)
end

function ServiceTutorProxy:RecvGrowupRewardCmd(data)
	self:Notify(ServiceEvent.TutorTutorGetGrowRewardCmd, data)
end

function ServiceTutorProxy:RecvTutorGrowRewardUpdateNtf(data)
	TutorProxy.Instance:UpdateRewardState(data)
	self:Notify(ServiceEvent.TutorTutorGrowRewardUpdateNtf, data)
end