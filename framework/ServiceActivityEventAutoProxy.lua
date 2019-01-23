ServiceActivityEventAutoProxy = class('ServiceActivityEventAutoProxy', ServiceProxy)

ServiceActivityEventAutoProxy.Instance = nil

ServiceActivityEventAutoProxy.NAME = 'ServiceActivityEventAutoProxy'

function ServiceActivityEventAutoProxy:ctor(proxyName)
	if ServiceActivityEventAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceActivityEventAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceActivityEventAutoProxy.Instance = self
	end
end

function ServiceActivityEventAutoProxy:Init()
end

function ServiceActivityEventAutoProxy:onRegister()
	self:Listen(64, 1, function (data)
		self:RecvActivityEventNtf(data) 
	end)
	self:Listen(64, 2, function (data)
		self:RecvActivityEventUserDataNtf(data) 
	end)
	self:Listen(64, 3, function (data)
		self:RecvActivityEventNtfEventCntCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceActivityEventAutoProxy:CallActivityEventNtf(events) 
	local msg = ActivityEvent_pb.ActivityEventNtf()
	if( events ~= nil )then
		for i=1,#events do 
			table.insert(msg.events, events[i])
		end
	end
	self:SendProto(msg)
end

function ServiceActivityEventAutoProxy:CallActivityEventUserDataNtf(rewarditems) 
	local msg = ActivityEvent_pb.ActivityEventUserDataNtf()
	if( rewarditems ~= nil )then
		for i=1,#rewarditems do 
			table.insert(msg.rewarditems, rewarditems[i])
		end
	end
	self:SendProto(msg)
end

function ServiceActivityEventAutoProxy:CallActivityEventNtfEventCntCmd(cnt) 
	local msg = ActivityEvent_pb.ActivityEventNtfEventCntCmd()
	if( cnt ~= nil )then
		for i=1,#cnt do 
			table.insert(msg.cnt, cnt[i])
		end
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceActivityEventAutoProxy:RecvActivityEventNtf(data) 
	self:Notify(ServiceEvent.ActivityEventActivityEventNtf, data)
end

function ServiceActivityEventAutoProxy:RecvActivityEventUserDataNtf(data) 
	self:Notify(ServiceEvent.ActivityEventActivityEventUserDataNtf, data)
end

function ServiceActivityEventAutoProxy:RecvActivityEventNtfEventCntCmd(data) 
	self:Notify(ServiceEvent.ActivityEventActivityEventNtfEventCntCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.ActivityEventActivityEventNtf = "ServiceEvent_ActivityEventActivityEventNtf"
ServiceEvent.ActivityEventActivityEventUserDataNtf = "ServiceEvent_ActivityEventActivityEventUserDataNtf"
ServiceEvent.ActivityEventActivityEventNtfEventCntCmd = "ServiceEvent_ActivityEventActivityEventNtfEventCntCmd"
