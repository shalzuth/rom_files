autoImport("PhotoFileInfo")
autoImport("GamePhoto")
NetIngScenicSpotPhotoNew = class("NetIngScenicSpotPhotoNew", NetIngScenicSpotPhoto)
local gCachedDownloadTaskRecordID = {}
local gCachedUploadTaskRecordID = {}
function NetIngScenicSpotPhotoNew.Ins()
  if NetIngScenicSpotPhotoNew.ins == null then
    NetIngScenicSpotPhotoNew.ins = NetIngScenicSpotPhotoNew.new()
  end
  return NetIngScenicSpotPhotoNew.ins
end
function NetIngScenicSpotPhotoNew:Download(role_id, scenic_spot_id, photo_id, timestamp, progress_callback, success_callback, error_callback, o_or_t, extension)
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
      local fileServerURL = XDCDNInfo.GetFileServerURL()
      local newURL = fileServerURL .. "/" .. self:GetPathOfServer(scenic_spot_id, extension)
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
    local url = fileServerURL .. "/" .. self:GetPathOfServerWithRoleID(role_id, scenic_spot_id, extension)
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
function NetIngScenicSpotPhotoNew:DownloadNew(scenic_spot_id, photo_id, timestamp, progress_callback, success_callback, error_callback, o_or_t)
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
      local newURL = fileServerURL .. "/" .. self:GetPathOfServerNew(scenic_spot_id)
      helplog("DownloadNew newURL" .. newURL)
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
    local url = fileServerURL .. "/" .. self:GetPathOfServerNew(scenic_spot_id)
    helplog("DownloadNew url" .. url)
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
function NetIngScenicSpotPhotoNew:IsDownloading(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    return taskRecord.State == CloudFile.E_TaskState.Progress or taskRecord.State == CloudFile.E_TaskState.None
  end
  return false
end
function NetIngScenicSpotPhotoNew:StopDownload(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end
function NetIngScenicSpotPhotoNew:Upload(scenic_spot_id, progress_callback, success_callback, error_callback)
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
    self:FormUpload(scenic_spot_id, progress_callback, success_callback, error_callback)
  end
end
function NetIngScenicSpotPhotoNew:SetUserPathOfServerNew(user_path)
  self.userPathOfServerNew = user_path
end
function NetIngScenicSpotPhotoNew:GetPathOfServerNew(scenic_spot_id)
  return self.userPathOfServerNew .. "/" .. GamePhoto.playerAccount .. "/" .. scenic_spot_id .. "." .. PhotoFileInfo.Extension
end
function NetIngScenicSpotPhotoNew:GetTempDownloadPathOfLocal(photo_id, o_or_t, pExtension)
  local extension = PhotoFileInfo.Extension
  if pExtension ~= nil then
    extension = pExtension
  end
  return self:GetTempDownloadRootPathOfLocal() .. "/" .. photo_id .. "_" .. (o_or_t and "o" or "t") .. "." .. extension
end
