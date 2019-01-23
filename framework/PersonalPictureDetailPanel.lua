PersonalPictureDetailPanel = class("PersonalPictureDetailPanel", ContainerView)
PersonalPictureDetailPanel.picNameName = "RO_Picture"

function PersonalPictureDetailPanel:Init()
	self:initView()
	self:initData()
	self:AddEventListener()
	self:AddViewEvts()
end

function PersonalPictureDetailPanel:AddViewEvts()
	self:AddListenEvt(PersonalPictureManager.PersonalOriginPhotoDownloadCompleteCallback ,self.photoCompleteCallback);
	self:AddListenEvt(PersonalPictureManager.PersonalOriginPhotoDownloadProgressCallback ,self.photoProgressCallback);

	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadCompleteCallback ,self.photoCompleteCallback);
	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadProgressCallback ,self.photoProgressCallback);
	self:AddListenEvt(PictureWallDataEvent.MapEnd,self.MapEnd);
end

function PersonalPictureDetailPanel:MapEnd( note )
	if(self.from)then
		self:CloseSelf()
	end
end

function PersonalPictureDetailPanel:photoCompleteCallback( note )
	-- body
	local data = note.body
	if(self.index == data.index)then
		self:completeCallback(data.byte)
	end
end

function PersonalPictureDetailPanel:photoProgressCallback( note )
	-- body
	local data = note.body
	-- printRed("PersonalPictureDetailPanel photoProgressCallback",data.progress)
	if(self.index == data.index)then
		self:progressCallback(data.progress)
	end
end

function PersonalPictureDetailPanel:initData(  )
	-- body
	self.PhotoData = self.viewdata.viewdata.PhotoData
	self.index = self.PhotoData.index
	self.from = self.viewdata.viewdata.from
	self.frameId = self.viewdata.viewdata.frameId
	self.isThumbnail = false
	self.canbeShare = false
	self:initDefaultTextureSize()
	LeanTween.cancel(self.gameObject)
	LeanTween.delayedCall(self.gameObject,0.1,function (  )
		self:getPhoto()
	end)

	if((self.PhotoData and self.PhotoData.type == PhotoDataProxy.PhotoType.SceneryPhotoType and not self.from))then
		self:Hide(self.delBtn)
	end

	if(self.from)then
		self:checkHasSelected()
		-- self:Show(self.checkBoxCt.gameObject)
	else
		self:Hide(self.tipDesCt)
		-- self:Hide(self.hasUpOtherFrame.gameObject)
		-- self:Hide(self.checkBoxCt.gameObject)
		-- self:Hide(self.star)
	end

end

function PersonalPictureDetailPanel:checkHasSelected(  )
	local uploadData = PhotoDataProxy.Instance:checkPhotoFrame(self.PhotoData,self.frameId)
	local isCurrent = false
	if(uploadData)then
		self:Show(self.tipDesCt)
		local find = false
		for i=1,#uploadData do
			local single = uploadData[i]
			if(single.frameid == self.frameId)then
				find = true
				break
			end
		end

		if(not find)then
			-- self:Show(self.star)
			self.tipDesLabel.text = ZhString.PersonalPictureCell_DetailPictureShowOther
			-- self:Show(self.hasUpOtherFrame.gameObject)
		else
			isCurrent = true
			self.tipDesLabel.text = ZhString.PersonalPictureCell_DetailPictureShowCur
			-- self:Hide(self.star)
			-- self:Hide(self.hasUpOtherFrame.gameObject)
		end
		self.delBtnSp.spriteName = "photo_icon_remove"
	else
		self:Hide(self.tipDesCt)
		self.delBtnSp.spriteName = "photo_icon_update"
		-- self:Hide(self.star)
		-- self:Hide(self.hasUpOtherFrame.gameObject)
	end
	self.delBtnSp:MakePixelPerfect()
	-- local selectedData = PhotoDataProxy.Instance:GetSelectedDataByPhotoData(self.PhotoData)
	-- local removeData = PhotoDataProxy.Instance:GetRemovedDataByPhotoData(self.PhotoData)
	-- if(selectedData or (uploadData and not removeData))then
	-- 	self.checkBox.value = true
	-- else
	-- 	self.checkBox.value = false
	-- end
end

