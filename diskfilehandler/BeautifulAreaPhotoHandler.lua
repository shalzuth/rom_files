autoImport("BeautifulAreaPhotoNetIngManager")
local IOPathConfig = autoImport("IOPathConfig")

BeautifulAreaPhotoHandler = class("BeautifulAreaPhotoHandler")

function BeautifulAreaPhotoHandler.Ins()
	if BeautifulAreaPhotoHandler.ins == null then
		BeautifulAreaPhotoHandler.ins = BeautifulAreaPhotoHandler.new()
	end
	return BeautifulAreaPhotoHandler.ins
end

function BeautifulAreaPhotoHandler:Initialize()
	self.directoryPath = IOPathConfig.Paths.USER.ScenicSpotPhoto
	self.thumbnailDirectoryPath = IOPathConfig.Paths.USER.ScenicSpotPreview
	self.extension = "png"
	self:ListenEvent()
end

function BeautifulAreaPhotoHandler:Reset()
	self:CancelListenEvent()
end

function BeautifulAreaPhotoHandler:ListenEvent()
	-- EventManager.Me():AddEventListener(AdventureDataEvent.SceneManualManualInit, self.OnReceiveEventAdventureData, self)
end

function BeautifulAreaPhotoHandler:CancelListenEvent()
	-- EventManager.Me():RemoveEventListener(AdventureDataEvent.SceneManualManualInit, self.OnReceiveEventAdventureData, self)
end

function BeautifulAreaPhotoHandler:Save(ba_id, bytes, on_complete)
	local localPath = self:GetLocalPath(ba_id)
	local thumbnailPath = self:GetThumbnailLocalPath(ba_id)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveDownloadTask(localPath)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveWaitingDownloadTask(localPath)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveDownloadTask(thumbnailPath)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveWaitingDownloadTask(thumbnailPath)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveUploadTask(localPath)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveWaitingUploadTask(localPath)
	self:DoSave(ba_id, bytes, function (x)
		if x then
			self:DeleteThumbnailFromLocal(ba_id)
		end
		if on_complete ~= nil then
			on_complete(x)
		end
	end)
end

function BeautifulAreaPhotoHandler:SaveForHistory(ba_id, bytes)
	local localPath = self:GetLocalPath(ba_id)
	local thumbnailPath = self:GetThumbnailLocalPath(ba_id)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveDownloadTask(localPath)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveWaitingDownloadTask(localPath)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveDownloadTask(thumbnailPath)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveWaitingDownloadTask(thumbnailPath)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveUploadTask(localPath)
	BeautifulAreaPhotoNetIngManager.Ins():RemoveWaitingUploadTask(localPath)
	local b = self:DoSaveForHistory(ba_id, bytes)
	return b
end

function BeautifulAreaPhotoHandler:BuildAndSaveThumbnail(ba_id, tex2D)
	if ba_id and ba_id > 0 then
		if tex2D then
			local cloneTex2D = Object.Instantiate(tex2D)
			local newWidth = cloneTex2D.width / 4
			local newHeight = cloneTex2D.height / 4
			TextureScale.Bilinear(cloneTex2D, newWidth, newHeight)
			local bytes = ImageConversion.EncodeToPNG(cloneTex2D)
			local localPath = self:GetThumbnailLocalPath(ba_id)
			FileDirectoryHandler.WriteFile(localPath, bytes, function (x)
				Object.Destroy(cloneTex2D)
			end)
		end
	end
end

function BeautifulAreaPhotoHandler:DoSave(ba_id, bytes, on_complete)
	local localPath = self:GetLocalPath(ba_id)
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime / 1000, on_complete)
end

function BeautifulAreaPhotoHandler:DoSaveForHistory(ba_id, bytes)
	local localPath = self:GetLocalPath(ba_id)
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	local b = DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime / 1000)
	if b then
		self:DeleteThumbnailFromLocal(ba_id)
	end
	return b
end

function BeautifulAreaPhotoHandler:Upload(ba_id, on_start, on_progress, on_complete, on_error)
	local localPath = self:GetLocalPath(ba_id)
	BeautifulAreaPhotoNetIngManager.Ins():Upload(ba_id, localPath, function ()
		if on_start ~= nil then
			on_start()
		end
	end, function (progress)
		if on_progress ~= nil then
			on_progress(progress)
		end
	end, function ()
		-- self:GetThumbnailFromServer(ba_id, nil, function (x)
		-- 	EventManager.Me():PassEvent(BeautifulAreaPhotoNeting.OnProgress, {baID = ba_id, progress = x})
		-- end, function (_baID, _bytes)
		-- 	EventManager.Me():PassEvent(BeautifulAreaPhotoNeting.OnComplete, {baID = _baID, bytes = _bytes})
		-- end)

		if on_complete ~= nil then
			on_complete()
		end
	end, function (error_type, error_code, error_message)
		if on_error ~= nil then
			on_error(error_type, error_code, error_message)
		end
	end)
