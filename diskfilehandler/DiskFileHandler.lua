DiskFileHandler = class("DiskFileHandler")

local IOPathConfig = autoImport("IOPathConfig")

function DiskFileHandler.Ins()
	if DiskFileHandler.ins == null then
		DiskFileHandler.ins = DiskFileHandler.new()
	end
	return DiskFileHandler.ins
end

function DiskFileHandler:EnterRoot()
	-- create IOPathConfig.Datas
	IOPathConfig.Init("", "")

	local usersDirectoryPath = IOPathConfig.Paths.Root
	local capacity = IOPathConfig.Datas.USER.Root.LRU_Count or 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(usersDirectoryPath, capacity, currentServerTime / 1000, false, false)
	else
		DiskFileManager.Instance:InitializeDirectory(usersDirectoryPath, currentServerTime / 1000, false)
	end
end

function DiskFileHandler:EnterExtension()
	local extensionDirectoryPath = IOPathConfig.Paths.Extension.Root
	local capacity = IOPathConfig.Datas.Extension.Root.LRUCount or 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(extensionDirectoryPath, capacity, currentServerTime / 1000, false, false)
	else
		DiskFileManager.Instance:InitializeDirectory(extensionDirectoryPath, currentServerTime / 1000, false)
	end
end

-- where call
-- CreateRoleViewV2:OnResponseCreateRoleSuccess
function DiskFileHandler:SetUser(user)
	self.user = user
end

function DiskFileHandler:SetServer(server)
	self.server = server
end

function DiskFileHandler:SetRole(role)
	self.role = role
end

function DiskFileHandler:GetServer()
	return self.server
end

