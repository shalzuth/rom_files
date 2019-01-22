PhotographResultPanel = class("PhotographResultPanel", ContainerView)
PhotographResultPanel.ViewType = UIViewType.PopUpLayer
PhotographResultPanel.SceneSpotPhotoFrame = { 
	icon = "photo_bg_logo",bg = "photo_bg_bottom5"	
}

autoImport("PersonalPicturePanel")
autoImport("PermissionUtil")
PhotographResultPanel.picNameName = "RO_Picture"
PhotographResultPanel.SceneryKey = "PhotographResultPanel_SceneryKey%d"
function PhotographResultPanel:Init()
	self:initView()
	self:AddEventListener()
	self:AddViewEvts()
end

function PhotographResultPanel:OnEnter(  )
	-- body
	self:initData()	
end

function PhotographResultPanel:AddViewEvts()
	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadCompleteCallback ,self.photoCompleteCallback);
	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadProgressCallback ,self.photoProgressCallback);

	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginUpCompleteCallback ,self.photoUpCallback);
	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginUpErrorCallback ,self.photoUpCallback);
	self:AddListenEvt(ServiceEvent.PhotoCmdPhotoUpdateNtf,self.PhotoCmdPhotoUpdateNtf);
end

function PhotographResultPanel:PhotoCmdPhotoUpdateNtf( note )
	local data = note.body
	if(data.opttype == PhotoCmd_pb.EPHOTOOPTTYPE_REPLACE or data.opttype == PhotoCmd_pb.EPHOTOOPTTYPE_ADD)then
		self.noClose  = false
		self:startUploadPhoto(data.photo.index,data.photo.time)
	end
end

function PhotographResultPanel:photoCompleteCallback( note )
	-- body
	local data = note.body
	if(self.scenicSpotID == data.index)then
		self:completeCallback(data.byte)
	end
end

function PhotographResultPanel:photoProgressCallback( note )
	-- body
	local data = note.body
	-- printRed("PersonalPictureDetailPanel photoProgressCallback",data.progress)
	if(self.scenicSpotID == data.index)then
		self:progressCallback(data.progress)
	end
end

function PhotographResultPanel:photoUpCallback( note )
	-- body
	local data = note.body
	-- printRed("PersonalPictureDetailPanel photoProgressCallback",data.progress)
	if(self.scenicSpotID == data.index)then
		self.hasUploadScenery = true
		self.saveAdventureBtnCollider.enabled = true
	end
end

function PhotographResultPanel:initData(  )
	-- body
	self.scenicSpotID = self.viewdata.scenicSpotID
	self.questData = self.viewdata.questData
	self.charid = self.viewdata.charid
	self.anglez = self.viewdata.anglez
	self.texture = self.viewdata.texture	
	local cameraData = self.viewdata.cameraData
	local icon = self:FindGO("icon"):GetComponent(UISprite)
	
	-- local tiledBg = self:FindGO("tiledBg"):GetComponent(UISprite)
	if(cameraData and cameraData.TiledBg and cameraData.TiledBg ~= "")then
		-- tiledBg.spriteName = cameraData.TiledBg
	end
	if(cameraData and cameraData.Icon and cameraData.Icon ~= "")then
		icon.spriteName = cameraData.Icon			
	end
	self:Hide(self.saveAdventureBtn)
	self:Hide(self.compareBtn)
	if(self.scenicSpotID)then
		-- self:Hide(self.saveToPhotoAlbumBtn)
		icon.spriteName = PhotographResultPanel.SceneSpotPhotoFrame.icon
		-- tiledBg.spriteName = PhotographResultPanel.SceneSpotPhotoFrame.bg
		if(AdventureDataProxy.Instance:IsSceneryUnlock(self.scenicSpotID))then
			self:Show(self.saveAdventureBtn)
			self:Show(self.compareBtn)
		else
			--Todo ????????????
			self:saveScenery(self.scenicSpotID)
			-- local sceneData = Table_Viewspot[self.scenicSpotID]
			-- if(sceneData)then
			-- 	MsgManager.ShowMsgByIDTable(904, sceneData.SpotName)
			-- end
		end
		local data = {sceneryid = self.scenicSpotID,anglez = self.anglez,charid = self.charid}
		FunctionScenicSpot.Me():InvalidateScenicSpot(data)
	end
	local bg = self:FindGO("background"):GetComponent(UISprite)
	bg.onChange = function (  )
		-- body
		local width = bg.width/2
		local height = bg.height/2
	end
	self:initDefaultTextureSize()	
	LeanTween.cancel(self.gameObject)
	LeanTween.delayedCall(self.gameObject,0.1,function (  )
			self:setTexture(self.texture)
			end)
	icon:MakePixelPerfect()
	-- if(self.questData == nil and self.scenicSpotID == nil)then
	-- 	self:Show(self.saveToPhotoAlbumBtn)
	-- else
	-- 	self:Hide(self.saveToPhotoAlbumBtn)
	-- end
	self.forbiddenClose = self.viewdata.forbiddenClose
	self.compareTexture = nil
	self.currentMapID = Game.MapManager:GetMapID()
	-- local 
	self.hasUploadScenery = false
