LocalScenicSpotPhotoNew = class('LocalScenicSpotPhotoNew')

local divideCharacter = '!'

function LocalScenicSpotPhotoNew.Ins()
	if LocalScenicSpotPhotoNew.ins == null then
		LocalScenicSpotPhotoNew.ins = LocalScenicSpotPhotoNew.new()
	end
	return LocalScenicSpotPhotoNew.ins
end

function LocalScenicSpotPhotoNew:Get_Share(scenic_spot_id, timestamp, o_or_t)
	local retValueBytes = nil
	local retValueTimestamp = 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	if timestamp ~= nil then
		local localPath = self:AssemblePathOfLocal_Share(scenic_spot_id, timestamp, o_or_t)
		retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
		retValueTimestamp = timestamp
	end
	if retValueBytes == nil then
		local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_Share(o_or_t)
		local sFileName = FileHelper.GetChildrenName(rootPath)
		for i = 1, #sFileName do
			local fileName = sFileName[i]
			local startIndex = string.find(fileName, scenic_spot_id .. divideCharacter)
			if startIndex ~= nil and startIndex == 1 then
				local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
				local strTimestamp = StringUtility.Split(nameExceptExtension, divideCharacter)[2]
				retValueTimestamp = tonumber(strTimestamp)
				local localPath = self:AssemblePathOfLocal_FileName_Share(fileName, o_or_t)
				retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
				break
			end
		end
	end
	if retValueBytes == nil then
		local fileName = scenic_spot_id .. '.' .. PhotoFileInfo.Extension
		local localPath = self:AssemblePathOfLocal_FileName_Share(fileName, o_or_t)
		retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
		retValueTimestamp = 0
	end
	return retValueBytes, retValueTimestamp
end

function LocalScenicSpotPhotoNew:Get_Roles(photo_id, timestamp, o_or_t)
	local retValueBytes = nil
	local retValueTimestamp = 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	if timestamp ~= nil then
		local localPath = self:AssemblePathOfLocal_Roles(photo_id, timestamp, o_or_t)
		retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
		retValueTimestamp = timestamp
	end
	if retValueBytes == nil then
		local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_Roles(o_or_t)
		local sFileName = FileHelper.GetChildrenName(rootPath)
		for i = 1, #sFileName do
			local fileName = sFileName[i]
			local startIndex = string.find(fileName, photo_id .. divideCharacter)
			if startIndex ~= nil and startIndex == 1 then
				local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
				local strTimestamp = StringUtility.Split(nameExceptExtension, divideCharacter)[2]
				retValueTimestamp = tonumber(strTimestamp)
				local localPath = self:AssemblePathOfLocal_FileName_Roles(fileName, o_or_t)
				retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
				break
			end
		end
	end
	if retValueBytes == nil then
		local fileName = photo_id .. '.' .. PhotoFileInfo.Extension
		local localPath = self:AssemblePathOfLocal_FileName_Roles(fileName, o_or_t)
		retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
		retValueTimestamp = 0
	end
	return retValueBytes, retValueTimestamp
end

function LocalScenicSpotPhotoNew:Get_LoginRole(role_id, scenic_spot_id, timestamp, o_or_t)
	local retValueBytes = nil
	local retValueTimestamp = 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	if timestamp ~= nil then
		local localPath = self:AssemblePathOfLocal_LoginRole(role_id, scenic_spot_id, timestamp, o_or_t)
		retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
		retValueTimestamp = timestamp
	end
	if retValueBytes == nil then
		local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_LoginRole(role_id, o_or_t)
		local sFileName = FileHelper.GetChildrenName(rootPath)
		for i = 1, #sFileName do
			local fileName = sFileName[i]
			local startIndex = string.find(fileName, scenic_spot_id .. divideCharacter)
			if startIndex ~= nil and startIndex == 1 then
				local nameExceptExtension = StringUtility.Split(fileName, '.')[1]
				local strTimestamp = StringUtility.Split(nameExceptExtension, divideCharacter)[2]
				retValueTimestamp = tonumber(strTimestamp)
				local localPath = self:AssemblePathOfLocal_FileName_LoginRole(role_id, fileName, o_or_t)
				retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
				break
			end
		end
	end
	if retValueBytes == nil then
		local fileName = scenic_spot_id .. '.' .. PhotoFileInfo.Extension
		local localPath = self:AssemblePathOfLocal_FileName_LoginRole(role_id, fileName, o_or_t)
		retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime / 1000)
		retValueTimestamp = 0
	end
	return retValueBytes, retValueTimestamp
end

function LocalScenicSpotPhotoNew:Save_Share(scenic_spot_id, bytes, timestamp, o_or_t, extension)
	self:Delete_Share(scenic_spot_id, o_or_t)
	local localPath = self:AssemblePathOfLocal_Share(scenic_spot_id, timestamp, o_or_t)
	if extension ~= nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = extension
		localPath = self:AssemblePathOfLocal_Share(scenic_spot_id, timestamp, o_or_t)
		PhotoFileInfo.Extension = tempExtension
	end
	local currentServerTime = ServerTime.CurServerTime() or -1
	DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime / 1000)
