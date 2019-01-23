FunctionLogin = class("FunctionLogin")
autoImport("FunctionLoginXd")
autoImport("FunctionLoginAny")
autoImport("FunctionLoginTXWY")
autoImport("FunctionGetIpStrategy")
autoImport("ScenicSpotPhotoNew")
autoImport("GamePhoto")
-- todo xde host
autoImport('OverseaHostHelper')
autoImport('FunctionLoginAnnounce')
--登陆成功后
--1 获取验证accessToken 的ip地址
--2 验证accessToken
FunctionLogin.AuthStatus = {
	Ok = 0,
	OherError = 1,
	GetServerListFailure = 2,
	CreateRoleFailure = 3,
	NoActive =  9,
}

FunctionLogin.LoginCode = {
	SdkLoginCancel = 1,
	SdkLoginSuc = 2,
	SdkLoginFailure = 3,
	SdkLoginNoneSdkType = 4
}
 
FunctionLogin.ErrorCode = {
	RequestAuthAccToken_NoneToken = 2001,  -- 请求验证token时，token为空
	StartActive_NoneToken = 2002,   -- 请求激活时，token为空
	CheckAccTokenValid_Failure_GetServerListFailure = 2005, -- 校验 账号信息 失败（服务器列表错误）
	CheckAccTokenValid_Failure_CreateRoleFailure = 2006,-- 校验 账号信息 失败（创建角色错误）
	Login_TokenInValid =  2010, -- token 无效
	LoginDataHandler_ServerListEmpty =  2011, -- 服务器列表为空
	Login_SDKLoginFailure = 2008,  --sdk登陆失败
	Login_SDKLaunchFailure =  2009,  -- sdk 启动失败
	Login_SDKLoginCancel = 2012,  --sdk登陆取消
	StartGameLogin_NoneSdkType = 2013,  --sdk Type 未知
	AuthHostHandler_Failure = 10000,  -- 获取 验证token地址 失败
	LoginDataHandler_Failure = 30000,   -- 校验玩家账号信息失败
	HandleConnectServer = 40000,  --连接游戏网关失败
	InvalidServerIP = 50000,  --没有可用的代理

	--todo xde add code
	LoginAnnounceError = 900000, -- 获取公告失败
	LoginAnnounceFormatError = 900001 -- 解析公告内容失败（JSON）
}

function FunctionLogin.Me()
	if nil == FunctionLogin.me then
		FunctionLogin.me = FunctionLogin.new()
	end
	return FunctionLogin.me
end

function FunctionLogin:ctor()
	self.gatePort = nil

	self.AsyncGetAliIp = false
	self.connectTime = 0

	self.reconnectTimes = 0
	self.delayTime = 0


	---Debug!!!-Debug!!!Debug!!!Debug!!!Debug!!!Debug!!!Debug!!!----------------
	
	-----Important!!!!!!!!! 线上一定要为false
	self.privateMode = false -- todo xde 默认false
	self.PrivatePlat = 90
	-----Important!!!!!!!!! 线上一定要为false

	--！！！！！！！！！参数随时可能更新，找素质最差的要具体参数（刘老湿和卖豆浆的）！！！！！！！！！！！！！！！！！！！！！！！！
	self.ShowWeChat = not Game.inAppStoreReview
	self.Debug = false  -- todo xde 默认 false
	--self.debugServerVersion = "1.0.15" todo xde
	self.debugServerVersion = "1.0.0"
	self.debugPlat = 1  -- (萌动首测: 2 ,预言之地: 3, 正式服: 1)
	self.debugServerPort = 8888 -- 正式服：5025/5023 预言之地：5001  萌动首测：xxx tw 8888 --todo xde
	self.debugAuthPort = 5003 -- 正式服：5003 预言之地：5002  萌动首测：xxxx
	self.debugClientCode = 13
	local tokens = {
		LXY = "1ec43da401cc32a3ac49a9174e8b5610",
		ZGB = "c8835efca46e0403a7afbd8bd9269c07",
		STB = "cada1fbebab105edc9f2e7a087daaa9f",
		HJY = "fa72c04c7993917886766c87255e6c4e",
		KM = "5396f64b0d8207d8eaea75d9c6848af0",
		-- "無双狂艹"
		WSKC = "b67c8c4ea1b8fa2c097adc424b171f41", 
		TXWY = ""
	}
