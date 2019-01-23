autoImport('NetIngPersonalPhoto')
autoImport('LocalPersonalPhoto')
autoImport('PersonalPhotoCallback')
autoImport('PhotoFileInfo')

PersonalPhoto = class('PersonalPhoto')

PersonalPhoto.thumbnailCoefficient = 0.1

function PersonalPhoto.Ins()
	if PersonalPhoto.ins == nil then
		PersonalPhoto.ins = PersonalPhoto.new()
	end
	return PersonalPhoto.ins
end

function PersonalPhoto:Initialize()
	NetIngPersonalPhoto.Ins():Initialize()
	self.callback = PersonalPhotoCallback.new()
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
-- function (bytes, localTimestamp)
-- end
-- error_callback
-- function (errorMessage)
-- end
function PersonalPhoto:GetOriginImage(pos_index, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_personalphotocallback, extension)
	print(string.format('PersonalPhoto:GetOriginImage\npos_index=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(pos_index), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	if not is_through_personalphotocallback then
		if not is_keep_previous_callback then
			self.callback:ClearCallback(pos_index, true)
		end
		self.callback:RegisterCallback(pos_index, progress_callback, success_callback, error_callback, true)

		if self:IsGettingO(pos_index) then return end
		self.isGettingO[pos_index] = 0
	end

	local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
	local isLatestLocal = false
	local localTimestamp = LocalPersonalPhoto.Ins():GetTimestamp(photoID, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalPersonalPhoto.Ins():Get(photoID, localTimestamp, true)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalPersonalPhoto.Ins():Get(photoID, localTimestamp, true)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingO[pos_index] = nil
		self.callback:FireSuccess(pos_index, bytes, localTimestamp, true)
		if is_through_personalphotocallback then
			if success_callback ~= nil then
				success_callback(bytes, localTimestamp)
			end
		end
	else
		local isDownloading = NetIngPersonalPhoto.Ins():IsDownloading(photoID, true)
		if not isDownloading then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempDownloadPathOfLocal(photoID, true, extension)
			NetIngPersonalPhoto.Ins():Download(
				Game.Myself.data.id,
				pos_index,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(pos_index, progressValue, true)
					if is_through_personalphotocallback then
						if progress_callback ~= nil then
							progress_callback(progressValue)
						end
					end
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalPersonalPhoto.Ins():Save(photoID, bytes, timestamp, true, extension)

					self.isGettingO[pos_index] = nil
					self.callback:FireSuccess(pos_index, bytes, timestamp, true)
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
					self.isGettingO[pos_index] = nil
					self.callback:FireError(pos_index, errorMessage, true)
					if is_through_personalphotocallback then
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
function PersonalPhoto:IsGettingO(pos_index)
	return self.isGettingO[pos_index] ~= nil
end

function PersonalPhoto:StopGetOriginImage(pos_index)
	local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
	NetIngPersonalPhoto.Ins():StopDownload(photoID, true)
end

function PersonalPhoto:GetThumbnail(pos_index, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, extension)
	print(string.format('PersonalPhoto:GetThumbnail\npos_index=%s\ntimestamp=%s\nis_keep_previous_callback=%s\nextension=%s', tostring(pos_index), tostring(timestamp), tostring(is_keep_previous_callback), extension))
	if not is_keep_previous_callback then
		self.callback:ClearCallback(pos_index, false)
	end
	self.callback:RegisterCallback(pos_index, progress_callback, success_callback, error_callback, false)
	if self:IsGettingT(pos_index) then return end
	self.isGettingT[pos_index] = 0

	local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
	local isLatestLocal = false
	local localTimestamp = LocalPersonalPhoto.Ins():GetTimestamp(photoID, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalPersonalPhoto.Ins():Get(photoID, localTimestamp, false)
		if bytes == nil then
			local tempExtension = PhotoFileInfo.Extension
			PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
			bytes = LocalPersonalPhoto.Ins():Get(photoID, localTimestamp, false)
			PhotoFileInfo.Extension = tempExtension
		end
		self.isGettingT[pos_index] = nil
		self.callback:FireSuccess(pos_index, bytes, localTimestamp, false)
	else
		local isDownloading = NetIngPersonalPhoto.Ins():IsDownloading(photoID, false)
		if not isDownloading and not self:IsGetingOForMakeT(pos_index) and not self:IsMakingTWhenGetThumbnail(pos_index) then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempDownloadPathOfLocal(photoID, false, extension)
			NetIngPersonalPhoto.Ins():Download(
				Game.Myself.data.id,
				pos_index,
				photoID,
				timestamp,
				function (x)
					local progressValue = x
					self.callback:FireProgress(pos_index, progressValue, false)
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalPersonalPhoto.Ins():Save(photoID, bytes, timestamp, false, extension)

					self.isGettingT[pos_index] = nil
					self.callback:FireSuccess(pos_index, bytes, timestamp, false)
				end,
				function ()
					-- delete error temp download file
					if FileHelper.ExistFile(downloadPath) then
						FileHelper.DeleteFile(downloadPath)
					end

					self.isGetingOForMakeT[pos_index] = 0
					-- If origin image exists on local, getting origin image will LRU.
					PersonalPhotoHelper.Ins():GetOriginImage(
						pos_index,
						timestamp,
						nil,
						function (x, y)
							self.isGetingOForMakeT[pos_index] = nil

							local bytesOfOriginImage = x
							local timestampOfOriginImage = y
							local texture = Texture2D(0,0,TextureFormat.RGB24,false)
							ImageConversion.LoadImage(texture, bytesOfOriginImage)
							self.isMakingTWhenGetThumbnail[pos_index] = 0
							FunctionTextureScale.ins:Scale(texture, PersonalPhoto.thumbnailCoefficient, function (x)
								Object.DestroyImmediate(texture)
								local scaledTexture = x
								if self.willStopMakeThumbnailWhenGetThumbnail[pos_index] ~= nil then
									Object.DestroyImmediate(scaledTexture)
									self.isMakingTWhenGetThumbnail[pos_index] = nil
									self.willStopMakeThumbnailWhenGetThumbnail[pos_index] = nil
								else
									local bytes = ImageConversion.EncodeToJPG(scaledTexture)
									Object.DestroyImmediate(scaledTexture)
									LocalPersonalPhoto.Ins():Save(photoID, bytes, timestampOfOriginImage, false)
									self.isMakingTWhenGetThumbnail[pos_index] = nil

									self.isGettingT[pos_index] = nil
									self.callback:FireSuccess(pos_index, bytes, timestampOfOriginImage, false)
								end
							end)
						end,
						function (x)
							self.isGetingOForMakeT[pos_index] = nil

							local errorMessage = x
							self.isGettingT[pos_index] = nil
							self.callback:FireError(pos_index, errorMessage, false)
						end,
						true,
						true
					)
				end,
				false,
				extension
			)
		elseif self:IsMakingTWhenGetThumbnail(pos_index) then
			self.willStopMakeThumbnailWhenGetThumbnail[pos_index] = nil
		end
	end
end
function PersonalPhoto:IsGettingT(pos_index)
	return self.isGettingT[pos_index] ~= nil
end
function PersonalPhoto:IsGetingOForMakeT(pos_index)
	return self.isGetingOForMakeT[pos_index] ~= nil
end
function PersonalPhoto:IsMakingTWhenGetThumbnail(pos_index)
	return self.isMakingTWhenGetThumbnail[pos_index] ~= nil
end

function PersonalPhoto:StopGetThumbnail(pos_index)
	local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
	NetIngPersonalPhoto.Ins():StopDownload(photoID, false)
	if self:IsGetingOForMakeT(pos_index) then
		PersonalPhotoHelper.Ins():StopGetOriginImage(pos_index)
	elseif self:IsMakingTWhenGetThumbnail(pos_index) then
		self.willStopMakeThumbnailWhenGetThumbnail[pos_index] = 0
	end
end

-- return value
-- 1 bytes; 2 local timestamp
function PersonalPhoto:TryGetThumbnailFromLocal(pos_index, timestamp, is_force_timestamp)
	print(string.format('PersonalPhoto:TryGetThumbnailFromLocal\npos_index=%s\ntimestamp=%s\nis_force_timestamp=%s', tostring(pos_index), tostring(timestamp), tostring(is_force_timestamp)))
	local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
	local localTimestamp = LocalPersonalPhoto.Ins():GetTimestamp(photoID, false)
	if is_force_timestamp and timestamp ~= localTimestamp then
		return nil
	end
	local retBytes, retTimestamp = LocalPersonalPhoto.Ins():Get(photoID, timestamp, false)
	if retBytes == nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
		retBytes, retTimestamp = LocalPersonalPhoto.Ins():Get(photoID, timestamp, false)
		PhotoFileInfo.Extension = tempExtension
	end
	return retBytes, retTimestamp
end

function PersonalPhoto:SaveAndUpload(pos_index, bytes, timestamp, progress_callback, success_callback, error_callback)
	print(string.format('PersonalPhoto:SaveAndUpload\npos_index=%s\ntimestamp=%s', tostring(pos_index), tostring(timestamp)))

	local md5IsCorrect = false
	local correctMD5 = GamePhoto.GetPhotoFileMD5_Personal(pos_index)
	if correctMD5 ~= nil then
		local currentMD5 = MyMD5.HashBytes(bytes)
		md5IsCorrect = currentMD5 == correctMD5
	end
	if not md5IsCorrect then
		MsgManager.ShowMsgByID(3706)
		if error_callback ~= nil then
			error_callback('Error file.')
		end
		return
	end

	if self:IsSaving(pos_index) then
		Debug.LogError('FAST HAND!')
	else
		self:StopSaveAndUpload(pos_index)
		PersonalPhotoHelper.Ins():StopGetOriginImage(pos_index)
		PersonalPhotoHelper.Ins():StopGetThumbnail(pos_index)
		self:ClearLocal(pos_index)

		local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
		local m = self.isSaving[pos_index]; m = m or 0; m = m + 1; self.isSaving[pos_index] = m
		LocalPersonalPhoto.Ins():SaveAsync(
			photoID,
			bytes,
			timestamp,
			function ()
				local tempUploadRootPath = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempUploadRootPathOfLocal()
				if not FileHelper.ExistDirectory(tempUploadRootPath) then
					FileHelper.CreateDirectory(tempUploadRootPath)
				end
				local tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempUploadPathOfLocal(photoID)
				FileDirectoryHandler.WriteFile(tempUploadPathOfLocal, bytes, function ()
					local n = self.isSaving[pos_index]; n = n - 1; self.isSaving[pos_index] = n
					if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
						NetIngPersonalPhoto.Ins():FormUpload(
							pos_index,
							photoID,
							progress_callback,
							function ()
								NetIngPersonalPhoto.Ins():SetExist(Game.Myself.data.id, pos_index)
								FileHelper.DeleteFile(tempUploadPathOfLocal)
								if success_callback ~= nil then
									success_callback()
								end
							end,
							error_callback
						)
					else
						NetIngPersonalPhoto.Ins():Upload(
							Game.Myself.data.id,
							pos_index,
							photoID,
							progress_callback,
							function ()
								NetIngPersonalPhoto.Ins():SetExist(Game.Myself.data.id, pos_index)
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
		self.isMakingTWhenSaveAndUpload[pos_index] = 0
		FunctionTextureScale.ins:Scale(texture, PersonalPhoto.thumbnailCoefficient, function (x)
			Object.DestroyImmediate(texture)
			local scaledTexture = x
			if self.willStopMakeThumbnailWhenSaveUpload[pos_index] ~= nil then
				Object.DestroyImmediate(scaledTexture)
				self.isMakingTWhenSaveAndUpload[pos_index] = nil
				self.willStopMakeThumbnailWhenSaveUpload[pos_index] = nil
			else
				local bytesThumbnail = ImageConversion.EncodeToJPG(scaledTexture)
				LocalPersonalPhoto.Ins():Save(photoID, bytesThumbnail, timestamp, false)
				self.isMakingTWhenSaveAndUpload[pos_index] = nil
			end
		end)
	end
end
function PersonalPhoto:IsSaving(pos_index)
	local m = self.isSaving[pos_index]
	return m ~= nil and m > 0
end
function PersonalPhoto:IsMakingTWhenSaveAndUpload(pos_index)
	return self.isMakingTWhenSaveAndUpload[pos_index] ~= nil
end

function PersonalPhoto:StopSaveAndUpload(pos_index)
	self:StopUpload(pos_index)
	if self:IsMakingTWhenSaveAndUpload(pos_index) then
		self.willStopMakeThumbnailWhenSaveUpload[pos_index] = 0
	end
end

function PersonalPhoto:Upload(pos_index, progress_callback, success_callback, error_callback)
	print(string.format('PersonalPhoto:Upload\npos_index=%s', tostring(pos_index)))

	local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
	local bytes = LocalPersonalPhoto.Ins():Get(photoID, nil, true)
	if bytes ~= nil then
		local md5IsCorrect = false
		local correctMD5 = GamePhoto.GetPhotoFileMD5_Personal(pos_index)
		if correctMD5 ~= nil then
			local currentMD5 = MyMD5.HashBytes(bytes)
			md5IsCorrect = currentMD5 == correctMD5
		end
		if not md5IsCorrect then
			MsgManager.ShowMsgByID(3706)
			if error_callback ~= nil then
				error_callback('Error file.')
			end
			return
		end

		if self:IsSaving(pos_index) then
			Debug.LogError('FAST HAND!')
		else
			self:StopUpload(pos_index)

			local tempUploadRootPath = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempUploadRootPathOfLocal()
			if not FileHelper.ExistDirectory(tempUploadRootPath) then
				FileHelper.CreateDirectory(tempUploadRootPath)
			end
			local tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempUploadPathOfLocal(photoID)
			local m = self.isSaving[pos_index]; m = m or 0; m = m + 1; self.isSaving[pos_index] = m
			FileDirectoryHandler.WriteFile(tempUploadPathOfLocal, bytes, function ()
				local n = self.isSaving[pos_index]; n = n - 1; self.isSaving[pos_index] = n
				if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
					NetIngPersonalPhoto.Ins():FormUpload(
						pos_index,
						photoID,
						progress_callback,
						function ()
							NetIngPersonalPhoto.Ins():SetExist(Game.Myself.data.id, pos_index)
							FileHelper.DeleteFile(tempUploadPathOfLocal)
							if success_callback ~= nil then
								success_callback()
							end
						end,
						error_callback
					)
				else
					NetIngPersonalPhoto.Ins():Upload(
						Game.Myself.data.id,
						pos_index,
						photoID,
						progress_callback,
						function ()
							NetIngPersonalPhoto.Ins():SetExist(Game.Myself.data.id, pos_index)
							FileHelper.DeleteFile(tempUploadPathOfLocal)
							if success_callback ~= nil then
								success_callback()
							end
						end,
						error_callback
					)
				end
			end)
		end
	end
end

function PersonalPhoto:StopUpload(pos_index)
	local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
	if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
		NetIngPersonalPhoto.Ins():StopFormUpload(photoID)
	else
		NetIngPersonalPhoto.Ins():StopUpload(photoID)
	end
end

function PersonalPhoto:CheckExistOnServer(pos_index, exist_callback, error_callback)
	print(string.format('PersonalPhoto:CheckExistOnServer\npos_index=%s', tostring(pos_index)))
	NetIngPersonalPhoto.Ins():CheckExist(
		Game.Myself.data.id,
		pos_index,
		exist_callback,
		function ()
			NetIngPersonalPhoto.Ins():CheckExist(
				Game.Myself.data.id,
				pos_index,
				exist_callback,
				error_callback,
				PhotoFileInfo.OldExtension
			)
		end,
		PhotoFileInfo.Extension
	)
end

-- return value
-- local timestamp
function PersonalPhoto:CheckExistOnLocal(pos_index)
	print(string.format('PersonalPhoto:CheckExistOnLocal\npos_index=%s', tostring(pos_index)))
	local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
	return LocalPersonalPhoto.Ins():GetTimestamp(photoID, true)
end

function PersonalPhoto:Clear(pos_index)
	print(string.format('PersonalPhoto:Clear\npos_index=%s', tostring(pos_index)))
	self:StopSaveAndUpload(pos_index)
	PersonalPhotoHelper.Ins():StopGetOriginImage(pos_index)
	PersonalPhotoHelper.Ins():StopGetThumbnail(pos_index)
	self:ClearLocal(pos_index)
end

function PersonalPhoto:ClearLocal(pos_index)
	local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
	local downloadOPath = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempDownloadPathOfLocal(photoID, true)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	downloadOPath = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempDownloadPathOfLocal(photoID, true, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	local downloadTPath = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempDownloadPathOfLocal(photoID, false)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	downloadTPath = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempDownloadPathOfLocal(photoID, false, PhotoFileInfo.OldExtension)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	local tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempUploadPathOfLocal(photoID)
	if FileHelper.ExistFile(tempUploadPathOfLocal) then
		FileHelper.DeleteFile(tempUploadPathOfLocal)
	end
	local tempExtension = PhotoFileInfo.Extension
	PhotoFileInfo.Extension = PhotoFileInfo.OldExtension
	tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngPersonalPhoto.Ins():GetTempUploadPathOfLocal(photoID)
	if FileHelper.ExistFile(tempUploadPathOfLocal) then
		FileHelper.DeleteFile(tempUploadPathOfLocal)
	end
	PhotoFileInfo.Extension = tempExtension
	LocalPersonalPhoto.Ins():Delete(photoID, true)
	LocalPersonalPhoto.Ins():Delete(photoID, false)
end

-- params
-- o_or_t, true : origin image; false : thumbnail
function PersonalPhoto:GetLocalAbsolutePath(pos_index, o_or_t)
	local photoID = self:GetPhotoID(Game.Myself.data.id, pos_index)
	local localPath = LocalPersonalPhoto.Ins():GetPathOfLocal(photoID, o_or_t)
	return localPath
end

function PersonalPhoto:GetPhotoID(role_id, pos_index)
	-- todo xde change photo id
	--	return role_id .. '_' .. pos_index
	return pos_index
end