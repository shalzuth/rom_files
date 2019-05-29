FunctionGetIpStrategy = class("FunctionGetIpStrategy")
FunctionGetIpStrategy.LANGUAGESCOPE = {EN = "EN", CN = "CN"}
FunctionGetIpStrategy.GROUPKEY = {
  "LANGUAGESCOPE"
}
autoImport("OverseaHostHelper")
function FunctionGetIpStrategy.Me()
  if nil == FunctionGetIpStrategy.me then
    FunctionGetIpStrategy.me = FunctionGetIpStrategy.new()
  end
  return FunctionGetIpStrategy.me
end
function FunctionGetIpStrategy:ctor()
  self:initData()
end
function FunctionGetIpStrategy:initData()
  self.needComatibility = false
  if BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
    self.needComatibility = true
  else
    Game.FunctionLoginMono = FunctionLoginMono.Instance
  end
  LogUtility.InfoFormat(" FunctionGetIpStrategy:initData needComatibility:{0}", self.needComatibility)
  self.language = FunctionGetIpStrategy.LANGUAGESCOPE.CN
  self.groupKey = self.language
  self.accId = nil
  self.isReconnect = false
  self.initAlSDKRetCode = nil
  self.normalIpIndex = 0
  self.hasConnFailure = false
  self.reConnCountInGame = 0
  self.ifUseAliSdk = nil
  self.socketInfo = nil
  self:resetData()
end
function FunctionGetIpStrategy:setReConnectState(state)
  self.isReconnect = state
  LogUtility.InfoFormat(" FunctionGetIpStrategy:setReConnectState:state:{0}", state)
end
function FunctionGetIpStrategy:setAccId(accId)
  self.accId = accId
  LogUtility.InfoFormat(" FunctionGetIpStrategy:setAccId:accId:{0}", accId)
end
function FunctionGetIpStrategy:setSdkState(sdkState)
  self.sdkState = sdkState
  LogUtility.InfoFormat(" FunctionGetIpStrategy:setSdkState:sdkState:{0}", sdkState)
end
function FunctionGetIpStrategy:setHasConnFailure(hasConnFailure)
  self.hasConnFailure = hasConnFailure
  if not hasConnFailure then
    self.reConnCountInGame = 0
  end
  LogUtility.InfoFormat(" FunctionGetIpStrategy:setHasConnFailure hasConnFailure:{0}", hasConnFailure)
end
function FunctionGetIpStrategy:resetData()
  self.curSerIndexInGroup = 1
  self.curSerIndex = nil
  self.sdkState = true
  LogUtility.Info(" FunctionGetIpStrategy:resetData")
end
function FunctionGetIpStrategy:getNextServerGroup()
  local groupName = ""
  local group = NetConfig.AliyunSecurityIPSdkServerGroup[self.groupKey]
  LogUtility.InfoFormat(" FunctionGetIpStrategy:getNextServerGroup groupKey:{0}", self.groupKey)
  if group and #group > 0 then
    if not self.curSerIndex then
      self.curSerIndex = self.accId % #group + 1
    end
    if self.isReconnect then
      self.curSerIndexInGroup = 2
    else
      self.curSerIndexInGroup = 1
    end
    if group[self.curSerIndex] then
      groupName = group[self.curSerIndex][self.curSerIndexInGroup]
    end
    LogUtility.InfoFormat(" FunctionGetIpStrategy:getNextServerGroup groupName:{0},isReconnect:{1},language:{2}", groupName, self.isReconnect, self.language)
    LogUtility.InfoFormat(" FunctionGetIpStrategy:getNextServerGroup curSerIndex:{0},accId:{1},curSerIndexInGroup:{2}", self.curSerIndex, self.accId, self.curSerIndexInGroup)
    return groupName
  else
    LogUtility.Info(" FunctionGetIpStrategy:getNextServerGroup no groupName")
  end
end
function FunctionGetIpStrategy:getNextServerIp()
  self.normalIpIndex = self.normalIpIndex + 1
  local ips = FunctionGetIpStrategy.Me():getGateHost()
  if self.normalIpIndex > #ips then
    self.normalIpIndex = 1
  end
  local ip = ips[self.normalIpIndex]
  LogUtility.InfoFormat(" FunctionGetIpStrategy:getNextServerIp normalIpIndex:{0} ,ip:{1}", self.normalIpIndex, ip)
  return ip
