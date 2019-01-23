autoImport('PersonalPhoto')
autoImport('PhotoFileInfo')
autoImport('LocalPersonalPhoto')
autoImport('NetIngPersonalPhoto')

PersonalPhotoHelper = class('PersonalPhotoHelper')

function PersonalPhotoHelper.Ins()
	if PersonalPhotoHelper.ins == nil then
		PersonalPhotoHelper.ins = PersonalPhotoHelper.new()
	end
	return PersonalPhotoHelper.ins
end

function PersonalPhotoHelper:Initialize()
	self.tabIsCheckingExistO = {}
	self.tabIsCheckingExistT = {}
	self.tabCachedParamsO = {}
	self.tabCachedParamsT = {}
	self.tabStopFlagO = {}
	self.tabStopFlagT = {}
end

function PersonalPhotoHelper:GetOriginImage(pos_index, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_personalphotocallback)
	print(string.format('PersonalPhotoHelper:GetOriginImage\npos_index=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(pos_index), tostring(timestamp), tostring(is_keep_previous_callback)))
	self.tabStopFlagO[pos_index] = nil
	local isLatestLocal = false
	local photoID = PersonalPhoto.Ins():GetPhotoID(Game.Myself.data.id, pos_index)
	local localTimestamp = LocalPersonalPhoto.Ins():GetTimestamp(photoID, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		PersonalPhoto.Ins():GetOriginImage(
			pos_index,
			timestamp,
			progress_callback,
			success_callback,
			error_callback,
			is_keep_previous_callback,
			is_through_personalphotocallback
		)
	else
		if self.tabCachedParamsO[pos_index] == nil then
			self.tabCachedParamsO[pos_index] = {}
		end
		table.insert(
			self.tabCachedParamsO[pos_index],
			{
				timestamp = timestamp,
				progressCallback = progress_callback,
				successCallback = success_callback,
				errorCallback = error_callback,
				isKeepPreviousCallback = is_keep_previous_callback,
				isThroughPersonalphotocallback = is_through_personalphotocallback
			}
		)
		
		if self.tabIsCheckingExistO[pos_index] == nil then
			NetIngPersonalPhoto.Ins():CheckExist(
				Game.Myself.data.id,
				pos_index,
				function ()
					self.tabIsCheckingExistO[pos_index] = nil
					if self.tabStopFlagO[pos_index] == nil then
						local params = self.tabCachedParamsO[pos_index]
						for i = 1, #params do
							local param = params[i]
							PersonalPhoto.Ins():GetOriginImage(
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
					self.tabCachedParamsO[pos_index] = nil
				end,
				function ()
					self.tabIsCheckingExistO[pos_index] = nil
					if self.tabStopFlagO[pos_index] == nil then
						local params = self.tabCachedParamsO[pos_index]
						for i = 1, #params do
							local param = params[i]
							PersonalPhoto.Ins():GetOriginImage(
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
					self.tabCachedParamsO[pos_index] = nil
				end,
				PhotoFileInfo.Extension
			)
			self.tabIsCheckingExistO[pos_index] = 0
		end
	end
end

function PersonalPhotoHelper:StopGetOriginImage(pos_index)
	if self.tabIsCheckingExistO[pos_index] ~= nil then
		self.tabStopFlagO[pos_index] = 0
	end
	PersonalPhoto.Ins():StopGetOriginImage(pos_index)
end

function PersonalPhotoHelper:GetThumbnail(pos_index, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
	print(string.format('PersonalPhotoHelper:GetThumbnail\npos_index=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(pos_index), tostring(timestamp), tostring(is_keep_previous_callback)))
	self.tabStopFlagT[pos_index] = nil
	local isLatestLocal = false
	local photoID = PersonalPhoto.Ins():GetPhotoID(Game.Myself.data.id, pos_index)
	local localTimestamp = LocalPersonalPhoto.Ins():GetTimestamp(photoID, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		PersonalPhoto.Ins():GetThumbnail(
			pos_index,
			timestamp,
			progress_callback,
			success_callback,
			error_callback,
			is_keep_previous_callback
		)
	else
		if self.tabCachedParamsT[pos_index] == nil then
			self.tabCachedParamsT[pos_index] = {}
		end
		table.insert(
			self.tabCachedParamsT[pos_index],
			{
				timestamp = timestamp,
				progressCallback = progress_callback,
				successCallback = success_callback,
				errorCallback = error_callback,
				isKeepPreviousCallback = is_keep_previous_callback
			}
		)

		if self.tabIsCheckingExistT[pos_index] == nil then
			NetIngPersonalPhoto.Ins():CheckExist(
				Game.Myself.data.id,
				pos_index,
				function ()
					self.tabIsCheckingExistT[pos_index] = nil
					if self.tabStopFlagT[pos_index] == nil then
						local params = self.tabCachedParamsT[pos_index]
						for i = 1, #params do
							local param = params[i]
							PersonalPhoto.Ins():GetThumbnail(
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
					self.tabCachedParamsT[pos_index] = nil
				end,
				function ()
					self.tabIsCheckingExistT[pos_index] = nil
					if self.tabStopFlagT[pos_index] == nil then
						local params = self.tabCachedParamsT[pos_index]
						for i = 1, #params do
							local param = params[i]
							PersonalPhoto.Ins():GetThumbnail(
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
					self.tabCachedParamsT[pos_index] = nil
				end,
				PhotoFileInfo.Extension
			)
			self.tabIsCheckingExistT[pos_index] = 0
		end
	end
end

function PersonalPhotoHelper:StopGetThumbnail(pos_index)
	if self.tabIsCheckingExistT[pos_index] ~= nil then
		self.tabStopFlagT[pos_index] = 0
	end
	PersonalPhoto.Ins():StopGetThumbnail(pos_index)
end