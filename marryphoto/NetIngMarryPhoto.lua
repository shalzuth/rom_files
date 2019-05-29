autoImport("GamePhoto")
NetIngMarryPhoto = class("NetIngMarryPhoto")
local gCachedDownloadTaskRecordID = {}
local gCachedUploadTaskRecordID = {}
function NetIngMarryPhoto.Ins()
  if NetIngMarryPhoto.ins == nil then
    NetIngMarryPhoto.ins = NetIngMarryPhoto.new()
  end
  return NetIngMarryPhoto.ins
end
function NetIngMarryPhoto:Initialize()
  EventManager.Me():AddEventListener(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, self.OnRecvOverseasPhotoUploadCmd, self)
  self.stopFormUploadFlag = {}
end
function NetIngMarryPhoto:Download(marry_id, pos_index, photo_id, timestamp, progress_callback, success_callback, error_callback, o_or_t)
  local tempDownloadRootPath = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadRootPathOfLocal()
  if not FileHelper.ExistDirectory(tempDownloadRootPath) then
    FileHelper.CreateDirectory(tempDownloadRootPath)
  end
  local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadPathOfLocal(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  if table.ContainsKey(gCachedDownloadTaskRecordID, key) then
    local taskRecordID = gCachedDownloadTaskRecordID[key]
    if self:IsDownloading(photo_id, o_or_t) then
      CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
    else
      if FileHelper.ExistFile(path) then
        FileHelper.DeleteFile(path)
      end
      ServiceOverseasTaiwanCmdProxy.Instance:GetDownLoadPath(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_WEDDING, function(data)
        local newURL = GoogleStorageConfig.googleStorageDownLoad .. "/" .. data.path .. "/" .. self:GetPathOfServer(marry_id, pos_index)
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
    ServiceOverseasTaiwanCmdProxy.Instance:GetDownLoadPath(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_WEDDING, function(data)
      local url = GoogleStorageConfig.googleStorageDownLoad .. "/" .. data.path .. "/" .. self:GetPathOfServer(marry_id, pos_index)
      helplog("download newURL scene " .. url)
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
function NetIngMarryPhoto:IsDownloading(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    return taskRecord.State == CloudFile.E_TaskState.None or taskRecord.State == CloudFile.E_TaskState.Progress
  end
  return false
end
function NetIngMarryPhoto:StopDownload(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end
local operatorName = GamePhoto.upyunOperatorName
local formUploadCallbacks = {}
function NetIngMarryPhoto:FormUpload(pos_index, photo_id, progress_callback, success_callback, error_callback)
  formUploadCallbacks[pos_index] = {
    photoID = photo_id,
    progressCallback = progress_callback,
    successCallback = success_callback,
    errorCallback = error_callback
  }
  ServiceOverseasTaiwanCmdProxy.Instance:GetUpLoadSign(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_WEDDING, pos_index)
  self.stopFormUploadFlag[photo_id] = false
end
function NetIngMarryPhoto:OnRecvOverseasPhotoUploadCmd(message)
  local eType = message.type
  if eType == 4 then
    local result = OverseaHostHelper:GenUpLoadSignObj(message.fields)
    local posIndex = message.photoId
    local photoID = formUploadCallbacks[posIndex].photoID
    if not self.stopFormUploadFlag[photoID] then
      self:OverseaDoFormUpload(photoID, result.signObj, result.uploadUrl, formUploadCallbacks[posIndex].progressCallback, formUploadCallbacks[posIndex].successCallback, formUploadCallbacks[posIndex].errorCallback)
    end
    formUploadCallbacks[posIndex] = nil
  end
end
function NetIngMarryPhoto:OverseaDoFormUpload(photo_id, signObj, url, progress_callback, success_callback, error_callback)
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
    local taskRecordID = CloudFile.CloudFileManager.Ins:NormalUploadGoogleStorage(path, url, signObj, progress_callback, success_callback, error_callback, nil)
    if taskRecordID > 0 then
      gCachedUploadTaskRecordID[photo_id] = taskRecordID
    end
  end
end
function NetIngMarryPhoto:OnReceiveUploadSceneryPhotoUserCmd(message)
  local eType = message.type
  if eType == SceneUser2_pb.EALBUMTYPE_WEDDING then
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
function NetIngMarryPhoto:DoFormUpload(photo_id, policy, authorization, progress_callback, success_callback, error_callback)
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
function NetIngMarryPhoto:StopFormUpload(photo_id)
  self.stopFormUploadFlag[photo_id] = true
  local taskRecordID = gCachedUploadTaskRecordID[photo_id]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end
function NetIngMarryPhoto:SetUserPathOfServer(user_path)
  self.userPathOfServer = user_path
end
function NetIngMarryPhoto:GetPathOfServer(marry_id, pos_index)
  return marry_id .. "/" .. pos_index .. "." .. PhotoFileInfo.Extension
end
function NetIngMarryPhoto:GetPathOfServerWithRoleID(role_id, marry_id, pos_index)
  return self.userPathOfServer .. "/" .. role_id .. "/" .. marry_id .. "/" .. pos_index .. "." .. PhotoFileInfo.Extension
end
function NetIngMarryPhoto:GetTempDownloadRootPathOfLocal()
  return "TempUsedToDownloadMarryPhoto"
end
function NetIngMarryPhoto:GetTempDownloadPathOfLocal(photo_id, o_or_t)
  return self:GetTempDownloadRootPathOfLocal() .. "/" .. photo_id .. "_" .. (o_or_t and "o" or "t") .. "." .. PhotoFileInfo.Extension
end
function NetIngMarryPhoto:GetTempUploadRootPathOfLocal()
  return "TempUsedToUploadMarryPhoto"
end
function NetIngMarryPhoto:GetTempUploadPathOfLocal(photo_id)
  return self:GetTempUploadRootPathOfLocal() .. "/" .. photo_id .. "." .. PhotoFileInfo.Extension
end