end

function LocalScenicSpotPhotoNew:Save_Roles(role_id, scenic_spot_id, photo_id, bytes, timestamp, o_or_t, extension)
	self:Delete_Roles(role_id, scenic_spot_id, o_or_t)
	local localPath = self:AssemblePathOfLocal_Roles(photo_id, timestamp, o_or_t)
	if extension ~= nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = extension
		localPath = self:AssemblePathOfLocal_Roles(photo_id, timestamp, o_or_t)
		PhotoFileInfo.Extension = tempExtension
	end
	local currentServerTime = ServerTime.CurServerTime() or -1
	DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime / 1000)
end

function LocalScenicSpotPhotoNew:SaveAsync_Share(scenic_spot_id, bytes, timestamp, complete_callback, o_or_t, extension)
	self:Delete_Share(scenic_spot_id, o_or_t)
	local localPath = self:AssemblePathOfLocal_Share(scenic_spot_id, timestamp, o_or_t)
	if extension ~= nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = extension
		localPath = self:AssemblePathOfLocal_Share(scenic_spot_id, timestamp, o_or_t)
		PhotoFileInfo.Extension = tempExtension
	end
	local currentServerTime = ServerTime.CurServerTime() or -1
	DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime / 1000, complete_callback)
end

function LocalScenicSpotPhotoNew:SaveAsync_Roles(role_id, scenic_spot_id, photo_id, bytes, timestamp, complete_callback, o_or_t, extension)
	self:Delete_Roles(role_id, scenic_spot_id, o_or_t)
	local localPath = self:AssemblePathOfLocal_Roles(photo_id, timestamp, o_or_t)
	if extension ~= nil then
		local tempExtension = PhotoFileInfo.Extension
		PhotoFileInfo.Extension = extension
		localPath = self:AssemblePathOfLocal_Roles(photo_id, timestamp, o_or_t)
		PhotoFileInfo.Extension = tempExtension
	end
	local currentServerTime = ServerTime.CurServerTime() or -1
	DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime / 1000, complete_callback)
end

