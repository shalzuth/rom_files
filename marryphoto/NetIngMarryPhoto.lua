autoImport('GamePhoto')

NetIngMarryPhoto = class('NetIngMarryPhoto')

local gCachedDownloadTaskRecordID = {}
local gCachedUploadTaskRecordID = {}

function NetIngMarryPhoto.Ins()
	if NetIngMarryPhoto.ins == nil then
		NetIngMarryPhoto.ins = NetIngMarryPhoto.new()
	end
	return NetIngMarryPhoto.ins
end

function NetIngMarryPhoto:Initialize()
--	EventManager.Me():AddEventListener(ServiceEvent.NUserUploadSceneryPhotoUserCmd, self.OnReceiveUploadSceneryPhotoUserCmd, self)
	-- todo xde change upload
	EventManager.Me():AddEventListener(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, self.OnRecvOverseasPhotoUploadCmd, self)
	self.stopFormUploadFlag = {}
end

function NetIngMarryPhoto:Download(marry_id, pos_index, photo_id, timestamp, progress_callback, success_callback, error_callback, o_or_t)
	print(string.format('NetIngMarryPhoto:Download\npos_index=%s', tostring(pos_index)))
	local tempDownloadRootPath = Application.persistentDataPath .. '/' .. self:GetTempDownloadRootPathOfLocal()
	if not FileHelper.ExistDirectory(tempDownloadRootPath) then
		FileHelper.CreateDirectory(tempDownloadRootPath)
	end

	local path = Application.persistentDataPath .. '/' .. self:GetTempDownloadPathOfLocal(photo_id, o_or_t)
	local key = photo_id .. '_' .. (o_or_t and 'o' or 't')
	if table.ContainsKey(gCachedDownloadTaskRecordID, key) then
		local taskRecordID = gCachedDownloadTaskRecordID[key]
		if self:IsDownloading(photo_id, o_or_t) then
			CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
		else
			if FileHelper.ExistFile(path) then
				FileHelper.DeleteFile(path)
			end
			-- todo xde change download
			ServiceOverseasTaiwanCmdProxy.Instance:GetDownLoadPath(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_WEDDING,function(data)
				local newURL = XDCDNInfo.GetFileServerURL() .. '/' .. data.path .. '/' .. self:GetPathOfServer(marry_id, pos_index)
				newURL = o_or_t and newURL or newURL .. '!33'
				newURL = newURL .. '?timestamp='..timestamp
				helplog("download newURL scene " .. newURL)
				local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
				taskRecord.URL = newURL
				CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
				CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
				CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
			end)
--			local fileServerURL = XDCDNInfo.GetFileServerURL()
--			local newURL = fileServerURL .. '/' .. self:GetPathOfServer(marry_id, pos_index) .. (o_or_t and '' or '!100') .. '?t=' .. timestamp
--			local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
--			taskRecord.URL = newURL
--			CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
--			CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
--			CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
		end
	else
		if FileHelper.ExistFile(path) then
			FileHelper.DeleteFile(path)
		end

		--todo xde change download
		ServiceOverseasTaiwanCmdProxy.Instance:GetDownLoadPath(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_WEDDING,function(data)
			local url = XDCDNInfo.GetFileServerURL() .. '/' .. data.path .. '/' .. self:GetPathOfServer(marry_id, pos_index)
			url = o_or_t and url or url .. '!33'
			url = url .. '?timestamp='..timestamp
			helplog("download newURL scene " .. url)
			local taskRecordID = nil
			if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
				taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback ,success_callback, error_callback, nil)
			else
				taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback ,success_callback, error_callback)
			end
			if taskRecordID > 0 then
				gCachedDownloadTaskRecordID[key] = taskRecordID
			end
		end)
	
--		local fileServerURL = XDCDNInfo.GetFileServerURL()
--		local url = fileServerURL .. '/' .. self:GetPathOfServer(marry_id, pos_index) .. (o_or_t and '' or '!100') .. '?t=' .. timestamp
--		local taskRecordID = nil
--		if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
--			taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback ,success_callback, error_callback, nil)
--		else
--			taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback ,success_callback, error_callback)
--		end
--		if taskRecordID > 0 then
--			gCachedDownloadTaskRecordID[key] = taskRecordID
--		end
	end
end

function NetIngMarryPhoto:IsDownloading(photo_id, o_or_t)
	local key = photo_id .. '_' ..  (o_or_t and 'o' or 't')
	local taskRecordID = gCachedDownloadTaskRecordID[key]
	if taskRecordID ~= nil then
		local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
		return taskRecord.State == CloudFile.E_TaskState.None or taskRecord.State == CloudFile.E_TaskState.Progress
	end
	return false
end

function NetIngMarryPhoto:StopDownload(photo_id, o_or_t)
	local key = photo_id .. '_' .. (o_or_t and 'o' or 't')
	local taskRecordID = gCachedDownloadTaskRecordID[key]
	if taskRecordID ~= nil then
		CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
	end
end

local operatorName = GamePhoto.upyunOperatorName
local formUploadCallbacks = {}
function NetIngMarryPhoto:FormUpload(pos_index, photo_id, progress_callback, success_callback, error_callback)
	formUploadCallbacks[pos_index] = {photoID = photo_id, progressCallback = progress_callback, successCallback = success_callback, errorCallback = error_callback}
--	ServiceNUserProxy.Instance:CallUploadSceneryPhotoUserCmd(SceneUser2_pb.EALBUMTYPE_WEDDING, pos_index)
	-- todo xde 结婚照上传
	ServiceOverseasTaiwanCmdProxy.Instance:GetUpLoadSign(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_WEDDING,pos_index)
	self.stopFormUploadFlag[photo_id] = false
