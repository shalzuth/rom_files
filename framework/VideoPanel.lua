VideoPanel = class("VideoPanel", ContainerView)
VideoPanel.ViewType = UIViewType.VideoLayer
function VideoPanel:Init()
  self:FindObjs()
  self:AddEvts()
  VideoPanel.Instance = self
end
function VideoPanel.PlayVideo(filePath, isStartGameCG)
  if BackwardCompatibilityUtil.CompatibilityMode_V10 then
    MsgManager.ShowMsgByIDTable(854)
    return
  end
  local instance = VideoPanel._getInstance()
  instance.filePath = filePath
  instance.isStartGameCG = isStartGameCG
  instance:_launchVideo()
end
function VideoPanel._getInstance()
  if VideoPanel.Instance == nil then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.VideoPanel
    })
  end
  return VideoPanel.Instance
end
function VideoPanel:FindObjs()
  self.videoPlayer = self:FindGO("VideoPlayer"):GetComponent(VideoPlayerNGUI)
  self.closeBtn = self:FindGO("CloseButton")
  self.Bg = self:FindGO("Bg"):GetComponent(UIWidget)
end
function VideoPanel:OnExit()
  VideoPanel.super.OnExit(self)
  VideoPanel.Instance = nil
end
function VideoPanel:AddEvts()
  self:AddClickEvent(self.videoPlayer.gameObject, function(g)
    if self.isStartGameCG then
      self:CloseSelf()
    else
      self:_showCtlView()
    end
  end)
end
function VideoPanel:_showCtlView()
  local active = self.closeBtn.activeSelf
  self.closeBtn:SetActive(not active)
end
function VideoPanel:_launchVideo()
  if nil == self.videoPlayer then
    return
  end
  local res
  local path = ApplicationHelper.persistentDataPath .. "/Videos/" .. self.filePath
  if FileHelper.ExistFile(path) then
    res = self.videoPlayer:OpenVideo(MediaPlayer.FileLocation.RelativeToPeristentDataFolder, path)
  else
    res = self.videoPlayer:OpenVideo(MediaPlayer.FileLocation.RelativeToStreamingAssetsFolder, "Videos/" .. self.filePath)
  end
  if not res then
    self:CloseSelf()
    return
  end
  FunctionBGMCmd.Me():Pause()
  self.videoPlayer:Play()
  self:_setTexture()
  function self.videoPlayer.finishPlaying()
    self:CloseSelf()
  end
end
function VideoPanel:_setTexture()
  local width = self.Bg.width
  local height = width / self.videoPlayer:GetVideoTextureRatio()
  self.videoPlayer:SetTextureSize(height, width)
end
function VideoPanel:CloseSelf()
  FunctionBGMCmd.Me():UnPause()
  if nil ~= self.videoPlayer then
    self.videoPlayer.finishPlaying = nil
    self.videoPlayer:Close()
  end
  VideoPanel.super.CloseSelf(self)
end
