EnviromentAnimation_Weather = class("EnviromentAnimation_Weather")

function EnviromentAnimation_Weather:ctor()
	self.color = LuaColor.white
	self.intensity = 1
	self.running = false
end

function EnviromentAnimation_Weather:Reset(r, g, b, a, scale)
	self.color:Set(r,g,b,a)
	self.intensity = scale
end

function EnviromentAnimation_Weather:Clear()
	self.color:Set(1,1,1,1)
	self.intensity = 1
end

function EnviromentAnimation_Weather:Start()
	if self.running then
		return
	end
	self.running = true
end

function EnviromentAnimation_Weather:End()
	if not self.running then
		return
	end
	self.running = false
end

function EnviromentAnimation_Weather:Update(time, deltaTime, setting)
	if not self.running then
		return
	end

	if not setting.lighting.enable then
		return
	end

	local info = setting.lighting
	if AmbientMode.Trilight == info.ambientMode then
		info.ambientSkyColor = LuaColorUtility.Asign(info.ambientSkyColor, self.color)
	else
		info.ambientLight = LuaColorUtility.Asign(info.ambientLight, self.color)
	end
	info.ambientIntensity = self.intensity
end