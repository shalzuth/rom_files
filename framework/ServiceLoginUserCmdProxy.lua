autoImport('ServiceLoginUserCmdAutoProxy')
autoImport('FunctionADBuiltInTyrantdb')
autoImport('UIModelRolesList')
autoImport('PersonalPhotoHelper')
autoImport('ScenicSpotPhotoHelperNew')
autoImport('UnionWallPhotoHelper')
autoImport('PersonalPhoto')
autoImport('ScenicSpotPhotoNew')
autoImport('UnionWallPhotoNew')
autoImport('AppStorePurchase')
autoImport('UnionLogo')
autoImport('MarryPhoto')
ServiceLoginUserCmdProxy = class('ServiceLoginUserCmdProxy', ServiceLoginUserCmdAutoProxy)
ServiceLoginUserCmdProxy.Instance = nil
ServiceLoginUserCmdProxy.NAME = 'ServiceLoginUserCmdProxy'


ServiceLoginUserCmdProxy.saveID = "ProfessionSaveLoadView_saveID"
ServiceLoginUserCmdProxy.toswitchroleid="ServiceLoginUserCmdProxy_toswitchroleid"
function ServiceLoginUserCmdProxy:ctor(proxyName)
	if ServiceLoginUserCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceLoginUserCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceLoginUserCmdProxy.Instance = self
	end
end

function ServiceLoginUserCmdProxy:RecvReqLoginParamUserCmd(data) 
	FunctionLogin.Me():RecvReqLoginParamUserCmd(data)
	self:Notify(ServiceEvent.LoginUserCmdReqLoginParamUserCmd, data)
end

function ServiceLoginUserCmdProxy:RecvHeartBeatUserCmd(data) 
	ServiceConnProxy.Instance:RecvHeart()
	self:Notify(ServiceEvent.LoginUserCmdHeartBeatUserCmd, data)
end

-- local tags = {"tags1","tagsRO"}
function ServiceLoginUserCmdProxy:RecvLoginResultUserCmd(data) 
	local ret = data.ret
	if(ret == 0)then
		LogUtility.Info("<color=lime>登陆成功</color>")
		--初始化景点上传下载
		--TODO
		self:CallServerTimeUserCmd()
		-- <RB>build local files
		DiskFileHandler.Ins():EnterServer()
		FunctionChatIO.Me():CheckLocalFiles()
		DiskFileHandler.Ins():EnterBeautifulArea()
		DiskFileHandler.Ins():EnterUnionWallPhoto()
		DiskFileHandler.Ins():EnterPersonalPhoto()
		DiskFileHandler.Ins():EnterUnionLogo()
		DiskFileHandler.Ins():EnterMarryPhoto()
		-- <RE>build local files

		-- <RB>beautiful area
		UpYunNetIngFileTaskManager.Ins:Open()
		BeautifulAreaPhotoHandler.Ins():Initialize()
		BeautifulAreaPhotoNetIngManager.Ins():Initialize()
		-- <RE>beautiful area

		--<RB>game photos
		PersonalPhotoHelper.Ins():Initialize()
		ScenicSpotPhotoHelperNew.Ins():Initialize()
		UnionWallPhotoHelper.Ins():Initialize()
		PersonalPhoto.Ins():Initialize()
		ScenicSpotPhotoNew.Ins():Initialize()
		UnionWallPhotoNew.Ins():Initialize()
		UnionLogo.Ins():Initialize()
		MarryPhoto.Ins():Initialize()
		--<RE>game photos

		-- BigCat Reset
		FunctionActivity.Me():Reset();
		-- BigCat Reset

		-- Seal Reset
		SealProxy.Instance:ResetSealData();
		SealProxy.Instance:ResetAcceptSealInfo();
		FunctionRepairSeal.Me():ResetRepairSeal()
		-- Seal Reset

		-- team, guild data reset
		TeamProxy.Instance:ExitTeam();
		GuildProxy.Instance:ExitGuild();
		QuestProxy.Instance:CleanAllQuest(  )
		-- team, guild data reset

		-- Astrolabe Reset
		AstrolabeProxy.Instance:ResetPlate();
		-- Astrolabe Reset

		-- RedTipProxy Reset
		RedTipProxy.Instance:RemoveAll()
		PvpProxy.Instance:ClearBosses()
		-- RedTipProxy Reset

		-- Pvp MathcInfo Reset
		PvpProxy.Instance:ClearMatchInfo();
		-- Pvp MathcInfo Reset

		-- 存档 clear
		MultiProfessionSaveProxy.Instance:Clear()
		-- 存档 clear

		-- 清除buff
		FunctionBuff.Me():ClearMyBuffs();
		-- 清除buff

		-- local loginData = FunctionLogin.Me():getLoginData()
		-- local account = loginData ~= nil and loginData.accid or 0
		-- ROPush.SetTagsWithAlias(tags,tostring(account))
		-- helplog("ROPush.SetTagsWithAlias",account)
		
		GameFacade.Instance:sendNotification(ServiceUserProxy.RecvLogin);	
	-- todo xde 去除同步DID
--		FunctionLogin.Me():SyncServerDID()
	else
		LogUtility.Info("<color=yellow>登陆失败</color>")
	end
	self:Notify(ServiceEvent.LoginUserCmdLoginResultUserCmd, data)
end