end
function FunctionGetIpStrategy:initALSDK()
  if self.initAlSDKRetCode ~= 0 then
    self.initAlSDKRetCode = AliyunSecurityIPSdk.initALSDK(NetConfig.AliyunSecurityIPSdkAppkey)
  end
  LogUtility.InfoFormat("FunctionGetIpStrategy:initALSDK:resultCode:{0}", self.initAlSDKRetCode)
end
function FunctionGetIpStrategy:getRequestAddresss()
  if not self.needComatibility then
    return NetConfig.NewAccessTokenAuthHost
  else
    local ips = NetConfig.AccessTokenAuthHost[self.groupKey]
    return ips
  end
end
function FunctionGetIpStrategy:getGateHost()
  local ips = NetConfig.GateHost[self.groupKey]
  ips = OverseaHostHelper:GetHosts()
  return ips
end
local tempTable = {}
function FunctionGetIpStrategy:setCurrentSocketInfo(socketInfo)
  if socketInfo then
    tempTable.ip = socketInfo.ip
    tempTable.domain = socketInfo.originDomain
    self.socketInfo = tempTable
  else
    self.socketInfo = nil
  end
end
function FunctionGetIpStrategy:getCurrentSocketInfo()
  return self.socketInfo
end
function FunctionGetIpStrategy:getIfUseAliSdk()
  if self.ifUseAliSdk == nil then
    local verStr = VersionUpdateManager.serverResJsonString
    LogUtility.InfoFormat("FunctionGetIpStrategy:getIfUseAliSdk() verStr:{0}", verStr)
    local result = StringUtil.Json2Lua(verStr)
    if result and result.data then
      local data = result.data
      local ifUseAliSdk = data.usealisdk
      self.ifUseAliSdk = ifUseAliSdk and tonumber(ifUseAliSdk) == 1 or false
    end
  end
  return self.ifUseAliSdk
end
function FunctionGetIpStrategy:getServerIpSync(callback, groupName)
  if not self.needComatibility then
    self:getBestServerIpByAliSdkSync(callback, groupName)
  else
    self:getIpByAliSdkSync(callback, groupName)
  end
end
function FunctionGetIpStrategy:getIpByAliSdkSync(callback, groupName)
  local serverHost
  local socketInfo = {}
  if self.hasConnFailure and not self.isReconnect then
    serverHost = self:getNextServerIp()
    socketInfo.originDomain = serverHost
  elseif self.isReconnect and self.hasConnFailure and self.reConnCountInGame > 0 then
    serverHost = self:getNextServerIp()
    socketInfo.originDomain = serverHost
  else
    if self.isReconnect and self.hasConnFailure then
      self.reConnCountInGame = self.reConnCountInGame + 1
    end
    if not groupName or not groupName then
      groupName = FunctionGetIpStrategy.Me():getNextServerGroup()
    end
    local useSdk = self:getIfUseAliSdk()
    if not useSdk then
      groupName = nil
    end
    if not groupName or groupName == "" then
      serverHost = self:getNextServerIp()
      socketInfo.originDomain = serverHost
    else
      self:initALSDK()
      serverHost = AliyunSecurityIPSdk.getIpByGroupNameSync(groupName)
      socketInfo.originDomain = groupName
      if not serverHost or serverHost == "" then
        serverHost = self:getNextServerIp()
        socketInfo.originDomain = serverHost
      end
    end
    LogUtility.InfoFormat("FunctionGetIpStrategy:getIpByGroupNameSync:serverHost:{0}", serverHost)
  end
  socketInfo.ip = serverHost
  self:setCurrentSocketInfo(socketInfo)
  callback(serverHost)
end
function FunctionGetIpStrategy:getBestServerIpByAliSdkSync(callback, groupName)
  self:getIpByDomains(function(resolveRets)
    if self.hasConnFailure and not self.isReconnect then
      self:multiSocketConnectTest(callback, resolveRets)
      return
    elseif self.isReconnect and self.hasConnFailure and self.reConnCountInGame > 0 then
      self:multiSocketConnectTest(callback, resolveRets)
      return
    elseif self.isReconnect and self.hasConnFailure then
      self.reConnCountInGame = self.reConnCountInGame + 1
    end
    if self:checkIsIpv6(resolveRets) then
      self:multiSocketConnectTest(callback, resolveRets)
      LogUtility.Info(" checkIsIpv6: return true")
    else
      groupName = groupName and groupName or FunctionGetIpStrategy.Me():getNextServerGroup()
      local useSdk = self:getIfUseAliSdk()
      if not useSdk then
        groupName = nil
      end
      LogUtility.InfoFormat(" start FunctionGetIpStrategy:getServerIpByAliSdkAsync groupName:{0}", groupName)
      if not groupName or groupName == "" then
        self:multiSocketConnectTest(callback, resolveRets)
      else
        GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
        LeanTween.delayedCall(0.05, function()
          self:delayAliGetIp(resolveRets, callback, groupName)
        end)
      end
    end
  end)
