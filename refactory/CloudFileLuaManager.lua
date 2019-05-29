CloudFileLuaManager = class("CloudFileLuaManager")
CloudFileLuaManager.DownloadState = {
  None = 1,
  Progress = 2,
  Done = 3,
  Interrupt = 4
}
function CloudFileLuaManager.Instance()
  if nil == CloudFileLuaManager.me then
    CloudFileLuaManager.me = CloudFileLuaManager.new()
  end
  return CloudFileLuaManager.me
end
function CloudFileLuaManager:ctor()
  self.count = 10
  self.recordMap = {}
  self.recordList = {}
  self.callBacksMap = {}
  self.recordIDGenerator = 0
end
function CloudFileLuaManager:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  local record = self.callBacksMap[taskRecordID]
  if not record then
    self.callBacksMap[taskRecordID] = {
      progressCallBack = progress_callback,
      successCallBack = success_callback,
      errorCallBack = error_callback
    }
  end
end
function CloudFileLuaManager:UnregisterCallback(taskRecordID)
  self.callBacksMap[taskRecordID] = nil
end
function CloudFileLuaManager:GetTaskRecord(taskRecordID)
  return self.recordMap[taskRecordID]
end
function CloudFileLuaManager:RestartTask(taskRecordID)
  local record = self.recordMap[taskRecordID]
  if record then
    self:StartDownload(record)
  end
end
function CloudFileLuaManager:Download(url, path, progress_callback, success_callback, error_callback)
  local record = self:CreateNewRecord(url, path)
  self:RegisterCallback(record.id, progress_callback, success_callback, error_callback)
  self:StartDownload(record)
  return record.id
end
function CloudFileLuaManager:CreateNewRecord(url, path)
  local recordId = self:GetNewRecordID()
  local newRecord = {
    id = recordId,
    Url = url,
    Path = path,
    State = CloudFileLuaManager.DownloadState.None,
    RestartTimes = 3
  }
  self.recordList[#self.recordList + 1] = newRecord
  self.recordMap[recordId] = newRecord
  return newRecord
end
function CloudFileLuaManager:GetNewRecordID()
  self.recordIDGenerator = self.recordIDGenerator + 1
  return self.recordIDGenerator
end
function CloudFileLuaManager:StopTask(recordId)
  local record = self.recordMap[recordId]
  if record then
    record.State = CloudFileLuaManager.DownloadState.Interrupt
  end
end
function CloudFileLuaManager:StartDownload(record)
  local recordCallBacks = self.callBacksMap[record.id]
  local c = coroutine.create(function()
    local www = WWW(record.Url)
    record.State = CloudFileLuaManager.DownloadState.Progress
    if ApplicationInfo.IsWindows() then
      CloudFile.CloudFileManager.AddServerCertificateValidationCallback()
    end
    while not www.isDone do
      if recordCallBacks.progressCallBack then
        recordCallBacks.progressCallBack(www.progress)
      end
      if record.State ~= CloudFileLuaManager.DownloadState.Interrupt then
        Yield()
      end
    end
    if recordCallBacks.progressCallBack then
      recordCallBacks.progressCallBack(www.progress)
    end
    if record.State ~= CloudFileLuaManager.DownloadState.Interrupt then
      Yield(www)
      if www.isDone then
        if www.error == nil or www.error == "" then
          if record.Path ~= "" then
            local file = io.open(record.Path, "wb")
            if file ~= nil then
              file:write(Slua.ToString(www.bytes))
              file:flush()
              file:close()
            end
          end
          record.State = CloudFileLuaManager.DownloadState.Done
          if recordCallBacks.successCallBack then
            recordCallBacks.successCallBack(www.bytes)
          end
          www:Dispose()
        elseif record.RestartTimes > 0 then
          record.leanTween = LeanTween.delayedCall(1, function()
            record.RestartTimes = record.RestartTimes - 1
            record.leanTween:cancel()
            record.leanTween = nil
            self:RestartTask(record.id)
          end)
          www:Dispose()
        else
          if recordCallBacks.errorCallBack then
            recordCallBacks.errorCallBack(www.error)
          end
          self.recordMap[record.id] = nil
          www:Dispose()
        end
      else
        self.recordMap[record.id] = nil
        www:Dispose()
      end
    else
      self.recordMap[record.id] = nil
      www:Dispose()
    end
  end)
  coroutine.resume(c)
end
