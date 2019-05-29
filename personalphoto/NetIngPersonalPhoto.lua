autoImport("XDCDNInfo")
autoImport("HTTPRequest")
autoImport("PhotoFileInfo")
autoImport("UpyunInfo")
NetIngPersonalPhoto = class("NetIngPersonalPhoto")
local gCachedDownloadTaskRecordID = {}
local gCachedUploadTaskRecordID = {}
function NetIngPersonalPhoto.Ins()
  if NetIngPersonalPhoto.ins == null then
    NetIngPersonalPhoto.ins = NetIngPersonalPhoto.new()
  end
  return NetIngPersonalPhoto.ins
end
function NetIngPersonalPhoto:Initialize()
  EventManager.Me():AddEventListener(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, self.OnRecvOverseasPhotoUploadCmd, self)
  self.stopFormUploadFlag = {}
  self.tabIsExist = {}
end
function NetIngPersonalPhoto:Download(role_id, pos_index, photo_id, timestamp, progress_callback, success_callback, error_callback, o_or_t, extension)
  local tempDownloadRootPath = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadRootPathOfLocal()
  if not FileHelper.ExistDirectory(tempDownloadRootPath) then
    FileHelper.CreateDirectory(tempDownloadRootPath)
  end
  local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadPathOfLocal(photo_id, o_or_t, extension)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  if table.ContainsKey(gCachedDownloadTaskRecordID, key) then
    local taskRecordID = gCachedDownloadTaskRecordID[key]
    if self:IsDownloading(photo_id, o_or_t) then
      CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
    else
      if FileHelper.ExistFile(path) then
        FileHelper.DeleteFile(path)
      end
      ServiceOverseasTaiwanCmdProxy.Instance:GetDownLoadPath(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_PHOTO, function(data)
        local newURL = GoogleStorageConfig.googleStorageDownLoad .. "/" .. data.path .. "/" .. pos_index .. ".jpg"
        helplog("download newURL person " .. newURL)
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
    ServiceOverseasTaiwanCmdProxy.Instance:GetDownLoadPath(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_PHOTO, function(data)
      local url = GoogleStorageConfig.googleStorageDownLoad .. "/" .. data.path .. "/" .. pos_index .. ".jpg"
      helplog("download newURL person " .. url)
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
function NetIngPersonalPhoto:IsDownloading(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    return taskRecord.State == CloudFile.E_TaskState.None or taskRecord.State == CloudFile.E_TaskState.Progress
  end
  return false
end
function NetIngPersonalPhoto:SetDownloadCallback(photo_id, progress_callback, success_callback, error_callback, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager._CloudFileCallbacks:UnregisterCallback(taskRecordID)
    CloudFile.CloudFileManager._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  end
end
function NetIngPersonalPhoto:AddDownloadCallback(photo_id, progress_callback, success_callback, error_callback, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  end
end
function NetIngPersonalPhoto:StopDownload(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end
function NetIngPersonalPhoto:Upload(role_id, pos_index, photo_id, progress_callback, success_callback, error_callback)
  if table.ContainsKey(gCachedUploadTaskRecordID, photo_id) then
    local taskRecordID = gCachedUploadTaskRecordID[photo_id]
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    if taskRecord.State == CloudFile.E_TaskState.Progress then
      CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
    end
    CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  else
    local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempUploadPathOfLocal(photo_id)
    local url = UpyunInfo.GetNormalUploadURL() .. "/" .. self:GetPathOfServer(role_id, pos_index)
    local taskRecordID
    if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
      taskRecordID = CloudFile.CloudFileManager.Ins:NormalUpload(path, url, progress_callback, success_callback, error_callback, nil)
    else
      taskRecordID = CloudFile.CloudFileManager.Ins:NormalUpload(path, url, progress_callback, success_callback, error_callback)
    end
    if taskRecordID > 0 then
      gCachedUploadTaskRecordID[photo_id] = taskRecordID
    end
  end
end
function NetIngPersonalPhoto:StopUpload(photo_id)
  local taskRecordID = gCachedUploadTaskRecordID[photo_id]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end
local operatorName = "roxdcdn"
local formUploadCallbacks = {}
function NetIngPersonalPhoto:FormUpload(pos_index, photo_id, progress_callback, success_callback, error_callback)
  formUploadCallbacks[pos_index] = {
    photoID = photo_id,
    progressCallback = progress_callback,
    successCallback = success_callback,
    errorCallback = error_callback
  }
  helplog("NetIngPersonalPhoto:FormUpload")
  ServiceOverseasTaiwanCmdProxy.Instance:GetUpLoadSign(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_PHOTO, photo_id)
  self.stopFormUploadFlag[photo_id] = false
end
function NetIngPersonalPhoto:OnRecvOverseasPhotoUploadCmd(message)
  local path = message.path
  local eType = string.split(path, "/")[2]
  if eType == "photo" then
    local photoId = message.photoId
    local result = OverseaHostHelper:GenUpLoadSignObj(message.fields)
    if not self.stopFormUploadFlag[photoId] then
      self:OverseaDoFormUpload(photoId, result.signObj, result.uploadUrl, formUploadCallbacks[photoId].progressCallback, formUploadCallbacks[photoId].successCallback, formUploadCallbacks[photoId].errorCallback)
    end
    formUploadCallbacks[photoId] = nil
  end
end
function NetIngPersonalPhoto:OverseaDoFormUpload(photo_id, signObj, url, progress_callback, success_callback, error_callback)
  if table.ContainsKey(gCachedUploadTaskRecordID, photo_id) then
    local taskRecordID = gCachedUploadTaskRecordID[photo_id]
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    if taskRecord.State == CloudFile.E_TaskState.Progress then
      CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
    end
    CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  else
    local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempUploadPathOfLocal(photo_id)
    local taskRecordID = CloudFile.CloudFileManager.Ins:NormalUploadGoogleStorage(path, url, signObj, progress_callback, success_callback, error_callback)
    if taskRecordID > 0 then
      gCachedUploadTaskRecordID[photo_id] = taskRecordID
    end
  end
end
function NetIngPersonalPhoto:OnReceiveUploadSceneryPhotoUserCmd(message)
  local eType = message.type
  if eType == SceneUser2_pb.EALBUMTYPE_PHOTO then
    local posIndex = message.sceneryid
    local photoID = formUploadCallbacks[posIndex].photoID
    if not self.stopFormUploadFlag[photoID] then
      local policy = message.policy
      local signature = message.signature
      local authorization = "UPYUN " .. operatorName .. ":" .. signature
      self:DoFormUpload(photoID, policy, authorization, formUploadCallbacks[posIndex].progressCallback, formUploadCallbacks[posIndex].successCallback, formUploadCallbacks[posIndex].errorCallback)
    end
    formUploadCallbacks[posIndex] = nil
  end
end
function NetIngPersonalPhoto:DoFormUpload(photo_id, policy, authorization, progress_callback, success_callback, error_callback)
  if table.ContainsKey(gCachedUploadTaskRecordID, photo_id) then
    local taskRecordID = gCachedUploadTaskRecordID[photo_id]
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    if taskRecord.State == CloudFile.E_TaskState.Progress then
      CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
    end
    CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  else
    local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempUploadPathOfLocal(photo_id)
    local url = UpyunInfo.GetFormUploadURL()
    local taskRecordID = CloudFile.CloudFileManager.Ins:FormUpload(path, url, policy, authorization, progress_callback, success_callback, error_callback, nil)
    if taskRecordID > 0 then
      gCachedUploadTaskRecordID[photo_id] = taskRecordID
    end
  end
end
function NetIngPersonalPhoto:StopFormUpload(photo_id)
  self.stopFormUploadFlag[photo_id] = true
  self:StopUpload(photo_id)
end
function NetIngPersonalPhoto:SetUserPathOfServer(user_path)
  self.userPathOfServer = user_path
end
function NetIngPersonalPhoto:GetPathOfServer(role_id, pos_index, pExtension)
  local extension = PhotoFileInfo.Extension
  if pExtension ~= nil then
    extension = pExtension
  end
  return self.userPathOfServer .. "/" .. role_id .. "/" .. pos_index .. "." .. extension
end
function NetIngPersonalPhoto:GetTempDownloadRootPathOfLocal()
  return "TempUsedToDownloadPersonalPhoto"
end
function NetIngPersonalPhoto:GetTempDownloadPathOfLocal(photo_id, o_or_t, pExtension)
  local extension = PhotoFileInfo.Extension
  if pExtension ~= nil then
    extension = pExtension
  end
  return self:GetTempDownloadRootPathOfLocal() .. "/" .. photo_id .. "_" .. (o_or_t and "o" or "t") .. "." .. extension
end
function NetIngPersonalPhoto:GetTempUploadRootPathOfLocal()
  return "TempUsedToUploadPersonalPhoto"
end
function NetIngPersonalPhoto:GetTempUploadPathOfLocal(photo_id)
  return self:GetTempUploadRootPathOfLocal() .. "/" .. photo_id .. "." .. PhotoFileInfo.Extension
end
function NetIngPersonalPhoto:SetExist(role_id, pos_index)
  if self.tabIsExist[role_id] == nil then
    self.tabIsExist[role_id] = {}
  end
  self.tabIsExist[role_id][pos_index] = 0
end
local existResponseCode = {
  [200] = 0
}
function NetIngPersonalPhoto:CheckExist(role_id, pos_index, exist_callback, error_callback, extension)
  local posIndexIsExist = self.tabIsExist[role_id]
  if posIndexIsExist ~= nil and posIndexIsExist[pos_index] ~= nil then
    if exist_callback ~= nil then
      exist_callback()
    end
    return
  end
  local url = GoogleStorageConfig.googleStorageDownLoad .. "/" .. self:GetPathOfServer(role_id, pos_index, extension)
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
