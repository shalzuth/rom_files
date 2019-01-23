ServiceSceneSealAutoProxy = class('ServiceSceneSealAutoProxy', ServiceProxy)

ServiceSceneSealAutoProxy.Instance = nil

ServiceSceneSealAutoProxy.NAME = 'ServiceSceneSealAutoProxy'

function ServiceSceneSealAutoProxy:ctor(proxyName)
	if ServiceSceneSealAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneSealAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSceneSealAutoProxy.Instance = self
	end
end

function ServiceSceneSealAutoProxy:Init()
end

function ServiceSceneSealAutoProxy:onRegister()
	self:Listen(21, 1, function (data)
		self:RecvQuerySeal(data) 
	end)
	self:Listen(21, 2, function (data)
		self:RecvUpdateSeal(data) 
	end)
	self:Listen(21, 3, function (data)
		self:RecvSealTimer(data) 
	end)
	self:Listen(21, 4, function (data)
		self:RecvBeginSeal(data) 
	end)
	self:Listen(21, 5, function (data)
		self:RecvEndSeal(data) 
	end)
	self:Listen(21, 6, function (data)
		self:RecvSealUserLeave(data) 
	end)
	self:Listen(21, 7, function (data)
		self:RecvSealQueryList(data) 
	end)
	self:Listen(21, 8, function (data)
		self:RecvSealAcceptCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSceneSealAutoProxy:CallQuerySeal(datas) 
	local msg = SceneSeal_pb.QuerySeal()
	if( datas ~= nil )then
		for i=1,#datas do 
			table.insert(msg.datas, datas[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneSealAutoProxy:CallUpdateSeal(newdata, deldata) 
	local msg = SceneSeal_pb.UpdateSeal()
	if( newdata ~= nil )then
		for i=1,#newdata do 
			table.insert(msg.newdata, newdata[i])
		end
	end
	if( deldata ~= nil )then
		for i=1,#deldata do 
			table.insert(msg.deldata, deldata[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneSealAutoProxy:CallSealTimer(speed, curvalue, maxvalue, stoptime, maxtime) 
	local msg = SceneSeal_pb.SealTimer()
	if(speed ~= nil )then
		msg.speed = speed
	end
	if(curvalue ~= nil )then
		msg.curvalue = curvalue
	end
	if(maxvalue ~= nil )then
		msg.maxvalue = maxvalue
	end
	if(stoptime ~= nil )then
		msg.stoptime = stoptime
	end
	if(maxtime ~= nil )then
		msg.maxtime = maxtime
	end
	self:SendProto(msg)
end

function ServiceSceneSealAutoProxy:CallBeginSeal(sealid, etype) 
	local msg = SceneSeal_pb.BeginSeal()
	if(sealid ~= nil )then
		msg.sealid = sealid
	end
	if(etype ~= nil )then
		msg.etype = etype
	end
	self:SendProto(msg)
end

function ServiceSceneSealAutoProxy:CallEndSeal(success, sealid) 
	local msg = SceneSeal_pb.EndSeal()
	if(success ~= nil )then
		msg.success = success
	end
	if(sealid ~= nil )then
		msg.sealid = sealid
	end
	self:SendProto(msg)
end

function ServiceSceneSealAutoProxy:CallSealUserLeave() 
	local msg = SceneSeal_pb.SealUserLeave()
	self:SendProto(msg)
end

function ServiceSceneSealAutoProxy:CallSealQueryList(configid, donetimes, maxtimes) 
	local msg = SceneSeal_pb.SealQueryList()
	if( configid ~= nil )then
		for i=1,#configid do 
			table.insert(msg.configid, configid[i])
		end
	end
	if(donetimes ~= nil )then
		msg.donetimes = donetimes
	end
	if(maxtimes ~= nil )then
		msg.maxtimes = maxtimes
	end
	self:SendProto(msg)
end

function ServiceSceneSealAutoProxy:CallSealAcceptCmd(seal, pos, abandon) 
	local msg = SceneSeal_pb.SealAcceptCmd()
	if(seal ~= nil )then
		msg.seal = seal
	end
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
	if(abandon ~= nil )then
		msg.abandon = abandon
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSceneSealAutoProxy:RecvQuerySeal(data) 
	self:Notify(ServiceEvent.SceneSealQuerySeal, data)
end

function ServiceSceneSealAutoProxy:RecvUpdateSeal(data) 
	self:Notify(ServiceEvent.SceneSealUpdateSeal, data)
end

function ServiceSceneSealAutoProxy:RecvSealTimer(data) 
	self:Notify(ServiceEvent.SceneSealSealTimer, data)
end

function ServiceSceneSealAutoProxy:RecvBeginSeal(data) 
	self:Notify(ServiceEvent.SceneSealBeginSeal, data)
end

function ServiceSceneSealAutoProxy:RecvEndSeal(data) 
	self:Notify(ServiceEvent.SceneSealEndSeal, data)
end

function ServiceSceneSealAutoProxy:RecvSealUserLeave(data) 
	self:Notify(ServiceEvent.SceneSealSealUserLeave, data)
end

function ServiceSceneSealAutoProxy:RecvSealQueryList(data) 
	self:Notify(ServiceEvent.SceneSealSealQueryList, data)
end

function ServiceSceneSealAutoProxy:RecvSealAcceptCmd(data) 
	self:Notify(ServiceEvent.SceneSealSealAcceptCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SceneSealQuerySeal = "ServiceEvent_SceneSealQuerySeal"
ServiceEvent.SceneSealUpdateSeal = "ServiceEvent_SceneSealUpdateSeal"
ServiceEvent.SceneSealSealTimer = "ServiceEvent_SceneSealSealTimer"
ServiceEvent.SceneSealBeginSeal = "ServiceEvent_SceneSealBeginSeal"
ServiceEvent.SceneSealEndSeal = "ServiceEvent_SceneSealEndSeal"
ServiceEvent.SceneSealSealUserLeave = "ServiceEvent_SceneSealSealUserLeave"
ServiceEvent.SceneSealSealQueryList = "ServiceEvent_SceneSealSealQueryList"
ServiceEvent.SceneSealSealAcceptCmd = "ServiceEvent_SceneSealSealAcceptCmd"
