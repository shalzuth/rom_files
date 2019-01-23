autoImport('ServiceWeatherAutoProxy')
ServiceWeatherProxy = class('ServiceWeatherProxy', ServiceWeatherAutoProxy)
ServiceWeatherProxy.Instance = nil
ServiceWeatherProxy.NAME = 'ServiceWeatherProxy'

function ServiceWeatherProxy:ctor(proxyName)
	if ServiceWeatherProxy.Instance == nil then
		self.proxyName = proxyName or ServiceWeatherProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceWeatherProxy.Instance = self
	end
	self.weatherID = 0
	self.enable = true
end

function ServiceWeatherProxy:SetWeatherEnable(enable)
	if self.enable == enable then
		return
	end
	self.enable = enable
	if enable then
		if Game.MapManager.running then
			self:PlayWeatherEffect(self.weatherID)
		else
			self.weatherID = 0
		end
	else
		self:PlayWeatherEffect(0)
	end
end

function ServiceWeatherProxy:PlayWeatherEffect(id)
	if nil ~= self.weather then
		self.weather:Destroy()
		self.weather = nil
	end

	if 0 ~= id then
		local info = Table_Weather[id]
		if nil ~= info and nil ~= info.EffectDir and "" ~= info.EffectDir then
			self.weather = Asset_Effect.PlayAt( info.EffectDir, LuaGeometry.Const_V3_zero)
		end
	end
end

function ServiceWeatherProxy:RecvWeatherChange(data) 
	self:Notify(ServiceEvent.WeatherWeatherChange, data)
	self.weatherID = data.id
	if self.enable then
		self:PlayWeatherEffect(data.id)
	end
end

function ServiceWeatherProxy:RecvSkyChange(data) 
	LogUtility.InfoFormat("<color=green>RecvSkyChange: </color>{0}, {1}", data.id, data.sec)
	Game.MapManager:SetEnviroment(data.id, data.sec)
	self:Notify(ServiceEvent.WeatherSkyChange, data)
end