end

function BeautifulAreaPhotoHandler:GetFromLocal(ba_id)
	local localPath = self:GetLocalPath(ba_id)
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	local bytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
	return bytes
end

function BeautifulAreaPhotoHandler:GetFromServer(ba_id, on_start, on_progress, on_complete, on_error)
	local localPath = self:GetLocalPath(ba_id)
	if not BeautifulAreaPhotoNetIngManager.Ins():IsDownloading(localPath) then
		BeautifulAreaPhotoNetIngManager.Ins():Download(ba_id, true, localPath, function ()
			if on_start ~= nil then
				on_start()
			end
		end, function (progress)
			if on_progress ~= nil then
				on_progress(progress, ba_id)
			end
		end, function ()
			local currentServerTime = ServerTime.CurServerTime()
			currentServerTime = currentServerTime or -1
			DiskFileManager.Instance:LRUParent(localPath, currentServerTime / 1000, true)
			local bytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
			if on_complete ~= nil then
				on_complete(ba_id, bytes)
			end
		end, function (error_type, error_code, error_message)
			if on_error ~= nil then
				on_error(ba_id, error_type, error_code, error_message)
			end
		end)
	end
end

function BeautifulAreaPhotoHandler:GetThumbnailFromLocal(ba_id)
	local localPath = self:GetThumbnailLocalPath(ba_id)
	if not BeautifulAreaPhotoNetIngManager.Ins():IsDownloading(localPath) then
		local bytes = FileDirectoryHandler.LoadFile(localPath)
		return bytes
	end
	return nil
end

function BeautifulAreaPhotoHandler:GetThumbnailFromServer(ba_id, on_start, on_progress, on_complete, on_error)
	local localPath = self:GetThumbnailLocalPath(ba_id)
	if not BeautifulAreaPhotoNetIngManager.Ins():IsDownloading(localPath) then
		BeautifulAreaPhotoNetIngManager.Ins():Download(ba_id, false, localPath, on_start, function (progress)
			if on_progress ~= nil then
				on_progress(progress, ba_id)
			end
		end, function (local_path)
			local currentServerTime = ServerTime.CurServerTime()
			currentServerTime = currentServerTime or -1
			local bytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
			if on_complete ~= nil then
				on_complete(ba_id, bytes)
			end
		end, function (error_type, error_code, error_message)
			if on_error ~= nil then
				on_error(ba_id, error_type, error_code, error_message)
			end
		end)
	end
end

function BeautifulAreaPhotoHandler:GetLocalPath(ba_id)
	local path = self.directoryPath .. "/" .. ba_id .. "." .. self.extension
	return path
end

function BeautifulAreaPhotoHandler:GetThumbnailLocalPath(ba_id)
	local path = self.thumbnailDirectoryPath .. "/" .. ba_id .. "." .. self.extension
	return path
end

function BeautifulAreaPhotoHandler:DeleteThumbnailFromLocal(ba_id)
	local localPath = self:GetThumbnailLocalPath(ba_id)
	FileDirectoryHandler.DeleteFile(localPath)
end

-- function BeautifulAreaPhotoHandler:DownloadThumbnails()
-- 	local activeAndCanActive = AdventureDataProxy.Instance:getCanAndHasUnlockedScenerys()
-- 	if activeAndCanActive ~= nil then
-- 		for _, v in pairs(activeAndCanActive) do
-- 			local baID = v.staticId
-- 			local thumbnailPath = self:GetThumbnailLocalPath(baID)
-- 			if not FileDirectoryHandler.ExistFile(thumbnailPath) then
-- 				self:GetThumbnailFromServer(baID, nil, function (x)
-- 					EventManager.Me():PassEvent(BeautifulAreaPhotoNeting.OnProgress, {baID = baID, progress = x})
-- 				end, function (_baID, _bytes)
-- 					EventManager.Me():PassEvent(BeautifulAreaPhotoNeting.OnComplete, {baID = _baID, bytes = _bytes})
-- 				end)
-- 			end
-- 		end
-- 	end
-- end

function BeautifulAreaPhotoHandler:ThumbnailIsDownloading(ba_id)
	local localPath = self:GetThumbnailLocalPath(ba_id)
	return BeautifulAreaPhotoNetIngManager.Ins():IsDownloading(localPath)
end

-- function BeautifulAreaPhotoHandler:OnReceiveEventAdventureData(data)
-- 	self:DownloadThumbnails()
-- end