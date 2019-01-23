autoImport('GoogleStorageConfig')
UpyunInfo = {}

function UpyunInfo.GetNormalUploadURL()
	-- todo xde
	return GoogleStorageConfig.googleStorageUpLoad

	--	local url = CloudFile.UpYunServer.UPLOAD_NORMAL_DOMAIN
	--	local runtimePlatform = ApplicationInfo.GetRunPlatform()
	--	if runtimePlatform == RuntimePlatform.Android or runtimePlatform == RuntimePlatform.WindowsEditor then
	--		url = string.gsub(url, 'https', 'http')
	--	end
	--	return url
end

function UpyunInfo.GetFormUploadURL()
	return UpyunInfo.GetNormalUploadURL()
end

function UpyunInfo.GetDownloadURL()
	local url = CloudFile.UpYunServer.DOWNLOAD_DOMAIN
	local runtimePlatform = ApplicationInfo.GetRunPlatform()
	if runtimePlatform == RuntimePlatform.Android or runtimePlatform == RuntimePlatform.WindowsEditor then
		url = string.gsub(url, 'https', 'http')
	end
	return url
end

function UpyunInfo.GetVisitURL()
	local url = CloudServer.VISIT_DOMAIN
	local runtimePlatform = ApplicationInfo.GetRunPlatform()
	if runtimePlatform == RuntimePlatform.Android or runtimePlatform == RuntimePlatform.WindowsEditor then
		url = string.gsub(url, 'https', 'http')
	end
	return url
end