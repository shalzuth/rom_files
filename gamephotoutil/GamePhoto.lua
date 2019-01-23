GamePhoto = class('GamePhoto')

GamePhoto.divideCharacter = '!'
GamePhoto.upyunOperatorName = 'roxdcdn'

function GamePhoto.SetPlayerAccount(player_account)
	GamePhoto.playerAccount = player_account
end

GamePhoto.photoFileMD5 = {}
function GamePhoto.SetPhotoFileMD5_Scenery(ss_id, md5)
	GamePhoto.photoFileMD5[ss_id .. '_s'] = md5
end
function GamePhoto.GetPhotoFileMD5_Scenery(ss_id)
	return GamePhoto.photoFileMD5[ss_id .. '_s']
end

function GamePhoto.SetPhotoFileMD5_Personal(p_index, md5)
	GamePhoto.photoFileMD5[p_index .. '_p'] = md5
end
function GamePhoto.GetPhotoFileMD5_Personal(p_index)
	return GamePhoto.photoFileMD5[p_index .. '_p']
end

function GamePhoto.SetPhotoFileMD5_UnionLogo(u_index, md5)
	GamePhoto.photoFileMD5[u_index .. 'u'] = md5
end
function GamePhoto.GetPhotoFileMD5_UnionLogo(u_index)
	return GamePhoto.photoFileMD5[u_index .. 'u']
end

function GamePhoto.SetPhotoFileMD5_Marry(p_index, md5)
	GamePhoto.photoFileMD5[p_index .. 'm'] = md5
end
function GamePhoto.GetPhotoFileMD5_Marry(p_index)
	return GamePhoto.photoFileMD5[p_index .. 'm']
end

function GamePhoto.GetTFFromExtension(extension)
	local textureFormat = nil
	if extension == PhotoFileInfo.PictureFormat.PNG then
		textureFormat = TextureFormat.RGBA32
	else
		textureFormat = TextureFormat.RGB24
	end
	return textureFormat
end