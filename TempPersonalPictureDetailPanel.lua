TempPersonalPictureDetailPanel = class("TempPersonalPictureDetailPanel", ContainerView)
TempPersonalPictureDetailPanel.ViewType = UIViewType.PopUpLayer
autoImport("PhotographResultPanel")
autoImport("PersonalPicturePanel")
autoImport("PermissionUtil")
function TempPersonalPictureDetailPanel:Init()
	self:initView()
	self:initData()
	self:AddEventListener()
	self:AddViewEvts()
end

function TempPersonalPictureDetailPanel:AddViewEvts()
	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadCompleteCallback ,self.photoCompleteCallback);
	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadProgressCallback ,self.photoProgressCallback);
	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginUpCompleteCallback ,self.photoUpCallback);	
	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginUpErrorCallback ,self.photoUpCallback);
	self:AddListenEvt(ServiceEvent.PhotoCmdPhotoUpdateNtf,self.PhotoCmdPhotoUpdateNtf);
end

function TempPersonalPictureDetailPanel:photoUpCallback( note )
	-- body
	local data = note.body
	-- printRed("PersonalPictureDetailPanel photoProgressCallback",data.progress)
	if(self.index == data.index)then
		self.hasUploadScenery = true
		self.saveAdventureBtnCollider.enabled = true
		ServiceSceneManualProxy.Instance:CallUpdateSolvedPhotoManualCmd(self.PhotoData.roleId,self.index)
		self:CloseSelf()
	end
end

function TempPersonalPictureDetailPanel:photoCompleteCallback( note )
	-- body
	local data = note.body
	MySceneryPictureManager.Instance():log("TempPersonalPictureDetailPanel:photoCompleteCallback",data.index, data.roleId,self.PhotoData.roleId,self.officialData.roleId)
	
	if(self.index == data.index and self.PhotoData.roleId == data.roleId)then
		self:completeCallback(data.byte)
	end
	if(self.index == data.index and self.officialData.roleId == data.roleId)then
		self:compareTxtCompleteCallback(data.byte)
	end
end

function TempPersonalPictureDetailPanel:photoProgressCallback( note )
	-- body
	local data = note.body
	-- printRed("TempPersonalPictureDetailPanel photoProgressCallback",data.progress)
	if(self.index == data.index and self.PhotoData.roleId == data.roleId)then
		self:progressCallback(data.progress)
	end
end

function TempPersonalPictureDetailPanel:PhotoCmdPhotoUpdateNtf( note )
	local data = note.body
	if(data.opttype == PhotoCmd_pb.EPHOTOOPTTYPE_REPLACE or data.opttype == PhotoCmd_pb.EPHOTOOPTTYPE_ADD)then
		self.noClose  = false
		self:startUploadPhoto(data.photo.index,data.photo.time)
	end
end

function TempPersonalPictureDetailPanel:initData(  )
	-- body
	self.PhotoData = self.viewdata.viewdata.PhotoData
	self.index = self.PhotoData.index
	self.isThumbnail = false
	self.officialData = AdventureDataProxy.Instance:GetSceneryData(self.index)
	self:initDefaultTextureSize()
	LeanTween.cancel(self.gameObject)
	LeanTween.delayedCall(self.gameObject,0.1,function (  )
		self:getPhoto()
	end)
end

function TempPersonalPictureDetailPanel:initView(  )
	-- body
	self.photo = self:FindGO("photo"):GetComponent(UITexture)
	self.noneTxIcon = self:FindGO("noneTxIcon"):GetComponent(UISprite)
	self.progress = self:FindGO("loadProgress"):GetComponent(UILabel)
	self:Hide(self.progress.gameObject)


	self.confirmBtn = self:FindGO("confirmBtn")
	self.saveToPhotoAlbumBtn = self:FindGO("saveToPhotoAlbumBtn")
	self.saveAdventureBtn = self:FindGO("saveAdventureBtn")
	self.compareBtn = self:FindGO("compareBtn")

	self.saveAdventureBtnCollider = self.saveAdventureBtn:GetComponent(BoxCollider)
end

function TempPersonalPictureDetailPanel:initDefaultTextureSize(  )
	-- body
	self.originWith = self.photo.width
	self.originHeight = self.photo.height
end

function TempPersonalPictureDetailPanel:setTexture( texture )
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
	-- Object.DestroyImmediate(self.photo.mainTexture)
	self.photo.width = width
	self.photo.height = height
	self.photo.mainTexture = texture
	-- self.checkboxAnchor:UpdateAnchors()
end

function TempPersonalPictureDetailPanel:AddEventListener( )
	-- body
	self:AddButtonEvent("closeBtn",function ( go )
		-- body
		self:CloseSelf();
	end)
	self:AddClickEvent(self.saveToPhotoAlbumBtn,function (  )
		-- body
		if(self.toUploadIndex ~= nil)then
			MsgManager.ShowMsgByIDTable(991)
		else
			self:saveToPhotoAlbum()
		end
	end)

	self:AddClickEvent(self.confirmBtn,function ( go )
		-- body	
		if(self.noClose)then
			return
		end
		self:savePicture()
		self:CloseSelf()
	end)

	self:AddClickEvent(self.saveAdventureBtn,function ( go )
		-- body
		helplog("save to AdventurePanel")
		self:saveScenery(self.index)
	end)

		local longPress = self.compareBtn:GetComponent(UILongPress)
	if(longPress)then
		longPress.pressEvent = function ( obj,state )
			-- body
			if(state)then
				self:CompareView()
			else
				self:Show(self.photo.gameObject)
				self:Hide(self.progress.gameObject)
				self:setTexture(self.texture)
			end
		end
	end
