VideoPanel=class("VideoPanel",ContainerView)
VideoPanel.ViewType=UIViewType.VideoLayer;

function VideoPanel:Init()
	self:FindObjs();
	self:AddEvts();
	VideoPanel.Instance = self
end

function VideoPanel.PlayVideo(filePath)
	if(BackwardCompatibilityUtil.CompatibilityMode_V10)then
		MsgManager.ShowMsgByIDTable(854);
		return;
	end
	local instance = VideoPanel._getInstance();
	instance.filePath=filePath;
	instance:_launchVideo();
end

function VideoPanel._getInstance()
	if(VideoPanel.Instance == nil)then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.VideoPanel})
	end
	return VideoPanel.Instance
end

function VideoPanel:FindObjs()
	self.videoPlayer=self:FindGO("VideoPlayer"):GetComponent(VideoPlayerNGUI);
	self.closeBtn=self:FindGO("CloseButton");
	self.Bg=self:FindGO("Bg"):GetComponent(UIWidget);
end

function VideoPanel:OnExit()
	VideoPanel.super.OnExit(self)
	VideoPanel.Instance = nil
end

function VideoPanel:AddEvts()
	self:AddClickEvent(self.videoPlayer.gameObject,function (g)
		self:_showCtlView()
	end)
end

function VideoPanel:_showCtlView()
	local active = self.closeBtn.activeSelf;
	self.closeBtn:SetActive(not active);
end

function VideoPanel:_launchVideo()
	if(nil==self.videoPlayer)then return end
	local res;
	res = self.videoPlayer:OpenVideo(self.filePath);
	if(not res)then
		self:CloseSelf();
		return;
	end
	local setting = FunctionPerformanceSetting.Me();
	self:_muteAudio(true)
	self.muteChange=true
	self.videoPlayer:Play();
	self:_setTexture();
	self.videoPlayer.finishPlaying = function ()
			self:CloseSelf();
	end
end

function VideoPanel:_setTexture()
	local width=self.Bg.width;
	local height = width/self.videoPlayer:GetVideoTextureRatio();
	self.videoPlayer:SetTextureSize(height,width);
end

function VideoPanel:CloseSelf()
	if(self.muteChange)then
		self:_muteAudio(false)
		self.muteChange=nil
	end
	if(nil~=self.videoPlayer)then
		self.videoPlayer.finishPlaying=nil;
		self.videoPlayer:Close();
	end
	VideoPanel.super.CloseSelf(self);
end

function VideoPanel:_muteAudio(on)
	FunctionBGMCmd.Me():SetMute(on)
	AudioUtility.Mute(on)
end