end

function PhotographResultPanel:initDefaultTextureSize(  )
	-- body
	self.originWith = self.photo.width
	self.originHeight = self.photo.height
end

function PhotographResultPanel:initView(  )
	-- body
	self.photo = self:FindGO("photo"):GetComponent(UITexture)
	self.watermark = self:FindGO("watermark"):GetComponent(UILabel)
	self:Hide(self.watermark.gameObject)
	self.toggel = self:FindGO("isShowWatermark"):GetComponent(UIToggle)
	self:Hide(self.toggel.gameObject)
	EventDelegate.Add(self.toggel.onChange, function (  ) 
		self.watermark.gameObject:SetActive(self.toggel.value)
		end)
	self.confirmBtn = self:FindGO("confirmBtn")
	self.saveToPhotoAlbumBtn = self:FindGO("saveToPhotoAlbumBtn")
	self.saveAdventureBtn = self:FindGO("saveAdventureBtn")
	self.compareBtn = self:FindGO("compareBtn")
	self.progress = self:FindGO("loadProgress"):GetComponent(UILabel)
	self:Hide(self.progress.gameObject)

	self.saveAdventureBtnCollider = self.saveAdventureBtn:GetComponent(BoxCollider)
	
	self.shareBtn = self:FindGO("shareBtn")
	self.closeShare = self:FindGO("closeShare")
	self:AddClickEvent(self.closeShare,function (  )
		-- body
		self:Hide(self.goUIViewSocialShare)
	end)	

	self:AddClickEvent(self.shareBtn,function (  )
		-- body
--		self:Show(self.goUIViewSocialShare)
		-- todo xde share
		self:FaceBookShareClick()
	end)	

	self:AddClickEvent(self.saveToPhotoAlbumBtn,function (  )
		-- body
		if(self.toUploadIndex ~= nil)then
			MsgManager.ShowMsgByIDTable(991)
		else
			self:saveToPhotoAlbum()
		end
	end)

	self:GetGameObjects()
	self:RegisterButtonClickEvent()
end


-- todo xde share
function PhotographResultPanel:FaceBookShareClick()
	local picName = PhotographResultPanel.picNameName..tostring(os.time())
	local path = PathUtil.GetSavePath(PathConfig.PhotographPath).."/"..picName
	ScreenShot.SaveJPG(self.viewdata.texture,path,100)
	path = path..".jpg"
	local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
	overseasManager:ShareImg(path,'','','',function(msg)
		redlog('msg' .. msg)
		ROFileUtils.FileDelete(path)
		if(msg == "1")then
			MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
		else
			MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
		end
	end)
end

function PhotographResultPanel:saveToPhotoAlbum( )
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
		end
		PersonalPicturePanel.ViewType = UIViewType.Lv4PopUpLayer
		local viewdata = {ShowMode = PersonalPicturePanel.ShowMode.ReplaceMode,callback = func}
		MsgManager.ShowMsgByIDTable(994)
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.PersonalPicturePanel, viewdata = viewdata});
	else
		MsgManager.ShowMsgByIDTable(991)
		self.toUploadIndex= PhotoDataProxy.Instance:getEmptyCellIndex()
		ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_ADD,self.toUploadIndex,self.anglez,self.currentMapID)
		self.noClose = true
	end
end

function PhotographResultPanel:startUploadPhoto( index,time )
	PersonalPictureManager.Instance():saveToPhotoAlbum(self.texture,index,time)
end

function PhotographResultPanel:OnExit(  )
	-- body
	LeanTween.cancel(self.gameObject)
	PhotographResultPanel.super.OnExit(self)
	Object.DestroyImmediate(self.texture)
	Object.DestroyImmediate(self.compareTexture)
end

