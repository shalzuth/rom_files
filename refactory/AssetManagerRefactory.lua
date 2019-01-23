
autoImport ("AssetManager_Effect")
autoImport ("AssetManager_Enviroment")
autoImport ("AssetManager_Role")
autoImport ("AssetManager_UI")
autoImport ("AssetManager_SceneDropItem")

AssetManagerRefactory = class("AssetManagerRefactory")

function AssetManagerRefactory.OnAssetLoaded(asset, args)
	args[2](args[3], asset, args[1], args[4])
	args[1] = nil
	args[2] = nil
	args[3] = nil
	args[4] = nil
	ReusableTable.DestroyArray(args)
end

function AssetManagerRefactory:ctor()
	self.resManager = ResourceManager.Instance -- c#
	self.amEffect = AssetManager_Effect.new(self)
	self.amEnviroment = AssetManager_Enviroment.new(self)
	self.amRole = AssetManager_Role.new(self)
	self.amUI = AssetManager_UI.new(self)
	self.amSceneDrop = AssetManager_SceneDropItem.new(self)

	Game.AssetManager_Effect = self.amEffect
	Game.AssetManager_Enviroment = self.amEnviroment
	Game.AssetManager_Role = self.amRole
	Game.AssetManager_UI = self.amUI
	Game.AssetManager_SceneDropItem = self.amSceneDrop
end

function AssetManagerRefactory:LoadAsset(path, type, callback, owner, custom)
	-- NOTE. do not load same path more than 1 time

	-- local args = ReusableTable.CreateArray()
	-- args[1] = path
	-- args[2] = callback
	-- args[3] = owner
	-- args[4] = custom
--	redlog('LoadAsset', path, type)
	local asset = self.resManager:SLoadByType(path, type)
--	redlog('asset', asset)
	callback(owner, asset, path, custom)
end

function AssetManagerRefactory:Load(path)
--	redlog('SLoad', path)
	return self.resManager:SLoad(path)
end

function AssetManagerRefactory:LoadByType(path, type)
--	redlog('SLoadByType', path, type)
	return self.resManager:SLoadByType(path, type)
end

function AssetManagerRefactory:PreloadAsset(path, type)
--	redlog('SLoadByType', path, type)
	return self.resManager:SLoadByType(path, type)
end

function AssetManagerRefactory:UnloadAsset(path)
	self.resManager:SUnLoad(path, false)
end

function AssetManagerRefactory:Update(time, deltaTime)
	self.amEffect:Update(time, deltaTime)
	self.amEnviroment:Update(time, deltaTime)
	self.amRole:Update(time, deltaTime)
end