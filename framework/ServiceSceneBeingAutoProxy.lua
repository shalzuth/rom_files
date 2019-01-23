ServiceSceneBeingAutoProxy = class('ServiceSceneBeingAutoProxy', ServiceProxy)

ServiceSceneBeingAutoProxy.Instance = nil

ServiceSceneBeingAutoProxy.NAME = 'ServiceSceneBeingAutoProxy'

function ServiceSceneBeingAutoProxy:ctor(proxyName)
	if ServiceSceneBeingAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneBeingAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSceneBeingAutoProxy.Instance = self
	end
end

function ServiceSceneBeingAutoProxy:Init()
end

function ServiceSceneBeingAutoProxy:onRegister()
	self:Listen(32, 1, function (data)
		self:RecvBeingSkillQuery(data) 
	end)
	self:Listen(32, 2, function (data)
		self:RecvBeingSkillUpdate(data) 
	end)
	self:Listen(32, 3, function (data)
		self:RecvBeingSkillLevelUp(data) 
	end)
	self:Listen(32, 4, function (data)
		self:RecvBeingInfoQuery(data) 
	end)
	self:Listen(32, 5, function (data)
		self:RecvBeingInfoUpdate(data) 
	end)
	self:Listen(32, 7, function (data)
		self:RecvBeingSwitchState(data) 
	end)
	self:Listen(32, 6, function (data)
		self:RecvBeingOffCmd(data) 
	end)
	self:Listen(32, 8, function (data)
		self:RecvChangeBodyBeingCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSceneBeingAutoProxy:CallBeingSkillQuery(data) 
	local msg = SceneBeing_pb.BeingSkillQuery()
	if( data ~= nil )then
		for i=1,#data do 
			table.insert(msg.data, data[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneBeingAutoProxy:CallBeingSkillUpdate(update, del) 
	local msg = SceneBeing_pb.BeingSkillUpdate()
	if( update ~= nil )then
		for i=1,#update do 
			table.insert(msg.update, update[i])
		end
	end
	if( del ~= nil )then
		for i=1,#del do 
			table.insert(msg.del, del[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneBeingAutoProxy:CallBeingSkillLevelUp(beingid, skillids) 
	local msg = SceneBeing_pb.BeingSkillLevelUp()
	if(beingid ~= nil )then
		msg.beingid = beingid
	end
	if( skillids ~= nil )then
		for i=1,#skillids do 
			table.insert(msg.skillids, skillids[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneBeingAutoProxy:CallBeingInfoQuery(beinginfo) 
	local msg = SceneBeing_pb.BeingInfoQuery()
	if( beinginfo ~= nil )then
		for i=1,#beinginfo do 
			table.insert(msg.beinginfo, beinginfo[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneBeingAutoProxy:CallBeingInfoUpdate(beingid, datas) 
	local msg = SceneBeing_pb.BeingInfoUpdate()
	msg.beingid = beingid
	if( datas ~= nil )then
		for i=1,#datas do 
			table.insert(msg.datas, datas[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneBeingAutoProxy:CallBeingSwitchState(beingid, battle) 
	local msg = SceneBeing_pb.BeingSwitchState()
	msg.beingid = beingid
	msg.battle = battle
	self:SendProto(msg)
end

function ServiceSceneBeingAutoProxy:CallBeingOffCmd(beingid) 
	local msg = SceneBeing_pb.BeingOffCmd()
	msg.beingid = beingid
	self:SendProto(msg)
end

function ServiceSceneBeingAutoProxy:CallChangeBodyBeingCmd(beingid, body) 
	local msg = SceneBeing_pb.ChangeBodyBeingCmd()
	msg.beingid = beingid
	msg.body = body
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSceneBeingAutoProxy:RecvBeingSkillQuery(data) 
	self:Notify(ServiceEvent.SceneBeingBeingSkillQuery, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingSkillUpdate(data) 
	self:Notify(ServiceEvent.SceneBeingBeingSkillUpdate, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingSkillLevelUp(data) 
	self:Notify(ServiceEvent.SceneBeingBeingSkillLevelUp, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingInfoQuery(data) 
	self:Notify(ServiceEvent.SceneBeingBeingInfoQuery, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingInfoUpdate(data) 
	self:Notify(ServiceEvent.SceneBeingBeingInfoUpdate, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingSwitchState(data) 
	self:Notify(ServiceEvent.SceneBeingBeingSwitchState, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingOffCmd(data) 
	self:Notify(ServiceEvent.SceneBeingBeingOffCmd, data)
end

function ServiceSceneBeingAutoProxy:RecvChangeBodyBeingCmd(data) 
	self:Notify(ServiceEvent.SceneBeingChangeBodyBeingCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SceneBeingBeingSkillQuery = "ServiceEvent_SceneBeingBeingSkillQuery"
ServiceEvent.SceneBeingBeingSkillUpdate = "ServiceEvent_SceneBeingBeingSkillUpdate"
ServiceEvent.SceneBeingBeingSkillLevelUp = "ServiceEvent_SceneBeingBeingSkillLevelUp"
ServiceEvent.SceneBeingBeingInfoQuery = "ServiceEvent_SceneBeingBeingInfoQuery"
ServiceEvent.SceneBeingBeingInfoUpdate = "ServiceEvent_SceneBeingBeingInfoUpdate"
ServiceEvent.SceneBeingBeingSwitchState = "ServiceEvent_SceneBeingBeingSwitchState"
ServiceEvent.SceneBeingBeingOffCmd = "ServiceEvent_SceneBeingBeingOffCmd"
ServiceEvent.SceneBeingChangeBodyBeingCmd = "ServiceEvent_SceneBeingChangeBodyBeingCmd"