function LocalScenicSpotPhotoNew:GetTimestamp_Share(scenic_spot_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_Share(o_or_t)
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
	local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName_Share(fileName, o_or_t)
	if FileHelper.ExistFile(localPath) then
		return 0
	end
	fileName = scenic_spot_id .. '.' .. PhotoFileInfo.OldExtension
	local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName_Share(fileName, o_or_t)
	if FileHelper.ExistFile(localPath) then
		return 0
	end
	return nil
end

function LocalScenicSpotPhotoNew:GetTimestamp_Roles(photo_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_Roles(o_or_t)
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
	local fileName = photo_id .. '.' .. PhotoFileInfo.Extension
	local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName_Roles(fileName, o_or_t)
	if FileHelper.ExistFile(localPath) then
		return 0
	end
	fileName = photo_id .. '.' .. PhotoFileInfo.OldExtension
	local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName_Roles(fileName, o_or_t)
	if FileHelper.ExistFile(localPath) then
		return 0
	end
	return nil
end

function LocalScenicSpotPhotoNew:GetTimestamp_LoginRole(role_id, scenic_spot_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_LoginRole(role_id, o_or_t)
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
	local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName_LoginRole(role_id, fileName, o_or_t)
	if FileHelper.ExistFile(localPath) then
		return 0
	end
	fileName = scenic_spot_id .. '.' .. PhotoFileInfo.OldExtension
	local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName_LoginRole(role_id, fileName, o_or_t)
	if FileHelper.ExistFile(localPath) then
		return 0
	end
	return nil
end

function LocalScenicSpotPhotoNew:Delete_Share(scenic_spot_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_Share(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, scenic_spot_id .. divideCharacter)
		local startIndexNoTimestamp = string.find(fileName, scenic_spot_id .. '.')
		if (startIndex ~= nil and startIndex == 1) or (startIndexNoTimestamp ~= nil and startIndexNoTimestamp == 1) then
			local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName_Share(fileName, o_or_t)
			FileHelper.DeleteFile(localPath)
		end
	end
end

function LocalScenicSpotPhotoNew:Delete_Roles(photo_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_Roles(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, photo_id .. divideCharacter)
		local startIndexNoTimestamp = string.find(fileName, photo_id .. '.')
		if (startIndex ~= nil and startIndex == 1) or (startIndexNoTimestamp ~= nil and startIndexNoTimestamp == 1) then
			local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName_Roles(fileName, o_or_t)
			FileHelper.DeleteFile(localPath)
		end
	end
end

function LocalScenicSpotPhotoNew:Delete_LoginRole(role_id, scenic_spot_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_LoginRole(role_id, o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, scenic_spot_id .. divideCharacter)
		local startIndexNoTimestamp = string.find(fileName, scenic_spot_id .. '.')
		if (startIndex ~= nil and startIndex == 1) or (startIndexNoTimestamp ~= nil and startIndexNoTimestamp == 1) then
			local localPath = Application.persistentDataPath .. '/' .. self:AssemblePathOfLocal_FileName_LoginRole(role_id, fileName, o_or_t)
			FileHelper.DeleteFile(localPath)
		end
	end
end

function LocalScenicSpotPhotoNew:GetPathOfLocal_Share(scenic_spot_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_Share(o_or_t)
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

function LocalScenicSpotPhotoNew:GetPathOfLocal_Roles(photo_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_Roles(o_or_t)
	local sFileName = FileHelper.GetChildrenName(rootPath)
	for i = 1, #sFileName do
		local fileName = sFileName[i]
		local startIndex = string.find(fileName, photo_id .. divideCharacter)
		if startIndex ~= nil and startIndex == 1 then
			return rootPath .. '/' .. fileName
		end
	end
	local fileName = photo_id .. '.' .. PhotoFileInfo.Extension
	local localPath = rootPath .. '/' .. fileName
	if FileHelper.ExistFile(localPath) then
		return localPath
	end
	return nil
end

function LocalScenicSpotPhotoNew:GetPathOfLocal_LoginRole(role_id, scenic_spot_id, o_or_t)
	local rootPath = Application.persistentDataPath .. '/' .. self:GetRootPathOfLocal_LoginRole(role_id, o_or_t)
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

function LocalScenicSpotPhotoNew:GetRootPathOfLocal_Share(o_or_t)
	if o_or_t then
		return IOPathConfig.Paths.Extension.ScenicSpotPhotoShareOrigin
	else
		return IOPathConfig.Paths.Extension.ScenicSpotPhotoShareThumbnail
	end
end

function LocalScenicSpotPhotoNew:GetRootPathOfLocal_Roles(o_or_t)
	if o_or_t then
		return IOPathConfig.Paths.Extension.ScenicSpotPhotoRolesOrigin
	else
		return IOPathConfig.Paths.Extension.ScenicSpotPhotoRolesThumbnail
	end
end

function LocalScenicSpotPhotoNew:GetRootPathOfLocal_LoginRole(role_id, o_or_t)
	local currentLoginRoleID = Game.Myself.data.id
	if o_or_t then
		return StringUtil.Replace(IOPathConfig.Paths.User.ScenicSpotPhoto, currentLoginRoleID, role_id)
	else
		return StringUtil.Replace(IOPathConfig.Paths.User.ScenicSpotPreview, currentLoginRoleID, role_id)
	end
end

function LocalScenicSpotPhotoNew:AssemblePathOfLocal_Share(scenic_spot_id, timestamp, o_or_t)
	local fileName = nil
	if timestamp > 0 then
		fileName = scenic_spot_id .. divideCharacter .. timestamp .. '.' .. PhotoFileInfo.Extension
	else
		fileName = scenic_spot_id .. '.' .. PhotoFileInfo.Extension
	end
	return self:AssemblePathOfLocal_FileName_Share(fileName, o_or_t)
end

function LocalScenicSpotPhotoNew:AssemblePathOfLocal_Roles(photo_id, timestamp, o_or_t)
	local fileName = nil
	if timestamp > 0 then
		fileName = photo_id .. divideCharacter .. timestamp .. '.' .. PhotoFileInfo.Extension
	else
		fileName = photo_id .. '.' .. PhotoFileInfo.Extension
	end
	return self:AssemblePathOfLocal_FileName_Roles(fileName, o_or_t)
end

function LocalScenicSpotPhotoNew:AssemblePathOfLocal_LoginRole(role_id, scenic_spot_id, timestamp, o_or_t)
	local fileName = nil
	if timestamp > 0 then
		fileName = scenic_spot_id .. divideCharacter .. timestamp .. '.' .. PhotoFileInfo.Extension
	else
		fileName = scenic_spot_id .. '.' .. PhotoFileInfo.Extension
	end
	return self:AssemblePathOfLocal_FileName_LoginRole(role_id, fileName, o_or_t)
end

function LocalScenicSpotPhotoNew:AssemblePathOfLocal_FileName_Share(file_name, o_or_t)
	return self:GetRootPathOfLocal_Share(o_or_t) .. '/' .. file_name
end

function LocalScenicSpotPhotoNew:AssemblePathOfLocal_FileName_Roles(file_name, o_or_t)
	return self:GetRootPathOfLocal_Roles(o_or_t) .. '/' .. file_name
end

function LocalScenicSpotPhotoNew:AssemblePathOfLocal_FileName_LoginRole(role_id, file_name, o_or_t)
	return self:GetRootPathOfLocal_LoginRole(role_id, o_or_t) .. '/' .. file_name
end