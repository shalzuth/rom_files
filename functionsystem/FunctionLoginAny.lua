autoImport("FunctionLoginBase")
FunctionLoginAny = class("FunctionLoginAny",FunctionLoginBase)

function FunctionLoginAny.Me()
	if nil == FunctionLoginAny.me then
		FunctionLoginAny.me = FunctionLoginAny.new()	
	end
	return FunctionLoginAny.me
end

function FunctionLoginAny:startSdkGameLogin( callback )
	-- body
	--TODO 登陆 重新登陆
	LogUtility.InfoFormat("FunctionLoginAny:isLogined:{0}",self:isLogined())
	local isLogined = self:isLogined()
	if(not isLogined or not self.loginData)then
		local CompatibilityMode_V9 = BackwardCompatibilityUtil.CompatibilityMode_V9
		if(CompatibilityMode_V9)then
			self:startSdkLogin(function (code,msg)
				-- body
				self:SdkLoginHandler(code,msg,function (  )
					-- body
					self:LoginDataHandler(NetConfig.ResponseCodeOk,msg,callback)
				end)
			end)
		else
			self:startSdkLoginNew(function (code,msg)
				-- body
				self:SdkLoginHandler(code,msg,function (  )
					-- body
					self:LoginDataHandler(NetConfig.ResponseCodeOk,msg,callback)
				end)
			end)
		end
		
	--登陆成功
	else
		if(callback)then
			callback()
		end
	end
end

-- function FunctionLoginAny:AnySDKLogin( serverId,url,susCal,failCal,canCal )
-- 	failCal("test failCal")
-- end

function FunctionLoginAny:startSdkLoginNew( callback )
	-- body
	local launchScs = self:isInitialized()
	LogUtility.InfoFormat("FunctionLoginAny:startSdkLoginNew(  ) Launch result:{0}",launchScs)
	if(launchScs)then
		local authUrl = self:getAuthUrl()
		LogUtility.InfoFormat("FunctionLoginAny:startSdkLoginNew(  ) authUrl:{0}",authUrl)
		FunctionSDK.Instance:AnySDKLogin("",authUrl,function (sucMsg )
		-- self:AnySDKLogin("",authUrl,function (sucMsg )
			LogUtility.InfoFormat("startSdkLoginNew sucMsg:{0}",sucMsg)
			if(callback)then
				callback(FunctionLogin.LoginCode.SdkLoginSuc,sucMsg)
			end
			self:resetRetryTime()

		end,function ( failMsg )
			-- body
			local bRetry = self:checkIfNeedRetry()
			LogUtility.InfoFormat("FunctionLoginAny:startSdkLoginNew(  ) bRetry:{0}",bRetry)
			if(bRetry)then
				self:startRetryLogin(callback)
				return
			end
			self:resetRetryTime()
			if(callback)then
				callback(FunctionLogin.LoginCode.SdkLoginFailure,failMsg)
			end

		end,function ( failMsg )
			-- body
			if(callback)then
				callback(FunctionLogin.LoginCode.SdkLoginCancel,failMsg)
			end
			self:resetRetryTime()
		end)
	else
		self:LaunchSdk( function ( scuccess ,msg)
			-- body
			if(scuccess)then
				self:startSdkLogin( callback )
			else
				msg = msg and tostring(msg) or "null" 
				Debug.Log("LoginFailure msg:"..msg)
				GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
				MsgManager.ShowMsgByIDTable(1037,{FunctionLogin.ErrorCode.Login_SDKLaunchFailure,msg})
				-- errorLog(ZhString.Login_SDKLaunchFailure)
			end
		end)
	end
end

function FunctionLoginAny:getAuthUrl()
	-- https://auth-m-ro.xd.com:5003/anylogin?plat=1
	local addresses = FunctionGetIpStrategy.Me():getRequestAddresss()
	if(not addresses )then
		return ""
	end
	local domain = addresses[self.retryTime]
	if(not domain)then
		domain = addresses[1]
	end
	local authPort = self:GetAuthPort()
	local plat = self:GetPlat()
	local url = "https://%s:%s/anylogin?plat=%s"
	url = string.format(url,domain,authPort,plat)
	return url
end

function FunctionLoginAny:startRetryLogin(callback)
	self.retryTime = self.retryTime + 1
	self.delayTime = self.delayTime + math.random()*self.retryTime
	LogUtility.InfoFormat("FunctionLoginAny:startSdkLoginNew(  ) self.retryTime:{0},self.delayTime:{1}",self.retryTime,self.delayTime)
	if(self.delayTime and self.delayTime >0)then
		LeanTween.delayedCall(self.delayTime,function (  )
			self:startSdkLoginNew(callback)
		end)
	else
		self:startSdkLoginNew(callback)
	end
end