autoImport('ScenicSpotPhoto')
autoImport('NetIngScenicSpotPhoto')
autoImport('LocalScenicSpotPhotoNew')
autoImport('ScenicSpotPhotoCallback')
autoImport('PhotoFileInfo')

ScenicSpotPhotoNew = class('ScenicSpotPhotoNew')

function ScenicSpotPhotoNew:Ins()
	if ScenicSpotPhotoNew.ins == nil then
		ScenicSpotPhotoNew.ins = ScenicSpotPhotoNew.new()
	end
	return ScenicSpotPhotoNew.ins
end

function ScenicSpotPhotoNew:Initialize()
	NetIngScenicSpotPhotoNew.Ins():Initialize()
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
function ScenicSpotPhotoNew:GetOriginImage_Share(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_scenicspotphotocallback, extension)
	print(string.format('ScenicSpotPhotoNew:GetOriginImage_Share\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	local photoID = self:GetPhotoID(role_id, scenic_spot_id)
	if not is_through_scenicspotphotocallback then
		if not is_keep_previous_callback then
			self.callback:ClearCallback(photoID, true)
		end
		self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, true)

		if self:IsGettingO(photoID) then return end
		self.isGettingO[photoID] = 0
	end

	local isLatestLocal = false
	local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Share(scenic_spot_id, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalScenicSpotPhotoNew.Ins():Get_Share(scenic_spot_id, localTimestamp, true)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalScenicSpotPhotoNew.Ins():Get_Share(scenic_spot_id, localTimestamp, true)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingO[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, true)
		if is_through_scenicspotphotocallback then
			if success_callback ~= nil then
				success_callback(bytes, localTimestamp)
			end
		end
	else
		local isDownloading = NetIngScenicSpotPhotoNew.Ins():IsDownloading(photoID, true)
		if not isDownloading then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, true, extension)
			NetIngScenicSpotPhotoNew.Ins():Download(
				role_id,
				scenic_spot_id,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(photoID, progressValue, true)
					if is_through_scenicspotphotocallback then
						if progress_callback ~= nil then
							progress_callback(progressValue)
						end
					end
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalScenicSpotPhotoNew.Ins():Save_Share(scenic_spot_id, bytes, timestamp, true, extension)

					self.isGettingO[photoID] = nil
					self.callback:FireSuccess(photoID, bytes, timestamp, true)
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
					self.isGettingO[photoID] = nil
					self.callback:FireError(photoID, errorMessage, true)
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
ScenicSpotPhotoNew.unrealRoleID = 999999
function ScenicSpotPhotoNew:GetOriginImage_Share_New(scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_scenicspotphotocallback)
	print(string.format('ScenicSpotPhotoNew:GetOriginImage_Share_New\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback)))
	local unrealRoleID = ScenicSpotPhotoNew.unrealRoleID
	local photoID = self:GetPhotoID(unrealRoleID, scenic_spot_id)
	if not is_through_scenicspotphotocallback then
		if not is_keep_previous_callback then
			self.callback:ClearCallback(photoID, true)
		end
		self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, true)

		if self:IsGettingO(photoID) then return end
		self.isGettingO[photoID] = 0
	end

	local isLatestLocal = false
	local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Share(scenic_spot_id, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalScenicSpotPhotoNew.Ins():Get_Share(scenic_spot_id, localTimestamp, true)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalScenicSpotPhotoNew.Ins():Get_Share(scenic_spot_id, localTimestamp, true)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingO[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, true)
		if is_through_scenicspotphotocallback then
			if success_callback ~= nil then
				success_callback(bytes, localTimestamp)
			end
		end
	else
		local isDownloading = NetIngScenicSpotPhotoNew.Ins():IsDownloading(photoID, true)
		if not isDownloading then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, true, extension)
			NetIngScenicSpotPhotoNew.Ins():DownloadNew(
				scenic_spot_id,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(photoID, progressValue, true)
					if is_through_scenicspotphotocallback then
						if progress_callback ~= nil then
							progress_callback(progressValue)
						end
					end
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalScenicSpotPhotoNew.Ins():Save_Share(scenic_spot_id, bytes, timestamp, true)

					self.isGettingO[photoID] = nil
					self.callback:FireSuccess(photoID, bytes, timestamp, true)
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
					self.isGettingO[photoID] = nil
					self.callback:FireError(photoID, errorMessage, true)
					if is_through_scenicspotphotocallback then
						if error_callback ~= nil then
							error_callback(errorMessage)
						end
					end
				end,
				true
			)
		end
	end
end
function ScenicSpotPhotoNew:GetOriginImage_Roles(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_scenicspotphotocallback, extension)
	print(string.format('ScenicSpotPhotoNew:GetOriginImage_Roles\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	local photoID = self:GetPhotoID(role_id, scenic_spot_id)
	if not is_through_scenicspotphotocallback then
		if not is_keep_previous_callback then
			self.callback:ClearCallback(photoID, true)
		end
		self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, true)

		if self:IsGettingO(photoID) then return end
		self.isGettingO[photoID] = 0
	end

	local isLatestLocal = false
	local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Roles(photoID, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalScenicSpotPhotoNew.Ins():Get_Roles(photoID, localTimestamp, true)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalScenicSpotPhotoNew.Ins():Get_Roles(photoID, localTimestamp, true)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingO[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, true)
		if is_through_scenicspotphotocallback then
			if success_callback ~= nil then
				success_callback(bytes, localTimestamp)
			end
		end
	else
		local isDownloading = NetIngScenicSpotPhotoNew.Ins():IsDownloading(photoID, true)
		if not isDownloading then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, true, extension)
			NetIngScenicSpotPhotoNew.Ins():Download(
				role_id,
				scenic_spot_id,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(photoID, progressValue, true)
					if is_through_scenicspotphotocallback then
						if progress_callback ~= nil then
							progress_callback(progressValue)
						end
					end
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalScenicSpotPhotoNew.Ins():Save_Roles(role_id, scenic_spot_id, photoID, bytes, timestamp, true, extension)

					self.isGettingO[photoID] = nil
					self.callback:FireSuccess(photoID, bytes, timestamp, true)
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
					self.isGettingO[photoID] = nil
					self.callback:FireError(photoID, errorMessage, true)
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
function ScenicSpotPhotoNew:IsGettingO(photo_id)
	return self.isGettingO[photo_id] ~= nil
end

function ScenicSpotPhotoNew:StopGetOriginImage(role_id, scenic_spot_id)
	local photoID = self:GetPhotoID(role_id, scenic_spot_id)
	NetIngScenicSpotPhotoNew.Ins():StopDownload(photoID, true)
end

function ScenicSpotPhotoNew:GetThumbnail_Share(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, extension)
	print(string.format('ScenicSpotPhotoNew:GetThumbnail_Share\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	local photoID = self:GetPhotoID(role_id, scenic_spot_id)
	if not is_keep_previous_callback then
		self.callback:ClearCallback(photoID, false)
	end
	self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, false)
	if self:IsGettingT(photoID) then return end
	self.isGettingT[photoID] = 0

	local isLatestLocal = false
	local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Share(scenic_spot_id, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalScenicSpotPhotoNew.Ins():Get_Share(scenic_spot_id, localTimestamp, false)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalScenicSpotPhotoNew.Ins():Get_Share(scenic_spot_id, localTimestamp, false)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingT[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, false)
	else
		local isDownloading = NetIngScenicSpotPhotoNew.Ins():IsDownloading(photoID, false)
		if not isDownloading and not self:IsGetingOForMakeT(photoID) and not self:IsMakingTWhenGetThumbnail(photoID) then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, false, extension)
			NetIngScenicSpotPhotoNew.Ins():Download(
				role_id,
				scenic_spot_id,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(photoID, progressValue, false)
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalScenicSpotPhotoNew.Ins():Save_Share(scenic_spot_id, bytes, timestamp, false, extension)

					self.isGettingT[photoID] = nil
					self.callback:FireSuccess(photoID, bytes, timestamp, false)
				end,
				function (x)
					-- delete error temp download file
					if FileHelper.ExistFile(downloadPath) then
						FileHelper.DeleteFile(downloadPath)
					end

					self.isGetingOForMakeT[photoID] = 0
					-- If origin image exists on local, getting origin image will LRU.
					ScenicSpotPhotoHelperNew.Ins():GetOriginImage_Share(
						role_id,
						scenic_spot_id,
						timestamp,
						nil,
						function (x, y)
							self.isGetingOForMakeT[photoID] = nil

							local bytesOfOriginImage = x
							local timestampOfOriginImage = y
							local texture = Texture2D(0,0,TextureFormat.RGB24,false)
							ImageConversion.LoadImage(texture, bytesOfOriginImage)
							self.isMakingTWhenGetThumbnail[photoID] = 0
							FunctionTextureScale.ins:Scale(texture, ScenicSpotPhoto.thumbnailCoefficient, function (x)
								Object.DestroyImmediate(texture)
								local scaledTexture = x
								if self.willStopMakeThumbnailWhenGetThumbnail[photoID] ~= nil then
									Object.DestroyImmediate(scaledTexture)
									self.isMakingTWhenGetThumbnail[photoID] = nil
									self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
								else
									local bytes = ImageConversion.EncodeToJPG(scaledTexture)
									Object.DestroyImmediate(scaledTexture)
									LocalScenicSpotPhotoNew.Ins():Save_Share(scenic_spot_id, bytes, timestampOfOriginImage, false)
									self.isMakingTWhenGetThumbnail[photoID] = nil

									self.isGettingT[photoID] = nil
									self.callback:FireSuccess(photoID, bytes, timestampOfOriginImage, false)
								end
							end)
						end,
						function (x)
							self.isGetingOForMakeT[photoID] = nil

							local errorMessage = x
							self.isGettingT[photoID] = nil
							self.callback:FireError(photoID, errorMessage, false)
						end,
						true,
						true
					)
				end,
				false,
				extension
			)
		elseif self:IsMakingTWhenGetThumbnail(photoID) then
			self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
		end
	end
end
function ScenicSpotPhotoNew:GetThumbnail_Share_New(scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
	print(string.format('ScenicSpotPhotoNew:GetThumbnail_Share_New\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	local unrealRoleID = ScenicSpotPhotoNew.unrealRoleID
	local photoID = self:GetPhotoID(unrealRoleID, scenic_spot_id)
	if not is_keep_previous_callback then
		self.callback:ClearCallback(photoID, false)
	end
	self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, false)
	if self:IsGettingT(photoID) then return end
	self.isGettingT[photoID] = 0

	local isLatestLocal = false
	local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Share(scenic_spot_id, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalScenicSpotPhotoNew.Ins():Get_Share(scenic_spot_id, localTimestamp, false)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalScenicSpotPhotoNew.Ins():Get_Share(scenic_spot_id, localTimestamp, false)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingT[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, false)
	else
		local isDownloading = NetIngScenicSpotPhotoNew.Ins():IsDownloading(photoID, false)
		if not isDownloading and not self:IsGetingOForMakeT(photoID) and not self:IsMakingTWhenGetThumbnail(photoID) then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, false)
			NetIngScenicSpotPhotoNew.Ins():DownloadNew(
				scenic_spot_id,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(photoID, progressValue, false)
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalScenicSpotPhotoNew.Ins():Save_Share(scenic_spot_id, bytes, timestamp, false)

					self.isGettingT[photoID] = nil
					self.callback:FireSuccess(photoID, bytes, timestamp, false)
				end,
				function (x)
					-- delete error temp download file
					if FileHelper.ExistFile(downloadPath) then
						FileHelper.DeleteFile(downloadPath)
					end

					self.isGetingOForMakeT[photoID] = 0
					-- If origin image exists on local, getting origin image will LRU.
					self:GetOriginImage_Share_New(
						scenic_spot_id,
						timestamp,
						nil,
						function (x, y)
							self.isGetingOForMakeT[photoID] = nil

							local bytesOfOriginImage = x
							local timestampOfOriginImage = y
							local texture = Texture2D(0,0,TextureFormat.RGB24,false)
							ImageConversion.LoadImage(texture, bytesOfOriginImage)
							self.isMakingTWhenGetThumbnail[photoID] = 0
							FunctionTextureScale.ins:Scale(texture, ScenicSpotPhoto.thumbnailCoefficient, function (x)
								Object.DestroyImmediate(texture)
								local scaledTexture = x
								if self.willStopMakeThumbnailWhenGetThumbnail[photoID] ~= nil then
									Object.DestroyImmediate(scaledTexture)
									self.isMakingTWhenGetThumbnail[photoID] = nil
									self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
								else
									local bytes = ImageConversion.EncodeToJPG(scaledTexture)
									Object.DestroyImmediate(scaledTexture)
									LocalScenicSpotPhotoNew.Ins():Save_Share(scenic_spot_id, bytes, timestampOfOriginImage, false)
									self.isMakingTWhenGetThumbnail[photoID] = nil

									self.isGettingT[photoID] = nil
									self.callback:FireSuccess(photoID, bytes, timestampOfOriginImage, false)
								end
							end)
						end,
						function (x)
							self.isGetingOForMakeT[photoID] = nil

							local errorMessage = x
							self.isGettingT[photoID] = nil
							self.callback:FireError(photoID, errorMessage, false)
						end,
						true,
						true
					)
				end,
				false
			)
		elseif self:IsMakingTWhenGetThumbnail(photoID) then
			self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
		end
	end
end
function ScenicSpotPhotoNew:GetThumbnail_Roles(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, extension)
	print(string.format('ScenicSpotPhotoNew:GetThumbnail_Roles\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	local photoID = self:GetPhotoID(role_id, scenic_spot_id)
	if not is_keep_previous_callback then
		self.callback:ClearCallback(photoID, false)
	end
	self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, false)
	if self:IsGettingT(photoID) then return end
	self.isGettingT[photoID] = 0

	local isLatestLocal = false
	local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Roles(photoID, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalScenicSpotPhotoNew.Ins():Get_Roles(photoID, localTimestamp, false)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalScenicSpotPhotoNew.Ins():Get_Roles(photoID, localTimestamp, false)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingT[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, false)
	else
		local isDownloading = NetIngScenicSpotPhotoNew.Ins():IsDownloading(photoID, false)
		if not isDownloading and not self:IsGetingOForMakeT(photoID) and not self:IsMakingTWhenGetThumbnail(photoID) then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, false, extension)
			NetIngScenicSpotPhotoNew.Ins():Download(
				role_id,
				scenic_spot_id,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(photoID, progressValue, false)
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalScenicSpotPhotoNew.Ins():Save_Roles(role_id, scenic_spot_id, photoID, bytes, timestamp, false, extension)

					self.isGettingT[photoID] = nil
					self.callback:FireSuccess(photoID, bytes, timestamp, false)
				end,
				function (x)
					-- delete error temp download file
					if FileHelper.ExistFile(downloadPath) then
						FileHelper.DeleteFile(downloadPath)
					end

					self.isGetingOForMakeT[photoID] = 0
					-- If origin image exists on local, getting origin image will LRU.
					ScenicSpotPhotoHelperNew.Ins():GetOriginImage_Roles(
						role_id,
						scenic_spot_id,
						timestamp,
						nil,
						function (x, y)
							self.isGetingOForMakeT[photoID] = nil

							local bytesOfOriginImage = x
							local timestampOfOriginImage = y
							local texture = Texture2D(0,0,TextureFormat.RGB24,false)
							ImageConversion.LoadImage(texture, bytesOfOriginImage)
							self.isMakingTWhenGetThumbnail[photoID] = 0
							FunctionTextureScale.ins:Scale(texture, ScenicSpotPhoto.thumbnailCoefficient, function (x)
								Object.DestroyImmediate(texture)
								local scaledTexture = x
								if self.willStopMakeThumbnailWhenGetThumbnail[photoID] ~= nil then
									Object.DestroyImmediate(scaledTexture)
									self.isMakingTWhenGetThumbnail[photoID] = nil
									self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
								else
									local bytes = ImageConversion.EncodeToJPG(scaledTexture)
									Object.DestroyImmediate(scaledTexture)
									LocalScenicSpotPhotoNew.Ins():Save_Roles(role_id, scenic_spot_id, photoID, bytes, timestampOfOriginImage, false)
									self.isMakingTWhenGetThumbnail[photoID] = nil

									self.isGettingT[photoID] = nil
									self.callback:FireSuccess(photoID, bytes, timestampOfOriginImage, false)
								end
							end)
						end,
						function (x)
							self.isGetingOForMakeT[photoID] = nil

							local errorMessage = x
							self.isGettingT[photoID] = nil
							self.callback:FireError(photoID, errorMessage, false)
						end,
						true,
						true
					)
				end,
				false,
				extension
			)
		elseif self:IsMakingTWhenGetThumbnail(photoID) then
			self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
		end
	end
end
function ScenicSpotPhotoNew:IsGettingT(photo_id)
	return self.isGettingT[photo_id] ~= nil
end
function ScenicSpotPhotoNew:IsGetingOForMakeT(photo_id)
	return self.isGetingOForMakeT[photo_id] ~= nil
end
function ScenicSpotPhotoNew:IsMakingTWhenGetThumbnail(photo_id)
	return self.isMakingTWhenGetThumbnail[photo_id] ~= nil
end

function ScenicSpotPhotoNew:StopGetThumbnail(role_id, scenic_spot_id)
	local photoID = self:GetPhotoID(role_id, scenic_spot_id)
	NetIngScenicSpotPhotoNew.Ins():StopDownload(photoID, false)
	if self:IsGetingOForMakeT(photoID) then
		ScenicSpotPhotoHelperNew.Ins():StopGetOriginImage(role_id, scenic_spot_id)
	elseif self:IsMakingTWhenGetThumbnail(photoID) then
		self.willStopMakeThumbnailWhenGetThumbnail[photoID] = 0
	end
end

-- return value
-- 1 bytes; 2 local timestamp
function ScenicSpotPhotoNew:TryGetThumbnailFromLocal_Share(scenic_spot_id, timestamp, is_force_timestamp)
	print(string.format('ScenicSpotPhotoNew:TryGetThumbnailFromLocal_Share\nscenic_spot_id=%s\ntimestamp=%s\nis_force_timestamp=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_force_timestamp)))
	local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Share(scenic_spot_id, false)
	if is_force_timestamp and localTimestamp ~= timestamp then
		return nil
	end
	local retBytes, retTimestamp = LocalScenicSpotPhotoNew.Ins():Get_Share(scenic_spot_id, timestamp, false)
	if retBytes == nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
		retBytes, retTimestamp = LocalScenicSpotPhotoNew.Ins():Get_Share(scenic_spot_id, timestamp, false)
		PhotoFileInfo.Extension = tempExtension
	end
	return retBytes, retTimestamp
end

-- return value
-- 1 bytes; 2 local timestamp
function ScenicSpotPhotoNew:TryGetThumbnailFromLocal_Roles(role_id, scenic_spot_id, timestamp, is_force_timestamp)
	print(string.format('ScenicSpotPhotoNew:TryGetThumbnailFromLocal_Roles\nscenic_spot_id=%s\ntimestamp=%s\nis_force_timestamp=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_force_timestamp)))
	local photoID = self:GetPhotoID(role_id, scenic_spot_id)
	local localTimestamp = LocalScenicSpotPhotoNew.Ins():GetTimestamp_Roles(photoID, false)
	if is_force_timestamp and localTimestamp ~= timestamp then
		return nil
	end
	local retBytes, retTimestamp = LocalScenicSpotPhotoNew.Ins():Get_Roles(photoID, timestamp, false)
	if retBytes == nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
		retBytes, retTimestamp = LocalScenicSpotPhotoNew.Ins():Get_Roles(photoID, timestamp, false)
		PhotoFileInfo.Extension = tempExtension
	end
	return retBytes, retTimestamp
end

-- role_id means selected role for every scenic spot, if no one, use unreal
function ScenicSpotPhotoNew:SaveAndUpload(role_id, scenic_spot_id, bytes, timestamp, progress_callback, success_callback, error_callback)
	print(string.format('ScenicSpotPhotoNew:SaveAndUpload\nscenic_spot_id=%s\ntimestamp=%s', tostring(scenic_spot_id), tostring(timestamp)))

	local md5IsCorrect = false
	local correctMD5 = GamePhoto.GetPhotoFileMD5_Scenery(scenic_spot_id)
	if correctMD5 ~= nil then
		local currentMD5 = MyMD5.HashBytes(bytes)
		md5IsCorrect = currentMD5 == correctMD5
	end
	if not md5IsCorrect then
		MsgManager.ShowMsgByID(1)
		return
	end
	
	if self:IsSaving(scenic_spot_id) then
		Debug.LogError('FAST HAND!')
	else
		self:StopSaveAndUpload(scenic_spot_id)
		local roleID = role_id or ScenicSpotPhotoNew.unrealRoleID
		ScenicSpotPhotoHelperNew.Ins():StopGetOriginImage(roleID, scenic_spot_id)
		ScenicSpotPhotoHelperNew.Ins():StopGetThumbnail(roleID, scenic_spot_id)
		self:ClearLocal_Share(role_id, scenic_spot_id)

		local m = self.isSaving[scenic_spot_id]; m = m or 0; m = m + 1; self.isSaving[scenic_spot_id] = m
		LocalScenicSpotPhotoNew.Ins():SaveAsync_Share(
			scenic_spot_id,
			bytes,
			timestamp,
			function ()
				local tempUploadRootPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempUploadRootPathOfLocal()
				if not FileHelper.ExistDirectory(tempUploadRootPath) then
					FileHelper.CreateDirectory(tempUploadRootPath)
				end
				local tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempUploadPathOfLocal(scenic_spot_id)
				FileDirectoryHandler.WriteFile(tempUploadPathOfLocal, bytes, function ()
					local n = self.isSaving[scenic_spot_id]; n = n - 1; self.isSaving[scenic_spot_id] = n
					if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
						NetIngScenicSpotPhotoNew.Ins():FormUpload(
							scenic_spot_id,
							progress_callback,
							function ()
								FileHelper.DeleteFile(tempUploadPathOfLocal)
								if success_callback ~= nil then
									success_callback()
								end
							end,
							error_callback
						)
					else
						NetIngScenicSpotPhotoNew.Ins():Upload(
							scenic_spot_id,
							progress_callback,
							function ()
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
				LocalScenicSpotPhotoNew.Ins():Save_Share(scenic_spot_id, bytesThumbnail, timestamp, false)
				self.isMakingTWhenSaveAndUpload[scenic_spot_id] = nil
			end
		end)
	end
end
function ScenicSpotPhotoNew:IsSaving(scenic_spot_id)
	local m = self.isSaving[scenic_spot_id]
	return m ~= nil and m > 0
end
function ScenicSpotPhotoNew:IsMakingTWhenSaveAndUpload(scenic_spot_id)
	return self.isMakingTWhenSaveAndUpload[scenic_spot_id] ~= nil
end

function ScenicSpotPhotoNew:StopSaveAndUpload(scenic_spot_id)
	NetIngScenicSpotPhotoNew.Ins():StopUpload(scenic_spot_id)
	if self:IsMakingTWhenSaveAndUpload(scenic_spot_id) then
		self.willStopMakeThumbnailWhenSaveUpload[scenic_spot_id] = 0
	end
end

-- role_id means selected role for every scenic spot, if no one, use unreal
function ScenicSpotPhotoNew:Clear_Share(role_id, scenic_spot_id)
	print(string.format('ScenicSpotPhotoNew:Clear_Share\nscenic_spot_id=%s', tostring(scenic_spot_id)))
	self:StopSaveAndUpload(scenic_spot_id)
	local roleID = role_id or ScenicSpotPhotoNew.unrealRoleID
	ScenicSpotPhotoHelperNew.Ins():StopGetOriginImage(roleID, scenic_spot_id)
	ScenicSpotPhotoHelperNew.Ins():StopGetThumbnail(roleID, scenic_spot_id)
	self:ClearLocal_Share(role_id, scenic_spot_id)
end

function ScenicSpotPhotoNew:Clear_Roles(role_id, scenic_spot_id)
	ScenicSpotPhotoHelperNew.Ins():StopGetOriginImage(role_id, scenic_spot_id)
	ScenicSpotPhotoHelperNew.Ins():StopGetThumbnail(role_id, scenic_spot_id)
	self:ClearLocal_Roles(role_id, scenic_spot_id)
end

function ScenicSpotPhotoNew:ClearLocal_Share(role_id, scenic_spot_id)
	local roleID = role_id or ScenicSpotPhotoNew.unrealRoleID
	local photoID = self:GetPhotoID(roleID, scenic_spot_id)
	local downloadOPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, true)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	downloadOPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, true, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	local downloadTPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, false)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	downloadTPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, false, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	local tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempUploadPathOfLocal(scenic_spot_id)
	if FileHelper.ExistFile(tempUploadPathOfLocal) then
		FileHelper.DeleteFile(tempUploadPathOfLocal)
	end
	local tempExtension = PhotoFileInfo.Extension
	PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
	tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempUploadPathOfLocal(scenic_spot_id)
	if FileHelper.ExistFile(tempUploadPathOfLocal) then
		FileHelper.DeleteFile(tempUploadPathOfLocal)
	end
	PhotoFileInfo.Extension = tempExtension
	LocalScenicSpotPhotoNew.Ins():Delete_Share(scenic_spot_id, true)
	LocalScenicSpotPhotoNew.Ins():Delete_Share(scenic_spot_id, false)
end

function ScenicSpotPhotoNew:ClearLocal_Roles(role_id, scenic_spot_id)
	local photoID = self:GetPhotoID(role_id, scenic_spot_id)
	local downloadOPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, true)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	downloadOPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, true, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	local downloadTPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, false)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	downloadTPath = Application.persistentDataPath .. '/' .. NetIngScenicSpotPhotoNew.Ins():GetTempDownloadPathOfLocal(photoID, false, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	LocalScenicSpotPhotoNew.Ins():Delete_Roles(photoID, true)
	LocalScenicSpotPhotoNew.Ins():Delete_Roles(photoID, false)
end

function ScenicSpotPhotoNew:GetPhotoID(role_id, scenic_spot_id)
	return role_id .. '_' .. scenic_spot_id
end

-- params
-- o_or_t, true : origin image; false : thumbnail
function ScenicSpotPhotoNew:GetLocalAbsolutePath_Share(scenic_spot_id, o_or_t)
	local localPath = LocalScenicSpotPhotoNew.Ins():GetPathOfLocal_Share(scenic_spot_id, o_or_t)
	return localPath
end

function ScenicSpotPhotoNew:GetLocalAbsolutePath_Roles(role_id, scenic_spot_id, o_or_t)
	local photoID = self:GetPhotoID(role_id, scenic_spot_id)
	local localPath = LocalScenicSpotPhotoNew.Ins():GetPathOfLocal_Roles(photoID, o_or_t)
	return localPath
end