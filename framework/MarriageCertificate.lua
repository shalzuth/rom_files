MarriageCertificate = class("MarriageCertificate", ContainerView)
autoImport("Charactor")
autoImport("PicutureWallSyncPanel")
MarriageCertificate.ViewType = UIViewType.PopUpLayer
local tempVector3 = LuaVector3.zero
local tempRot = LuaQuaternion.identity

MarriageCertificate.BgTextureName = "marry_bg_bottom1";
MarriageCertificate.ProcessTextureName = "marry_bg_process";

function MarriageCertificate:Init()
	self:AddViewEvts()
	self:initView()
	self:initData()
end

function MarriageCertificate:AddViewEvts()
	self:AddListenEvt(WeddingWallPicManager.WeddingPicDownloadCompleteCallback,self.photoCompleteCallback);
	self:AddListenEvt(WeddingWallPicManager.WeddingPicDownloadProgressCallback,self.photoProgressCallback);
	self:AddListenEvt(WeddingWallPicManager.WeddingPicDownloadErrorCallback,self.photoErrorCallback);
	self:AddListenEvt(ServiceEvent.NUserUploadWeddingPhotoUserCmd,self.UpdateCurPhoto);
end

function MarriageCertificate:ShowRedTip( note )
	local size = note.body
	if(size>0)then
		self:Show(self.redTip)
		self:ShowMsgAnim(note.body)
	else
		self:Hide(self.redTip)
	end
end

function MarriageCertificate:PhotoCmdFrameActionPhotoCmd( note )
end

function MarriageCertificate:UpdateCurPhoto( note )
	-- helplog("UpdateCurPhoto:")
	-- local serverData = Game.PictureWallManager:getServerDataByFrameId(self.frameId)
	-- if(serverData)then
	-- 	if(self.serverData and Game.PictureWallManager:checkSamePicture(self.serverData.photoData,serverData.photoData))then
	-- 		return
	-- 	end
	-- 	self.serverData = serverData
	-- 	local photoData = self.serverData.photoData 
	-- 	self.anglez = photoData.anglez
		self:getPhoto()
	-- else
	-- 	local texture = self.photo.mainTexture
	-- 	self.photo.mainTexture = nil
	-- 	Object.DestroyImmediate(texture)
	-- end
end

function MarriageCertificate:changePhotoSize()

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

function MarriageCertificate:photoCompleteCallback( note )
	-- body
	local data = note.body
	local id = data.id
	local index = data.index
	Game.WeddingWallPicManager:log("MarriageCertificate:photoCompleteCallback1",id,self.weddingData.id,self.weddingData.photoidx)
	if(self.weddingData and id == self.weddingData.id and index == self.weddingData.photoidx)then
		self:completeCallback(data.byte)
	end
end

function MarriageCertificate:photoProgressCallback( note )
	-- body
	local data = note.body
	local id = data.id
	local index = data.index
		Game.WeddingWallPicManager:log("MarriageCertificate:photoCompleteCallback1",id,self.weddingData.id,self.weddingData.photoidx)
	if(self.weddingData and id == self.weddingData.id and index == self.weddingData.photoidx)then
		self:progressCallback(data.progress)
	end
end

function MarriageCertificate:photoErrorCallback( note )
	-- body
	helplog("photoErrorCallback")
end

function MarriageCertificate:initData(  )
	-- body
	self.data = self.viewdata.viewdata
	self.weddingData = self.data.weddingData or {}
	self:initDefaultTextureSize()
	self:initScreenShotData()
	if(self.weddingData and self.weddingData.photoidx ~= 0 )then
		self.loadReady = false
	else
		self:changePhotoSize()
	end

	LeanTween.cancel(self.gameObject)
	LeanTween.delayedCall(self.gameObject,0.1,function (  )
		self:getPhoto()
		end)
	self:UpdateHead()
	local str = "%Y.%m.%d  %H:%M";
	str = os.date(str, self.weddingData.weddingtime)
	self.marriageTime.text = str	
end