--	self.debugToken = tokens.ZGB --todo xde
	self.debugToken = tokens.TXWY
end

function FunctionLogin:StartActive( cdKey,callback )
	-- body
	local fucntionSdk = self:getFunctionSdk()
	if(fucntionSdk)then
		fucntionSdk:StartActive(cdKey,callback)
	end
end

function FunctionLogin:requestGetUrlHost( url ,callback,address,privateMode)
	-- body
	local phoneplat  = "editor"
	local runtimePlatform = ApplicationInfo.GetRunPlatform()
	if(runtimePlatform== RuntimePlatform.Android) then
		phoneplat = "Android"
	elseif(runtimePlatform == RuntimePlatform.IPhonePlayer)then
		phoneplat = "iOS"
	end
	local timestamp = os.time()
	timestamp = string.format("&timestamp=%s&phoneplat=%s",timestamp,phoneplat)
	local requests = HttpWWWSeveralRequests()
	if(privateMode or self.privateMode)then
		local ip = NetConfig.PrivateAuthServerUrl
		ip = string.format("http://%s%s%s",ip,url,timestamp)
		LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost address url:{0}",ip)
		local order = HttpWWWRequestOrder(ip,NetConfig.HttpRequestTimeOut,nil,false,true)
		requests:AddOrder(order)
	elseif(address and "" ~= address)then
		local ip = address
		ip = string.format("https://%s%s%s",ip,url,timestamp)
		LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost address url:{0}",ip)
		local order = HttpWWWRequestOrder(ip,NetConfig.HttpRequestTimeOut,nil,false,true)
		requests:AddOrder(order)
	else
		local ips = FunctionGetIpStrategy.Me():getRequestAddresss()
		for i=1,#ips do
			local ip = ips[i]					
			ip = string.format("https://%s%s%s",ip,url,timestamp)
			LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost url:{0}",ip)
			local order = HttpWWWRequestOrder(ip,NetConfig.HttpRequestTimeOut,nil,false,true)
			requests:AddOrder(order)
		end
	end
	requests:SetCallBacks(function(response)
			-- callback(response.Status,response.resString)
			callback(NetConfig.ResponseCodeOk,response.resString)
		end,
		function ( order )
			-- body
			local IsOverTime = order.IsOverTime
			LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost IsOverTime:{0}",IsOverTime)
			LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost occur error,url:{0},address:{1},errorMsg:{2}",url,address,order.orderError)
			callback(FunctionLogin.AuthStatus.OherError, order)
		end)
	requests:StartRequest()
end

function FunctionLogin:LoginDataHandler(status,content,callback)
	-- body
	local functionSdk = self:getFunctionSdk()
	if(functionSdk)then
		functionSdk:LoginDataHandler(status,content,callback)
	end
end

function FunctionLogin:connectGameServer( callback,isRestart )
	-- body
	if(self.AsyncGetAliIp)then
		FunctionGetIpStrategy.Me():getServerIpAsync(function ( result )
			-- body
			local port = self:getServerPort()
			if(result and result ~= "")then				--
				local serverHost = result.ip and result.ip or result
				LogUtility.InfoFormat("getServerIpAsync,serverHost:{0} port:{1}",serverHost,port)
				if(result.socket and not Slua.IsNull(result.socket))then
					Game.NetConnectionManager:setSocket(result.socket)
					self.netDelay = result.delay
					self:handleConnectServer(NetState.Connect,callback,isRestart)
				else
					 NetManager.ConnGameServer(serverHost, port,function (state,netDelay)
						self.netDelay = netDelay
						self:handleConnectServer(state,callback,isRestart)
					end)
				end
			else
				--no server ip is avaliable
--				MsgManager.ShowMsgByIDTable(1017,{FunctionLogin.ErrorCode.InvalidServerIP})
                --  todo xde show static cdn ann
                FunctionLoginAnnounce.Me():showCDNAnnounce()
				GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
			end
		end)
	else
		local port = self:getServerPort()
		if(self.privateMode)then