function PersonalPictureDetailPanel:initView(  )
	-- body
	self.photo = self:FindGO("photo"):GetComponent(UITexture)
	self.noneTxIcon = self:FindGO("noneTxIcon"):GetComponent(UISprite)
	self.progress = self:FindGO("loadProgress"):GetComponent(UILabel)
	self:Hide(self.progress.gameObject)
	self.delBtn = self:FindGO("delBtn")
	self.shareBtn = self:FindGO("shareBtn")
	self.closeShare = self:FindGO("closeShare")
	self.confirmBtn = self:FindGO("confirmBtn")
	self:AddClickEvent(self.confirmBtn,function ( go )
		-- body			
		self:savePicture()
		self:CloseSelf()
	end)
	self:AddClickEvent(self.closeShare,function (  )
		-- body
		self:Hide(self.goUIViewSocialShare)
	end)

	self:AddClickEvent(self.shareBtn,function (  )
		-- body
--		self:Show(self.goUIViewSocialShare)
		--todo xde 修改为fb分享
		self:sharePicture('', '', '')
	end)

	self.checkBox = self:FindComponent("selectedBg",UIToggle)
	self.delBtnSp = self:FindComponent("Sprite",UISprite,self.delBtn)
	-- self.checkBoxCt = self:FindGO("checkBox")
	-- self.checkboxAnchor = self:FindComponent("checkBox",UIWidget)
	-- self:AddButtonEvent("checkBox",function (  )
	-- 	-- body
	-- 	self:CheckBoxChange()
	-- end)
	-- self.hasUpOtherFrame = self:FindComponent("hasUpOtherFrame",UILabel)
	-- self.hasUpOtherFrame.text = ZhString.PersonalPictureCell_HasUpOtherFrame

	-- self.star = self:FindGO("star")

	self:GetGameObjects()
	self:RegisterButtonClickEvent()

	self.tipDesCt = self:FindGO("tipDesCt")
	self.tipDesLabel = self:FindComponent("tipDesLabel",UILabel)
end

function PersonalPictureDetailPanel:savePicture(  )
	-- body
	--todo xde
	PermissionUtil.Access_SavePicToMediaStorage(function()
		if(self.photo.mainTexture)then
			local picName = PersonalPictureDetailPanel.picNameName
			local path = PathUtil.GetSavePath(PathConfig.PhotographPath).."/"..picName
			ScreenShot.SaveJPG(self.photo.mainTexture,path,100)
			path = path..".jpg"
			ExternalInterfaces.SavePicToDCIM(path)
			MsgManager.ShowMsgByID(907)
		end
	end)
end

-- function PersonalPictureDetailPanel:CheckBoxChange(  )
-- 	local value = self.checkBox.value
-- 	if(value)then
-- 		 PhotoDataProxy.Instance:DetailPicUnSelected( self.PhotoData )
-- 		 self.checkBox.value = false
-- 	else
-- 		local bRet = PhotoDataProxy.Instance:DetailPicSelected( self.PhotoData )
-- 		if(bRet)then
-- 			self.checkBox.value = true
-- 		end
-- 	end
-- 	self:sendNotification(PictureWallDataEvent.SelectedPicChange)
-- end

function PersonalPictureDetailPanel:initDefaultTextureSize(  )
	-- body
	self.originWith = self.photo.width
	self.originHeight = self.photo.height
end

function PersonalPictureDetailPanel:setTexture( texture )
	-- body
	local orginRatio = self.originWith / self.originHeight 
	local textureRatio =  texture.width / texture.height
	local wRatio = math.min(orginRatio,textureRatio) == orginRatio
	local height = self.originHeight 
	local width = self.originWith
	if(wRatio)then
		height = self.originWith/textureRatio
	else
		width = self.originHeight*textureRatio
	end
	Object.DestroyImmediate(self.photo.mainTexture)
	self.photo.width = width
	self.photo.height = height
	self.photo.mainTexture = texture
	-- self.checkboxAnchor:UpdateAnchors()
end

