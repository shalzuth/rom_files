MarriageManualPicDiy = class("MarriageManualPicDiy", ContainerView)
autoImport("PicutureWallSyncPanel")


MarriageManualPicDiy.ViewType = UIViewType.PopUpLayer

MarriageManualPicDiy.BgTextureName = "marry_bg_bottom1";

function MarriageManualPicDiy:Init()
	self:AddViewEvts()
	self:initView()
	self:initData()
end

function MarriageManualPicDiy:AddViewEvts()
	self:AddListenEvt(WeddingWallPicManager.WeddingPicDownloadCompleteCallback,self.photoCompleteCallback);
	self:AddListenEvt(WeddingWallPicManager.WeddingPicDownloadProgressCallback,self.photoProgressCallback);
	self:AddListenEvt(WeddingWallPicManager.WeddingPicDownloadErrorCallback,self.photoErrorCallback);
	self:AddListenEvt(ServiceEvent.WeddingCCmdUpdateWeddingManualCCmd,self.UpdateCurPhoto);
end

function MarriageManualPicDiy:PhotoCmdFrameActionPhotoCmd( note )
end

function MarriageManualPicDiy:UpdateCurPhoto( note )

	-- local serverData = Game.PictureWallManager:getServerDataByFrameId(self.frameId)
	-- if(serverData)then
	-- 	if(self.serverData and Game.PictureWallManager:checkSamePicture(self.serverData.photoData,serverData.photoData))then
	-- 		return
	-- 	end
	-- 	self.serverData = serverData
	-- 	local photoData = self.serverData.photoData 
		-- self.anglez = photoData.anglez
		if(self.curPhotoIndex ~= self.weddingProxy.manualPhotoIndex)then
			self:getPhoto()
			self.curPhotoIndex = self.weddingProxy.manualPhotoIndex

		end
	-- else
	-- 	local texture = self.photo.mainTexture
	-- 	self.photo.mainTexture = nil
	-- 	Object.DestroyImmediate(texture)
	-- end
	self:updateBtnState()
end

function MarriageManualPicDiy:updateBtnState()
	if(not self.weddingProxy.manualPhotoIndex or self.weddingProxy.manualPhotoIndex ==0 )then
		self.uploadBtn.text = ZhString.WeddingPictureDiyUploadTitle
		self:Show(self.defPhoto)
		PictureManager.Instance:SetWedding(MarriageManualPicDiy.BgTextureName, self.defPhotoTx);
	else
		self:Hide(self.defPhoto)
		PictureManager.Instance:UnLoadWedding(MarriageManualPicDiy.BgTextureName,self.defPhotoTx);
		self.uploadBtn.text = ZhString.WeddingPictureDiyReplace
	end
end

function MarriageManualPicDiy:changePhotoSize()

	local frameData = Table_ScenePhotoFrame[self.frameId]
	local dir = 0
	if(frameData)then
		dir = frameData.Dir
	end
	if(dir == 1)then
		self.photo.width = 400
		self.photo.height = 600
	end
end

function MarriageManualPicDiy:photoCompleteCallback( note )
	-- body
	local data = note.body
	local index = data.index
	-- Game.PictureWallManager:log("MarriageManualPicDiy:photoCompleteCallback1",photoData.sourceid,photoData.source,photoData.charid)
	if(index == self.weddingProxy.manualPhotoIndex)then
		self:completeCallback(data.byte)
	end
end

function MarriageManualPicDiy:photoProgressCallback( note )
	-- body
	local data = note.body
	local id = data.id
	local index = data.index
	-- Game.PictureWallManager:log("MarriageManualPicDiy:photoCompleteCallback1",photoData.sourceid,photoData.source,photoData.charid)
	if(index == self.weddingProxy.manualPhotoIndex)then
		self:progressCallback(data.progress)
	end
end

function MarriageManualPicDiy:photoErrorCallback( note )
	-- body
	helplog("photoErrorCallback")
end

function MarriageManualPicDiy:initData(  )
	-- body
	self.weddingProxy = WeddingProxy.Instance
	self.curPhotoIndex = self.weddingProxy.manualPhotoIndex
	self:initDefaultTextureSize()
	-- self:initScreenShotData()
	-- self:changePhotoSize()
	-- end
	self:updateBtnState()

	LeanTween.cancel(self.gameObject)
	LeanTween.delayedCall(self.gameObject,0.1,function (  )
		self:getPhoto()
		end)