end
function FunctionGetIpStrategy:delayAliGetIp(resolveRets, callback, groupName)
  self:initALSDK()
  local serverHost = AliyunSecurityIPSdk.getIpByGroupNameSync(groupName)
  GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
  if serverHost and serverHost ~= "" then
    self:multiSocketConnectTest(callback, resolveRets, serverHost, groupName)
  else
    self:multiSocketConnectTest(callback, resolveRets)
  end
end
function FunctionGetIpStrategy:getServerIpAsync(callback, groupName)
  if not self.needComatibility then
    self:getBestServerIpByAliSdkAsync(callback, groupName)
  else
    self:getIpByAliSdkAsync(callback, groupName)
  end
end
function FunctionGetIpStrategy:getIpByAliSdkAsync(callback, groupName)
  if self.hasConnFailure and not self.isReconnect then
    local serverHost = self:getNextServerIp()
    LogUtility.InfoFormat(" FunctionGetIpStrategy:getServerIpByAliSdkAsync login try:{0}", groupName)
    if callback then
      callback(serverHost)
    end
    return
  elseif self.isReconnect and self.hasConnFailure and self.reConnCountInGame > 0 then
    local serverHost = self:getNextServerIp()
    LogUtility.InfoFormat(" FunctionGetIpStrategy:getServerIpByAliSdkAsync reconnect try:{0}", self.reConnCountInGame)
    if callback then
      callback(serverHost)
    end
    return
  elseif self.isReconnect and self.hasConnFailure then
    self.reConnCountInGame = self.reConnCountInGame + 1
  end
  if not groupName or not groupName then
    groupName = FunctionGetIpStrategy.Me():getNextServerGroup()
  end
  local useSdk = self:getIfUseAliSdk()
  if not useSdk then
    groupName = nil
  end
  LogUtility.InfoFormat(" start FunctionGetIpStrategy:getServerIpByAliSdkAsync groupName:{0}", groupName)
  if not groupName or groupName == "" then
    local serverHost = self:getNextServerIp()
    if callback then
      callback(serverHost)
    end
  else
    self:initALSDK()
    Game.FunctionLoginMono:getIpByGroupNameAsync(groupName, function(serverHost)
      LogUtility.InfoFormat("end FunctionGetIpStrategy:getServerIpByAliSdkAsync:serverHost:{0}", serverHost)
      if serverHost and serverHost ~= "" then
        if callback then
          callback(serverHost)
        end
      else
        serverHost = self:getNextServerIp()
        if callback then
          callback(serverHost)
        end
      end
    end, NetConfig.GetAliyunIpTimeOut)
  end
end
function FunctionGetIpStrategy:getBestServerIpByAliSdkAsync(callback, groupName)
  self:getIpByDomains(function(resolveRets)
    if self.hasConnFailure and not self.isReconnect then
      self:multiSocketConnectTest(callback, resolveRets)
      return
    elseif self.isReconnect and self.hasConnFailure and self.reConnCountInGame > 0 then
      self:multiSocketConnectTest(callback, resolveRets)
      return
    elseif self.isReconnect and self.hasConnFailure then
      self.reConnCountInGame = self.reConnCountInGame + 1
    end
    if self:checkIsIpv6(resolveRets) then
      self:multiSocketConnectTest(callback, resolveRets)
      LogUtility.Info(" checkIsIpv6: return true")
    else
      groupName = groupName and groupName or FunctionGetIpStrategy.Me():getNextServerGroup()
      LogUtility.InfoFormat(" start FunctionGetIpStrategy:getServerIpByAliSdkAsync groupName:{0}", groupName)
      local useSdk = self:getIfUseAliSdk()
      if not useSdk then
        groupName = nil
      end
      if not groupName or groupName == "" then
        self:multiSocketConnectTest(callback, resolveRets)
      else
        self:initALSDK()
        Game.FunctionLoginMono:getIpByGroupNameAsync(groupName, function(serverHost)
          LogUtility.InfoFormat("end FunctionGetIpStrategy:getServerIpByAliSdkAsync:serverHost:{0}", serverHost)
          if serverHost and serverHost ~= "" then
            self:multiSocketConnectTest(callback, resolveRets, serverHost, groupName)
          else
            self:multiSocketConnectTest(callback, resolveRets)
          end
        end, NetConfig.GetAliyunIpTimeOut)
      end
    end
  end)
