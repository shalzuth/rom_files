autoImport("PicutureWallSyncPanel")
WeddingWallPictureSyncPanel = class("WeddingWallPictureSyncPanel", PicutureWallSyncPanel);
autoImport("PictureWallPersonalListPage")
autoImport("PictureWallSceneryListPage")
autoImport("PersonalPicturCombineItemWallCell")


WeddingWallPictureSyncPanel.CellSelectedChange = "WeddingWallPictureSyncPanel_CellSelectedChange"
WeddingWallPictureSyncPanel.CheckCurPicIsShow = "WeddingWallPictureSyncPanel_CheckCurPicIsShow"

WeddingWallPictureSyncPanel.ViewType = UIViewType.PopUpLayer

WeddingWallPictureSyncPanel.Album = {
	PersonalAlbum = 1,
	SceneryAlbum = 2,
}

function WeddingWallPictureSyncPanel:initData(  )	
	self.totalSize = GameConfig.WeddingWallTotalUpSize or 10
	self.frameId = self.viewdata.viewdata.frameId
end

function WeddingWallPictureSyncPanel:handleCategorySelect( key )
	-- body		
	if(key == PersonalPicturePanel.Album.PersonalAlbum)then
		local size = PhotoDataProxy.Instance:getUploadedSizeByAlbum(ProtoCommon_pb.ESOURCE_PHOTO_SELF)
		self.albumState.text = string.format(ZhString.PersonalPictureCell_CurAlbumState,size)
	elseif(key == PersonalPicturePanel.Album.SceneryAlbum)then
		local size = PhotoDataProxy.Instance:getUploadedSizeByAlbum(ProtoCommon_pb.ESOURCE_PHOTO_SCENERY)
		self.albumState.text = string.format(ZhString.PersonalPictureCell_CurAlbumState,size)
		if(self.SceneryListPage)then
			self.SceneryListPage:ResetPosition()
		end
	end
end