--			local serverHost = NetConfig.PrivateGameServerUrl
--			NetManager.ConnGameServer(serverHost, port,function (state,netDelay)
--				self.netDelay = netDelay
--				self:handleConnectServer(state,callback,isRestart)
			-- todo xde debug
			FunctionGetIpStrategy.Me():getServerIpSync(function ( result )
				-- body
				if(result and result ~= "")then				--
					local serverHost = result.ip and result.ip or result
					LogUtility.InfoFormat("getServerIpAsync,serverHost:{0} port:{1}",serverHost,port)
					if(result.socket and not Slua.IsNull(result.socket))then
						Game.NetConnectionManager:setSocket(result.socket)
						self.netDelay = result.delay
						self:handleConnectServer(NetState.Connect,callback,isRestart)
					else
						NetManager.ConnGameServer(serverHost, port,function (state,netDelay)
							self.netDelay = netDelay
							self:handleConnectServer(state,callback,isRestart)
						end)
					end
				else
					--no server ip is avaliable
					--MsgManager.ShowMsgByIDTable(1017,{FunctionLogin.ErrorCode.InvalidServerIP})
                    --  todo xde show static cdn ann
                    FunctionLoginAnnounce.Me():showCDNAnnounce()
					GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
				end
			end)
		else
			FunctionGetIpStrategy.Me():getServerIpSync(function ( result )
				-- body
				if(result and result ~= "")then				--
					local serverHost = result.ip and result.ip or result
					LogUtility.InfoFormat("getServerIpAsync,serverHost:{0} port:{1}",serverHost,port)
					if(result.socket and not Slua.IsNull(result.socket))then
						Game.NetConnectionManager:setSocket(result.socket)
						self.netDelay = result.delay
						self:handleConnectServer(NetState.Connect,callback,isRestart)
					else
						 NetManager.ConnGameServer(serverHost, port,function (state,netDelay)
							self.netDelay = netDelay
							self:handleConnectServer(state,callback,isRestart)
						end)
					end
				else
					--no server ip is avaliable
--					MsgManager.ShowMsgByIDTable(1017,{FunctionLogin.ErrorCode.InvalidServerIP})
                    --  todo xde show static cdn ann
                    FunctionLoginAnnounce.Me():showCDNAnnounce()
					GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
				end
			end)
		end
		
	end
end

function FunctionLogin:connectLanGameServer( accid,callback,isRestart )
	-- body
	local ips = self:getServerIp()
	local ip = ips[1]
	local port = self:getServerPort()
	--test start
	-- ip = "fe80::14d8:a209:89e6:c162%14"
	-- port = 9000
	--test end
	LogUtility.InfoFormat("FunctionLogin:connectLanGameServer(  )ip:{0},port:{1} accid:{2}",ip,port,tostring(accid))
	GameFacade.Instance:sendNotification(NewLoginEvent.StartLogin)	
	NetManager.ConnGameServer(ip, port,function (state,netDelay)
		self.netDelay = netDelay
		self:handleConnectLanServerSuccess(state,accid,callback,isRestart)
	end)
end

function FunctionLogin:handleConnectLanServerSuccess( state,accid,callback,isRestart )
	-- body
	self.recvReqLoginParamCallback = callback
	LogUtility.InfoFormat("handleConnectLanServerSuccess:state:{0}",state)
	if state ~= NetState.Connect then
		FunctionGetIpStrategy.Me():setHasConnFailure(true)

		if(not isRestart and state ~= 10051)then
			if(self:startTryReconnectLan(accid,callback,isRestart))then
				return
			end
		end
		
		self:clearReconnectRelated()
		if(isRestart)then
			-- FunctionNetError.Me():ShowErrorById(4)
		else
			UIWarning.Instance:HideBord()
			if(state == NetState.Timeout  or state == 10051)then
				FunctionNetError.Me():ShowErrorById(11)	
			else
				MsgManager.ShowMsgByIDTable(1017,{FunctionLogin.ErrorCode.HandleConnectServer + state})
			end
		end
		GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
		-- GameFacade.Instance:sendNotification(NewLoginEvent.ConnectServerFailure)
	else
		FunctionGetIpStrategy.Me():setHasConnFailure(false)

		local accid = tonumber(accid)
		LogUtility.InfoFormat("CallReqLoginParamUserCmd:accid:{0}",accid)
		GameFacade.Instance:sendNotification(NewLoginEvent.ReqLoginUserCmd)
		ServiceLoginUserCmdProxy.Instance:CallReqLoginParamUserCmd(accid)
		self:HandleConnectSus()
	end
end

function FunctionLogin:RecvReqLoginParamUserCmd( data )
	-- body
	local loginData = {}
	loginData.sha1 = data.sha1
	loginData.accid = data.accid
	loginData.timestamp = data.timestamp
	loginData.zoneid = self.ServerZone
	GamePhoto.SetPlayerAccount(data.accid)
	self:setLoginData(loginData)
	if(self.recvReqLoginParamCallback)then
		self.recvReqLoginParamCallback()
	end
end

function FunctionLogin:clearConnectTime(  )
	-- body
	self.connectTime = 0
end

function FunctionLogin:handleConnectServer( state ,callback,isRestart)
	-- body
	LogUtility.InfoFormat("handleConnectServer:state:{0}",state)
	if state ~= NetState.Connect then
		FunctionGetIpStrategy.Me():setHasConnFailure(true)
		if(not isRestart and state ~= 10051)then
			if(self:startTryReconnect(callback,isRestart))then
				return
			end
		end
		self:clearReconnectRelated()
		if(isRestart)then
			-- FunctionNetError.Me():ShowErrorById(4)
		else
			UIWarning.Instance:HideBord()
			if(state == NetState.Timeout or state == 10051)then
				FunctionNetError.Me():ShowErrorById(11)	
			else
				MsgManager.ShowMsgByIDTable(1017,{FunctionLogin.ErrorCode.HandleConnectServer + state})
			end
		end
		GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
	else
		FunctionGetIpStrategy.Me():setHasConnFailure(false)
		self:clearReconnectRelated()
		self:HandleConnectSus()
		self:LoginUserCmd()
		if(callback)then
			callback()
		end
	end
end

function FunctionLogin:startTryReconnect(callback, isRestart)
	-- body
	if(self.reconnectTimes < 5)then
		local port = self:getServerPort()
		if(self.reconnectTimes == 0)then
			GameFacade.Instance:sendNotification(NewLoginEvent.StartReconnect)
		end
		if(self.delayTime and self.delayTime >0)then
			LeanTween.delayedCall(self.delayTime,function (  )
				self:connectGameServer(callback,isRestart)
			end)
		else
			self:connectGameServer(callback,isRestart)
		end
		self.reconnectTimes = self.reconnectTimes+1
		self.delayTime = self.delayTime + self.reconnectTimes + math.random()*self.reconnectTimes
		return true
	end
	return false
end

function FunctionLogin:clearReconnectRelated( )
	-- body
	self.reconnectTimes = 0
	self.delayTime = 0
	GameFacade.Instance:sendNotification(NewLoginEvent.StopReconnect)
end

function FunctionLogin:startTryReconnectLan(accid,callback, isRestart)
	-- body
	if(self.reconnectTimes < 5)then
		local port = self:getServerPort()
		if(self.reconnectTimes == 0)then
			GameFacade.Instance:sendNotification(NewLoginEvent.StartReconnect)
		end

		if(self.delayTime and self.delayTime >0)then
			LeanTween.delayedCall(self.delayTime,function (  )
				self:connectLanGameServer(accid,callback,isRestart)
			end)
		else
			self:connectLanGameServer(accid,callback,isRestart)
		end
		self.reconnectTimes = self.reconnectTimes+1
		self.delayTime = self.delayTime + self.reconnectTimes + math.random()*self.reconnectTimes
		return true
	end
	return false
end

function FunctionLogin:stopTryReconnect( )
	-- body
	self:clearReconnectRelated()
	ServiceConnProxy.Instance:StopHeart(  )
end

function FunctionLogin:HandleConnectSus( )
	-- body
	ServiceConnProxy.Instance:HandleConnect()
end

function FunctionLogin:getServerVersion( )
	-- body
	local version = VersionUpdateManager.CurrentServerVersion
	version = version == nil and self.debugServerVersion or version
	if AppEnvConfig.IsTestApp then
		version = self.debugServerVersion
	end
	version = tostring(version)
	return version
end

function FunctionLogin:LoginUserCmd()
	-- body
	local loginData = self:getLoginData()
	if(not loginData)then
		GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
		return 
	end
	local accid = loginData.accid
	local sha1 = tostring(loginData.sha1)
	local timestamp = tonumber(loginData.timestamp)
	local zoneid = tonumber(self.ServerZone)
	local version = self:getServerVersion()
	local socketInfo = FunctionGetIpStrategy.Me():getCurrentSocketInfo()
	local domain 
	local ip 
	if(socketInfo)then
		ip = socketInfo.ip
		domain = socketInfo.domain
	end

	local device  = "editor"
	local runtimePlatform = ApplicationInfo.GetRunPlatform()
	if(runtimePlatform== RuntimePlatform.Android) then
		device = "android"
	elseif(runtimePlatform == RuntimePlatform.IPhonePlayer)then
		device = "ios"
	end
	local phone = self:getPhoneNum()
	local param = self:getSecurityParam()

	local loginVersion = self:getLoginVersion()
--	local zone = ApplicationInfo.GetSystemLanguage()
	--todo xde 使用服务器返回的zone
	local zone = OverseaHostHelper.langZone;
	OverseaHostHelper:ResetSectors(zoneid)
	helplog("send to server langzong:".. zone)
	local site = self:getLoginSite() or 0
	site = tonumber(site)
	local authoriz = self:getLogin_authoriz_state()
	authoriz = tostring(authoriz)

	-- local userIp = DeviceInfo.GetUserIp()
	LogUtility.InfoFormat("FunctionLogin:LoginUserCmd CallReqLoginUserCmd:zoneid:{0},version:{1}",zoneid,version)
	LogUtility.InfoFormat("accid:{0},sha1:{1}",accid,sha1)
	LogUtility.InfoFormat("netDelay:{0},userIp:{1}",self.netDelay,userIp)
	LogUtility.InfoFormat("ip:{0},domain:{1}",ip,domain)
	LogUtility.InfoFormat("param:{0},zone:{1},zonId:{2}",param,zone,zoneid)
	ServiceLoginUserCmdProxy.Instance:CallServerTimeUserCmd()
	ServiceLoginUserCmdProxy.Instance:CallReqLoginUserCmd(accid, sha1, zoneid, timestamp,version,domain,ip,device,phone,param,zone,site,authoriz)

	-- printRed("--------------self.netDelay",self.netDelay)
	self.netDelay = self.netDelay > 0 and self.netDelay or 0
	ServiceLoginUserCmdProxy.Instance:CallClientInfoUserCmd(nil,self.netDelay)

	GameFacade.Instance:sendNotification(NewLoginEvent.ReqLoginUserCmd)
end

function FunctionLogin:reStartGameLogin( callback  )
	-- body	
	local sdkEnable = self:getSdkEnable()
	local loginData = self:getLoginData()
	FunctionGetIpStrategy.Me():setReConnectState( true )	
	if(sdkEnable)then
		-- InternetUtil.Ins:InternetIsValid(function (result)
		LogUtility.InfoFormat("reStartGameLogin sdkEnable:{0} self.ServerZone:{1}",sdkEnable,self.ServerZone)
		local functionSdk = self:getFunctionSdk()
		if(functionSdk)then
			-- functionSdk:setLoginData(nil)
			functionSdk:startSdkGameLogin(function()
				self:connectGameServer(callback,true)
			end)
		end
	else
		self:connectLanGameServer(loginData.accid,callback,true)
	end
end

function FunctionLogin:LaunchSdk( callback )
	-- body
	LogUtility.Info("FunctionLogin:LaunchSdk()")
	local fucntionSdk = self:getFunctionSdk()
	if(fucntionSdk)then
		fucntionSdk:LaunchSdk(callback)
	end
end

function FunctionLogin:startSdkLogin( callback )
	-- body
	local fucntionSdk = self:getFunctionSdk()
	if(fucntionSdk)then
		fucntionSdk:startSdkLogin(callback)
	end
end

function FunctionLogin:startAuthAccessToken( callback )
	-- body
	LogUtility.Info("FunctionLogin:startAuthAccessToken()")
	local fucntionSdk = self:getFunctionSdk()
	if(fucntionSdk)then
		Debug.Log("FunctionLogin:startAuthAccessToken1")
		fucntionSdk:startAuthAccessToken(callback)
	end
end

function FunctionLogin:startGameLogin(serverData ,accid,callback)
	ServiceConnProxy.Instance:StopHeart(  )
	LogUtility.InfoFormat("FunctionLogin:startGameLogin(  ) loginData and accid:{0}",accid)
	local SDKEnable = self:getSdkEnable()
	-- SDKEnable = false
	if(accid and not SDKEnable)then
		self.serverData = serverData
		self.ServerZone = serverData.serverid
		self:connectLanGameServer(accid,callback)
	else
		local loginData = self:getLoginData()
		local isLogined = self:isLogined()
		--未登录 or 退出登陆
		if(not isLogined or not loginData)then
			local functionSdk = self:getFunctionSdk()
			if(functionSdk)then
				--TODO 
				functionSdk:setLoginData(nil)
				functionSdk:startSdkGameLogin(callback )
			end
		else
			self.serverData = serverData
			self.ServerZone = serverData.serverid
			--todo xde 全球版多个区域选择 连接前记录本次选择
			helplog('connect store serverid' .. self.ServerZone)
			helplog(OverseaHostHelper.PlayerPrefsMYServer)
			PlayerPrefs.SetInt(OverseaHostHelper.PlayerPrefsMYServer,tonumber(self.ServerZone) or 0)
			self:connectGameServer(callback)
		end		
	end
end

function FunctionLogin:createRole(name,role_sex, profession,hair, haircolor, clothcolor, index)
	-- body
	haircolor = haircolor or 0
	bodycolor = bodycolor or 0
	name = tostring(name)
	role_sex = tonumber(role_sex) or 0
	profession = tonumber(profession) or 0
	hair = tonumber(hair) or 1
	haircolor = tonumber(haircolor) or 0
	clothcolor = tonumber(clothcolor) or 0
	index = index or 0
	ServiceLoginUserCmdProxy.Instance:CallCreateCharUserCmd(name, role_sex, profession, hair, haircolor, clothcolor, nil, index)
end

function FunctionLogin:getSdkEnable(  )
	-- body
	if(self.Debug)then
		return true
	else
		local SDKEnable = EnvChannel.SDKEnable()
--		 LogUtility.InfoFormat("SDKEnable:{0}",SDKEnable)
		return SDKEnable
	end
end

function FunctionLogin:getSdkType(  )
	-- body
	if(self.Debug)then
		-- return FunctionSDK.E_SDKType.Any -- todo xde
		return FunctionSDK.E_SDKType.TXWY
	else
		return FunctionSDK.Instance.CurrentType
	end
end

function FunctionLogin:isLogined(  )
	-- body
	local functionSdk = self:getFunctionSdk()
	if(functionSdk)then
		return functionSdk:isLogined()
	end
end

function FunctionLogin:isDebug(  )
	-- body
	return self.Debug
end

function FunctionLogin:isPrivateMode(  )
	-- body
	return self.privateMode
end

function FunctionLogin:getServerDatas(  )
	-- body
	local functionSdk = self:getFunctionSdk()
	if(functionSdk)then
		return functionSdk:getServerDatas()
	end
end

function FunctionLogin:getCurServerData(  )
	-- body
	return self.serverData
end

function FunctionLogin:replaceBracket( arg )
	-- body
	local str = string.gsub(arg,"{","(")
	str = string.gsub(str,"}",")")
	return str
end

function FunctionLogin:getDefaultServerData()
	local functionSdk = self:getFunctionSdk()
	if(functionSdk)then
		return functionSdk:getDefaultServerData()
	end
end

function FunctionLogin:getServerIp(  )
	-- body
	local ips
	if(self:getSdkEnable())then
		ips = EnvChannel.GetPublicIP()
	else
		ips = self.serverData.type ==2 and EnvChannel.GetPublicIP() or { NetConfig.PrivateGameServerUrl }
	end
	return ips
end

function FunctionLogin:setLoginData(data)
	self.loginData = data
	LogUtility.InfoFormat("setLoginData:accid:{0}",self.loginData.accid)
	local accid = tonumber(self.loginData.accid)
	self.loginData.accid = accid
	FunctionGetIpStrategy.Me():setAccId(accid)
end

function FunctionLogin:getLoginData()
	local sdkEnable = self:getSdkEnable()
	if(sdkEnable)then
		local functionSdk = self:getFunctionSdk()
		if(functionSdk)then
			return functionSdk:getLoginData()
		end
	else
		return self.loginData
	end
end

function FunctionLogin:getFunctionSdk(  )
	-- body
	-- todo xde
--	local runtimePlatform = ApplicationInfo.GetRunPlatform()
--	if runtimePlatform == RuntimePlatform.Android then
--		if(not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13)) then
--			return FunctionLoginXd.Me()
--		end
--	end
	local sdkType = self:getSdkType()
	if(sdkType == FunctionSDK.E_SDKType.Any)then
		return FunctionLoginAny.Me()
	elseif(sdkType == FunctionSDK.E_SDKType.XD)then
		return FunctionLoginXd.Me()
	elseif(sdkType == FunctionSDK.E_SDKType.TXWY)then
		return FunctionLoginTXWY.Me()
	else
		MsgManager.ShowMsgByIDTable(1017,{FunctionLogin.ErrorCode.StartGameLogin_NoneSdkType})
		GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
	end
end

function FunctionLogin:setServerPort(port)
	self.gatePort = port
end

function FunctionLogin:getServerPort()
	if(not self.gatePort)then
		local port = EnvChannel.GetPublicPort()
		if(self.Debug)then
			port = self.debugServerPort
		end
		if(self.privateMode)then
			port = NetConfig.PrivateGameServerUrlPort
		end
		if(self:getSdkEnable())then
			local verStr = VersionUpdateManager.serverResJsonString
			LogUtility.InfoFormat("FunctionLogin:getServerPort() verStr:{0}",verStr)
			local result = StringUtil.Json2Lua(verStr)
			if(result and result["data"])then
				local data = result["data"]
				local tmp = tonumber(data["gateport"])
				port = tmp and tmp or port
			end
		else
			if(self.serverData.type ~= 2)then
				port = NetConfig.PrivateGameServerUrlPort
			end
		end


		if(self.Debug)then
			port = self.debugServerPort
		end

		self.gatePort = port
		LogUtility.InfoFormat("FunctionLogin:getServerPort() gatePort:{0}",port)
	end
	return self.gatePort
end

function FunctionLogin:setSecurityParam(param)
	self.securityParam = param
end

function FunctionLogin:getSecurityParam()
	return self.securityParam
end

function FunctionLogin:getPhoneNum()
	return self.phoneNum
end

function FunctionLogin:setPhoneNum(phoneNum)
	self.phoneNum = phoneNum
end

function FunctionLogin:getLoginSite()
	return self.site
end

function FunctionLogin:setLoginSite(site)
	helplog("setLoginSite:",site)
	self.site = site
end

function FunctionLogin:getLoginVersion()
	return self.loginVersion
end

function FunctionLogin:setLoginVersion(loginVersion)
	self.loginVersion = loginVersion
end

function FunctionLogin:setLogin_authoriz_state(login_authoriz_state)
	helplog("setLogin_authoriz_state:",login_authoriz_state)
	self.login_authoriz_state = login_authoriz_state
end

function FunctionLogin:getLogin_authoriz_state(login_authoriz_state)
	return self.login_authoriz_state
end

function FunctionLogin:set_realName_Centified(b)
	self.realName_Centified = b;
end

function FunctionLogin:get_realName_Centified()
	return self.realName_Centified;
end

function FunctionLogin:set_IsTmp(is_tmp)
	self.is_tmp = is_tmp;
end

function FunctionLogin:get_IsTmp()
	return self.is_tmp;
end

--todo xde 修复 callback
function FunctionLogin:launchAndLoginSdk(callback)
	-- body
	local runtimePlatform = ApplicationInfo.GetRunPlatform()
	if runtimePlatform == RuntimePlatform.Android then
		if(not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13)) then
			self:LaunchSdk(function ( state ,msg)
				-- body
				if(state)then
					self:startSdkLogin(function ( code,msg )
					-- body
						if(code == FunctionLogin.LoginCode.SdkLoginSuc)then
							self:startAuthAccessToken(callback)
						else
							-- MsgManager.ShowMsgByIDTable(1017,FunctionLogin.ErrorCode.StartGameLogin_NoneSdkType)
							--TODO
							GameFacade.Instance:sendNotification(NewLoginEvent.SDKLoginFailure)
						end
					end)
				else
				--TODO
					GameFacade.Instance:sendNotification(NewLoginEvent.LaunchFailure)
				end
			end)
			return
		end
	end

	self:LaunchSdk(function (state ,msg)
		-- body
		local sdkType = FunctionLogin.Me():getSdkType()
		if(state)then
			self:startSdkLogin(function ( code,msg )
			-- body
				if(code == FunctionLogin.LoginCode.SdkLoginSuc)then
					if(sdkType == FunctionSDK.E_SDKType.XD or sdkType == FunctionSDK.E_SDKType.TXWY)then
						self:startAuthAccessToken(callback)
					else
						self:LoginDataHandler(NetConfig.ResponseCodeOk,msg,callback)
					end
				else
					-- MsgManager.ShowMsgByIDTable(1017,FunctionLogin.ErrorCode.StartGameLogin_NoneSdkType)
					--TODO
					GameFacade.Instance:sendNotification(NewLoginEvent.SDKLoginFailure)
				end
			end)
		else
			--TODO
			GameFacade.Instance:sendNotification(NewLoginEvent.LaunchFailure)
		end
	end)
