
autoImport ("Asset_Role")
autoImport ("Asset_RolePart")

AssetManager_Role = class("AssetManager_Role")

local GetFromRoleCompletePool = GOLuaPoolManager.GetFromRoleCompletePool
local AddToRoleCompletePool = GOLuaPoolManager.AddToRoleCompletePool

local GetFromRolePartPool = {
	GOLuaPoolManager.GetFromRolePartBodyPool,
	GOLuaPoolManager.GetFromRolePartHairPool,
	GOLuaPoolManager.GetFromRolePartWeaponPool,
	GOLuaPoolManager.GetFromRolePartWeaponPool,
	GOLuaPoolManager.GetFromRolePartHeadPool,
	GOLuaPoolManager.GetFromRolePartWingPool,
	GOLuaPoolManager.GetFromRolePartFacePool,
	GOLuaPoolManager.GetFromRolePartTailPool,
	GOLuaPoolManager.GetFromRolePartEyePool,
	GOLuaPoolManager.GetFromRolePartMouthPool,
	GOLuaPoolManager.GetFromRolePartMountPool,
}

local AddToRolePartPool = {
	GOLuaPoolManager.AddToRolePartBodyPool,
	GOLuaPoolManager.AddToRolePartHairPool,
	GOLuaPoolManager.AddToRolePartWeaponPool,
	GOLuaPoolManager.AddToRolePartWeaponPool,
	GOLuaPoolManager.AddToRolePartHeadPool,
	GOLuaPoolManager.AddToRolePartWingPool,
	GOLuaPoolManager.AddToRolePartFacePool,
	GOLuaPoolManager.AddToRolePartTailPool,
	GOLuaPoolManager.AddToRolePartEyePool,
	GOLuaPoolManager.AddToRolePartMouthPool,
	GOLuaPoolManager.AddToRolePartMountPool,
}

local RolePartPoolKeyFull = {
	GOLuaPoolManager.RolePartBodyKeyFull,
	GOLuaPoolManager.RolePartHairKeyFull,
	GOLuaPoolManager.RolePartWeaponKeyFull,
	GOLuaPoolManager.RolePartWeaponKeyFull,
	GOLuaPoolManager.RolePartHeadKeyFull,
	GOLuaPoolManager.RolePartWingKeyFull,
	GOLuaPoolManager.RolePartFaceKeyFull,
	GOLuaPoolManager.RolePartTailKeyFull,
	GOLuaPoolManager.RolePartEyeKeyFull,
	GOLuaPoolManager.RolePartMouthKeyFull,
	GOLuaPoolManager.RolePartMountKeyFull,
}

local RolePartPoolElementFull = {
	GOLuaPoolManager.RolePartBodyElementFull,
	GOLuaPoolManager.RolePartHairElementFull,
	GOLuaPoolManager.RolePartWeaponElementFull,
	GOLuaPoolManager.RolePartWeaponElementFull,
	GOLuaPoolManager.RolePartHeadElementFull,
	GOLuaPoolManager.RolePartWingElementFull,
	GOLuaPoolManager.RolePartFaceElementFull,
	GOLuaPoolManager.RolePartTailElementFull,
	GOLuaPoolManager.RolePartEyeElementFull,
	GOLuaPoolManager.RolePartMouthElementFull,
	GOLuaPoolManager.RolePartMountElementFull,
}

local RolePartPoolElementCount = {
	GOLuaPoolManager.RolePartBodyElementCount,
	GOLuaPoolManager.RolePartHairElementCount,
	GOLuaPoolManager.RolePartWeaponElementCount,
	GOLuaPoolManager.RolePartWeaponElementCount,
	GOLuaPoolManager.RolePartHeadElementCount,
	GOLuaPoolManager.RolePartWingElementCount,
	GOLuaPoolManager.RolePartFaceElementCount,
	GOLuaPoolManager.RolePartTailElementCount,
	GOLuaPoolManager.RolePartEyeElementCount,
	GOLuaPoolManager.RolePartMouthElementCount,
	GOLuaPoolManager.RolePartMountElementCount,
}

