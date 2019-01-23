AssetManager_Enviroment = class("AssetManager_Enviroment")

function AssetManager_Enviroment:ctor(assetManager)
	self.assetManager = assetManager

	self.skyboxMaterial = nil
	self.assetPathSkyboxCubemap = nil
	self.assetSkyboxCubemap = nil
	self.assetPathSkyboxCubemapAlpha = nil
	self.assetSkyboxCubemapAlpha = nil

	self.skyboxSun = nil
	self.assetPathSunFlare = nil
	self.assetSunFlare = nil

	self.assetPathWeather = nil
	self.objWeather = nil
end

function AssetManager_Enviroment:ClearSkyboxCubemap()
	if nil ~= self.assetPathSkyboxCubemap then
		self.assetManager:UnloadAsset(self.assetPathSkyboxCubemap)
	end
	if nil ~= self.assetPathSkyboxCubemapAlpha then
		self.assetManager:UnloadAsset(self.assetPathSkyboxCubemapAlpha)
	end
	self.assetSkyboxCubemap = nil
	self.assetSkyboxCubemapAlpha = nil

	self.skyboxMaterial = nil
	self.assetPathSkyboxCubemap = nil
	self.assetPathSkyboxCubemapAlpha = nil
end

function AssetManager_Enviroment:ClearSunFlare()
	if nil ~= self.assetPathSunFlare then
		self.assetManager:UnloadAsset(self.assetPathSunFlare)
	end
	self.assetSunFlare = nil

	self.skyboxSun = nil
	self.assetPathSunFlare = nil
end

function AssetManager_Enviroment:Clear()
	self:ClearSkyboxCubemap()
	self:ClearSunFlare()
end

function AssetManager_Enviroment:TrySetTexture()
	if nil == self.skyboxMaterial then
		return
	end
	if nil ~= self.assetSkyboxCubemap then
		if nil ~= self.assetPathSkyboxCubemapAlpha 
			and "" ~= self.assetPathSkyboxCubemapAlpha then
			-- alpha mode
			if nil == self.assetSkyboxCubemapAlpha then
				return
			end
			self.skyboxMaterial:SetTexture("_Tex", self.assetSkyboxCubemap)
			self.skyboxMaterial:SetTexture("_TexAlpha", self.assetSkyboxCubemapAlpha)
			self.skyboxMaterial:EnableKeyword("USETEXALPHA_ON")
		else
			self.skyboxMaterial:SetTexture("_Tex", self.assetSkyboxCubemap)
			self.skyboxMaterial:SetTexture("_TexAlpha", nil)
			self.skyboxMaterial:DisableKeyword("USETEXALPHA_ON")
		end
	end
end

function AssetManager_Enviroment:OnAssetLoaded_SkyboxCubemap(asset, resID, path)
	LogUtility.InfoFormat("<color=yellow>OnAssetLoaded_SkyboxCubemap: </color>{0}, {1}", 
		(nil ~= asset) and asset or "nil",
		path)
	if self.assetPathSkyboxCubemap == path then
		self.assetSkyboxCubemap = asset
		self:TrySetTexture()
	else
		self.assetManager:UnloadAsset(resID)
	end
end

function AssetManager_Enviroment:OnAssetLoaded_SkyboxCubemapAlpha(asset, resID, path)
	LogUtility.InfoFormat("<color=yellow>OnAssetLoaded_SkyboxCubemapAlpha: </color>{0}, {1}", 
		(nil ~= asset) and asset or "nil",
		path)
	if self.assetPathSkyboxCubemapAlpha == path then
		self.assetSkyboxCubemapAlpha = asset
		self:TrySetTexture()
	else
		self.assetManager:UnloadAsset(resID)
	end
end

function AssetManager_Enviroment:OnAssetLoaded_SunFlare(asset, resID, path)
	if nil ~= self.skyboxSun and self.assetPathSunFlare == path then
		self.skyboxSun.flare = asset
		self.assetSunFlare = asset
	else
		self.assetManager:UnloadAsset(resID)
	end
