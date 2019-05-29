autoImport("LocalMarryPhoto")
autoImport("NetIngMarryPhoto")
autoImport("MarryPhotoCallback")
MarryPhoto = class("MarryPhoto")
MarryPhoto.thumbnailCoefficient = 0.1
function MarryPhoto.Ins()
  if MarryPhoto.ins == nil then
    MarryPhoto.ins = MarryPhoto.new()
  end
  return MarryPhoto.ins
end
function MarryPhoto:Initialize()
  NetIngMarryPhoto.Ins():Initialize()
  self.callback = MarryPhotoCallback.new()
  self.isGetingOForMakeT = {}
  self.isMakingTWhenGetThumbnail = {}
  self.willStopMakeThumbnailWhenGetThumbnail = {}
  self.isSaving = {}
  self.willStopMakeThumbnailWhenSaveUpload = {}
  self.isMakingTWhenSaveAndUpload = {}
  self.isGettingO = {}
  self.isGettingT = {}
end
function MarryPhoto:GetOriginImage(marry_id, pos_index, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_marryphotocallback)
  local photoID = self:GetPhotoID(marry_id, pos_index)
  if not is_through_marryphotocallback then
    if not is_keep_previous_callback then
      self.callback:ClearCallback(photoID, true)
    end
    self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, true)
    if self:IsGettingO(photoID) then
      return
    end
    self.isGettingO[photoID] = 0
  end
  local isLatestLocal = false
  local localTimestamp = LocalMarryPhoto.Ins():GetTimestamp(photoID, true)
  if localTimestamp ~= nil then
    isLatestLocal = timestamp <= localTimestamp
  else
    isLatestLocal = false
  end
  if isLatestLocal then
    local bytes = LocalMarryPhoto.Ins():Get(photoID, localTimestamp, true)
    self.isGettingO[photoID] = nil
    self.callback:FireSuccess(photoID, bytes, localTimestamp, true)
    if is_through_marryphotocallback and success_callback ~= nil then
      success_callback(bytes, localTimestamp)
    end
  else
    local isDownloading = NetIngMarryPhoto.Ins():IsDownloading(photoID, true)
    if not isDownloading then
      local downloadPath = ApplicationHelper.persistentDataPath .. "/" .. NetIngMarryPhoto.Ins():GetTempDownloadPathOfLocal(photoID, true)
      NetIngMarryPhoto.Ins():Download(marry_id, pos_index, photoID, timestamp, function(x)
        local progressValue = x
        self.callback:FireProgress(photoID, progressValue, true)
        if is_through_marryphotocallback and progress_callback ~= nil then
          progress_callback(progressValue)
        end
      end, function()
        local bytes = FileHelper.LoadFile(downloadPath)
        FileHelper.DeleteFile(downloadPath)
        LocalMarryPhoto.Ins():Save(photoID, bytes, timestamp, true)
        self.isGettingO[photoID] = nil
        self.callback:FireSuccess(photoID, bytes, timestamp, true)
        if is_through_marryphotocallback and success_callback ~= nil then
          success_callback(bytes, timestamp)
        end
      end, function(x)
        if FileHelper.ExistFile(downloadPath) then
          FileHelper.DeleteFile(downloadPath)
        end
        local errorMessage = x
        self.isGettingO[photoID] = nil
        self.callback:FireError(photoID, errorMessage, true)
        if is_through_marryphotocallback and error_callback ~= nil then
          error_callback(errorMessage)
        end
      end, true)
    else
    end
  end
end
function MarryPhoto:IsGettingO(photo_id)
  return self.isGettingO[photo_id] ~= nil
end
function MarryPhoto:StopGetOriginImage(marry_id, pos_index)
  local photoID = self:GetPhotoID(marry_id, pos_index)
  NetIngMarryPhoto.Ins():StopDownload(photoID, true)