end
function FunctionGetIpStrategy:getIpByDomains(callback)
  local domains = NetConfig.NewGateHost
  domains = OverseaHostHelper:GetHosts()
  local fucntionSdk = FunctionLogin.Me():getFunctionSdk()
  if fucntionSdk then
    local plat = fucntionSdk:GetPlat()
    plat = tonumber(plat)
    if plat == 3 then
      domains = NetConfig.NewGateHost_NOTEST
    end
  end
  if domains and #domains > 0 then
    self.dnsrel = FunctionLoginDnsResolve(NetConfig.DnsResolveTimeOut)
    for i = 1, #domains do
      local domain = domains[i]
      self.dnsrel:addDomainName(domains[i])
    end
    self.dnsrel:setCallback(function(resolveRets)
      callback(resolveRets)
    end)
    self.dnsrel:tryStartResolve()
  else
    callback()
  end
end
local tempArray = {}
function FunctionGetIpStrategy:multiSocketConnectTest(callback, resolveRets, aliIP, aliGroup)
  self.sts = nil
  local gatePort = FunctionLogin.Me():getServerPort()
  LogUtility.InfoFormat("multiSocketConnectTest gatePort:{0}", gatePort)
  TableUtility.ArrayClear(tempArray)
  for i = 1, #resolveRets do
    local ret = resolveRets[i]
    if ret.result.state == FunctionLoginDnsResolve.DnsResolveState.Finish and not table.ContainsValue(tempArray, ret.result.ip) then
      if self.sts == nil then
        self.sts = FunctionLoginChooseSocket(NetConfig.SocketConnectTestTimeOut)
      end
      self.sts:addIpAndPort(ret.result.ip, gatePort, ret.result.domain)
      table.insert(tempArray, ret.result.ip)
    end
    LogUtility.InfoFormat("FunctionLoginDnsResolve delay:{0},ip:{1},domain:{2}", ret.result.delay, ret.result.ip, ret.result.domain)
    LogUtility.InfoFormat("FunctionLoginDnsResolve state:{0},errorMessage:{1}", ret.result.state, ret.result.errorMessage)
  end
  if aliIP then
    if self.sts == nil then
      self.sts = FunctionLoginChooseSocket(NetConfig.SocketConnectTestTimeOut)
    end
    self.sts:addIpAndPort(aliIP, gatePort, aliGroup)
  end
  if self.sts then
    self.sts:setCallback(function(connectRets)
      local result = self:getBestResult(connectRets)
      self:setCurrentSocketInfo(result)
      if callback then
        callback(result)
      end
    end)
    self.sts:tryStartConnect()
  else
    callback()
  end
end
function FunctionGetIpStrategy:checkIsIpv6(resolveRets)
  if resolveRets then
    for i = 1, #resolveRets do
      local ret = resolveRets[i]
      if ret.result.state == FunctionLoginDnsResolve.DnsResolveState.Finish then
        local ip = ret.result.ip
        if ip and string.find(ip, ":") then
          return true
        end
      end
    end
  end
end
function FunctionGetIpStrategy:getBestResult(connectRets)
  return self:getBestResult_2(connectRets)
end
function FunctionGetIpStrategy:getBestResult_1(connectRets)
  local result
  local minDelay = 999999
  for i = 1, #connectRets do
    local ret = connectRets[i]
    local isConnected = ret.result.state == FunctionLoginChooseSocket.SocketConnectState.Finish
    local isAli = self:isAliSdk(ret.result.originDomain)
    local delta = isAli and NetConfig.AliyunNetDelayDelta or 0
    LogUtility.InfoFormat("FunctionLoginChooseSocket isAli:{0},delta:{1}", isAli, delta)
    if isConnected and delta > ret.result.delay - minDelay then
      minDelay = ret.result.delay
      if result then
        result:dispose()
      end
      result = ret.result
    else
      ret.result:dispose()
    end
    LogUtility.InfoFormat("FunctionLoginChooseSocket delay:{0},ip:{1},originDomain:{2}", ret.result.delay, ret.result.ip, ret.result.originDomain)
    LogUtility.InfoFormat("FunctionLoginChooseSocket state:{0},errorMessage:{1}", ret.result.state, ret.result.errorMessage)
  end
  return result
