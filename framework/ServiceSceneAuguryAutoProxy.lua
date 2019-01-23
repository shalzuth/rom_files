ServiceSceneAuguryAutoProxy = class('ServiceSceneAuguryAutoProxy', ServiceProxy)

ServiceSceneAuguryAutoProxy.Instance = nil

ServiceSceneAuguryAutoProxy.NAME = 'ServiceSceneAuguryAutoProxy'

function ServiceSceneAuguryAutoProxy:ctor(proxyName)
	if ServiceSceneAuguryAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneAuguryAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSceneAuguryAutoProxy.Instance = self
	end
end

function ServiceSceneAuguryAutoProxy:Init()
end

function ServiceSceneAuguryAutoProxy:onRegister()
	self:Listen(27, 1, function (data)
		self:RecvAuguryInvite(data) 
	end)
	self:Listen(27, 2, function (data)
		self:RecvAuguryInviteReply(data) 
	end)
	self:Listen(27, 3, function (data)
		self:RecvAuguryChat(data) 
	end)
	self:Listen(27, 4, function (data)
		self:RecvAuguryTitle(data) 
	end)
	self:Listen(27, 5, function (data)
		self:RecvAuguryAnswer(data) 
	end)
	self:Listen(27, 6, function (data)
		self:RecvAuguryQuit(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSceneAuguryAutoProxy:CallAuguryInvite(inviterid, invitername, npcguid, type, isextra) 
	local msg = SceneAugury_pb.AuguryInvite()
	if(inviterid ~= nil )then
		msg.inviterid = inviterid
	end
	if(invitername ~= nil )then
		msg.invitername = invitername
	end
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(isextra ~= nil )then
		msg.isextra = isextra
	end
	self:SendProto(msg)
end

function ServiceSceneAuguryAutoProxy:CallAuguryInviteReply(type, inviterid, npcguid, augurytype, isextra) 
	local msg = SceneAugury_pb.AuguryInviteReply()
	if(type ~= nil )then
		msg.type = type
	end
	if(inviterid ~= nil )then
		msg.inviterid = inviterid
	end
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	if(augurytype ~= nil )then
		msg.augurytype = augurytype
	end
	if(isextra ~= nil )then
		msg.isextra = isextra
	end
	self:SendProto(msg)
end

function ServiceSceneAuguryAutoProxy:CallAuguryChat(content, sender) 
	local msg = SceneAugury_pb.AuguryChat()
	if(content ~= nil )then
		msg.content = content
	end
	if(sender ~= nil )then
		msg.sender = sender
	end
	self:SendProto(msg)
end

function ServiceSceneAuguryAutoProxy:CallAuguryTitle(titleid, type, subtableid) 
	local msg = SceneAugury_pb.AuguryTitle()
	if(titleid ~= nil )then
		msg.titleid = titleid
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(subtableid ~= nil )then
		msg.subtableid = subtableid
	end
	self:SendProto(msg)
end

function ServiceSceneAuguryAutoProxy:CallAuguryAnswer(titleid, answer, answerid) 
	local msg = SceneAugury_pb.AuguryAnswer()
	if(titleid ~= nil )then
		msg.titleid = titleid
	end
	if(answer ~= nil )then
		msg.answer = answer
	end
	if(answerid ~= nil )then
		msg.answerid = answerid
	end
	self:SendProto(msg)
end

function ServiceSceneAuguryAutoProxy:CallAuguryQuit() 
	local msg = SceneAugury_pb.AuguryQuit()
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSceneAuguryAutoProxy:RecvAuguryInvite(data) 
	self:Notify(ServiceEvent.SceneAuguryAuguryInvite, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryInviteReply(data) 
	self:Notify(ServiceEvent.SceneAuguryAuguryInviteReply, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryChat(data) 
	self:Notify(ServiceEvent.SceneAuguryAuguryChat, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryTitle(data) 
	self:Notify(ServiceEvent.SceneAuguryAuguryTitle, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryAnswer(data) 
	self:Notify(ServiceEvent.SceneAuguryAuguryAnswer, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryQuit(data) 
	self:Notify(ServiceEvent.SceneAuguryAuguryQuit, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SceneAuguryAuguryInvite = "ServiceEvent_SceneAuguryAuguryInvite"
ServiceEvent.SceneAuguryAuguryInviteReply = "ServiceEvent_SceneAuguryAuguryInviteReply"
ServiceEvent.SceneAuguryAuguryChat = "ServiceEvent_SceneAuguryAuguryChat"
ServiceEvent.SceneAuguryAuguryTitle = "ServiceEvent_SceneAuguryAuguryTitle"
ServiceEvent.SceneAuguryAuguryAnswer = "ServiceEvent_SceneAuguryAuguryAnswer"
ServiceEvent.SceneAuguryAuguryQuit = "ServiceEvent_SceneAuguryAuguryQuit"