function ServiceLoginUserCmdProxy:RecvSnapShotUserCmd(data)
	-- print('ServiceLoginUserCmdProxy:RecvSnapShotUserCmd')
	-- print('data following...')
	-- local strDeletechar = ''
	-- if data.deletechar == nil then
	-- 	strDeletechar = 'nil'
	-- else
	-- 	strDeletechar = data.deletechar and 'true' or 'false'
	-- end
	-- print('deletechar = ' .. strDeletechar)
	-- print('deletecdtime = ' .. data.deletecdtime)
	-- for k, v in pairs(data.data) do
	-- 	if type(k) == 'number' then
	-- 		print('k = ' .. k)
	-- 		print('id = ' .. v.id)
	-- 		print('baselv = ' .. v.baselv)
	-- 		print('hair = ' .. v.hair)
	-- 		print('haircolor = ' .. v.haircolor)
	-- 		print('lefthand = ' .. v.lefthand)
	-- 		print('righthand = ' .. v.righthand)
	-- 		print('body = ' .. v.body)
	-- 		print('head = ' .. v.head)
	-- 		print('back = ' .. v.back)
	-- 		print('face = ' .. v.face)
	-- 		print('tail = ' .. v.tail)
	-- 		print('mount = ' .. v.mount)
	-- 		print('eye = ' .. v.eye)
	-- 		print('partnerid = ' .. v.partnerid)
	-- 		print('portrait = ' .. v.portrait)
	-- 		print('mouth = ' .. v.mouth)
	-- 		print('gender = ' .. tonumber(v.gender))
	-- 		print('profession = ' .. tonumber(v.profession))
	-- 		print('name = ' .. v.name)
	-- 		print('sequence = ' .. v.sequence)
	-- 		print('isopen = ' .. v.isopen)
	-- 		print('deletetime = ' .. v.deletetime)
	-- 	end
	-- end
	local security = FunctionSecurity.Me()
	if(security.verifySecuriySus and security.verifySecuriyCode)then
		ServiceLoginUserCmdProxy.Instance:CallConfirmAuthorizeUserCmd(security.verifySecuriyCode)
	end
	
	MyselfProxy.Instance:SetUserRolesInfo(data);

	UIModelRolesList.Ins():SetRoleDeleteCDCompleteTime(data.deletecdtime)
	ServiceUserProxy.Instance:RecvRoleInfo(data)	
	ServiceConnProxy.Instance:CheckHeartStatus()
	ServiceConnProxy.Instance:RecvHeart()
	self:CallServerTimeUserCmd()
	self:Notify(ServiceEvent.LoginUserCmdSnapShotUserCmd, data)

	-- <RB>build local files
	local loginData = FunctionLogin.Me():getLoginData()
	local account = loginData ~= nil and loginData.accid or 0
	DiskFileHandler.Ins():SetUser(account)
	local server = FunctionLogin.Me():getCurServerData()
	local serverID = server ~= nil and server.serverid or 0
	DiskFileHandler.Ins():SetServer(serverID)
	-- <RE>build local files

	-- <RB>tyrantdb
	local loginData = FunctionLogin.Me():getLoginData()
	local account = loginData ~= nil and loginData.accid or 0
	local userAge = 99
	local userName = 'wumingshi'

	-- todo xde 在版本 24 时强制启用 tyrantdb
	-- if not BackwardCompatibilityUtil.CompatibilityMode_V24 then
	FunctionTyrantdb.Instance:SetUser(account, E_TyrantdbUserType.Registered, E_TyrantdbUserSex.Unknown, userAge, userName);
	-- end

	if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
		local runtimePlatform = ApplicationInfo.GetRunPlatform()
		if runtimePlatform == RuntimePlatform.IPhonePlayer then
			--FunctionADBuiltInTyrantdb.Instance():OnCreateRole()
		end
	end
	local server = FunctionLogin.Me():getCurServerData()
	local serverName = server ~= nil and server.name or "Unknown"
	FunctionTyrantdb.Instance:SetServer(serverName)
	-- <RE>tyrantdb	
end

function ServiceLoginUserCmdProxy:RecvServerTimeUserCmd(data) 
	ServerTime.InitTime(data.time)
	LocalSaveProxy.Instance:InitDontShowAgain()
	self:Notify(ServiceEvent.NUserServerTime, data)
end

function ServiceLoginUserCmdProxy:RecvConfirmAuthorizeUserCmd(data) 
	FunctionSecurity.Me():RecvAuthorizeInfo(data)
	-- helplog("RecvConfirmAuthorizeUserCmd",data.safe)	
	self:Notify(ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd, data)
end

function ServiceLoginUserCmdProxy:RecvSafeDeviceUserCmd(data)
	Game.isSecurityDevice = data.safe
	-- helplog("RecvSafeDeviceUserCmd",data.safe)
	self:Notify(ServiceEvent.LoginUserCmdSafeDeviceUserCmd, data)
end

function ServiceLoginUserCmdProxy:CallRealAuthorizeUserCmd(authoriz_state, authorized) 
	helplog("Call-->RealAuthorizeUserCmd", authoriz_state);
	ServiceLoginUserCmdProxy.super.CallRealAuthorizeUserCmd(self, authoriz_state, authorized);
end

function ServiceLoginUserCmdProxy:RecvRealAuthorizeUserCmd(data) 
	helplog("Recv-->RealAuthorizeUserCmd", data.authorized);
	FunctionLogin.Me():set_realName_Centified(data.authorized)
	self:Notify(ServiceEvent.LoginUserCmdRealAuthorizeUserCmd, data)
end