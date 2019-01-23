autoImport('LocalUnionWallPhoto')
autoImport('NetIngUnionWallPhoto_ScenicSpot')
autoImport('NetIngUnionWallPhoto_Personal')
autoImport('UnionWallPhotoCallback')
autoImport('StringUtility')
autoImport('PhotoFileInfo')

UnionWallPhoto = class('UnionWallPhoto')

UnionWallPhoto.thumbnailCoefficient = 0.1

UnionWallPhoto.ins = nil
function UnionWallPhoto.Ins()
	if UnionWallPhoto.ins == nil then
		UnionWallPhoto.ins = UnionWallPhoto.new()
	end
	return UnionWallPhoto.ins
end

function UnionWallPhoto:Initialize()
	self.callback = UnionWallPhotoCallback.new()
	self.isGetingOForMakeT = {}
	self.isMakingTWhenGetThumbnail = {}
	self.willStopMakeThumbnailWhenGetThumbnail = {}

	self.isGettingO = {} -- outside call
	self.isGettingT = {} -- outside call
end

-- region personal

-- progress_callback
-- function (progressValue)
-- end
-- success_callback
-- function (bytes, timestamp)
-- end
-- error_callback
-- function (errorMessage)
-- end
function UnionWallPhoto:GetOriginImage_Personal(role_id, pos_index, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_unionwallphotocallback, extension)
	print(string.format('UnionWallPhoto:GetOriginImage_Personal\nrole_id=%s\npos_index=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(role_id), tostring(pos_index), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	local photoID = self:GetPhotoID(role_id, pos_index, 'p')

	if not is_through_unionwallphotocallback then
		if not is_keep_previous_callback then
			self.callback:ClearCallback(photoID, true)
		end
		self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, true)

		if self:IsGettingO(photoID) then return end
		self.isGettingO[photoID] = 0
	end

	local isLatestLocal = false
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalUnionWallPhoto.Ins():Get(photoID, localTimestamp, true)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalUnionWallPhoto.Ins():Get(photoID, localTimestamp, true)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingO[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, true)
		if is_through_unionwallphotocallback then
			if success_callback ~= nil then
				success_callback(bytes, localTimestamp)
			end
		end
	else
		local isDownloading = NetIngUnionWallPhoto_Personal.Ins():IsDownloading(photoID, true)
		if not isDownloading then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_Personal.Ins():GetTempDownloadPathOfLocal(photoID, true, extension)
			NetIngUnionWallPhoto_Personal.Ins():Download(
				role_id,
				pos_index,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(photoID, progressValue, true)
					if is_through_unionwallphotocallback then
						if progress_callback ~= nil then
							progress_callback(progressValue)
						end
					end
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					LocalUnionWallPhoto.Ins():Save(photoID, bytes, timestamp, true, extension)
					FileHelper.DeleteFile(downloadPath)

					self.isGettingO[photoID] = nil
					self.callback:FireSuccess(photoID, bytes, timestamp, true)
					if is_through_unionwallphotocallback then
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
					if is_through_unionwallphotocallback then
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

function UnionWallPhoto:StopGetOriginImage_Personal(role_id, pos_index)
	local photoID = self:GetPhotoID(role_id, pos_index, 'p')
	NetIngUnionWallPhoto_Personal.Ins():StopDownload(photoID, true)
end

function UnionWallPhoto:GetThumbnail_Personal(role_id, pos_index, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, extension)
	print(string.format('UnionWallPhoto:GetThumbnail_Personal\nrole_id=%s\npos_index=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(role_id), tostring(pos_index), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	local photoID = self:GetPhotoID(role_id, pos_index, 'p')

	if not is_keep_previous_callback then
		self.callback:ClearCallback(photoID, false)
	end
	self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, false)
	if self:IsGettingT(photoID) then return end
	self.isGettingT[photoID] = 0

	local isLatestLocal = false
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalUnionWallPhoto.Ins():Get(photoID, timestamp, false)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalUnionWallPhoto.Ins():Get(photoID, localTimestamp, true)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingT[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, false)
	else
		local isDownloading = NetIngUnionWallPhoto_Personal.Ins():IsDownloading(photoID, false)
		if not isDownloading and not self:IsGetingOForMakeT(photoID) and not self:IsMakingTWhenGetThumbnail(photoID) then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_Personal.Ins():GetTempDownloadPathOfLocal(photoID, false, extension)
			NetIngUnionWallPhoto_Personal.Ins():Download(
				role_id,
				pos_index,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(photoID, progressValue, false)
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalUnionWallPhoto.Ins():Save(photoID, bytes, timestamp, false, extension)

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
					UnionWallPhotoHelper.Ins():GetOriginImage_Personal(
						role_id,
						pos_index,
						timestamp,
						nil,
						function (x, y)
							self.isGetingOForMakeT[photoID] = nil

							local bytesOfOriginImage = x
							local timestampOfOriginImage = y
							local texture = Texture2D(0,0,TextureFormat.RGB24,false)
							ImageConversion.LoadImage(texture, bytesOfOriginImage)
							self.isMakingTWhenGetThumbnail[photoID] = 0
							FunctionTextureScale.ins:Scale(texture, UnionWallPhoto.thumbnailCoefficient, function (x)
								Object.DestroyImmediate(texture)
								local scaledTexture = x
								if self.willStopMakeThumbnailWhenGetThumbnail[photoID] ~= nil then
									Object.DestroyImmediate(scaledTexture)
									self.isMakingTWhenGetThumbnail[photoID] = nil
									self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
								else
									local bytes = ImageConversion.EncodeToJPG(scaledTexture)
									Object.DestroyImmediate(scaledTexture)
									LocalUnionWallPhoto.Ins():Save(photoID, bytes, timestampOfOriginImage, false)
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

function UnionWallPhoto:StopGetThumbnail_Personal(role_id, pos_index)
	local photoID = self:GetPhotoID(role_id, pos_index, 'p')
	NetIngUnionWallPhoto_Personal.Ins():StopDownload(photoID, false)
	if self:IsGetingOForMakeT(photoID) then
		UnionWallPhotoHelper.Ins():StopGetOriginImage_Personal(role_id, pos_index)
	elseif self:IsMakingTWhenGetThumbnail(photoID) then
		self.willStopMakeThumbnailWhenGetThumbnail[photoID] = 0
	end
end

-- return value
-- 1 bytes; 2 local timestamp
function UnionWallPhoto:TryGetThumbnailFromLocal_Personal(role_id, pos_index, timestamp, is_force_timestamp)
	print(string.format('UnionWallPhoto:TryGetThumbnailFromLocal_Personal\nrole_id=%s\npos_index=%s\ntimestamp=%s\nis_force_timestamp=%s', tostring(role_id), tostring(pos_index), tostring(timestamp), tostring(is_force_timestamp)))
	local photoID = self:GetPhotoID(role_id, pos_index, 'p')
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, false)
	if is_force_timestamp and timestamp ~= localTimestamp then
		return nil
	end
	local retBytes, retTimestam = LocalUnionWallPhoto.Ins():Get(photoID, timestamp, false)
	if retBytes == nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
		retBytes, retTimestamp = LocalUnionWallPhoto.Ins():Get(photoID, timestamp, false)
		PhotoFileInfo.Extension = tempExtension
	end
	return retBytes, retTimestamp
end

function UnionWallPhoto:Clear_Personal(role_id, pos_index)
	print(string.format('UnionWallPhoto:Clear_Personal\nrole_id=%s\npos_index=%s', tostring(role_id), tostring(pos_index)))
	UnionWallPhotoHelper.Ins():StopGetOriginImage_Personal(role_id, pos_index)
	UnionWallPhotoHelper.Ins():StopGetThumbnail_Personal(role_id, pos_index)
	self:ClearLocal_Personal(role_id, pos_index)
end

function UnionWallPhoto:ClearLocal_Personal(role_id, pos_index)
	local photoID = self:GetPhotoID(role_id, pos_index, 'p')
	local downloadOPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_Personal.Ins():GetTempDownloadPathOfLocal(photoID, true)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	downloadOPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_Personal.Ins():GetTempDownloadPathOfLocal(photoID, true, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	local downloadTPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_Personal.Ins():GetTempDownloadPathOfLocal(photoID, false)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	downloadTPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_Personal.Ins():GetTempDownloadPathOfLocal(photoID, false, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	LocalUnionWallPhoto.Ins():Delete(photoID, true)
	LocalUnionWallPhoto.Ins():Delete(photoID, false)
end
-- region personal

-- region scenic spot
function UnionWallPhoto:GetOriginImage_ScenicSpot(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_unionwallphotocallback, extension)
	print(string.format('UnionWallPhoto:GetOriginImage_ScenicSpot\nrole_id=%s\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(role_id), tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback)))
	local photoID = self:GetPhotoID(role_id, scenic_spot_id, 's')

	if not is_through_unionwallphotocallback then
		if not is_keep_previous_callback then
			self.callback:ClearCallback(photoID, true)
		end
		self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, true)

		if self:IsGettingO(photoID) then return end
		self.isGettingO[photoID] = 0
	end

	local isLatestLocal = false
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalUnionWallPhoto.Ins():Get(photoID, localTimestamp, true)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalUnionWallPhoto.Ins():Get(photoID, localTimestamp, true)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingO[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, true)
		if is_through_unionwallphotocallback then
			if success_callback ~= nil then
				success_callback(bytes, localTimestamp)
			end
		end
	else
		local isDownloading = NetIngUnionWallPhoto_ScenicSpot.Ins():IsDownloading(photoID, true)
		if not isDownloading then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_ScenicSpot.Ins():GetTempDownloadPathOfLocal(photoID, true, extension)
			NetIngUnionWallPhoto_ScenicSpot.Ins():Download(
				role_id,
				scenic_spot_id,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(photoID, progressValue, true)
					if is_through_unionwallphotocallback then
						if progress_callback ~= nil then
							progress_callback(progressValue)
						end
					end
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					LocalUnionWallPhoto.Ins():Save(photoID, bytes, timestamp, true, extension)
					FileHelper.DeleteFile(downloadPath)

					self.isGettingO[photoID] = nil
					self.callback:FireSuccess(photoID, bytes, timestamp, true)
					if is_through_unionwallphotocallback then
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
					if is_through_unionwallphotocallback then
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
function UnionWallPhoto:IsGettingO(photoID)
	return self.isGettingO[photoID] ~= nil
end

function UnionWallPhoto:StopGetOriginImage_ScenicSpot(role_id, scenic_spot_id)
	local photoID = self:GetPhotoID(role_id, scenic_spot_id, 's')
	NetIngUnionWallPhoto_ScenicSpot.Ins():StopDownload(photoID, true)
end

function UnionWallPhoto:GetThumbnail_ScenicSpot(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, extension)
	print(string.format('UnionWallPhoto:GetThumbnail_ScenicSpot\nrole_id=%s\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(role_id), tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback)))
	local photoID = self:GetPhotoID(role_id, scenic_spot_id, 's')

	if not is_keep_previous_callback then
		self.callback:ClearCallback(photoID, false)
	end
	self.callback:RegisterCallback(photoID, progress_callback, success_callback, error_callback, false)
	if self:IsGettingT(photoID) then return end
	self.isGettingT[photoID] = 0

	local isLatestLocal = false
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalUnionWallPhoto.Ins():Get(photoID, timestamp, false)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalUnionWallPhoto.Ins():Get(photoID, localTimestamp, false)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingT[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, false)
	else
		local isDownloading = NetIngUnionWallPhoto_ScenicSpot.Ins():IsDownloading(photoID, false)
		if not isDownloading and not self:IsGetingOForMakeT(photoID) and not self:IsMakingTWhenGetThumbnail(photoID) then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_ScenicSpot.Ins():GetTempDownloadPathOfLocal(photoID, false, extension)
			NetIngUnionWallPhoto_ScenicSpot.Ins():Download(
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
					LocalUnionWallPhoto.Ins():Save(photoID, bytes, timestamp, false, extension)

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
					UnionWallPhotoHelper.Ins():GetOriginImage_ScenicSpot(
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
							FunctionTextureScale.ins:Scale(texture, UnionWallPhoto.thumbnailCoefficient, function (x)
								Object.DestroyImmediate(texture)
								local scaledTexture = x
								if self.willStopMakeThumbnailWhenGetThumbnail[photoID] ~= nil then
									Object.DestroyImmediate(scaledTexture)
									self.isMakingTWhenGetThumbnail[photoID] = nil
									self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
								else
									local bytes = ImageConversion.EncodeToJPG(scaledTexture)
									Object.DestroyImmediate(scaledTexture)
									LocalUnionWallPhoto.Ins():Save(photoID, bytes, timestampOfOriginImage, false)
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
function UnionWallPhoto:IsGettingT(photoID)
	return self.isGettingT[photoID] ~= nil
end
function UnionWallPhoto:IsGetingOForMakeT(photoID)
	return self.isGetingOForMakeT[photoID] ~= nil
end
function UnionWallPhoto:IsMakingTWhenGetThumbnail(photoID)
	return self.isMakingTWhenGetThumbnail[photoID] ~= nil
end

function UnionWallPhoto:StopGetThumbnail_ScenicSpot(role_id, scenic_spot_id)
	local photoID = self:GetPhotoID(role_id, scenic_spot_id, 's')
	NetIngUnionWallPhoto_ScenicSpot.Ins():StopDownload(photoID, false)
	if self:IsGetingOForMakeT(photoID) then
		UnionWallPhotoHelper.Ins():StopGetOriginImage_ScenicSpot(role_id, scenic_spot_id)
	elseif self:IsMakingTWhenGetThumbnail(photoID) then
		self.willStopMakeThumbnailWhenGetThumbnail[photoID] = 0
	end
end

-- return value
-- 1 bytes; 2 local timestamp
function UnionWallPhoto:TryGetThumbnailFromLocal_ScenicSpot(role_id, scenic_spot_id, timestamp, is_force_timestamp)
	print(string.format('UnionWallPhoto:TryGetThumbnailFromLocal_ScenicSpot\nrole_id=%s\nscenic_spot_id=%s\ntimestamp=%s\nis_force_timestamp=%s', tostring(role_id), tostring(scenic_spot_id), tostring(timestamp), tostring(is_force_timestamp)))
	local photoID = self:GetPhotoID(role_id, scenic_spot_id, 's')
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, false)
	if is_force_timestamp and timestamp ~= localTimestamp then
		return nil
	end
	local retBytes, retTimestamp = LocalUnionWallPhoto.Ins():Get(photoID, timestamp, false)
	if retBytes == nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
		retBytes, retTimestamp = LocalUnionWallPhoto.Ins():Get(photoID, timestamp, false)
		PhotoFileInfo.Extension = tempExtension
	end
	return retBytes, retTimestamp
end

function UnionWallPhoto:Clear_ScenicSpot(role_id, scenic_spot_id)
	print(string.format('UnionWallPhoto:Clear_ScenicSpot\nrole_id=%s\nscenic_spot_id=%s', tostring(role_id), tostring(scenic_spot_id)))
	UnionWallPhotoHelper.Ins():StopGetOriginImage_ScenicSpot(role_id, scenic_spot_id)
	UnionWallPhotoHelper.Ins():StopGetThumbnail_ScenicSpot(role_id, scenic_spot_id)
	self:ClearLocal_ScenicSpot(role_id, scenic_spot_id)
end

function UnionWallPhoto:ClearLocal_ScenicSpot(role_id, scenic_spot_id)
	local photoID = self:GetPhotoID(role_id, scenic_spot_id, 's')
	local downloadOPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_ScenicSpot.Ins():GetTempDownloadPathOfLocal(photoID, true)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	downloadOPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_ScenicSpot.Ins():GetTempDownloadPathOfLocal(photoID, true, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	local downloadTPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_ScenicSpot.Ins():GetTempDownloadPathOfLocal(photoID, false)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	downloadTPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_ScenicSpot.Ins():GetTempDownloadPathOfLocal(photoID, false, PhotoFileInfo.OldExtensio)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	LocalUnionWallPhoto.Ins():Delete(photoID, true)
	LocalUnionWallPhoto.Ins():Delete(photoID, false)
end
-- region scenic spot

function UnionWallPhoto:GetPhotoID(role_id, sid_or_pindex, p_or_s)
	return role_id .. '_' .. sid_or_pindex .. '_' .. p_or_s
end

function UnionWallPhoto:SeparatePhotoID(photo_id)
	local splitedPhotoID = StringUtility.Split(photo_id, '_')
	local roleID = tonumber(splitedPhotoID[1])
	local pIndexOrSID = tonumber(splitedPhotoID[2])
	local pOrS = splitedPhotoID[3]
	return roleID, pIndexOrSID, pOrS
end

function UnionWallPhoto:Clear(role_id)
	print(string.format('UnionWallPhoto:Clear\nrole_id=%s', role_id))
	for k, v in pairs(self.isGettingO) do
		local photoID = k
		local roleID, pIndexOrSID, pOrS = self:SeparatePhotoID(photoID)
		if pOrS == 'p' then
			UnionWallPhotoHelper.Ins():StopGetOriginImage_Personal(roleID, pIndexOrSID)
		elseif pOrS == 's' then
			UnionWallPhotoHelper.Ins():StopGetOriginImage_ScenicSpot(roleID, pIndexOrSID)
		end
	end
	for k, v in pairs(self.isGettingT) do
		local photoID = k
		local roleID, pIndexOrSID, pOrS = self:SeparatePhotoID(photoID)
		if pOrS == 'p' then
			UnionWallPhotoHelper.Ins():StopGetThumbnail_Personal(roleID, pIndexOrSID)
		elseif pOrS == 's' then
			UnionWallPhotoHelper.Ins():StopGetThumbnail_ScenicSpot(roleID, pIndexOrSID)
		end
	end
	self:ClearLocal(role_id)
end

function UnionWallPhoto:ClearLocal(role_id)
	NetIngUnionWallPhoto_Personal.Ins():ClearTempDownloadFileOfRole(role_id)
	NetIngUnionWallPhoto_ScenicSpot.Ins():ClearTempDownloadFileOfRole(role_id)
	LocalUnionWallPhoto.Ins():DeleteAllPhotosOfRole(role_id)
end