end
function FunctionGetIpStrategy:getBestResult_2(connectRets)
  local minDelay = 999999
  local result, norRet, aliRet, gfRet
  for i = 1, #connectRets do
    local ret = connectRets[i]
    local isConnected = ret.result.state == FunctionLoginChooseSocket.SocketConnectState.Finish
    local isAli = self:isAliSdk(ret.result.originDomain)
    local isGf = self:isGfDomain(ret.result.originDomain)
    if isConnected and isAli then
      aliRet = ret.result
    elseif isConnected and isGf then
      gfRet = ret.result
    elseif isConnected and minDelay > ret.result.delay then
      minDelay = ret.result.delay
      norRet = ret.result
    end
    LogUtility.InfoFormat("FunctionLoginChooseSocket isAli:{0},isGf:{1}", isAli, isGf)
    LogUtility.InfoFormat("FunctionLoginChooseSocket delay:{0},ip:{1},originDomain:{2}", ret.result.delay, ret.result.ip, ret.result.originDomain)
    LogUtility.InfoFormat("FunctionLoginChooseSocket state:{0},errorMessage:{1}", ret.result.state, ret.result.errorMessage)
  end
  local aliOk = false
  local gfOk = false
  local maxDelta = 20
  local delta
  if aliRet then
    if norRet then
      delta = aliRet.delay - norRet.delay
      if maxDelta > delta then
        aliOk = true
      end
    else
      aliOk = true
    end
  end
  if gfRet then
    if norRet then
      delta = gfRet.delay - norRet.delay
      if maxDelta > delta then
        gfOk = true
      end
    else
      gfOk = true
    end
  end
  if aliOk and gfOk then
    local ret = math.random(2) == 1
    if ret then
      result = aliRet
      LogUtility.Info("FunctionLoginChooseSocket Choose Ali by random")
    else
      result = gfRet
      LogUtility.Info("FunctionLoginChooseSocket Choose GF by random")
    end
  elseif aliOk then
    result = aliRet
    LogUtility.Info("FunctionLoginChooseSocket Choose Ali")
  elseif gfOk then
    result = gfRet
    LogUtility.Info("FunctionLoginChooseSocket Choose GF")
  else
    result = norRet
    LogUtility.Info("FunctionLoginChooseSocket Choose Other")
  end
  if nil ~= result then
    LogUtility.InfoFormat("FunctionLoginChooseSocket Choose: delay:{0},ip:{1},originDomain:{2}", result.delay, result.ip, result.originDomain)
  end
  for i = 1, #connectRets do
    local ret = connectRets[i].result
    if ret ~= result then
      ret:dispose()
    end
  end
  return result
end
function FunctionGetIpStrategy:checkResultIsOk(result, connectRets)
  local result
  local minDelay = 999999
  local maxDelta = 100
  local isAli = self:isAliSdk(result.originDomain)
  local isGf = self:isGfDomain(result.originDomain)
  for i = 1, #connectRets do
    local ret = connectRets[i]
    if result ~= ret.result then
      local isConnected = ret.result.state == FunctionLoginChooseSocket.SocketConnectState.Finish
      LogUtility.InfoFormat("FunctionLoginChooseSocket isAli:{0},isGf:{1},delta:{2}", isAli, isGf, delta)
      if isConnected and maxDelta > result.delay - minDelay then
        minDelay = ret.result.delay
        if result then
          result:dispose()
        end
        result = ret.result
      end
    end
  end
end
function FunctionGetIpStrategy:isAliSdk(originDomain)
  local domains = NetConfig.NewGateHost
  for i = 1, #domains do
    if originDomain == domains[i] then
      return false
    end
  end
  domains = NetConfig.NewGateHost_NOTEST
  for i = 1, #domains do
    if originDomain == domains[i] then
      return false
    end
  end
  return true
end
function FunctionGetIpStrategy:isGfDomain(originDomain)
  return originDomain == NetConfig.NewGateHostGf
end
function FunctionGetIpStrategy:isForeignDomain(originDomain)
  if originDomain == NetConfig.NewGateHostFg then
    return true
  end
end
function FunctionGetIpStrategy:GameEnd()
  if self.dnsrel then
    self.dnsrel:setCallback(nil)
  end
  if self.sts then
    self.dnsrel:setCallback(nil)
  end
end
