
autoImport ("Asset_Effect")

AssetManager_Effect = class("AssetManager_Effect")

local EffectLifeLimit = 20

local GameFromPool = GOLuaPoolManager.GetFromEffectPool
local AddToPool = GOLuaPoolManager.AddToEffectPool

local function DestroyObserver(observer)
	observer[1] = nil
	observer[2] = nil
	observer[3] = nil
	observer[4] = nil
	ReusableTable.DestroyArray(observer)
end

function AssetManager_Effect.RemoveObserverPredicate(observer, tag)
	if observer[1] == tag  then
		DestroyObserver(observer)
		return true
	end
	return false
end

function AssetManager_Effect:ctor(assetManager)
	self.nextLoadTag = 1
	self.loadingInfos = {}
	self.autoDestroyEffects = {}
	self.assetManager = assetManager
end

function AssetManager_Effect:AddAutoDestroyEffect(effect)
	Game.EffectManager:RegisterEffect(effect,true)
	TableUtility.ArrayPushBack(self.autoDestroyEffects, effect)
end

function AssetManager_Effect:NewTag()
	local tag = self.nextLoadTag
	self.nextLoadTag = self.nextLoadTag+1
	return tag
end

-- part begin
function AssetManager_Effect:_AddObserver(path, tag, callback, owner, custom)
	local loadingInfo = self.loadingInfos[path]
	if nil == loadingInfo then
		loadingInfo = {
			observers = {},
			loading = false
		}
		self.loadingInfos[path] = loadingInfo
	end

	local observer = ReusableTable.CreateArray()
	observer[1] = tag
	observer[2] = callback
	observer[3] = owner
	observer[4] = custom
	TableUtility.ArrayPushBack(loadingInfo.observers, observer)
end

function AssetManager_Effect:_RemoveObserver(path, tag)
	local loadingInfo = self.loadingInfos[path]
	if nil == loadingInfo then
		return
	end

	TableUtility.ArrayRemoveByPredicate(
		loadingInfo.observers, 
		AssetManager_Effect.RemoveObserverPredicate,
		tag)
end

function AssetManager_Effect:_NotifyObservers(path, asset)
	local loadingInfo = self.loadingInfos[path]
	if nil == loadingInfo then
		return
	end
	local observers = loadingInfo.observers
	for i=1, #observers do
		local observer = observers[i]
		local obj = nil
		if nil ~= asset then
			obj = EffectHandle.Instantiate(asset)
		end
		observer[2](observer[3], observer[1], obj, path, observer[4])
	end
end

function AssetManager_Effect:_EndLoading(path)
	local loadingInfo = self.loadingInfos[path]
	if nil == loadingInfo then
		return
	end
	TableUtility.ArrayClearByDeleter(
		loadingInfo.observers, 
		DestroyObserver)
	loadingInfo.loading = false
end

function AssetManager_Effect:OnAssetLoaded(asset, resPath, path)
	self:_NotifyObservers(path, asset)
	self:_EndLoading(path)
	-- self.assetManager:UnloadAsset(resID)
end

function AssetManager_Effect:CreateEffect(path, parent, callback, owner, custom)
	if nil == path then
		callback(owner, nil, nil, path, custom)
		return nil
	end

	-- get from pool
	local obj = GameFromPool(Game.GOLuaPoolManager, path, parent)
	if nil ~= obj then
		-- restore status
		callback(owner, nil, obj, path, custom)
		-- obj:Restore()
		return nil
	end

	local tag = self:NewTag()
	self:_AddObserver(path, tag, callback, owner, custom)
	return tag
end

function AssetManager_Effect:CancelCreateEffect(path, tag)
	self:_RemoveObserver(path, tag)
end

function AssetManager_Effect:DestroyEffect(path, obj)
	if nil == obj then
		return
	end
	-- put into pool
	if AddToPool(Game.GOLuaPoolManager, path, obj) then
		return
	end

	if not LuaGameObject.ObjectIsNull(obj) 
		and not LuaGameObject.ObjectIsNull(obj.gameObject) then
		GameObject.Destroy(obj.gameObject)
	end
end
-- part end

function AssetManager_Effect:Update(time, deltaTime)
	-- load all effect
	for path,v in pairs(self.loadingInfos) do
		if not v.loading and 0 < #v.observers then
			v.loading = true
			self.assetManager:LoadAsset(
				ResourcePathHelper.Effect(path), 
				EffectHandle,
				self.OnAssetLoaded, 
				self,
				path)
		end
	end

	-- auto destroy
	if 0 < #self.autoDestroyEffects then
		local effects = self.autoDestroyEffects
		for i=#effects, 1, -1 do
			local effect = effects[i]
			local lifeElapsed = effect:UpdateLifeTime(time, deltaTime)
			if effect:Alive() then
				if EffectLifeLimit < lifeElapsed or not effect:IsRunning() then
					effect:Destroy()
					table.remove(effects, i)
				end
			else
				table.remove(effects, i)
			end
		end
	end
end