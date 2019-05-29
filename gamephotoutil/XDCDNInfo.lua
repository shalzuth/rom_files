autoImport("GoogleStorageConfig")
XDCDNInfo = {}
local FILE_SERVER_URL_S = "https://ro.xdcdn.net"
local FILE_SERVER_URL = "http://ro.xdcdn.net"
function XDCDNInfo.GetFileServerURL()
  return GoogleStorageConfig.googleStorageDownLoad
end
function XDCDNInfo.GetAudioServerURL()
  return FILE_SERVER_URL_S
end
