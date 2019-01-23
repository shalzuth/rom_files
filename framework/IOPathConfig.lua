local IOPathConfig = {}
IOPathConfig.Paths = {}
IOPathConfig.Paths.Root = "Users"
IOPathConfig.Paths.PublicPicRoot = "PublicPicRoot"

function IOPathConfig.Init(userGuid,server,roleID)
	IOPathConfig.userGuid = userGuid
	IOPathConfig.server = server
	IOPathConfig.Paths.USER = {}
	IOPathConfig.Paths.USER.UserGuid = IOPathConfig.Paths.Root.."/"..tostring(userGuid)
	IOPathConfig.Paths.USER.Server = IOPathConfig.Paths.USER.UserGuid.."/"..tostring(server)
	IOPathConfig.Paths.USER.Role = IOPathConfig.Paths.USER.Server .. '/' .. tostring(roleID)
	--景点
	IOPathConfig.Paths.USER.ScenicSpot = IOPathConfig.Paths.USER.Role.."/ScenicSpot"
	--景点/预览
	IOPathConfig.Paths.USER.ScenicSpotPreview = IOPathConfig.Paths.USER.ScenicSpot.."/Preview"
	--景点/照片
	IOPathConfig.Paths.USER.ScenicSpotPhoto = IOPathConfig.Paths.USER.ScenicSpot.."/Photo"
	-- union photo
	IOPathConfig.Paths.USER.UnionWallPhoto = IOPathConfig.Paths.USER.Role .. '/UnionWallPhoto'
	IOPathConfig.Paths.USER.UnionWallPhotoOrigin = IOPathConfig.Paths.USER.UnionWallPhoto .. '/Origin'
	IOPathConfig.Paths.USER.UnionWallPhotoThumbnail = IOPathConfig.Paths.USER.UnionWallPhoto .. '/Thumbnail'
	-- personal photo
	IOPathConfig.Paths.USER.PersonalPhoto = IOPathConfig.Paths.USER.Role .. '/PersonalPhoto'
	IOPathConfig.Paths.USER.PersonalPhotoOrigin = IOPathConfig.Paths.USER.PersonalPhoto .. '/Origin'
	IOPathConfig.Paths.USER.PersonalPhotoThumbnail = IOPathConfig.Paths.USER.PersonalPhoto .. '/Thumbnail'
	-- union logo
	IOPathConfig.Paths.USER.UnionLogo = IOPathConfig.Paths.USER.Role .. '/UnionLogo'
	IOPathConfig.Paths.USER.UnionLogoOrigin = IOPathConfig.Paths.USER.UnionLogo .. '/Origin'
	IOPathConfig.Paths.USER.UnionLogoThumbnail = IOPathConfig.Paths.USER.UnionLogo .. '/Thumbnail'
	-- marry photo
	IOPathConfig.Paths.USER.MarryPhoto = IOPathConfig.Paths.USER.Role .. '/MarryPhoto'
	IOPathConfig.Paths.USER.MarryPhotoOrigin = IOPathConfig.Paths.USER.MarryPhoto .. '/Origin'
	IOPathConfig.Paths.USER.MarryPhotoThumbnail = IOPathConfig.Paths.USER.MarryPhoto .. '/Thumbnail'
	--私聊
	IOPathConfig.Paths.USER.PrivateChat = IOPathConfig.Paths.USER.Role.."/PrivateChat"
	--私聊/对象id
	IOPathConfig.Paths.USER.PrivateChatUser = IOPathConfig.Paths.USER.PrivateChat.."/%s"
	IOPathConfig.Paths.USER.Chat = IOPathConfig.Paths.USER.Role .. "/Chat"
	IOPathConfig.Paths.USER.ChatSpeech = IOPathConfig.Paths.USER.Chat .. "/Speech"

	IOPathConfig.Paths.PUBLICPIC = {}
	IOPathConfig.Paths.PUBLICPIC.ActivityPicture = IOPathConfig.Paths.PublicPicRoot.."/ActivityPicture"
	IOPathConfig.Paths.PUBLICPIC.LotteryPicture = IOPathConfig.Paths.PublicPicRoot.."/LotteryPicture"

	IOPathConfig.Paths.Extension = {}
	IOPathConfig.Paths.Extension.Root = 'UsersExtension'
	IOPathConfig.Paths.Extension.Account = IOPathConfig.Paths.Extension.Root .. '/Account'
	IOPathConfig.Paths.Extension.AccountX = IOPathConfig.Paths.Extension.Account .. '/' .. tostring(userGuid)
	IOPathConfig.Paths.Extension.Server = IOPathConfig.Paths.Extension.AccountX .. '/Server'
	IOPathConfig.Paths.Extension.ServerX = IOPathConfig.Paths.Extension.Server .. '/' .. tostring(server)
	IOPathConfig.Paths.Extension.GamePhoto = IOPathConfig.Paths.Extension.ServerX .. '/GamePhoto'
	IOPathConfig.Paths.Extension.ScenicSpotPhoto = IOPathConfig.Paths.Extension.GamePhoto .. '/ScenicSpotPhoto'
	IOPathConfig.Paths.Extension.ScenicSpotPhotoShare = IOPathConfig.Paths.Extension.ScenicSpotPhoto .. '/SharePhoto'
	IOPathConfig.Paths.Extension.ScenicSpotPhotoShareOrigin = IOPathConfig.Paths.Extension.ScenicSpotPhotoShare .. '/Origin'
	IOPathConfig.Paths.Extension.ScenicSpotPhotoShareThumbnail = IOPathConfig.Paths.Extension.ScenicSpotPhotoShare .. '/Thumbnail'
	IOPathConfig.Paths.Extension.ScenicSpotPhotoRoles = IOPathConfig.Paths.Extension.ScenicSpotPhoto .. '/RolesPhoto'
	IOPathConfig.Paths.Extension.ScenicSpotPhotoRolesOrigin = IOPathConfig.Paths.Extension.ScenicSpotPhotoRoles .. '/Origin'
	IOPathConfig.Paths.Extension.ScenicSpotPhotoRolesThumbnail = IOPathConfig.Paths.Extension.ScenicSpotPhotoRoles .. '/Thumbnail'

	IOPathConfig.Datas = {}
	--玩家账户相关
	IOPathConfig.Datas.USER = {
		Root = {Directory = IOPathConfig.Paths.Root,LRU_Count=1},
		UserGuid = {Directory = IOPathConfig.Paths.USER.UserGuid ,LRU_Count=2},
		Server = {Directory = IOPathConfig.Paths.USER.Server},
		Role = {Directory = IOPathConfig.Paths.USER.Role},
		ScenicSpot = {Directory = IOPathConfig.Paths.USER.ScenicSpot},
		ScenicSpotPreview = {Directory = IOPathConfig.Paths.USER.ScenicSpotPreview},
		ScenicSpotPhoto = {Directory = IOPathConfig.Paths.USER.ScenicSpotPhoto ,LRU_Count = 40},
		UnionWallPhoto = {Directory = IOPathConfig.Paths.USER.UnionWallPhoto},
		UnionWallPhotoOrigin = {Directory = IOPathConfig.Paths.USER.UnionWallPhotoOrigin, LRU_Count = 50},
		UnionWallPhotoThumbnail = {Directory = IOPathConfig.Paths.USER.UnionWallPhotoThumbnail, LRU_Count = 500},
		PersonalPhoto = {Directory = IOPathConfig.Paths.USER.PersonalPhoto},
		PersonalPhotoOrigin = {Directory = IOPathConfig.Paths.USER.PersonalPhotoOrigin, LRU_Count = 50},
		PersonalPhotoThumbnail = {Directory = IOPathConfig.Paths.USER.PersonalPhotoThumbnail, LRU_Count = 500},
		UnionLogo = {Directory = IOPathConfig.Paths.USER.UnionLogo},
		UnionLogoOrigin = {Directory = IOPathConfig.Paths.USER.UnionLogoOrigin, LRU_Count = 50},
		UnionLogoThumbnail = {Directory = IOPathConfig.Paths.USER.UnionLogoThumbnail, LRU_Count = 500},
		MarryPhoto = {Directory = IOPathConfig.Paths.USER.MarryPhoto},
		MarryPhotoOrigin = {Directory = IOPathConfig.Paths.USER.MarryPhotoOrigin, LRU_Count = 10},
		MarryPhotoThumbnail = {Directory = IOPathConfig.Paths.USER.MarryPhotoThumbnail, LRU_Count = 100},
		PrivateChat = {Directory = IOPathConfig.Paths.USER.PrivateChat},
		PrivateChatUser = {Directory = IOPathConfig.Paths.USER.PrivateChatUser},
		Chat = {Directory = IOPathConfig.Paths.USER.Chat},
		ChatSpeech = {Directory = IOPathConfig.Paths.USER.ChatSpeech, LRU_Count = 10}
	}

	--公共
	IOPathConfig.Datas.PUBLICPIC = {
		Root = {Directory = IOPathConfig.Paths.PublicPicRoot},
		ActivityPicture = { Directory = IOPathConfig.Paths.PUBLICPIC.ActivityPicture,LRU_Count = 30},
		LotteryPicture = {Directory = IOPathConfig.Paths.PUBLICPIC.LotteryPicture, LRU_Count = 10}
	}

	IOPathConfig.Datas.Extension = {}
	IOPathConfig.Datas.Extension.Root = {}
	IOPathConfig.Datas.Extension.Account = {LRUCount = 1}
	IOPathConfig.Datas.Extension.AccountX = {}
	IOPathConfig.Datas.Extension.Server = {LRUCount = 1}
	IOPathConfig.Datas.Extension.ServerX = {}
	IOPathConfig.Datas.Extension.GamePhoto = {}
	IOPathConfig.Datas.Extension.ScenicSpotPhoto = {}
	IOPathConfig.Datas.Extension.ScenicSpotPhotoShare = {}
	-- caculate params
	-- device disk size 16G
	-- app percent 80%
	-- ro app percent 50%
	-- create 3 roles
	-- game photo percent 100%
	-- personal photo 60
	-- scenic spot photo 162
	-- union wall photo 840
	-- union logo 32
	IOPathConfig.Datas.Extension.ScenicSpotPhotoShareOrigin = {LRUCount = 50}
	IOPathConfig.Datas.Extension.ScenicSpotPhotoShareThumbnail = {LRUCount = 500}
	IOPathConfig.Datas.Extension.ScenicSpotPhotoRoles = {}
	IOPathConfig.Datas.Extension.ScenicSpotPhotoRolesOrigin = {LRUCount = 50}
	IOPathConfig.Datas.Extension.ScenicSpotPhotoRolesThumbnail = {LRUCount = 500}
end

return IOPathConfig