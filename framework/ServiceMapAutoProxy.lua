ServiceMapAutoProxy = class('ServiceMapAutoProxy', ServiceProxy)

ServiceMapAutoProxy.Instance = nil

ServiceMapAutoProxy.NAME = 'ServiceMapAutoProxy'

function ServiceMapAutoProxy:ctor(proxyName)
	if ServiceMapAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceMapAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceMapAutoProxy.Instance = self
	end
end

function ServiceMapAutoProxy:Init()
end

function ServiceMapAutoProxy:onRegister()
	self:Listen(12, 1, function (data)
		self:RecvAddMapItem(data) 
	end)
	self:Listen(12, 2, function (data)
		self:RecvPickupItem(data) 
	end)
	self:Listen(12, 3, function (data)
		self:RecvAddMapUser(data) 
	end)
	self:Listen(12, 4, function (data)
		self:RecvAddMapNpc(data) 
	end)
	self:Listen(12, 5, function (data)
		self:RecvAddMapTrap(data) 
	end)
	self:Listen(12, 6, function (data)
		self:RecvAddMapAct(data) 
	end)
	self:Listen(12, 7, function (data)
		self:RecvExitPointState(data) 
	end)
	self:Listen(12, 8, function (data)
		self:RecvMapCmdEnd(data) 
	end)
	self:Listen(12, 9, function (data)
		self:RecvNpcSearchRangeCmd(data) 
	end)
	self:Listen(12, 10, function (data)
		self:RecvUserHandsCmd(data) 
	end)
	self:Listen(12, 11, function (data)
		self:RecvSpEffectCmd(data) 
	end)
	self:Listen(12, 12, function (data)
		self:RecvUserHandNpcCmd(data) 
	end)
	self:Listen(12, 13, function (data)
		self:RecvGingerBreadNpcCmd(data) 
	end)
	self:Listen(12, 14, function (data)
		self:RecvGoCityGateMapCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceMapAutoProxy:CallAddMapItem(items) 
	local msg = SceneMap_pb.AddMapItem()
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallPickupItem(playerguid, itemguid, success) 
	local msg = SceneMap_pb.PickupItem()
	if(playerguid ~= nil )then
		msg.playerguid = playerguid
	end
	if(itemguid ~= nil )then
		msg.itemguid = itemguid
	end
	if(success ~= nil )then
		msg.success = success
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallAddMapUser(users) 
	local msg = SceneMap_pb.AddMapUser()
	if( users ~= nil )then
		for i=1,#users do 
			table.insert(msg.users, users[i])
		end
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallAddMapNpc(npcs) 
	local msg = SceneMap_pb.AddMapNpc()
	if( npcs ~= nil )then
		for i=1,#npcs do 
			table.insert(msg.npcs, npcs[i])
		end
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallAddMapTrap(traps) 
	local msg = SceneMap_pb.AddMapTrap()
	if( traps ~= nil )then
		for i=1,#traps do 
			table.insert(msg.traps, traps[i])
		end
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallAddMapAct(acts) 
	local msg = SceneMap_pb.AddMapAct()
	if( acts ~= nil )then
		for i=1,#acts do 
			table.insert(msg.acts, acts[i])
		end
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallExitPointState(exitid, visible) 
	local msg = SceneMap_pb.ExitPointState()
	if(exitid ~= nil )then
		msg.exitid = exitid
	end
	if(visible ~= nil )then
		msg.visible = visible
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallMapCmdEnd() 
	local msg = SceneMap_pb.MapCmdEnd()
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallNpcSearchRangeCmd(id, range) 
	local msg = SceneMap_pb.NpcSearchRangeCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(range ~= nil )then
		msg.range = range
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallUserHandsCmd(player1, player2, isadd) 
	local msg = SceneMap_pb.UserHandsCmd()
	if(player1 ~= nil )then
		msg.player1 = player1
	end
	if(player2 ~= nil )then
		msg.player2 = player2
	end
	if(isadd ~= nil )then
		msg.isadd = isadd
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallSpEffectCmd(senderid, data, isadd) 
	local msg = SceneMap_pb.SpEffectCmd()
	if(senderid ~= nil )then
		msg.senderid = senderid
	end
	if(data ~= nil )then
		if(data.guid ~= nil )then
			msg.data.guid = data.guid
		end
	end
	if(data ~= nil )then
		if(data.id ~= nil )then
			msg.data.id = data.id
		end
	end
	if(data ~= nil )then
		if(data.entity ~= nil )then
			for i=1,#data.entity do 
				table.insert(msg.data.entity, data.entity[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.expiretime ~= nil )then
			msg.data.expiretime = data.expiretime
		end
	end
	if(isadd ~= nil )then
		msg.isadd = isadd
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallUserHandNpcCmd(data, ishand, userid) 
	local msg = SceneMap_pb.UserHandNpcCmd()
	if(data ~= nil )then
		if(data.body ~= nil )then
			msg.data.body = data.body
		end
	end
	if(data ~= nil )then
		if(data.head ~= nil )then
			msg.data.head = data.head
		end
	end
	if(data ~= nil )then
		if(data.hair ~= nil )then
			msg.data.hair = data.hair
		end
	end
	if(data ~= nil )then
		if(data.haircolor ~= nil )then
			msg.data.haircolor = data.haircolor
		end
	end
	if(data ~= nil )then
		if(data.guid ~= nil )then
			msg.data.guid = data.guid
		end
	end
	if(data ~= nil )then
		if(data.speffect ~= nil )then
			msg.data.speffect = data.speffect
		end
	end
	if(data ~= nil )then
		if(data.name ~= nil )then
			msg.data.name = data.name
		end
	end
	if(data ~= nil )then
		if(data.eye ~= nil )then
			msg.data.eye = data.eye
		end
	end
	if(ishand ~= nil )then
		msg.ishand = ishand
	end
	if(userid ~= nil )then
		msg.userid = userid
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallGingerBreadNpcCmd(data, isadd, userid, bornpos) 
	local msg = SceneMap_pb.GingerBreadNpcCmd()
	if(data ~= nil )then
		if(data.npcid ~= nil )then
			msg.data.npcid = data.npcid
		end
	end
	if(data ~= nil )then
		if(data.guid ~= nil )then
			msg.data.guid = data.guid
		end
	end
	if(data ~= nil )then
		if(data.giveid ~= nil )then
			msg.data.giveid = data.giveid
		end
	end
	if(data ~= nil )then
		if(data.expiretime ~= nil )then
			msg.data.expiretime = data.expiretime
		end
	end
	if(data ~= nil )then
		if(data.type ~= nil )then
			msg.data.type = data.type
		end
	end
	if(isadd ~= nil )then
		msg.isadd = isadd
	end
	if(userid ~= nil )then
		msg.userid = userid
	end
	if(bornpos ~= nil )then
		if(bornpos.x ~= nil )then
			msg.bornpos.x = bornpos.x
		end
	end
	if(bornpos ~= nil )then
		if(bornpos.y ~= nil )then
			msg.bornpos.y = bornpos.y
		end
	end
	if(bornpos ~= nil )then
		if(bornpos.z ~= nil )then
			msg.bornpos.z = bornpos.z
		end
	end
	self:SendProto(msg)
end

function ServiceMapAutoProxy:CallGoCityGateMapCmd(flag) 
	local msg = SceneMap_pb.GoCityGateMapCmd()
	if(flag ~= nil )then
		msg.flag = flag
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceMapAutoProxy:RecvAddMapItem(data) 
	self:Notify(ServiceEvent.MapAddMapItem, data)
end

function ServiceMapAutoProxy:RecvPickupItem(data) 
	self:Notify(ServiceEvent.MapPickupItem, data)
end

function ServiceMapAutoProxy:RecvAddMapUser(data) 
	self:Notify(ServiceEvent.MapAddMapUser, data)
end

function ServiceMapAutoProxy:RecvAddMapNpc(data) 
	self:Notify(ServiceEvent.MapAddMapNpc, data)
end

function ServiceMapAutoProxy:RecvAddMapTrap(data) 
	self:Notify(ServiceEvent.MapAddMapTrap, data)
end

function ServiceMapAutoProxy:RecvAddMapAct(data) 
	self:Notify(ServiceEvent.MapAddMapAct, data)
end

function ServiceMapAutoProxy:RecvExitPointState(data) 
	self:Notify(ServiceEvent.MapExitPointState, data)
end

function ServiceMapAutoProxy:RecvMapCmdEnd(data) 
	self:Notify(ServiceEvent.MapMapCmdEnd, data)
end

function ServiceMapAutoProxy:RecvNpcSearchRangeCmd(data) 
	self:Notify(ServiceEvent.MapNpcSearchRangeCmd, data)
end

function ServiceMapAutoProxy:RecvUserHandsCmd(data) 
	self:Notify(ServiceEvent.MapUserHandsCmd, data)
end

function ServiceMapAutoProxy:RecvSpEffectCmd(data) 
	self:Notify(ServiceEvent.MapSpEffectCmd, data)
end

function ServiceMapAutoProxy:RecvUserHandNpcCmd(data) 
	self:Notify(ServiceEvent.MapUserHandNpcCmd, data)
end

function ServiceMapAutoProxy:RecvGingerBreadNpcCmd(data) 
	self:Notify(ServiceEvent.MapGingerBreadNpcCmd, data)
end

function ServiceMapAutoProxy:RecvGoCityGateMapCmd(data) 
	self:Notify(ServiceEvent.MapGoCityGateMapCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.MapAddMapItem = "ServiceEvent_MapAddMapItem"
ServiceEvent.MapPickupItem = "ServiceEvent_MapPickupItem"
ServiceEvent.MapAddMapUser = "ServiceEvent_MapAddMapUser"
ServiceEvent.MapAddMapNpc = "ServiceEvent_MapAddMapNpc"
ServiceEvent.MapAddMapTrap = "ServiceEvent_MapAddMapTrap"
ServiceEvent.MapAddMapAct = "ServiceEvent_MapAddMapAct"
ServiceEvent.MapExitPointState = "ServiceEvent_MapExitPointState"
ServiceEvent.MapMapCmdEnd = "ServiceEvent_MapMapCmdEnd"
ServiceEvent.MapNpcSearchRangeCmd = "ServiceEvent_MapNpcSearchRangeCmd"
ServiceEvent.MapUserHandsCmd = "ServiceEvent_MapUserHandsCmd"
ServiceEvent.MapSpEffectCmd = "ServiceEvent_MapSpEffectCmd"
ServiceEvent.MapUserHandNpcCmd = "ServiceEvent_MapUserHandNpcCmd"
ServiceEvent.MapGingerBreadNpcCmd = "ServiceEvent_MapGingerBreadNpcCmd"
ServiceEvent.MapGoCityGateMapCmd = "ServiceEvent_MapGoCityGateMapCmd"
