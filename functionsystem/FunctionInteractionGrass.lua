-- autoImport('EffectAndAudioForInteractionGrass_NoAppropriate')
autoImport('LuaFarmland')
autoImport('LuaRolesOnCurrentMap')
autoImport('Debug_LuaMemotry')
autoImport('ArrayUtil')
autoImport('LuaDynamicGrass')

FunctionInteractionGrass = class("FunctionInteractionGrass")

local reusableLuaVector3 = LuaVector3.New()
local reusableArray1 = {}
local reusableArray2 = {}

local poolLuaVector3 = {}
local IsNull = Slua.IsNull
function FunctionInteractionGrass.GetLuaVector3()
	local retVec3 = nil
	local retIndex = 0
	for k, v in pairs(poolLuaVector3) do
		local vec3Container = v
		if not vec3Container.vec3IsBusy then
			retVec3 = vec3Container.vec3
			retIndex = k
			vec3Container.vec3IsBusy = true
			break
		end
	end
	if retVec3 == nil then
		local luaVector3 = LuaVector3.zero
		local vec3Container = {
			vec3IsBusy = true,
			vec3 = luaVector3
		}
		table.insert(poolLuaVector3, vec3Container)
		retVec3 = luaVector3
		retIndex = #poolLuaVector3
	end
	return retVec3, retIndex
end

function FunctionInteractionGrass.BackLuaVector3(lua_vector3_index)
	local vec3Container = poolLuaVector3[lua_vector3_index]
	vec3Container.isBusy = false
	vec3Container.vec3:Set(0, 0, 0)
end

FunctionInteractionGrass.ins = nil
function FunctionInteractionGrass.Ins()
	if FunctionInteractionGrass.ins == nil then
		FunctionInteractionGrass.ins = FunctionInteractionGrass.new()
	end
	return FunctionInteractionGrass.ins
end

function FunctionInteractionGrass:Open()
	if self.tick == nil then
		self.tickID = 1
		self.tick = TimeTickManager.Me():CreateTick(0, 100, self.OnTick, self, self.tickID)
	end
	if self.farmlandManager == nil then
		self.farmlandManager = LuaFarmlandManager.Ins()
		self.farmlandManager:Initialize()
	end

	-- {
	-- 	[1] = { -- player id
	-- 		pos = LuaVector3.zero, -- position
	-- 		previousFarmland = 1, -- previous farmland
	-- 		isLeaveFromPreviousFarmland = false,
	-- 		farmland = 1 -- farmland
	-- 	}
	-- }
	if self.cachedPlayersOnFarmlands == nil then
		self.cachedPlayersOnFarmlands = {}
	end

	-- self:ListenSceneBeLoaded()

	-- EffectAndAudioForInteractionGrass_NoAppropriate.Instance():Open()

	self:Listen()
end

function FunctionInteractionGrass:Close()
	if self.tick ~= nil then
		TimeTickManager.Me():ClearTick(self, self.tickID)
	end
	self:Release()
	-- EffectAndAudioForInteractionGrass_NoAppropriate.Instance():Close()
	self:CancelListen()
end

function FunctionInteractionGrass:OnTick()
	if not self:IsExistAnyFarmland() then
		return
	end
	
	-- 1.handle Myself
	self:_HandleCreature(Game.Myself)

	-- 2.handle Players
	local users = NSceneUserProxy.Instance.userMap
	for k,v in pairs(users) do
		self:_HandleCreature(v)
	end

	-- 3.can handle npcs
end

function FunctionInteractionGrass:_HandleCreature(creature)
	local pos = creature:GetPosition()
	local creatureID= creature.data.id
	local handled = false
	local farmlandManager = self.farmlandManager
	for i = 1, #farmlandManager.cachedFarmlands do
		local luaFarmland = farmlandManager.cachedFarmlands[i]
		-- if not IsNull(luaFarmland.csfarmland) then
			if(handled==false) then
				if(luaFarmland:IsPointInside(pos)) then
					farmlandManager:CreatureIn(luaFarmland,creatureID,pos)
					if(not farmlandManager:GetOverlap()) then
						handled = true
					end
					if(creature:IsMoving()) then
						--handle moving
						farmlandManager:TryHandleCreatureMoving(luaFarmland,creatureID,pos)
					else
						--handle idle
						-- farmlandManager:TryHandleCreatureIdle(luaFarmland,creatureID)
					end
				else
					farmlandManager:TryHandleCreatureLeaving(luaFarmland,creatureID)
				end
			else
				farmlandManager:TryHandleCreatureLeaving(luaFarmland,creatureID)
			end
		-- end
	end
end

function FunctionInteractionGrass:IsExistAnyFarmland()
	for k, v in pairs(self.farmlandManager.cachedFarmlands) do
		local luaFarmland = v
		if not GameObjectUtil.Instance:ObjectIsNULL(luaFarmland.csfarmland) then
			return true
		end
	end
	return false
end

function FunctionInteractionGrass:Listen()
	EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneBeLoaded, self)
	EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self.OnMapChange, self)
end

function FunctionInteractionGrass:CancelListen()
	EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene,self.OnSceneBeLoaded,self)
	EventManager.Me():RemoveEventListener(ServiceEvent.PlayerMapChange, self.OnMapChange, self)
end

function FunctionInteractionGrass:OnSceneBeLoaded(message)
------------------- lawn -------------------
	-- self:GetLawnsGameObject()
------------------- lawn -------------------
end

function FunctionInteractionGrass:OnMapChange(message)
	self:Release()
	self:Reset()
	self.farmlandManager:Release()
	self.farmlandManager:Reset()
	-- EffectAndAudioForInteractionGrass_NoAppropriate.Instance():Reset()
	LuaRolesOnCurrentMap.Ins():Reset()
	-- LuaDynamicGrass.ReleasePoolEffectiveBody()
end

------------------- lawn -------------------
local effectiveDistanceOfLawn = {
	Clover = 0.5,
}

function FunctionInteractionGrass:GetLawnsGameObject()
	if self.gameObjectLawns == nil then
		self.gameObjectLawns = {}
	end
	TableUtility.ArrayClear(self.gameObjectLawns)
	local index = 1
	while true do
		local goLawn = GameObject.Find("Lawn" .. index)
		if goLawn ~= nil then
			table.insert(self.gameObjectLawns, goLawn)
			index = index + 1
		else
			break
		end
	end
end

function FunctionInteractionGrass:IsExistAnyLawn()
	if self.gameObjectLawns ~= nil then
		for k, v in pairs(self.gameObjectLawns) do
			local gameObjectLawn = v
			if GameObjectUtil.Instance:ObjectIsNULL(gameObjectLawn) then
				self.gameObjectLawns[k] = nil
			end
		end
		if #self.gameObjectLawns > 0 then
			return true
		end
	end
	return false
end
------------------- lawn -------------------

function FunctionInteractionGrass:Release()
	for _, v in pairs(self.cachedPlayersOnFarmlands) do
		local playerOnFarmland = v
		FunctionInteractionGrass.BackLuaVector3(playerOnFarmland.vec3Index)
		ReusableTable.DestroyAndClearTable(playerOnFarmland)
	end
	self.cachedPlayersOnFarmlands = nil
end

function FunctionInteractionGrass:Reset()
	self.cachedPlayersOnFarmlands = {}
end