end

function FunctionLogin:GetRealNameCentifyUrl(realname, realid)
	local authUrl = NetConfig.AccessTokenRealNameCentifyUrl_Xd;

	local sdkEnable = self:getSdkEnable();

	local port;
	local token;
	if(not sdkEnable)then
		token = FunctionLogin.Me().debugToken;
		port = 5556;
	else
		local login = self:getFunctionSdk();
		if(login)then
			token = login:getToken();
			port = login:GetAuthPort();
		end
	end

	return string.format(":%s%s%s&is_tmp=%s&realname=%s&realid=%s",port,authUrl,token,self.is_tmp or 0,realname,realid)
end

function FunctionLogin:SyncServerDID(  )
	local url = NetConfig.SyncDidUrl
	local customVersion = GameConfig.DidVersion or 1
	local pfKey = string.format("RO_DeviceID_%s",customVersion)
	local value = PlayerPrefs.GetString(pfKey)
	local timestamp = os.time()

	local token
	local login = self:getFunctionSdk();
	if(login)then
		token = login:getToken();
	end
	token = token and token or ""
	if(not value or value == "")then
		local did = DeviceInfo.GetID()
		value = string.format("%s:%s:%s",did,timestamp,customVersion)
		PlayerPrefs.SetString(pfKey,value)
		helplog("保存设备DID:",value)
	else
		helplog("获取设备DID:",value)
	end
	url = string.format(url,value,token)
	FunctionLoginAnnounce.Me():doRequest(url,function ( status,content )
		-- body
		helplog("同步设备DID完成！",status,content)
	end)
end
