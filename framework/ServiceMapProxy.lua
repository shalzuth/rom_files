autoImport('ServiceMapAutoProxy')
ServiceMapProxy = class('ServiceMapProxy', ServiceMapAutoProxy)
ServiceMapProxy.Instance = nil
ServiceMapProxy.NAME = 'ServiceMapProxy'

function ServiceMapProxy:ctor(proxyName)
	if ServiceMapProxy.Instance == nil then
		self.proxyName = proxyName or ServiceMapProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceMapProxy.Instance = self
	end
end

function ServiceMapProxy:RecvAddMapItem(data) 
	SceneItemProxy.Instance:DropItems(data.items)
	-- for i=1,#data.items do
	-- 	helplog("掉落物品:", data.items[i].guid);
	-- end
	self:Notify(ServiceEvent.MapAddMapItem, data)
end

function ServiceMapProxy:RecvPickupItem(data) 
	local player = SceneCreatureProxy.FindCreature(data.playerguid)
	if(player~=nil) then
		-- helplog( string.format("玩家%s拾取%s是否成功:%s",player.data.name,(data.itemguid),tostring(data.success)) )
		if(data.success) then
			FunctionSceneItemCommand.Me():PickUpItem(player,data.itemguid)
		end
	end
	self:Notify(ServiceEvent.MapPickupItem, data)
end

function ServiceMapProxy:RecvAddMapUser(data) 
	NSceneUserProxy.Instance:AddSome(data.users)
	self:Notify(ServiceEvent.MapAddMapUser, data)
end

function ServiceMapProxy:RecvAddMapNpc(data) 
	NSceneNpcProxy.Instance:AddSome(data.npcs)
	-- print("FUN >>> ServiceMapProxy:RecvAddMapNpc",#data.npcs)
	-- LuaGC.AddCreature(#data.npcs)
	self:Notify(ServiceEvent.MapAddMapNpc, data)
end

function ServiceMapProxy:RecvAddMapTrap(data) 
	SceneTrapProxy.Instance:AddSome(data.traps)
	-- self:Notify(ServiceEvent.MapAddMapTrap, data)
end

function ServiceMapProxy:RecvExitPointState(data) 
	Game.AreaTrigger_ExitPoint:SetEPEnable(data.exitid,data.visible==1)
	local note = ReusableTable.CreateTable()
	note.id ,note.state = data.exitid,(data.visible==1)
	self:Notify(MiniMapEvent.ExitPointStateChange,note);
	ReusableTable.DestroyAndClearTable(note)
	-- self:Notify(ServiceEvent.MapExitPointState, data)
end

function ServiceMapProxy:RecvAddMapAct(data) 
	SceneTriggerProxy.Instance:AddSome(data.acts)
	-- self:Notify(ServiceEvent.MapAddMapAct, data)
end

function ServiceMapProxy:RecvMapCmdEnd(data) 
	-- self:Notify(ServiceEvent.MapMapCmdEnd, data)
	FunctionMapEnd.Me():Launch()
end

function ServiceMapProxy:RecvNpcSearchRangeCmd(data)
	NSceneNpcProxy.Instance:SetSearchRange(data)
end

function ServiceMapProxy:RecvUserHandsCmd(data) 
	-- local creature = SceneCreatureProxy.FindCreature(data.player2)
	-- FunctionHandInHand.Me():HandInHand(data.player1,creature,data.isadd == 1)
	-- self:Notify(ServiceEvent.MapUserHandsCmd, data)
end

-- function ServiceMapProxy:RecvUserLineCmd(data) 
-- 	if(data.isline) then
-- 		FunctionConnectRole.Me():Add(data.masterId, data.slaveId)
-- 	else
-- 		FunctionConnectRole.Me():Remove(data.masterId, data.slaveId)
-- 	end
-- end
function ServiceMapProxy:RecvSpEffectCmd(data) 
	local creature = SceneCreatureProxy.FindCreature(data.senderid)
	if nil == creature then
		return
	end
	local spEffectData = data.data
	if data.isadd then
		creature:Server_AddSpEffect(spEffectData)
	else
		creature:Server_RemoveSpEffect(spEffectData)
	end
	
	self:Notify(ServiceEvent.MapSpEffectCmd, data)
end

function ServiceMapProxy:RecvUserHandNpcCmd(data)
	SceneAINpcProxy.Instance:SetHandNpc(data)
	self:Notify(ServiceEvent.MapUserHandNpcCmd, data)
end

function ServiceMapProxy:RecvGingerBreadNpcCmd(data)
	SceneAINpcProxy.Instance:SetExpressNpc(data)
	self:Notify(ServiceEvent.MapGingerBreadNpcCmd, data)
end