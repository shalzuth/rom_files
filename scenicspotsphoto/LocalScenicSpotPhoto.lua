local IOPathConfig = autoImport('IOPathConfig')
autoImport('StringUtility')
autoImport('PhotoFileInfo')

LocalScenicSpotPhoto = class('LocalScenicSpotPhoto')

local divideCharacter = '!'



function LocalScenicSpotPhoto.Ins()
	if LocalScenicSpotPhoto.ins == null then
		LocalScenicSpotPhoto.ins = LocalScenicSpotPhoto.new()
	end
	return LocalScenicSpotPhoto.ins
end

function LocalScenicSpotPhoto:Get(scenic_spot_id, timestamp, o_or_t)
	local retValueBytes = nil
	local retValueTimestamp = 0
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	if timestamp ~= nil then
		local localPath = self:AssemblePathOfLocal(scenic_spot_id, timestamp, o_or_t)
		retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
		retValueTimestamp = timestamp
	end
	if retValueBytes == nil then
		local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(o_or_t)
		local sFileName = FileHelper.GetChildrenName(rootPath)
		for i = 1, #sFileName do
			local fileName = sFileName[i]
			local startIndex = string.find(fileName, scenic_spot_id .. divideCharacter)
			if startIndex ~= nil and startIndex == 1 then
				local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
				local strTimestamp = StringUtility.Split(nameExceptExtension, divideCharacter)[2]
				retValueTimestamp = tonumber(strTimestamp)
				local localPath = self:AssemblePathOfLocal_FileName(fileName, o_or_t)
				retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
				break
			end
		end
	end
	if retValueBytes == nil then
		local fileName = scenic_spot_id .. '.' .. PhotoFileInfo.Extension
		local localPath = self:AssemblePathOfLocal_FileName(fileName, o_or_t)
		retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
		retValueTimestamp = 0
	end
	return retValueBytes, retValueTimestamp
end

function LocalScenicSpotPhoto:Save(scenic_spot_id, bytes, timestamp, o_or_t, extension)
	self:Delete(scenic_spot_id, o_or_t)
	local localPath = self:AssemblePathOfLocal(scenic_spot_id, timestamp, o_or_t)
	if extension ~= nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = extension
		localPath = self:AssemblePathOfLocal(scenic_spot_id, timestamp, o_or_t)
		PhotoFileInfo.Extension = tempExtension
	end
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime / 1000)
end

function LocalScenicSpotPhoto:SaveAsync(scenic_spot_id, bytes, timestamp, complete_callback, o_or_t, extension)
	self:Delete(scenic_spot_id, o_or_t)
	local localPath = self:AssemblePathOfLocal(scenic_spot_id, timestamp, o_or_t)
	if extension ~= nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = extension
		localPath = self:AssemblePathOfLocal(scenic_spot_id, timestamp, o_or_t)
		PhotoFileInfo.Extension = tempExtension
	end
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime / 1000, complete_callback)
end

function LocalScenicSpotPhoto:GetTimestamp(scenic_spot_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, scenic_spot_id .. divideCharacter)
		if startIndex ~= nil and startIndex == 1 then
			local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
			local strTimestamp = StringUtility.Split(nameExceptExtension, divideCharacter)[2]
			local timestamp = tonumber(strTimestamp)
			return timestamp
		end
	end
	local fileName = scenic_spot_id .. '.' .. PhotoFileInfo.Extension
	local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName(fileName, o_or_t)
	if FileHelper.ExistFile(localPath) then
		return 0
	end
	fileName = scenic_spot_id .. '.' .. PhotoFileInfo.OldExtension
	local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName(fileName, o_or_t)
	if FileHelper.ExistFile(localPath) then
		return 0
	end
	return nil
end

function LocalScenicSpotPhoto:Delete(scenic_spot_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, scenic_spot_id .. divideCharacter)
		local startIndexNoTimestamp = string.find(fileName, scenic_spot_id .. '.')
		if (startIndex ~= nil and startIndex == 1) or (startIndexNoTimestamp ~= nil and startIndexNoTimestamp == 1) then
			local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName(fileName, o_or_t)
			FileHelper.DeleteFile(localPath)
		end
	end
end

function LocalScenicSpotPhoto:GetPathOfLocal(scenic_spot_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, scenic_spot_id .. divideCharacter)
		if startIndex ~= nil and startIndex == 1 then
			return rootPath .. '/' .. fileName
		end
	end
	local fileName = scenic_spot_id .. '.' .. PhotoFileInfo.Extension
	local localPath = rootPath .. '/' .. fileName
	if FileHelper.ExistFile(localPath) then
		return localPath
	end
	return nil
end

function LocalScenicSpotPhoto:GetRootPathOfLocal(o_or_t)
	if o_or_t then
		return IOPathConfig.Paths.USER.ScenicSpotPhoto
	else
		return IOPathConfig.Paths.USER.ScenicSpotPreview
	end
end

function LocalScenicSpotPhoto:AssemblePathOfLocal(scenic_spot_id, timestamp, o_or_t)
	local fileName = nil
	if timestamp > 0 then
		fileName = scenic_spot_id .. divideCharacter .. timestamp .. '.' .. PhotoFileInfo.Extension
	else
		fileName = scenic_spot_id .. '.' .. PhotoFileInfo.Extension
	end
	return self:AssemblePathOfLocal_FileName(fileName, o_or_t)
end

function LocalScenicSpotPhoto:AssemblePathOfLocal_FileName(file_name, o_or_t)
	return self:GetRootPathOfLocal(o_or_t) .. '/' .. file_name
end