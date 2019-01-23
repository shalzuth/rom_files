
autoImport ("EnviromentInfo")
autoImport ("EnviromentAnimation_Base")
autoImport ("EnviromentAnimation_Weather")

EnviromentManager = class("EnviromentManager")

local NumberAlmostEqualWithDiff = NumberUtility.AlmostEqualWithDiff

local UpdateInterval = 0.1

local function GetChangedNumberWithDiff(prev, new, diff)
	if nil ~= prev and NumberAlmostEqualWithDiff(prev, new, diff) then
		return nil
	end
	return new
end

function EnviromentManager.ApplyLighting(info, applyArgs, prevInfo)
	if nil ~= info and info.enable then 
		RenderSettings.ambientMode = info.ambientMode
		if AmbientMode.Skybox == info.ambientMode 
			or AmbientMode.Flat == info.ambientMode then
			RenderSettings.ambientLight = info.ambientLight
		elseif AmbientMode.Trilight == info.ambientMode then
			RenderSettings.ambientSkyColor = info.ambientSkyColor
			RenderSettings.ambientEquatorColor = info.ambientEquatorColor
			RenderSettings.ambientGroundColor = info.ambientGroundColor
		end
		
		RenderSettings.ambientIntensity = info.ambientIntensity
		RenderSettings.defaultReflectionMode = info.defaultReflectionMode
		if DefaultReflectionMode.Custom == info.defaultReflectionMode then
			applyArgs.assetPathCustomRelection = info.customReflection
		end
		RenderSettings.defaultReflectionResolution = info.defaultReflectionResolution
		RenderSettings.reflectionBounces = info.reflectionBounces
		RenderSettings.reflectionIntensity = info.reflectionIntensity
	else
		RenderSettings.ambientMode = AmbientMode.Flat
		RenderSettings.skybox = nil
		RenderSettings.ambientLight = LuaGeometry.Const_Col_white
		RenderSettings.ambientIntensity = 1

		RenderSettings.defaultReflectionMode = DefaultReflectionMode.Skybox
		RenderSettings.defaultReflectionResolution = 128
		RenderSettings.reflectionBounces = 0
		RenderSettings.reflectionIntensity = 0
	end
end

function EnviromentManager.ApplyFog(info, applyArgs, prevInfo)
	if nil ~= info and info.enable then
		RenderSettings.fog=info.fog
		RenderSettings.fogColor=info.fogColor
		RenderSettings.fogMode=info.fogMode
		if FogMode.Linear == info.fogMode then
			RenderSettings.fogStartDistance=info.fogStartDistance
			RenderSettings.fogEndDistance=info.fogEndDistance
		else
			RenderSettings.fogDensity=info.fogDensity
		end
	else
		RenderSettings.fog = false
	end
end

function EnviromentManager.ApplyFlare(info, applyArgs, prevInfo)
	if nil ~= info and info.enable then
		local n = GetChangedNumberWithDiff(prevInfo.flareFadeSpeed, info.flareFadeSpeed, 1)
		if nil ~= n then
			RenderSettings.flareFadeSpeed = n
			prevInfo.flareFadeSpeed = n
		end
		n = GetChangedNumberWithDiff(prevInfo.flareStrength, info.flareStrength, 0.1)
		if nil ~= n then
			RenderSettings.flareStrength = n
			prevInfo.flareStrength = n
		end
	else
		RenderSettings.flareFadeSpeed = 0
		RenderSettings.flareStrength = 0
		-- prev
		prevInfo.flareFadeSpeed = nil
		prevInfo.flareStrength = nil
	end
end

