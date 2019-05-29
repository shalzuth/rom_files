autoImport("HTTPRequest")
autoImport("XDCDNInfo")
autoImport("PhotoFileInfo")
autoImport("UpyunInfo")
autoImport("GoogleStorageConfig")
NetIngScenicSpotPhoto = class("NetIngScenicSpotPhoto")
local gCachedDownloadTaskRecordID = {}
local gCachedUploadTaskRecordID = {}
function NetIngScenicSpotPhoto.Ins()
  if NetIngScenicSpotPhoto.ins == null then
    NetIngScenicSpotPhoto.ins = NetIngScenicSpotPhoto.new()
  end
  return NetIngScenicSpotPhoto.ins
end
function NetIngScenicSpotPhoto:Initialize()
  EventManager.Me():AddEventListener(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, self.OnRecvOverseasPhotoUploadCmd, self)
  self.stopFormUploadFlag = {}
  self.tabIsExist = {}
end
function NetIngScenicSpotPhoto:Download(scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, o_or_t, extension)
  local tempDownloadRootPath = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadRootPathOfLocal()
  if not FileHelper.ExistDirectory(tempDownloadRootPath) then
    FileHelper.CreateDirectory(tempDownloadRootPath)
  end
  local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadPathOfLocal(scenic_spot_id, o_or_t, extension)
  local key = scenic_spot_id .. "_" .. (o_or_t and "o" or "t")
  if table.ContainsKey(gCachedDownloadTaskRecordID, key) then
    local taskRecordID = gCachedDownloadTaskRecordID[key]
    if self:IsDownloading(scenic_spot_id, o_or_t) then
      CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
    else
      if FileHelper.ExistFile(path) then
        FileHelper.DeleteFile(path)
      end
      ServiceOverseasTaiwanCmdProxy.Instance:GetDownLoadPath(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_SCENERY, function(data)
        local newURL = GoogleStorageConfig.googleStorageDownLoad .. "/" .. data.path .. "/" .. scenic_spot_id .. ".jpg"
        helplog("download newURL scene " .. newURL)
        local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
        taskRecord.URL = newURL
        CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
        CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
        CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
      end)
      break
    end
  else
    if FileHelper.ExistFile(path) then
      FileHelper.DeleteFile(path)
    end
    ServiceOverseasTaiwanCmdProxy.Instance:GetDownLoadPath(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_SCENERY, function(data)
      local url = GoogleStorageConfig.googleStorageDownLoad .. "/" .. data.path .. "/" .. scenic_spot_id .. ".jpg"
      helplog("download url scene " .. url)
      local taskRecordID
      if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
        taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback, success_callback, error_callback, nil)
      else
        taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback, success_callback, error_callback)
      end
      if taskRecordID > 0 then
        gCachedDownloadTaskRecordID[key] = taskRecordID
      end
    end)
  end
end
function NetIngScenicSpotPhoto:IsDownloading(scenic_spot_id, o_or_t)
  local key = scenic_spot_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    return taskRecord.State == CloudFile.E_TaskState.Progress or taskRecord.State == CloudFile.E_TaskState.None
  end
  return false
end
function NetIngScenicSpotPhoto:StopDownload(scenic_spot_id, o_or_t)
  local key = scenic_spot_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end
function NetIngScenicSpotPhoto:Upload(scenic_spot_id, progress_callback, success_callback, error_callback)
  if table.ContainsKey(gCachedUploadTaskRecordID, scenic_spot_id) then
    local taskRecordID = gCachedUploadTaskRecordID[scenic_spot_id]
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    if taskRecord.State == CloudFile.E_TaskState.Progress then
      CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
    end
    CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  else
    local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempUploadPathOfLocal(scenic_spot_id)
    local url = UpyunInfo.GetNormalUploadURL() .. "/" .. self:GetPathOfServer(scenic_spot_id)
    local taskRecordID
    if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
      taskRecordID = CloudFile.CloudFileManager.Ins:NormalUpload(path, url, progress_callback, success_callback, error_callback, nil)
    else
      taskRecordID = CloudFile.CloudFileManager.Ins:NormalUpload(path, url, progress_callback, success_callback, error_callback)
    end
    if taskRecordID > 0 then
      gCachedUploadTaskRecordID[scenic_spot_id] = taskRecordID
    end
  end
end
function NetIngScenicSpotPhoto:StopUpload(scenic_spot_id)
  local taskRecordID = gCachedUploadTaskRecordID[scenic_spot_id]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end
local operatorName = "roxdcdn"
local formUploadCallbacks = {}
function NetIngScenicSpotPhoto:FormUpload(scenic_spot_id, progress_callback, success_callback, error_callback)
  helplog("NetIngScenicSpotPhoto:FormUpload")
  formUploadCallbacks[scenic_spot_id] = {
    progressCallback = progress_callback,
    successCallback = success_callback,
    errorCallback = error_callback
  }
  ServiceOverseasTaiwanCmdProxy.Instance:GetUpLoadSign(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_SCENERY, scenic_spot_id)
  self.stopFormUploadFlag[scenic_spot_id] = false
end
function NetIngScenicSpotPhoto:OnRecvOverseasPhotoUploadCmd(message)
  local path = message.path
  local eType = string.split(path, "/")[2]
  if eType == "scenery" then
    local scenerySpotID = message.photoId
    local result = OverseaHostHelper:GenUpLoadSignObj(message.fields)
    if not self.stopFormUploadFlag[scenerySpotID] then
      self:OverseaDoFormUpload(scenerySpotID, result.signObj, result.uploadUrl, formUploadCallbacks[scenerySpotID].progressCallback, formUploadCallbacks[scenerySpotID].successCallback, formUploadCallbacks[scenerySpotID].errorCallback)
    end
    formUploadCallbacks[scenerySpotID] = nil
  end
