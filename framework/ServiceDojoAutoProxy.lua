ServiceDojoAutoProxy = class('ServiceDojoAutoProxy', ServiceProxy)

ServiceDojoAutoProxy.Instance = nil

ServiceDojoAutoProxy.NAME = 'ServiceDojoAutoProxy'

function ServiceDojoAutoProxy:ctor(proxyName)
	if ServiceDojoAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceDojoAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceDojoAutoProxy.Instance = self
	end
end

function ServiceDojoAutoProxy:Init()
end

function ServiceDojoAutoProxy:onRegister()
	self:Listen(58, 1, function (data)
		self:RecvDojoPrivateInfoCmd(data) 
	end)
	self:Listen(58, 2, function (data)
		self:RecvDojoPublicInfoCmd(data) 
	end)
	self:Listen(58, 3, function (data)
		self:RecvDojoInviteCmd(data) 
	end)
	self:Listen(58, 4, function (data)
		self:RecvDojoReplyCmd(data) 
	end)
	self:Listen(58, 5, function (data)
		self:RecvEnterDojo(data) 
	end)
	self:Listen(58, 6, function (data)
		self:RecvDojoAddMsg(data) 
	end)
	self:Listen(58, 7, function (data)
		self:RecvDojoPanelOper(data) 
	end)
	self:Listen(58, 9, function (data)
		self:RecvDojoSponsorCmd(data) 
	end)
	self:Listen(58, 10, function (data)
		self:RecvDojoQueryStateCmd(data) 
	end)
	self:Listen(58, 11, function (data)
		self:RecvDojoRewardCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceDojoAutoProxy:CallDojoPrivateInfoCmd(groupid, completed_id) 
	local msg = Dojo_pb.DojoPrivateInfoCmd()
	if(groupid ~= nil )then
		msg.groupid = groupid
	end
	if( completed_id ~= nil )then
		for i=1,#completed_id do 
			table.insert(msg.completed_id, completed_id[i])
		end
	end
	self:SendProto(msg)
end

function ServiceDojoAutoProxy:CallDojoPublicInfoCmd(dojoid, msgblob) 
	local msg = Dojo_pb.DojoPublicInfoCmd()
	if(dojoid ~= nil )then
		msg.dojoid = dojoid
	end
	if(msgblob ~= nil )then
		if(msgblob.msgs ~= nil )then
			for i=1,#msgblob.msgs do 
				table.insert(msg.msgblob.msgs, msgblob.msgs[i])
			end
		end
	end
	if(msgblob ~= nil )then
		if(msgblob.dojoid ~= nil )then
			msg.msgblob.dojoid = msgblob.dojoid
		end
	end
	self:SendProto(msg)
end

function ServiceDojoAutoProxy:CallDojoInviteCmd(dojoid, sponsorid, sponsorname) 
	local msg = Dojo_pb.DojoInviteCmd()
	if(dojoid ~= nil )then
		msg.dojoid = dojoid
	end
	if(sponsorid ~= nil )then
		msg.sponsorid = sponsorid
	end
	if(sponsorname ~= nil )then
		msg.sponsorname = sponsorname
	end
	self:SendProto(msg)
end

function ServiceDojoAutoProxy:CallDojoReplyCmd(eReply, userid) 
	local msg = Dojo_pb.DojoReplyCmd()
	if(eReply ~= nil )then
		msg.eReply = eReply
	end
	if(userid ~= nil )then
		msg.userid = userid
	end
	self:SendProto(msg)
end

function ServiceDojoAutoProxy:CallEnterDojo(dojoid, userid, zoneid, time, sign) 
	local msg = Dojo_pb.EnterDojo()
	if(dojoid ~= nil )then
		msg.dojoid = dojoid
	end
	if(userid ~= nil )then
		msg.userid = userid
	end
	if(zoneid ~= nil )then
		msg.zoneid = zoneid
	end
	if(time ~= nil )then
		msg.time = time
	end
	if(sign ~= nil )then
		msg.sign = sign
	end
	self:SendProto(msg)
end

function ServiceDojoAutoProxy:CallDojoAddMsg(dojoid, dojomsg) 
	local msg = Dojo_pb.DojoAddMsg()
	if(dojoid ~= nil )then
		msg.dojoid = dojoid
	end
	if(dojomsg ~= nil )then
		if(dojomsg.charid ~= nil )then
			msg.dojomsg.charid = dojomsg.charid
		end
	end
	if(dojomsg ~= nil )then
		if(dojomsg.name ~= nil )then
			msg.dojomsg.name = dojomsg.name
		end
	end
	if(dojomsg ~= nil )then
		if(dojomsg.conent ~= nil )then
			msg.dojomsg.conent = dojomsg.conent
		end
	end
	if(dojomsg ~= nil )then
		if(dojomsg.iscompleted ~= nil )then
			msg.dojomsg.iscompleted = dojomsg.iscompleted
		end
	end
	self:SendProto(msg)
end

function ServiceDojoAutoProxy:CallDojoPanelOper() 
	local msg = Dojo_pb.DojoPanelOper()
	self:SendProto(msg)
end

function ServiceDojoAutoProxy:CallDojoSponsorCmd(dojoid, is_cancel, sponsorid, sponsorname, ret) 
	local msg = Dojo_pb.DojoSponsorCmd()
	if(dojoid ~= nil )then
		msg.dojoid = dojoid
	end
	if(is_cancel ~= nil )then
		msg.is_cancel = is_cancel
	end
	if(sponsorid ~= nil )then
		msg.sponsorid = sponsorid
	end
	if(sponsorname ~= nil )then
		msg.sponsorname = sponsorname
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	self:SendProto(msg)
end

function ServiceDojoAutoProxy:CallDojoQueryStateCmd(state, dojoid, sponsorid, sponsorname, ret) 
	local msg = Dojo_pb.DojoQueryStateCmd()
	if(state ~= nil )then
		msg.state = state
	end
	if(dojoid ~= nil )then
		msg.dojoid = dojoid
	end
	if(sponsorid ~= nil )then
		msg.sponsorid = sponsorid
	end
	if(sponsorname ~= nil )then
		msg.sponsorname = sponsorname
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	self:SendProto(msg)
end

function ServiceDojoAutoProxy:CallDojoRewardCmd(dojoid, passtype, items) 
	local msg = Dojo_pb.DojoRewardCmd()
	if(dojoid ~= nil )then
		msg.dojoid = dojoid
	end
	if(passtype ~= nil )then
		msg.passtype = passtype
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceDojoAutoProxy:RecvDojoPrivateInfoCmd(data) 
	self:Notify(ServiceEvent.DojoDojoPrivateInfoCmd, data)
end

function ServiceDojoAutoProxy:RecvDojoPublicInfoCmd(data) 
	self:Notify(ServiceEvent.DojoDojoPublicInfoCmd, data)
end

function ServiceDojoAutoProxy:RecvDojoInviteCmd(data) 
	self:Notify(ServiceEvent.DojoDojoInviteCmd, data)
end

function ServiceDojoAutoProxy:RecvDojoReplyCmd(data) 
	self:Notify(ServiceEvent.DojoDojoReplyCmd, data)
end

function ServiceDojoAutoProxy:RecvEnterDojo(data) 
	self:Notify(ServiceEvent.DojoEnterDojo, data)
end

function ServiceDojoAutoProxy:RecvDojoAddMsg(data) 
	self:Notify(ServiceEvent.DojoDojoAddMsg, data)
end

function ServiceDojoAutoProxy:RecvDojoPanelOper(data) 
	self:Notify(ServiceEvent.DojoDojoPanelOper, data)
end

function ServiceDojoAutoProxy:RecvDojoSponsorCmd(data) 
	self:Notify(ServiceEvent.DojoDojoSponsorCmd, data)
end

function ServiceDojoAutoProxy:RecvDojoQueryStateCmd(data) 
	self:Notify(ServiceEvent.DojoDojoQueryStateCmd, data)
end

function ServiceDojoAutoProxy:RecvDojoRewardCmd(data) 
	self:Notify(ServiceEvent.DojoDojoRewardCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.DojoDojoPrivateInfoCmd = "ServiceEvent_DojoDojoPrivateInfoCmd"
ServiceEvent.DojoDojoPublicInfoCmd = "ServiceEvent_DojoDojoPublicInfoCmd"
ServiceEvent.DojoDojoInviteCmd = "ServiceEvent_DojoDojoInviteCmd"
ServiceEvent.DojoDojoReplyCmd = "ServiceEvent_DojoDojoReplyCmd"
ServiceEvent.DojoEnterDojo = "ServiceEvent_DojoEnterDojo"
ServiceEvent.DojoDojoAddMsg = "ServiceEvent_DojoDojoAddMsg"
ServiceEvent.DojoDojoPanelOper = "ServiceEvent_DojoDojoPanelOper"
ServiceEvent.DojoDojoSponsorCmd = "ServiceEvent_DojoDojoSponsorCmd"
ServiceEvent.DojoDojoQueryStateCmd = "ServiceEvent_DojoDojoQueryStateCmd"
ServiceEvent.DojoDojoRewardCmd = "ServiceEvent_DojoDojoRewardCmd"
