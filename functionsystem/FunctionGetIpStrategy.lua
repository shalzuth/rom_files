FunctionGetIpStrategy = class("FunctionGetIpStrategy")

FunctionGetIpStrategy.LANGUAGESCOPE = {
	EN = "EN",
	CN = "CN"
}

FunctionGetIpStrategy.GROUPKEY = {
	"LANGUAGESCOPE",
}

-- sdk获取成功{
	--尝试登陆{
		--1 登陆成功
		--2 登陆失败
	--}
--}
--
--首次登陆失败-》高防
--重连失败-》高防

-- sdk获取失败{
	-- 高防
-- }

-- }


-- 虎钤 17:49:32
--  我建议你 第一个分组尝试重连1次
-- 虎钤 17:49:41
--  第二个分组尝试重连2次

-- 首次登陆的分组连不上的话，是不是最好再试下重连的那个分组呢。还是说直接走高防。
-- 已读
-- 虎钤
--  直接走高防
-- 虎钤
--  不要尝试重连的
-- 虎钤
--  切记

--  首次登陆第一个分组即失败了，我这继续尝试登陆第一个分组，只有登陆成功后的重连才会尝试登陆第二个重连的分组。
-- 已读
-- 虎钤
--  是的
-- 虎钤
--  如果首次登陆失败你就直接走高防


--

-- 1、是否使用游戏盾根据检查版本更新阶段返回usealisdk
-- 2、异步同时获取列表{"gw-m-ro-gf.xd.com"（高防）,"gw-m-ro.xd.com","gw-m-ro-foreign.xd.com"}ip
-- 3、获取2步骤中解析成功的ip进行socket连接并记录连接状态与连接延迟（socket连接开始到成功的时间），如果允许使用游戏盾则同时获取游戏盾ip并进行socket连接
-- 4、判断{"gw-m-ro.xd.com","gw-m-ro-foreign.xd.com"}是否最终socket连接成功，并取得二者最小延迟一个(min_delay)
-- 5、判断游戏盾是否启用，如果启用判断其socket连接状态与延迟（ali_delay），并比较4中得到的结果的延迟，如果游戏盾socket可连接并延迟时间较4步骤中结果延迟ali_delay - min_delay < 100ms 则标记游戏盾可用
-- 5、判断高防其socket连接状态与延迟（gf_delay），并比较4中得到的结果的延迟，如果socket可连接并延迟时间较4步骤中结果延迟gf_delay - min_delay < 20ms 则标记高防可用
-- 6、
-- 	1）、如果高防可用且游戏盾可用，随机取一个
-- 	2）、如果高防可用且游戏盾不可用，取高防
-- 	3）、如果高防不可用且游戏盾可用，取游戏盾
-- 	4）、如果高防不可用且游戏盾不可用，取4步骤中结果
-- 	5）、全部不可用，弹框错误50000
-- --
-- todo xde host
autoImport('OverseaHostHelper')


function FunctionGetIpStrategy.Me()
	if nil == FunctionGetIpStrategy.me then
		FunctionGetIpStrategy.me = FunctionGetIpStrategy.new()
	end
	return FunctionGetIpStrategy.me
end

function FunctionGetIpStrategy:ctor()
	self:initData()
	-- todo xde cancel
	-- self:initALSDK()
end

function FunctionGetIpStrategy:initData(  )
	-- body
	-- local language = AliyunSecurityIPSdk.getLanguage()
	-- LogUtility.InfoFormat(" FunctionGetIpStrategy:initData:language:{0}",language)
	-- if(language == SystemLanguage.ChineseSimplified or language == SystemLanguage.Chinese)then
	-- 	self.language = FunctionGetIpStrategy.LANGUAGESCOPE.CN
	-- else
	-- 	self.language = FunctionGetIpStrategy.LANGUAGESCOPE.EN
	-- end

	self.needComatibility = false
	if BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
    	self.needComatibility = true
   	else
    	Game.FunctionLoginMono = FunctionLoginMono.Instance
   	end

   	LogUtility.InfoFormat(" FunctionGetIpStrategy:initData needComatibility:{0}",self.needComatibility)
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

