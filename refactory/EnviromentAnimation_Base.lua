EnviromentAnimation_Base = class("EnviromentAnimation_Base")

local function CopyLighting(cur, info)
	info.ambientMode = cur.ambientMode
	info.ambientLight = LuaColorUtility.TryAsign(info.ambientLight, cur.ambientLight)
	info.ambientSkyColor = LuaColorUtility.TryAsign(info.ambientSkyColor, cur.ambientSkyColor)
	info.ambientEquatorColor = LuaColorUtility.TryAsign(info.ambientEquatorColor, cur.ambientEquatorColor)
	info.ambientGroundColor = LuaColorUtility.TryAsign(info.ambientGroundColor, cur.ambientGroundColor)
	info.ambientIntensity = cur.ambientIntensity
	info.defaultReflectionMode = cur.defaultReflectionMode
	info.customReflection = cur.customReflection or info.customReflection
	info.defaultReflectionResolution = cur.defaultReflectionResolution
	info.reflectionBounces = cur.reflectionBounces
	info.reflectionIntensity = cur.reflectionIntensity
end

local function LerpLighting(curFrom, curTo, progress, info)
	info.ambientMode = curTo.ambientMode

	info.ambientLight = LuaColorUtility.TryLerp(
		info.ambientLight, 
		curFrom.ambientLight, 
		curTo.ambientLight, 
		progress)
	
	info.ambientSkyColor = LuaColorUtility.TryLerp(
		info.ambientSkyColor, 
		curFrom.ambientSkyColor, 
		curTo.ambientSkyColor, 
		progress)

	info.ambientEquatorColor = LuaColorUtility.TryLerp(
		info.ambientEquatorColor, 
		curFrom.ambientEquatorColor, 
		curTo.ambientEquatorColor, 
		progress)

	info.ambientGroundColor = LuaColorUtility.TryLerp(
		info.ambientGroundColor, 
		curFrom.ambientGroundColor, 
		curTo.ambientGroundColor, 
		progress)

	info.ambientIntensity = NumberUtility.TryLerpUnclamped(
		curFrom.ambientIntensity, 
		curTo.ambientIntensity, 
		progress)

	info.defaultReflectionMode = curTo.defaultReflectionMode

	info.customReflection = curTo.customReflection or info.customReflection
	info.defaultReflectionResolution = curTo.defaultReflectionResolution

	info.reflectionBounces = NumberUtility.TryLerpUnclamped(
		curFrom.reflectionBounces, 
		curTo.reflectionBounces, 
		progress)

	info.reflectionIntensity = NumberUtility.TryLerpUnclamped(
		curFrom.reflectionIntensity, 
		curTo.reflectionIntensity, 
		progress)
end

local function CopyFog(cur, info)
	info.fog = cur.fog
	info.fogColor = LuaColorUtility.TryAsign(info.fogColor, cur.fogColor)
	info.fogMode = cur.fogMode or info.fogMode
	info.fogStartDistance = cur.fogStartDistance or info.fogStartDistance
	info.fogEndDistance = cur.fogEndDistance or info.fogEndDistance
	info.fogDensity = cur.fogDensity or info.fogDensity
end

local function LerpFog(curFrom, curTo, progress, info)
	info.fog = curTo.fog
	info.fogColor = LuaColorUtility.TryLerp(
		info.fogColor, 
		curFrom.fogColor, 
		curTo.fogColor, 
		progress)

	info.fogMode = curTo.fogMode or info.fogMode

	info.fogStartDistance = NumberUtility.TryLerpUnclamped(
		curFrom.fogStartDistance, 
		curTo.fogStartDistance, 
		progress) or info.fogStartDistance
	info.fogEndDistance = NumberUtility.TryLerpUnclamped(
		curFrom.fogEndDistance, 
		curTo.fogEndDistance, 
		progress) or info.fogEndDistance
	info.fogDensity = NumberUtility.TryLerpUnclamped(
		curFrom.fogDensity, 
		curTo.fogDensity, 
		progress) or info.fogDensity
end

local function CopyFlare(cur, info)
	info.flareFadeSpeed = cur.flareFadeSpeed
	info.flareStrength = cur.flareStrength
end

