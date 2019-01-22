ApplicationInfo = {}

local screenSize = NGUITools.screenSize

function ApplicationInfo.GetRunPlatform()
	return Application.platform
end

function ApplicationInfo.IsRunOnEditor()
	local platform = ApplicationInfo.GetRunPlatform()
	return platform == RuntimePlatform.OSXEditor or platform == RuntimePlatform.WindowsEditor
end

function ApplicationInfo.IsRunOnWindowns()
	if(ApplicationInfo.IsRunOnEditor())then
		return true;
	end
	return Application.platform == RuntimePlatform.WindowsPlayer;
end

function ApplicationInfo.GetVersion()
	return Application.version
end

function ApplicationInfo.GetScreenSize()
	return screenSize
end

function ApplicationInfo.IsIphoneX()
	if(not BackwardCompatibilityUtil.CompatibilityMode_V16 and (Application.platform == RuntimePlatform.IPhonePlayer or ApplicationInfo.IsRunOnEditor())) then
		return SafeArea.isiPhoneX
	end
	return false
end

function ApplicationInfo.GetSystemLanguage()
	helplog("??????????????????????????????????????? : " .. OverSea.LangManager.Instance():CurLangInt())
	return OverSea.LangManager.Instance():CurLangInt()
end

function ApplicationInfo.CopyToSystemClipboard(contents)
	if not BackwardCompatibilityUtil.CompatibilityMode_V17 then
		return ClipboardManager.CopyToClipBoard(contents) == 0
	else
		return false
	end
end

-- 
function ApplicationInfo.IsIOSVersionUnder8()
	if(Application.platform ~= RuntimePlatform.IPhonePlayer)then
		return false;
	end

	local version =  ExternalInterfaces.GetIOSVersion();
	if(version == nil)then
		return false;
	end

	local version_s = string.split(version, ".");
	version = version_s[1] and tonumber(version_s[1]) or nil
	if(version and version <=8)then
		return true;
	end

	return false;
end

function ApplicationInfo:IsRunOnWindowns()
	return false
end