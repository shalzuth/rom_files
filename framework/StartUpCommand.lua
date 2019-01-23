StartUpCommand = class('StartUpCommand', pm.MacroCommand)
autoImport("PrepDataProxyCommand")
autoImport("PrepServiceProxyCommand")
autoImport("PrepCMDCommand")
autoImport("PrepUICommand")

--todo xde
autoImport("SpeechRecognizer")

function StartUpCommand:initializeMacroCommand()
	self:addSubCommand(PrepCMDCommand)
	self:addSubCommand(PrepDataProxyCommand)
	self:addSubCommand(PrepServiceProxyCommand)
	self:addSubCommand(PrepUICommand)
	--self:addSubCommand(PrepUICommand)

	FunctionAppStateMonitor.Me():Launch()

	-- <RB>tyrantdb initialize
	local channel = ''
	local runtimePlatform = ApplicationInfo.GetRunPlatform()
	if runtimePlatform == RuntimePlatform.IPhonePlayer then
		channel = GameConfig.Channel['1']['name']
	elseif runtimePlatform == RuntimePlatform.Android then
		local channelID = nil
		if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
			-- channelID = '800053'
			channelID = ChannelInfo.GetChannelID()
		else
			channelID = FunctionSDK.Instance:GetChannelID()
		end
		local channelDetail = GameConfig.Channel[channelID]
		if channelDetail then
			channel = channelDetail['name']
		end
	end
	if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V8) then
		if runtimePlatform == RuntimePlatform.IPhonePlayer or runtimePlatform == RuntimePlatform.Android then
			local tyrantdbApplicationInfo = AppBundleConfig.GetTyrantdbInfo()
			if tyrantdbApplicationInfo ~= nil then
    			local tyrantdbApplicationID = tyrantdbApplicationInfo.APP_ID
	    		local version = ApplicationInfo.GetVersion()
		    	if runtimePlatform == RuntimePlatform.IPhonePlayer then
			    	version = FunctionTyrantdb.Instance:GetAppVersion()
			    end
			    Debug.Log('tyrantdbApplicationID is ' .. tyrantdbApplicationID)
			    Debug.Log('channel is ' .. channel)
			    Debug.Log('version is ' .. version)
			    if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
				    FunctionTyrantdb.Instance:Initialize(tyrantdbApplicationID, channel, version, false)
			    else
				    FunctionTyrantdb.Instance:Initialize(tyrantdbApplicationID, channel, version)
			    end
			end
		end
	else
		FunctionTyrantdb.Instance:Initialize(channel)
	end
	-- <RE>tyrantdb initialize

	-- GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.LoadingViewDefault}) 
	--初始化语音模块
	--todo xde voice init
	--RedefineExternalSpeech(ExternalInterfaces)
	ExternalInterfaces.InitRecognizer(FunctionChatSpeech.Me().recognizerFileName)
	--初始化推送模块
	--local envChannel = EnvChannel.Channel.Name
	--local channelConfig = EnvChannel.ChannelConfig
    --
	--if ApplicationInfo.IsRunOnEditor() then
	--	Debug.Log("编辑器模式 无法使用jpush")
	--else
	--	ROPush.Init("JPushBinding")
	--	ROPush.SetDebug(envChannel == channelConfig.Develop.Name or envChannel == channelConfig.Studio.Name)
	--	ROPush.ResetBadge ()
	--	ROPush.SetApplicationIconBadgeNumber (0)
	--end

	NetMonitor.Me():InitCallBack()
	NetMonitor.Me():ListenSkillUseSendCallBack()

	LuaGC.StartLuaGC()
end