end

--todo xde change upload
function NetIngMarryPhoto:OnRecvOverseasPhotoUploadCmd(message)

	local signDataObj = {}
	for i = 1, #message.fields do
		local d = message.fields[i]
		signDataObj[d.name] = d.value
	end
	local signObj =  OverSeas_TW.GoogleStorageSignObj.insObg(
		signDataObj["content-type"],
		signDataObj["bucket"],
		signDataObj["acl"],
		signDataObj["key"],
		signDataObj['GoogleAccessId'],
		signDataObj['policy'],
		signDataObj['signature'],
		signDataObj['success_action_status']
	)

	local eType = message.type;
	if eType == 4 then
		local posIndex = message.photoId
		local photoID = formUploadCallbacks[posIndex].photoID
		if not self.stopFormUploadFlag[photoID] then
			self:OverseaDoFormUpload(
				photoID,
				signObj,
				signDataObj['key'],
				formUploadCallbacks[posIndex].progressCallback,
				formUploadCallbacks[posIndex].successCallback,
				formUploadCallbacks[posIndex].errorCallback
			)
		end
		formUploadCallbacks[posIndex] = nil
	end
end

-- todo xde
function NetIngMarryPhoto:OverseaDoFormUpload(photo_id, signObj,keypath, progress_callback, success_callback, error_callback)
		if table.ContainsKey(gCachedUploadTaskRecordID, photo_id) then
			local taskRecordID = gCachedUploadTaskRecordID[photo_id]
			local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
			if taskRecord.State == CloudFile.E_TaskState.Progress then
				CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
			end
			CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
			CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
			CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
		else
			local path = Application.persistentDataPath .. '/' .. self:GetTempUploadPathOfLocal(photo_id)
			local url = GoogleStorageConfig.googleStorageUpLoad
			helplog("upload marry :".. url ..keypath)
			local taskRecordID = CloudFile.CloudFileManager.Ins:NormalUploadGoogleStorage(path, url, signObj, progress_callback, success_callback, error_callback, nil)
			if taskRecordID > 0 then
				gCachedUploadTaskRecordID[photo_id] = taskRecordID
			end
		end
end

function NetIngMarryPhoto:OnReceiveUploadSceneryPhotoUserCmd(message)
	print('NetIngMarryPhoto:OnReceiveUploadSceneryPhotoUserCmd')
	local eType = message.type
	if eType == SceneUser2_pb.EALBUMTYPE_WEDDING then
		local posIndex = message.sceneryid
		local photoID = formUploadCallbacks[posIndex].photoID
		if not self.stopFormUploadFlag[photoID] then
			local policy = message.policy
			local signature = message.signature
			local authorization = "UPYUN " .. operatorName .. ":" .. signature;
			self:DoFormUpload(
				photoID,
				policy,
				authorization,
				formUploadCallbacks[posIndex].progressCallback,
				formUploadCallbacks[posIndex].successCallback,
				formUploadCallbacks[posIndex].errorCallback
			)
		end
		formUploadCallbacks[posIndex] = nil
	end
end

function NetIngMarryPhoto:DoFormUpload(photo_id, policy, authorization, progress_callback, success_callback, error_callback)
	if table.ContainsKey(gCachedUploadTaskRecordID, photo_id) then
		local taskRecordID = gCachedUploadTaskRecordID[photo_id]
		local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
		if taskRecord.State == CloudFile.E_TaskState.Progress then
			CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
		end
		CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
		CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
		CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
	else
		local path = Application.persistentDataPath .. '/' .. self:GetTempUploadPathOfLocal(photo_id)
		local url = UpyunInfo.GetFormUploadURL()
		local taskRecordID = CloudFile.CloudFileManager.Ins:FormUpload(path, url, policy, authorization, progress_callback, success_callback, error_callback, nil)
		if taskRecordID > 0 then
			gCachedUploadTaskRecordID[photo_id] = taskRecordID
		end
	end
end

function NetIngMarryPhoto:StopFormUpload(photo_id)
	self.stopFormUploadFlag[photo_id] = true
	local taskRecordID = gCachedUploadTaskRecordID[photo_id]
	if taskRecordID ~= nil then
		CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
	end
end

function NetIngMarryPhoto:SetUserPathOfServer(user_path)
	self.userPathOfServer = user_path
end

function NetIngMarryPhoto:GetPathOfServer(marry_id, pos_index)
	--todo xde 
	--	return self:GetPathOfServerWithRoleID(Game.Myself.data.id, marry_id, pos_index)
	return  marry_id .. '/' .. pos_index .. '.' .. PhotoFileInfo.Extension
end

function NetIngMarryPhoto:GetPathOfServerWithRoleID(role_id, marry_id, pos_index)
	return self.userPathOfServer .. '/' .. role_id .. '/' .. marry_id .. '/' .. pos_index .. '.' .. PhotoFileInfo.Extension
end

function NetIngMarryPhoto:GetTempDownloadRootPathOfLocal()
	return 'TempUsedToDownloadMarryPhoto'
end

function NetIngMarryPhoto:GetTempDownloadPathOfLocal(photo_id, o_or_t)
	return self:GetTempDownloadRootPathOfLocal() .. '/' .. photo_id .. '_' .. (o_or_t and 'o' or 't') .. '.' .. PhotoFileInfo.Extension
end

function NetIngMarryPhoto:GetTempUploadRootPathOfLocal()
	return 'TempUsedToUploadMarryPhoto'
end

function NetIngMarryPhoto:GetTempUploadPathOfLocal(photo_id)
	return self:GetTempUploadRootPathOfLocal() .. '/' .. photo_id .. '.' .. PhotoFileInfo.Extension
end