function PersonalPictureDetailPanel:AddEventListener( )
	-- body
	self:AddClickEvent(self.delBtn,function ( go )
		-- body
		if(not _G["PicutureWallSyncPanel"])then
			autoImport("PicutureWallSyncPanel")
		end
		if(self.from == PicutureWallSyncPanel.PictureSyncFrom.GuildWall or self.from == PicutureWallSyncPanel.PictureSyncFrom.WeddingWall)then
			local uploadData = PhotoDataProxy.Instance:checkPhotoFrame(self.PhotoData,self.frameId)
			local action = PhotoCmd_pb.EFRAMEACTION_UPLOAD
			local list = {{source = self.PhotoData.source,sourceid = self.PhotoData.sourceid}}
			local frameId = self.frameId
			if(uploadData)then
				action = PhotoCmd_pb.EFRAMEACTION_REMOVE
				if(#uploadData>0 and self.from == PicutureWallSyncPanel.PictureSyncFrom.GuildWall)then
					frameId = uploadData[1].frameid
				end				
			else
				local count = PhotoDataProxy.Instance:getCurUpSize()
				if(PhotoDataProxy.Instance.totoalUpSize ~= -1 and count >= PhotoDataProxy.Instance.totoalUpSize)then
					MsgManager.ShowMsgByIDTable(999)
					return
				end
			end
			ServicePhotoCmdProxy.Instance:CallFrameActionPhotoCmd(frameId,action,list)
			self:CloseSelf()
		elseif(self.from == PicutureWallSyncPanel.PictureSyncFrom.WeddingCertificate or self.from == PicutureWallSyncPanel.PictureSyncFrom.WeddingCertificateDiy)then
			if(self.canbeShare)then
				Game.WeddingWallPicManager:UploadWeddingPicture(self.photo.mainTexture,self.PhotoData.index,self.PhotoData.time,self.from)
				self:CloseSelf()
			else
				MsgManager.FloatMsg(nil,ZhString.WeddingPictureDownloading)
				return
			end
		else
			MsgManager.ConfirmMsgByID(993, function ()
				PersonalPictureManager.Instance():removePhotoFromeAlbum(self.index,self.PhotoData.time)
				self:CloseSelf()
			end, nil)
		end
	end)

	self:AddButtonEvent("closeBtn",function ( go )
		-- body
		self:CloseSelf();
	end)
end

function PersonalPictureDetailPanel:getPhoto(  )
	-- body
	if(self.PhotoData and self.PhotoData.type == PhotoDataProxy.PhotoType.SceneryPhotoType)then
		local tBytes = ScenicSpotPhotoNew.Ins():TryGetThumbnailFromLocal_Share(self.index,self.PhotoData.time)
		if(tBytes)then
			self:completeCallback(tBytes,true)
		end
		MySceneryPictureManager.Instance():tryGetMySceneryOriginImage(self.PhotoData.roleId,self.index,self.PhotoData.time)
	else
		local tBytes = PersonalPhoto.Ins():TryGetThumbnailFromLocal(self.index,self.PhotoData.time,true)
		if(tBytes)then
			self:completeCallback(tBytes,true)
		end
		PersonalPictureManager.Instance():tryGetOriginImage(self.index,self.PhotoData.time)
	end
end

function PersonalPictureDetailPanel:getPhotoPath(  )
	-- body
	if(self.PhotoData and self.PhotoData.type == PhotoDataProxy.PhotoType.SceneryPhotoType)then
		return ScenicSpotPhotoNew.Ins():GetLocalAbsolutePath_Share(self.index, true)
	else
		return PersonalPhoto.Ins():GetLocalAbsolutePath(self.index, true)
	end	
end

function PersonalPictureDetailPanel:sharePicture(platform_type, content_title, content_body)
	-- body
	if(self.canbeShare)then
		local path = self:getPhotoPath()
		self:Log("sharePicture pic path:",path)
		if(path and path ~= "")then
			--todo xde 分享修改
			local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
			overseasManager:ShareImg(path,content_title,'',content_body,function(msg)
				ROFileUtils.FileDelete(path)
				if(msg == "1")then
					self:CloseSelf();
					MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
				else
					MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
				end
			end)
			
			
--			SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function ( succMsg)
--				-- body
--				self:Log("SocialShare.Instance:Share success")
--				if platform_type == E_PlatformType.Sina then
--					MsgManager.ShowMsgByIDTable(566)
--				end
--				ROFileUtils.FileDelete(path)
--			end,function ( failCode,failMsg)
--				-- body
--				self:Log("SocialShare.Instance:Share failure")
--
--				local errorMessage = failMsg or 'error'
--				if failCode ~= nil then
--					errorMessage = failCode .. ', ' .. errorMessage
--				end
--				ROFileUtils.FileDelete(path)
--				MsgManager.ShowMsg('', errorMessage, MsgManager.MsgType.Float)
--			end,function (  )
--				-- body
--				self:Log("SocialShare.Instance:Share cancel")
--				ROFileUtils.FileDelete(path)
--			end)
		else
			MsgManager.FloatMsg(nil,ZhString.ShareAwardView_EmptyPath)
		end
		return true
	end
	return false
