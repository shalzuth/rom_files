PermissionUtil = {}
local isAndroid = RuntimePlatform.Android == Application.platform
function PermissionUtil.Access_SavePicToMediaStorage(callback)
  if isAndroid then
    callback()
  else
    callback()
  end
end
function PermissionUtil.Access_Camera()
  if isAndroid then
    helplog("Access_Camera")
  end
  return true
end
function PermissionUtil.Access_WriteMediaStorage()
  if isAndroid then
    helplog("Access_WriteMediaStorage")
  end
  return true
end
function PermissionUtil.Access_RecordAudio(callback)
  if isAndroid then
    OverSeas_TW.OverSeasManager.GetInstance():AndroidPermissionAudio(function()
      callback()
    end)
  else
    callback()
  end
end
