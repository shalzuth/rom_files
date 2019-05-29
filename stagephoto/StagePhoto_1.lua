autoImport("NetIngStagePhoto")
autoImport("StagePhotoCallback")
StagePhoto = class("StagePhoto")
StagePhoto.thumbnailCoefficient = 0.1
function StagePhoto.Ins()
  if StagePhoto.ins == nil then
    StagePhoto.ins = StagePhoto.new()
  end
  return StagePhoto.ins
end
function StagePhoto:Initialize()
  NetIngStagePhoto.Ins():Initialize()
  self.callback = StagePhotoCallback.new()
  self.isGetingOForMakeT = {}
  self.isMakingTWhenGetThumbnail = {}
  self.willStopMakeThumbnailWhenGetThumbnail = {}
  self.isSaving = {}
  self.willStopMakeThumbnailWhenSaveUpload = {}
  self.isMakingTWhenSaveAndUpload = {}
  self.isGettingO = {}
  self.isGettingT = {}
end
function StagePhoto:GetOriginImage(session_id, acc_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_Stagephotocallback)
  print(string.format([[
StagePhoto:GetOriginImage
acc_id=%s
timestamp=%s
is_keep_previous_callback=%s]], tostring(acc_id), tostring(timestamp), tostring(is_keep_previous_callback)))
  local photoID = self:GetPhotoID(session_id, acc_id)
  if not is_through_Stagephotocallback then
    if not is_keep_previous_callback then
      self.callback:ClearCallback(photoID, true)
    end
    self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, true)
    if self:IsGettingO(photoID) then
      return
    end
    self.isGettingO[photoID] = 0
  end
  local isDownloading = NetIngStagePhoto.Ins():IsDownloading(photoID, true)
  if not isDownloading then
    do
      local downloadPath = ApplicationHelper.persistentDataPath .. "/" .. NetIngStagePhoto.Ins():GetTempDownloadPathOfLocal(photoID, true)
      NetIngStagePhoto.Ins():Download(session_id, acc_id, photoID, timestamp, function(x)
        local progressValue = x
        self.callback:FireProgress(photoID, progressValue, true)
        if is_through_Stagephotocallback and progress_callback ~= nil then
          progress_callback(progressValue)
        end
      end, function()
        local bytes = FileHelper.LoadFile(downloadPath)
        FileHelper.DeleteFile(downloadPath)
        self.isGettingO[photoID] = nil
        self.callback:FireSuccess(photoID, bytes, timestamp, true)
        if is_through_Stagephotocallback and success_callback ~= nil then
          success_callback(bytes, timestamp)
        end
      end, function(x)
        if FileHelper.ExistFile(downloadPath) then
          FileHelper.DeleteFile(downloadPath)
        end
        local errorMessage = x
        self.isGettingO[photoID] = nil
        self.callback:FireError(photoID, errorMessage, true)
        if is_through_Stagephotocallback and error_callback ~= nil then
          error_callback(errorMessage)
        end
      end, true)
    end
  else
  end
end
function StagePhoto:IsGettingO(photo_id)
  return self.isGettingO[photo_id] ~= nil
end
function StagePhoto:StopGetOriginImage(session_id, acc_id)
  local photoID = self:GetPhotoID(session_id, acc_id)
  NetIngStagePhoto.Ins():StopDownload(photoID, true)
end
function StagePhoto:GetThumbnail(session_id, acc_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
  print(string.format([[
StagePhoto:GetThumbnail
acc_id=%s
timestamp=%s
is_keep_previous_callback=%s]], tostring(acc_id), tostring(timestamp), tostring(is_keep_previous_callback)))
  local photoID = self:GetPhotoID(session_id, acc_id)
  if not is_keep_previous_callback then
    self.callback:ClearCallback(photoID, false)
  end
  self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, false)
  if self:IsGettingT(photoID) then
    return
  end
  self.isGettingT[photoID] = 0
  local isDownloading = NetIngStagePhoto.Ins():IsDownloading(photoID, false)
  if not isDownloading and not self:IsGetingOForMakeT(photoID) and not self:IsMakingTWhenGetThumbnail(photoID) then
    local downloadPath = ApplicationHelper.persistentDataPath .. "/" .. NetIngStagePhoto.Ins():GetTempDownloadPathOfLocal(photoID, false)
    NetIngStagePhoto.Ins():Download(session_id, acc_id, photoID, timestamp, function(x)
      local progressValue = x
      self.callback:FireProgress(photoID, progressValue, false)
    end, function()
      local bytes = FileHelper.LoadFile(downloadPath)
      FileHelper.DeleteFile(downloadPath)
      self.isGettingT[photoID] = nil
      self.callback:FireSuccess(photoID, bytes, timestamp, false)
    end, function()
      if FileHelper.ExistFile(downloadPath) then
        FileHelper.DeleteFile(downloadPath)
      end
      self.isGetingOForMakeT[photoID] = 0
      self:GetOriginImage(session_id, acc_id, timestamp, nil, function(x, y)
        self.isGetingOForMakeT[photoID] = nil
        local bytesOfOriginImage = x
        local timestampOfOriginImage = y
        local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
        ImageConversion.LoadImage(texture, bytesOfOriginImage)
        self.isMakingTWhenGetThumbnail[photoID] = 0
        FunctionTextureScale.ins:Scale(texture, StagePhoto.thumbnailCoefficient, function(x)
          Object.DestroyImmediate(texture)
          local scaledTexture = x
          if self.willStopMakeThumbnailWhenGetThumbnail[photoID] ~= nil then
            Object.DestroyImmediate(scaledTexture)
            self.isMakingTWhenGetThumbnail[photoID] = nil
            self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
          else
            local bytes = ImageConversion.EncodeToJPG(scaledTexture)
            Object.DestroyImmediate(scaledTexture)
            self.isMakingTWhenGetThumbnail[photoID] = nil
            self.isGettingT[photoID] = nil
            self.callback:FireSuccess(photoID, bytes, timestampOfOriginImage, false)
          end
        end)
      end, function(x)
        self.isGetingOForMakeT[photoID] = nil
        local errorMessage = x
        self.isGettingT[photoID] = nil
        self.callback:FireError(photoID, errorMessage, false)
      end, true, true)
    end, false)
    break
  elseif self:IsMakingTWhenGetThumbnail(photoID) then
    self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
  end
