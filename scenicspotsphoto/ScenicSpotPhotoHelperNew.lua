autoImport("ScenicSpotPhotoNew")
autoImport("LocalScenicSpotPhotoNew")
autoImport("PhotoFileInfo")
autoImport("NetIngScenicSpotPhotoNew")
ScenicSpotPhotoHelperNew = class("ScenicSpotPhotoHelperNew")
function ScenicSpotPhotoHelperNew:Ins()
  if ScenicSpotPhotoHelperNew.ins == nil then
    ScenicSpotPhotoHelperNew.ins = ScenicSpotPhotoHelperNew.new()
  end
  return ScenicSpotPhotoHelperNew.ins
end
function ScenicSpotPhotoHelperNew:Initialize()
  self.tabIsCheckingExistO = {}
  self.tabIsCheckingExistT = {}
  self.tabCachedParamsO = {}
  self.tabCachedParamsT = {}
  self.tabStopFlagO = {}
  self.tabStopFlagT = {}
end
function ScenicSpotPhotoHelperNew:GetOriginImage_Share(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_scenicspotphotocallback)
  local roleID = role_id or ScenicSpotPhotoNew.unrealRoleID
  local photoID = ScenicSpotPhotoNew.Ins():GetPhotoID(roleID, scenic_spot_id)
  self.tabStopFlagO[photoID] = nil
  local isLatestLocal = false
  local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Share(scenic_spot_id, true)
  if localTimestamp ~= nil then
    isLatestLocal = timestamp <= localTimestamp
  else
    isLatestLocal = false
  end
  if isLatestLocal then
    ScenicSpotPhotoNew.Ins():GetOriginImage_Share(roleID, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_scenicspotphotocallback)
  elseif role_id == nil then
    ScenicSpotPhotoNew.Ins():GetOriginImage_Share_New(scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_scenicspotphotocallback)
  else
    if self.tabCachedParamsO[photoID] == nil then
      self.tabCachedParamsO[photoID] = {}
    end
    table.insert(self.tabCachedParamsO[photoID], {
      timestamp = timestamp,
      progressCallback = progress_callback,
      successCallback = success_callback,
      errorCallback = error_callback,
      isKeepPreviousCallback = is_keep_previous_callback,
      isThroughScenicspotphotocallback = is_through_scenicspotphotocallback
    })
    if self.tabIsCheckingExistO[photoID] == nil then
      NetIngScenicSpotPhotoNew.Ins():CheckExist(roleID, scenic_spot_id, function()
        self.tabIsCheckingExistO[photoID] = nil
        if self.tabStopFlagO[photoID] == nil then
          local params = self.tabCachedParamsO[photoID]
          for i = 1, #params do
            local param = params[i]
            ScenicSpotPhotoNew.Ins():GetOriginImage_Share(roleID, scenic_spot_id, param.timestamp, param.progressCallback, param.successCallback, param.errorCallback, param.isKeepPreviousCallback, param.isThroughScenicspotphotocallback, PhotoFileInfo.Extension)
          end
        end
        self.tabCachedParamsO[photoID] = nil
      end, function()
        self.tabIsCheckingExistO[photoID] = nil
        if self.tabStopFlagO[photoID] == nil then
          local params = self.tabCachedParamsO[photoID]
          for i = 1, #params do
            local param = params[i]
            ScenicSpotPhotoNew.Ins():GetOriginImage_Share(roleID, scenic_spot_id, param.timestamp, param.progressCallback, param.successCallback, param.errorCallback, param.isKeepPreviousCallback, param.isThroughScenicspotphotocallback, PhotoFileInfo.OldExtension)
          end
        end
        self.tabCachedParamsO[photoID] = nil
      end, PhotoFileInfo.Extension)
      self.tabIsCheckingExistO[photoID] = 0
    end
  end
