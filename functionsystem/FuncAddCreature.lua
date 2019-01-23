autoImport("EventDispatcher")
FuncAddCreature = class("FuncAddCreature",EventDispatcher)

FuncAddCreature.Func = {
	HandInHand = 1,
}

function FuncAddCreature.Me()
	if nil == FuncAddCreature.me then
		FuncAddCreature.me = FuncAddCreature.new()
	end
	return FuncAddCreature.me
end

function FuncAddCreature:ctor()
	self.waitMap = nil
	self.handles = {}
	self.handles[FuncAddCreature.Func.HandInHand] = self.HandleHandInHand
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles,self.SceneAddCreaturesHandler,self)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs,self.SceneAddCreaturesHandler,self)
end

function FuncAddCreature:Reset()
	self.waitMap = {}
end

function FuncAddCreature:SceneAddCreaturesHandler(creatures)
	for i=1,#creatures do
		self:HandleAddCreature(creatures[i])
	end
end

function FuncAddCreature:AddToWait(waitFor,wait,funcType)
	local map = self.waitMap[waitFor]
	if(map==nil) then
		map = {}
		self.waitMap[waitFor] = map
	end
	local funcMap = map[funcType]
	if(funcMap==nil) then
		funcMap = {}
		map[funcType] = funcMap
	end
	funcMap[wait] = wait
end

function FuncAddCreature:RemoveWait(waitFor,wait,funcType)
	local map = self.waitMap[waitFor]
	if(map) then
		local funcMap = map[funcType]
		if(funcMap) then
			funcMap[wait] = nil
		end
	end
end

function FuncAddCreature:HandleAddCreature(creature)
	local map = self.waitMap[creature.id]
	if(map) then
		local handle = nil
		for k,v in pairs(map) do
			handle = self.handles[k]
			if(handle~=nil) then
				handle(self,creature,v)
			end
		end
	end
end

--确保follower不是Nil
function FuncAddCreature:HandInHand(masterID,followerCreature,on)
	local creature = SceneCreatureProxy.FindCreature(masterID)
	if(followerCreature) then
		followerCreature:ControlHandInHand(on,creature~=nil and creature.roleAgent or nil)
	end
	if(creature) then
		creature:BeHandInHandLeader(on)
	elseif(followerCreature) then
		if(on) then
			self:AddToWait(masterID,followerCreature.id,FuncAddCreature.Func.HandInHand)
		else
			self:RemoveWait(masterID,followerCreature.id,FuncAddCreature.Func.HandInHand)
		end
	end
end

function FuncAddCreature:HandleHandInHand(master,followerIDs)
	if(master) then
		master:BeHandInHandLeader(true)
		local follower = nil
		for k,v in pairs(followerIDs) do
			follower = SceneCreatureProxy.FindCreature(k)
			if(follower) then
				follower:ControlHandInHand(true,master.roleAgent)
			end
			followerIDs[k] = nil
		end
	end
end