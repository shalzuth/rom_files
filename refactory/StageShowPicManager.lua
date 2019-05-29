StageShowPicManager = class("StageShowPicManager")
autoImport("PersonalPhoto")
autoImport("PersonalPhotoHelper")
function StageShowPicManager.Instance()
  if nil == StageShowPicManager.me then
    StageShowPicManager.me = StageShowPicManager.new()
  end
  return StageShowPicManager.me
end
function StageShowPicManager:ctor()
  if self.toBeDownload then
    TableUtility.ArrayClear(self.toBeDownload)
  end
  self.toBeDownload = {}
  if self.LRUTextureCache then
    TableUtility.ArrayClear(self.LRUTextureCache)
  end
  self.LRUTextureCache = {}
  self.UploadingMap = {}
  self.maxCache = 50
  self.logEnable = false
  self.isDownloading = false
end
function StageShowPicManager:log(...)
  if self.logEnable then
    helplog(...)
  end
end
function StageShowPicManager:tryGetMyThumbnail(index, time)
  self.isDownloading = true
  PersonalPhotoHelper.Ins():GetThumbnail(index, time, function(progress)
    self:MyThumbnailProgressCallback(index, time, progress)
  end, function(bytes)
    self:MyThumbnailSusCallback(index, time, bytes)
  end, function(errorMessage)
    self:MyThumbnailErrorCallback(index, time, errorMessage)
  end)
end
function StageShowPicManager:AddMyThumbnailInfos(list)
  if list and #list > 0 then
    for i = 1, #list do
      self:AddSingleMyThumbnail(list[i])
    end
    self:startTryGetMyThumbnail()
  end