end
function ScenicSpotPhotoHelperNew:GetOriginImage_Roles(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_scenicspotphotocallback)
  local photoID = ScenicSpotPhotoNew.Ins():GetPhotoID(role_id, scenic_spot_id)
  self.tabStopFlagO[photoID] = nil
  local isLatestLocal = false
  local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Roles(photoID, true)
  if localTimestamp ~= nil then
    isLatestLocal = timestamp <= localTimestamp
  else
    isLatestLocal = false
  end
  if isLatestLocal then
    ScenicSpotPhotoNew.Ins():GetOriginImage_Roles(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_scenicspotphotocallback)
  else
    if self.tabCachedParamsO[photoID] == nil then
      self.tabCachedParamsO[photoID] = {}
    end
    table.insert(self.tabCachedParamsO[photoID], {
      timestamp = timestamp,
      progressCallback = progress_callback,
      successCallback = success_callback,
      errorCallback = error_callback,
      isKeepPreviousCallback = is_keep_previous_callback,
      isThroughScenicspotphotocallback = is_through_scenicspotphotocallback
    })
    if self.tabIsCheckingExistO[photoID] == nil then
      NetIngScenicSpotPhotoNew.Ins():CheckExist(role_id, scenic_spot_id, function()
        self.tabIsCheckingExistO[photoID] = nil
        if self.tabStopFlagO[photoID] == nil then
          local params = self.tabCachedParamsO[photoID]
          for i = 1, #params do
            local param = params[i]
            ScenicSpotPhotoNew.Ins():GetOriginImage_Roles(role_id, scenic_spot_id, param.timestamp, param.progressCallback, param.successCallback, param.errorCallback, param.isKeepPreviousCallback, param.isThroughScenicspotphotocallback, PhotoFileInfo.Extension)
          end
        end
        self.tabCachedParamsO[photoID] = nil
      end, function()
        self.tabIsCheckingExistO[photoID] = nil
        if self.tabStopFlagO[photoID] == nil then
          local params = self.tabCachedParamsO[photoID]
          for i = 1, #params do
            local param = params[i]
            ScenicSpotPhotoNew.Ins():GetOriginImage_Roles(role_id, scenic_spot_id, param.timestamp, param.progressCallback, param.successCallback, param.errorCallback, param.isKeepPreviousCallback, param.isThroughScenicspotphotocallback, PhotoFileInfo.OldExtension)
          end
        end
        self.tabCachedParamsO[photoID] = nil
      end, PhotoFileInfo.Extension)
      self.tabIsCheckingExistO[photoID] = 0
    end
  end
end
function ScenicSpotPhotoHelperNew:StopGetOriginImage(role_id, scenic_spot_id)
  local photoID = ScenicSpotPhotoNew.Ins():GetPhotoID(role_id, scenic_spot_id)
  if self.tabIsCheckingExistO[photoID] ~= nil then
    self.tabStopFlagO[photoID] = 0
  end
  ScenicSpotPhotoNew.Ins():StopGetOriginImage(role_id, scenic_spot_id)
