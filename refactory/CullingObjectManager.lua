
-- CullingObjectSyncInfo = class("CullingObjectSyncInfo", ReusableObject)
-- function CullingObjectSyncInfo:ctor()
	
-- end
-- function CullingObjectSyncInfo:SetLocalPosition(x,y,z)
-- 	if nil ~= self.localPosition then
-- 		self.localPosition:Set(x,y,z)
-- 	else
-- 		self.localPosition = LuaVector3.New(x,y,z)
-- 	end
-- end
-- function CullingObjectSyncInfo:SetLocalEulerAngles(x,y,z)
-- 	if nil ~= self.localEulerAngles then
-- 		self.localEulerAngles:Set(x,y,z)
-- 	else
-- 		self.localEulerAngles = LuaVector3.New(x,y,z)
-- 	end
-- end
-- function CullingObjectSyncInfo:SetLocalScale(x,y,z)
-- 	if nil ~= self.scale then
-- 		self.scale:Set(x,y,z)
-- 	else
-- 		self.scale = LuaVector3.New(x,y,z)
-- 	end
-- end
-- function CullingObjectSyncInfo:SetLocalEulerAngleY(v)
-- 	self.angleY = v
-- end
-- function CullingObjectSyncInfo:SetLocalScaleAll(v)
-- 	self.scaleAll = v
-- end
-- function CullingObjectSyncInfo:SetPosition(x,y,z)
-- 	if nil ~= self.position then
-- 		self.position:Set(x,y,z)
-- 	else
-- 		self.position = LuaVector3.New(x,y,z)
-- 	end
-- end
-- function CullingObjectSyncInfo:SetEulerAngles(x,y,z)
-- 	if nil ~= self.eulerAngles then
-- 		self.eulerAngles:Set(x,y,z)
-- 	else
-- 		self.eulerAngles = LuaVector3.New(x,y,z)
-- 	end
-- end
-- function CullingObjectSyncInfo:Serialize(type, key, array)
-- 	local typeIndex = #array+1

-- 	local flag = 0
-- 	local index = typeIndex+3
-- 	if nil ~= self.psition then
-- 		local p = self.psition
-- 		array[index+1] = p[1]
-- 		array[index+2] = p[2]
-- 		array[index+3] = p[3]
-- 		index = index+3
-- 		flag = flag + 1
-- 	end
-- 	if nil ~= self.eulerAngles then
-- 		local p = self.eulerAngles
-- 		array[index+1] = p[1]
-- 		array[index+2] = p[2]
-- 		array[index+3] = p[3]
-- 		index = index+3
-- 		flag = flag + 2
-- 	end
-- 	if nil ~= self.scale then
-- 		local p = self.scale
-- 		array[index+1] = p[1]
-- 		array[index+2] = p[2]
-- 		array[index+3] = p[3]
-- 		index = index+3
-- 		flag = flag + 4
-- 	end
-- 	if nil ~= self.angleY then
-- 		array[index+1] = self.angleY
-- 		index = index+1
-- 		flag = flag + 8
-- 	end
-- 	if nil ~= self.scale then
-- 		array[index+1] = self.scale
-- 		index = index+1
-- 		flag = flag + 16
-- 	end
-- 	if nil ~= self.psition then
-- 		local p = self.psition
-- 		array[index+1] = p[1]
-- 		array[index+2] = p[2]
-- 		array[index+3] = p[3]
-- 		index = index+3
-- 		flag = flag + 32
-- 	end
-- 	if nil ~= self.eulerAngles then
-- 		local p = self.eulerAngles
-- 		array[index+1] = p[1]
-- 		array[index+2] = p[2]
-- 		array[index+3] = p[3]
-- 		index = index+3
-- 		flag = flag + 64
-- 	end
-- 	if 0 ~= flag then
-- 		array[typeIndex] = type
-- 		array[typeIndex+1] = key
-- 		array[typeIndex+2] = flag
-- 	end
-- end
-- -- override begin
-- function CullingObjectSyncInfo:DoConstruct(asArray, args)

-- end