local ResPathHelperFuncs = {
	[Asset_Role.PartIndex.Body] = ResourcePathHelper.RoleBody,
	[Asset_Role.PartIndex.Hair] = ResourcePathHelper.RoleHair,
	[Asset_Role.PartIndex.LeftWeapon] = ResourcePathHelper.RoleWeapon,
	[Asset_Role.PartIndex.RightWeapon] = ResourcePathHelper.RoleWeapon,
	[Asset_Role.PartIndex.Head] = ResourcePathHelper.RoleHead,
	[Asset_Role.PartIndex.Wing] = ResourcePathHelper.RoleWing,
	[Asset_Role.PartIndex.Face] = ResourcePathHelper.RoleFace,
	[Asset_Role.PartIndex.Tail] = ResourcePathHelper.RoleTail,
	[Asset_Role.PartIndex.Eye] = ResourcePathHelper.RoleEye,
	[Asset_Role.PartIndex.Mouth] = ResourcePathHelper.RoleMouth,
	[Asset_Role.PartIndex.Mount] = ResourcePathHelper.RoleMount,
}

local LoadInterval = 0.1

local function DestroyObserver(observer)
	observer[1] = nil
	observer[2] = nil
	observer[3] = nil
	observer[4] = nil
	ReusableTable.DestroyArray(observer)
end

function AssetManager_Role.RemoveObserverPredicate(observer, tag)
	if observer[1] == tag  then
		DestroyObserver(observer)
		return true
	end
	return false
end

function AssetManager_Role:ctor(assetManager)
	self.nextLoadTag = 1

	self.partLoadingInfos = {}
	for i=1, Asset_Role.PartCount do
		self.partLoadingInfos[i] = {}
	end

	self.assetManager = assetManager

	self.nextLoadTime = 0
	self.forceLoadAll = 0
end

function AssetManager_Role:SetForceLoadAll(force)
	if force then
		self.forceLoadAll = self.forceLoadAll+1
	else
		self.forceLoadAll = self.forceLoadAll-1
	end
end

function AssetManager_Role:NewTag()
	local tag = self.nextLoadTag
	self.nextLoadTag = self.nextLoadTag+1
	return tag
end

-- complete begin
function AssetManager_Role:CreateComplete()
	local obj = GetFromRoleCompletePool(Game.GOLuaPoolManager)
	if nil ~= obj then
		-- restore obj status
		obj.layer = 0
		obj.invisible = false
		obj.shadowInvisible = false
		obj.colliderEnable = false
		obj.weaponEnable = false
		obj.mountEnable = false
		obj.hairColorIndex = -1
		obj.actionSpeed = 1
		obj.useInstanceMaterial = false
		obj:AlphaTo(1, 0)
		obj:ChangeColorTo(LuaGeometry.Const_Col_whiteClear, 0)
		return obj
	end

	return RoleComplete.Instantiate(Game.Prefab_RoleComplete)
end

function AssetManager_Role:DestroyComplete(obj)
	if nil == obj or LuaGameObject.ObjectIsNull(obj.gameObject) then
		return
	end

	if nil ~= CameraController.singletonInstance then
		CameraController.singletonInstance:SetPuppetFocus(
			obj.transform, 
			nil, 
			0)
	end

	-- put into pool
	if AddToRoleCompletePool(Game.GOLuaPoolManager, obj) then
		-- clear
		-- TODO restore status(layer)
		obj:ActionCallback()
		return
	end

	LuaGameObject.DestroyObject(obj.gameObject)
end

function AssetManager_Role:PreloadComplete(instantiateCount)
	if nil == instantiateCount or 0 >= instantiateCount then
		return
	end
	local prefab = Game.Prefab_RoleComplete
	
	local obj = nil
	for i=1, instantiateCount do
		obj = RoleComplete.Instantiate(prefab)
		if not AddToRoleCompletePool(Game.GOLuaPoolManager, obj) then
			GameObject.Destroy(obj.gameObject)
			break
		end
	end
end
-- complete end

-- part begin
function AssetManager_Role:_AddObserver_Part(part, ID, tag, callback, owner, custom)
	local partLoadingInfo = self.partLoadingInfos[part][ID]
	if nil == partLoadingInfo then
		partLoadingInfo = {
			observers = {},
			loading = false
		}
		self.partLoadingInfos[part][ID] = partLoadingInfo
	end

	local observer = ReusableTable.CreateArray()
	observer[1] = tag
	observer[2] = callback
	observer[3] = owner
	observer[4] = custom
	TableUtility.ArrayPushBack(partLoadingInfo.observers, observer)
end

function AssetManager_Role:_RemoveObserver_Part(part, ID, tag)
	local partLoadingInfo = self.partLoadingInfos[part][ID]
	if nil == partLoadingInfo then
		return
	end

	TableUtility.ArrayRemoveByPredicate(
		partLoadingInfo.observers, 
		AssetManager_Role.RemoveObserverPredicate,
		tag)