local function LerpFlare(curFrom, curTo, progress, info)
	info.flareFadeSpeed = NumberUtility.TryLerpUnclamped(
		curFrom.flareFadeSpeed, 
		curTo.flareFadeSpeed, 
		progress)

	info.flareStrength = NumberUtility.TryLerpUnclamped(
		curFrom.flareStrength, 
		curTo.flareStrength, 
		progress)
end

local function CopySkybox(cur, info)
	info.type = cur.type
	info.sunColor = LuaColorUtility.TryAsign(info.sunColor, cur.sunColor)
	info.sunIntensity = cur.sunIntensity or 0
	info.sunBounceIntensity = cur.sunBounceIntensity or 0
	info.sunRotation = VectorUtility.TryAsign_3(info.sunRotation, cur.sunRotation)
	info.sunSize = cur.sunSize or 0
	info.sunFlare = cur.sunFlare
	info.atmoshpereThickness = cur.atmoshpereThickness or 0
	info.skyTint = LuaColorUtility.TryAsign(info.skyTint, cur.skyTint)
	info.ground = LuaColorUtility.TryAsign(info.ground, cur.ground)
	info.exposure = cur.exposure or 0
	info.cubemap = cur.cubemap
	info.cubemapAlpha = cur.cubemapAlpha
	info.cubemapRotation = cur.cubemapRotation or 0
	info.cubemapTint = LuaColorUtility.TryAsign(info.cubemapTint, cur.cubemapTint)
end

local function LerpSkybox(curFrom, curTo, progress, info)
	info.type = curTo.type
	info.sunColor = LuaColorUtility.TryLerp(
		info.sunColor, 
		curFrom.sunColor, 
		curTo.sunColor, 
		progress)
	info.sunIntensity = NumberUtility.TryLerpUnclamped(
		curFrom.sunIntensity, 
		curTo.sunIntensity, 
		progress) or info.sunIntensity
	info.sunBounceIntensity = NumberUtility.TryLerpUnclamped(
		curFrom.sunBounceIntensity, 
		curTo.sunBounceIntensity, 
		progress) or info.sunBounceIntensity
	info.sunRotation = VectorUtility.TryLerpAngleUnclamped_3(
		info.sunRotation,
		curFrom.sunRotation, 
		curTo.sunRotation, 
		progress)
	info.sunSize = NumberUtility.TryLerpUnclamped(
		curFrom.sunSize, 
		curTo.sunSize, 
		progress) or info.sunSize
	info.atmoshpereThickness = NumberUtility.TryLerpUnclamped(
		curFrom.atmoshpereThickness, 
		curTo.atmoshpereThickness, 
		progress) or info.atmoshpereThickness
	info.skyTint = LuaColorUtility.TryLerp(
		info.skyTint, 
		curFrom.skyTint, 
		curTo.skyTint, 
		progress)
	info.ground = LuaColorUtility.TryLerp(
		info.ground, 
		curFrom.ground, 
		curTo.ground, 
		progress)
	info.exposure = NumberUtility.TryLerpUnclamped(
		curFrom.exposure, 
		curTo.exposure, 
		progress) or info.exposure

	if 0.5 > progress then
		info.sunFlare = curFrom.sunFlare or info.sunFlare
		info.cubemap = curFrom.cubemap or info.cubemap
		info.cubemapAlpha = curFrom.cubemapAlpha or info.cubemapAlpha
		info.cubemapTint = LuaColorUtility.TryLerp(
			info.cubemapTint, 
			curFrom.cubemapTint, 
			LuaGeometry.Const_Col_whiteClear, 
			progress*2)
	else
		info.sunFlare = curTo.sunFlare or info.sunFlare
		info.cubemap = curTo.cubemap or info.cubemap
		info.cubemapAlpha = curTo.cubemapAlpha or info.cubemapAlpha
		info.cubemapTint = LuaColorUtility.TryLerp(
			info.cubemapTint, 
			LuaGeometry.Const_Col_whiteClear, 
			curTo.cubemapTint, 
		(progress-0.5)*2)
	end

	info.cubemapRotation = NumberUtility.LerpAngleUnclamped(
		curFrom.cubemapRotation, 
		curTo.cubemapRotation, 
		progress) or info.cubemapRotation
end

