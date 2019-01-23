autoImport('UnionWallPhotoNew')
autoImport('LocalUnionWallPhoto')
autoImport('NetIngUnionWallPhoto_Personal')
autoImport('NetIngUnionWallPhoto_ScenicSpot')
autoImport('PhotoFileInfo')

UnionWallPhotoHelper = class('UnionWallPhotoHelper')

function UnionWallPhotoHelper:Ins()
	if UnionWallPhotoHelper.ins == nil then
		UnionWallPhotoHelper.ins = UnionWallPhotoHelper.new()
	end
	return UnionWallPhotoHelper.ins
end

function UnionWallPhotoHelper:Initialize()
	self.tabIsCheckingExistO = {}
	self.tabIsCheckingExistT = {}
	self.tabCachedParamsO = {}
	self.tabCachedParamsT = {}
	self.tabStopFlagO = {}
	self.tabStopFlagT = {}
end

function UnionWallPhotoHelper:GetOriginImage_Personal(role_id, pos_index, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_unionwallphotocallback)
	print(string.format('UnionWallPhotoHelper:GetOriginImage_Personal\nrole_id=%s\npos_index=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(role_id), tostring(pos_index), tostring(timestamp), tostring(is_keep_previous_callback)))
	local photoID = UnionWallPhotoNew.Ins():GetPhotoID(role_id, pos_index, 'p')
	self.tabStopFlagO[photoID] = nil
	local isLatestLocal = false
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		UnionWallPhotoNew.Ins():GetOriginImage_Personal(
			role_id,
			pos_index,
			timestamp,
			progress_callback,
			success_callback,
			error_callback,
			is_keep_previous_callback,
			is_through_personalphotocallback
		)
	else
		if self.tabCachedParamsO[photoID] == nil then
			self.tabCachedParamsO[photoID] = {}
		end
		table.insert(
			self.tabCachedParamsO[photoID],
			{
				roleID = role_id,
				posIndex = pos_index,
				timestamp = timestamp,
				progressCallback = progress_callback,
				successCallback = success_callback,
				errorCallback = error_callback,
				isKeepPreviousCallback = is_keep_previous_callback,
				isThroughPersonalphotocallback = is_through_personalphotocallback
			}
		)
		
		if self.tabIsCheckingExistO[photoID] == nil then
			NetIngUnionWallPhoto_Personal.Ins():CheckExist(
				role_id,
				pos_index,
				function ()
					self.tabIsCheckingExistO[photoID] = nil
					if self.tabStopFlagO[photoID] == nil then
						local params = self.tabCachedParamsO[photoID]
						for i = 1, #params do
							local param = params[i]
							UnionWallPhotoNew.Ins():GetOriginImage_Personal(
								role_id,
								pos_index,
								param.timestamp,
								param.progressCallback,
								param.successCallback,
								param.errorCallback,
								param.isKeepPreviousCallback,
								param.isThroughPersonalphotocallback,
								PhotoFileInfo.Extension
							)
						end
					end
					self.tabCachedParamsO[photoID] = nil
				end,
				function ()
					self.tabIsCheckingExistO[photoID] = nil
					if self.tabStopFlagO[photoID] == nil then
						local params = self.tabCachedParamsO[photoID]
						for i = 1, #params do
							local param = params[i]
							UnionWallPhotoNew.Ins():GetOriginImage_Personal(
								role_id,
								pos_index,
								param.timestamp,
								param.progressCallback,
								param.successCallback,
								param.errorCallback,
								param.isKeepPreviousCallback,
								param.isThroughPersonalphotocallback,
								PhotoFileInfo.OldExtension
							)
						end
					end
					self.tabCachedParamsO[photoID] = nil
				end,
				PhotoFileInfo.Extension
			)
			self.tabIsCheckingExistO[photoID] = 0
		end
	end
end

function UnionWallPhotoHelper:StopGetOriginImage_Personal(role_id, pos_index)
	local photoID = UnionWallPhotoNew.Ins():GetPhotoID(role_id, pos_index, 'p')
	if self.tabIsCheckingExistO[photoID] ~= nil then
		self.tabStopFlagO[photoID] = 0
	end
	UnionWallPhotoNew.Ins():StopGetOriginImage_Personal(role_id, pos_index)
end

function UnionWallPhotoHelper:GetThumbnail_Personal(role_id, pos_index, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
	print(string.format('UnionWallPhotoHelper:GetThumbnail_Personal\nrole_id=%s\npos_index=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(role_id), tostring(pos_index), tostring(timestamp), tostring(is_keep_previous_callback)))
	local photoID = UnionWallPhotoNew.Ins():GetPhotoID(role_id, pos_index, 'p')
	self.tabStopFlagT[photoID] = nil
	local isLatestLocal = false
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		UnionWallPhotoNew.Ins():GetThumbnail_Personal(
			role_id,
			pos_index,
			timestamp,
			progress_callback,
			success_callback,
			error_callback,
			is_keep_previous_callback
		)
	else
		if self.tabCachedParamsT[photoID] == nil then
			self.tabCachedParamsT[photoID] = {}
		end
		table.insert(
			self.tabCachedParamsT[photoID],
			{
				timestamp = timestamp,
				progressCallback = progress_callback,
				successCallback = success_callback,
				errorCallback = error_callback,
				isKeepPreviousCallback = is_keep_previous_callback
			}
		)

		if self.tabIsCheckingExistT[photoID] == nil then
			NetIngUnionWallPhoto_Personal.Ins():CheckExist(
				role_id,
				pos_index,
				function ()
					self.tabIsCheckingExistT[photoID] = nil
					if self.tabStopFlagT[photoID] == nil then
						local params = self.tabCachedParamsT[photoID]
						for i = 1, #params do
							local param = params[i]
							UnionWallPhotoNew.Ins():GetThumbnail_Personal(
								role_id,
								pos_index,
								param.timestamp,
								param.progressCallback,
								param.successCallback,
								param.errorCallback,
								param.isKeepPreviousCallback,
								PhotoFileInfo.Extension
							)
						end
					end
					self.tabCachedParamsT[photoID] = nil
				end,
				function ()
					self.tabIsCheckingExistT[photoID] = nil
					if self.tabStopFlagT[photoID] == nil then
						local params = self.tabCachedParamsT[photoID]
						for i = 1, #params do
							local param = params[i]
							UnionWallPhotoNew.Ins():GetThumbnail_Personal(
								role_id,
								pos_index,
								param.timestamp,
								param.progressCallback,
								param.successCallback,
								param.errorCallback,
								param.isKeepPreviousCallback,
								PhotoFileInfo.OldExtension
							)
						end
					end
					self.tabCachedParamsT[photoID] = nil
				end,
				PhotoFileInfo.Extension
			)
			self.tabIsCheckingExistT[photoID] = 0
		end
	end
end

function UnionWallPhotoHelper:StopGetThumbnail_Personal(role_id, pos_index)
	local photoID = UnionWallPhotoNew.Ins():GetPhotoID(role_id, pos_index, 'p')
	if self.tabIsCheckingExistT[photoID] ~= nil then
		self.tabStopFlagT[photoID] = 0
	end
	UnionWallPhotoNew.Ins():StopGetThumbnail_Personal(role_id, pos_index)
end

function UnionWallPhotoHelper:GetOriginImage_ScenicSpot(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_unionwallphotocallback)
	print(string.format('UnionWallPhotoHelper:GetOriginImage_ScenicSpot\nrole_id=%s\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(role_id), tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback)))
	local photoID = UnionWallPhotoNew.Ins():GetPhotoID(role_id, scenic_spot_id, 's')
	self.tabStopFlagO[photoID] = nil
	local isLatestLocal = false
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		UnionWallPhotoNew.Ins():GetOriginImage_ScenicSpot(
			role_id,
			scenic_spot_id,
			timestamp,
			progress_callback,
			success_callback,
			error_callback,
			is_keep_previous_callback,
			is_through_personalphotocallback
		)
	else
		if self.tabCachedParamsO[photoID] == nil then
			self.tabCachedParamsO[photoID] = {}
		end
		table.insert(
			self.tabCachedParamsO[photoID],
			{
				roleID = role_id,
				scenicSpotID = scenic_spot_id,
				timestamp = timestamp,
				progressCallback = progress_callback,
				successCallback = success_callback,
				errorCallback = error_callback,
				isKeepPreviousCallback = is_keep_previous_callback,
				isThroughPersonalphotocallback = is_through_personalphotocallback
			}
		)
		
		if self.tabIsCheckingExistO[photoID] == nil then
			NetIngUnionWallPhoto_ScenicSpot.Ins():CheckExist(
				role_id,
				scenic_spot_id,
				function ()
					self.tabIsCheckingExistO[photoID] = nil
					if self.tabStopFlagO[photoID] == nil then
						local params = self.tabCachedParamsO[photoID]
						for i = 1, #params do
							local param = params[i]
							UnionWallPhotoNew.Ins():GetOriginImage_ScenicSpot(
								role_id,
								scenic_spot_id,
								param.timestamp,
								param.progressCallback,
								param.successCallback,
								param.errorCallback,
								param.isKeepPreviousCallback,
								param.isThroughPersonalphotocallback,
								PhotoFileInfo.Extension
							)
						end
					end
					self.tabCachedParamsO[photoID] = nil
				end,
				function ()
					self.tabIsCheckingExistO[photoID] = nil
					if self.tabStopFlagO[photoID] == nil then
						local params = self.tabCachedParamsO[photoID]
						for i = 1, #params do
							local param = params[i]
							UnionWallPhotoNew.Ins():GetOriginImage_ScenicSpot(
								role_id,
								scenic_spot_id,
								param.timestamp,
								param.progressCallback,
								param.successCallback,
								param.errorCallback,
								param.isKeepPreviousCallback,
								param.isThroughPersonalphotocallback,
								PhotoFileInfo.OldExtension
							)
						end
					end
					self.tabCachedParamsO[photoID] = nil
				end,
				PhotoFileInfo.Extension
			)
			self.tabIsCheckingExistO[photoID] = 0
		end
	end
end

function UnionWallPhotoHelper:StopGetOriginImage_ScenicSpot(role_id, scenic_spot_id)
	local photoID = UnionWallPhotoNew.Ins():GetPhotoID(role_id, scenic_spot_id, 's')
	if self.tabIsCheckingExistO[photoID] ~= nil then
		self.tabStopFlagO[photoID] = 0
	end
	UnionWallPhotoNew.Ins():StopGetOriginImage_ScenicSpot(role_id, scenic_spot_id)
end

function UnionWallPhotoHelper:GetThumbnail_ScenicSpot(role_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
	print(string.format('UnionWallPhotoHelper:GetThumbnail_ScenicSpot\nrole_id=%s\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(role_id), tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback)))
	local photoID = UnionWallPhotoNew.Ins():GetPhotoID(role_id, scenic_spot_id, 's')
	self.tabStopFlagT[photoID] = nil
	local isLatestLocal = false
	local localTimestamp = LocalUnionWallPhoto.Ins():GetTimestamp(photoID, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		UnionWallPhotoNew.Ins():GetThumbnail_ScenicSpot(
			role_id,
			scenic_spot_id,
			timestamp,
			progress_callback,
			success_callback,
			error_callback,
			is_keep_previous_callback
		)
	else
		if self.tabCachedParamsT[photoID] == nil then
			self.tabCachedParamsT[photoID] = {}
		end
		table.insert(
			self.tabCachedParamsT[photoID],
			{
				timestamp = timestamp,
				progressCallback = progress_callback,
				successCallback = success_callback,
				errorCallback = error_callback,
				isKeepPreviousCallback = is_keep_previous_callback
			}
		)

		if self.tabIsCheckingExistT[photoID] == nil then
			NetIngUnionWallPhoto_ScenicSpot.Ins():CheckExist(
				role_id,
				scenic_spot_id,
				function ()
					self.tabIsCheckingExistT[photoID] = nil
					if self.tabStopFlagT[photoID] == nil then
						local params = self.tabCachedParamsT[photoID]
						for i = 1, #params do
							local param = params[i]
							UnionWallPhotoNew.Ins():GetThumbnail_ScenicSpot(
								role_id,
								scenic_spot_id,
								param.timestamp,
								param.progressCallback,
								param.successCallback,
								param.errorCallback,
								param.isKeepPreviousCallback,
								PhotoFileInfo.Extension
							)
						end
					end
					self.tabCachedParamsT[photoID] = nil
				end,
				function ()
					self.tabIsCheckingExistT[photoID] = nil
					if self.tabStopFlagT[photoID] == nil then
						local params = self.tabCachedParamsT[photoID]
						for i = 1, #params do
							local param = params[i]
							UnionWallPhotoNew.Ins():GetThumbnail_ScenicSpot(
								role_id,
								scenic_spot_id,
								param.timestamp,
								param.progressCallback,
								param.successCallback,
								param.errorCallback,
								param.isKeepPreviousCallback,
								PhotoFileInfo.OldExtension
							)
						end
					end
					self.tabCachedParamsT[photoID] = nil
				end,
				PhotoFileInfo.Extension
			)
			self.tabIsCheckingExistT[photoID] = 0
		end
	end
end

function UnionWallPhotoHelper:StopGetThumbnail_ScenicSpot(role_id, scenic_spot_id)
	local photoID = UnionWallPhotoNew.Ins():GetPhotoID(role_id, scenic_spot_id, 's')
	if self.tabIsCheckingExistT[photoID] ~= nil then
		self.tabStopFlagT[photoID] = 0
	end
	UnionWallPhotoNew.Ins():StopGetThumbnail_ScenicSpot(role_id, scenic_spot_id)
end

function UnionWallPhotoHelper:GetOriginImage_ScenicSpot_Account(account_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_unionwallphotocallback)
	UnionWallPhotoNew.Ins():GetOriginImage_ScenicSpot_Account(account_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_unionwallphotocallback)
end

function UnionWallPhotoHelper:GetThumbnail_ScenicSpot_Account(account_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
	UnionWallPhotoNew.Ins():GetThumbnail_ScenicSpot_Account(account_id, scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
end