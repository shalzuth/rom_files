autoImport('GoogleStorageConfig')
XDCDNInfo = {}

local FILE_SERVER_URL_S = 'https://ro.xdcdn.net'
local FILE_SERVER_URL = 'http://ro.xdcdn.net'

function XDCDNInfo.GetFileServerURL()
	--todo xde
	return GoogleStorageConfig.googleStorageDownLoad
	--	local url = FILE_SERVER_URL_S
	--	local runtimePlatform = ApplicationInfo.GetRunPlatform()
	--	if runtimePlatform == RuntimePlatform.Android or runtimePlatform == RuntimePlatform.WindowsEditor then
	--		url = FILE_SERVER_URL
	--	end
	--	return url
end