ServiceChatRoomAutoProxy = class('ServiceChatRoomAutoProxy', ServiceProxy)

ServiceChatRoomAutoProxy.Instance = nil

ServiceChatRoomAutoProxy.NAME = 'ServiceChatRoomAutoProxy'

function ServiceChatRoomAutoProxy:ctor(proxyName)
	if ServiceChatRoomAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceChatRoomAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceChatRoomAutoProxy.Instance = self
	end
end

function ServiceChatRoomAutoProxy:Init()
end

function ServiceChatRoomAutoProxy:onRegister()
	self:Listen(19, 1, function (data)
		self:RecvCreateChatRoom(data) 
	end)
	self:Listen(19, 2, function (data)
		self:RecvJoinChatRoom(data) 
	end)
	self:Listen(19, 3, function (data)
		self:RecvExitChatRoom(data) 
	end)
	self:Listen(19, 4, function (data)
		self:RecvKickChatMember(data) 
	end)
	self:Listen(19, 5, function (data)
		self:RecvExchangeRoomOwner(data) 
	end)
	self:Listen(19, 7, function (data)
		self:RecvRoomMemberUpdate(data) 
	end)
	self:Listen(19, 6, function (data)
		self:RecvEnterChatRoom(data) 
	end)
	self:Listen(19, 8, function (data)
		self:RecvChatRoomDataSync(data) 
	end)
	self:Listen(19, 9, function (data)
		self:RecvChatRoomTip(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceChatRoomAutoProxy:CallCreateChatRoom(roomname, maxnum, pswd) 
	local msg = SceneChatRoom_pb.CreateChatRoom()
	if(roomname ~= nil )then
		msg.roomname = roomname
	end
	if(maxnum ~= nil )then
		msg.maxnum = maxnum
	end
	if(pswd ~= nil )then
		msg.pswd = pswd
	end
	self:SendProto(msg)
end

function ServiceChatRoomAutoProxy:CallJoinChatRoom(roomid, pswd) 
	local msg = SceneChatRoom_pb.JoinChatRoom()
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	if(pswd ~= nil )then
		msg.pswd = pswd
	end
	self:SendProto(msg)
end

function ServiceChatRoomAutoProxy:CallExitChatRoom(roomid, userid) 
	local msg = SceneChatRoom_pb.ExitChatRoom()
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	if(userid ~= nil )then
		msg.userid = userid
	end
	self:SendProto(msg)
end

function ServiceChatRoomAutoProxy:CallKickChatMember(roomid, memberid) 
	local msg = SceneChatRoom_pb.KickChatMember()
	if(roomid ~= nil )then
		msg.roomid = roomid
	end
	if(memberid ~= nil )then
		msg.memberid = memberid
	end
	self:SendProto(msg)
end

function ServiceChatRoomAutoProxy:CallExchangeRoomOwner(userid) 
	local msg = SceneChatRoom_pb.ExchangeRoomOwner()
	if(userid ~= nil )then
		msg.userid = userid
	end
	self:SendProto(msg)
end

function ServiceChatRoomAutoProxy:CallRoomMemberUpdate(updates, deletes) 
	local msg = SceneChatRoom_pb.RoomMemberUpdate()
	if( updates ~= nil )then
		for i=1,#updates do 
			table.insert(msg.updates, updates[i])
		end
	end
	if( deletes ~= nil )then
		for i=1,#deletes do 
			table.insert(msg.deletes, deletes[i])
		end
	end
	self:SendProto(msg)
end

function ServiceChatRoomAutoProxy:CallEnterChatRoom(data) 
	local msg = SceneChatRoom_pb.EnterChatRoom()
	if(data ~= nil )then
		if(data.roomid ~= nil )then
			msg.data.roomid = data.roomid
		end
	end
	if(data ~= nil )then
		if(data.name ~= nil )then
			msg.data.name = data.name
		end
	end
	if(data ~= nil )then
		if(data.pswd ~= nil )then
			msg.data.pswd = data.pswd
		end
	end
	if(data ~= nil )then
		if(data.ownerid ~= nil )then
			msg.data.ownerid = data.ownerid
		end
	end
	if(data ~= nil )then
		if(data.maxnum ~= nil )then
			msg.data.maxnum = data.maxnum
		end
	end
	if(data ~= nil )then
		if(data.roomtype ~= nil )then
			msg.data.roomtype = data.roomtype
		end
	end
	if(data ~= nil )then
		if(data.members ~= nil )then
			for i=1,#data.members do 
				table.insert(msg.data.members, data.members[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceChatRoomAutoProxy:CallChatRoomDataSync(esync, data) 
	local msg = SceneChatRoom_pb.ChatRoomDataSync()
	if(esync ~= nil )then
		msg.esync = esync
	end
	if(data ~= nil )then
		if(data.ownerid ~= nil )then
			msg.data.ownerid = data.ownerid
		end
	end
	if(data ~= nil )then
		if(data.roomid ~= nil )then
			msg.data.roomid = data.roomid
		end
	end
	if(data ~= nil )then
		if(data.name ~= nil )then
			msg.data.name = data.name
		end
	end
	if(data ~= nil )then
		if(data.roomtype ~= nil )then
			msg.data.roomtype = data.roomtype
		end
	end
	if(data ~= nil )then
		if(data.maxnum ~= nil )then
			msg.data.maxnum = data.maxnum
		end
	end
	if(data ~= nil )then
		if(data.curnum ~= nil )then
			msg.data.curnum = data.curnum
		end
	end
	if(data ~= nil )then
		if(data.pswd ~= nil )then
			msg.data.pswd = data.pswd
		end
	end
	self:SendProto(msg)
end

function ServiceChatRoomAutoProxy:CallChatRoomTip(tip, userid, name) 
	local msg = SceneChatRoom_pb.ChatRoomTip()
	if(tip ~= nil )then
		msg.tip = tip
	end
	if(userid ~= nil )then
		msg.userid = userid
	end
	if(name ~= nil )then
		msg.name = name
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceChatRoomAutoProxy:RecvCreateChatRoom(data) 
	self:Notify(ServiceEvent.ChatRoomCreateChatRoom, data)
end

function ServiceChatRoomAutoProxy:RecvJoinChatRoom(data) 
	self:Notify(ServiceEvent.ChatRoomJoinChatRoom, data)
end

function ServiceChatRoomAutoProxy:RecvExitChatRoom(data) 
	self:Notify(ServiceEvent.ChatRoomExitChatRoom, data)
end

function ServiceChatRoomAutoProxy:RecvKickChatMember(data) 
	self:Notify(ServiceEvent.ChatRoomKickChatMember, data)
end

function ServiceChatRoomAutoProxy:RecvExchangeRoomOwner(data) 
	self:Notify(ServiceEvent.ChatRoomExchangeRoomOwner, data)
end

function ServiceChatRoomAutoProxy:RecvRoomMemberUpdate(data) 
	self:Notify(ServiceEvent.ChatRoomRoomMemberUpdate, data)
end

function ServiceChatRoomAutoProxy:RecvEnterChatRoom(data) 
	self:Notify(ServiceEvent.ChatRoomEnterChatRoom, data)
end

function ServiceChatRoomAutoProxy:RecvChatRoomDataSync(data) 
	self:Notify(ServiceEvent.ChatRoomChatRoomDataSync, data)
end

function ServiceChatRoomAutoProxy:RecvChatRoomTip(data) 
	self:Notify(ServiceEvent.ChatRoomChatRoomTip, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.ChatRoomCreateChatRoom = "ServiceEvent_ChatRoomCreateChatRoom"
ServiceEvent.ChatRoomJoinChatRoom = "ServiceEvent_ChatRoomJoinChatRoom"
ServiceEvent.ChatRoomExitChatRoom = "ServiceEvent_ChatRoomExitChatRoom"
ServiceEvent.ChatRoomKickChatMember = "ServiceEvent_ChatRoomKickChatMember"
ServiceEvent.ChatRoomExchangeRoomOwner = "ServiceEvent_ChatRoomExchangeRoomOwner"
ServiceEvent.ChatRoomRoomMemberUpdate = "ServiceEvent_ChatRoomRoomMemberUpdate"
ServiceEvent.ChatRoomEnterChatRoom = "ServiceEvent_ChatRoomEnterChatRoom"
ServiceEvent.ChatRoomChatRoomDataSync = "ServiceEvent_ChatRoomChatRoomDataSync"
ServiceEvent.ChatRoomChatRoomTip = "ServiceEvent_ChatRoomChatRoomTip"