-- function CullingObjectSyncInfo:DoDeconstruct(asArray)
-- 	if nil ~= self.localPsition then
-- 		self.localPsition:Destroy()
-- 		self.localPsition = nil
-- 	end
-- 	if nil ~= self.localEulerAngles then
-- 		self.localEulerAngles:Destroy()
-- 		self.localEulerAngles = nil
-- 	end
-- 	if nil ~= self.scale then
-- 		self.scale:Destroy()
-- 		self.scale = nil
-- 	end
-- 	self.angleY = nil
-- 	self.scale = nil
-- 	if nil ~= self.psition then
-- 		self.psition:Destroy()
-- 		self.psition = nil
-- 	end
-- 	if nil ~= self.eulerAngles then
-- 		self.eulerAngles:Destroy()
-- 		self.eulerAngles = nil
-- 	end
-- end
-- -- override end

CullingObjectManager = class("CullingObjectManager")

local CullingType = {
	CullingObject = Game.GameObjectType.CullingObject, -- 8, auto active
	ExitPoint = 100, -- auto active
	Trap = 101, -- auto active
	Creature = 200,
}

local UpdateInterval = 0.1

local FindCreature = SceneCreatureProxy.FindCreature
local CompatibilityMode_V9 = BackwardCompatibilityUtil.CompatibilityMode_V9

local CreatureGUIDMap = {}

function CullingObjectManager:ctor()
	-- if not CompatibilityMode_V9 then
	-- 	self.syncInfos = {}
	-- end
end

function CullingObjectManager:DistanceToLevel(distance)
	if nil == self.boundingDistances then
		self.boundingDistances = Game.Object_GameObjectMap.cullingGroupBoundingDistances
	end
	local maxLevel = #self.boundingDistances
	for i=1, maxLevel do
		if self.boundingDistances[i] > distance then
			return i-1
		end
	end
	return maxLevel
end

function CullingObjectManager:SetCamera(camera)
	Game.Object_GameObjectMap:SetCullingGroupCamera(camera)
end

function CullingObjectManager:ClearCamera(camera)
	Game.Object_GameObjectMap:ClearCullingGroupCamera(camera)
end

function CullingObjectManager:ReferenceToMyself(on)
	local ref = on and Game.Myself.assetRole.completeTransform or nil
	Game.Object_GameObjectMap.cullingGroupReference = ref
end

-- culling object begin
function CullingObjectManager:Register_CullingObject(obj)
	local radius = tonumber(obj:GetProperty(0))
	self:_Register(
		CullingType.CullingObject, 
		obj.ID, 
		obj.transform, 
		radius)
end
function CullingObjectManager:Unregister_CullingObject(obj)
	if not self.running then
		return
	end
	self:_Unregister(CullingType.CullingObject, obj.ID)
end
function CullingObjectManager:Clear_CullingObject()
	self:Clear(CullingType.CullingObject)
end
-- culling object end

-- exit point begin
function CullingObjectManager:Register_ExitPoint(ep, effectHandler)
	self:_Register(
		CullingType.ExitPoint, 
		ep.ID, 
		effectHandler.transform, 
		1.5)
end
function CullingObjectManager:Unregister_ExitPoint(ep)
	if not self.running then
		return
	end
	self:_Unregister(CullingType.ExitPoint, ep.ID)
end
function CullingObjectManager:Clear_ExitPoint()
	self:_Clear(CullingType.ExitPoint)
end
-- exit point end

-- trap begin
function CullingObjectManager:Register_Trap(trap, effectHandler)
	self:_Register(
		CullingType.Trap, 
		trap.cullingID, 
		effectHandler.transform, 
		1.5)
end
function CullingObjectManager:Unregister_Trap(trap)
	if not self.running then
		return
	end
	self:_Unregister(CullingType.Trap, trap.cullingID)
end
function CullingObjectManager:Clear_Trap()
	self:_Clear(CullingType.Trap)
end
-- trap end

-- creature begin
function CullingObjectManager:Register_Creature(creature)
	if CompatibilityMode_V9 then
		CreatureGUIDMap[creature.data.cullingID] = creature.data.id
	end
	self:_Register(
		CullingType.Creature, 
		creature.data.cullingID, 
		creature.assetRole.completeTransform, 
		1)
end
function CullingObjectManager:Unregister_Creature(creature)
	if CompatibilityMode_V9 then
		CreatureGUIDMap[creature.data.cullingID] = nil
	end
	if not self.running then
		return
	end
	self:_Unregister(CullingType.Creature, creature.data.cullingID)