end

function TempPersonalPictureDetailPanel:startUploadPhoto( index,time )
	PersonalPictureManager.Instance():saveToPhotoAlbum(self.texture,index,time)
	self:CloseSelf()
end

function TempPersonalPictureDetailPanel:saveToPhotoAlbum( )
	local isFull = PhotoDataProxy.Instance:isPhotoAlbumFull()
	local isOutOfBounds= PhotoDataProxy.Instance:isPhotoAlbumOutofbounds()
	if(isOutOfBounds)then
		MsgManager.ShowMsgByIDTable(994)
	elseif(isFull)then
		local func = function ( index )
			-- body
			ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_REPLACE,index,self.anglez,self.currentMapID)
			self.toUploadIndex = index
			self.noClose = true
			MsgManager.ShowMsgByIDTable(991)
			ServiceSceneManualProxy.Instance:CallUpdateSolvedPhotoManualCmd(self.PhotoData.roleId,self.index)
		end
		PersonalPicturePanel.ViewType = UIViewType.Lv4PopUpLayer
		local viewdata = {ShowMode = PersonalPicturePanel.ShowMode.ReplaceMode,callback = func}
		MsgManager.ShowMsgByIDTable(994)
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.PersonalPicturePanel, viewdata = viewdata});
	else
		MsgManager.ShowMsgByIDTable(991)
		self.toUploadIndex= PhotoDataProxy.Instance:getEmptyCellIndex()
		ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_ADD,self.toUploadIndex,self.anglez,self.currentMapID)
		ServiceSceneManualProxy.Instance:CallUpdateSolvedPhotoManualCmd(self.PhotoData.roleId,self.index)
		self.noClose = true
	end
end

function TempPersonalPictureDetailPanel:savePicture(  )
	-- body
	--todo xde
	PermissionUtil.Access_SavePicToMediaStorage(function()
		local picName = PhotographResultPanel.picNameName
		local path = PathUtil.GetSavePath(PathConfig.PhotographPath).."/"..picName
		ScreenShot.SaveJPG(self.viewdata.texture,path,100)
		path = path..".jpg"
		ExternalInterfaces.SavePicToDCIM(path)
		MsgManager.ShowMsgByID(907)
		ServiceSceneManualProxy.Instance:CallUpdateSolvedPhotoManualCmd(self.PhotoData.roleId,self.index)
	end)
end

function TempPersonalPictureDetailPanel:saveScenery( scenicSpotID )
	-- body
	if(not self.hasUploadScenery)then
		self.saveAdventureBtnCollider.enabled = false
		local serverTime = math.floor(ServerTime.CurServerTime()/1000)
		MySceneryPictureManager.Instance():saveToPhotoAlbum(self.texture,scenicSpotID,serverTime,self.anglez)
		local key = string.format(PhotographResultPanel.SceneryKey,scenicSpotID)
		FunctionPlayerPrefs.Me():SetBool(key,true)
	else
		MsgManager.ShowMsgByID(553)
	end
end

function TempPersonalPictureDetailPanel:CompareView(  )
	-- body
	self:Hide(self.photo.gameObject)
	self:Show(self.progress.gameObject)
	if(self.compareTexture)then
		self:setTexture(self.compareTexture)
		self:Hide(self.progress.gameObject)
		self:Show(self.photo.gameObject)
	else
		--TODO
		self.progress.text = "0%"
		local data = AdventureDataProxy.Instance:GetSceneryData(self.index)
		MySceneryPictureManager.Instance():tryGetMySceneryOriginImage(data.roleId,self.index,data.time)
	end
end

function TempPersonalPictureDetailPanel:compareTxtCompleteCallback(bytes )
	-- body
	self:Hide(self.progress.gameObject)
	local texture = Texture2D(self.texture.width,self.texture.height,TextureFormat.RGB24,false)
	local bRet = ImageConversion.LoadImage(texture, bytes)
	if(bRet)then
		Object.DestroyImmediate(self.compareTexture)
		self.compareTexture = texture
		self:setTexture(self.compareTexture)
		self:Show(self.photo.gameObject)
	else
		Object.DestroyImmediate(texture)
	end
end

function TempPersonalPictureDetailPanel:getPhoto(  )
	-- body
	local tBytes = ScenicSpotPhotoNew.Ins():TryGetThumbnailFromLocal_Roles(self.PhotoData.roleId,self.index,self.PhotoData.time)
	if(tBytes)then
		self:completeCallback(tBytes,true)
	end
	MySceneryPictureManager.Instance():tryGetMySceneryOriginImage_Role(self.PhotoData.roleId,self.index,self.PhotoData.time)
end

function TempPersonalPictureDetailPanel:progressCallback( progress )
	-- body
	self:Show(self.progress.gameObject)
	progress = progress >=1 and 1 or progress
	local value = progress*100
	value = math.floor(value)
	self.progress.text = value.."%"
end

function TempPersonalPictureDetailPanel:completeCallback(bytes,thumbnail )
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
			Object.DestroyImmediate(self.texture)
			self.texture = texture
			self:setTexture(texture)
		else
			Object.DestroyImmediate(texture)
		end
	end
end

function TempPersonalPictureDetailPanel:OnExit(  )
	-- body
	LeanTween.cancel(self.gameObject)
	TempPersonalPictureDetailPanel.super.OnExit(self)
	Object.DestroyImmediate(self.photo.mainTexture)
	Object.DestroyImmediate(self.texture)
	Object.DestroyImmediate(self.compareTexture)
end