end

function AssetManager_Role:_NotifyObservers_Part(part, ID, asset)
	local partLoadingInfo = self.partLoadingInfos[part][ID]
	if nil == partLoadingInfo then
		return
	end
	local observers = partLoadingInfo.observers
	for i=1, #observers do
		local observer = observers[i]
		local obj = nil
		if nil ~= asset then
			obj = RolePart.Instantiate(asset)
		end
		observer[2](observer[3], observer[1], obj, part, ID, observer[4])
	end
end

function AssetManager_Role:_EndLoading_Part(part, ID)
	local partLoadingInfo = self.partLoadingInfos[part][ID]
	if nil == partLoadingInfo then
		return
	end
	TableUtility.ArrayClearByDeleter(
		partLoadingInfo.observers, 
		DestroyObserver)
	partLoadingInfo.loading = false
end

function AssetManager_Role:OnAssetLoaded_Part(asset, resPath, partInfo)
	local part = partInfo[1]
	local ID = partInfo[2]
	self:_NotifyObservers_Part(part, ID, asset)
	self:_EndLoading_Part(part, ID)

	ReusableTable.DestroyArray(partInfo)
	-- self.assetManager:UnloadAsset(path)
end

function AssetManager_Role:GetPartCacheCount(part, ID)
	return RolePartPoolElementCount[part](Game.GOLuaPoolManager, ID)
end

function AssetManager_Role:CreatePart(part, ID, callback, owner, custom)
	-- get from pool
	local obj = GetFromRolePartPool[part](Game.GOLuaPoolManager, ID)
	if nil ~= obj then
		obj.layer = 0
		callback(owner, nil, obj, part, ID, custom)
		return nil
	end

	local tag = self:NewTag()
	self:_AddObserver_Part(part, ID, tag, callback, owner, custom)
	return tag
end

function AssetManager_Role:CancelCreatePart(part, ID, tag)
	self:_RemoveObserver_Part(part, ID, tag)
end

function AssetManager_Role:DestroyPart(part, ID, obj)
	if nil == obj or LuaGameObject.ObjectIsNull(obj.gameObject) then
		return
	end
	-- put into pool
	if AddToRolePartPool[part](Game.GOLuaPoolManager, ID, obj) then
		obj:UseOriginMaterials()
		return
	end

	LuaGameObject.DestroyObject(obj.gameObject)
end

function AssetManager_Role:PreloadPart(part, ID, instantiateCount)
	local poolManager = Game.GOLuaPoolManager
	-- check part full
	-- if RolePartPoolKeyFull[part](poolManager) then
	-- 	return false
	-- end

	if nil == instantiateCount then
		return false
	end
	local elementCount = RolePartPoolElementCount[part](poolManager, ID)
	instantiateCount = instantiateCount-elementCount
	if 0 >= instantiateCount then
		return false
	end

	local path = ResPathHelperFuncs[part](ID)
	asset = self.assetManager:PreloadAsset(path, RolePart)
	if nil == asset then
		return false
	end

	local PoolElementFull = RolePartPoolElementFull[part]
	local AddToPool = AddToRolePartPool[part]
	local obj = nil
	for i=1, instantiateCount do
		-- check ID full
		if PoolElementFull(poolManager, ID) then
			return false
		end
		obj = RolePart.Instantiate(asset)
		if not AddToPool(poolManager, ID, obj) then
			GameObject.Destroy(obj.gameObject)
			return false
		end
	end
	return true
end
function AssetManager_Role:ClearPreloadPart(part, ID)
end
-- part end

function AssetManager_Role:Update(time, deltaTime)
	local loadAll = 0 < self.forceLoadAll
	if not loadAll then
		if self.nextLoadTime > time then
			return
		end
	end

	for part=1, #self.partLoadingInfos do
		for ID,v in pairs(self.partLoadingInfos[part]) do
			if not v.loading and 0 < #v.observers then
				v.loading = true

				local path = ResPathHelperFuncs[part](ID)
				local partInfo = ReusableTable.CreateArray()
				partInfo[1] = part
				partInfo[2] = ID
				self.assetManager:LoadAsset(
					path, 
					RolePart,
					self.OnAssetLoaded_Part, 
					self,
					partInfo)
				if not loadAll then
					self.nextLoadTime = time + LoadInterval
					return
				end
			end
		end
	end
end