function PhotographResultPanel:AddEventListener( )
	-- body
	self:AddButtonEvent("cancelBtn",function ( go )
		-- body
		if(self.noClose)then
			return
		end
		self:CloseSelf();
	end)

	self:AddClickEvent(self.confirmBtn,function ( go )
		-- body	
		if(self.noClose)then
			return
		end
-- 		todo xde google
		self:savePicture()
--		self:CloseSelf()
	end)

	self:AddClickEvent(self.saveAdventureBtn,function ( go )
		-- body
		printRed("save to AdventurePanel")
		self:saveScenery(self.scenicSpotID)
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

function PhotographResultPanel:CompareView(  )
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
		local data = AdventureDataProxy.Instance:GetSceneryData(self.scenicSpotID)
		MySceneryPictureManager.Instance():tryGetMySceneryOriginImage(data.roleId,self.scenicSpotID,data.time)
	end
end

function PhotographResultPanel:AddCloseButtonEvent()
	self:AddButtonEvent("CloseButton", function (go)
		-- body
		if(self.noClose)then
			return
		end
		if(not self.forbiddenClose)then
			self:sendNotification(UIEvent.CloseUI, PhotographPanel.ViewType);
		end
		self:CloseSelf();
	end);
end

function PhotographResultPanel:progressCallback( progress )
	-- body
	progress = progress >=1 and 1 or progress
	local value = progress*100
	value = math.floor(value)
	self.progress.text = value.."%"
end

function PhotographResultPanel:completeCallback(bytes )
	-- body
	self:Hide(self.progress.gameObject)
	Object.DestroyImmediate(self.compareTexture)
	self.compareTexture = Texture2D(self.texture.width,self.texture.height,TextureFormat.RGB24,false)
	local bRet = ImageConversion.LoadImage(self.compareTexture, bytes)
	self:setTexture(self.compareTexture)
	self:Show(self.photo.gameObject)
end

function PhotographResultPanel:setTexture( texture )
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
	self.photo.width = width
	self.photo.height = height
	self.photo.mainTexture = texture
end

function PhotographResultPanel:savePicture(  )
	-- body
--	local result = PermissionUtil.Access_SavePicToMediaStorage()
--	if(result)then
--		local picName = PhotographResultPanel.picNameName
--		local path = PathUtil.GetSavePath(PathConfig.PhotographPath).."/"..picName
--		ScreenShot.SaveJPG(self.viewdata.texture,path,100)
--		path = path..".jpg"
--		ExternalInterfaces.SavePicToDCIM(path)
--		MsgManager.ShowMsgByID(907)
--	end
	-- todo xde google
	PermissionUtil.Access_SavePicToMediaStorage(function()
		local picName = PhotographResultPanel.picNameName
		local path = PathUtil.GetSavePath(PathConfig.PhotographPath).."/"..picName
		ScreenShot.SaveJPG(self.viewdata.texture,path,100)
		path = path..".jpg"
		ExternalInterfaces.SavePicToDCIM(path)
		MsgManager.ShowMsgByID(907)
		self:CloseSelf()
	end)
end

function PhotographResultPanel:sharePicture(platform_type, content_title, content_body)
	-- body
	local picName = PhotographResultPanel.picNameName..tostring(os.time())
	local path = PathUtil.GetSavePath(PathConfig.PhotographPath).."/"..picName
	ScreenShot.SaveJPG(self.viewdata.texture,path,100)
	path = path..".jpg"
	self:Log("sharePicture pic path:",path)

	SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function ( succMsg)
			-- body
			self:Log("SocialShare.Instance:Share success")
			ROFileUtils.FileDelete(path)

			if platform_type == E_PlatformType.Sina then
				MsgManager.ShowMsgByIDTable(566)
			end
		end,function ( failCode,failMsg)
			-- body
			self:Log("SocialShare.Instance:Share failure")
			ROFileUtils.FileDelete(path)

			local errorMessage = failMsg or 'error'
			if failCode ~= nil then
				errorMessage = failCode .. ', ' .. errorMessage
			end
			MsgManager.ShowMsg('', errorMessage, MsgManager.MsgType.Float)
		end,function (  )
			-- body
			self:Log("SocialShare.Instance:Share cancel")
			ROFileUtils.FileDelete(path)
		end)
end

-- <RB> social share
function PhotographResultPanel:GetGameObjects()
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

function PhotographResultPanel:RegisterButtonClickEvent()
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

function PhotographResultPanel:OnClickForButtonWechatMoments()
	if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
		self:sharePicture(E_PlatformType.WechatMoments, '', '')
	else
		MsgManager.ShowMsgByIDTable(561)
	end
end

function PhotographResultPanel:OnClickForButtonWechat()
	if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
		self:sharePicture(E_PlatformType.Wechat, '', '')
	else
		MsgManager.ShowMsgByIDTable(561)
	end
end

function PhotographResultPanel:OnClickForButtonQQ()
	if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
		self:sharePicture(E_PlatformType.QQ, '', '')
	else
		MsgManager.ShowMsgByIDTable(562)
	end
end

function PhotographResultPanel:OnClickForButtonSina()
	if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
		local contentBody = GameConfig.PhotographResultPanel_ShareDescription
		if contentBody == nil or #contentBody <= 0 then
			contentBody = 'RO'
		end
		self:sharePicture(E_PlatformType.Sina, '', contentBody)
	else
		MsgManager.ShowMsgByIDTable(563)
	end
end
-- <RE> social share

function PhotographResultPanel:saveScenery( scenicSpotID )
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
end