end
function StageShowPicManager:AddSingleMyThumbnail(data)
  local index = data.index
  local time = data.time
  local texture = self:GetThumbnailTextureById(index, time)
  if not texture then
    local hasIn = self:HasInToBeDownload(index, time)
    if not hasIn then
      local loadData = {index = index, time = time}
      self.toBeDownload[#self.toBeDownload + 1] = loadData
    end
  end
end
function StageShowPicManager:GetPersonPicThumbnail(cell)
  local data = cell.data
  local index = data.index
  local time = data.time
  local texture = self:GetThumbnailTextureById(index, time, true)
  if texture then
    cell:setTexture(texture)
  else
    local hasIn = self:HasInToBeDownload(index, time)
    if not hasIn then
      local loadData = {index = index, time = time}
      self.toBeDownload[#self.toBeDownload + 1] = loadData
      if #self.toBeDownload > 0 then
        self:startTryGetMyThumbnail()
      end
    end
  end
end
function StageShowPicManager:HasInToBeDownload(index, time)
  for i = 1, #self.toBeDownload do
    local single = self.toBeDownload[i]
    if single.index == index and single.time == time then
      return true
    end
  end
end
function StageShowPicManager:MyThumbnailSusCallback(index, time, bytes)
  self.isDownloading = false
  local texture = Texture2D(2, 2, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    self:addThumbnailTextureById(index, time, texture)
    self:removeOldTimeData(index, time)
    self:StageShowThumbnailDownloadCompleteCallback1(index, time, bytes)
    self:removeDownloadTexture(index, time)
    self:startTryGetMyThumbnail()
  else
    self:MyThumbnailErrorCallback(index, time, "load LoadImage error!")
    Object.DestroyImmediate(texture)
  end
end
function StageShowPicManager:removePhotoCache(index, time)
  for i = 1, #self.LRUTextureCache do
    local single = self.LRUTextureCache[i]
    if single.index == index then
      local data = table.remove(self.LRUTextureCache, i)
      Object.DestroyImmediate(data.texture)
      break
    end
  end
end
function StageShowPicManager:removeOldTimeData(index, time)
  for i = 1, #self.toBeDownload do
    local single = self.toBeDownload[i]
    if single.index == index and single.time ~= time then
      table.remove(self.toBeDownload, i)
      break
    end
  end
  for i = 1, #self.LRUTextureCache do
    local single = self.LRUTextureCache[i]
    if single.index == index and single.time ~= time then
      local data = table.remove(self.LRUTextureCache, i)
      Object.DestroyImmediate(data.texture)
      break
    end
  end
end
function StageShowPicManager:MyThumbnailErrorCallback(index, time, errorMessage)
  self.isDownloading = false
  self:removeDownloadTexture(index, time)
  self:StageShowThumbnailDownloadErrorCallback1(index, time, errorMessage)
  self:startTryGetMyThumbnail()
end
function StageShowPicManager:MyThumbnailProgressCallback(index, time, progress)
  self:StageShowThumbnailDownloadProgressCallback1(index, time, progress)
end
function StageShowPicManager:startTryGetMyThumbnail()
  if #self.toBeDownload > 0 and not self.isDownloading then
    local loadData = self.toBeDownload[1]
    self:tryGetMyThumbnail(loadData.index, loadData.time)
  end
end
function StageShowPicManager:GetThumbnailTexture(index)
  local texture = self:GetThumbnailTextureById(index, true)
  if texture then
    return texture
  end
end
function StageShowPicManager:GetThumbnailTextureById(index, time, rePos)
  for i = 1, #self.LRUTextureCache do
    local single = self.LRUTextureCache[i]
    if single.index == index and single.time == time then
      if rePos then
        table.remove(self.LRUTextureCache, i)
        table.insert(self.LRUTextureCache, 1, single)
      end
      return single.texture
    end
  end
end
function StageShowPicManager:addThumbnailTextureById(index, time, texture)
  if not self:GetThumbnailTextureById(index, time) then
    if #self.LRUTextureCache > self.maxCache then
      local oldData = table.remove(self.LRUTextureCache)
      Object.DestroyImmediate(oldData.texture)
    end
    local data = {}
    data.index = index
    data.texture = texture
    data.time = time
    table.insert(self.LRUTextureCache, 1, data)
  else
    self:log("addThumbnailTextureById:exsit  index:", index)
  end
end
function StageShowPicManager:removeDownloadTexture(index, time)
  for j = 1, #self.toBeDownload do
    local data = self.toBeDownload[j]
    if index == data.index and time == data.time then
      table.remove(self.toBeDownload, j)
      break
    end
  end
end
function StageShowPicManager:saveToPhotoAlbum(texture, index, time)
  local bytes = ImageConversion.EncodeToJPG(texture)
  self.UploadingMap[index] = true
  local md5 = MyMD5.HashBytes(bytes)
  GamePhoto.SetPhotoFileMD5_Personal(index, md5)
  local pbMd5 = PhotoCmd_pb.PhotoMd5()
  pbMd5.md5 = md5
  pbMd5.sourceid = index
  pbMd5.time = time
  pbMd5.source = ProtoCommon_pb.ESOURCE_PHOTO_SELF
  ServicePhotoCmdProxy.Instance:CallAddMd5PhotoCmd(pbMd5)
  PersonalPhoto.Ins():SaveAndUpload(index, bytes, time, function(progress)
    self:log("Upload progress:", progress)
    self:StageShowOriginPhotoUploadProgressCallback1(index, time, progress)
  end, function(bytes)
    self:log("Upload sus:")
    self.UploadingMap[index] = false
    ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_UPLOAD, index)
    self:StageShowOriginPhotoUploadCompleteCallback1(index, time)
    ServicePhotoCmdProxy.Instance:CallRemoveMd5PhotoCmd(pbMd5)
  end, function(errorMessage)
    self.UploadingMap[index] = false
    self:log("Upload error:", errorMessage)
    self:StageShowOriginPhotoUploadErrorCallback1(index, time, errorMessage)
  end)
end
function StageShowPicManager:isUpLoadFailure(index)
  local photoData = PhotoDataProxy.Instance:getPhotoDataByIndex(index)
  if photoData and not photoData.isupload then
    return true
  end
end
function StageShowPicManager:isUpLoading(index)
  return self.UploadingMap[index] == true
end
function StageShowPicManager:isCanReUpLoading(index, time)
  local exsit = PersonalPhoto.Ins():CheckExistOnLocal(index)
  if exsit then
    return true
  end
end
function StageShowPicManager:removePhotoFromeAlbum(index, time)
  ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_REMOVE, index)
end
function StageShowPicManager:removeAndClearPhotoDataWhenDel(index, time)
  self:removePhotoDataWhenDel(index, time)
  PersonalPhoto.Ins():Clear(index)
end
function StageShowPicManager:removePhotoDataWhenDel(index, time)
  self:removeDownloadTexture(index, time)
  self:removeOldTimeData(index, time)
  self.UploadingMap[index] = false
  self:removePhotoCache(index, time)
end
function StageShowPicManager:UploadPhoto(index, time)
  self.UploadingMap[index] = true
  PersonalPhoto.Ins():Upload(index, function(progress)
    self:log("Upload progress:", progress)
    self:StageShowOriginPhotoUploadProgressCallback1(index, time, progress)
  end, function(bytes)
    self:log("Upload sus:")
    self.UploadingMap[index] = false
    ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_UPLOAD, index)
    self:StageShowOriginPhotoUploadCompleteCallback1(index, time)
  end, function(errorMessage)
    self.UploadingMap[index] = false
    self:log("Upload error:", errorMessage)
    self:StageShowOriginPhotoUploadErrorCallback1(index, time, errorMessage)
  end)
