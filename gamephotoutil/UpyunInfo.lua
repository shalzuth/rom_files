autoImport("GoogleStorageConfig")
UpyunInfo = {}
function UpyunInfo.GetNormalUploadURL()
  return GoogleStorageConfig.googleStorageUpLoad
end
function UpyunInfo.GetFormUploadURL()
  return UpyunInfo.GetNormalUploadURL()
end
function UpyunInfo.GetDownloadURL()
  local url = CloudFile.UpYunServer.DOWNLOAD_DOMAIN
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android or runtimePlatform == RuntimePlatform.WindowsEditor then
    url = string.gsub(url, "https", "http")
  end
  return url
end
function UpyunInfo.GetVisitURL()
  local url = CloudServer.VISIT_DOMAIN
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android or runtimePlatform == RuntimePlatform.WindowsEditor then
    url = string.gsub(url, "https", "http")
  end
  return url
end
