ActivityTextureManager = class("ActivityTextureManager")
autoImport("IOPathConfig")
function ActivityTextureManager.Instance()
  if nil == ActivityTextureManager.me then
    ActivityTextureManager.me = ActivityTextureManager.new()
  end
  return ActivityTextureManager.me
end
function ActivityTextureManager:ctor()
  if self.toBeDownload then
    TableUtility.ArrayClear(self.toBeDownload)
  end
  self.toBeDownload = {}
  self.logEnable = false
  self.isDownloading = false
  self:initDownloadDir()
end
function ActivityTextureManager:log(...)
  if self.logEnable then
    helplog(...)
  end
end
function ActivityTextureManager:GetLocalTempFilePath(picUrl)
  local fileName = self:GetFileName(picUrl)
  if not fileName then
    return
  end
  return self:GetLocalTempRootPath() .. "/" .. fileName
end
function ActivityTextureManager:GetLocalPathByUrl(picUrl)
  local fileName = self:GetFileName(picUrl)
  if not fileName then
    return
  end
  return self:GetLocalDownFilePath() .. "/" .. fileName
end
function ActivityTextureManager:GetFileName(picUrl)
  local fileName = string.match(picUrl, ".+/([^/]*%.%w+)$")
  return fileName
end
function ActivityTextureManager:GetLocalTempRootPath()
  return ApplicationHelper.persistentDataPath .. "/" .. "TempUsedToDownloadActivityPic"
end
function ActivityTextureManager:GetLocalDownFilePath()
  return IOPathConfig.Paths.PUBLICPIC.ActivityPicture
end
function ActivityTextureManager:initDownloadDir()
  local rootPath = self:GetLocalTempRootPath()
  if not FileHelper.ExistDirectory(rootPath) then
    FileHelper.CreateDirectory(rootPath)
  end
end
function ActivityTextureManager:checkFileMd5(picUrl, bytes)
  local fileName = string.match(picUrl, ".+/([^/]*)%.%w+$")
  local md5Str = MyMD5.HashBytes(bytes)
  if fileName and fileName == md5Str then
    return true
  end
end
function ActivityTextureManager:tryGetActivityPicFromRemote(picUrl)
  self:log("ActivityTextureManager:tryGetActivityPicFromRemote start!!!", picUrl)
  self.isDownloading = true
  local tempPath = self:GetLocalTempFilePath(picUrl)
  if tempPath then
    if FileHelper.ExistFile(tempPath) then
      FileHelper.DeleteFile(tempPath)
    end
    do
      local localPath = self:GetLocalPathByUrl(picUrl)
      if not localPath then
        helplog("nil local path")
        return
      end
      if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
        local taskRecordID = CloudFile.CloudFileManager.Ins:Download(picUrl, tempPath, false, function(progress)
          self:ActivityPicProgressCallback(picUrl, progress)
        end, function()
          local bytes = FileHelper.LoadFile(tempPath)
          FileHelper.DeleteFile(tempPath)
          if self:checkFileMd5(picUrl, bytes) then
            local currentTime = ServerTime.CurServerTime() or os.time()
            currentTime = math.floor(currentTime / 1000)
            DiskFileManager.Instance:SaveFile(localPath, bytes, currentTime)
            self:ActivityPicCompleteCallback(picUrl, bytes)
          else
            self:ActivityPicErrorCallback(picUrl, "md5 check error!")
          end
        end, function(errorMessage)
          if FileHelper.ExistFile(tempPath) then
            FileHelper.DeleteFile(tempPath)
          end
          self:ActivityPicErrorCallback(picUrl, errorMessage)
        end, nil)
      else
        local taskRecordID = CloudFile.CloudFileManager.Ins:Download(picUrl, tempPath, false, function(progress)
          self:ActivityPicProgressCallback(picUrl, progress)
        end, function()
          local bytes = FileHelper.LoadFile(tempPath)
          FileHelper.DeleteFile(tempPath)
          local currentTime = ServerTime.CurServerTime() or os.time()
          currentTime = math.floor(currentTime / 1000)
          DiskFileManager.Instance:SaveFile(localPath, bytes, currentTime)
          self:ActivityPicCompleteCallback(picUrl, bytes)
        end, function(errorMessage)
          if FileHelper.ExistFile(tempPath) then
            FileHelper.DeleteFile(tempPath)
          end
          self:ActivityPicErrorCallback(picUrl, errorMessage)
        end)
      end
    end
  else
  end
