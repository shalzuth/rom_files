autoImport('LocalUnionWallPhoto')
autoImport('NetIngUnionWallPhoto_ScenicSpot')
autoImport('NetIngUnionWallPhoto_Personal')
autoImport('UnionWallPhotoCallback')
autoImport('StringUtility')
autoImport('PhotoFileInfo')
autoImport('UnionWallPhoto')

UnionWallPhotoNew = class('UnionWallPhotoNew', UnionWallPhoto)

function UnionWallPhotoNew.Ins()
	if UnionWallPhotoNew.ins == nil then
		UnionWallPhotoNew.ins = UnionWallPhotoNew.new()
	end
	return UnionWallPhotoNew.ins
end

function UnionWallPhotoNew:GetOriginImage_ScenicSpot_Account(account_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_unionwallphotocallback)
	print(string.format('UnionWallPhotoNew:GetOriginImage_ScenicSpot_Account\naccount_id=%s\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(account_id), tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback)))
	local photoID = self:GetPhotoID_Account(account_id, scenic_spot_id, 's')

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
			NetIngUnionWallPhoto_ScenicSpot.Ins():Download_Account(
				account_id,
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
					LocalUnionWallPhoto.Ins():Save(photoID, bytes, timestamp, true)
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
				true
			)
		end
	end
end

function UnionWallPhotoNew:StopGetOriginImage_ScenicSpot_Account(account_id, scenic_spot_id)
	local photoID = self:GetPhotoID_Account(account_id, scenic_spot_id, 's')
	NetIngUnionWallPhoto_ScenicSpot.Ins():StopDownload(photoID, true)
end

function UnionWallPhotoNew:GetThumbnail_ScenicSpot_Account(account_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
	print(string.format('UnionWallPhotoNew:GetThumbnail_ScenicSpot_Account\naccount_id=%s\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(account_id), tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback)))
	local photoID = self:GetPhotoID_Account(account_id, scenic_spot_id, 's')

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
		self.isGettingT[photoID] = nil
		self.callback:FireSuccess(photoID, bytes, localTimestamp, false)
	else
		local isDownloading = NetIngUnionWallPhoto_ScenicSpot.Ins():IsDownloading(photoID, false)
		if not isDownloading and not self:IsGetingOForMakeT(photoID) and not self:IsMakingTWhenGetThumbnail(photoID) then
			local downloadPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_ScenicSpot.Ins():GetTempDownloadPathOfLocal(photoID, false)
			NetIngUnionWallPhoto_ScenicSpot.Ins():Download_Account(
				account_id,
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
					LocalUnionWallPhoto.Ins():Save(photoID, bytes, timestamp, false)

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
					self:GetOriginImage_ScenicSpot_Account(
						account_id,
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
				false
			)
		elseif self:IsMakingTWhenGetThumbnail(photoID) then
			self.willStopMakeThumbnailWhenGetThumbnail[photoID] = nil
		end
	end
end

function UnionWallPhotoNew:StopGetThumbnail_ScenicSpot_Account(account_id, scenic_spot_id)
	local photoID = self:GetPhotoID_Account(account_id, scenic_spot_id, 's')
	NetIngUnionWallPhoto_ScenicSpot.Ins():StopDownload(photoID, false)
	if self:IsGetingOForMakeT(photoID) then
		self:StopGetOriginImage_ScenicSpot_Account(account_id, scenic_spot_id)
	elseif self:IsMakingTWhenGetThumbnail(photoID) then
		self.willStopMakeThumbnailWhenGetThumbnail[photoID] = 0
	end
end

-- return value
-- 1 bytes; 2 local timestamp
function UnionWallPhotoNew:TryGetThumbnailFromLocal_ScenicSpot_Account(account_id, scenic_spot_id, timestamp, is_force_timestamp)
	print(string.format('UnionWallPhotoNew:TryGetThumbnailFromLocal_ScenicSpot_Account\naccount_id=%s\nscenic_spot_id=%s\ntimestamp=%s\nis_force_timestamp=%s', tostring(account_id), tostring(scenic_spot_id), tostring(timestamp), tostring(is_force_timestamp)))
	local photoID = self:GetPhotoID_Account(account_id, scenic_spot_id, 's')
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, false)
	if is_force_timestamp and timestamp ~= localTimestamp then
		return nil
	end
	local retBytes, retTimestamp = LocalUnionWallPhoto.Ins():Get(photoID, timestamp, false)
	return retBytes, retTimestamp
end

function UnionWallPhotoNew:Clear_ScenicSpot_Account(account_id, scenic_spot_id)
	print(string.format('UnionWallPhotoNew:Clear_ScenicSpot_Account\naccount_id=%s\nscenic_spot_id=%s', tostring(account_id), tostring(scenic_spot_id)))
	self:StopGetOriginImage_ScenicSpot_Account(account_id, scenic_spot_id)
	self:StopGetThumbnail_ScenicSpot_Account(account_id, scenic_spot_id)
	self:ClearLocal_ScenicSpot_Account(account_id, scenic_spot_id)
end

function UnionWallPhotoNew:ClearLocal_ScenicSpot_Account(account_id, scenic_spot_id)
	local photoID = self:GetPhotoID_Account(account_id, scenic_spot_id, 's')
	local downloadOPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_ScenicSpot.Ins():GetTempDownloadPathOfLocal(photoID, true)
	if FileHelper.ExistFile(downloadOPath) then
		FileHelper.DeleteFile(downloadOPath)
	end
	local downloadTPath = Application.persistentDataPath .. '/' .. NetIngUnionWallPhoto_ScenicSpot.Ins():GetTempDownloadPathOfLocal(photoID, false)
	if FileHelper.ExistFile(downloadTPath) then
		FileHelper.DeleteFile(downloadTPath)
	end
	LocalUnionWallPhoto.Ins():Delete(photoID, true)
	LocalUnionWallPhoto.Ins():Delete(photoID, false)
end

function UnionWallPhotoNew:SeparatePhotoID_Account(photo_id)
	local splitedPhotoID = StringUtility.Split(photo_id, '_')
	local accountID = tonumber(splitedPhotoID[1])
	local pIndexOrSID = tonumber(splitedPhotoID[2])
	local pOrS = splitedPhotoID[3]
	local accountFlag = splitedPhotoID[4]
	return accountID, pIndexOrSID, pOrS, accountFlag
end

function UnionWallPhotoNew:Clear_Account(account_id)
	print(string.format('UnionWallPhotoNew:Clear_Account\naccount_id=%s', account_id))
	for k, v in pairs(self.isGettingO) do
		local photoID = k
		local accountID, pIndexOrSID, pOrS, accountFlag = self:SeparatePhotoID_Account(photoID)
		if accountFlag == 'a' then
			if pOrS == 's' then
				self:StopGetOriginImage_ScenicSpot_Account(account_id, pIndexOrSID)
			end
		end
	end
	for k, v in pairs(self.isGettingT) do
		local photoID = k
		local accountID, pIndexOrSID, pOrS, accountFlag = self:SeparatePhotoID_Account(photoID)
		if pOrS == 's' then
			self:StopGetThumbnail_ScenicSpot_Account(account_id, pIndexOrSID)
		end
	end
	self:ClearLocal_Account(account_id)
end

function UnionWallPhotoNew:ClearLocal_Account(account_id)
	NetIngUnionWallPhoto_ScenicSpot.Ins():ClearTempDownloadFileOfAccount(account_id)
	LocalUnionWallPhoto.Ins():DeleteAllPhotosOfAccount(account_id)
end

function UnionWallPhoto:GetPhotoID_Account(account_id, sid_or_pindex, p_or_s)
	return account_id .. '_' .. sid_or_pindex .. '_' .. p_or_s .. '_' .. 'a'
end