local IOPathConfig = autoImport('IOPathConfig')
autoImport('StringUtility')
autoImport('PhotoFileInfo')

LocalUnionWallPhoto = class('LocalUnionWallPhoto')

local divideCharacter = '!'

function LocalUnionWallPhoto.Ins()
	if LocalUnionWallPhoto.ins == nil then
		LocalUnionWallPhoto.ins = LocalUnionWallPhoto.new()
	end
	return LocalUnionWallPhoto.ins
end

function LocalUnionWallPhoto:Get(photo_id, timestamp, o_or_t)
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

function LocalUnionWallPhoto:Save(photo_id, bytes, timestamp, o_or_t, extension)
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

function LocalUnionWallPhoto:SaveAsync(photo_id, bytes, timestamp, complete_callback, o_or_t, extension)
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

function LocalUnionWallPhoto:GetTimestamp(photo_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, photo_id .. divideCharacter)
		if startIndex ~= nil and startIndex == 1 then
			local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
			local strTimestamp = StringUtility.Split(nameExceptExtension, divideCharacter)[2]
			local timestamp = tonumber(strTimestamp)
			return timestamp
		end
	end
	return nil
end

function LocalUnionWallPhoto:Delete(photo_id, o_or_t)
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

function LocalUnionWallPhoto:DeleteAllPhotosOfRole(role_id)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(true)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
		local strRoleID = StringUtility.Split(nameExceptExtension, '_')[1]
		local roleID = tonumber[strRoleID]
		if roleID == role_id then
			local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName(fileName, true)
			FileHelper.DeleteFile(localPath)
		end
	end
	rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(false)
	sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
		local strRoleID = StringUtility.Split(nameExceptExtension, '_')[1]
		local roleID = tonumber[strRoleID]
		if roleID == role_id then
			local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName(fileName, false)
			FileHelper.DeleteFile(localPath)
		end
	end
end

function LocalUnionWallPhoto:DeleteAllPhotosOfAccount(account_id)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(true)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
		local nameExceptExtensionSplitByUnderline = StringUtility.Split(nameExceptExtension, '_')
		local accountFlag = nameExceptExtensionSplitByUnderline[4]
		if accountFlag == 'a' then
			local strAccountID = nameExceptExtensionSplitByUnderline[1]
			local accountID = tonumber[strAccountID]
			if accountID == account_id then
				local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName(fileName, true)
				FileHelper.DeleteFile(localPath)
			end
		end
	end
	rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal(false)
	sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
		local nameExceptExtensionSplitByUnderline = StringUtility.Split(nameExceptExtension, '_')
		local accountFlag = nameExceptExtensionSplitByUnderline[4]
		if accountFlag == 'a' then
			local strAccountID = nameExceptExtensionSplitByUnderline[1]
			local accountID = tonumber[strAccountID]
			if accountID == account_id then
				local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName(fileName, false)
				FileHelper.DeleteFile(localPath)
			end
		end
	end
end

function LocalUnionWallPhoto:GetRootPathOfLocal(o_or_t)
	if o_or_t then
		return IOPathConfig.Paths.USER.UnionWallPhotoOrigin
	else
		return IOPathConfig.Paths.USER.UnionWallPhotoThumbnail
	end
end

function LocalUnionWallPhoto:AssemblePathOfLocal(photo_id, timestamp, o_or_t)
	local fileName = photo_id .. divideCharacter .. timestamp .. '.' .. PhotoFileInfo.Extension
	return self:AssemblePathOfLocal_FileName(fileName, o_or_t)
end

function LocalUnionWallPhoto:AssemblePathOfLocal_FileName(file_name, o_or_t)
	return self:GetRootPathOfLocal(o_or_t) .. '/' .. file_name
end