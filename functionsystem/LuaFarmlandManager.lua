LuaFarmlandManager = class('LuaFarmlandManager')

LuaFarmlandManager.ins = nil
function LuaFarmlandManager:Ins()
	if LuaFarmlandManager.ins == nil then
		LuaFarmlandManager.ins = LuaFarmlandManager.new()
	end
	return LuaFarmlandManager.ins
end

function LuaFarmlandManager:Initialize()
	self.cachedFarmlands = {}
	self._overlap = false
	-- key creatureID,value farmlandID
	self.creatureInLand = {}
	self:Listen()
end

function LuaFarmlandManager:GetOverlap()
	return self._overlap
end

function LuaFarmlandManager:CheckOverlap()
	local farmland1,farmland2
	for i=1,#self.cachedFarmlands do
		farmland1 = self.cachedFarmlands[i]
		for j=i+1,#self.cachedFarmlands do
			farmland2 = self.cachedFarmlands[j]
			if(farmland1:IsOverlapOther(farmland2)) then
				self._overlap = true
				return
			end
		end
	end
end

function LuaFarmlandManager:Add(lua_farmland)
	local index = TableUtility.ArrayFindIndex(self.cachedFarmlands, lua_farmland)
	if not (index > 0) then
		table.insert(self.cachedFarmlands, lua_farmland)
	end
end

function LuaFarmlandManager:Remove(lua_farmland)
	local index = TableUtility.ArrayFindIndex(self.cachedFarmlands, lua_farmland)
	if index > 0 then
		table.remove(self.cachedFarmlands, index)
	end
end

function LuaFarmlandManager:Get(lua_farmland_id)
	for i = 1, #self.cachedFarmlands do
		local luaFarmland = self.cachedFarmlands[i]
		if luaFarmland.csfarmland.id == lua_farmland_id then
			return luaFarmland
		end
	end
	return nil
end

function LuaFarmlandManager:Clear()
	TableUtility.ArrayClear(self.cachedFarmlands)
	TableUtility.TableClear(self.creatureInLand)
end

function LuaFarmlandManager:Release()
	for i = 1, #self.cachedFarmlands do
		local luaFarmland = self.cachedFarmlands[i]
		luaFarmland:Release()
	end
	self.cachedFarmlands = nil
	self.creatureInLand = nil
end

function LuaFarmlandManager:Reset()
	self.cachedFarmlands = {}
	self.creatureInLand = {}
end

function LuaFarmlandManager:Update()
	for i = 1, #self.cachedFarmlands do
		local luaFarmland = self.cachedFarmlands[i]
		luaFarmland:Update()
	end
end

function LuaFarmlandManager:Listen()
	EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneBeLoaded, self)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveRoles,self.OnCreaturesRemove, self)
end

function LuaFarmlandManager:CancelListen()
	EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene,self.OnSceneBeLoaded,self)
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveRoles,self.OnCreaturesRemove, self)
end

function LuaFarmlandManager:OnSceneBeLoaded(message)
	local goFarmlands = GameObject.Find('Farmlands')
	if goFarmlands ~= nil then
		local farmlandCount = goFarmlands.transform.childCount
		if farmlandCount > 0 then
			for i = 0, farmlandCount - 1 do
				local transFarmland = goFarmlands.transform:GetChild(i)
				local farmland = transFarmland:GetComponent(Farmland)
				local luaFarmland = LuaFarmland.new()
				luaFarmland:AttachGameObject(transFarmland.gameObject)
				luaFarmland:SetCSFarmland(farmland)
				luaFarmland:Initialize()
				self:Add(luaFarmland)
			end
			self:CheckOverlap()
		end
	end
end

function LuaFarmlandManager:OnCreaturesRemove(roleIDs)
	local creatureID,inLandID,farmland
	for i=1,#roleIDs do
		creatureID = roleIDs[i]
		inLandID = self.creatureInLand[creatureID]
		if(inLandID) then
			if(self._overlap) then
				for j=1,#self.cachedFarmlands do
					farmland = self.cachedFarmlands[j]
					if(inLandID & farmland.idBitValue > 0) then
						farmland:SomebodyLeave(creatureID)
					end
				end
			else
				farmland = self:Get(inLandID)
				farmland:SomebodyLeave(creatureID)
			end
			self.creatureInLand[creatureID] = nil
		end
	end
end

function LuaFarmlandManager:CreatureIn(luaFarmland,creatureID,pos)
	local inLandID = self.creatureInLand[creatureID]
	if(self._overlap) then
		--set in land flag
		if(inLandID == nil or inLandID & luaFarmland.idBitValue == 0) then
			self.creatureInLand[creatureID] = luaFarmland.idBitValue + (inLandID or 0)
			luaFarmland:SomebodyMove(creatureID,pos)
		end
	else
		if(inLandID~=luaFarmland.id) then
			if(inLandID) then
				local lastland = self:Get(inLandID)
				lastland:SomebodyLeave(creatureID)
			end
			luaFarmland:SomebodyOccur(creatureID,pos)
		end
		self.creatureInLand[creatureID] = luaFarmland.id
	end
end

function LuaFarmlandManager:TryHandleCreatureIdle(luaFarmland,creatureID)
	luaFarmland:SomebodyIdle(creatureID)
end

function LuaFarmlandManager:TryHandleCreatureMoving(luaFarmland,creatureID,pos)
	luaFarmland:SomebodyMove(creatureID,pos)
end

function LuaFarmlandManager:TryHandleCreatureLeaving(luaFarmland,creatureID)
	if(self._overlap) then
		local inLandID = self.creatureInLand[creatureID]
		if(inLandID) then
			if(inLandID & luaFarmland.idBitValue > 0) then
				luaFarmland:SomebodyLeave(creatureID)
				inLandID = inLandID - luaFarmland.idBitValue
				if(inLandID==0) then
					self.creatureInLand[creatureID] = nil
				else
					self.creatureInLand[creatureID] = inLandID
				end
			end
		end
	else
		local inLandID = self.creatureInLand[creatureID]
		if(inLandID and inLandID == luaFarmland.id) then
			luaFarmland:SomebodyLeave(creatureID)
			self.creatureInLand[creatureID] = nil
		end
	end
end