function DiskFileHandler:EnterServer()
	IOPathConfig.Init(self.user, self.server, self.role)

	-- Users
	local userDirectoryPath = IOPathConfig.Paths.USER.UserGuid
	local capacity = IOPathConfig.Datas.USER.UserGuid.LRU_Count
	capacity = capacity or 0
	local currentServerTime = ServerTime.CurServerTime()
	if currentServerTime ~= nil then
		currentServerTime = currentServerTime / 1000
	else
		currentServerTime = -1
	end
	local parentLRUCount = IOPathConfig.Datas.USER.Root.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(userDirectoryPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(userDirectoryPath, currentServerTime, parentLRUCount > 0)
	end

	local serverDirectoryPath = IOPathConfig.Paths.USER.Server
	capacity = IOPathConfig.Datas.USER.Server.LRU_Count
	capacity = capacity or 0
	parentLRUCount = IOPathConfig.Datas.USER.UserGuid.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(serverDirectoryPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(serverDirectoryPath, currentServerTime, parentLRUCount > 0)
	end

	local roleDirectoryPath = IOPathConfig.Paths.USER.Role
	capacity = IOPathConfig.Datas.USER.Role.LRU_Count; capacity = capacity or 0
	parentLRUCount = IOPathConfig.Datas.USER.Server.LRU_Count; parentLRUCount = parentLRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(roleDirectoryPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(roleDirectoryPath, currentServerTime, parentLRUCount > 0)
	end

	-- Extension
	local accountDirectoryPath = IOPathConfig.Paths.Extension.Account
	capacity = IOPathConfig.Datas.Extension.Account.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.Root.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(accountDirectoryPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(accountDirectoryPath, currentServerTime, parentLRUCount > 0)
	end

	local accountX_DirectoryPath = IOPathConfig.Paths.Extension.AccountX
	capacity = IOPathConfig.Datas.Extension.AccountX.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.Account.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(accountX_DirectoryPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(accountX_DirectoryPath, currentServerTime, parentLRUCount > 0)
	end

	serverDirectoryPath = IOPathConfig.Paths.Extension.Server
	capacity = IOPathConfig.Datas.Extension.Server.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.AccountX.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(serverDirectoryPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(serverDirectoryPath, currentServerTime, parentLRUCount > 0)
	end

	local serverX_DirectoryPath = IOPathConfig.Paths.Extension.ServerX
	capacity = IOPathConfig.Datas.Extension.ServerX.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.Server.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(serverX_DirectoryPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(serverX_DirectoryPath, currentServerTime, parentLRUCount > 0)
	end
end

function DiskFileHandler:EnterBeautifulArea()
	local baPath = IOPathConfig.Paths.USER.ScenicSpot
	local capacity = IOPathConfig.Datas.USER.ScenicSpot.LRU_Count
	capacity = capacity or 0
	local currentServerTime = ServerTime.CurServerTime()
	if currentServerTime ~= nil then
		currentServerTime = currentServerTime / 1000
	else
		currentServerTime = -1
	end
	local parentLRUCount = IOPathConfig.Datas.USER.Role.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(baPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(baPath, currentServerTime, parentLRUCount > 0)
	end

	local baPicturePath = IOPathConfig.Paths.USER.ScenicSpotPhoto
	capacity = IOPathConfig.Datas.USER.ScenicSpotPhoto.LRU_Count
	capacity = capacity or 0
	parentLRUCount = IOPathConfig.Datas.USER.ScenicSpot.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(baPicturePath, capacity, currentServerTime, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(baPicturePath, currentServerTime, parentLRUCount > 0)
	end

	local baThumbnailPath = IOPathConfig.Paths.USER.ScenicSpotPreview
	capacity = IOPathConfig.Datas.USER.ScenicSpotPreview.LRU_Count
	capacity = capacity or 0
	parentLRUCount = IOPathConfig.Datas.USER.ScenicSpot.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(baThumbnailPath, capacity, currentServerTime, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(baThumbnailPath, currentServerTime, parentLRUCount > 0)
	end

	local gamePhotoDirectoryPath = IOPathConfig.Paths.Extension.GamePhoto
	capacity = IOPathConfig.Datas.Extension.GamePhoto.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.ServerX.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(gamePhotoDirectoryPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(gamePhotoDirectoryPath, currentServerTime, parentLRUCount > 0)
	end

	local scenicSpotPhotoDirectoryPath = IOPathConfig.Paths.Extension.ScenicSpotPhoto
	capacity = IOPathConfig.Datas.Extension.ScenicSpotPhoto.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.GamePhoto.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(scenicSpotPhotoDirectoryPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(scenicSpotPhotoDirectoryPath, currentServerTime, parentLRUCount > 0)
	end

	-- DP means directory path; SS means scenic spot
	local ssPhotoShareDP = IOPathConfig.Paths.Extension.ScenicSpotPhotoShare
	capacity = IOPathConfig.Datas.Extension.ScenicSpotPhotoShare.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.ScenicSpotPhoto.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(ssPhotoShareDP, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(ssPhotoShareDP, currentServerTime, parentLRUCount > 0)
	end

	local ssPhotoShareOriginDP = IOPathConfig.Paths.Extension.ScenicSpotPhotoShareOrigin
	capacity = IOPathConfig.Datas.Extension.ScenicSpotPhotoShareOrigin.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.ScenicSpotPhotoShare.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(ssPhotoShareOriginDP, capacity, currentServerTime, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(ssPhotoShareOriginDP, currentServerTime, parentLRUCount > 0)
	end

	local ssPhotoShareThumbnailDP = IOPathConfig.Paths.Extension.ScenicSpotPhotoShareThumbnail
	capacity = IOPathConfig.Datas.Extension.ScenicSpotPhotoShareThumbnail.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.ScenicSpotPhotoShare.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(ssPhotoShareThumbnailDP, capacity, currentServerTime, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(ssPhotoShareThumbnailDP, currentServerTime, parentLRUCount > 0)
	end

	local ssPhotoRolesDP = IOPathConfig.Paths.Extension.ScenicSpotPhotoRoles
	capacity = IOPathConfig.Datas.Extension.ScenicSpotPhotoRoles.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.ScenicSpotPhoto.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(ssPhotoRolesDP, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(ssPhotoRolesDP, currentServerTime, parentLRUCount > 0)
	end

	local ssPhotoRolesOriginDP = IOPathConfig.Paths.Extension.ScenicSpotPhotoRolesOrigin
	capacity = IOPathConfig.Datas.Extension.ScenicSpotPhotoRolesOrigin.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.ScenicSpotPhotoRoles.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(ssPhotoRolesOriginDP, capacity, currentServerTime, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(ssPhotoRolesOriginDP, currentServerTime, parentLRUCount > 0)
	end

	local ssPhotoRolesThumbnailDP = IOPathConfig.Paths.Extension.ScenicSpotPhotoRolesThumbnail
	capacity = IOPathConfig.Datas.Extension.ScenicSpotPhotoRolesThumbnail.LRUCount or 0
	parentLRUCount = IOPathConfig.Datas.Extension.ScenicSpotPhotoRoles.LRUCount or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(ssPhotoRolesThumbnailDP, capacity, currentServerTime, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(ssPhotoRolesThumbnailDP, currentServerTime, parentLRUCount > 0)
	end
end

function DiskFileHandler:EnterUnionWallPhoto()
	local uwpPath = IOPathConfig.Paths.USER.UnionWallPhoto
	local capacity = IOPathConfig.Datas.USER.UnionWallPhoto.LRU_Count
	capacity = capacity or 0
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	local parentLRUCount = IOPathConfig.Datas.USER.Role.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(uwpPath, capacity, currentServerTime / 1000, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(uwpPath, currentServerTime / 1000, parentLRUCount > 0)
	end

	local uwpOriginPath = IOPathConfig.Paths.USER.UnionWallPhotoOrigin
	capacity = IOPathConfig.Datas.USER.UnionWallPhotoOrigin.LRU_Count
	capacity = capacity or 0
	parentLRUCount = IOPathConfig.Datas.USER.UnionWallPhoto.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(uwpOriginPath, capacity, currentServerTime / 1000, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(uwpOriginPath, currentServerTime / 1000, parentLRUCount > 0)
	end

	local uwpThumbnailPath = IOPathConfig.Paths.USER.UnionWallPhotoThumbnail
	capacity = IOPathConfig.Datas.USER.UnionWallPhotoThumbnail.LRU_Count
	capacity = capacity or 0
	parentLRUCount = IOPathConfig.Datas.USER.UnionWallPhoto.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(uwpThumbnailPath, capacity, currentServerTime / 1000, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(uwpThumbnailPath, currentServerTime / 1000, parentLRUCount > 0)
	end
end

function DiskFileHandler:EnterPersonalPhoto()
	local ppPath = IOPathConfig.Paths.USER.PersonalPhoto
	local capacity = IOPathConfig.Datas.USER.PersonalPhoto.LRU_Count
	capacity = capacity or 0
	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	local parentLRUCount = IOPathConfig.Datas.USER.Role.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(ppPath, capacity, currentServerTime / 1000, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(ppPath, currentServerTime / 1000, parentLRUCount > 0)
	end

	local ppOriginPath = IOPathConfig.Paths.USER.PersonalPhotoOrigin
	capacity = IOPathConfig.Datas.USER.PersonalPhotoOrigin.LRU_Count
	capacity = capacity or 0
	parentLRUCount = IOPathConfig.Datas.USER.PersonalPhoto.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(ppOriginPath, capacity, currentServerTime / 1000, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(ppOriginPath, currentServerTime / 1000, parentLRUCount > 0)
	end

	local ppThumbnailPath = IOPathConfig.Paths.USER.PersonalPhotoThumbnail
	capacity = IOPathConfig.Datas.USER.PersonalPhotoThumbnail.LRU_Count
	capacity = capacity or 0
	parentLRUCount = IOPathConfig.Datas.USER.PersonalPhoto.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(ppThumbnailPath, capacity, currentServerTime / 1000, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(ppThumbnailPath, currentServerTime / 1000, parentLRUCount > 0)
	end
end

function DiskFileHandler:EnterUnionLogo()
	local ulPath = IOPathConfig.Paths.USER.UnionLogo
	local capacity = IOPathConfig.Datas.USER.UnionLogo.LRU_Count or 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	local parentLRUCount = IOPathConfig.Datas.USER.Role.LRU_Count or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(ulPath, capacity, currentServerTime / 1000, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(ulPath, currentServerTime / 1000, parentLRUCount > 0)
	end

	local ulOriginPath = IOPathConfig.Paths.USER.UnionLogoOrigin
	capacity = IOPathConfig.Datas.USER.UnionLogoOrigin.LRU_Count or 0
	parentLRUCount = IOPathConfig.Datas.USER.UnionLogo.LRU_Count or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(ulOriginPath, capacity, currentServerTime / 1000, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(ulOriginPath, currentServerTime / 1000, parentLRUCount > 0)
	end

	local ulThumbnailPath = IOPathConfig.Paths.USER.UnionLogoThumbnail
	capacity = IOPathConfig.Datas.USER.UnionLogoThumbnail.LRU_Count or 0
	parentLRUCount = IOPathConfig.Datas.USER.UnionLogo.LRU_Count or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(ulThumbnailPath, capacity, currentServerTime / 1000, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(ulThumbnailPath, currentServerTime / 1000, parentLRUCount > 0)
	end
end

function DiskFileHandler:EnterMarryPhoto()
	local mpPath = IOPathConfig.Paths.USER.MarryPhoto
	local capacity = IOPathConfig.Datas.USER.MarryPhoto.LRU_Count or 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	local parentLRUCount = IOPathConfig.Datas.USER.Role.LRU_Count or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(mpPath, capacity, currentServerTime / 1000, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(mpPath, currentServerTime / 1000, parentLRUCount > 0)
	end

	local mpOriginPath = IOPathConfig.Paths.USER.MarryPhotoOrigin
	capacity = IOPathConfig.Datas.USER.MarryPhotoOrigin.LRU_Count or 0
	parentLRUCount = IOPathConfig.Datas.USER.MarryPhoto.LRU_Count or 0
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(mpOriginPath, capacity, currentServerTime / 1000, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(mpOriginPath, currentServerTime / 1000, parentLRUCount > 0)
	end
end

function DiskFileHandler:EnterPrivateChat()
	local pcPath = IOPathConfig.Paths.USER.PrivateChat
	local capacity = IOPathConfig.Datas.USER.PrivateChat.LRU_Count or 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	local parentLRUCount = IOPathConfig.Datas.USER.Server.LRU_Count
	parentLRUCount = parentLRUCount or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(pcPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(pcPath, currentServerTime, parentLRUCount > 0)
	end
end

function DiskFileHandler:EnterChat()
	local chatPath = IOPathConfig.Paths.USER.Chat
	local capacity = IOPathConfig.Datas.USER.Chat.LRU_Count or 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	local parentLRUCount = IOPathConfig.Datas.USER.Server.LRU_Count or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(chatPath, capacity, currentServerTime, parentLRUCount > 0, false)
	else
		DiskFileManager.Instance:InitializeDirectory(chatPath, currentServerTime, parentLRUCount > 0)
	end

	local chatSpeechPath = IOPathConfig.Paths.USER.ChatSpeech
	local capacity = IOPathConfig.Datas.USER.ChatSpeech.LRU_Count or 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	local parentLRUCount = IOPathConfig.Datas.USER.Chat.LRU_Count or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(chatSpeechPath, capacity, currentServerTime, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(chatSpeechPath, currentServerTime, parentLRUCount > 0)
	end
end

function DiskFileHandler:EnterPublicPicRoot()
	local publicPicRootPath = IOPathConfig.Paths.PublicPicRoot
	local capacity = IOPathConfig.Datas.PUBLICPIC.Root.LRU_Count or 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(publicPicRootPath, capacity, currentServerTime / 1000, false, false)
	else
		DiskFileManager.Instance:InitializeDirectory(publicPicRootPath, currentServerTime / 1000, false)
	end
end

function DiskFileHandler:EnterActivityPicture()
	local apPath = IOPathConfig.Paths.PUBLICPIC.ActivityPicture
	local capacity = IOPathConfig.Datas.PUBLICPIC.ActivityPicture.LRU_Count or 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	local parentLRUCount = IOPathConfig.Datas.PUBLICPIC.Root.LRU_Count or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(apPath, capacity, currentServerTime / 1000, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(apPath, currentServerTime / 1000, parentLRUCount > 0)
	end
end

function DiskFileHandler:EnterLotteryPicture()
	local apPath = IOPathConfig.Paths.PUBLICPIC.LotteryPicture
	local capacity = IOPathConfig.Datas.PUBLICPIC.LotteryPicture.LRU_Count or 0
	local currentServerTime = ServerTime.CurServerTime() or -1
	local parentLRUCount = IOPathConfig.Datas.PUBLICPIC.Root.LRU_Count or 0
	if (capacity > 0) then
		DiskFileManager.Instance:InitializeLRUDirectory(apPath, capacity, currentServerTime / 1000, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(apPath, currentServerTime / 1000, parentLRUCount > 0)
	end
end

function DiskFileHandler:EnterDirectory(path, pCapacity, parent_lru_count)
	local capacity = pCapacity or 0
	local parentLRUCount = parent_lru_count or 0
	local currentServerTime = ServerTime.CurServerTime()
	if currentServerTime ~= nil then
		currentServerTime = currentServerTime / 1000
	else
		currentServerTime = -1
	end
	if capacity > 0 then
		DiskFileManager.Instance:InitializeLRUDirectory(path, capacity, currentServerTime, parentLRUCount > 0, true)
	else
		DiskFileManager.Instance:InitializeDirectory(path, currentServerTime, parentLRUCount > 0)
	end
end

function DiskFileHandler.GetCurrentServerTime()
	local currentServerTime = ServerTime.CurServerTime()
	if currentServerTime ~= nil then
		currentServerTime = currentServerTime / 1000
	else
		currentServerTime = -1
	end
	return currentServerTime
end