KFCActivityShowView = class("KFCActivityShowView",BaseView)
autoImport("PhotographResultPanel")
KFCActivityShowView.ViewType = UIViewType.ShareLayer

function KFCActivityShowView:Init()
  self:initView()
  self:initData()
end

function KFCActivityShowView:initView(  )
	-- body	
	self.cornerCt = self:FindGO("cornerCt")
	self.closeBtn = self:FindGO("CloseButton")
	self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)

	self:Hide(self.cornerCt)
	self:GetGameObjects()
	self:RegisterButtonClickEvent()
end

function KFCActivityShowView:GetGameObjects()
	self.goUIViewSocialShare = self:FindGO('UIViewSocialShare', self.gameObject)
	self.goButtonWechatMoments = self:FindGO('WechatMoments', self.goUIViewSocialShare)
	self.goButtonWechat = self:FindGO('Wechat', self.goUIViewSocialShare)
	self.goButtonQQ = self:FindGO('QQ', self.goUIViewSocialShare)
	self.goButtonSina = self:FindGO('Sina', self.goUIViewSocialShare)
end

function KFCActivityShowView:RegisterButtonClickEvent()
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

function KFCActivityShowView:OnClickForButtonWechatMoments()
	if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
		self:sharePicture(E_PlatformType.WechatMoments, '', '')
	else
		MsgManager.ShowMsgByIDTable(561)
	end
end

function KFCActivityShowView:OnClickForButtonWechat()
	if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
		self:sharePicture(E_PlatformType.Wechat, '', '')
	else
		MsgManager.ShowMsgByIDTable(561)
	end
end

function KFCActivityShowView:OnClickForButtonQQ()
	if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
		self:sharePicture(E_PlatformType.QQ, '', '')
	else
		MsgManager.ShowMsgByIDTable(562)
	end
end

function KFCActivityShowView:OnClickForButtonSina()
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

function KFCActivityShowView:startSharePicture(texture,platform_type, content_title, content_body)
	local picName = PhotographResultPanel.picNameName..tostring(os.time())
	local path = PathUtil.GetSavePath(PathConfig.PhotographPath).."/"..picName
	ScreenShot.SaveJPG(texture,path,100)
	path = path..".jpg"
	self:Log("KFCActivityShowView sharePicture pic path:",path)

	SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function ( succMsg)
			-- body
			self:Log("SocialShare.Instance:Share success")
			ROFileUtils.FileDelete(path)

			if platform_type == E_PlatformType.Sina then
				MsgManager.ShowMsgByIDTable(566)
			end
			ServiceNUserProxy.Instance:CallKFCShareUserCmd()
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
function KFCActivityShowView:sharePicture(platform_type, content_title, content_body)
	-- body
	self:startCaptureScreen(platform_type, content_title, content_body)
end

function KFCActivityShowView:startCaptureScreen(platform_type, content_title, content_body)
	-- body	
	local ui = NGUIUtil:GetCameraByLayername("UI");
	self:changeUIState(true)
    self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self. textureFormat, self.texDepth, self.antiAliasing)
	self.screenShotHelper:GetScreenShot(function ( texture )		
		self:changeUIState(false)
		self:startSharePicture(texture,platform_type, content_title, content_body)
	end,ui)
end

function KFCActivityShowView:changeUIState( isStart )
	-- body
	if(isStart)then
		self:Show(self.cornerCt)
		self:Hide(self.goUIViewSocialShare)
		self:Hide(self.closeBtn)
	else
		self:Hide(self.cornerCt)
		self:Show(self.goUIViewSocialShare)
		self:Show(self.closeBtn)		
	end
end

function KFCActivityShowView:initData(  )
	-- body
	self.screenShotWidth = -1
	self.screenShotHeight = 1080
	self.textureFormat = TextureFormat.RGB24
	self.texDepth = 24
	self.antiAliasing = ScreenShot.AntiAliasing.None
end

function KFCActivityShowView:OnExit()
	-- body	
	if(self.data)then
		self.data:Exit()
	end
end