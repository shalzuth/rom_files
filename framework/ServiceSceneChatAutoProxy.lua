ServiceSceneChatAutoProxy = class('ServiceSceneChatAutoProxy', ServiceProxy)

ServiceSceneChatAutoProxy.Instance = nil

ServiceSceneChatAutoProxy.NAME = 'ServiceSceneChatAutoProxy'

function ServiceSceneChatAutoProxy:ctor(proxyName)
	if ServiceSceneChatAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneChatAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSceneChatAutoProxy.Instance = self
	end
end

function ServiceSceneChatAutoProxy:Init()
end

function ServiceSceneChatAutoProxy:onRegister()
	self:Listen(24, 3, function (data)
		self:RecvChatCountCmd(data) 
	end)
	self:Listen(24, 4, function (data)
		self:RecvChatChangeCountCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSceneChatAutoProxy:CallChatCountCmd(msgcnt) 
	local msg = SceneChat_pb.ChatCountCmd()
	if( msgcnt ~= nil )then
		for i=1,#msgcnt do 
			table.insert(msg.msgcnt, msgcnt[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneChatAutoProxy:CallChatChangeCountCmd(isclear) 
	local msg = SceneChat_pb.ChatChangeCountCmd()
	if(isclear ~= nil )then
		msg.isclear = isclear
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSceneChatAutoProxy:RecvChatCountCmd(data) 
	self:Notify(ServiceEvent.SceneChatChatCountCmd, data)
end

function ServiceSceneChatAutoProxy:RecvChatChangeCountCmd(data) 
	self:Notify(ServiceEvent.SceneChatChatChangeCountCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SceneChatChatCountCmd = "ServiceEvent_SceneChatChatCountCmd"
ServiceEvent.SceneChatChatChangeCountCmd = "ServiceEvent_SceneChatChatChangeCountCmd"
