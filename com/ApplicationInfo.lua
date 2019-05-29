ApplicationInfo = {}
local screenSize = NGUITools.screenSize
function ApplicationInfo.GetRunPlatform()
  return Application.platform
end
function ApplicationInfo.IsRunOnEditor()
  local platform = ApplicationInfo.GetRunPlatform()
  return platform == RuntimePlatform.OSXEditor or platform == RuntimePlatform.WindowsEditor
end
function ApplicationInfo.IsWindows()
  return ApplicationInfo.IsRunOnWindowns()
end
function ApplicationInfo.IsRunOnWindowns()
  return Application.platform == RuntimePlatform.WindowsPlayer
end
function ApplicationInfo.GetVersion()
  return Application.version
end
function ApplicationInfo.GetScreenSize()
  return screenSize
end
function ApplicationInfo.SetSafeAreaSides(l, t, r, b)
  if BackwardCompatibilityUtil.CompatibilityMode_V29 then
    return
  end
  SafeArea.on = true
  local ins = SafeArea.Instance
  ins.l = l
  ins.t = t
  ins.r = r
  ins.b = b
end
function ApplicationInfo.GetSafeAreaSides()
  local ins = SafeArea.Instance
  return ins.l, ins.t, ins.r, ins.b
end
function ApplicationInfo.GetSystemLanguage()
  return OverSea.LangManager.Instance():CurLangInt()
end
function ApplicationInfo.CopyToSystemClipboard(contents)
  if not BackwardCompatibilityUtil.CompatibilityMode_V17 then
    return ClipboardManager.CopyToClipBoard(contents) == 0
  else
    return false
  end
end
function ApplicationInfo.GetRunPlatformStr()
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  local phoneplat = "editor"
  if runtimePlatform == RuntimePlatform.Android then
    phoneplat = "Android"
  elseif runtimePlatform == RuntimePlatform.IPhonePlayer then
    phoneplat = "iOS"
  elseif runtimePlatform == RuntimePlatform.WindowsPlayer then
    phoneplat = "Windows"
  elseif runtimePlatform == RuntimePlatform.WindowsEditor then
    phoneplat = "Windows"
  end
  return phoneplat
end
function ApplicationInfo.NeedOpenVoiceRealtime()
  return false
end
function ApplicationInfo.NeedOpenVoiceSend()
  if ApplicationInfo.IsWindows() then
    if GameConfig.SystemForbid.OpenVoiceSendForWindows then
      return false
    else
      return true
    end
  elseif GameConfig.SystemForbid.OpenVoiceSend then
    return false
  else
    return true
  end
end
function ApplicationInfo.IsIOSVersionUnder8()
  if Application.platform ~= RuntimePlatform.IPhonePlayer then
    return false
  end
  local version = ExternalInterfaces.GetIOSVersion()
  if version == nil then
    return false
  end
  local version_s = string.split(version, ".")
  version = version_s[1] and tonumber(version_s[1]) or nil
  if version and version <= 8 then
    return true
  end
  return false
end
function ApplicationInfo.IsDebugModeForWindows()
  return true
end
