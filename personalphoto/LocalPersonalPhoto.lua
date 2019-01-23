autoImport('StringUtility')
autoImport('PhotoFileInfo')
local IOPathConfig = autoImport('IOPathConfig')

LocalPersonalPhoto = class('LocalPersonalPhoto')

local divideCharacter = '!'

function LocalPersonalPhoto.Ins()
	if LocalPersonalPhoto.ins == nil then
		LocalPersonalPhoto.ins = LocalPersonalPhoto.new()
	end
	return LocalPersonalPhoto.ins
end

function LocalPersonalPhoto:Get(photo_id, timestamp, o_or_t)
	local retValueBytes = nil
	local retValueTimestamp = 0
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	if timestamp ~= nil then
		local localPath = self:AssemblePathOfLocal(photo_id, timestamp, o_or_t)
		retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
		retValueTimestamp = timestamp
	end
	if retValueBytes == nil then
		local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(o_or_t)
		local sFileName = FileHelper.GetChildrenName(rootPath)
		for i = 1, #sFileName do
			local fileName = sFileName[i]
			local startIndex = string.find(fileName, photo_id .. divideCharacter)
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
	return retValueBytes, retValueTimestamp
end

function LocalPersonalPhoto:Save(photo_id, bytes, timestamp, o_or_t, extension)
	self:Delete(photo_id, o_or_t)
	local localPath = self:AssemblePathOfLocal(photo_id, timestamp, o_or_t)
	if extension ~= nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = extension
		localPath = self:AssemblePathOfLocal(photo_id, timestamp, o_or_t)
		PhotoFileInfo.Extension = tempExtension
	end
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime / 1000)
end

function LocalPersonalPhoto:SaveAsync(photo_id, bytes, timestamp, complete_callback, o_or_t, extension)
	self:Delete(photo_id, o_or_t)
	local localPath = self:AssemblePathOfLocal(photo_id, timestamp, o_or_t)
	if extension ~= nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = extension
		localPath = self:AssemblePathOfLocal(photo_id, timestamp, o_or_t)
		PhotoFileInfo.Extension = tempExtension
	end
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime / 1000, complete_callback)
end

function LocalPersonalPhoto:GetTimestamp(photo_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, photo_id .. divideCharacter)
		if startIndex ~= nil and startIndex == 1 then
			local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
			local sNameSplited = StringUtility.Split(nameExceptExtension, divideCharacter)
			local strTimestamp = sNameSplited[2]
			local timestamp = tonumber(strTimestamp)
			return timestamp
		end
	end
	return nil
end

function LocalPersonalPhoto:Delete(photo_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, photo_id .. divideCharacter)
		if startIndex ~= nil and startIndex == 1 then
			local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName(fileName, o_or_t)
			FileHelper.DeleteFile(localPath)
		end
	end
end

function LocalPersonalPhoto:GetPathOfLocal(photo_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, photo_id .. divideCharacter)
		if startIndex ~= nil and startIndex == 1 then
			return rootPath .. '/' .. fileName
		end
	end
	return nil
end

function LocalPersonalPhoto:GetFileExtension(photo_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, photo_id .. divideCharacter)
		if startIndex ~= nil and startIndex == 1 then
			return StringUtility.Split(fileName, '.')[2]
		end
	end
	return nil
end

function LocalPersonalPhoto:GetRootPathOfLocal(o_or_t)
	if o_or_t then
		return IOPathConfig.Paths.USER.PersonalPhotoOrigin
	else
		return IOPathConfig.Paths.USER.PersonalPhotoThumbnail
	end
end

function LocalPersonalPhoto:AssemblePathOfLocal(photo_id, timestamp, o_or_t)
	local fileName = photo_id .. divideCharacter .. timestamp .. '.' .. PhotoFileInfo.Extension
	return self:AssemblePathOfLocal_FileName(fileName, o_or_t)
end

function LocalPersonalPhoto:AssemblePathOfLocal_FileName(file_name, o_or_t)
	return self:GetRootPathOfLocal(o_or_t) .. '/' .. file_name
end