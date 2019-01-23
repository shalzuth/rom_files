IOPathConfig = autoImport("IOPathConfig")

BeautifulAreaPhotoNetIngManager = class("BeautifulAreaPhotoNetIngManager")
local ThumbnailTail = "!200"
local extension = "png"

function BeautifulAreaPhotoNetIngManager.Ins()
	if BeautifulAreaPhotoNetIngManager.ins == null then
		BeautifulAreaPhotoNetIngManager.ins = BeautifulAreaPhotoNetIngManager.new()
	end
	return BeautifulAreaPhotoNetIngManager.ins
end

function BeautifulAreaPhotoNetIngManager:Initialize()
	self.downloadTasks = {}
	self.uploadTasks = {}
	self.waitingSignatureUpload = {}
	self.waitingServerPathDownload = {}
	-- EventManager.Me():AddEventListener(LoadSceneEvent.BeginLoadScene, self.OnSwitchOn, self)
	-- EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSwitchOff, self)
	self.m_switch = true

	EventManager.Me():AddEventListener(ServiceEvent.NUserUploadSceneryPhotoUserCmd, self.OnRequestSignatureAndPolicyComp, self)
	EventManager.Me():AddEventListener(ServiceEvent.NUserDownloadSceneryPhotoUserCmd, self.OnRequestServerPathComp, self)
end

function BeautifulAreaPhotoNetIngManager:NetIsValid(action)
	InternetUtil.Ins:WIFIIsValid(action, 5)
end

function BeautifulAreaPhotoNetIngManager:OnSwitchOn()
	self.m_switch = true
end

function BeautifulAreaPhotoNetIngManager:OnSwitchOff()
	self.m_switch = true
end

function BeautifulAreaPhotoNetIngManager:Download(ba_id, is_origin, local_path, on_start, on_progress, on_complete, on_error)
	if self.serverPath == nil then
		if not self.isRequestingServerPath then
			ServiceNUserProxy.Instance:CallDownloadSceneryPhotoUserCmd()
			self.isRequestingServerPath = true
		end
		table.insert(self.waitingServerPathDownload, {baID = ba_id, isOrigin = is_origin, localPath = local_path, onStart = on_start, onProgress = on_progress, onComplete = on_complete, onError = on_error})
	else
		self:NetIsValid(function (x)
			if x and self.m_switch then
				local serverPath = self.serverPath .. ba_id .. '.' .. extension
				if not is_origin then
					serverPath = serverPath .. ThumbnailTail
				end
				local id = self:DoDownload(serverPath, local_path, on_start, on_progress, on_complete, on_error)
				table.insert(self.downloadTasks, {id = id, localPath = local_path})
			end
		end)
	end
end

function BeautifulAreaPhotoNetIngManager:DoDownload(server_path, local_path, on_start, on_progress, on_complete, on_error)
	local id = UpYunNetIngFileTaskManager.Ins:Download(server_path, local_path, function ()
		if on_start ~= nil then
			on_start()
		end
	end, function (progress)
		if on_progress ~= nil then
			on_progress(progress)
		end
	end, function ()
		self:_RemoveDownloadTask(local_path)

		if on_complete ~= nil then
			on_complete()
		end
	end, function (error_type, error_code, error_message)
		if on_error ~= nil then
			on_error(error_type, error_code, error_message)
		end
	end)
	return id
end

function BeautifulAreaPhotoNetIngManager:Upload(ba_id, local_path, on_start, on_progress, on_complete, on_error)
	-- request signature and policy
	local absolutePath = FileDirectoryHandler.GetAbsolutePath(local_path)
	local fileMD5 = MyMD5.HashFile(absolutePath)
	local myFile = MyFileFactory.Ins:GetMyFile(absolutePath)
	local blockCount = myFile.BlockCount
	local fileSize = myFile.Size
	ServiceNUserProxy.Instance:CallUploadSceneryPhotoUserCmd(fileMD5, ba_id, nil, nil, blockCount, fileMD5, fileSize)

	-- put into waiting signature collection
	table.insert(self.waitingSignatureUpload, {baID = ba_id, localPath = local_path, onStart = on_start, onProgress = on_progress, onComplete = on_complete, onError = on_error})
end

function BeautifulAreaPhotoNetIngManager:DoUpload(local_path, signature, policy, on_start, on_progress, on_complete, on_error)
	local id = UpYunNetIngFileTaskManager.Ins:Upload(local_path, signature, policy, function ()
		if on_start ~= nil then
			on_start()
		end
	end, function (progress)
		if on_progress ~= nil then
			on_progress(progress)
		end
	end, function ()
		self:_RemoveUploadTask(local_path)
		if on_complete ~= nil then
			on_complete()
		end
	end, function (error_type, error_code, error_message)
		if on_error ~= nil then
			on_error(error_type, error_code, error_message)
		end
	end)
	return id