end
function StagePhoto:IsGettingT(photo_id)
  return self.isGettingT[photo_id] ~= nil
end
function StagePhoto:IsGetingOForMakeT(photo_id)
  return self.isGetingOForMakeT[photo_id] ~= nil
end
function StagePhoto:IsMakingTWhenGetThumbnail(photo_id)
  return self.isMakingTWhenGetThumbnail[photo_id] ~= nil
end
function StagePhoto:StopGetThumbnail(session_id, acc_id)
  local photoID = self:GetPhotoID(session_id, acc_id)
  NetIngStagePhoto.Ins():StopDownload(photoID, false)
  if self:IsGetingOForMakeT(photoID) then
    self:StopGetOriginImage(session_id, acc_id)
  elseif self:IsMakingTWhenGetThumbnail(photoID) then
    self.willStopMakeThumbnailWhenGetThumbnail[photoID] = 0
  end
end
function StagePhoto:SaveAndUpload(session_id, acc_id, bytes, timestamp, progress_callback, success_callback, error_callback)
  print(string.format([[
StagePhoto:SaveAndUpload
acc_id=%s
timestamp=%s]], tostring(acc_id), tostring(timestamp)))
  local md5IsCorrect = false
  local correctMD5 = GamePhoto.GetPhotoFileMD5_Stage(acc_id)
  if correctMD5 ~= nil then
    local currentMD5 = MyMD5.HashBytes(bytes)
    md5IsCorrect = currentMD5 == correctMD5
  end
  if not md5IsCorrect then
    MsgManager.ShowMsgByID(3706)
    if error_callback ~= nil then
      error_callback("Error file.")
    end
    return
  end
  local photoID = self:GetPhotoID(session_id, acc_id)
  if self:IsSaving(photoID) then
    Debug.LogError("FAST HAND!")
  else
    self:StopSaveAndUpload(session_id, acc_id)
    self:StopGetOriginImage(session_id, acc_id)
    self:StopGetThumbnail(session_id, acc_id)
    local m = self.isSaving[photoID]
    m = m or 0
    m = m + 1
    self.isSaving[photoID] = m
    local tempUploadRootPath = ApplicationHelper.persistentDataPath .. "/" .. NetIngStagePhoto.Ins():GetTempUploadRootPathOfLocal()
    if not FileHelper.ExistDirectory(tempUploadRootPath) then
      FileHelper.CreateDirectory(tempUploadRootPath)
    end
    local tempUploadPathOfLocal = ApplicationHelper.persistentDataPath .. "/" .. NetIngStagePhoto.Ins():GetTempUploadPathOfLocal(photoID)
    FileDirectoryHandler.WriteFile(tempUploadPathOfLocal, bytes, function()
      local n = self.isSaving[photoID]
      n = n - 1
      self.isSaving[photoID] = n
      NetIngStagePhoto.Ins():FormUpload(session_id, photoID, progress_callback, function()
        FileHelper.DeleteFile(tempUploadPathOfLocal)
        if success_callback ~= nil then
          success_callback()
        end
      end, error_callback)
    end)
    break
  end
end
function StagePhoto:IsSaving(photo_id)
  local m = self.isSaving[photo_id]
  return m ~= nil and m > 0
end
function StagePhoto:IsMakingTWhenSaveAndUpload(photo_id)
  return self.isMakingTWhenSaveAndUpload[photo_id] ~= nil
end
function StagePhoto:StopSaveAndUpload(session_id, acc_id)
  self:StopUpload(session_id, acc_id)
  local photoID = self:GetPhotoID(session_id, acc_id)
  if self:IsMakingTWhenSaveAndUpload(photoID) then
    self.willStopMakeThumbnailWhenSaveUpload[photoID] = 0
  end
end
function StagePhoto:StopUpload(session_id, acc_id)
  local photoID = self:GetPhotoID(session_id, acc_id)
  NetIngPersonalPhoto.Ins():StopFormUpload(photoID)
end
function StagePhoto:Clear(session_id, acc_id)
  print(string.format([[
StagePhoto:Clear
acc_id=%s]], tostring(acc_id)))
  self:StopSaveAndUpload(session_id, acc_id)
  self:StopGetOriginImage(session_id, acc_id)
  self:StopGetThumbnail(session_id, acc_id)
end
function StagePhoto:GetPhotoID(session_id, acc_id)
  return session_id .. "_" .. acc_id
end
