PermissionUtil = {}

local isAndroid = (RuntimePlatform.Android == Application.platform)

function PermissionUtil.Access_SavePicToMediaStorage(callback)
	callback()
--	if isAndroid then
--		OverSeas_TW.OverSeasManager.GetInstance():AndroidPermissionCamera(function()
--			callback()
--		end)
--	else
--		callback()
--	end


	--	if(not PermissionUtil.Access_Camera()) then
	--		return false
	--	end
	--	return PermissionUtil.Access_WriteMediaStorage()
end

function PermissionUtil.Access_Camera()
	if isAndroid then
		helplog("Access_Camera")
	end
	return true
end

-- function PermissionUtil.Access_WriteExternalStorage()
-- 	if isAndroid then
-- 		helplog("Access_WriteExternalStorage")
-- 	end
-- 	return true
-- end

-- function PermissionUtil.Access_ReadExternalStorage()
-- 	if isAndroid then
-- 		helplog("Access_ReadExternalStorage")
-- 	end
-- 	return true
-- end

-- function PermissionUtil.Access_ReadPhoneState()
-- 	if isAndroid then
-- 		helplog("Access_ReadPhoneState")
-- 	end
-- 	return true
-- end

function PermissionUtil.Access_WriteMediaStorage()
	if isAndroid then
		helplog("Access_WriteMediaStorage")
	end
	return true
end

function PermissionUtil.Access_RecordAudio(callback)
	if isAndroid then
		OverSeas_TW.OverSeasManager.GetInstance():AndroidPermissionAudio(function()
			callback()
		end)
	else
		callback()
	end


	--	if isAndroid then
	--		helplog("Access_RecordAudio")
	--	end
	--	return true
end