end
function StageShowPicManager:tryGetOriginImage(index, time)
  PersonalPhotoHelper.Ins():GetOriginImage(index, time, function(progress)
    self:StageShowOriginPhotoDownloadProgressCallback1(index, time, progress)
  end, function(bytes, timestamp)
    self:StageShowOriginPhotoDownloadCompleteCallback1(index, time, bytes)
  end, function(errorMessage)
    self:StageShowOriginPhotoDownloadErrorCallback1(index, time, errorMessage)
  end)
end
StageShowPicManager.StageShowThumbnailDownloadProgressCallback = "StageShowPicManager_StageShowThumbnailDownloadProgressCallback"
StageShowPicManager.StageShowThumbnailDownloadCompleteCallback = "StageShowPicManager_StageShowThumbnailDownloadCompleteCallback"
StageShowPicManager.StageShowThumbnailDownloadErrorCallback = "StageShowPicManager_StageShowThumbnailDownloadErrorCallback"
StageShowPicManager.StageShowOriginPhotoDownloadProgressCallback = "StageShowPicManager_StageShowOriginPhotoDownloadProgressCallback"
StageShowPicManager.StageShowOriginPhotoDownloadCompleteCallback = "StageShowPicManager_StageShowOriginPhotoDownloadCompleteCallback"
StageShowPicManager.StageShowOriginPhotoDownloadErrorCallback = "StageShowPicManager_StageShowOriginPhotoDownloadErrorCallback"
StageShowPicManager.StageShowOriginPhotoUploadProgressCallback = "StageShowPicManager_StageShowOriginPhotoUploadProgressCallback"
StageShowPicManager.StageShowOriginPhotoUploadCompleteCallback = "StageShowPicManager_StageShowOriginPhotoUploadCompleteCallback"
StageShowPicManager.StageShowOriginPhotoUploadErrorCallback = "StageShowPicManager_StageShowOriginPhotoUploadErrorCallback"
function StageShowPicManager:StageShowThumbnailDownloadProgressCallback1(index, time, progress)
  GameFacade.Instance:sendNotification(StageShowPicManager.StageShowThumbnailDownloadProgressCallback, {
    index = index,
    time = time,
    progress = progress
  })
end
function StageShowPicManager:StageShowThumbnailDownloadCompleteCallback1(index, time, bytes)
  GameFacade.Instance:sendNotification(StageShowPicManager.StageShowThumbnailDownloadCompleteCallback, {
    index = index,
    time = time,
    byte = bytes
  })
end
function StageShowPicManager:StageShowThumbnailDownloadErrorCallback1(index, time, errorMessage)
  GameFacade.Instance:sendNotification(StageShowPicManager.StageShowThumbnailDownloadErrorCallback, {index = index, time = time})
end
function StageShowPicManager:StageShowOriginPhotoDownloadProgressCallback1(index, time, progress)
  GameFacade.Instance:sendNotification(StageShowPicManager.StageShowOriginPhotoDownloadProgressCallback, {
    index = index,
    time = time,
    progress = progress
  })
end
function StageShowPicManager:StageShowOriginPhotoDownloadCompleteCallback1(index, time, bytes)
  GameFacade.Instance:sendNotification(StageShowPicManager.StageShowOriginPhotoDownloadCompleteCallback, {
    index = index,
    time = time,
    byte = bytes
  })
end
function StageShowPicManager:StageShowOriginPhotoDownloadErrorCallback1(index, time, errorMessage)
  GameFacade.Instance:sendNotification(StageShowPicManager.StageShowOriginPhotoDownloadErrorCallback, {index = index, time = time})
end
function StageShowPicManager:StageShowOriginPhotoUploadProgressCallback1(index, time, progress)
  GameFacade.Instance:sendNotification(StageShowPicManager.StageShowOriginPhotoUploadProgressCallback, {
    index = index,
    time = time,
    progress = progress
  })
end
function StageShowPicManager:StageShowOriginPhotoUploadCompleteCallback1(index, time)
  GameFacade.Instance:sendNotification(StageShowPicManager.StageShowOriginPhotoUploadCompleteCallback, {index = index, time = time})
end
function StageShowPicManager:StageShowOriginPhotoUploadErrorCallback1(index, time, errorMessage)
  GameFacade.Instance:sendNotification(StageShowPicManager.StageShowOriginPhotoUploadErrorCallback, {index = index, time = time})
end