end

function AssetManager_Enviroment:ApplySkyboxCubemap(applyArgs)
	-- 1
	if self.skyboxMaterial == applyArgs.skyboxMaterial 
		and self.assetPathSkyboxCubemap == applyArgs.assetPathSkyboxCubemap then
		return
	end

	-- 2
	if nil == applyArgs.skyboxMaterial 
		or nil == applyArgs.assetPathSkyboxCubemap then
		self:ClearSkyboxCubemap()
		return
	end

	-- 3
	self.skyboxMaterial = applyArgs.skyboxMaterial

	-- 4
	local oldPath = self.assetPathSkyboxCubemap

	if oldPath ~= applyArgs.assetPathSkyboxCubemap then
		if nil ~= self.assetSkyboxCubemap then
			self.assetManager:UnloadAsset(oldPath)
			self.assetSkyboxCubemap = nil
		end
	end

	local oldAlphaPath = self.assetPathSkyboxCubemapAlpha
	if oldAlphaPath ~= applyArgs.assetPathSkyboxCubemapAlpha then
		if nil ~= self.assetSkyboxCubemapAlpha then
			self.assetManager:UnloadAsset(oldAlphaPath)
			self.assetSkyboxCubemapAlpha = nil
		end
	end

	self.assetPathSkyboxCubemap = applyArgs.assetPathSkyboxCubemap
	self.assetPathSkyboxCubemapAlpha = applyArgs.assetPathSkyboxCubemapAlpha

	if nil ~= self.assetSkyboxCubemap then
		-- TODO try set texture
		self:TrySetTexture()
	elseif nil ~= self.assetPathSkyboxCubemap 
		and "" ~= self.assetPathSkyboxCubemap then
		self.assetManager:LoadAsset(
			self.assetPathSkyboxCubemap, 
			Cubemap, 
			self.OnAssetLoaded_SkyboxCubemap, 
			self, 
			self.assetPathSkyboxCubemap)
	end

	if nil == self.assetSkyboxCubemapAlpha 
		and nil ~= self.assetPathSkyboxCubemapAlpha 
		and "" ~= self.assetPathSkyboxCubemapAlpha then
		self.assetManager:LoadAsset(
			self.assetPathSkyboxCubemapAlpha, 
			Cubemap, 
			self.OnAssetLoaded_SkyboxCubemapAlpha, 
			self, 
			self.assetPathSkyboxCubemapAlpha)
	end
end

function AssetManager_Enviroment:ApplySunFlare(applyArgs)
	-- 1
	if self.skyboxSun == applyArgs.skyboxSun 
		and self.assetPathSunFlare == applyArgs.assetPathSunFlare then
		return
	end

	-- 2
	if nil == applyArgs.skyboxSun 
		or nil == applyArgs.assetPathSunFlare then
		self:ClearSunFlare()
		return
	end

	-- 3
	self.skyboxSun = applyArgs.skyboxSun

	-- 4
	if nil ~= self.assetSunFlare then
		if self.assetPathSunFlare == applyArgs.assetPathSunFlare then
			self.skyboxSun.flare = self.assetSunFlare
			return
		end

		self.assetManager:UnloadAsset(self.assetPathSunFlare)
		self.assetSunFlare = nil
	end
	self.assetPathSunFlare = applyArgs.assetPathSunFlare

	-- 5
	self.assetManager:LoadAsset(
		self.assetPathSunFlare, 
		Flare, 
		self.OnAssetLoaded_SunFlare, 
		self, 
		self.assetPathSunFlare)
end

function AssetManager_Enviroment:ApplyAssets(applyArgs)
	-- RenderSettings.customReflection = applyArgs.assetPathCustomReflection
	self:ApplySkyboxCubemap(applyArgs)
	self:ApplySunFlare(applyArgs)
end

function AssetManager_Enviroment:Update(time, deltaTime)
end

