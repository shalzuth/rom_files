ServiceBossCmdAutoProxy = class('ServiceBossCmdAutoProxy', ServiceProxy)

ServiceBossCmdAutoProxy.Instance = nil

ServiceBossCmdAutoProxy.NAME = 'ServiceBossCmdAutoProxy'

function ServiceBossCmdAutoProxy:ctor(proxyName)
	if ServiceBossCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceBossCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceBossCmdAutoProxy.Instance = self
	end
end

function ServiceBossCmdAutoProxy:Init()
end

function ServiceBossCmdAutoProxy:onRegister()
	self:Listen(15, 1, function (data)
		self:RecvBossListUserCmd(data) 
	end)
	self:Listen(15, 2, function (data)
		self:RecvBossPosUserCmd(data) 
	end)
	self:Listen(15, 3, function (data)
		self:RecvKillBossUserCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceBossCmdAutoProxy:CallBossListUserCmd(bosslist, minilist) 
	local msg = BossCmd_pb.BossListUserCmd()
	if( bosslist ~= nil )then
		for i=1,#bosslist do 
			table.insert(msg.bosslist, bosslist[i])
		end
	end
	if( minilist ~= nil )then
		for i=1,#minilist do 
			table.insert(msg.minilist, minilist[i])
		end
	end
	self:SendProto(msg)
end

function ServiceBossCmdAutoProxy:CallBossPosUserCmd(pos) 
	local msg = BossCmd_pb.BossPosUserCmd()
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

function ServiceBossCmdAutoProxy:CallKillBossUserCmd(userid) 
	local msg = BossCmd_pb.KillBossUserCmd()
	if(userid ~= nil )then
		msg.userid = userid
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceBossCmdAutoProxy:RecvBossListUserCmd(data) 
	self:Notify(ServiceEvent.BossCmdBossListUserCmd, data)
end

function ServiceBossCmdAutoProxy:RecvBossPosUserCmd(data) 
	self:Notify(ServiceEvent.BossCmdBossPosUserCmd, data)
end

function ServiceBossCmdAutoProxy:RecvKillBossUserCmd(data) 
	self:Notify(ServiceEvent.BossCmdKillBossUserCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.BossCmdBossListUserCmd = "ServiceEvent_BossCmdBossListUserCmd"
ServiceEvent.BossCmdBossPosUserCmd = "ServiceEvent_BossCmdBossPosUserCmd"
ServiceEvent.BossCmdKillBossUserCmd = "ServiceEvent_BossCmdKillBossUserCmd"
