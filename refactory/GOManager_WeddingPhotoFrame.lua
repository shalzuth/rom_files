autoImport("GOManager_ScenePhotoFrame")
GOManager_WeddingPhotoFrame = class("GOManager_WeddingPhotoFrame",GOManager_ScenePhotoFrame)

function GOManager_WeddingPhotoFrame:OnClick(obj)
	local renderer = self.renderers[obj.ID]
	helplog("OnClick")
	if nil ~= renderer then
		Game.WeddingWallPicManager:ClickFrame(obj.ID,renderer)
	else
		Game.WeddingWallPicManager:ClickFrame(obj.ID,obj)
	end
end

