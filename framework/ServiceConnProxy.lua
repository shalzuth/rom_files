-- game server connect
local ServiceConnProxy = class('ServiceConnProxy', ServiceProxy)

ServiceConnProxy.Instance = nil;

ServiceConnProxy.NAME = "ServiceConnProxy"

--ip server  --game server
function ServiceConnProxy:ctor(proxyName)	
	if ServiceConnProxy.Instance == nil then		
		self.proxyName = proxyName or ServiceConnProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		ServiceConnProxy.Instance = self
		self:Init()
		self:ResetLoseHeartTime()
	end
end

function ServiceConnProxy:Init()
	Game.HeartNetInfo = {
	SendHeartIntervalMax = 0,
	SendHeartIntervalAvg = 0,
	RecvHeartIntervalMax = 0,
	RecvHeartTimeOut = 0,
}
	self.isConnect = false
	self.stopCheckHeart = false

	self.checkHeartTime = 0
	self.checkHeartInterval = 0.5*30

	self.sendHeartTime = 0	
	self.sendHeartInterval = 5*30

	self.recvHeartTime = nil

	self.loseHeartTime = 10*30
	self.maxLoseHeartTime = 30*30

	self.tryReconnectTime = 0
	self.tryReconnectInterval = 5.1*30

	self.hasPressHome = false
	self.leftTime = GameConfig.TimeOfHomeKey.TimeWithLogin
	self.homeStartTime = 0
	---------Debug!!!!!!!!!!!!------------
	self.autoReconnect = true
	---------Debug!!!!!!!!!!!!------------
end

function ServiceConnProxy:ResetLoseHeartTime(  )
	-- body
	self.loseHeartTime = math.random(10,15)*30
	-- helplog("ResetLoseHeartTime:",self.loseHeartTime)
end

function ServiceConnProxy:handleNotification(notification)
	if(self.viewComponent ~= nil) then
		return self.viewComponent:handleNotification(notification)
	end
end

function ServiceConnProxy:onRegister()
	NetManager.GameSetUpdate(function ()
		self:SendHeart()
		self:CheckHeart()
	end)
	local eventManager = EventManager.Me()
  	eventManager:AddEventListener(AppStateEvent.Pause, self.GamePaused, self)
end

function ServiceConnProxy:NetworkStateReset(  )
	-- body
	self.isConnect = false
	self.recvHeartTime = nil
end

function ServiceConnProxy:TryReconnect()
	if self.isConnect then
		return
	end	

	local time = Time.frameCount
	local off = time - self.tryReconnectTime
	if off < self.tryReconnectInterval then
		return
	end
	self.tryReconnectTime = time
	Game.HeartNetInfo.RecvHeartTimeOut = Game.HeartNetInfo.RecvHeartTimeOut + 1

		-- try
	LogUtility.Warning("ServiceConnProxy::TryReconnect!!!")
	self:NotifyNetDelay()		
	ServiceUserProxy.Instance:IsReConnect(true)
	local loginData = FunctionLogin.Me():getLoginData()
	if(loginData and ServerTime.CurServerTime())then
		local serverTime = ServerTime.CurServerTime()/1000
		local timeOut = 23*60*60
		local timestamp = tonumber(loginData.timestamp)
		-- timeOut = 60
		-- helplog("reStartGameLogin:",serverTime - timestamp)
		if(serverTime - timestamp > timeOut)then
			local functionSdk = FunctionLogin.Me():getFunctionSdk()
			if(functionSdk)then
				--TODO 
				functionSdk:setLoginData(nil)
			end
		end
	end
	FunctionLogin.Me():reStartGameLogin(function ( )
		-- body
		if(not FunctionLogin.Me():getSdkEnable())then
			FunctionLogin.Me():LoginUserCmd()
		end
	end)
end

function ServiceConnProxy:UpdateSendHeartTime()
	local last = self.sendHeartTime_time
	local current = ServerTime.CacheUnscaledTime
	if(last==nil) then
		self.sendHeartTime_time = {0,0}
		last = current
	else
		last = self.sendHeartTime_time[1]
	end
	local delta = current-last
	Game.HeartNetInfo.SendHeartIntervalAvg = (delta+self.sendHeartTime_time[2])/2
	Game.HeartNetInfo.SendHeartIntervalMax = math.max(Game.HeartNetInfo.SendHeartIntervalMax,current-last)
	self.sendHeartTime = Time.frameCount
	self.sendHeartTime_time[1] = current
	self.sendHeartTime_time[2] = delta
end

function ServiceConnProxy:SendHeart()
	if not self.isConnect then
		return
	end

	local time = Time.frameCount
	-- do send
	local sendOff = time - self.sendHeartTime
	if sendOff > self.sendHeartInterval then
		local serverTime  = ServerTime.CurServerTime()
		if(serverTime)then
			ServiceLoginUserCmdProxy.Instance:CallHeartBeatUserCmd(serverTime)
			-- LogUtility.Info("SendHeart~~~~~~~~~~~~~~~~~~")
		end
	end
end

function ServiceConnProxy:RecvHeart()
	self.isConnect = true
	local last = self.recvHeartTime
	if(last==nil) then
		last = Time.frameCount
	end
	self.recvHeartTime = Time.frameCount
	Game.HeartNetInfo.RecvHeartIntervalMax = math.max(Game.HeartNetInfo.RecvHeartIntervalMax,self.recvHeartTime-last)
	-- LogUtility.Info("RecvHeart~~~~~~~~~~~~~~~~~~")
end