end
function CullingObjectManager:Clear_Creature()
	self:_Clear(CullingType.Creature)
	if CompatibilityMode_V9 then
		TableUtility.TableClear(CreatureGUIDMap)
	end
end
function CullingObjectManager:SyncLocalPosition_Creature(creature, x, y, z)
	self:_SyncLocalPosition(CullingType.Creature, creature.data.cullingID, x, y, z)
end
function CullingObjectManager:SyncLocalEulerAngleY_Creature(creature, v)
	self:_SyncLocalEulerAngleY(CullingType.Creature, creature.data.cullingID, v)
end
function CullingObjectManager:SyncLocalScaleAll_Creature(creature, v)
	self:_SyncLocalScaleAll(CullingType.Creature, creature.data.cullingID, v)
end
-- creature end

function CullingObjectManager:ClearAll()
	Game.Object_GameObjectMap:ClearAll()
	if CompatibilityMode_V9 then
		TableUtility.TableClear(CreatureGUIDMap)
	end
end

function CullingObjectManager:_Register(type, key, transform, radius)
	Game.Object_GameObjectMap:Register_TransformForCulling(
		type, key, transform, radius)
end

function CullingObjectManager:_Unregister(type, key)
	Game.Object_GameObjectMap:Unregister(type, key)
end

function CullingObjectManager:_Clear(type)
	Game.Object_GameObjectMap:Clear(type)
end

function CullingObjectManager:_GetSyncInfo(type, key)
	local infoMap = self.syncInfos[type]
	if nil == infoMap then
		infoMap = ReusableTable.CreateTable()
		self.syncInfos[type] = infoMap
	end
	local info = infoMap[key]
	if nil == info then
		info = CullingObjectSyncInfo.new()
		info[key] = info
	end
	return info
end

function CullingObjectManager:_SyncLocalPosition(type, key, x, y, z)
	-- if CompatibilityMode_V9 then
		GameObjectMap.SetLocalPosition(
			type, key, 
			x, y, z)
	-- else
	-- 	local info = self:_GetSyncInfo(type, key)
	-- 	info:SetLocalPosition(x, y, z)
	-- end
end

function CullingObjectManager:_SyncLocalEulerAngles(type, key, x, y, z)
	-- if CompatibilityMode_V9 then
		GameObjectMap.SetLocalEulerAngles(
			type, key, 
			x, y, z)
	-- else
	-- 	local info = self:_GetSyncInfo(type, key)
	-- 	info:SetLocalEulerAngles(x, y, z)
	-- end
end

function CullingObjectManager:_SyncLocalScale(type, key, x, y, z)
	-- if CompatibilityMode_V9 then
		GameObjectMap.SetLocalScale(
			type, key, 
			x, y, z)
	-- else
	-- 	local info = self:_GetSyncInfo(type, key)
	-- 	info:SetLocalScale(x, y, z)
	-- end
end

function CullingObjectManager:_SyncLocalEulerAngleY(type, key, v)
	-- if CompatibilityMode_V9 then
		GameObjectMap.SetLocalEulerAngleY(
			type, key, 
			v)
	-- else
	-- 	local info = self:_GetSyncInfo(type, key)
	-- 	info:SetLocalEulerAngleY(v)
	-- end
end

function CullingObjectManager:_SyncLocalScaleAll(type, key, v)
	-- if CompatibilityMode_V9 then
		GameObjectMap.SetLocalScale(
			type, key, 
			v, v, v)
	-- else
	-- 	local info = self:_GetSyncInfo(type, key)
	-- 	info:SetLocalScaleAll(v)
	-- end
end

function CullingObjectManager:_SyncPosition(type, key, x, y, z)
	-- if CompatibilityMode_V9 then
		GameObjectMap.SetPosition(
			type, key, 
			x, y, z)
	-- else
	-- 	local info = self:_GetSyncInfo(type, key)
	-- 	info:SetPosition(x, y, z)
	-- end
end

function CullingObjectManager:_SyncEulerAngles(type, key, x, y, z)
	-- if CompatibilityMode_V9 then
		GameObjectMap.SetEulerAngles(
			type, key, 
			x, y, z)
	-- else
	-- 	local info = self:_GetSyncInfo(type, key)
	-- 	info:SetEulerAngles(x, y, z)
	-- end
