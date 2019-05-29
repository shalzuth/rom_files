autoImport("GamePhoto")
NetIngStagePhoto = class("NetIngStagePhoto")
local gCachedDownloadTaskRecordID = {}
local gCachedUploadTaskRecordID = {}
function NetIngStagePhoto.Ins()
  if NetIngStagePhoto.ins == nil then
    NetIngStagePhoto.ins = NetIngStagePhoto.new()
  end
  return NetIngStagePhoto.ins
end
function NetIngStagePhoto:Initialize()
  EventManager.Me():AddEventListener(ServiceEvent.NUserUploadSceneryPhotoUserCmd, self.OnReceiveUploadSceneryPhotoUserCmd, self)
  self.stopFormUploadFlag = {}
end
function NetIngStagePhoto:Download(session_id, acc_id, photo_id, timestamp, progress_callback, success_callback, error_callback, o_or_t)
  print(string.format([[
NetIngStagePhoto:Download
acc_id=%s]], tostring(acc_id)))
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
      local fileServerURL = XDCDNInfo.GetFileServerURL()
      local newURL = fileServerURL .. "/" .. self:GetPathOfServer(session_id, acc_id) .. (o_or_t and "" or "!100") .. "?t=" .. timestamp
      local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
      taskRecord.URL = newURL
      CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
      CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
      CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
    end
  else
    if FileHelper.ExistFile(path) then
      FileHelper.DeleteFile(path)
    end
    local fileServerURL = XDCDNInfo.GetFileServerURL()
    local url = fileServerURL .. "/" .. self:GetPathOfServer(session_id, acc_id) .. (o_or_t and "" or "!100") .. "?t=" .. timestamp
    local taskRecordID
    if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
      taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback, success_callback, error_callback, nil)
    else
      taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback, success_callback, error_callback)
    end
    if taskRecordID > 0 then
      gCachedDownloadTaskRecordID[key] = taskRecordID
    end
  end
end
function NetIngStagePhoto:IsDownloading(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    return taskRecord.State == CloudFile.E_TaskState.None or taskRecord.State == CloudFile.E_TaskState.Progress
  end
  return false
end
function NetIngStagePhoto:StopDownload(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end
local operatorName = GamePhoto.upyunOperatorName
local formUploadCallbacks = {}
function NetIngStagePhoto:FormUpload(session_id, photo_id, progress_callback, success_callback, error_callback)
  formUploadCallbacks[session_id] = {
    photoID = photo_id,
    progressCallback = progress_callback,
    successCallback = success_callback,
    errorCallback = error_callback
  }
  ServiceNUserProxy.Instance:CallUploadSceneryPhotoUserCmd(SceneUser2_pb.EALBUMTYPE_STAGE, session_id)
  self.stopFormUploadFlag[photo_id] = false
end
function NetIngStagePhoto:OnReceiveUploadSceneryPhotoUserCmd(message)
  print("NetIngStagePhoto:OnReceiveUploadSceneryPhotoUserCmd")
  local eType = message.type
  if eType == SceneUser2_pb.EALBUMTYPE_STAGE then
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
function NetIngStagePhoto:DoFormUpload(photo_id, policy, authorization, progress_callback, success_callback, error_callback)
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
function NetIngStagePhoto:StopFormUpload(photo_id)
  self.stopFormUploadFlag[photo_id] = true
  local taskRecordID = gCachedUploadTaskRecordID[photo_id]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end
function NetIngStagePhoto:SetUserPathOfServer(user_path)
  self.userPathOfServer = user_path
end
function NetIngStagePhoto:GetPathOfServer(session_id, acc_id)
  return self:GetPathOfServerWithRoleID(Game.Myself.data.id, session_id, acc_id)
end
function NetIngStagePhoto:GetPathOfServerWithRoleID(role_id, session_id, acc_id)
  return self.userPathOfServer .. "/" .. role_id .. "/" .. session_id .. "/" .. acc_id .. "." .. PhotoFileInfo.Extension
end
function NetIngStagePhoto:GetTempDownloadRootPathOfLocal()
  return "TempUsedToDownloadStagePhoto"
end
function NetIngStagePhoto:GetTempDownloadPathOfLocal(photo_id, o_or_t)
  return self:GetTempDownloadRootPathOfLocal() .. "/" .. photo_id .. "_" .. (o_or_t and "o" or "t") .. "." .. PhotoFileInfo.Extension
end
function NetIngStagePhoto:GetTempUploadRootPathOfLocal()
  return "TempUsedToUploadStagePhoto"
end
function NetIngStagePhoto:GetTempUploadPathOfLocal(photo_id)
  return self:GetTempUploadRootPathOfLocal() .. "/" .. photo_id .. "." .. PhotoFileInfo.Extension
end
