AssetManager_SceneDropItem = class("AssetManager_SceneDropItem")

local GetFromSceneDropPool = GOLuaPoolManager.GetFromSceneDropPool
local AddToSceneDropPool = GOLuaPoolManager.AddToSceneDropPool
local IsNull = Slua.IsNull

function AssetManager_SceneDropItem:ctor(assetManager)
	self.goLuaPoolManager = Game.GOLuaPoolManager
	self.assetManager = assetManager
end

function AssetManager_SceneDropItem:GetGoLuaPoolManager()
	if(self.goLuaPoolManager==nil) then
		self.goLuaPoolManager = Game.GOLuaPoolManager
	end
	return self.goLuaPoolManager
end

function AssetManager_SceneDropItem:CreateSceneDrop(key,parent)
	local sceneDrop = GetFromSceneDropPool(self:GetGoLuaPoolManager(),key,parent)
	if(sceneDrop==nil) then
		local asset = self.assetManager:Load(ResourcePathHelper.Item(key))
		if(asset~=nil) then
			sceneDrop = GameObject.Instantiate(asset);
		end
	end
	return sceneDrop
end

function AssetManager_SceneDropItem:DestroySceneDrop(key,gameobject)
	if nil == gameobject or IsNull(gameobject) then
		return
	end
	if(AddToSceneDropPool(self:GetGoLuaPoolManager(),key,gameobject)) then
		return
	end
	LuaGameObject.DestroyObject(gameobject)
end

-- function AssetManager_SceneDropItem:LoadAsset(path, type, callback, owner, custom)
-- 	self.assetManager:LoadAsset(path,type,callback,owner,custom)
-- end

-- function AssetManager_SceneDropItem:UnLoadAsset(path)
-- 	self.assetManager:UnloadAsset(path)
-- end

-- function AssetManager_SceneDropItem:_LoadAndCreate(path,parent)
-- 	local asset = self.assetManager.resManager:SLoad(path)
-- 	if(asset~=nil) then
-- 		local go = GameObject.Instantiate(asset)
-- 		LuaGameObject.TrimNameClone(go)

-- 		if(not Slua.IsNull(parent) and not Slua.IsNull(go))then
-- 			go.transform:SetParent(parent.transform, false);
-- 		end
-- 		return go
-- 	end
-- 	return nil
-- end

-- function AssetManager_UI:CreateAsset(path,parent)
-- 	local go = GetFromUIPool(Game.GOLuaPoolManager,path,parent)
-- 	if(go==nil) then
-- 		return self:_LoadAndCreate(path,parent)
-- 	end
-- 	return go
-- end