function FunctionGetIpStrategy:setReConnectState( state )
	-- body
	self.isReconnect = state
	LogUtility.InfoFormat(" FunctionGetIpStrategy:setReConnectState:state:{0}",state)
end

function FunctionGetIpStrategy:setAccId( accId )
	-- body
	self.accId = accId
	LogUtility.InfoFormat(" FunctionGetIpStrategy:setAccId:accId:{0}",accId)
end

function FunctionGetIpStrategy:setSdkState( sdkState )
	-- body
	self.sdkState = sdkState
	LogUtility.InfoFormat(" FunctionGetIpStrategy:setSdkState:sdkState:{0}",sdkState)
end

function FunctionGetIpStrategy:setHasConnFailure( hasConnFailure )
	-- body
	self.hasConnFailure = hasConnFailure
	if(not hasConnFailure)then
		self.reConnCountInGame = 0
	end
	LogUtility.InfoFormat(" FunctionGetIpStrategy:setHasConnFailure hasConnFailure:{0}",hasConnFailure)
end

function FunctionGetIpStrategy:resetData(  )
	-- body	
	self.curSerIndexInGroup = 1
	self.curSerIndex = nil
	self.sdkState = true
	LogUtility.Info(" FunctionGetIpStrategy:resetData")
end

function FunctionGetIpStrategy:getNextServerGroup(  )
	-- body
	local groupName = ""

	-- if(false)then
	-- 	首次登陆已失败
	-- 	重连失败
		--return groupName
	-- end
	local group = NetConfig.AliyunSecurityIPSdkServerGroup[self.groupKey]
	LogUtility.InfoFormat(" FunctionGetIpStrategy:getNextServerGroup groupKey:{0}",self.groupKey)

	if(group and #group >0)then

		if(not self.curSerIndex)then
			self.curSerIndex = self.accId % (#group) + 1
		end

		if(self.isReconnect)then
			self.curSerIndexInGroup = 2
		else
			self.curSerIndexInGroup = 1
		end

		if(group[self.curSerIndex])then
			groupName = group[self.curSerIndex][self.curSerIndexInGroup]
		end			

		LogUtility.InfoFormat(" FunctionGetIpStrategy:getNextServerGroup groupName:{0},isReconnect:{1},language:{2}",groupName,self.isReconnect,self.language)
		LogUtility.InfoFormat(" FunctionGetIpStrategy:getNextServerGroup curSerIndex:{0},accId:{1},curSerIndexInGroup:{2}",self.curSerIndex,self.accId,self.curSerIndexInGroup)
		return groupName
	else
		LogUtility.Info(" FunctionGetIpStrategy:getNextServerGroup no groupName")
	end
end


function FunctionGetIpStrategy:getNextServerIp(  )
	-- body
	self.normalIpIndex = self.normalIpIndex+1
	local ips = FunctionGetIpStrategy.Me():getGateHost()
	if(self.normalIpIndex > #ips)then
		self.normalIpIndex = 1
	end
	local ip = ips[self.normalIpIndex]
	LogUtility.InfoFormat(" FunctionGetIpStrategy:getNextServerIp normalIpIndex:{0} ,ip:{1}",self.normalIpIndex,ip)
	return ip
end

function FunctionGetIpStrategy:initALSDK(  )
	-- body
	if(self.initAlSDKRetCode ~= 0 )then
		self.initAlSDKRetCode = AliyunSecurityIPSdk.initALSDK(NetConfig.AliyunSecurityIPSdkAppkey)		
	end
	-- LogUtility.InfoFormat("FunctionGetIpStrategy:initALSDK:resultCode:{0}",self.initAlSDKRetCode)
	LogUtility.InfoFormat("FunctionGetIpStrategy:initALSDK:resultCode:{0}",self.initAlSDKRetCode)
end

function FunctionGetIpStrategy:getRequestAddresss(  )
	-- body
	if(not self.needComatibility)then
		return NetConfig.NewAccessTokenAuthHost
	else
		local ips = NetConfig.AccessTokenAuthHost[self.groupKey]
		return ips
	end
end

function FunctionGetIpStrategy:getGateHost(  )
	-- body
	local ips = NetConfig.GateHost[self.groupKey]
	-- todo xde host
	ips = OverseaHostHelper:GetHosts()
	return ips
end

local tempTable = {}
function FunctionGetIpStrategy:setCurrentSocketInfo( socketInfo )
	-- body
	if(socketInfo)then
		tempTable.ip = socketInfo.ip
		tempTable.domain = socketInfo.originDomain
		self.socketInfo = tempTable
	else
		self.socketInfo = nil
	end
end

function FunctionGetIpStrategy:getCurrentSocketInfo(  )
	-- body
	return self.socketInfo
end

function FunctionGetIpStrategy:getIfUseAliSdk(  )
	-- body
	if(self.ifUseAliSdk == nil)then
		local verStr = VersionUpdateManager.serverResJsonString
		LogUtility.InfoFormat("FunctionGetIpStrategy:getIfUseAliSdk() verStr:{0}",verStr)
		local result = StringUtil.Json2Lua(verStr)
		if(result and result["data"])then
			local data = result["data"]
			local ifUseAliSdk = data["usealisdk"]
			self.ifUseAliSdk = ifUseAliSdk and tonumber(ifUseAliSdk) == 1 or false
		end
	end
	return self.ifUseAliSdk
end

function FunctionGetIpStrategy:getServerIpSync( callback,groupName )
	if(not self.needComatibility)then
		self:getBestServerIpByAliSdkSync(callback,groupName)
	else
		self:getIpByAliSdkSync(callback,groupName)
	end
end

---------deprecated----------
function FunctionGetIpStrategy:getIpByAliSdkSync(callback, groupName )
	-- body
	local serverHost
	local socketInfo = {}
	-- 首次登陆失败 走高防
	if(self.hasConnFailure and not self.isReconnect)then
		serverHost = self:getNextServerIp()
		socketInfo.originDomain = serverHost
		--重连登陆最多尝试两次
	elseif(self.isReconnect and self.hasConnFailure and self.reConnCountInGame > 0)then
		serverHost = self:getNextServerIp()
		socketInfo.originDomain = serverHost
	else
		if(self.isReconnect and self.hasConnFailure)then
			self.reConnCountInGame = self.reConnCountInGame +1
		end
		groupName = groupName and groupName or FunctionGetIpStrategy.Me():getNextServerGroup()
		local useSdk = self:getIfUseAliSdk()
		if(not useSdk)then
			groupName = nil
		end
		if(not groupName or groupName == "")then
			serverHost = self:getNextServerIp()
			socketInfo.originDomain = serverHost
		else
			self:initALSDK()
			serverHost = AliyunSecurityIPSdk.getIpByGroupNameSync(groupName)
			socketInfo.originDomain = groupName
			if(not serverHost or serverHost == "")then
				serverHost = self:getNextServerIp()
				socketInfo.originDomain = serverHost
			end
		end
		LogUtility.InfoFormat("FunctionGetIpStrategy:getIpByGroupNameSync:serverHost:{0}",serverHost)
	end		
	socketInfo.ip = serverHost	
	self:setCurrentSocketInfo(socketInfo)
	callback(serverHost)
end

---------deprecated----------
function FunctionGetIpStrategy:getBestServerIpByAliSdkSync( callback,groupName )
	-- body
	self:getIpByDomains(function ( resolveRets )
		-- body	
		-- 首次登陆分组失败即走高防
		if(self.hasConnFailure and not self.isReconnect)then
			self:multiSocketConnectTest(callback,resolveRets)
			return 
			--重连登陆分组尝试两次走高防
		elseif(self.isReconnect and self.hasConnFailure and self.reConnCountInGame > 0)then
			self:multiSocketConnectTest(callback,resolveRets)
			return 
		elseif(self.isReconnect and self.hasConnFailure)then
			self.reConnCountInGame = self.reConnCountInGame +1
		end
		if(self:checkIsIpv6(resolveRets))then
			self:multiSocketConnectTest(callback,resolveRets)
			LogUtility.Info(" checkIsIpv6: return true")
		else
			groupName = groupName and groupName or FunctionGetIpStrategy.Me():getNextServerGroup()
			local useSdk = self:getIfUseAliSdk()
			if(not useSdk)then
				groupName = nil
			end
			LogUtility.InfoFormat(" start FunctionGetIpStrategy:getServerIpByAliSdkAsync groupName:{0}",groupName)
			if(not groupName or groupName == "")then
				self:multiSocketConnectTest(callback,resolveRets)
			else
				GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
				LeanTween.delayedCall(0.05,function ()
					self:delayAliGetIp(resolveRets,callback,groupName)
				end)
			end
		end
	end)
end

function FunctionGetIpStrategy:delayAliGetIp( resolveRets,callback,groupName)
	self:initALSDK()
	local serverHost = AliyunSecurityIPSdk.getIpByGroupNameSync(groupName)
	GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
	if(serverHost and serverHost ~= "")then
		self:multiSocketConnectTest(callback,resolveRets,serverHost,groupName)
	else
		self:multiSocketConnectTest(callback,resolveRets)
	end
end

function FunctionGetIpStrategy:getServerIpAsync( callback,groupName)
	-- body
	if(not self.needComatibility)then
		self:getBestServerIpByAliSdkAsync(callback,groupName)
	else
		self:getIpByAliSdkAsync(callback,groupName)
	end
end

function FunctionGetIpStrategy:getIpByAliSdkAsync( callback,groupName)
	-- body
	-- 首次登陆分组失败即走高防
	if(self.hasConnFailure and not self.isReconnect)then
		local serverHost = self:getNextServerIp()
		LogUtility.InfoFormat(" FunctionGetIpStrategy:getServerIpByAliSdkAsync login try:{0}",groupName)

		if(callback)then
			callback(serverHost)
		end
		return 
		--重连登陆分组尝试两次走高防
	elseif(self.isReconnect and self.hasConnFailure and self.reConnCountInGame > 0)then
		local serverHost = self:getNextServerIp()
		LogUtility.InfoFormat(" FunctionGetIpStrategy:getServerIpByAliSdkAsync reconnect try:{0}",self.reConnCountInGame)
		if(callback)then
			callback(serverHost)
		end
		return 
	elseif(self.isReconnect and self.hasConnFailure)then
		self.reConnCountInGame = self.reConnCountInGame +1
	end

	groupName = groupName and groupName or FunctionGetIpStrategy.Me():getNextServerGroup()
	local useSdk = self:getIfUseAliSdk()
	if(not useSdk)then
		groupName = nil
	end
	LogUtility.InfoFormat(" start FunctionGetIpStrategy:getServerIpByAliSdkAsync groupName:{0}",groupName)
	if(not groupName or groupName == "")then
		local serverHost = self:getNextServerIp()
		if(callback)then
			callback(serverHost)
		end
	else
		self:initALSDK()
		Game.FunctionLoginMono:getIpByGroupNameAsync(groupName,function ( serverHost )
			-- body	
			LogUtility.InfoFormat("end FunctionGetIpStrategy:getServerIpByAliSdkAsync:serverHost:{0}",serverHost)
			if(serverHost and serverHost ~= "")then
				if(callback)then
					callback(serverHost)
				end
			else
				serverHost = self:getNextServerIp()
				if(callback)then
					callback(serverHost)
				end
			end
		end,NetConfig.GetAliyunIpTimeOut)
	end	
end

function FunctionGetIpStrategy:getBestServerIpByAliSdkAsync( callback,groupName)
	-- body
	self:getIpByDomains(function ( resolveRets )
		-- body	
		-- 首次登陆分组失败即走高防
		if(self.hasConnFailure and not self.isReconnect)then
			self:multiSocketConnectTest(callback,resolveRets)
			return 
			--重连登陆分组尝试两次走高防
		elseif(self.isReconnect and self.hasConnFailure and self.reConnCountInGame > 0)then
			self:multiSocketConnectTest(callback,resolveRets)
			return 
		elseif(self.isReconnect and self.hasConnFailure)then
			self.reConnCountInGame = self.reConnCountInGame +1
		end
		if(self:checkIsIpv6(resolveRets))then
			self:multiSocketConnectTest(callback,resolveRets)
			LogUtility.Info(" checkIsIpv6: return true")
		else
			groupName = groupName and groupName or FunctionGetIpStrategy.Me():getNextServerGroup()
			LogUtility.InfoFormat(" start FunctionGetIpStrategy:getServerIpByAliSdkAsync groupName:{0}",groupName)
			local useSdk = self:getIfUseAliSdk()
			if(not useSdk)then
				groupName = nil
			end
			if(not groupName or groupName == "")then
				self:multiSocketConnectTest(callback,resolveRets)
			else
				self:initALSDK()
				Game.FunctionLoginMono:getIpByGroupNameAsync(groupName,function ( serverHost )
					-- body	
					LogUtility.InfoFormat("end FunctionGetIpStrategy:getServerIpByAliSdkAsync:serverHost:{0}",serverHost)
					if(serverHost and serverHost ~= "")then
						self:multiSocketConnectTest(callback,resolveRets,serverHost,groupName)
					else
						self:multiSocketConnectTest(callback,resolveRets)
					end
				end,NetConfig.GetAliyunIpTimeOut)
			end	
		end
	end)
end

function FunctionGetIpStrategy:getIpByDomains(callback)
	-- body
	local domains = NetConfig.NewGateHost
	-- todo xde host
	domains = OverseaHostHelper:GetHosts()
	local fucntionSdk = FunctionLogin.Me():getFunctionSdk()
	if(fucntionSdk)then
		local plat = fucntionSdk:GetPlat()
		plat = tonumber(plat)
		if(plat == 3)then
			domains = NetConfig.NewGateHost_NOTEST
		end
	end
	if(domains and #domains>0)then
		self.dnsrel = FunctionLoginDnsResolve(NetConfig.DnsResolveTimeOut);
		for i=1,#domains do
			local domain = domains[i]
			self.dnsrel:addDomainName(domains[i]);
		end
		self.dnsrel:setCallback(function (resolveRets)
			-- body
			callback(resolveRets)
		end)
		self.dnsrel:tryStartResolve()
	else
		callback()
	end
end

local tempArray = {}
function FunctionGetIpStrategy:multiSocketConnectTest(callback,resolveRets,aliIP,aliGroup)
	-- body	
	self.sts = nil 
	local gatePort = FunctionLogin.Me():getServerPort()
	LogUtility.InfoFormat("multiSocketConnectTest gatePort:{0}",gatePort)
	TableUtility.ArrayClear(tempArray)
	for i=1,#resolveRets do
		local ret = resolveRets[i]
		if(ret.result.state == FunctionLoginDnsResolve.DnsResolveState.Finish and not table.ContainsValue(tempArray,ret.result.ip))then
			if(self.sts == nil)then
				self.sts = FunctionLoginChooseSocket(NetConfig.SocketConnectTestTimeOut)
			end
			self.sts:addIpAndPort(ret.result.ip,gatePort,ret.result.domain);
			table.insert(tempArray,ret.result.ip)
		end
		LogUtility.InfoFormat("FunctionLoginDnsResolve delay:{0},ip:{1},domain:{2}",ret.result.delay,ret.result.ip,ret.result.domain)
		LogUtility.InfoFormat("FunctionLoginDnsResolve state:{0},errorMessage:{1}",ret.result.state,ret.result.errorMessage)
	end

	if(aliIP)then
		if(self.sts == nil)then
			self.sts = FunctionLoginChooseSocket(NetConfig.SocketConnectTestTimeOut)
		end
		self.sts:addIpAndPort(aliIP,gatePort,aliGroup);
	end
	if(self.sts)then
		self.sts:setCallback(function ( connectRets )
				-- body
			local result = self:getBestResult(connectRets)
			self:setCurrentSocketInfo(result)
			if(callback)then
				callback(result)
			end
		end);
		self.sts:tryStartConnect();
	else
		callback()
	end
	
end

function FunctionGetIpStrategy:checkIsIpv6( resolveRets )
	-- body
	if(resolveRets)then
		for i=1,#resolveRets do
			local ret = resolveRets[i]
			if(ret.result.state == FunctionLoginDnsResolve.DnsResolveState.Finish)then
				local ip = ret.result.ip
				if(ip and string.find(ip,":"))then
					return true
				end
			end
		end
	end
end

function FunctionGetIpStrategy:getBestResult( connectRets )
	-- body
	----游戏盾80ms差值内使用游戏盾
	-- return self:getBestResult_1(connectRets)
	--流量能在游戏盾和aws（高防域名）之间相对均衡的分配
	return self:getBestResult_2(connectRets)
end

function FunctionGetIpStrategy:getBestResult_1( connectRets )
	-- body
	local result
	local minDelay = 999999
	for i=1,#connectRets do
		local ret = connectRets[i]
		local isConnected = ret.result.state == FunctionLoginChooseSocket.SocketConnectState.Finish
		local isAli = self:isAliSdk(ret.result.originDomain)
		local delta = isAli and NetConfig.AliyunNetDelayDelta or 0
		LogUtility.InfoFormat("FunctionLoginChooseSocket isAli:{0},delta:{1}",isAli,delta)
		if( isConnected and (ret.result.delay - minDelay < delta))then
			-- sts:addIpAndPort(ret.result.ip,5001,ret.result.domain);
			minDelay = ret.result.delay
			if(result)then
				result:dispose()
			end
			result = ret.result
		else
			ret.result:dispose()
		end
		LogUtility.InfoFormat("FunctionLoginChooseSocket delay:{0},ip:{1},originDomain:{2}",ret.result.delay,ret.result.ip,ret.result.originDomain)
		LogUtility.InfoFormat("FunctionLoginChooseSocket state:{0},errorMessage:{1}",ret.result.state,ret.result.errorMessage)
	end
	return result
end

function FunctionGetIpStrategy:getBestResult_2( connectRets )
	-- body
	local minDelay = 999999
	local result = nil
	local norRet = nil
	local aliRet = nil
	local gfRet = nil
	for i=1,#connectRets do
		local ret = connectRets[i]
		local isConnected = ret.result.state == FunctionLoginChooseSocket.SocketConnectState.Finish
		local isAli = self:isAliSdk(ret.result.originDomain)
		local isGf = self:isGfDomain(ret.result.originDomain)
		-- local delta = isAli and NetConfig.AliyunNetDelayDelta or 0
		if( isConnected and isAli )then
			aliRet = ret.result
		elseif( isConnected and isGf )then
			gfRet = ret.result
		elseif(isConnected and (ret.result.delay < minDelay ))then
		-- sts:addIpAndPort(ret.result.ip,5001,ret.result.domain);
			minDelay = ret.result.delay
			norRet = ret.result
		end
		
		LogUtility.InfoFormat("FunctionLoginChooseSocket isAli:{0},isGf:{1}",isAli,isGf)
		LogUtility.InfoFormat("FunctionLoginChooseSocket delay:{0},ip:{1},originDomain:{2}",ret.result.delay,ret.result.ip,ret.result.originDomain)
		LogUtility.InfoFormat("FunctionLoginChooseSocket state:{0},errorMessage:{1}",ret.result.state,ret.result.errorMessage)
	end
	local aliOk = false
	local gfOk = false
	local maxDelta = 20
	local delta
	if(aliRet)then
		if(norRet)then
			delta = aliRet.delay - norRet.delay
			if(delta < maxDelta)then
				aliOk = true
			end
		else
			aliOk = true
		end
	end

	if(gfRet)then
		if(norRet)then
			delta = gfRet.delay - norRet.delay
			if(delta < maxDelta)then
				gfOk = true
			end
		else
			gfOk = true
		end
	end


	if(aliOk and gfOk)then
		local ret = (math.random(2) == 1)
		if(ret)then
			result = aliRet
			LogUtility.Info("FunctionLoginChooseSocket Choose Ali by random")
		else
			result = gfRet
			LogUtility.Info("FunctionLoginChooseSocket Choose GF by random")
		end
	elseif(aliOk)then
		result = aliRet
		LogUtility.Info("FunctionLoginChooseSocket Choose Ali")
	elseif(gfOk)then
		result = gfRet
		LogUtility.Info("FunctionLoginChooseSocket Choose GF")
	else
		result = norRet
		LogUtility.Info("FunctionLoginChooseSocket Choose Other")
	end

	if nil ~= result then
		LogUtility.InfoFormat("FunctionLoginChooseSocket Choose: delay:{0},ip:{1},originDomain:{2}",
			result.delay,result.ip,result.originDomain)
	end

	for i=1,#connectRets do
		local ret = connectRets[i].result
		if(ret ~= result)then
			ret:dispose()
		end
	end
	return result
end

function FunctionGetIpStrategy:checkResultIsOk( result,connectRets )
	-- body
	local result
	local minDelay = 999999
	local maxDelta = 100
	local isAli = self:isAliSdk(result.originDomain)
	local isGf = self:isGfDomain(result.originDomain)
	for i=1,#connectRets do
		local ret = connectRets[i]
		if(result ~= ret.result)then
			local isConnected = ret.result.state == FunctionLoginChooseSocket.SocketConnectState.Finish		
			LogUtility.InfoFormat("FunctionLoginChooseSocket isAli:{0},isGf:{1},delta:{2}",isAli,isGf,delta)
			if( isConnected and (result.delay - minDelay < maxDelta))then
				-- sts:addIpAndPort(ret.result.ip,5001,ret.result.domain);
				minDelay = ret.result.delay
				if(result)then
					result:dispose()
				end
				result = ret.result
			end
		end
	end
end

function FunctionGetIpStrategy:isAliSdk( originDomain )
	-- body
	local domains = NetConfig.NewGateHost	
	for i=1,#domains do
		if(originDomain == domains[i])then
			return false
		end		
	end

	domains = NetConfig.NewGateHost_NOTEST
	for i=1,#domains do
		if(originDomain == domains[i])then
			return false
		end		
	end

	return true
end

function FunctionGetIpStrategy:isGfDomain( originDomain )
	-- body
	return (originDomain == NetConfig.NewGateHostGf)
end

function FunctionGetIpStrategy:isForeignDomain( originDomain )
	-- body
	if(originDomain == NetConfig.NewGateHostFg)then
		return true
	end
end

function FunctionGetIpStrategy:GameEnd( )
	if(self.dnsrel)then
		self.dnsrel:setCallback(nil)
	end

	if(self.sts)then
		self.dnsrel:setCallback(nil)
	end
end