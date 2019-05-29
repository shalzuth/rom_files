autoImport("StringUtility")
autoImport("DiskFileHandler")
autoImport("PhotoFileInfo")
LocalUnionLogo = class("LocalUnionLogo")
local divideCharacter = "!"
function LocalUnionLogo.Ins()
  if LocalUnionLogo.ins == nil then
    LocalUnionLogo.ins = LocalUnionLogo.new()
  end
  return LocalUnionLogo.ins
end
function LocalUnionLogo:Get(photo_id, timestamp, extension, o_or_t)
  local retValueBytes
  local retValueTimestamp = 0
  local currentServerTime = DiskFileHandler.GetCurrentServerTime()
  if timestamp ~= nil then
    local localPath = self:AssemblePathOfLocal(photo_id, timestamp, extension, o_or_t)
    retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime)
    retValueTimestamp = timestamp
  end
  if retValueBytes == nil then
    local rootPath = ApplicationHelper.persistentDataPath .. "/" .. self:GetRootPathOfLocal(o_or_t)
    local sFileName = FileHelper.GetChildrenName(rootPath)
    if sFileName then
      for i = 1, #sFileName do
        local fileName = sFileName[i]
        local startIndex = string.find(fileName, photo_id .. divideCharacter)
        if startIndex ~= nil and startIndex == 1 then
          local nameExceptExtension = StringUtility.Split(fileName, ".")[1]
          local strTimestamp = StringUtility.Split(nameExceptExtension, divideCharacter)[2]
          retValueTimestamp = tonumber(strTimestamp)
          local localPath = self:AssemblePathOfLocal_FileName(fileName, o_or_t)
          retValueBytes = DiskFileManager.Instance:LoadFile(localPath, currentServerTime)
          break
        end
      end
    else
      redlog("LocalUnionLogo:sFileName is null")
    end
  end
  return retValueBytes, retValueTimestamp
end
function LocalUnionLogo:Save(photo_id, bytes, timestamp, extension, o_or_t)
  self:Delete(photo_id, o_or_t)
  local localPath = self:AssemblePathOfLocal(photo_id, timestamp, extension, o_or_t)
  local currentServerTime = DiskFileHandler.GetCurrentServerTime()
  DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime)
end
function LocalUnionLogo:SaveAsync(photo_id, bytes, timestamp, extension, complete_callback, o_or_t)
  self:Delete(photo_id, o_or_t)
  local localPath = self:AssemblePathOfLocal(photo_id, timestamp, extension, o_or_t)
  local currentServerTime = DiskFileHandler.GetCurrentServerTime()
  DiskFileManager.Instance:SaveFile(localPath, bytes, currentServerTime, complete_callback)
end
function LocalUnionLogo:GetTimestamp(photo_id, o_or_t)
  local rootPath = ApplicationHelper.persistentDataPath .. "/" .. self:GetRootPathOfLocal(o_or_t)
  local sFileName = FileHelper.GetChildrenName(rootPath)
  if sFileName then
    for i = 1, #sFileName do
      local fileName = sFileName[i]
      local startIndex = string.find(fileName, photo_id .. divideCharacter)
      if startIndex ~= nil and startIndex == 1 then
        local nameExceptExtension = StringUtility.Split(fileName, ".")[1]
        local sNameSplited = StringUtility.Split(nameExceptExtension, divideCharacter)
        local strTimestamp = sNameSplited[2]
        local timestamp = tonumber(strTimestamp)
        return timestamp
      end
    end
  else
    redlog("LocalUnionLogo:sFileName is null")
  end
  return nil
end
function LocalUnionLogo:Delete(photo_id, o_or_t)
  local rootPath = ApplicationHelper.persistentDataPath .. "/" .. self:GetRootPathOfLocal(o_or_t)
  local sFileName = FileHelper.GetChildrenName(rootPath)
  if sFileName then
    for i = 1, #sFileName do
      local fileName = sFileName[i]
      local startIndex = string.find(fileName, photo_id .. divideCharacter)
      if startIndex ~= nil and startIndex == 1 then
        local localPath = rootPath .. "/" .. fileName
        FileHelper.DeleteFile(localPath)
      end
    end
  else
    redlog("LocalUnionLogo:sFileName is null")
  end
end
function LocalUnionLogo:GetRootPathOfLocal(o_or_t)
  if o_or_t then
    return IOPathConfig.Paths.USER.UnionLogoOrigin
  else
    return IOPathConfig.Paths.USER.UnionLogoThumbnail
  end
end
function LocalUnionLogo:AssemblePathOfLocal(photo_id, timestamp, extension, o_or_t)
  local fileName = photo_id .. divideCharacter .. timestamp .. "." .. extension
  return self:AssemblePathOfLocal_FileName(fileName, o_or_t)
end
function LocalUnionLogo:AssemblePathOfLocal_FileName(file_name, o_or_t)
  return self:GetRootPathOfLocal(o_or_t) .. "/" .. file_name
end
