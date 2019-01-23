ServiceInfiniteTowerAutoProxy = class('ServiceInfiniteTowerAutoProxy', ServiceProxy)

ServiceInfiniteTowerAutoProxy.Instance = nil

ServiceInfiniteTowerAutoProxy.NAME = 'ServiceInfiniteTowerAutoProxy'

function ServiceInfiniteTowerAutoProxy:ctor(proxyName)
	if ServiceInfiniteTowerAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceInfiniteTowerAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceInfiniteTowerAutoProxy.Instance = self
	end
end

function ServiceInfiniteTowerAutoProxy:Init()
end

function ServiceInfiniteTowerAutoProxy:onRegister()
	self:Listen(20, 1, function (data)
		self:RecvTeamTowerInfoCmd(data) 
	end)
	self:Listen(20, 2, function (data)
		self:RecvTeamTowerSummaryCmd(data) 
	end)
	self:Listen(20, 3, function (data)
		self:RecvTeamTowerInviteCmd(data) 
	end)
	self:Listen(20, 4, function (data)
		self:RecvTeamTowerReplyCmd(data) 
	end)
	self:Listen(20, 5, function (data)
		self:RecvEnterTower(data) 
	end)
	self:Listen(20, 7, function (data)
		self:RecvUserTowerInfoCmd(data) 
	end)
	self:Listen(20, 8, function (data)
		self:RecvTowerLayerSyncTowerCmd(data) 
	end)
	self:Listen(20, 10, function (data)
		self:RecvTowerInfoCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceInfiniteTowerAutoProxy:CallTeamTowerInfoCmd(teamid) 
	local msg = InfiniteTower_pb.TeamTowerInfoCmd()
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	self:SendProto(msg)
end

function ServiceInfiniteTowerAutoProxy:CallTeamTowerSummaryCmd(teamtower, maxlayer, refreshtime) 
	local msg = InfiniteTower_pb.TeamTowerSummaryCmd()
	if(teamtower ~= nil )then
		if(teamtower.teamid ~= nil )then
			msg.teamtower.teamid = teamtower.teamid
		end
	end
	if(teamtower ~= nil )then
		if(teamtower.layer ~= nil )then
			msg.teamtower.layer = teamtower.layer
		end
	end
	if(teamtower.leadertower ~= nil )then
		if(teamtower.leadertower.oldmaxlayer ~= nil )then
			msg.teamtower.leadertower.oldmaxlayer = teamtower.leadertower.oldmaxlayer
		end
	end
	if(teamtower.leadertower ~= nil )then
		if(teamtower.leadertower.curmaxlayer ~= nil )then
			msg.teamtower.leadertower.curmaxlayer = teamtower.leadertower.curmaxlayer
		end
	end
	if(teamtower ~= nil )then
		if(teamtower.leadertower.layers ~= nil )then
			for i=1,#teamtower.leadertower.layers do 
				table.insert(msg.teamtower.leadertower.layers, teamtower.leadertower.layers[i])
			end
		end
	end
	if(teamtower.leadertower ~= nil )then
		if(teamtower.leadertower.maxlayer ~= nil )then
			msg.teamtower.leadertower.maxlayer = teamtower.leadertower.maxlayer
		end
	end
	if(teamtower.leadertower ~= nil )then
		if(teamtower.leadertower.record_layer ~= nil )then
			msg.teamtower.leadertower.record_layer = teamtower.leadertower.record_layer
		end
	end
	if(teamtower ~= nil )then
		if(teamtower.leadertower.everpasslayers ~= nil )then
			for i=1,#teamtower.leadertower.everpasslayers do 
				table.insert(msg.teamtower.leadertower.everpasslayers, teamtower.leadertower.everpasslayers[i])
			end
		end
	end
	if(teamtower ~= nil )then
		if(teamtower.members ~= nil )then
			for i=1,#teamtower.members do 
				table.insert(msg.teamtower.members, teamtower.members[i])
			end
		end
	end
	if(maxlayer ~= nil )then
		msg.maxlayer = maxlayer
	end
	if(refreshtime ~= nil )then
		msg.refreshtime = refreshtime
	end
	self:SendProto(msg)
end

function ServiceInfiniteTowerAutoProxy:CallTeamTowerInviteCmd(iscancel) 
	local msg = InfiniteTower_pb.TeamTowerInviteCmd()
	if(iscancel ~= nil )then
		msg.iscancel = iscancel
	end
	self:SendProto(msg)
end

function ServiceInfiniteTowerAutoProxy:CallTeamTowerReplyCmd(eReply, userid) 
	local msg = InfiniteTower_pb.TeamTowerReplyCmd()
	if(eReply ~= nil )then
		msg.eReply = eReply
	end
	if(userid ~= nil )then
		msg.userid = userid
	end
	self:SendProto(msg)
end

function ServiceInfiniteTowerAutoProxy:CallEnterTower(layer, userid, zoneid, time, sign) 
	local msg = InfiniteTower_pb.EnterTower()
	if(layer ~= nil )then
		msg.layer = layer
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

function ServiceInfiniteTowerAutoProxy:CallUserTowerInfoCmd(usertower) 
	local msg = InfiniteTower_pb.UserTowerInfoCmd()
	if(usertower ~= nil )then
		if(usertower.oldmaxlayer ~= nil )then
			msg.usertower.oldmaxlayer = usertower.oldmaxlayer
		end
	end
	if(usertower ~= nil )then
		if(usertower.curmaxlayer ~= nil )then
			msg.usertower.curmaxlayer = usertower.curmaxlayer
		end
	end
	if(usertower ~= nil )then
		if(usertower.layers ~= nil )then
			for i=1,#usertower.layers do 
				table.insert(msg.usertower.layers, usertower.layers[i])
			end
		end
	end
	if(usertower ~= nil )then
		if(usertower.maxlayer ~= nil )then
			msg.usertower.maxlayer = usertower.maxlayer
		end
	end
	if(usertower ~= nil )then
		if(usertower.record_layer ~= nil )then
			msg.usertower.record_layer = usertower.record_layer
		end
	end
	if(usertower ~= nil )then
		if(usertower.everpasslayers ~= nil )then
			for i=1,#usertower.everpasslayers do 
				table.insert(msg.usertower.everpasslayers, usertower.everpasslayers[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceInfiniteTowerAutoProxy:CallTowerLayerSyncTowerCmd(layer) 
	local msg = InfiniteTower_pb.TowerLayerSyncTowerCmd()
	if(layer ~= nil )then
		msg.layer = layer
	end
	self:SendProto(msg)
end

function ServiceInfiniteTowerAutoProxy:CallTowerInfoCmd(maxlayer, refreshtime) 
	local msg = InfiniteTower_pb.TowerInfoCmd()
	if(maxlayer ~= nil )then
		msg.maxlayer = maxlayer
	end
	if(refreshtime ~= nil )then
		msg.refreshtime = refreshtime
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceInfiniteTowerAutoProxy:RecvTeamTowerInfoCmd(data) 
	self:Notify(ServiceEvent.InfiniteTowerTeamTowerInfoCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTeamTowerSummaryCmd(data) 
	self:Notify(ServiceEvent.InfiniteTowerTeamTowerSummaryCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTeamTowerInviteCmd(data) 
	self:Notify(ServiceEvent.InfiniteTowerTeamTowerInviteCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTeamTowerReplyCmd(data) 
	self:Notify(ServiceEvent.InfiniteTowerTeamTowerReplyCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvEnterTower(data) 
	self:Notify(ServiceEvent.InfiniteTowerEnterTower, data)
end

function ServiceInfiniteTowerAutoProxy:RecvUserTowerInfoCmd(data) 
	self:Notify(ServiceEvent.InfiniteTowerUserTowerInfoCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTowerLayerSyncTowerCmd(data) 
	self:Notify(ServiceEvent.InfiniteTowerTowerLayerSyncTowerCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTowerInfoCmd(data) 
	self:Notify(ServiceEvent.InfiniteTowerTowerInfoCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.InfiniteTowerTeamTowerInfoCmd = "ServiceEvent_InfiniteTowerTeamTowerInfoCmd"
ServiceEvent.InfiniteTowerTeamTowerSummaryCmd = "ServiceEvent_InfiniteTowerTeamTowerSummaryCmd"
ServiceEvent.InfiniteTowerTeamTowerInviteCmd = "ServiceEvent_InfiniteTowerTeamTowerInviteCmd"
ServiceEvent.InfiniteTowerTeamTowerReplyCmd = "ServiceEvent_InfiniteTowerTeamTowerReplyCmd"
ServiceEvent.InfiniteTowerEnterTower = "ServiceEvent_InfiniteTowerEnterTower"
ServiceEvent.InfiniteTowerUserTowerInfoCmd = "ServiceEvent_InfiniteTowerUserTowerInfoCmd"
ServiceEvent.InfiniteTowerTowerLayerSyncTowerCmd = "ServiceEvent_InfiniteTowerTowerLayerSyncTowerCmd"
ServiceEvent.InfiniteTowerTowerInfoCmd = "ServiceEvent_InfiniteTowerTowerInfoCmd"