end
-- local tempSyncArray = {}
-- function CullingObjectManager:_SyncAll()
-- 	if CompatibilityMode_V9 then
-- 		return
-- 	end

-- 	for type,v in pairs(self.syncInfos) do
-- 		self.syncInfos[type] = nil
-- 		for key,info in pairs(v) do
-- 			v[key] = nil
-- 			info:Serialize(type, key, tempSyncArray)
-- 			info:Destroy()
-- 		end
-- 		ReusableTable.DestroyTable(v)
-- 	end
-- 	if 0 < #tempSyncArray then
-- 		GameObjectMapHelper.SyncTransform(tempSyncArray)
-- 		TableUtility.ArrayClear(tempSyncArray)
-- 	end
-- end

function CullingObjectManager:Launch()
	if self.running then
		return
	end
	self.running = true

	self.nextUpdateTime = 0
end

function CullingObjectManager:Shutdown()
	if not self.running then
		return
	end
	self.running = false

	self:ClearAll()
end

local cullingStateChangedArray = {}
-- CullingState = {
-- 	[1] = type, -- int
-- 	[2] = key, -- int
-- 	[3] = visible, -- int, not 0 is true, nil if not changed
-- 	[4] = distanceLevel, -- int base 0, nil if not changed
-- }
-- distance levels: 
-- 0. <10
-- 1. 10~20
-- 2. 20~50
-- 3. >50
function CullingObjectManager:LateUpdate(time, deltaTime)
	if not self.running then
		return
	end

	-- self:_SyncAll()

	if time < self.nextUpdateTime then
		return
	end
	self.nextUpdateTime = time + UpdateInterval

	-- Profiler.BeginSample("[Ghost] GetChangedCullingStates");
	GameObjectMapHelper.GetChangedCullingStates(cullingStateChangedArray)
	local index = 1
	local objType = cullingStateChangedArray[index]
	while nil ~= objType do
		-- LogUtility.InfoFormat("<color=white>CullingChanged: </color>{0}, {1}", 
		-- 	LogUtility.StringFormat("type={0}, key={1}", 
		-- 		objType, 
		-- 		cullingStateChangedArray[index+1]),
		-- 	LogUtility.StringFormat("isVisible={0}, currentDistance={1}", 
		-- 		LogUtility.ToString(cullingStateChangedArray[index+2]), 
		-- 		LogUtility.ToString(cullingStateChangedArray[index+3])))
		if CullingType.Creature == objType then
			local creatureGUID = cullingStateChangedArray[index+1]
			if CompatibilityMode_V9 then
				creatureGUID = CreatureGUIDMap[creatureGUID]
			end
			local creature = FindCreature(creatureGUID)
			if nil ~= creature then
				-- LogUtility.InfoFormat("<color=white>CullingChanged: </color>{0}, {1}", 
				-- 	LogUtility.StringFormat("creatureGUID={0}, key={1}, name={2}", 
				-- 		creatureGUID,
				-- 		cullingStateChangedArray[index+1],
				-- 		creature.data:GetName()),
				-- 	LogUtility.StringFormat("isVisible={0}, currentDistance={1}", 
				-- 		LogUtility.ToString(cullingStateChangedArray[index+2]), 
				-- 		LogUtility.ToString(cullingStateChangedArray[index+3])))
				creature:CullingStateChange(
					cullingStateChangedArray[index+2],
					cullingStateChangedArray[index+3])
			end
		elseif CullingType.ExitPoint == objType then
			Game.AreaTrigger_ExitPoint:CullingStateChange(
				cullingStateChangedArray[index+1], 
				cullingStateChangedArray[index+2],
				cullingStateChangedArray[index+3])
		elseif CullingType.Trap == objType then
			SceneTrapProxy.Instance:CullingStateChange(
				cullingStateChangedArray[index+1], 
				cullingStateChangedArray[index+2],
				cullingStateChangedArray[index+3])
		end
		index = index + 4
		objType = cullingStateChangedArray[index]
	end
	if 1 < index then
		TableUtility.ArrayClearWithCount(cullingStateChangedArray, index-1)
	end
	-- Profiler.EndSample()
end