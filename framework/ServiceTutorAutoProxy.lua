ServiceTutorAutoProxy = class('ServiceTutorAutoProxy', ServiceProxy)

ServiceTutorAutoProxy.Instance = nil

ServiceTutorAutoProxy.NAME = 'ServiceTutorAutoProxy'

function ServiceTutorAutoProxy:ctor(proxyName)
	if ServiceTutorAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceTutorAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceTutorAutoProxy.Instance = self
	end
end

function ServiceTutorAutoProxy:Init()
end

function ServiceTutorAutoProxy:onRegister()
	self:Listen(31, 1, function (data)
		self:RecvTutorTaskUpdateNtf(data) 
	end)
	self:Listen(31, 2, function (data)
		self:RecvTutorTaskQueryCmd(data) 
	end)
	self:Listen(31, 3, function (data)
		self:RecvTutorTaskTeacherRewardCmd(data) 
	end)
	self:Listen(31, 4, function (data)
		self:RecvTutorGrowRewardUpdateNtf(data) 
	end)
	self:Listen(31, 5, function (data)
		self:RecvTutorGetGrowRewardCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceTutorAutoProxy:CallTutorTaskUpdateNtf(items) 
	local msg = Tutor_pb.TutorTaskUpdateNtf()
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceTutorAutoProxy:CallTutorTaskQueryCmd(charid, items, finishtaskids, refresh) 
	local msg = Tutor_pb.TutorTaskQueryCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	if( finishtaskids ~= nil )then
		for i=1,#finishtaskids do 
			table.insert(msg.finishtaskids, finishtaskids[i])
		end
	end
	if(refresh ~= nil )then
		msg.refresh = refresh
	end
	self:SendProto(msg)
end

function ServiceTutorAutoProxy:CallTutorTaskTeacherRewardCmd(charid, taskid) 
	local msg = Tutor_pb.TutorTaskTeacherRewardCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(taskid ~= nil )then
		msg.taskid = taskid
	end
	self:SendProto(msg)
end

function ServiceTutorAutoProxy:CallTutorGrowRewardUpdateNtf(growrewards) 
	local msg = Tutor_pb.TutorGrowRewardUpdateNtf()
	if( growrewards ~= nil )then
		for i=1,#growrewards do 
			table.insert(msg.growrewards, growrewards[i])
		end
	end
	self:SendProto(msg)
end

function ServiceTutorAutoProxy:CallTutorGetGrowRewardCmd() 
	local msg = Tutor_pb.TutorGetGrowRewardCmd()
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceTutorAutoProxy:RecvTutorTaskUpdateNtf(data) 
	self:Notify(ServiceEvent.TutorTutorTaskUpdateNtf, data)
end

function ServiceTutorAutoProxy:RecvTutorTaskQueryCmd(data) 
	self:Notify(ServiceEvent.TutorTutorTaskQueryCmd, data)
end

function ServiceTutorAutoProxy:RecvTutorTaskTeacherRewardCmd(data) 
	self:Notify(ServiceEvent.TutorTutorTaskTeacherRewardCmd, data)
end

function ServiceTutorAutoProxy:RecvTutorGrowRewardUpdateNtf(data) 
	self:Notify(ServiceEvent.TutorTutorGrowRewardUpdateNtf, data)
end

function ServiceTutorAutoProxy:RecvTutorGetGrowRewardCmd(data) 
	self:Notify(ServiceEvent.TutorTutorGetGrowRewardCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.TutorTutorTaskUpdateNtf = "ServiceEvent_TutorTutorTaskUpdateNtf"
ServiceEvent.TutorTutorTaskQueryCmd = "ServiceEvent_TutorTutorTaskQueryCmd"
ServiceEvent.TutorTutorTaskTeacherRewardCmd = "ServiceEvent_TutorTutorTaskTeacherRewardCmd"
ServiceEvent.TutorTutorGrowRewardUpdateNtf = "ServiceEvent_TutorTutorGrowRewardUpdateNtf"
ServiceEvent.TutorTutorGetGrowRewardCmd = "ServiceEvent_TutorTutorGetGrowRewardCmd"
