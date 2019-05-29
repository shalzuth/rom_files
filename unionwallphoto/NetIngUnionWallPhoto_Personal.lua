autoImport("XDCDNInfo")
autoImport("NetIngPersonalPhoto")
NetIngUnionWallPhoto_Personal = class("NetIngUnionWallPhoto_Personal")
local gCachedDownloadTaskRecordID = {}
function NetIngUnionWallPhoto_Personal.Ins()
  if NetIngUnionWallPhoto_Personal.ins == null then
    NetIngUnionWallPhoto_Personal.ins = NetIngUnionWallPhoto_Personal.new()
  end
  return NetIngUnionWallPhoto_Personal.ins
end
function NetIngUnionWallPhoto_Personal:Download(role_id, pos_index, photo_id, timestamp, progress_callback, success_callback, error_callback, o_or_t, extension)
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
      local newURL = fileServerURL .. "/" .. self:GetPathOfServer(role_id, pos_index, extension) .. (o_or_t and "" or "!100") .. "?t=" .. timestamp
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
    local url = fileServerURL .. "/" .. self:GetPathOfServer(role_id, pos_index, extension) .. (o_or_t and "" or "!100") .. "?t=" .. timestamp
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
function NetIngUnionWallPhoto_Personal:IsDownloading(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    return taskRecord.State == CloudFile.E_TaskState.None or taskRecord.State == CloudFile.E_TaskState.Progress
  end
  return false
end
function NetIngUnionWallPhoto_Personal:StopDownload(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end
function NetIngUnionWallPhoto_Personal:ClearTempDownloadFileOfRole(role_id)
  local rootPath = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadRootPathOfLocal()
  local sFileName = FileHelper.GetChildrenName(rootPath)
  for i = 1, #sFileName do
    local fileName = sFileName[i]
    local nameExceptExtension = StringUtility.Split(fileName, ".")[1]
    local strRoleID = StringUtility.Split(nameExceptExtension, "_")[1]
    local roleID = tonumber(strRoleID)
    if roleID == role_id then
      local localPath = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadPathOfLocal_FileName(fileName)
      FileHelper.DeleteFile(localPath)
    end
  end
end
function NetIngUnionWallPhoto_Personal:SetUserPathOfServer(user_path)
  self.userPathOfServer = user_path
end
function NetIngUnionWallPhoto_Personal:GetPathOfServer(role_id, pos_index, pExtension)
  local extension = PhotoFileInfo.Extension
  if pExtension ~= nil then
    extension = pExtension
  end
  return self.userPathOfServer .. "/" .. role_id .. "/" .. pos_index .. "." .. extension
end
function NetIngUnionWallPhoto_Personal:GetTempDownloadRootPathOfLocal()
  return "TempUsedToDownloadUnionWallPhoto"
end
function NetIngUnionWallPhoto_Personal:GetTempDownloadPathOfLocal(photo_id, o_or_t, pExtension)
  local extension = PhotoFileInfo.Extension
  if pExtension ~= nil then
    extension = pExtension
  end
  local fileName = photo_id .. "_" .. (o_or_t and "o" or "t") .. "." .. extension
  return self:GetTempDownloadPathOfLocal_FileName(fileName)
end
function NetIngUnionWallPhoto_Personal:GetTempDownloadPathOfLocal_FileName(file_name)
  return self:GetTempDownloadRootPathOfLocal() .. "/" .. file_name
end
function NetIngUnionWallPhoto_Personal:CheckExist(role_id, pos_index, exist_callback, error_callback, extension)
  NetIngPersonalPhoto.Ins():CheckExist(role_id, pos_index, exist_callback, error_callback, extension)
end
