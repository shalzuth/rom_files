autoImport("BgmCtrl")
FunctionBGMCmd = class("FunctionBGMCmd")
FunctionBGMCmd.BgmSort = {
  Default = {priority = 1},
  Mission = {priority = 2},
  JukeBox = {priority = 3},
  Activity = {priority = 4},
  UI = {priority = 5}
}
FunctionBGMCmd.MaxVolume = 0.7
function FunctionBGMCmd.Me()
  if nil == FunctionBGMCmd.me then
    FunctionBGMCmd.me = FunctionBGMCmd.new()
  end
  return FunctionBGMCmd.me
end
function FunctionBGMCmd:ctor()
  self.currentNewBgm = nil
  self.currentVolume = FunctionBGMCmd.MaxVolume
  self.mute = false
  self.fadeInStart = 0.5
  self.defaultBgm = BgmCtrl.new(nil, FunctionBGMCmd.BgmSort.Default, 0, 100)
  self:Reset()
  self:SetMaxVolume(FunctionBGMCmd.MaxVolume)
end
function FunctionBGMCmd:Reset()
  self:SetCurrentBgm(self.defaultBgm, false)
end
function FunctionBGMCmd:StartSpeakVoice()
  self:SetVolume(0.2 * self.currentVolume)
end
function FunctionBGMCmd:EndSpeakVoice()
  self:SetVolume(self.currentVolume)
end
function FunctionBGMCmd:StartSolo()
  self:SetVolume(0.2 * self.currentVolume)
end
function FunctionBGMCmd:EndSolo()
  self:SetVolume(self.currentVolume)
end
function FunctionBGMCmd:GetMaxVolume(v)
  return math.min(v, self.currentVolume)
end
function FunctionBGMCmd:SetMute(val)
  self.mute = val
  if self.currentNewBgm then
    self.currentNewBgm:SetMute(val)
  end
end
function FunctionBGMCmd:SettingSetVolume(v)
  if v >= 0 and v <= 1 then
    v = FunctionBGMCmd.MaxVolume * v
  end
  AudioManager.volume = v
  self.currentVolume = v
  self:SetMaxVolume(v)
  self:SetVolume(v)
end
function FunctionBGMCmd:SetVolume(v)
  v = self:GetMaxVolume(v)
  if self.currentNewBgm then
    self.currentNewBgm:SetVolume(v)
  end
end
function FunctionBGMCmd:SetMaxVolume(v)
  v = self:GetMaxVolume(v)
  if self.defaultBgm then
    self.defaultBgm:SetMaxVolume(v)
  end
  if self.currentNewBgm then
    self.currentNewBgm:SetMaxVolume(v)
  end
end
function FunctionBGMCmd:GetDefaultBGM()
  if self.defaultBgm and AudioManager.Instance ~= nil then
    self.defaultBgm:SetAudioSource(AudioManager.Instance.bgMusic)
  end
  return self.defaultBgm
end
function FunctionBGMCmd:SetCurrentBgm(bgm, fade, outDuration, inDuration, fadeInStart)
  if self.currentNewBgm ~= bgm and self.currentNewBgm then
    if fade then
      local currentNewBgm = self.currentNewBgm
      currentNewBgm:FadeFromTo(currentNewBgm:GetVolume(), 0, outDuration, function()
        if currentNewBgm ~= self.defaultBgm then
          currentNewBgm:Destroy()
        end
      end)
      break
    elseif self.currentNewBgm ~= self.defaultBgm then
      self.currentNewBgm:Destroy()
    end
  end
  self.currentNewBgm = bgm
  if self.currentNewBgm and fade then
    self.currentNewBgm:FadeFromTo(fadeInStart and fadeInStart or self.fadeInStart, 1, inDuration)
  else
  end
end
function FunctionBGMCmd:PlayJukeBox(bgmPath, progress, percent, playTimes)
  self:TryPlayBGMSort(bgmPath, progress, FunctionBGMCmd.BgmSort.JukeBox, percent, playTimes)
end
function FunctionBGMCmd:StopJukeBox()
  self:StopBgm(FunctionBGMCmd.BgmSort.JukeBox)
end
function FunctionBGMCmd:PlayMissionBgm(bgmPath, playTimes)
  self:TryPlayBGMSort(bgmPath, 0, FunctionBGMCmd.BgmSort.Mission, false, playTimes)
end
function FunctionBGMCmd:StopMissionBgm()
  self:StopBgm(FunctionBGMCmd.BgmSort.Mission)
end
function FunctionBGMCmd:PlayActivityBgm(bgmPath, playTimes)
  self:TryPlayBGMSort(bgmPath, 0, FunctionBGMCmd.BgmSort.Activity, false, playTimes)