end
function ScenicSpotPhotoHelperNew:GetThumbnail_Share(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
  local roleID = role_id or ScenicSpotPhotoNew.unrealRoleID
  local photoID = ScenicSpotPhotoNew.Ins():GetPhotoID(roleID, scenic_spot_id)
  self.tabStopFlagT[photoID] = nil
  local isLatestLocal = false
  local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Share(scenic_spot_id, false)
  if localTimestamp ~= nil then
    isLatestLocal = timestamp <= localTimestamp
  else
    isLatestLocal = false
  end
  if isLatestLocal then
    ScenicSpotPhotoNew.Ins():GetThumbnail_Share(roleID, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
  elseif role_id == nil then
    ScenicSpotPhotoNew.Ins():GetThumbnail_Share_New(scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
  else
    if self.tabCachedParamsT[photoID] == nil then
      self.tabCachedParamsT[photoID] = {}
    end
    table.insert(self.tabCachedParamsT[photoID], {
      timestamp = timestamp,
      progressCallback = progress_callback,
      successCallback = success_callback,
      errorCallback = error_callback,
      isKeepPreviousCallback = is_keep_previous_callback
    })
    if self.tabIsCheckingExistT[photoID] == nil then
      NetIngScenicSpotPhotoNew.Ins():CheckExist(role_id, scenic_spot_id, function()
        self.tabIsCheckingExistT[photoID] = nil
        if self.tabStopFlagT[photoID] == nil then
          local params = self.tabCachedParamsT[photoID]
          for i = 1, #params do
            local param = params[i]
            ScenicSpotPhotoNew.Ins():GetThumbnail_Share(role_id, scenic_spot_id, param.timestamp, param.progressCallback, param.successCallback, param.errorCallback, param.isKeepPreviousCallback, PhotoFileInfo.Extension)
          end
        end
        self.tabCachedParamsT[photoID] = nil
      end, function()
        self.tabIsCheckingExistT[photoID] = nil
        if self.tabStopFlagT[photoID] == nil then
          local params = self.tabCachedParamsT[photoID]
          for i = 1, #params do
            local param = params[i]
            ScenicSpotPhotoNew.Ins():GetThumbnail_Share(role_id, scenic_spot_id, param.timestamp, param.progressCallback, param.successCallback, param.errorCallback, param.isKeepPreviousCallback, PhotoFileInfo.OldExtension)
          end
        end
        self.tabCachedParamsT[photoID] = nil
      end, PhotoFileInfo.Extension)
      self.tabIsCheckingExistT[photoID] = 0
    end
  end
end
function ScenicSpotPhotoHelperNew:GetThumbnail_Roles(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
  local photoID = ScenicSpotPhotoNew.Ins():GetPhotoID(role_id, scenic_spot_id)
  self.tabStopFlagT[photoID] = nil
  local isLatestLocal = false
  local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Roles(photoID, false)
  if localTimestamp ~= nil then
    isLatestLocal = timestamp <= localTimestamp
  else
    isLatestLocal = false
  end
  if isLatestLocal then
    ScenicSpotPhotoNew.Ins():GetThumbnail_Roles(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
  else
    if self.tabCachedParamsT[photoID] == nil then
      self.tabCachedParamsT[photoID] = {}
    end
    table.insert(self.tabCachedParamsT[photoID], {
      timestamp = timestamp,
      progressCallback = progress_callback,
      successCallback = success_callback,
      errorCallback = error_callback,
      isKeepPreviousCallback = is_keep_previous_callback
    })
    if self.tabIsCheckingExistT[photoID] == nil then
      NetIngScenicSpotPhotoNew.Ins():CheckExist(role_id, scenic_spot_id, function()
        self.tabIsCheckingExistT[photoID] = nil
        if self.tabStopFlagT[photoID] == nil then
          local params = self.tabCachedParamsT[photoID]
          for i = 1, #params do
            local param = params[i]
            ScenicSpotPhotoNew.Ins():GetThumbnail_Roles(role_id, scenic_spot_id, param.timestamp, param.progressCallback, param.successCallback, param.errorCallback, param.isKeepPreviousCallback, PhotoFileInfo.Extension)
          end
        end
        self.tabCachedParamsT[photoID] = nil
      end, function()
        self.tabIsCheckingExistT[photoID] = nil
        if self.tabStopFlagT[photoID] == nil then
          local params = self.tabCachedParamsT[photoID]
          for i = 1, #params do
            local param = params[i]
            ScenicSpotPhotoNew.Ins():GetThumbnail_Roles(role_id, scenic_spot_id, param.timestamp, param.progressCallback, param.successCallback, param.errorCallback, param.isKeepPreviousCallback, PhotoFileInfo.OldExtension)
          end
        end
        self.tabCachedParamsT[photoID] = nil
      end, PhotoFileInfo.Extension)
      self.tabIsCheckingExistT[photoID] = 0
    end
  end
end
function ScenicSpotPhotoHelperNew:StopGetThumbnail(role_id, scenic_spot_id)
  local photoID = ScenicSpotPhotoNew.Ins():GetPhotoID(role_id, scenic_spot_id)
  if self.tabIsCheckingExistT[photoID] ~= nil then
    self.tabStopFlagT[photoID] = 0
  end
  ScenicSpotPhotoNew.Ins():StopGetThumbnail(role_id, scenic_spot_id)
end