end
function MarryPhoto:GetThumbnail(marry_id, pos_index, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
  local photoID = self:GetPhotoID(marry_id, pos_index)
  if not is_keep_previous_callback then
    self.callback:ClearCallback(photoID, false)
  end
  self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, false)
  if self:IsGettingT(photoID) then
    return
  end
  self.isGettingT[photoID] = 0
  local isLatestLocal = false
  local localTimestamp = LocalMarryPhoto.Ins():GetTimestamp(photoID, false)
  if localTimestamp ~= nil then
    isLatestLocal = timestamp <= localTimestamp
  else
    isLatestLocal = false
  end
  if isLatestLocal then
    local bytes = LocalMarryPhoto.Ins():Get(photoID, localTimestamp, false)
    self.isGettingT[photoID] = nil
    self.callback:FireSuccess(photoID, bytes, localTimestamp, false)
  else
    local isDownloading = NetIngMarryPhoto.Ins():IsDownloading(photoID, false)
    if not isDownloading and not self:IsGetingOForMakeT(photoID) and not self:IsMakingTWhenGetThumbnail(photoID) then
      local downloadPath = ApplicationHelper.persistentDataPath .. "/" .. NetIngMarryPhoto.Ins():GetTempDownloadPathOfLocal(photoID, false)
      NetIngMarryPhoto.Ins():Download(marry_id, pos_index, photoID, timestamp, function(x)
        local progressValue = x
        self.callback:FireProgress(photoID, progressValue, false)
      end, function()
        local bytes = FileHelper.LoadFile(downloadPath)
        FileHelper.DeleteFile(downloadPath)
        LocalMarryPhoto.Ins():Save(photoID, bytes, timestamp, false)
        self.isGettingT[photoID] = nil
        self.callback:FireSuccess(photoID, bytes, timestamp, false)
      end, function()
        if FileHelper.ExistFile(downloadPath) then
          FileHelper.DeleteFile(downloadPath)
        end
        self.isGetingOForMakeT[photoID] = 0
        self:GetOriginImage(marry_id, pos_index, timestamp, nil, function(x, y)
          self.isGetingOForMakeT[photoID] = nil
          local bytesOfOriginImage = x
          local timestampOfOriginImage = y
          local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
          ImageConversion.LoadImage(texture, bytesOfOriginImage)
          self.isMakingTWhenGetThumbnail[photoID] = 0
          FunctionTextureScale.ins:Scale(texture, MarryPhoto.thumbnailCoefficient, function(x)
            Object.DestroyImmediate(texture)
            local scaledTexture = x
            if self.willStopMakeThumbnailWhenGetThumbnail[photoID] ~= nil then
              Object.DestroyImmediate(scaledTexture)
              self.isMakingTWhenGetThumbnail[photoID] = nil
              self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
            else
              local bytes = ImageConversion.EncodeToJPG(scaledTexture)
              Object.DestroyImmediate(scaledTexture)
              LocalMarryPhoto.Ins():Save(photoID, bytes, timestampOfOriginImage, false)
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
end
function MarryPhoto:IsGettingT(photo_id)
  return self.isGettingT[photo_id] ~= nil
end
function MarryPhoto:IsGetingOForMakeT(photo_id)
  return self.isGetingOForMakeT[photo_id] ~= nil
end
function MarryPhoto:IsMakingTWhenGetThumbnail(photo_id)
  return self.isMakingTWhenGetThumbnail[photo_id] ~= nil
end
function MarryPhoto:StopGetThumbnail(marry_id, pos_index)
  local photoID = self:GetPhotoID(marry_id, pos_index)
  NetIngMarryPhoto.Ins():StopDownload(photoID, false)
  if self:IsGetingOForMakeT(photoID) then
    self:StopGetOriginImage(marry_id, pos_index)
  elseif self:IsMakingTWhenGetThumbnail(photoID) then
    self.willStopMakeThumbnailWhenGetThumbnail[photoID] = 0
  end
end
function MarryPhoto:SaveAndUpload(marry_id, pos_index, bytes, timestamp, progress_callback, success_callback, error_callback)
  local md5IsCorrect = false
  local correctMD5 = GamePhoto.GetPhotoFileMD5_Marry(pos_index)
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
  local photoID = self:GetPhotoID(marry_id, pos_index)
  if self:IsSaving(photoID) then
    LogUtility.Info("FAST HAND!")
  else
    self:StopSaveAndUpload(marry_id, pos_index)
    self:StopGetOriginImage(marry_id, pos_index)
    self:StopGetThumbnail(marry_id, pos_index)
    self:ClearLocal(marry_id, pos_index)
    local m = self.isSaving[photoID]
    m = m or 0
    m = m + 1
    self.isSaving[photoID] = m
    LocalMarryPhoto.Ins():SaveAsync(photoID, bytes, timestamp, function()
      local tempUploadRootPath = ApplicationHelper.persistentDataPath .. "/" .. NetIngMarryPhoto.Ins():GetTempUploadRootPathOfLocal()
      if not FileHelper.ExistDirectory(tempUploadRootPath) then
        FileHelper.CreateDirectory(tempUploadRootPath)
      end
      local tempUploadPathOfLocal = ApplicationHelper.persistentDataPath .. "/" .. NetIngMarryPhoto.Ins():GetTempUploadPathOfLocal(photoID)
      FileDirectoryHandler.WriteFile(tempUploadPathOfLocal, bytes, function()
        local n = self.isSaving[photoID]
        n = n - 1
        self.isSaving[photoID] = n
        NetIngMarryPhoto.Ins():FormUpload(pos_index, photoID, progress_callback, function()
          FileHelper.DeleteFile(tempUploadPathOfLocal)
          if success_callback ~= nil then
            success_callback()
          end
        end, error_callback)
      end)
    end, true)
  end
end
function MarryPhoto:IsSaving(photo_id)
  local m = self.isSaving[photo_id]
  return m ~= nil and m > 0
end
function MarryPhoto:IsMakingTWhenSaveAndUpload(photo_id)
  return self.isMakingTWhenSaveAndUpload[photo_id] ~= nil
end
function MarryPhoto:StopSaveAndUpload(marry_id, pos_index)
  self:StopUpload(marry_id, pos_index)
  local photoID = self:GetPhotoID(marry_id, pos_index)
  if self:IsMakingTWhenSaveAndUpload(photoID) then
    self.willStopMakeThumbnailWhenSaveUpload[photoID] = 0
  end
end
function MarryPhoto:StopUpload(marry_id, pos_index)
  local photoID = self:GetPhotoID(marry_id, pos_index)
  NetIngPersonalPhoto.Ins():StopFormUpload(photoID)
end
function MarryPhoto:Clear(marry_id, pos_index)
  self:StopSaveAndUpload(marry_id, pos_index)
  self:StopGetOriginImage(marry_id, pos_index)
  self:StopGetThumbnail(marry_id, pos_index)
  self:ClearLocal(marry_id, pos_index)
end
function MarryPhoto:ClearLocal(marry_id, pos_index)
  local photoID = self:GetPhotoID(marry_id, pos_index)
  local downloadOPath = ApplicationHelper.persistentDataPath .. "/" .. NetIngMarryPhoto.Ins():GetTempDownloadPathOfLocal(photoID, true)
  if FileHelper.ExistFile(downloadOPath) then
    FileHelper.DeleteFile(downloadOPath)
  end
  local downloadTPath = ApplicationHelper.persistentDataPath .. "/" .. NetIngMarryPhoto.Ins():GetTempDownloadPathOfLocal(photoID, false)
  if FileHelper.ExistFile(downloadTPath) then
    FileHelper.DeleteFile(downloadTPath)
  end
  local tempUploadPathOfLocal = ApplicationHelper.persistentDataPath .. "/" .. NetIngMarryPhoto.Ins():GetTempUploadPathOfLocal(photoID)
  if FileHelper.ExistFile(tempUploadPathOfLocal) then
    FileHelper.DeleteFile(tempUploadPathOfLocal)
  end
  LocalMarryPhoto.Ins():Delete(photoID, true)
end
function MarryPhoto:GetPhotoID(marry_id, pos_index)
  return marry_id .. "_" .. pos_index
end