end
function NetIngScenicSpotPhoto:OverseaDoFormUpload(scenic_spot_id, signObj, url, progress_callback, success_callback, error_callback)
  if table.ContainsKey(gCachedUploadTaskRecordID, scenic_spot_id) then
    local taskRecordID = gCachedUploadTaskRecordID[scenic_spot_id]
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    if taskRecord.State == CloudFile.E_TaskState.Progress then
      CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
    end
    CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  else
    local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempUploadPathOfLocal(scenic_spot_id)
    helplog(url)
    local taskRecordID = CloudFile.CloudFileManager.Ins:NormalUploadGoogleStorage(path, url, signObj, progress_callback, success_callback, error_callback)
    if taskRecordID > 0 then
      gCachedUploadTaskRecordID[scenic_spot_id] = taskRecordID
    end
  end
end
function NetIngScenicSpotPhoto:OnReceiveUploadSceneryPhotoUserCmd(message)
  local eType = message.type
  if eType == SceneUser2_pb.EALBUMTYPE_SCENERY then
    local scenerySpotID = message.sceneryid
    if not self.stopFormUploadFlag[scenerySpotID] then
      local policy = message.policy
      local signature = message.signature
      local authorization = "UPYUN " .. operatorName .. ":" .. signature
      self:DoFormUpload(scenerySpotID, policy, authorization, formUploadCallbacks[scenerySpotID].progressCallback, formUploadCallbacks[scenerySpotID].successCallback, formUploadCallbacks[scenerySpotID].errorCallback)
    end
    formUploadCallbacks[scenerySpotID] = nil
  end
end
function NetIngScenicSpotPhoto:DoFormUpload(scenic_spot_id, policy, authorization, progress_callback, success_callback, error_callback)
  if table.ContainsKey(gCachedUploadTaskRecordID, scenic_spot_id) then
    local taskRecordID = gCachedUploadTaskRecordID[scenic_spot_id]
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    if taskRecord.State == CloudFile.E_TaskState.Progress then
      CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
    end
    CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  else
    local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempUploadPathOfLocal(scenic_spot_id)
    local url = UpyunInfo.GetFormUploadURL()
    local taskRecordID = CloudFile.CloudFileManager.Ins:FormUpload(path, url, policy, authorization, progress_callback, success_callback, error_callback, nil)
    if taskRecordID > 0 then
      gCachedUploadTaskRecordID[scenic_spot_id] = taskRecordID
    end
  end
end
function NetIngPersonalPhoto:StopFormUpload(scenic_spot_id)
  self.stopFormUploadFlag[scenic_spot_id] = true
  self:StopUpload(scenic_spot_id)
end
function NetIngScenicSpotPhoto:SetUserPathOfServer(user_path)
  self.userPathOfServer = user_path
end
function NetIngScenicSpotPhoto:GetPathOfServer(scenic_spot_id, pExtension)
  return self:GetPathOfServerWithRoleID(Game.Myself.data.id, scenic_spot_id, pExtension)
end
function NetIngScenicSpotPhoto:GetPathOfServerWithRoleID(role_id, scenic_spot_id, pExtension)
  local extension = PhotoFileInfo.Extension
  if pExtension ~= nil then
    extension = pExtension
  end
  return self.userPathOfServer .. "/" .. role_id .. "/" .. scenic_spot_id .. "." .. extension
end
function NetIngScenicSpotPhoto:GetTempDownloadRootPathOfLocal()
  return "TempUsedToDownloadScenicSpot"
end
function NetIngScenicSpotPhoto:GetTempDownloadPathOfLocal(scenic_spot_id, o_or_t, pExtension)
  local extension = PhotoFileInfo.Extension
  if pExtension ~= nil then
    extension = pExtension
  end
  return self:GetTempDownloadRootPathOfLocal() .. "/" .. scenic_spot_id .. "_" .. (o_or_t and "o" or "t") .. "." .. extension
end
function NetIngScenicSpotPhoto:GetTempUploadRootPathOfLocal()
  return "TempUsedToUploadScenicSpot"
end
function NetIngScenicSpotPhoto:GetTempUploadPathOfLocal(scenic_spot_id)
  return self:GetTempUploadRootPathOfLocal() .. "/" .. scenic_spot_id .. "." .. PhotoFileInfo.Extension
end
function NetIngScenicSpotPhoto:SetExist(role_id, scenic_spot_id)
  if self.tabIsExist[role_id] == nil then
    self.tabIsExist[role_id] = {}
  end
  self.tabIsExist[role_id][scenic_spot_id] = 0
end
local existResponseCode = {
  [200] = 0
}
function NetIngScenicSpotPhoto:CheckExist(role_id, scenic_spot_id, exist_callback, error_callback, extension)
  local scenicSpotIsExist = self.tabIsExist[role_id]
  if scenicSpotIsExist ~= nil and scenicSpotIsExist[scenic_spot_id] ~= nil then
    if exist_callback ~= nil then
      exist_callback()
    end
    return
  end
  local url = GoogleStorageConfig.googleStorageDownLoad .. "/" .. self:GetPathOfServerWithRoleID(role_id, scenic_spot_id, extension)
  helplog("check url:" .. url)
  HTTPRequest.Head(url, function(x)
    local unityWebRequest = x
    local responseCode = unityWebRequest.responseCode
    if existResponseCode[responseCode] == 0 then
      if exist_callback ~= nil then
        exist_callback()
      end
    elseif error_callback ~= nil then
      error_callback()
    end
  end)
end
