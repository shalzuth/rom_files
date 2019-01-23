autoImport('NetIngScenicSpotPhoto')
autoImport('LocalScenicSpotPhoto')
autoImport('ScenicSpotPhotoCallback')
autoImport('PhotoFileInfo')

ScenicSpotPhoto = class('ScenicSpotPhoto')

ScenicSpotPhoto.thumbnailCoefficient = 0.1

function ScenicSpotPhoto:Ins()
	if ScenicSpotPhoto.ins == nil then
		ScenicSpotPhoto.ins = ScenicSpotPhoto.new()
	end
	return ScenicSpotPhoto.ins
end

function ScenicSpotPhoto:Initialize()
	NetIngScenicSpotPhoto.Ins():Initialize()
	self.callback = ScenicSpotPhotoCallback.new()
	self.isGetingOForMakeT = {}
	self.isMakingTWhenGetThumbnail = {}
	self.willStopMakeThumbnailWhenGetThumbnail = {}
	self.isSaving = {}
	self.willStopMakeThumbnailWhenSaveUpload = {}
	self.isMakingTWhenSaveAndUpload = {}

	self.isGettingO = {} -- outside call
	self.isGettingT = {} -- outside call
end

-- progress_callback
-- function (progressValue)
-- end
-- success_callback
-- function (bytesOfOrigin, localTimestamp)
-- end
-- error_callback
-- function (errorMessage)
-- end
function ScenicSpotPhoto:GetOriginImage(scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_scenicspotphotocallback, extension)
	print(string.format('ScenicSpotPhoto:GetOriginImage\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	if not is_through_scenicspotphotocallback then
		if not is_keep_previous_callback then
			self.callback:ClearCallback(scenic_spot_id, true)
		end
		self.callback:RegisterCallback(scenic_spot_id, progress_callback, success_callback, error_callback, true)

		if self:IsGettingO(scenic_spot_id) then return end
		self.isGettingO[scenic_spot_id] = 0
	end

	local isLatestLocal = false
	local localTimestamp = LocalScenicSpotPhoto.Ins():GetTimestamp(scenic_spot_id, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalScenicSpotPhoto.Ins():Get(scenic_spot_id, localTimestamp, true)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalScenicSpotPhoto.Ins():Get(scenic_spot_id, localTimestamp, true)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingO[scenic_spot_id] = nil
		self.callback:FireSuccess(scenic_spot_id, bytes, localTimestamp, true)
		if is_through_scenicspotphotocallback then
			if success_callback ~= nil then
				success_callback(bytes, localTimestamp)
			end
		end
	else
		local isDownloading = NetIngScenicSpotPhoto.Ins():IsDownloading(scenic_spot_id, true)
		if not isDownloading then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhoto.Ins():GetTempDownloadPathOfLocal(scenic_spot_id, true, extension)
			NetIngScenicSpotPhoto.Ins():Download(
				scenic_spot_id,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(scenic_spot_id, progressValue, true)
					if is_through_scenicspotphotocallback then
						if progress_callback ~= nil then
							progress_callback(progressValue)
						end
					end
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalScenicSpotPhoto.Ins():Save(scenic_spot_id, bytes, timestamp, true, extension)

					self.isGettingO[scenic_spot_id] = nil
					self.callback:FireSuccess(scenic_spot_id, bytes, timestamp, true)
					if is_through_personalphotocallback then
						if success_callback ~= nil then
							success_callback(bytes, timestamp)
						end
					end
				end,
				function (x)
					-- delete error temp download file
					if FileHelper.ExistFile(downloadPath) then
						FileHelper.DeleteFile(downloadPath)
					end

					local errorMessage = x
					self.isGettingO[scenic_spot_id] = nil
					self.callback:FireError(scenic_spot_id, errorMessage, true)
					if is_through_scenicspotphotocallback then
						if error_callback ~= nil then
							error_callback(errorMessage)
						end
					end
				end,
				true,
				extension
			)
		end
	end
end
function ScenicSpotPhoto:IsGettingO(scenic_spot_id)
	return self.isGettingO[scenic_spot_id] ~= nil
end

function ScenicSpotPhoto:StopGetOriginImage(scenic_spot_id)
	NetIngScenicSpotPhoto.Ins():StopDownload(scenic_spot_id, true)
end

function ScenicSpotPhoto:GetThumbnail(scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, extension)
	print(string.format('ScenicSpotPhoto:GetThumbnail\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	if not is_keep_previous_callback then
		self.callback:ClearCallback(scenic_spot_id, false)
	end
	self.callback:RegisterCallback(scenic_spot_id, progress_callback, success_callback, error_callback, false)
	if self:IsGettingT(scenic_spot_id) then return end
	self.isGettingT[scenic_spot_id] = 0

	local isLatestLocal = false
	local localTimestamp = LocalScenicSpotPhoto.Ins():GetTimestamp(scenic_spot_id, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalScenicSpotPhoto.Ins():Get(scenic_spot_id, localTimestamp, false)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalScenicSpotPhoto.Ins():Get(scenic_spot_id, localTimestamp, false)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingT[scenic_spot_id] = nil
		self.callback:FireSuccess(scenic_spot_id, bytes, localTimestamp, false)
	else
		local isDownloading = NetIngScenicSpotPhoto.Ins():IsDownloading(scenic_spot_id, false)
		if not isDownloading and not self:IsGetingOForMakeT(scenic_spot_id) and not self:IsMakingTWhenGetThumbnail(scenic_spot_id) then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhoto.Ins():GetTempDownloadPathOfLocal(scenic_spot_id, false, extension)
			NetIngScenicSpotPhoto.Ins():Download(
				scenic_spot_id,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(scenic_spot_id, progressValue, false)
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalScenicSpotPhoto.Ins():Save(scenic_spot_id, bytes, timestamp, false, extension)

					self.isGettingT[scenic_spot_id] = nil
					self.callback:FireSuccess(scenic_spot_id, bytes, timestamp, false)
				end,
				function (x)
					-- delete error temp download file
					if FileHelper.ExistFile(downloadPath) then
						FileHelper.DeleteFile(downloadPath)
					end

					self.isGetingOForMakeT[scenic_spot_id] = 0
					-- If origin image exists on local, getting origin image will LRU.
					ScenicSpotPhotoHelper.Ins():GetOriginImage(
						scenic_spot_id,
						timestamp,
						nil,
						function (x, y)
							self.isGetingOForMakeT[scenic_spot_id] = nil

							local bytesOfOriginImage = x
							local timestampOfOriginImage = y
							local texture = Texture2D(0,0,TextureFormat.RGB24,false)
							ImageConversion.LoadImage(texture, bytesOfOriginImage)
							self.isMakingTWhenGetThumbnail[scenic_spot_id] = 0
							FunctionTextureScale.ins:Scale(texture, ScenicSpotPhoto.thumbnailCoefficient, function (x)
								Object.DestroyImmediate(texture)
								local scaledTexture = x
								if self.willStopMakeThumbnailWhenGetThumbnail[scenic_spot_id] ~= nil then
									Object.DestroyImmediate(scaledTexture)
									self.isMakingTWhenGetThumbnail[scenic_spot_id] = nil
									self.willStopMakeThumbnailWhenGetThumbnail[scenic_spot_id] = nil
								else
									local bytes = ImageConversion.EncodeToJPG(scaledTexture)
									Object.DestroyImmediate(scaledTexture)
									LocalScenicSpotPhoto.Ins():Save(scenic_spot_id, bytes, timestampOfOriginImage, false)
									self.isMakingTWhenGetThumbnail[scenic_spot_id] = nil

									self.isGettingT[scenic_spot_id] = nil
									self.callback:FireSuccess(scenic_spot_id, bytes, timestampOfOriginImage, false)
								end
							end)
						end,
						function (x)
							self.isGetingOForMakeT[scenic_spot_id] = nil

							local errorMessage = x
							self.isGettingT[scenic_spot_id] = nil
							self.callback:FireError(scenic_spot_id, errorMessage, false)
						end,
						true,
						true
					)
				end,
				false,
				extension
			)
		elseif self:IsMakingTWhenGetThumbnail(scenic_spot_id) then
			self.willStopMakeThumbnailWhenGetThumbnail[scenic_spot_id] = nil
		end
	end
end
function ScenicSpotPhoto:IsGettingT(scenic_spot_id)
	return self.isGettingT[scenic_spot_id] ~= nil
end
function ScenicSpotPhoto:IsGetingOForMakeT(scenic_spot_id)
	return self.isGetingOForMakeT[scenic_spot_id] ~= nil
end
function ScenicSpotPhoto:IsMakingTWhenGetThumbnail(scenic_spot_id)
	return self.isMakingTWhenGetThumbnail[scenic_spot_id] ~= nil
end

function ScenicSpotPhoto:StopGetThumbnail(scenic_spot_id)
	NetIngScenicSpotPhoto.Ins():StopDownload(scenic_spot_id, false)
	if self:IsGetingOForMakeT(scenic_spot_id) then
		ScenicSpotPhotoHelper.Ins():StopGetOriginImage(scenic_spot_id)
	elseif self:IsMakingTWhenGetThumbnail(scenic_spot_id) then
		self.willStopMakeThumbnailWhenGetThumbnail[scenic_spot_id] = 0
	end
end

-- return value
-- 1 bytes; 2 local timestamp
function ScenicSpotPhoto:TryGetThumbnailFromLocal(scenic_spot_id, timestamp, is_force_timestamp)
	print(string.format('ScenicSpotPhoto:TryGetThumbnailFromLocal\nscenic_spot_id=%s\ntimestamp=%s\nis_force_timestamp=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_force_timestamp)))
	local localTimestamp = LocalScenicSpotPhoto.Ins():GetTimestamp(scenic_spot_id, false)
	if is_force_timestamp and localTimestamp ~= timestamp then
		return nil
	end
	local retBytes, retTimestamp = LocalScenicSpotPhoto.Ins():Get(scenic_spot_id, timestamp, false)
	if retBytes == nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
		retBytes, retTimestamp = LocalScenicSpotPhoto.Ins():Get(scenic_spot_id, timestamp, false)
		PhotoFileInfo.Extension = tempExtension
	end
	return retBytes, retTimestamp
end

function ScenicSpotPhoto:SaveAndUpload(scenic_spot_id, bytes, timestamp, progress_callback, success_callback, error_callback)
	print(string.format('ScenicSpotPhoto:SaveAndUpload\nscenic_spot_id=%s\ntimestamp=%s', tostring(scenic_spot_id), tostring(timestamp)))
	if self:IsSaving(scenic_spot_id) then
		Debug.LogError('FAST HAND!')
	else
		self:StopSaveAndUpload(scenic_spot_id)
		ScenicSpotPhotoHelper.Ins():StopGetOriginImage(scenic_spot_id)
		ScenicSpotPhotoHelper.Ins():StopGetThumbnail(scenic_spot_id)
		self:ClearLocal(scenic_spot_id)

		local m = self.isSaving[scenic_spot_id]; m = m or 0; m = m + 1; self.isSaving[scenic_spot_id] = m
		LocalScenicSpotPhoto.Ins():SaveAsync(
			scenic_spot_id,
			bytes,
			timestamp,
			function ()
				local tempUploadRootPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhoto.Ins():GetTempUploadRootPathOfLocal()
				if not FileHelper.ExistDirectory(tempUploadRootPath) then
					FileHelper.CreateDirectory(tempUploadRootPath)
				end
				local tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhoto.Ins():GetTempUploadPathOfLocal(scenic_spot_id)
				FileDirectoryHandler.WriteFile(tempUploadPathOfLocal, bytes, function ()
					local n = self.isSaving[scenic_spot_id]; n = n - 1; self.isSaving[scenic_spot_id] = n
					if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
						NetIngScenicSpotPhoto.Ins():FormUpload(
							scenic_spot_id,
							progress_callback,
							function ()
								NetIngScenicSpotPhoto.Ins():SetExist(Game.Myself.data.id, scenic_spot_id)
								FileHelper.DeleteFile(tempUploadPathOfLocal)
								if success_callback ~= nil then
									success_callback()
								end
							end,
							error_callback
						)
					else
						NetIngScenicSpotPhoto.Ins():Upload(
							scenic_spot_id,
							progress_callback,
							function ()
								NetIngScenicSpotPhoto.Ins():SetExist(Game.Myself.data.id, scenic_spot_id)
								FileHelper.DeleteFile(tempUploadPathOfLocal)
								if success_callback ~= nil then
									success_callback()
								end
							end,
							error_callback
						)
					end
				end)
			end,
			true
		)

		local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
		ImageConversion.LoadImage(texture, bytes)
		self.isMakingTWhenSaveAndUpload[scenic_spot_id] = 0
		FunctionTextureScale.ins:Scale(texture, ScenicSpotPhoto.thumbnailCoefficient, function (x)
			Object.DestroyImmediate(texture)
			local scaledTexture = x
			if self.willStopMakeThumbnailWhenSaveUpload[scenic_spot_id] ~= nil then
				Object.DestroyImmediate(scaledTexture)
				self.isMakingTWhenSaveAndUpload[scenic_spot_id] = nil
				self.willStopMakeThumbnailWhenSaveUpload[scenic_spot_id] = nil
			else
				local bytesThumbnail = ImageConversion.EncodeToJPG(x)
				LocalScenicSpotPhoto.Ins():Save(scenic_spot_id, bytesThumbnail, timestamp, false)
				self.isMakingTWhenSaveAndUpload[scenic_spot_id] = nil
			end
		end)
	end
end
function ScenicSpotPhoto:IsSaving(scenic_spot_id)
	local m = self.isSaving[scenic_spot_id]
	return m ~= nil and m > 0
end
function ScenicSpotPhoto:IsMakingTWhenSaveAndUpload(scenic_spot_id)
	return self.isMakingTWhenSaveAndUpload[scenic_spot_id] ~= nil
end

function ScenicSpotPhoto:StopSaveAndUpload(scenic_spot_id)
	NetIngScenicSpotPhoto.Ins():StopUpload(scenic_spot_id)
	if self:IsMakingTWhenSaveAndUpload(scenic_spot_id) then
		self.willStopMakeThumbnailWhenSaveUpload[scenic_spot_id] = 0
	end
end

function ScenicSpotPhoto:Clear(scenic_spot_id)
	print(string.format('ScenicSpotPhoto:Clear\nscenic_spot_id=%s', tostring(scenic_spot_id)))
	self:StopSaveAndUpload(scenic_spot_id)
	ScenicSpotPhotoHelper.Ins():StopGetOriginImage(scenic_spot_id)
	ScenicSpotPhotoHelper.Ins():StopGetThumbnail(scenic_spot_id)
	self:ClearLocal(scenic_spot_id)
end

function ScenicSpotPhoto:ClearLocal(scenic_spot_id)
	local downloadOPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhoto.Ins():GetTempDownloadPathOfLocal(scenic_spot_id, true)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	downloadOPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhoto.Ins():GetTempDownloadPathOfLocal(scenic_spot_id, true, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	local downloadTPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhoto.Ins():GetTempDownloadPathOfLocal(scenic_spot_id, false)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	downloadTPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhoto.Ins():GetTempDownloadPathOfLocal(scenic_spot_id, false, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	local tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhoto.Ins():GetTempUploadPathOfLocal(scenic_spot_id)
	if FileHelper.ExistFile(tempUploadPathOfLocal) then
		FileHelper.DeleteFile(tempUploadPathOfLocal)
	end
	local tempExtension = PhotoFileInfo.Extension
	PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
	tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhoto.Ins():GetTempUploadPathOfLocal(scenic_spot_id)
	if FileHelper.ExistFile(tempUploadPathOfLocal) then
		FileHelper.DeleteFile(tempUploadPathOfLocal)
	end
	PhotoFileInfo.Extension = tempExtension
	LocalScenicSpotPhoto.Ins():Delete(scenic_spot_id, true)
	LocalScenicSpotPhoto.Ins():Delete(scenic_spot_id, false)
end

-- params
-- o_or_t, true : origin image; false : thumbnail
function ScenicSpotPhoto:GetLocalAbsolutePath(scenic_spot_id, o_or_t)
	local localPath = LocalScenicSpotPhoto.Ins():GetPathOfLocal(scenic_spot_id, o_or_t)
	return localPath
end