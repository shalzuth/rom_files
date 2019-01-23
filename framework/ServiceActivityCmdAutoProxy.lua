ServiceActivityCmdAutoProxy = class('ServiceActivityCmdAutoProxy', ServiceProxy)

ServiceActivityCmdAutoProxy.Instance = nil

ServiceActivityCmdAutoProxy.NAME = 'ServiceActivityCmdAutoProxy'

function ServiceActivityCmdAutoProxy:ctor(proxyName)
	if ServiceActivityCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceActivityCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceActivityCmdAutoProxy.Instance = self
	end
end

function ServiceActivityCmdAutoProxy:Init()
end

function ServiceActivityCmdAutoProxy:onRegister()
	self:Listen(60, 1, function (data)
		self:RecvStartActCmd(data) 
	end)
	self:Listen(60, 4, function (data)
		self:RecvStopActCmd(data) 
	end)
	self:Listen(60, 2, function (data)
		self:RecvBCatUFOPosActCmd(data) 
	end)
	self:Listen(60, 3, function (data)
		self:RecvActProgressNtfCmd(data) 
	end)
	self:Listen(60, 5, function (data)
		self:RecvStartGlobalActCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceActivityCmdAutoProxy:CallStartActCmd(id, mapid, starttime, endtime, path, unshowmap) 
	local msg = ActivityCmd_pb.StartActCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(mapid ~= nil )then
		msg.mapid = mapid
	end
	if(starttime ~= nil )then
		msg.starttime = starttime
	end
	if(endtime ~= nil )then
		msg.endtime = endtime
	end
	if(path ~= nil )then
		msg.path = path
	end
	if( unshowmap ~= nil )then
		for i=1,#unshowmap do 
			table.insert(msg.unshowmap, unshowmap[i])
		end
	end
	self:SendProto(msg)
end

function ServiceActivityCmdAutoProxy:CallStopActCmd(id) 
	local msg = ActivityCmd_pb.StopActCmd()
	if(id ~= nil )then
		msg.id = id
	end
	self:SendProto(msg)
end

function ServiceActivityCmdAutoProxy:CallBCatUFOPosActCmd(pos) 
	local msg = ActivityCmd_pb.BCatUFOPosActCmd()
	if(pos ~= nil )then
		if(pos.x ~= nil )then
			msg.pos.x = pos.x
		end
	end
	if(pos ~= nil )then
		if(pos.y ~= nil )then
			msg.pos.y = pos.y
		end
	end
	if(pos ~= nil )then
		if(pos.z ~= nil )then
			msg.pos.z = pos.z
		end
	end
	self:SendProto(msg)
end

function ServiceActivityCmdAutoProxy:CallActProgressNtfCmd(id, progress, endtime, starttime) 
	local msg = ActivityCmd_pb.ActProgressNtfCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(progress ~= nil )then
		msg.progress = progress
	end
	if(endtime ~= nil )then
		msg.endtime = endtime
	end
	if(starttime ~= nil )then
		msg.starttime = starttime
	end
	self:SendProto(msg)
end

function ServiceActivityCmdAutoProxy:CallStartGlobalActCmd(id, type, params, starttime, endtime, open, count) 
	local msg = ActivityCmd_pb.StartGlobalActCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(type ~= nil )then
		msg.type = type
	end
	if( params ~= nil )then
		for i=1,#params do 
			table.insert(msg.params, params[i])
		end
	end
	if(starttime ~= nil )then
		msg.starttime = starttime
	end
	if(endtime ~= nil )then
		msg.endtime = endtime
	end
	if(open ~= nil )then
		msg.open = open
	end
	if(count ~= nil )then
		msg.count = count
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceActivityCmdAutoProxy:RecvStartActCmd(data) 
	self:Notify(ServiceEvent.ActivityCmdStartActCmd, data)
end

function ServiceActivityCmdAutoProxy:RecvStopActCmd(data) 
	self:Notify(ServiceEvent.ActivityCmdStopActCmd, data)
end

function ServiceActivityCmdAutoProxy:RecvBCatUFOPosActCmd(data) 
	self:Notify(ServiceEvent.ActivityCmdBCatUFOPosActCmd, data)
end

function ServiceActivityCmdAutoProxy:RecvActProgressNtfCmd(data) 
	self:Notify(ServiceEvent.ActivityCmdActProgressNtfCmd, data)
end

function ServiceActivityCmdAutoProxy:RecvStartGlobalActCmd(data) 
	self:Notify(ServiceEvent.ActivityCmdStartGlobalActCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.ActivityCmdStartActCmd = "ServiceEvent_ActivityCmdStartActCmd"
ServiceEvent.ActivityCmdStopActCmd = "ServiceEvent_ActivityCmdStopActCmd"
ServiceEvent.ActivityCmdBCatUFOPosActCmd = "ServiceEvent_ActivityCmdBCatUFOPosActCmd"
ServiceEvent.ActivityCmdActProgressNtfCmd = "ServiceEvent_ActivityCmdActProgressNtfCmd"
ServiceEvent.ActivityCmdStartGlobalActCmd = "ServiceEvent_ActivityCmdStartGlobalActCmd"
