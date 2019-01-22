ScenerytDetailPanel = class("ScenerytDetailPanel", ContainerView)

ScenerytDetailPanel.ViewType = UIViewType.PopUpLayer

autoImport("PermissionUtil")
function ScenerytDetailPanel:Init()
	self:initView()
	self:initData()
	self:AddEventListener()
	self:AddViewEvts()
end

function ScenerytDetailPanel:AddViewEvts()
	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadCompleteCallback ,self.photoCompleteCallback);
	self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadProgressCallback ,self.photoProgressCallback);
end

function ScenerytDetailPanel:photoCompleteCallback( note )
	-- body
	local data = note.body
	if(self.index == data.index)then
		self:completeCallback(data.byte)
	end
end

function ScenerytDetailPanel:photoProgressCallback( note )
	-- body
	local data = note.body
	-- printRed("PersonalPictureDetailPanel photoProgressCallback",data.progress)
	if(self.index == data.index)then
		self:progressCallback(data.progress)
	end
end

function ScenerytDetailPanel:initData(  )
	-- body
	self.scenicSpotData = self.viewdata.scenicSpotData
	self.PhotoData = PhotoData.new(self.scenicSpotData,PhotoDataProxy.PhotoType.SceneryPhotoType)
	self.index = self.scenicSpotData.staticId	
	self.adventureValue.text = self.scenicSpotData:getAdventureValue()
	local icon = self:FindGO("icon"):GetComponent(UISprite)
	self.canbeShare = false

	local bg = self:FindGO("background"):GetComponent(UISprite)
	self:initDefaultTextureSize()
	LeanTween.cancel(self.gameObject)
	LeanTween.delayedCall(self.gameObject,0.1,function (  )
		self:getPhoto()
	end)
end

function ScenerytDetailPanel:initView(  )
	-- body
	self.photo = self:FindGO("photo"):GetComponent(UITexture)
	self.adventureValue = self:FindGO("adventureValue"):GetComponent(UILabel)
	self.noneTxIcon = self:FindGO("noneTxIcon"):GetComponent(UISprite)
	self.progress = self:FindGO("loadProgress"):GetComponent(UILabel)
	self:Hide(self.progress.gameObject)
	-- self.watermark = self:FindGO("watermark"):GetComponent(UILabel)
	-- self:Hide(self.watermark.gameObject)
	-- self.toggel = self:FindGO("isShowWatermark"):GetComponent(UIToggle)
	-- self:Hide(self.toggel.gameObject)
	-- EventDelegate.Add(self.toggel.onChange, function (  ) 
	-- 	self.watermark.gameObject:SetActive(self.toggel.value)
	-- 	end)
	self.confirmBtn = self:FindGO("confirmBtn")

	self.shareBtn = self:FindGO("shareBtn")
	self.closeShare = self:FindGO("closeShare")
	self:AddClickEvent(self.closeShare,function (  )
		-- body
		self:Hide(self.goUIViewSocialShare)
	end)	

	self:AddClickEvent(self.shareBtn,function (  )
		-- body
--		self:Show(self.goUIViewSocialShare)
		--todo xde ?????????fb??????
		self:sharePicture('', '', '')
	end)
	-- self.saveAdventureBtn = self:FindGO("saveAdventureBtn")
	-- self.compareBtn = self:FindGO("compareBtn")
	-- self:generateWatermark()

	self:GetGameObjects()
	self:RegisterButtonClickEvent()
end

function ScenerytDetailPanel:initDefaultTextureSize(  )
	-- body
	self.originWith = self.photo.width
	self.originHeight = self.photo.height
end

function ScenerytDetailPanel:setTexture( texture )
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
	self.texture = texture
end

function ScenerytDetailPanel:AddEventListener( )
	-- body
	self:AddClickEvent(self.confirmBtn,function ( go )
		-- body	
		if(self.texture)then
			--todo xde
			PermissionUtil.Access_SavePicToMediaStorage(function()
				local picName = "RO_"..tostring(os.time())
				local path = PathUtil.GetSavePath(PathConfig.PhotographPath).."/"..picName
				ScreenShot.SaveJPG(self.texture,path,100)
				ExternalInterfaces.SavePicToDCIM(path..".jpg")
				MsgManager.ShowMsgByID(907)
			end)
		end
		self:CloseSelf();
	end)

	-- self:AddClickEvent(self.shareBtn,function ( go )
	-- 	-- body
	-- 	-- self
		
	-- end)

	self:AddButtonEvent("closeBtn",function ( go )
		-- body
		self:CloseSelf();
	end)
end

function ScenerytDetailPanel:getPhoto(  )
	-- body	
	local tBytes = ScenicSpotPhotoNew.Ins():TryGetThumbnailFromLocal_Share(self.index,self.PhotoData.time)
	if(tBytes)then
		self:completeCallback(tBytes,true)
	end
	MySceneryPictureManager.Instance():tryGetMySceneryOriginImage(self.PhotoData.roleId,self.index,self.PhotoData.time)
end

function ScenerytDetailPanel:sharePicture(platform_type, content_title, content_body)
	-- body
	if(self.canbeShare)then
		local path = ScenicSpotPhotoNew.Ins():GetLocalAbsolutePath_Share(self.index, true)
		self:Log("sharePicture pic path:",path)
		if(path)then
			local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
			overseasManager:ShareImg(path,content_title,'',content_body,function(msg)
				if(msg == "1")then
					self:CloseSelf();
					MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
				else
					MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
				end
			end)
		else
			MsgManager.FloatMsg(nil,ZhString.ShareAwardView_EmptyPath)
		end
		return true
	end
	return false
end

function ScenerytDetailPanel:progressCallback( progress )
	-- body
	self:Show(self.progress.gameObject)
	progress = progress >=1 and 1 or progress
	local value = progress*100
	value = math.floor(value)
	self.progress.text = value.."%"
end

function ScenerytDetailPanel:completeCallback(bytes,thumbnail )
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

function ScenerytDetailPanel:OnExit(  )
	-- body
	LeanTween.cancel(self.gameObject)
	Object.DestroyImmediate(self.photo.mainTexture)
end


-- <RB> social share
function ScenerytDetailPanel:GetGameObjects()
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

function ScenerytDetailPanel:RegisterButtonClickEvent()
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

function ScenerytDetailPanel:OnClickForButtonWechatMoments()
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

function ScenerytDetailPanel:OnClickForButtonWechat()
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

function ScenerytDetailPanel:OnClickForButtonQQ()
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

function ScenerytDetailPanel:OnClickForButtonSina()
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
-- <RE> social share
