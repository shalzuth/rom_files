ServicePveCardAutoProxy = class('ServicePveCardAutoProxy', ServiceProxy)

ServicePveCardAutoProxy.Instance = nil

ServicePveCardAutoProxy.NAME = 'ServicePveCardAutoProxy'

function ServicePveCardAutoProxy:ctor(proxyName)
	if ServicePveCardAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServicePveCardAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServicePveCardAutoProxy.Instance = self
	end
end

function ServicePveCardAutoProxy:Init()
end

function ServicePveCardAutoProxy:onRegister()
	self:Listen(66, 1, function (data)
		self:RecvInvitePveCardCmd(data) 
	end)
	self:Listen(66, 2, function (data)
		self:RecvReplyPveCardCmd(data) 
	end)
	self:Listen(66, 3, function (data)
		self:RecvEnterPveCardCmd(data) 
	end)
	self:Listen(66, 4, function (data)
		self:RecvQueryCardInfoCmd(data) 
	end)
	self:Listen(66, 5, function (data)
		self:RecvSelectPveCardCmd(data) 
	end)
	self:Listen(66, 6, function (data)
		self:RecvSyncProcessPveCardCmd(data) 
	end)
	self:Listen(66, 7, function (data)
		self:RecvUpdateProcessPveCardCmd(data) 
	end)
	self:Listen(66, 8, function (data)
		self:RecvBeginFirePveCardCmd(data) 
	end)
	self:Listen(66, 9, function (data)
		self:RecvFinishPlayCardCmd(data) 
	end)
	self:Listen(66, 10, function (data)
		self:RecvPlayPveCardCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServicePveCardAutoProxy:CallInvitePveCardCmd(configid, iscancel) 
	local msg = PveCard_pb.InvitePveCardCmd()
	if(configid ~= nil )then
		msg.configid = configid
	end
	if(iscancel ~= nil )then
		msg.iscancel = iscancel
	end
	self:SendProto(msg)
end

function ServicePveCardAutoProxy:CallReplyPveCardCmd(agree, charid) 
	local msg = PveCard_pb.ReplyPveCardCmd()
	if(agree ~= nil )then
		msg.agree = agree
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	self:SendProto(msg)
end

function ServicePveCardAutoProxy:CallEnterPveCardCmd(configid) 
	local msg = PveCard_pb.EnterPveCardCmd()
	if(configid ~= nil )then
		msg.configid = configid
	end
	self:SendProto(msg)
end

function ServicePveCardAutoProxy:CallQueryCardInfoCmd(cards) 
	local msg = PveCard_pb.QueryCardInfoCmd()
	if( cards ~= nil )then
		for i=1,#cards do 
			table.insert(msg.cards, cards[i])
		end
	end
	self:SendProto(msg)
end

function ServicePveCardAutoProxy:CallSelectPveCardCmd(index) 
	local msg = PveCard_pb.SelectPveCardCmd()
	msg.index = index
	self:SendProto(msg)
end

function ServicePveCardAutoProxy:CallSyncProcessPveCardCmd(card, process) 
	local msg = PveCard_pb.SyncProcessPveCardCmd()
	if(card ~= nil )then
		if(card.index ~= nil )then
			msg.card.index = card.index
		end
	end
	if(card ~= nil )then
		if(card.cardids ~= nil )then
			for i=1,#card.cardids do 
				table.insert(msg.card.cardids, card.cardids[i])
			end
		end
	end
	if(process ~= nil )then
		msg.process = process
	end
	self:SendProto(msg)
end

function ServicePveCardAutoProxy:CallUpdateProcessPveCardCmd(process) 
	local msg = PveCard_pb.UpdateProcessPveCardCmd()
	if(process ~= nil )then
		msg.process = process
	end
	self:SendProto(msg)
end

function ServicePveCardAutoProxy:CallBeginFirePveCardCmd() 
	local msg = PveCard_pb.BeginFirePveCardCmd()
	self:SendProto(msg)
end

function ServicePveCardAutoProxy:CallFinishPlayCardCmd() 
	local msg = PveCard_pb.FinishPlayCardCmd()
	self:SendProto(msg)
end

function ServicePveCardAutoProxy:CallPlayPveCardCmd(npcguid, cardids) 
	local msg = PveCard_pb.PlayPveCardCmd()
	msg.npcguid = npcguid
	if( cardids ~= nil )then
		for i=1,#cardids do 
			table.insert(msg.cardids, cardids[i])
		end
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServicePveCardAutoProxy:RecvInvitePveCardCmd(data) 
	self:Notify(ServiceEvent.PveCardInvitePveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvReplyPveCardCmd(data) 
	self:Notify(ServiceEvent.PveCardReplyPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvEnterPveCardCmd(data) 
	self:Notify(ServiceEvent.PveCardEnterPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvQueryCardInfoCmd(data) 
	self:Notify(ServiceEvent.PveCardQueryCardInfoCmd, data)
end

function ServicePveCardAutoProxy:RecvSelectPveCardCmd(data) 
	self:Notify(ServiceEvent.PveCardSelectPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvSyncProcessPveCardCmd(data) 
	self:Notify(ServiceEvent.PveCardSyncProcessPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvUpdateProcessPveCardCmd(data) 
	self:Notify(ServiceEvent.PveCardUpdateProcessPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvBeginFirePveCardCmd(data) 
	self:Notify(ServiceEvent.PveCardBeginFirePveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvFinishPlayCardCmd(data) 
	self:Notify(ServiceEvent.PveCardFinishPlayCardCmd, data)
end

function ServicePveCardAutoProxy:RecvPlayPveCardCmd(data) 
	self:Notify(ServiceEvent.PveCardPlayPveCardCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.PveCardInvitePveCardCmd = "ServiceEvent_PveCardInvitePveCardCmd"
ServiceEvent.PveCardReplyPveCardCmd = "ServiceEvent_PveCardReplyPveCardCmd"
ServiceEvent.PveCardEnterPveCardCmd = "ServiceEvent_PveCardEnterPveCardCmd"
ServiceEvent.PveCardQueryCardInfoCmd = "ServiceEvent_PveCardQueryCardInfoCmd"
ServiceEvent.PveCardSelectPveCardCmd = "ServiceEvent_PveCardSelectPveCardCmd"
ServiceEvent.PveCardSyncProcessPveCardCmd = "ServiceEvent_PveCardSyncProcessPveCardCmd"
ServiceEvent.PveCardUpdateProcessPveCardCmd = "ServiceEvent_PveCardUpdateProcessPveCardCmd"
ServiceEvent.PveCardBeginFirePveCardCmd = "ServiceEvent_PveCardBeginFirePveCardCmd"
ServiceEvent.PveCardFinishPlayCardCmd = "ServiceEvent_PveCardFinishPlayCardCmd"
ServiceEvent.PveCardPlayPveCardCmd = "ServiceEvent_PveCardPlayPveCardCmd"