function EnviromentManager.ApplySkybox(info, applyArgs, prevInfo)
	local skyboxCamera = applyArgs.skyboxCamera
	local skyboxMaterial = applyArgs.skyboxMaterial
	if nil ~= info and info.enable and nil ~= skyboxCamera then
		if SkyboxType.SolidColor == info.type or nil == skyboxMaterial then
			skyboxCamera.clearFlags = CameraClearFlags.Color--SolidColor
			skyboxCamera.backgroundColor = info.skyTint
			EnviromentManager.ClearSkybox_Sun(info, applyArgs, prevInfo)
		else
			local shaderManager = Game.ShaderManager

			skyboxCamera.clearFlags = CameraClearFlags.Skybox

			if SkyboxType.CubemapOnly == info.type then
				if shaderManager.skyboxCubemap ~= skyboxMaterial.shader then
					skyboxMaterial.shader = shaderManager.skyboxCubemap
				end
				applyArgs.assetPathSkyboxCubemap = info.cubemap
				applyArgs.assetPathSkyboxCubemapAlpha = info.cubemapAlpha
				skyboxMaterial:SetFloat("_Rotation", info.cubemapRotation)
				skyboxMaterial:SetColor("_Tint", info.cubemapTint)
				skyboxMaterial:SetFloat("_Exposure", info.exposure)
			elseif SkyboxType.Procedural == info.type then
				if shaderManager.skyboxProcedural ~= skyboxMaterial.shader then
					skyboxMaterial.shader = shaderManager.skyboxProcedural
				end
				skyboxMaterial:SetFloat("_SunSize", info.sunSize)
				skyboxMaterial:SetFloat("_AtmosphereThickness", info.atmoshpereThickness)
				skyboxMaterial:SetColor("_SkyTint", info.skyTint)
				skyboxMaterial:SetColor("_GroundColor", info.ground)
				skyboxMaterial:SetFloat("_Exposure", info.exposure)
			elseif SkyboxType.ProceduralEx == info.type then
				if shaderManager.skyboxProceduralEx ~= skyboxMaterial.shader then
					skyboxMaterial.shader = shaderManager.skyboxProceduralEx
				end
				
				-- Procedural
				skyboxMaterial:SetFloat("_SunSize", info.sunSize)
				skyboxMaterial:SetFloat("_AtmosphereThickness", info.atmoshpereThickness)
				skyboxMaterial:SetColor("_SkyTint", info.skyTint)
				skyboxMaterial:SetColor("_GroundColor", info.ground)
				skyboxMaterial:SetFloat("_Exposure", info.exposure)

				-- Cubemap
				applyArgs.assetPathSkyboxCubemap = info.cubemap
				applyArgs.assetPathSkyboxCubemapAlpha = info.cubemapAlpha
				skyboxMaterial:SetFloat("_Rotation", info.cubemapRotation)
				skyboxMaterial:SetColor("_TexTint", info.cubemapTint)
			end

			EnviromentManager.ApplySkybox_Sun(info, applyArgs, prevInfo)
		end
	else
		if nil ~= skyboxCamera then
			skyboxCamera.clearFlags = CameraClearFlags.Color--SolidColor
			skyboxCamera.backgroundColor = LuaGeometry.Const_Col_black
		end
		EnviromentManager.ClearSkybox_Sun(info, applyArgs, prevInfo)
	end
end

function EnviromentManager.ApplySkybox_Sun(info, applyArgs, prevInfo)
	local skyboxSun = applyArgs.skyboxSun
	if nil ~= info and info.enable and nil ~= skyboxSun then
		if nil ~= info.sunSize and 0 < info.sunSize then
			skyboxSun.color = info.sunColor
			skyboxSun.intensity = info.sunIntensity
			skyboxSun.bounceIntensity = info.sunBounceIntensity
			skyboxSun.transform.eulerAngles = info.sunRotation
			applyArgs.assetPathSunFlare = info.sunFlare
		end
	else
		EnviromentManager.ClearSkybox_Sun(info, applyArgs)
	end
end

function EnviromentManager.ClearSkybox_Sun(info, applyArgs, prevInfo)
	local skyboxSun = applyArgs.skyboxSun
	if nil ~= skyboxSun then
		skyboxSun.color = LuaGeometry.Const_Col_white
		skyboxSun.intensity = 0
		skyboxSun.bounceIntensity = 0
	end
