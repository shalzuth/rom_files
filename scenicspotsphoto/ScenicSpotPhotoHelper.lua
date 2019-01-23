autoImport('ScenicSpotPhoto')
autoImport('LocalScenicSpotPhoto')
autoImport('PhotoFileInfo')
autoImport('NetIngScenicSpotPhoto')

ScenicSpotPhotoHelper = class('ScenicSpotPhotoHelper')

function ScenicSpotPhotoHelper:Ins()
	if ScenicSpotPhotoHelper.ins == nil then
		ScenicSpotPhotoHelper.ins = ScenicSpotPhotoHelper.new()
	end
	return ScenicSpotPhotoHelper.ins
end

function ScenicSpotPhotoHelper:Initialize()
	self.tabIsCheckingExistO = {}
	self.tabIsCheckingExistT = {}
	self.tabCachedParamsO = {}
	self.tabCachedParamsT = {}
	self.tabStopFlagO = {}
	self.tabStopFlagT = {}
end

function ScenicSpotPhotoHelper:GetOriginImage(scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback, is_through_scenicspotphotocallback)
	print(string.format('ScenicSpotPhotoHelper:GetOriginImage\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback)))
	self.tabStopFlagO[scenic_spot_id] = nil
	local isLatestLocal = false
	local localTimestamp = LocalScenicSpotPhoto.Ins():GetTimestamp(scenic_spot_id, true)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		ScenicSpotPhoto.Ins():GetOriginImage(
			scenic_spot_id,
			timestamp,
			progress_callback,
			success_callback,
			error_callback,
			is_keep_previous_callback,
			is_through_scenicspotphotocallback
		)
	else
		if self.tabCachedParamsO[scenic_spot_id] == nil then
			self.tabCachedParamsO[scenic_spot_id] = {}
		end
		table.insert(
			self.tabCachedParamsO[scenic_spot_id],
			{
				timestamp = timestamp,
				progressCallback = progress_callback,
				successCallback = success_callback,
				errorCallback = error_callback,
				isKeepPreviousCallback = is_keep_previous_callback,
				isThroughPersonalphotocallback = is_through_personalphotocallback
			}
		)

		if self.tabIsCheckingExistO[scenic_spot_id] == nil then
			NetIngScenicSpotPhoto.Ins():CheckExist(
				Game.Myself.data.id,
				scenic_spot_id,
				function ()
					self.tabIsCheckingExistO[scenic_spot_id] = nil
					if self.tabStopFlagO[scenic_spot_id] == nil then
						local params = self.tabCachedParamsO[scenic_spot_id]
						for i = 1, #params do
							local param = params[i]
							ScenicSpotPhoto.Ins():GetOriginImage(
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
					self.tabCachedParamsO[scenic_spot_id] = nil
				end,
				function ()
					self.tabIsCheckingExistO[scenic_spot_id] = nil
					if self.tabStopFlagO[scenic_spot_id] == nil then
						local params = self.tabCachedParamsO[scenic_spot_id]
						for i = 1, #params do
							local param = params[i]
							ScenicSpotPhoto.Ins():GetOriginImage(
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
					self.tabCachedParamsO[scenic_spot_id] = nil
				end,
				PhotoFileInfo.Extension
			)
			self.tabIsCheckingExistO[scenic_spot_id] = 0
		end
	end
end

function ScenicSpotPhotoHelper:StopGetOriginImage(scenic_spot_id)
	if self.tabIsCheckingExistO[scenic_spot_id] ~= nil then
		self.tabStopFlagO[scenic_spot_id] = 0
	end
	ScenicSpotPhoto.Ins():StopGetOriginImage(scenic_spot_id)
end

function ScenicSpotPhotoHelper:GetThumbnail(scenic_spot_id, timestamp, progress_callback, success_callback, error_callback, is_keep_previous_callback)
	print(string.format('ScenicSpotPhotoHelper:GetThumbnail\nscenic_spot_id=%s\ntimestamp=%s\nis_keep_previous_callback=%s', tostring(scenic_spot_id), tostring(timestamp), tostring(is_keep_previous_callback)))
	self.tabStopFlagT[scenic_spot_id] = nil
	local isLatestLocal = false
	local localTimestamp = LocalScenicSpotPhoto.Ins():GetTimestamp(scenic_spot_id, false)
	if localTimestamp ~= nil then
		isLatestLocal = localTimestamp >= timestamp
	else
		isLatestLocal = false
	end
	if isLatestLocal then
		ScenicSpotPhoto.Ins():GetThumbnail(
			scenic_spot_id,
			timestamp,
			progress_callback,
			success_callback,
			error_callback,
			is_keep_previous_callback
		)
	else
		if self.tabCachedParamsT[scenic_spot_id] == nil then
			self.tabCachedParamsT[scenic_spot_id] = {}
		end
		table.insert(
			self.tabCachedParamsT[scenic_spot_id],
			{
				timestamp = timestamp,
				progressCallback = progress_callback,
				successCallback = success_callback,
				errorCallback = error_callback,
				isKeepPreviousCallback = is_keep_previous_callback
			}
		)

		if self.tabIsCheckingExistT[scenic_spot_id] == nil then
			NetIngScenicSpotPhoto.Ins():CheckExist(
				Game.Myself.data.id,
				scenic_spot_id,
				function ()
					self.tabIsCheckingExistT[scenic_spot_id] = nil
					if self.tabStopFlagT[scenic_spot_id] == nil then
						local params = self.tabCachedParamsT[scenic_spot_id]
						for i = 1, #params do
							local param = params[i]
							ScenicSpotPhoto.Ins():GetThumbnail(
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
					self.tabCachedParamsT[scenic_spot_id] = nil
				end,
				function ()
					self.tabIsCheckingExistT[scenic_spot_id] = nil
					if self.tabStopFlagT[scenic_spot_id] == nil then
						local params = self.tabCachedParamsT[scenic_spot_id]
						for i = 1, #params do
							local param = params[i]
							ScenicSpotPhoto.Ins():GetThumbnail(
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
					self.tabCachedParamsT[scenic_spot_id] = nil
				end,
				PhotoFileInfo.Extension
			)
			self.tabIsCheckingExistT[scenic_spot_id] = 0
		end
	end
end

function ScenicSpotPhotoHelper:StopGetThumbnail(scenic_spot_id)
	if self.tabIsCheckingExistT[scenic_spot_id] ~= nil then
		self.tabStopFlagT[scenic_spot_id] = 0
	end
	ScenicSpotPhoto.Ins():StopGetThumbnail(scenic_spot_id)
end