end

function PersonalPictureDetailPanel:progressCallback( progress )
	-- body
	self:Show(self.progress.gameObject)
	progress = progress >=1 and 1 or progress
	local value = progress*100
	value = math.floor(value)
	self.progress.text = value.."%"
end

function PersonalPictureDetailPanel:completeCallback(bytes,thumbnail )
	-- body
	if(not thumbnail)then
		self:Hide(self.progress.gameObject)		
	end
	self.isThumbnail = thumbnail
	if(bytes)then
		local texture = Texture2D(0,0,TextureFormat.RGB24,false)
		local bRet = ImageConversion.LoadImage(texture, bytes)
		if( bRet)then
			self.canbeShare = not thumbnail	
			self:setTexture(texture)
		else
			Object.DestroyImmediate(texture)
		end
	end
end

function PersonalPictureDetailPanel:OnExit(  )
	-- body
	LeanTween.cancel(self.gameObject)
	Object.DestroyImmediate(self.photo.mainTexture)
end

function PersonalPictureDetailPanel:GetGameObjects()
	self.goUIViewSocialShare = self:FindGO('UIViewSocialShare', self.gameObject)
	self.goButtonWechatMoments = self:FindGO('WechatMoments', self.goUIViewSocialShare)
	self.goButtonWechat = self:FindGO('Wechat', self.goUIViewSocialShare)
	self.goButtonQQ = self:FindGO('QQ', self.goUIViewSocialShare)
	self.goButtonSina = self:FindGO('Sina', self.goUIViewSocialShare)

	local enable = FloatAwardView.ShareFunctionIsOpen(  )
	if not enable then
		self:Hide(self.shareBtn)
	end
end

function PersonalPictureDetailPanel:RegisterButtonClickEvent()
	self:AddClickEvent(self.goButtonWechatMoments, function ()
		self:OnClickForButtonWechatMoments()
	end)
	self:AddClickEvent(self.goButtonWechat, function ()
		self:OnClickForButtonWechat()
	end)
	self:AddClickEvent(self.goButtonQQ, function ()
		self:OnClickForButtonQQ()
	end)
	self:AddClickEvent(self.goButtonSina, function ()
		self:OnClickForButtonSina()
	end)
end

function PersonalPictureDetailPanel:OnClickForButtonWechatMoments()
	if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
		local result = self:sharePicture(E_PlatformType.WechatMoments, '', '')
		if(result)then
			self:CloseSelf();
		else
			MsgManager.ShowMsgByID(559)
		end
	else
		MsgManager.ShowMsgByIDTable(561)
	end
end

function PersonalPictureDetailPanel:OnClickForButtonWechat()
	if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
		local result = self:sharePicture(E_PlatformType.Wechat, '', '')
		if(result)then
			self:CloseSelf();
		else
			MsgManager.ShowMsgByID(559)
		end
	else
		MsgManager.ShowMsgByIDTable(561)
	end
end

function PersonalPictureDetailPanel:OnClickForButtonQQ()
	if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
		local result = self:sharePicture(E_PlatformType.QQ, '', '')
		if(result)then
			self:CloseSelf();
		else
			MsgManager.ShowMsgByID(559)
		end
	else
		MsgManager.ShowMsgByIDTable(562)
	end
end

function PersonalPictureDetailPanel:OnClickForButtonSina()
	if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
		local contentBody = GameConfig.PhotographResultPanel_ShareDescription
		if contentBody == nil or #contentBody <= 0 then
			contentBody = 'RO'
		end
		local result = self:sharePicture(E_PlatformType.Sina, '', contentBody)
		if(result)then
			self:CloseSelf();
		else
			MsgManager.ShowMsgByID(559)
		end
	else
		MsgManager.ShowMsgByIDTable(563)
	end
end