end
function ActivityTextureManager:getActivityPicFromLocal(picUrl)
  local localPath = self:GetLocalPathByUrl(picUrl)
  if localPath then
    local currentTime = ServerTime.CurServerTime() or os.time()
    currentTime = math.floor(currentTime / 1000)
    local bytes = DiskFileManager.Instance:LoadFile(localPath, currentTime)
    if self:checkFileMd5(picUrl, bytes) then
      return bytes
    else
      localPath = ApplicationHelper.persistentDataPath .. "/" .. localPath
      if FileHelper.ExistFile(localPath) then
        FileHelper.DeleteFile(localPath)
      end
    end
  end
end
function ActivityTextureManager:AddActivityPicInfos(list)
  if list and #list > 0 then
    for i = 1, #list do
      self:AddSingleActivityPicInfo(list[i])
    end
    if not self.isDownloading then
      self:startTryGetActivityPic()
    end
  end
end
function ActivityTextureManager:AddSingleActivityPicInfo(picUrl)
  local bytes = self:getActivityPicFromLocal(picUrl)
  if not bytes then
    local hasIn = self:HasInToBeDownload(picUrl)
    if not hasIn then
      self.toBeDownload[#self.toBeDownload + 1] = picUrl
    end
  else
    self:ActivityPicCompleteCallback(picUrl, bytes)
  end
end
function ActivityTextureManager:HasInToBeDownload(picUrl)
  for i = 1, #self.toBeDownload do
    local single = self.toBeDownload[i]
    if single == picUrl then
      return true
    end
  end
end
function ActivityTextureManager:startTryGetActivityPic()
  if #self.toBeDownload > 0 then
    self:tryGetActivityPicFromRemote(self.toBeDownload[1])
  end
end
function ActivityTextureManager:removeDownloadTexture(picUrl)
  for j = 1, #self.toBeDownload do
    local data = self.toBeDownload[j]
    if picUrl == picUrl then
      table.remove(self.toBeDownload, j)
      break
    end
  end
end
ActivityTextureManager.ActivityPicProgressCallbackMsg = "ActivityTextureManager_ActivityPicProgressCallbackMsg"
ActivityTextureManager.ActivityPicCompleteCallbackMsg = "ActivityTextureManager_ActivityPicCompleteCallbackMsg"
ActivityTextureManager.ActivityPicErrorCallbackMsg = "ActivityTextureManager_ActivityPicErrorCallbackMsg"
function ActivityTextureManager:ActivityPicProgressCallback(picUrl, progress)
  self:log("ActivityPicProgressCallback", picUrl, progress)
  GameFacade.Instance:sendNotification(ActivityTextureManager.ActivityPicProgressCallbackMsg, {picUrl = picUrl, progress = progress})
end
function ActivityTextureManager:ActivityPicCompleteCallback(picUrl, bytes)
  self:log("ActivityPicCompleteCallback", picUrl, tostring(bytes))
  self.isDownloading = false
  self:removeDownloadTexture(picUrl)
  self:startTryGetActivityPic()
  GameFacade.Instance:sendNotification(ActivityTextureManager.ActivityPicCompleteCallbackMsg, {picUrl = picUrl, byte = bytes})
  EventManager.Me():DispatchEvent(ActivityTextureManager.ActivityPicCompleteCallbackMsg, {picUrl = picUrl, byte = bytes})
end
function ActivityTextureManager:ActivityPicErrorCallback(picUrl, errorMessage)
  self:log("ActivityPicErrorCallback", picUrl, errorMessage)
  self.isDownloading = false
  self:removeDownloadTexture(picUrl)
  self:startTryGetActivityPic()
  GameFacade.Instance:sendNotification(ActivityTextureManager.ActivityPicErrorCallbackMsg, {picUrl = picUrl})
end
