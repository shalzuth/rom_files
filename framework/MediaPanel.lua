using "RenderHeads.Media.AVProVideo"
MediaPanel = class("MediaPanel", ContainerView)

autoImport("ShopViewExchangePage")

MediaPanel.PlayVideo = "MediaPanel.PlayVideo"
MediaPanel.PlayVideoFinish = "MediaPanel.PlayVideoFinish"

MediaPanel.ViewType = UIViewType.MovieLayer

function MediaPanel:Init()
	self:FindObjs()
	self:AddViewEvts()
end

function MediaPanel:FindObjs()
	self.videoApplyDelegate = self:FindGO("VideoCanvas"):GetComponent(ApplyToDelegate)
	self.mediaPlayer = self:FindGO("MediaPlayer"):GetComponent(MediaPlayer)
	self.videoCanvas = self:FindGO("VideoCanvas"):GetComponent(UITexture)
	self:AddButtonEvent("SkipIt",function ()
		self:FinishPlaying()
	end)
end

function MediaPanel:AddViewEvts()
	self:AddListenEvt(MediaPanel.PlayVideo, self.NotifyPlayVideo);
end

function MediaPanel:NotifyPlayVideo(note)
	self:StartPlay(note.body)
end

function MediaPanel:StartPlay(videoName)
	if(self.mediaPlayer.Control~=nil) then
		self:RealStartPlay(videoName)
	else
		LeanTween.delayedCall(2,function ()
			self:RealStartPlay(videoName)
		end):setUseFrames(true)
	end
	
end

function MediaPanel:RealStartPlay(videoName)
	local res = false
	if(videoName~=nil and videoName ~="") then
		self.videoApplyDelegate.receiver = function (texture,scale,offset)
			self.videoCanvas.mainTexture = texture
			if(not self.textureMakePixelPerfect) then
				self.videoCanvas:MakePixelPerfect()
			end
		end
		self.mediaPlayer:AddListener(function (mp,et)
			if(et==MediaPlayerEvent.EventType.FinishedPlaying) then
				self:FinishPlaying()
			end
		end)

		if(ApplicationHelper.AssetBundleLoadMode) then
			--热更新模式
			res = self.mediaPlayer:OpenVideoFromFile(MediaPlayer.FileLocation.RelativeToPeristentDataFolder,ApplicationHelper.platformFolder.."/Videos/"..videoName)
		else
			res = self.mediaPlayer:OpenVideoFromFile(MediaPlayer.FileLocation.RelativeToStreamingAssetsFolder,"Videos/"..videoName)
		end
	end
	if(not res) then
		if(videoName ==nil) then
			videoName = "[videoName]为空"
		end
		errorLog("播放视频失败.."..videoName)
		self:FinishPlaying()
	end
end

function MediaPanel:FinishPlaying()
	if(self.mediaPlayer~=nil) then
		self.mediaPlayer:Stop()
		self.mediaPlayer:CloseVideo()
	end
	self.videoApplyDelegate.receiver = nil
	self.videoCanvas.mainTexture = nil
	self:sendNotification(MediaPanel.PlayVideoFinish)
	self:CloseSelf()
end