end

function BeautifulAreaPhotoNetIngManager:OnRequestSignatureAndPolicyComp(data)
	if data == nil then return end
	local baID = data.sceneryid
	local params = nil
	for i = 1, #self.waitingSignatureUpload do
		local item = self.waitingSignatureUpload[i]
		if item.baID == baID then
			params = item
			table.remove(self.waitingSignatureUpload, i)
			break
		end
	end
	if params ~= nil then
		--self:RemoveUploadTask(params.localPath)
		self:NetIsValid(function (x)
			if x and self.m_switch then
				local id = self:DoUpload(params.localPath, data.signature, data.policy, params.onStart, params.onProgress, params.onComplete, params.onError)
				table.insert(self.uploadTasks, {id = id, localPath = params.localPath})
			end
		end)
	end
end

function BeautifulAreaPhotoNetIngManager:OnRequestServerPathComp(data)
	if data == nil then return end
	self.serverPath = data.url

	self:NetIsValid(function (x)
		if x and self.m_switch then
			for i = #self.waitingServerPathDownload, 1, -1 do
				local item = self.waitingServerPathDownload[i]
				local serverPath = self.serverPath .. item.baID .. '.' .. extension
				if not item.isOrigin then
					serverPath = serverPath .. ThumbnailTail
				end
				local id = self:DoDownload(serverPath, item.localPath, item.onStart, item.onProgress, item.onComplete, item.onError)
				table.insert(self.downloadTasks, {id = id, localPath = item.localPath})
				table.remove(self.waitingServerPathDownload, i)
			end
		end
	end)
end

function BeautifulAreaPhotoNetIngManager:_RemoveUploadTask(local_path)
	for i = 1, #self.uploadTasks do
		local uploadTask = self.uploadTasks[i]
		if uploadTask.localPath == local_path then
			table.remove(self.uploadTasks, i)
			break
		end
	end
end

function BeautifulAreaPhotoNetIngManager:_RemoveDownloadTask(local_path)
	for i = 1, #self.downloadTasks do
		local downloadTask = self.downloadTasks[i]
		if downloadTask.localPath == local_path then
			table.remove(self.downloadTasks, i)
			break
		end
	end
end

function BeautifulAreaPhotoNetIngManager:RemoveUploadTask(local_path)
	for i = #self.uploadTasks, 1, -1 do
		local uploadTask = self.uploadTasks[i]
		if uploadTask.localPath == local_path then
			UpYunNetIngFileTaskManager.Ins:RemoveBlocksUploadTaskFromID(uploadTask.id)
			table.remove(self.uploadTasks, i)
		end
	end
end

function BeautifulAreaPhotoNetIngManager:RemoveWaitingUploadTask(local_path)
	for i = #self.waitingSignatureUpload, 1, -1 do
		local uploadTask = self.waitingSignatureUpload[i]
		if uploadTask.localPath == local_path then
			table.remove(self.waitingSignatureUpload, i)
		end
	end
end

function BeautifulAreaPhotoNetIngManager:RemoveDownloadTask(local_path)
	for i = #self.downloadTasks, 1, -1 do
		local downloadTask = self.downloadTasks[i]
		if downloadTask.localPath == local_path then
			UpYunNetIngFileTaskManager.Ins:RemoveDownloadTaskFromID(downloadTask.id)
			table.remove(self.downloadTasks, i)
		end
	end
end

function BeautifulAreaPhotoNetIngManager:RemoveWaitingDownloadTask(local_path)
	for i = #self.waitingServerPathDownload, 1, -1 do
		local downloadTask = self.waitingServerPathDownload[i]
		if downloadTask.localPath == local_path then
			table.remove(self.waitingServerPathDownload, i)
		end
	end
end

function BeautifulAreaPhotoNetIngManager:IsDownloading(local_path)
	for i = 1, #self.downloadTasks do
		local downloadTask = self.downloadTasks[i]
		if downloadTask.localPath == local_path then
			local downloadTaskInfo = UpYunNetIngFileTaskManager.Ins:GetDownloadTaskInfoFromID(downloadTask.id)
			if downloadTaskInfo and (downloadTaskInfo.state == 1 or downloadTaskInfo.state == 5) then
				return true
			end
		end
	end
	return false
end