function ServiceConnProxy:StopHeart()
	LogUtility.Info("ServiceConnProxy::StopHeart!!!")
	local msg = String.Format("{0}\n{1}", "ServiceConnProxy::StopHeart!!!", debug.traceback())
	ROLogger.Log(msg)
	self.isConnect = false
	self.recvHeartTime = nil
	self.stopCheckHeart = true
	NetManager.GameDisConnect()
end

function ServiceConnProxy:CheckHeartStatus()
	self.stopCheckHeart = false
end

function ServiceConnProxy:CheckHeart()
	if self.recvHeartTime == nil or self.stopCheckHeart then
		return
	end
	local time = Time.frameCount

	local off = time - self.checkHeartTime
	if off < self.checkHeartInterval then
		return
	end

	-- check receive	
	local recvOff = self.checkHeartTime - self.recvHeartTime
	-- LogUtility.Info(string.format("CheckHeart(  ):checkHeartTime:%s,recvHeartTime:%s,hasPressHome:%s,isConnect:%s",
	-- 	tostring(self.checkHeartTime),tostring(self.recvHeartTime),tostring(self.hasPressHome),tostring(self.isConnect)))
	-- helplog(string.format("CheckHeart(  ):checkHeartTime:%s,recvHeartTime:%s,hasPressHome:%s,isConnect:%s ，recvoff:%s",
	-- 	tostring(self.checkHeartTime),tostring(self.recvHeartTime),tostring(self.hasPressHome),tostring(self.isConnect),recvOff))

	self.checkHeartTime = time
	-- helplog("CheckHeart:",recvOff)
	if recvOff > self.loseHeartTime and not self.hasPressHome then
		if(self.autoReconnect)then
			if self.isConnect then
				local msg = String.Format("{0}\n{1}", "ServiceConnProxy--------CheckHeart netmanager gameclose", debug.traceback())
				ROLogger.Log(msg)
				-- errorLog("ServiceConnProxy--------CheckHeart netmanager gameclose")
				-- LogUtility.Warning("ServiceConnProxy--------CheckHeart netmanager gameclose")
				NetManager.GameDisConnect()
				self.isConnect = false
			end
			-- errorLog(string.format("CheckHeart(  ):checkHeartTime:%s,recvHeartTime:%s,hasPressHome:%s,isConnect:%s ，recvoff:%s",
			-- 	tostring(self.checkHeartTime),tostring(self.recvHeartTime),tostring(self.hasPressHome),tostring(self.isConnect),recvOff))
			if recvOff > self.maxLoseHeartTime then	
				self:NotifyNetDown()		
			else			
				self:TryReconnect()
			end
		end
	end
end

function ServiceConnProxy:NotifyNetDown()
	-- 提示断线重新登录
	-- LogUtility.Warning("ServiceConnProxy::NotifyNetDown!!!")
	-- errorLog("ServiceConnProxy::NotifyNetDown!!!")
	UIWarning.Instance:RestartEvt()
	self:Notify(ServiceEvent.ConnNetDown)
end

function ServiceConnProxy:NotifyNetDelay()
	-- 提示网络延迟，转菊花
	-- errorLog("ServiceConnProxy::NotifyNetDelay!!!")
	-- LogUtility.Warning("ServiceConnProxy::NotifyNetDelay!!!")
	UIWarning.Instance:WaitEvt()
	self:Notify(ServiceEvent.ConnNetDelay)
end

function ServiceConnProxy:NotifyReconnect()
	-- 提示网络恢复成功，取消转菊花
	-- errorLog("ServiceConnProxy::NotifyReconnect TryReconnect Success")
	-- LogUtility.Warning("ServiceConnProxy::NotifyReconnect TryReconnect Success")
	UIWarning.Instance:ReConnEvt()
	
	self:Notify(ServiceEvent.ConnReconnect)
	self:Notify(ServiceEvent.ReconnInit)
	self.stopCheckHeart = false
	self:ResetLoseHeartTime()
end

function ServiceConnProxy:HandleConnect()
	-- 提示网络链接成功
	-- errorLog("ServiceConnProxy::HandleConnect Success")
	-- LogUtility.Warning("ServiceConnProxy::HandleConnect Success")
	UIWarning.Instance:HideBord()
end

function ServiceConnProxy:pressHomeKey(  )
	-- body	
end

function ServiceConnProxy:gameReActivie(  )
end

function ServiceConnProxy:GamePaused( note )
	-- body
	local paused = note.data
	if(paused)then
		self.homeStartTime = Time.frameCount
		self.hasPressHome = true
		LogUtility.Info(string.format("pressHomeKey(  ):homeStartTime:%s,isConnect:%s",tostring(self.homeStartTime),tostring(self.isConnect)))
		FunctionTyrantdb.Instance:Stop()
	else
		local dtTime = Time.frameCount - self.homeStartTime
		LogUtility.Info(string.format("gameReActivie(  ):hasPressHome:%s,homeStartTime:%s,dtTime:%s,isConnect:%s",tostring(self.hasPressHome),tostring(self.homeStartTime), tostring(dtTime),tostring(self.isConnect)))
		if(dtTime >= self.leftTime and self.hasPressHome)then
			self.homeStartTime = 0
			 FunctionNetError.Me():ErrorBackToLogo()
		elseif(dtTime < self.leftTime and self.hasPressHome)then
			if(self.isConnect)then		
				self.recvHeartTime = Time.frameCount
			end
		end
		-- print(self.recvHeartTime)
		-- printOrange("gameReActivie end")
		self.hasPressHome = false
		FunctionTyrantdb.Instance:Resume()
	end
end

return ServiceConnProxy