end

function EnviromentManager.ApplySceneObject(info, applyArgs, prevInfo)
	local sceneObjectMaterials = applyArgs.sceneObjectMaterials
	if nil ~= info and info.enable and nil ~= sceneObjectMaterials and 0 < #sceneObjectMaterials then
		for i=1, #sceneObjectMaterials do
			local mat = sceneObjectMaterials[i]
			mat:SetColor("_LightColor", info.lightColor)
			mat:SetFloat("_LightScale", info.lightScale)
		end
	else
		if nil ~= sceneObjectMaterials and 0 < #sceneObjectMaterials then
			for i=1, #sceneObjectMaterials do
				local mat = sceneObjectMaterials[i]
				mat:SetColor("_LightColor", LuaGeometry.Const_Col_white)
				mat:SetFloat("_LightScale", 1)
			end
		end
	end
end

function EnviromentManager.ApplySetting(applyArgs)
	local setting = applyArgs.setting
	local prevSetting = applyArgs.prevSetting
	if nil ~= setting then
		EnviromentManager.ApplyLighting(setting.lighting, applyArgs, prevSetting.lighting)
		EnviromentManager.ApplyFog(setting.fog, applyArgs, prevSetting.fog)
		EnviromentManager.ApplyFlare(setting.flare, applyArgs, prevSetting.flare)
		EnviromentManager.ApplySkybox(setting.skybox, applyArgs, prevSetting.skybox)
		EnviromentManager.ApplySceneObject(setting.sceneObject, applyArgs, prevSetting.sceneObject)
	end
end

function EnviromentManager:ctor()
	self.prevSetting = {
		lighting = {
		},
		fog = {
		},
		flare = {
		},
		skybox = {
		},
		sceneObject = {
		}
	}
	self.setting = {
		lighting = {
			enable = false,
			ambientMode = AmbientMode.Flat,
			ambientLight = LuaColor.white,
			ambientSkyColor = LuaColor.white,
			ambientEquatorColor = LuaColor.white,
			ambientGroundColo = LuaColor.white,
			ambientIntensity = 1,
			defaultReflectionMode = DefaultReflectionMode.Skybox,
			customReflection = nil,
			defaultReflectionResolution = 128,
			reflectionBounces = 0,
			reflectionIntensity = 0,
		},
		fog = {
			enable = false,
			fog = false,
			fogColor = LuaColor.white,
			fogMode = FogMode.Linear,
			fogStartDistance = 40,
			fogEndDistance = 110,
			fogDensity = 0,
		},
		flare = {
			enable = false,
			flareFadeSpeed = 0,
			flareStrength = 0,
		},
		skybox = {
			enable = false,
			type=SkyboxType.SolidColor,
			sunColor=LuaColor.white,
			sunIntensity=1,
			sunBounceIntensity=1,
			sunRotation=LuaVector3.zero,
			sunSize=0,
			atmoshpereThickness=0,
			skyTint=LuaColor.white,
			ground=LuaColor.white,
			exposure=0,
			cubemap=nil,
			cubemapAlpha=nil,
			cubemapRotation=0,
			cubemapTint=LuaColor.clear,
			exposure=0
		},
		sceneObject = {
			enable = false,
			lightColor = LuaColor.white,
			lightScale = 1,
		}
	}
	self.applyArgs = {}
	self:_Reset()
	self.animationEnable = true
end

function EnviromentManager:_Reset()
	self.baseID = nil
	self.skyboxCamera = nil
	self.skyboxMaterial = nil
	self.skyboxSun = nil
	self.sceneObjectMaterials = nil

	self.animationBase = nil
	self.animationWeather = nil

	self.weatherID = nil

	self.running = false
	self.nextUpdateTime = 0
	self.eatenDeltaTime = 0

	for k,v in pairs(self.prevSetting) do
		TableUtility.TableClear(v)
	end
end