end
function FunctionBGMCmd:StopActivityBgm()
  self:StopBgm(FunctionBGMCmd.BgmSort.Activity)
end
function FunctionBGMCmd:PlayUIBgm(bgmPath, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn)
  self:TryPlayBGMSort(bgmPath, 0, FunctionBGMCmd.BgmSort.UI, false, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn)
end
function FunctionBGMCmd:StopUIBgm(fallbackDuration, fallbackFadeStartVolumn)
  self:StopBgm(FunctionBGMCmd.BgmSort.UI, fallbackDuration, fallbackFadeStartVolumn)
end
function FunctionBGMCmd:ReplaceCurrentBgm(bgmPath)
  if AudioManager.Instance ~= nil and AudioManager.Instance.bgMusic ~= nil then
    LogUtility.InfoFormat("\229\156\186\230\153\175\233\187\152\232\174\164\232\131\140\230\153\175\233\159\179\228\185\144\230\155\191\230\141\162\228\184\186{0}", bgmPath)
    local clip = ResourceManager.Instance:SLoadByType(ResourcePathHelper.AudioBGM(bgmPath), AudioClip)
    if clip ~= nil then
      AudioManager.Instance.bgMusic.clip = clip
      AudioManager.Instance.bgMusic:Play()
    end
  end
end
function FunctionBGMCmd:TryPlayBGMSort(bgmPath, progress, playType, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn)
  if percent and progress >= 1 then
    return
  end
  if self.currentNewBgm and self.currentNewBgm.bgmType.priority > playType.priority then
    return
  end
  self:ChangeBGM(bgmPath, progress, playType, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn)
end
function FunctionBGMCmd:StopBgm(playType, fallbackDuration, fallbackFadeStartVolumn)
  if self.currentNewBgm and self.currentNewBgm.bgmType == playType then
    self:Clear(fallbackDuration, fallbackFadeStartVolumn)
  end
end
function FunctionBGMCmd:Pause(fade)
  if self.currentNewBgm then
    if AudioManager.Instance ~= nil then
      self.defaultBgm:SetAudioSource(AudioManager.Instance.bgMusic)
    end
    self.currentNewBgm:Pause(fade)
  end
end
function FunctionBGMCmd:UnPause(fade)
  if self.currentNewBgm then
    if AudioManager.Instance ~= nil then
      self.defaultBgm:SetAudioSource(AudioManager.Instance.bgMusic)
    end
    self.currentNewBgm:UnPause(fade)
  end
end
function FunctionBGMCmd:ChangeBGM(bgmPath, progress, playType, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn)
  helplog("FunctionBGMCmd:ChangeBGM", bgmPath)
  if AudioManager.Instance ~= nil then
    self.defaultBgm:SetAudioSource(AudioManager.Instance.bgMusic)
    progress = progress or 0
    do
      local go = GameObject("ReplaceBGM")
      go:AddComponent(AudioSource)
      go.transform.parent = AudioManager.Instance.bgMusic.transform.parent
      local audioSource = AudioHelper.SPlayOn(ResourcePathHelper.AudioBGM(bgmPath), go)
      if audioSource == nil then
        error(string.format("not find audiosource:%s", bgmPath))
      end
      local bgmCtrl = BgmCtrl.new(audioSource.audioSource, playType, playTimes, 100, nil)
      bgmCtrl:SetFinishCallback(function()
        bgmCtrl:Destroy()
        self:Clear(fallbackDuration, fallbackFadeStartVolumn)
      end)
      bgmCtrl:SetMute(self.mute)
      bgmCtrl:SetMaxVolume(self.currentVolume)
      bgmCtrl:SetVolume(self.fadeInStart)
      if percent then
        progress = math.clamp(progress, 0, 0.99)
        progress = progress * audioSource.clip.length
      else
        progress = math.clamp(progress, 0, audioSource.clip.length - 1)
      end
      bgmCtrl:SetProgress(progress)
      bgmCtrl:Play()
      self:SetCurrentBgm(bgmCtrl, true, outDuration, inDuration)
    end
  else
  end
end
function FunctionBGMCmd:Clear(fallbackDuration, fallbackFadeStartVolumn)
  LogUtility.Info(string.format("\230\146\173\230\148\190\231\187\147\230\157\159 fallbackDuration:%s fallbackFadeStartVolumn:%s", fallbackDuration, fallbackFadeStartVolumn))
  self:SetCurrentBgm(self.defaultBgm, true, nil, fallbackDuration, fallbackFadeStartVolumn)
end