local function CopySceneObject(cur, info)
	info.lightColor = LuaColorUtility.TryAsign(info.lightColor, cur.lightColor)
	info.lightScale = cur.lightScale
end

local function LerpSceneObject(curFrom, curTo, progress, info)
	info.lightColor = LuaColorUtility.TryLerp(
		info.lightColor, 
		curFrom.lightColor, 
		curTo.lightColor, 
		progress)
	info.lightScale = NumberUtility.TryLerpUnclamped(
		curFrom.lightScale, 
		curTo.lightScale, 
		progress)
end

local function CopySetting(from, setting)
	local cur = from.lighting
	local info = setting.lighting
	if nil ~= cur then
		info.enable = true
		CopyLighting(cur, info)
	else
		info.enable = false
	end

	cur = from.fog
	info = setting.fog
	if nil ~= cur then
		info.enable = true
		CopyFog(cur, info)
	else
		info.enable = false
	end

	cur = from.flare
	info = setting.flare
	if nil ~= cur then
		info.enable = true
		CopyFlare(cur, info)
	else
		info.enable = false
	end

	cur = from.skybox
	info = setting.skybox
	if nil ~= cur then
		info.enable = true
		CopySkybox(cur, info)
	else
		info.enable = false
	end

	cur = from.sceneObject
	info = setting.sceneObject
	if nil ~= cur then
		info.enable = true
		CopySceneObject(cur, info)
	else
		info.enable = false
	end
end

local function LerpSetting(from, to, progress, setting)
	local curFrom = from.lighting
	local curTo = to.lighting
	local info = setting.lighting
	if nil ~= curTo then
		info.enable = true
		if nil ~= curFrom then
			LerpLighting(curFrom, curTo, progress, info)
		else
			CopyLighting(curTo, info)
		end
	else
		info.enable = false
	end

	curFrom = from.fog
	curTo = to.fog
	info = setting.fog
	if nil ~= curTo then
		info.enable = true
		if nil ~= curFrom then
			LerpFog(curFrom, curTo, progress, info)
		else
			CopyFog(curTo, info)
		end
	else
		info.enable = false
	end

	curFrom = from.flare
	curTo = to.flare
	info = setting.flare
	if nil ~= curTo then
		info.enable = true
		if nil ~= curFrom then
			LerpFlare(curFrom, curTo, progress, info)
		else
			CopyFlare(curTo, info)
		end
	else
		info.enable = false
	end

	curFrom = from.skybox
	curTo = to.skybox
	info = setting.skybox
	if nil ~= curTo then
		info.enable = true
		if nil ~= curFrom then
			LerpSkybox(curFrom, curTo, progress, info)
		else
			CopySkybox(curTo, info)
		end
	else
		info.enable = false
	end

	curFrom = from.sceneObject
	curTo = to.sceneObject
	info = setting.sceneObject
	if nil ~= curTo then
		info.enable = true
		if nil ~= curFrom then
			LerpSceneObject(curFrom, curTo, progress, info)
		else
			CopySceneObject(curTo, info)
		end
	else
		info.enable = false
	end
end

function EnviromentAnimation_Base:ctor()
	self.running = false
	self.from = nil
	self.to = nil
	self.duration = 0
	self.timeElapsed = 0
end

function EnviromentAnimation_Base:Reset(to, duration)
	self.to = to
	self.duration = self.timeElapsed + duration
end

function EnviromentAnimation_Base:EndAnimation()
	self.duration = 0
end

function EnviromentAnimation_Base:Clear()
	self.from = nil
	self.to = nil
	self.duration = 0
	self.timeElapsed = 0
end

function EnviromentAnimation_Base:Start()
	if self.running then
		return
	end
	self.running = true
end

function EnviromentAnimation_Base:End()
	if not self.running then
		return
	end
	self.running = false
	self.from = self.to
	self.duration = 0
	self.timeElapsed = 0
end

function EnviromentAnimation_Base:Update(time, deltaTime, setting)
	if self.running then
		if nil ~= self.from and self.timeElapsed < self.duration then
			self.timeElapsed = self.timeElapsed + deltaTime
			LerpSetting(self.from, self.to, self.timeElapsed/self.duration, setting)
			return
		else
			self:End()
		end
	end

	CopySetting(self.to, setting)
end