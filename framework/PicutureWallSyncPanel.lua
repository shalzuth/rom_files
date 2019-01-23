autoImport("PersonalPicturePanel")
PicutureWallSyncPanel = class("PicutureWallSyncPanel", PersonalPicturePanel);
autoImport("PictureWallPersonalListPage")
autoImport("PictureWallSceneryListPage")
autoImport("PersonalPicturCombineItemWallCell")

PicutureWallSyncPanel.PictureSyncFrom = {
	GuildWall = 1,
	WeddingWall = 2,
	WeddingCertificate = 3,
	WeddingCertificateDiy = 4,
}

PicutureWallSyncPanel.CellSelectedChange = "PicutureWallSyncPanel_CellSelectedChange"
PicutureWallSyncPanel.CheckCurPicIsShow = "PicutureWallSyncPanel_CheckCurPicIsShow"

PicutureWallSyncPanel.ViewType = UIViewType.PopUpLayer
function PicutureWallSyncPanel:Init()
	-- body
	self:initData()
	self:initView()
	self:AddEvents()
	self:refreshCurState()
end

function PicutureWallSyncPanel:AddEvents(  )
	self:AddListenEvt(PictureWallDataEvent.MapEnd,self.MapEnd);
	self:AddListenEvt(PictureWallDataEvent.SelectedPicChange,self.UpdateList);
	self:AddListenEvt(ServiceEvent.PhotoCmdQueryFramePhotoListPhotoCmd,self.UpdateList);
end

function PicutureWallSyncPanel:MapEnd(  )
	self:CloseSelf()
end

function PicutureWallSyncPanel:UpdateList(  )	
	self.PersonalListPage:UpdateList()
	self.SceneryListPage:UpdateList()
	self:refreshCurState()
end

function PicutureWallSyncPanel:OnExit(  )
	-- body
	PicutureWallSyncPanel.super.OnExit(self)
	PhotoDataProxy.Instance:clearSelectedData()
	PhotoDataProxy.Instance:clearRemoveData()
end

function PicutureWallSyncPanel:initData(  )	
	self.totalSize = PhotoDataProxy.Instance:getUploadedPhotoSize()
	self.frameId = self.viewdata.viewdata.frameId
	self.from = self.viewdata.viewdata.from
end

function PicutureWallSyncPanel:initView(  )
	-- body
	self:AddTabChangeEvent(self:FindGO("PersonalTab"),self:FindGO("PersonalListPage"),PersonalPicturePanel.Album.PersonalAlbum)
	self:AddTabChangeEvent(self:FindGO("SceneryTab"),self:FindGO("SceneryListPage"),PersonalPicturePanel.Album.SceneryAlbum)
	
	self.PersonalListPage = self:AddSubView("PersonalListPage",PictureWallPersonalListPage)
	self.SceneryListPage = self:AddSubView("SceneryListPage",PictureWallSceneryListPage)

	self.albumState = self:FindComponent("albumState",UILabel)
	self.albumState.text = ZhString.PersonalPicturePanel_AlbumStateFull

	if(self.from == PicutureWallSyncPanel.PictureSyncFrom.WeddingWall)then
		self:Hide(self.albumState)
	else
		self:Show(self.albumState)
	end

	self.PersonalTabLabel = self:FindComponent("PersonalTabLabel",UILabel)
	self.SceneryTabLabel = self:FindComponent("SceneryTabLabel",UILabel)
	self:TabChangeHandler(PersonalPicturePanel.Album.PersonalAlbum)
	-- EFRAMEACTION_UPLOAD = 1;
	-- EFRAMEACTION_REMOVE
	self.curState = self:FindComponent("CurState",UILabel)
	self:AddButtonEvent("SyncDataBtn",function ( ... )
		-- body
		if(PhotoDataProxy.Instance:checkPhotoSyncPermission())then
			PhotoDataProxy.Instance:StartSyncPictureWallFrame(self.frameId)
			self:CloseSelf()			
		else
			MsgManager.ShowMsgByIDTable(998)
		end
	end)
end

function PicutureWallSyncPanel:RemovePhotoData( cell )
	-- body
	PhotoDataProxy.Instance:RemovePhotoData(cell)
	self:refreshCurState()
end

function PicutureWallSyncPanel:AddPhotoData( cell )
	PhotoDataProxy.Instance:AddPhotoData(cell)
	self:refreshCurState()
end

function PicutureWallSyncPanel:refreshCurState(  )
	-- body
	-- if(self.totalSize == -1)then
	-- 	self:Hide(self.curState.transform.parent.gameObject)
	-- else
	-- 	self:Show(self.curState.transform.parent.gameObject)
	-- 	local curSize = PhotoDataProxy.Instance:getCurUpSize()
	-- 	self.curState.text = string.format(ZhString.PersonalPictureCell_CurSyncState,curSize,self.totalSize)
	-- end
end

function PicutureWallSyncPanel:CheckCurPicIsShow( cellCtl )
	-- body
	local data = cellCtl.data
	local uploadData = PhotoDataProxy.Instance:checkPhotoFrame(data,self.frameId)
	local find = false
	if(uploadData)then
		for i=1,#uploadData do
			local single = uploadData[i]
			if(single.frameid == self.frameId)then
				find = true
				break
			end
		end
		if(not find)then
			cellCtl:setShowTipDes(true,false)
		else
			isCurrent = true
			cellCtl:setShowTipDes(true,true)
		end
	else
		cellCtl:setShowTipDes(false)		
	end
end

function PicutureWallSyncPanel:handleCategorySelect( key )
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