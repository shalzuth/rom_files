autoImport('NetIngUnionLogo')
autoImport('LocalUnionLogo')
autoImport('UnionLogoCallback')
autoImport('PhotoFileInfo')
autoImport('GamePhoto')

UnionLogo = class('UnionLogo')

UnionLogo.CallerIndex = {
	LogoEditor = 1,
	RoleFootDetail = 2,
	UnionFlag = 3,
	UnionList = 4
}

UnionLogo.thumbnailCoefficient = 0.25

function UnionLogo.Ins()
	if UnionLogo.ins == nil then
		UnionLogo.ins = UnionLogo.new()
	end
	return UnionLogo.ins
end

function UnionLogo:Initialize()
	NetIngUnionLogo.Ins():Initialize()
	self.callback = UnionLogoCallback.new()
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
-- is_through_personalphotocallback should be nil
function UnionLogo:GetOriginImage(caller_index, pos_index, timestamp, extension, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_personalphotocallback)
	print(string.format('UnionLogo:GetOriginImage\npos_index=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(pos_index), tostring(timestamp), tostring(is_keep_previous_callback)))
	local unionID = self:GetUnionID()
	local photoID = self:GetPhotoID(unionID, pos_index)
	local idForCallback = caller_index .. '_' .. pos_index
	if not is_through_personalphotocallback then
		if not is_keep_previous_callback then
			self.callback:ClearCallback(idForCallback, true)
		end
		self.callback:RegisterCallback(idForCallback, progress_callback, success_callback, error_callback, true)

		if self:IsGettingO(photoID) then return end
		self.isGettingO[photoID] = 0
	end

	extension = extension or PhotoFileInfo.PictureFormat.JPG

	local isLatestLocal = false
	local localTimestamp = LocalUnionLogo.Ins():GetTimestamp(photoID, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalUnionLogo.Ins():Get(photoID, localTimestamp, extension, true)
		self.isGettingO[photoID] = nil
		self.callback:FireSuccess(idForCallback, bytes, localTimestamp, true)
		if is_through_personalphotocallback then
			if success_callback ~= nil then
				success_callback(bytes, localTimestamp)
			end
		end
	else
		local isDownloading = NetIngUnionLogo.Ins():IsDownloading(photoID, true)
		if not isDownloading then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngUnionLogo.Ins():GetTempDownloadPathOfLocal(photoID, true, extension)
			NetIngUnionLogo.Ins():Download(
				unionID,
				pos_index,
				photoID,
				timestamp,
				extension,
				function (x)
					local progressValue = x
					self.callback:FireProgress(idForCallback, progressValue, true)
					if is_through_personalphotocallback then
						if progress_callback ~= nil then
							progress_callback(progressValue)
						end
					end
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalUnionLogo.Ins():Save(photoID, bytes, timestamp, extension, true)

					self.isGettingO[photoID] = nil
					self.callback:FireSuccess(idForCallback, bytes, timestamp, true)
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
					self.callback:FireError(idForCallback, errorMessage, true)
					if is_through_personalphotocallback then
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
function UnionLogo:IsGettingO(photo_id)
	return self.isGettingO[photo_id] ~= nil
end

function UnionLogo:StopGetOriginImage(photo_id)
	NetIngUnionLogo.Ins():StopDownload(photo_id, true)
end

function UnionLogo:GetThumbnail(caller_index, pos_index, timestamp, extension, progress_callback, success_callback, error_callback, is_keep_previous_callback)
	print(string.format('UnionLogo:GetThumbnail\npos_index=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(pos_index), tostring(timestamp), tostring(is_keep_previous_callback)))
	local unionID = self:GetUnionID()
	local photoID = self:GetPhotoID(unionID, pos_index)
	local idForCallback = caller_index .. '_' .. pos_index
	if not is_keep_previous_callback then
		self.callback:ClearCallback(idForCallback, false)
	end
	self.callback:RegisterCallback(idForCallback, progress_callback, success_callback, error_callback, false)
	if self:IsGettingT(photoID) then return end
	self.isGettingT[photoID] = 0

	extension = extension or PhotoFileInfo.PictureFormat.JPG

	local isLatestLocal = false
	local localTimestamp = LocalUnionLogo.Ins():GetTimestamp(photoID, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		local bytes = LocalUnionLogo.Ins():Get(photoID, localTimestamp, extension, false)
		self.isGettingT[photoID] = nil
		self.callback:FireSuccess(idForCallback, bytes, localTimestamp, false)
	else
		local isDownloading = NetIngUnionLogo.Ins():IsDownloading(photoID, false)
		if not isDownloading and not self:IsGetingOForMakeT(photoID) and not self:IsMakingTWhenGetThumbnail(photoID) then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngUnionLogo.Ins():GetTempDownloadPathOfLocal(photoID, false, extension)
			NetIngUnionLogo.Ins():Download(
				unionID,
				pos_index,
				photoID,
				timestamp,
				extension,
				function (x)
					local progressValue = x
					self.callback:FireProgress(idForCallback, progressValue, false)
				end,
				function ()
					local bytes = FileHelper.LoadFile(downloadPath)
					FileHelper.DeleteFile(downloadPath)
					LocalUnionLogo.Ins():Save(photoID, bytes, timestamp, extension, false)

					self.isGettingT[photoID] = nil
					self.callback:FireSuccess(idForCallback, bytes, timestamp, false)
				end,
				function ()
					-- delete error temp download file
					if FileHelper.ExistFile(downloadPath) then
						FileHelper.DeleteFile(downloadPath)
					end

					self.isGetingOForMakeT[photoID] = 0
					-- If origin image exists on local, getting origin image will LRU.
					self:GetOriginImage(
						0,
						pos_index,
						timestamp,
						nil,
						extension,
						function (x, y)
							self.isGetingOForMakeT[photoID] = nil

							local bytesOfOriginImage = x
							local timestampOfOriginImage = y
							local texture = Texture2D(0,0,GamePhoto.GetTFFromExtension(extension),false)
							ImageConversion.LoadImage(texture, bytesOfOriginImage)
							self.isMakingTWhenGetThumbnail[photoID] = 0
							FunctionTextureScale.ins:Scale(texture, UnionLogo.thumbnailCoefficient, function (x)
								Object.DestroyImmediate(texture)
								local scaledTexture = x
								if self.willStopMakeThumbnailWhenGetThumbnail[photoID] ~= nil then
									Object.DestroyImmediate(scaledTexture)
									self.isMakingTWhenGetThumbnail[photoID] = nil
									self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
								else
									local bytes = nil
									if extension == PhotoFileInfo.PictureFormat.PNG then
										bytes = ImageConversion.EncodeToPNG(scaledTexture)
									else
										bytes = ImageConversion.EncodeToJPG(scaledTexture)
									end
									Object.DestroyImmediate(scaledTexture)
									LocalUnionLogo.Ins():Save(photoID, bytes, timestampOfOriginImage, extension, false)
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
function UnionLogo:IsGettingT(photoID)
	return self.isGettingT[photoID] ~= nil
end
function UnionLogo:IsGetingOForMakeT(photoID)
	return self.isGetingOForMakeT[photoID] ~= nil
end
function UnionLogo:IsMakingTWhenGetThumbnail(photoID)
	return self.isMakingTWhenGetThumbnail[photoID] ~= nil
end

function UnionLogo:StopGetThumbnail(photo_id)
	NetIngUnionLogo.Ins():StopDownload(photo_id, false)
	if self:IsGetingOForMakeT(photo_id) then
		self:StopGetOriginImage(photo_id)
	elseif self:IsMakingTWhenGetThumbnail(photo_id) then
		self.willStopMakeThumbnailWhenGetThumbnail[photo_id] = 0
	end
end

function UnionLogo:SaveAndUpload(pos_index, bytes, timestamp, extension, progress_callback, success_callback, error_callback)
	print(string.format('UnionLogo:SaveAndUpload\npos_index=%s\ntimestamp=%s', tostring(pos_index), tostring(timestamp)))

	local md5IsCorrect = false
	local correctMD5 = GamePhoto.GetPhotoFileMD5_UnionLogo(pos_index)
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

	extension = extension or PhotoFileInfo.PictureFormat.JPG
	
	local unionID = self:GetUnionID()
	local photoID = self:GetPhotoID(unionID, pos_index)
	if self:IsSaving(photoID) then
		Debug.LogError('FAST HAND!')
	else
		self:StopSaveAndUpload(photoID)
		self:StopGetOriginImage(photoID)
		self:StopGetThumbnail(photoID)
		self:ClearLocal(pos_index)

		local m = self.isSaving[photoID]; m = m or 0; m = m + 1; self.isSaving[photoID] = m
		LocalUnionLogo.Ins():SaveAsync(
			photoID,
			bytes,
			timestamp,
			extension,
			function ()
				local tempUploadRootPath = Application.persistentDataPath .. '/' .. NetIngUnionLogo.Ins():GetTempUploadRootPathOfLocal()
				if not FileHelper.ExistDirectory(tempUploadRootPath) then
					FileHelper.CreateDirectory(tempUploadRootPath)
				end
				local tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngUnionLogo.Ins():GetTempUploadPathOfLocal(photoID, extension)
				-- If file already exists, truncate.
				FileDirectoryHandler.WriteFile(tempUploadPathOfLocal, bytes, function ()
					local n = self.isSaving[photoID]; n = n - 1; self.isSaving[photoID] = n
					NetIngUnionLogo.Ins():FormUpload(
						pos_index,
						photoID,
						extension,
						progress_callback,
						function ()
							FileHelper.DeleteFile(tempUploadPathOfLocal)
							if success_callback ~= nil then
								success_callback()
							end
						end,
						error_callback
					)
				end)
			end,
			true
		)

		local texture = Texture2D(0, 0, GamePhoto.GetTFFromExtension(extension), false)
		ImageConversion.LoadImage(texture, bytes)
		self.isMakingTWhenSaveAndUpload[photoID] = 0
		FunctionTextureScale.ins:Scale(texture, UnionLogo.thumbnailCoefficient, function (x)
			Object.DestroyImmediate(texture)
			local scaledTexture = x
			if self.willStopMakeThumbnailWhenSaveUpload[photoID] ~= nil then
				Object.DestroyImmediate(scaledTexture)
				self.isMakingTWhenSaveAndUpload[photoID] = nil
				self.willStopMakeThumbnailWhenSaveUpload[photoID] = nil
			else

				local bytesThumbnail = nil
				if extension == PhotoFileInfo.PictureFormat.PNG then
					bytesThumbnail = ImageConversion.EncodeToPNG(scaledTexture)
				else
					bytesThumbnail = ImageConversion.EncodeToJPG(scaledTexture)
				end
				Object.DestroyImmediate(scaledTexture)
				LocalUnionLogo.Ins():Save(photoID, bytesThumbnail, timestamp, extension, false)
				self.isMakingTWhenSaveAndUpload[photoID] = nil
			end
		end)
	end
end
function UnionLogo:IsSaving(photoID)
	local m = self.isSaving[photoID]
	return m ~= nil and m > 0
end
function UnionLogo:IsMakingTWhenSaveAndUpload(photoID)
	return self.isMakingTWhenSaveAndUpload[photoID] ~= nil
end

function UnionLogo:StopSaveAndUpload(photoID)
	self:StopUpload(photoID)
	if self:IsMakingTWhenSaveAndUpload(photoID) then
		self.willStopMakeThumbnailWhenSaveUpload[photoID] = 0
	end
end

function UnionLogo:StopUpload(photoID)
	NetIngUnionLogo.Ins():StopFormUpload(photoID)
end

function UnionLogo:Clear(pos_index, extension)
	extension = extension or PhotoFileInfo.PictureFormat.JPG

	local unionID = self:GetUnionID()
	local photoID = self:GetPhotoID(unionID, pos_index)
	self:StopSaveAndUpload(photoID)
	self:StopGetOriginImage(photoID)
	self:StopGetThumbnail(photoID)
	self:ClearLocal(pos_index, extension)
end

function UnionLogo:ClearLocal(pos_index, extension)
	extension = extension or PhotoFileInfo.PictureFormat.JPG
	
	local unionID = self:GetUnionID()
	local photoID = self:GetPhotoID(unionID, pos_index)
	local downloadOPath = Application.persistentDataPath .. '/' .. NetIngUnionLogo.Ins():GetTempDownloadPathOfLocal(photoID, true, extension)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	local downloadTPath = Application.persistentDataPath .. '/' .. NetIngUnionLogo.Ins():GetTempDownloadPathOfLocal(photoID, false, extension)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	local tempUploadPathOfLocal = Application.persistentDataPath .. '/' .. NetIngUnionLogo.Ins():GetTempUploadPathOfLocal(photoID, extension)
	if FileHelper.ExistFile(tempUploadPathOfLocal) then
		FileHelper.DeleteFile(tempUploadPathOfLocal)
	end
	LocalUnionLogo.Ins():Delete(photoID, true)
	LocalUnionLogo.Ins():Delete(photoID, false)
end

function UnionLogo:GetUnionID()
	return self.currentUnionID
end

function UnionLogo:SetUnionID(union_id)
	self.currentUnionID = union_id
end

function UnionLogo:GetPhotoID(union_id, pos_index)
	return union_id .. '_' .. pos_index
end