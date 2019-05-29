StartUpCommand = class("StartUpCommand", pm.MacroCommand)
autoImport("PrepDataProxyCommand")
autoImport("PrepServiceProxyCommand")
autoImport("PrepCMDCommand")
autoImport("PrepUICommand")
autoImport("SpeechRecognizer")
function StartUpCommand:initializeMacroCommand()
  self:addSubCommand(PrepCMDCommand)
  self:addSubCommand(PrepDataProxyCommand)
  self:addSubCommand(PrepServiceProxyCommand)
  self:addSubCommand(PrepUICommand)
  FunctionAppStateMonitor.Me():Launch()
  local channel = ""
  local branchText = ""
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.IPhonePlayer then
    channel = GameConfig.Channel["1"].name
  elseif runtimePlatform == RuntimePlatform.Android then
    local channelID
    if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
      channelID = ChannelInfo.GetChannelID()
    else
      channelID = FunctionSDK.Instance:GetChannelID()
    end
    local channelDetail = GameConfig.Channel[channelID]
    if channelDetail then
      channel = channelDetail.name
    end
  elseif runtimePlatform == RuntimePlatform.WindowsPlayer or runtimePlatform == RuntimePlatform.WindowsEditor then
    channel = "windows"
  end
  if runtimePlatform == RuntimePlatform.IPhonePlayer or runtimePlatform == RuntimePlatform.Android or runtimePlatform == RuntimePlatform.WindowsPlayer or runtimePlatform == RuntimePlatform.WindowsEditor then
    local tyrantdbApplicationInfo = AppBundleConfig.GetTyrantdbInfo()
    local tyrantdbApplicationID = tyrantdbApplicationInfo.APP_ID
    local version = ApplicationInfo.GetVersion()
    if runtimePlatform == RuntimePlatform.IPhonePlayer then
      version = FunctionTyrantdb.Instance:GetAppVersion()
    end
    helplog("tyrantdbApplicationID is " .. tyrantdbApplicationID)
    if EnvChannel.IsTrunkBranch() then
      branchText = "Trunk"
      if runtimePlatform == RuntimePlatform.IPhonePlayer then
        channel = branchText .. "\229\134\133\231\189\145iOS"
      elseif runtimePlatform == RuntimePlatform.Android then
        channel = branchText .. "\229\134\133\231\189\145Android"
      elseif runtimePlatform == RuntimePlatform.WindowsPlayer then
        channel = branchText .. "\229\134\133\231\189\145Windows"
      elseif runtimePlatform == RuntimePlatform.WindowsEditor then
        channel = branchText .. "\229\134\133\231\189\145WindowsUnity\231\188\150\232\190\145\229\153\168"
      end
    elseif EnvChannel.IsStudioBranch() then
      branchText = "Studio"
      if runtimePlatform == RuntimePlatform.IPhonePlayer then
        channel = branchText .. "\229\134\133\231\189\145iOS"
      elseif runtimePlatform == RuntimePlatform.Android then
        channel = branchText .. "\229\134\133\231\189\145Android"
      elseif runtimePlatform == RuntimePlatform.WindowsPlayer then
        channel = branchText .. "\229\134\133\231\189\145Windows"
      elseif runtimePlatform == RuntimePlatform.WindowsEditor then
        channel = branchText .. "\229\134\133\231\189\145WindowsUnity\231\188\150\232\190\145\229\153\168"
      end
    end
    helplog("channel is " .. channel)
    helplog("version is " .. version)
    FunctionTyrantdb.Instance:Initialize(tyrantdbApplicationID, channel, version, false)
  end
  NetMonitor.Me():InitCallBack()
  NetMonitor.Me():ListenSkillUseSendCallBack()
  LuaGC.StartLuaGC()
end