end

function MarriageManualPicDiy:initView(  )
	-- body	
	self.photo = self:FindComponent("photo",UITexture)
	self.progress = self:FindComponent("loadProgress",UILabel)
	self:Hide(self.progress.gameObject)

	local marriageDes = self:FindComponent("marriageDes",UILabel)
	marriageDes.text = ZhString.WeddingPictureDiyDes
	local title = self:FindComponent("title",UILabel)
	title.text = ZhString.WeddingPictureDiyUploadTitle

	self.uploadBtn = self:FindComponent("btnLabel",UILabel)
	self.defPhoto = self:FindGO("defPhoto")
	self.defPhotoTx = self:FindComponent("defPhoto",UITexture)
	
	self:AddButtonEvent("actionBtn",function (  )
		PicutureWallSyncPanel.ViewType = UIViewType.Lv4PopUpLayer
	   self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.PicutureWallSyncPanel,viewdata = {frameId = 0,from = PicutureWallSyncPanel.PictureSyncFrom.WeddingCertificateDiy}})
	end)
end

function MarriageManualPicDiy:initDefaultTextureSize(  )
	-- body
	self.originWith = self.photo.width
	self.originHeight = self.photo.height
end

function MarriageManualPicDiy:setTexture( texture )
	-- body
	-- local anglez = 0
	-- if(self.anglez >=45 and self.anglez <= 135)then
	-- 	anglez = 90
	-- elseif(self.anglez >= 225 and self.anglez <= 315)then
	-- 	anglez = 270
	-- elseif(self.anglez >=135 and self.anglez <=225)then
	--  	anglez = 180
	-- end

	-- tempVector3:Set(0, 0, anglez)
	-- tempRot.eulerAngles = tempVector3
	-- self.PhotoCt.transform.localRotation = tempRot

	local orginRatio = self.originWith / self.originHeight 
	local textureRatio = 0
	-- if(anglez == 90 or anglez == 270)then
	-- 	textureRatio =  texture.height / texture.width
	-- else
		textureRatio =  texture.width / texture.height
	-- end
	local wRatio = math.min(orginRatio,textureRatio) == orginRatio
	local height = self.originHeight 
	local width = self.originWith
	if(wRatio)then
		height = self.originWith/textureRatio
	else
		width = self.originHeight*textureRatio
	end

	-- if(anglez == 90 or anglez == 270)then
	-- 	self.photo.width = height
	-- 	self.photo.height = width
	-- else
		self.photo.width = width
		self.photo.height = height
	-- end
	Object.DestroyImmediate(self.photo.mainTexture)
	self.photo.mainTexture = texture
end

function MarriageManualPicDiy:getPhoto(  )
	-- body
	if(self.weddingProxy.manualPhotoIndex and self.weddingProxy.manualPhotoIndex ~= 0)then
		Game.WeddingWallPicManager:GetWeddingPicture(self.weddingProxy.manualPhotoIndex,self.weddingProxy.manualPhotoTime)
	end
end

function MarriageManualPicDiy:progressCallback( progress )
	-- body
	self:Show(self.progress.gameObject)
	progress = progress >=1 and 1 or progress
	local value = progress*100
	value = math.floor(value)
	self.progress.text = value.."%"
end

function MarriageManualPicDiy:completeCallback(bytes )
	-- body
	self:Hide(self.progress.gameObject)		
	if(bytes)then
		local texture = Texture2D(0,0,TextureFormat.RGB24,false)
		local bRet = ImageConversion.LoadImage(texture, bytes)
		if( bRet)then
			self:setTexture(texture)
		else
			Object.DestroyImmediate(texture)
		end
	end
end

function MarriageManualPicDiy:OnExit()
	-- body
	PictureManager.Instance:UnLoadWedding(MarriageManualPicDiy.BgTextureName,self.defPhotoTx);
	LeanTween.cancel(self.gameObject)
	Object.DestroyImmediate(self.photo.mainTexture)
end