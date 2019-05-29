local ServiceConnProxy = class("ServiceConnProxy", ServiceProxy)
ServiceConnProxy.Instance = nil
ServiceConnProxy.NAME = "ServiceConnProxy"
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
    RecvHeartTimeOut = 0
  }
  self.isConnect = false
  self.stopCheckHeart = false
  self.checkHeartTime = 0
  self.checkHeartInterval = 15.0
  self.sendHeartTime = 0
  self.sendHeartInterval = 150
  self.recvHeartTime = nil
  self.loseHeartTime = 300
  self.maxLoseHeartTime = 900
  self.tryReconnectTime = 0
  self.tryReconnectInterval = 153.0
  self.hasPressHome = false
  self.leftTime = GameConfig.TimeOfHomeKey.TimeWithLogin
  self.homeStartTime = 0
  self.autoReconnect = true
end
function ServiceConnProxy:ResetLoseHeartTime()
  self.loseHeartTime = math.random(10, 15) * 30
end
function ServiceConnProxy:handleNotification(notification)
  if self.viewComponent ~= nil then
    return self.viewComponent:handleNotification(notification)
  end
end
function ServiceConnProxy:onRegister()
  NetManager.GameSetUpdate(function()
    self:SendHeart()
    self:CheckHeart()
  end)
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(AppStateEvent.Pause, self.GamePaused, self)
end
function ServiceConnProxy:NetworkStateReset()
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
  LogUtility.Warning("ServiceConnProxy::TryReconnect!!!")
  self:NotifyNetDelay()
  ServiceUserProxy.Instance:IsReConnect(true)
  local loginData = FunctionLogin.Me():getLoginData()
  if loginData and ServerTime.CurServerTime() then
    local serverTime = ServerTime.CurServerTime() / 1000
    local timeOut = 82800
    local timestamp = tonumber(loginData.timestamp)
    if timeOut < serverTime - timestamp then
      local functionSdk = FunctionLogin.Me():getFunctionSdk()
      if functionSdk then
        functionSdk:setLoginData(nil)
      end
    end
  end
  FunctionLogin.Me():reStartGameLogin(function()
    if not FunctionLogin.Me():getSdkEnable() then
      FunctionLogin.Me():LoginUserCmd()
    end
  end)
end
function ServiceConnProxy:UpdateSendHeartTime()
  local last = self.sendHeartTime_time
  local current = ServerTime.CacheUnscaledTime
  if last == nil then
    self.sendHeartTime_time = {0, 0}
    last = current
  else
    last = self.sendHeartTime_time[1]
  end
  local delta = current - last
  Game.HeartNetInfo.SendHeartIntervalAvg = (delta + self.sendHeartTime_time[2]) / 2
  Game.HeartNetInfo.SendHeartIntervalMax = math.max(Game.HeartNetInfo.SendHeartIntervalMax, current - last)
  self.sendHeartTime = Time.frameCount
  self.sendHeartTime_time[1] = current
  self.sendHeartTime_time[2] = delta
end
function ServiceConnProxy:SendHeart()
  if not self.isConnect then
    return
  end
  local time = Time.frameCount
  local sendOff = time - self.sendHeartTime
  if sendOff > self.sendHeartInterval then
    local serverTime = ServerTime.CurServerTime()
    if serverTime then
      ServiceLoginUserCmdProxy.Instance:CallHeartBeatUserCmd(serverTime)
    end
  end
end
function ServiceConnProxy:RecvHeart()
  self.isConnect = true
  local last = self.recvHeartTime
  if last == nil then
    last = Time.frameCount
  end
  self.recvHeartTime = Time.frameCount
  Game.HeartNetInfo.RecvHeartIntervalMax = math.max(Game.HeartNetInfo.RecvHeartIntervalMax, self.recvHeartTime - last)
end
function ServiceConnProxy:StopHeart()
  LogUtility.Info("ServiceConnProxy::StopHeart!!!")
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
  local recvOff = self.checkHeartTime - self.recvHeartTime
  self.checkHeartTime = time
  if recvOff > self.loseHeartTime and not self.hasPressHome and self.autoReconnect then
    if self.isConnect then
      LogUtility.Warning("ServiceConnProxy--------CheckHeart netmanager gameclose")
      NetManager.GameDisConnect()
      self.isConnect = false
    end
    if recvOff > self.maxLoseHeartTime then
      self:NotifyNetDown()
    else
      self:TryReconnect()
    end
  end
end
function ServiceConnProxy:NotifyNetDown()
  UIWarning.Instance:RestartEvt()
  self:Notify(ServiceEvent.ConnNetDown)
end
function ServiceConnProxy:NotifyNetDelay()
  UIWarning.Instance:WaitEvt()
  self:Notify(ServiceEvent.ConnNetDelay)
end
function ServiceConnProxy:NotifyReconnect()
  UIWarning.Instance:ReConnEvt()
  self:Notify(ServiceEvent.ConnReconnect)
  self:Notify(ServiceEvent.ReconnInit)
  self.stopCheckHeart = false
  self:ResetLoseHeartTime()
end
function ServiceConnProxy:HandleConnect()
  self:Notify(ServiceEvent.ConnSuccess)
  UIWarning.Instance:HideBord()
end
function ServiceConnProxy:pressHomeKey()
end
function ServiceConnProxy:gameReActivie()
end
function ServiceConnProxy:GamePaused(note)
  local paused = note.data
  if paused then
    self.homeStartTime = Time.frameCount
    self.hasPressHome = true
    LogUtility.Info(string.format("pressHomeKey(  ):homeStartTime:%s,isConnect:%s", tostring(self.homeStartTime), tostring(self.isConnect)))
    FunctionTyrantdb.Instance:Stop()
  else
    local dtTime = Time.frameCount - self.homeStartTime
    LogUtility.Info(string.format("gameReActivie(  ):hasPressHome:%s,homeStartTime:%s,dtTime:%s,isConnect:%s", tostring(self.hasPressHome), tostring(self.homeStartTime), tostring(dtTime), tostring(self.isConnect)))
    if dtTime >= self.leftTime and self.hasPressHome then
      self.homeStartTime = 0
      FunctionNetError.Me():ErrorBackToLogo()
    elseif dtTime < self.leftTime and self.hasPressHome and self.isConnect then
      self.recvHeartTime = Time.frameCount
    end
    self.hasPressHome = false
    FunctionTyrantdb.Instance:Resume()
  end
end
return ServiceConnProxy