function EnviromentManager:_Apply()
	local applyArgs = self.applyArgs
	applyArgs.setting = self.setting
	applyArgs.prevSetting = self.prevSetting
	applyArgs.skyboxCamera = self.skyboxCamera
	applyArgs.skyboxMaterial = self.skyboxMaterial
	applyArgs.skyboxSun = self.skyboxSun
	applyArgs.sceneObjectMaterials = self.sceneObjectMaterials

	applyArgs.assetPathCustomRelection = nil
	applyArgs.assetPathSkyboxCubemap = nil
	applyArgs.assetPathSkyboxCubemapAlpha = nil
	applyArgs.assetPathSunFlare = nil

	EnviromentManager.ApplySetting(applyArgs)
	Game.AssetManager_Enviroment:ApplyAssets(applyArgs)
end

function EnviromentManager:SetAnimationEnable(enable)
	if self.animationEnable == enable then
		return
	end
	self.animationEnable = enable
	if not enable then
		if nil ~= self.animationBase then
			self.animationBase:EndAnimation()
		end
		if nil ~= self.animationWeather then
			self.animationWeather:End()
		end
	end
end

function EnviromentManager:SetSkyboxCamera(camera, material)
	self.skyboxCamera = camera
	self.skyboxMaterial = material
end

function EnviromentManager:SetSkyboxSun(sun)
	self.skyboxSun = sun
end

function EnviromentManager:SetSceneObjectMaterials(materials)
	self.sceneObjectMaterials = materials
end

function EnviromentManager:GetBaseID()
	return self.baseID
end

function EnviromentManager:SetBaseInfo(baseID, duration)
	if nil ~= self.baseID and self.baseID == baseID then
		return
	end
	
	if not self.animationEnable or nil == duration then
		duration = 0
	end
	local envFile = "Enviroment_"..baseID
	if(not ResourceID.CheckFileIsRecorded(envFile)) then
		errorLog("EnviromentManager:SetBaseInfo set invalid Enviroment Lua file : "..envFile)
		return
	end
	local info = autoImport(envFile)

	-- set
	self.baseID = baseID
	if nil == self.animationBase then
		self.animationBase = EnviromentAnimation_Base.new()
	end
	self.animationBase:Reset(info, duration)
	self.animationBase:Start()
end

function EnviromentManager:SetWeatherInfo(r, g, b, a, scale)
	if not self.animationEnable then
		return
	end
	if nil == self.animationWeather then
		self.animationWeather = EnviromentAnimation_Weather.new()
	end
	self.animationWeather:Reset(r, g, b, a, scale)
	self.animationWeather:Start()
end

function EnviromentManager:SetWeatherAnimationEnable(enable)
	if self.animationEnable and nil ~= self.animationWeather then
		self.animationWeather:End()
	end
end

function EnviromentManager:Launch()
	if self.running then
		return
	end
	self.running = true
end

function EnviromentManager:Shutdown()
	if not self.running then
		return
	end
	self.running = false

	-- end animtions
	if nil ~= self.animationBase then
		self.animationBase:End()
		self.animationBase:Clear()
	end
	if nil ~= self.animationWeather then
		self.animationWeather:End()
		self.animationWeather:Clear()
	end

	-- clear assets
	Game.AssetManager_Enviroment:Clear()

	self:_Reset()
end

function EnviromentManager:Update(time, deltaTime)
	if not self.running then
		return
	end

	if time < self.nextUpdateTime then
		self.eatenDeltaTime = self.eatenDeltaTime + deltaTime
		return
	end
	deltaTime = deltaTime + self.eatenDeltaTime
	self.eatenDeltaTime = 0
	self.nextUpdateTime = time + UpdateInterval

	local settingUpdated = false
	if nil ~= self.animationBase and self.animationBase.running then
		self.animationBase:Update(time, deltaTime, self.setting)
		settingUpdated = true
	end
	if nil ~= self.animationWeather and self.animationWeather.running then
		self.animationWeather:Update(time, deltaTime, self.setting)
		settingUpdated = true
	end

	if settingUpdated then
		self:_Apply()
	end
end

