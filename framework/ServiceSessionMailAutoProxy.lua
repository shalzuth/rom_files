ServiceSessionMailAutoProxy = class('ServiceSessionMailAutoProxy', ServiceProxy)

ServiceSessionMailAutoProxy.Instance = nil

ServiceSessionMailAutoProxy.NAME = 'ServiceSessionMailAutoProxy'

function ServiceSessionMailAutoProxy:ctor(proxyName)
	if ServiceSessionMailAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSessionMailAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSessionMailAutoProxy.Instance = self
	end
end

function ServiceSessionMailAutoProxy:Init()
end

function ServiceSessionMailAutoProxy:onRegister()
	self:Listen(55, 1, function (data)
		self:RecvQueryAllMail(data) 
	end)
	self:Listen(55, 2, function (data)
		self:RecvMailUpdate(data) 
	end)
	self:Listen(55, 3, function (data)
		self:RecvGetMailAttach(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSessionMailAutoProxy:CallQueryAllMail(datas) 
	local msg = SessionMail_pb.QueryAllMail()
	if( datas ~= nil )then
		for i=1,#datas do 
			table.insert(msg.datas, datas[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionMailAutoProxy:CallMailUpdate(updates, dels) 
	local msg = SessionMail_pb.MailUpdate()
	if( updates ~= nil )then
		for i=1,#updates do 
			table.insert(msg.updates, updates[i])
		end
	end
	if( dels ~= nil )then
		for i=1,#dels do 
			table.insert(msg.dels, dels[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionMailAutoProxy:CallGetMailAttach(id) 
	local msg = SessionMail_pb.GetMailAttach()
	if(id ~= nil )then
		msg.id = id
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSessionMailAutoProxy:RecvQueryAllMail(data) 
	self:Notify(ServiceEvent.SessionMailQueryAllMail, data)
end

function ServiceSessionMailAutoProxy:RecvMailUpdate(data) 
	self:Notify(ServiceEvent.SessionMailMailUpdate, data)
end

function ServiceSessionMailAutoProxy:RecvGetMailAttach(data) 
	self:Notify(ServiceEvent.SessionMailGetMailAttach, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SessionMailQueryAllMail = "ServiceEvent_SessionMailQueryAllMail"
ServiceEvent.SessionMailMailUpdate = "ServiceEvent_SessionMailMailUpdate"
ServiceEvent.SessionMailGetMailAttach = "ServiceEvent_SessionMailGetMailAttach"