function MarriageCertificate:initView(  )
	helplog("initView")
	-- body
	self.photo = self:FindComponent("photo",UITexture)
	self.progress = self:FindComponent("loadProgress",UILabel)
	self:Hide(self.progress.gameObject)
	
	self.portrait_1 = self:FindGO("portrait_1")
	self.portrait_2 = self:FindGO("portrait_2")

	self.coupleName1 = self:FindComponent("coupleName1",UILabel)
	self.coupleName2 = self:FindComponent("coupleName2",UILabel)
	self.marriageTime = self:FindComponent("marriageTime",UILabel)
	self.closeBtn = self:FindGO("CloseButton")
	self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)

	self:GetGameObjects()
	self:RegisterButtonClickEvent()

	self.shareBtn = self:FindGO("shareBtn")
	self:AddClickEvent(self.shareBtn,function (  )
		--todo xde 不要显示那么多分享了点击直接分享
--	   self:Show(self.goUIViewSocialShare)
		 self:sharePicture('Facebook', '', '')
	end)

	self.defPhoto = self:FindGO("defPhoto")
	self.defPhotoTx = self:FindComponent("defPhoto",UITexture)
	self.bgTx1 = self:FindComponent("Texture_1",UITexture)
	self.bgTx2 = self:FindComponent("Texture_2",UITexture)
	PictureManager.Instance:SetWedding(MarriageCertificate.ProcessTextureName, self.bgTx1);
	PictureManager.Instance:SetWedding(MarriageCertificate.ProcessTextureName, self.bgTx2);
	local shareLabel = self:FindComponent("shareLabel",UILabel)
	shareLabel.text = ZhString.WeddingPictureShareLabel
	self:AddButtonEvent("innerBg",function (  )
		PhotoDataProxy.Instance:setCurCertificateData(self.data)
		PicutureWallSyncPanel.ViewType = UIViewType.Lv4PopUpLayer
	   self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.PicutureWallSyncPanel,viewdata = {frameId = 0,from = PicutureWallSyncPanel.PictureSyncFrom.WeddingCertificate}})
	end)

	self.closeShare = self:FindGO("closeShare")
	self:AddClickEvent(self.closeShare,function (  )
		-- body
		self:Hide(self.goUIViewSocialShare)
	end)
	if(FloatAwardView.ShareFunctionIsOpen(  ))then
		self:Show(self.shareBtn)
	else
		self:Hide(self.shareBtn)
	end
end

function MarriageCertificate:UpdateHead(  )
	-- body
	if(not self.targetCell1)then
		local headCellObj = self:FindGO("portrait_2")
		self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId,headCellObj)
		tempVector3:Set(0,0,0)
		self.headCellObj.transform.localPosition = tempVector3
		self.targetCell1 = PlayerFaceCell.new(self.headCellObj)
		self.targetCell1:HideHpMp()
		self.targetCell1:HideLevel()
	end

	local infoData = WeddingProxy.Instance:GetWeddingInfo()
	if(infoData)then
		local id = infoData:GetPartnerGuid()
		local coupleData = WeddingProxy.Instance:GetPortraitInfo(id)
		local headData = HeadImageData.new()
		headData:TransByWeddingCharData(coupleData)
		self.coupleName2.text = coupleData.name
		self.targetCell1:SetData(headData);
	else
		helplog("没找到你老婆的头像数据")
	end
	
	if(not self.targetCell2)then
		local headCellObj = self:FindGO("portrait_1")
		self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId,headCellObj)
		tempVector3:Set(0,0,0)
		self.headCellObj.transform.localPosition = tempVector3
		self.targetCell2 = PlayerFaceCell.new(self.headCellObj)
		self.targetCell2:HideHpMp()
		self.targetCell2:HideLevel()
	end
	self.coupleName1.text = Game.Myself.data.name
	headData = HeadImageData.new();
	headData:TransByMyself();
	-- headData.frame = nil;
	headData.job = nil;
	self.targetCell2:SetData(headData);
	
end

function MarriageCertificate:initDefaultTextureSize(  )
	-- body
	self.originWith = self.photo.width
	self.originHeight = self.photo.height
end

function MarriageCertificate:setTexture( texture )
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

function MarriageCertificate:getPhoto(  )
	-- body
	if(self.weddingData and self.weddingData.photoidx and self.weddingData.photoidx ~= 0)then
		helplog("getPhoto:",tostring(self.weddingData.photoidx),tostring(self.weddingData.photoidx))
		Game.WeddingWallPicManager:GetWeddingPicture(self.weddingData.photoidx,self.weddingData.phototime)
		PictureManager.Instance:UnLoadWedding(MarriageCertificate.BgTextureName,self.defPhotoTx);
		self:Hide(self.defPhoto)
	else
		self:Show(self.defPhoto)
		PictureManager.Instance:SetWedding(MarriageCertificate.BgTextureName, self.defPhotoTx);
	end
end

function MarriageCertificate:progressCallback( progress )
	-- body
	self:Show(self.progress.gameObject)
	progress = progress >=1 and 1 or progress
	local value = progress*100
	value = math.floor(value)
	self.progress.text = value.."%"
end

function MarriageCertificate:completeCallback(bytes )
	-- body
	self:Hide(self.progress.gameObject)		
	if(bytes)then
		local texture = Texture2D(0,0,TextureFormat.RGB24,false)
		local bRet = ImageConversion.LoadImage(texture, bytes)
		if( bRet)then
			self.loadReady = true
			self:setTexture(texture)			
		else
			Object.DestroyImmediate(texture)
		end
	end
end


function MarriageCertificate:GetGameObjects()
	self.goUIViewSocialShare = self:FindGO('UIViewSocialShare', self.gameObject)
	self.goButtonWechatMoments = self:FindGO('WechatMoments', self.goUIViewSocialShare)
	self.goButtonWechat = self:FindGO('Wechat', self.goUIViewSocialShare)
	self.goButtonQQ = self:FindGO('QQ', self.goUIViewSocialShare)
	self.goButtonSina = self:FindGO('Sina', self.goUIViewSocialShare)
end

function MarriageCertificate:RegisterButtonClickEvent()
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

function MarriageCertificate:OnClickForButtonWechatMoments()
	if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
		self:sharePicture(E_PlatformType.WechatMoments, '', '')
	else
		MsgManager.ShowMsgByIDTable(561)
	end
end

function MarriageCertificate:OnClickForButtonWechat()
	if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
		self:sharePicture(E_PlatformType.Wechat, '', '')
	else
		MsgManager.ShowMsgByIDTable(561)
	end
end

function MarriageCertificate:OnClickForButtonQQ()
	if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
		self:sharePicture(E_PlatformType.QQ, '', '')
	else
		MsgManager.ShowMsgByIDTable(562)
	end
end

function MarriageCertificate:OnClickForButtonSina()
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

function MarriageCertificate:startSharePicture(texture,platform_type, content_title, content_body)
	local picName = "Ro_"..tostring(os.time())
	local path = PathUtil.GetSavePath(PathConfig.PhotographPath).."/"..picName
	ScreenShot.SaveJPG(texture,path,100)
	path = path..".jpg"
	self:Log("MarriageCertificate sharePicture pic path:",path)

--	SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function ( succMsg)
--			-- body
--			self:Log("SocialShare.Instance:Share success")game
--			ROFileUtils.FileDelete(path)
--
--			if platform_type == E_PlatformType.Sina then
--				MsgManager.ShowMsgByIDTable(566)
--			end
--		end,function ( failCode,failMsg)
--			-- body
--			self:Log("SocialShare.Instance:Share failure")
--			ROFileUtils.FileDelete(path)
--
--			local errorMessage = failMsg or 'error'
--			if failCode ~= nil then
--				errorMessage = failCode .. ', ' .. errorMessage
--			end
--			MsgManager.ShowMsg('', errorMessage, MsgManager.MsgType.Float)
--		end,function (  )
--			-- body
--			self:Log("SocialShare.Instance:Share cancel")
--			ROFileUtils.FileDelete(path)
--		end)

	-- todo xde fb share
	local overseasManager = OverSeas_TW.OverSeasManager.GetInstance();
	overseasManager:ShareImg(path,content_title,"",content_body,function(msg)
		ROFileUtils.FileDelete(path)
		if(msg == "1")then
			MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
		else
			MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
		end
	end);
end
function MarriageCertificate:sharePicture(platform_type, content_title, content_body)
	-- body
	self:startCaptureScreen(platform_type, content_title, content_body)
end

function MarriageCertificate:startCaptureScreen(platform_type, content_title, content_body)
	-- body	
	local ui = NGUIUtil:GetCameraByLayername("UI");
	self:changeUIState(true)
    self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self. textureFormat, self.texDepth, self.antiAliasing)
	self.screenShotHelper:GetScreenShot(function ( texture )		
		self:changeUIState(false)
		self:startSharePicture(texture,platform_type, content_title, content_body)
	end,ui)
end

function MarriageCertificate:changeUIState( isStart )
	-- body
	if(isStart)then
		--todo xde
--		self:Hide(self.goUIViewSocialShare)
		self:Hide(self.closeBtn)
		self:Hide(self.shareBtn)
	else
		--todo xde
--		self:Show(self.goUIViewSocialShare)
		self:Show(self.shareBtn)
		self:Show(self.closeBtn)
	end
end

function MarriageCertificate:initScreenShotData(  )
	-- body
	self.screenShotWidth = -1
	self.screenShotHeight = 1080
	self.textureFormat = TextureFormat.RGB24
	self.texDepth = 24
	self.antiAliasing = ScreenShot.AntiAliasing.None
end

function MarriageCertificate:OnExit(  )
	-- body
	LeanTween.cancel(self.gameObject)
	PictureManager.Instance:UnLoadWedding(MarriageCertificate.BgTextureName,self.defPhotoTx);
	PictureManager.Instance:UnLoadWedding(MarriageCertificate.ProcessTextureName, self.bgTx1);
	PictureManager.Instance:UnLoadWedding(MarriageCertificate.ProcessTextureName, self.bgTx2);
	Object.DestroyImmediate(self.photo.mainTexture)
end