SetViewSystemState = class("SetViewSystemState", SubView)
autoImport("AudioHD")
local tempBGM = 1
local tempSound = 1
local voiceLabTab = {}
local voiceIndex = 1
function SetViewSystemState:Init()
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvts()
  self:Show()
end
function SetViewSystemState:FindObj()
  self.table = self:FindGO("Table"):GetComponent(UITable)
  self.bgmSlider = self:FindGO("BgmSet/BgmSlider"):GetComponent("UISlider")
  self.soundSlider = self:FindGO("SoundSet/SoundSlider"):GetComponent("UISlider")
  self.speechTeamToggle = self:FindGO("SpeechTeamSet/SpeechTeamToggle"):GetComponent("UIToggle")
  self.speechGuildToggle = self:FindGO("SpeechGuildSet/SpeechGuildToggle"):GetComponent("UIToggle")
  self.speechChatZoneToggle = self:FindGO("SpeechChatZoneSet/SpeechChatZoneToggle"):GetComponent("UIToggle")
  self.speechPrivateChatToggle = self:FindGO("SpeechPrivateChatSet/SpeechPrivateChatToggle"):GetComponent("UIToggle")
  self.showDetailToggleAll = self:FindGO("ShowDetailAll/ShowDetailToggleAll"):GetComponent("UIToggle")
  self.showDetailToggleFriend = self:FindGO("ShowDetailFriend/ShowDetailToggleFriend"):GetComponent("UIToggle")
  self.showDetailToggleClose = self:FindGO("ShowDetailClose/ShowDetailToggleClose"):GetComponent("UIToggle")
  self.SavingMode = self:FindGO("SavingMode")
  self.SavingModeToggle = self:FindGO("SavingMode/SavingModeToggle"):GetComponent("UIToggle")
  self.audioHdBtn = self:FindGO("StartPauseBtn")
  self.audioHdBtnLabel = self:FindGO("StartPauseLabel", self.audioHdBtn):GetComponent("UILabel")
  self.audioHdBtnLabel.text = ""
  self.audioDownloadLeft = self:FindGO("DownloadSizeLabel"):GetComponent("UILabel")
  self.audioDownloadHint = self:FindGO("DownloadHintLabel"):GetComponent("UILabel")
  OverseaHostHelper:FixLabelOverV1(self.audioHdBtnLabel, 3, 99)
  OverseaHostHelper:FixLabelOverV1(self.audioDownloadHint, 3, 255)
  self.audioDownloadHint.transform.localPosition = Vector3(20, -61, 0)
  if GameObject.Find("ChineseVoice/ChineseVoiceToggle") then
    self.ChineseVoiceToggle = self:FindGO("ChineseVoice/ChineseVoiceToggle"):GetComponent("UIToggle")
    self.JapaneseVoiceToggle = self:FindGO("JapaneseVoice/JapaneseVoiceToggle"):GetComponent("UIToggle")
  end
  self.npcSoundPoplist = self:FindGO("NPCSoundPoplist"):GetComponent("UIPopupList")
  self.showExterior = {}
  self.showExterior[0] = self:FindGO("ShowExteriorHeadToggle"):GetComponent("UIToggle")
  self.showExterior[1] = self:FindGO("ShowExteriorBackToggle"):GetComponent("UIToggle")
  self.showExterior[2] = self:FindGO("ShowExteriorFaceToggle"):GetComponent("UIToggle")
  self.showExterior[3] = self:FindGO("ShowExteriorTailToggle"):GetComponent("UIToggle")
  self.showExterior[4] = self:FindGO("ShowExteriorMouthToggle"):GetComponent("UIToggle")
  self.weddingSet = self:FindGO("WeddingSet")
  self.showWeddingToggleAll = self:FindGO("ShowWeddingToggleAll"):GetComponent(UIToggle)
  self.showWeddingToggleFriend = self:FindGO("ShowWeddingToggleFriend"):GetComponent(UIToggle)
  self.showWeddingToggleClose = self:FindGO("ShowWeddingToggleClose"):GetComponent(UIToggle)
  self.pushSet = self:FindGO("PushSet")
  self.pushToggle = {}
  self.pushToggle[0] = self:FindGO("PushPoringToggle"):GetComponent(UIToggle)
  self.pushToggle[1] = self:FindGO("PushGuildToggle"):GetComponent(UIToggle)
  self.pushToggle[2] = self:FindGO("PushAuctionToggle"):GetComponent(UIToggle)
  self.pushToggle[3] = self:FindGO("PushMonsterToggle"):GetComponent(UIToggle)
  self.pushToggle[4] = self:FindGO("PushBigCatToggle"):GetComponent(UIToggle)
  self.GVoiceSet = self:FindGO("GVoiceSet")
  if self.GVoiceSet then
    self.GVoiceSet.gameObject:SetActive(false)
  end
  self.TeamGVoice = self:FindGO("TeamGVoice", self.GVoiceSet)
  self.GuildGVoice = self:FindGO("GuildGVoice", self.GVoiceSet)
  self.OpenYang = self:FindGO("OpenYang", self.GVoiceSet)
  self.OpenMai = self:FindGO("OpenMai", self.GVoiceSet)
  self.OpenMai_UILabel = self:FindGO("OpenMai", self.GVoiceSet):GetComponent(UILabel)
  self.OpenMai_UILabel.text = "\229\188\128\229\144\175\233\186\166\229\133\139\233\163\142"
  self.TeamGVoiceToggle_UIToggle = self:FindGO("Toggle", self.TeamGVoice):GetComponent(UIToggle)
  self.GuildGVoiceToggle_UIToggle = self:FindGO("Toggle", self.GuildGVoice):GetComponent(UIToggle)
  self.OpenYangToggle_UIToggle = self:FindGO("Toggle", self.OpenYang):GetComponent(UIToggle)
  self.OpenMaiToggle_UIToggle = self:FindGO("Toggle", self.OpenMai):GetComponent(UIToggle)
  self.TeamGVoiceToggle_UIToggle.optionCanBeNone = true
  self.gvoiceToggle = {}
  self.gvoiceToggle[0] = self.TeamGVoiceToggle_UIToggle
  self.gvoiceToggle[1] = self.GuildGVoiceToggle_UIToggle
  self.gvoiceToggle[2] = self.OpenYangToggle_UIToggle
  self.gvoiceToggle[3] = self.OpenMaiToggle_UIToggle
  if GuildProxy.Instance:IHaveGuild() then
    self.GuildGVoice.gameObject:SetActive(true)
    self.GuildGVoiceToggle_UIToggle.group = 101
    self.TeamGVoiceToggle_UIToggle.group = 101
  else
  end
  self.TeamGVoiceToggle_UIToggle.optionCanBeNone = true
  self.GuildGVoiceToggle_UIToggle.optionCanBeNone = true
  self.gvoiceToggle[2].group = 102
  self.gvoiceToggle[3].group = 103
  self.AutoAudio = self:FindGO("AutoAudio")
  if self.AutoAudio and ApplicationInfo.IsWindows() and GameConfig.SystemForbid.AutoPlayVoiceForWindows then
    self.AutoAudio.gameObject:SetActive(false)
  end
  self.npcSoundPoplistTempSprite = self:FindGO("NPCSoundPoplistTempSprite")
  self.poplistLeanTween = LeanTween.delayedCall(0.1, function()
    self.npcSoundPoplistTempSprite:SetActive(true)
    self.poplistLeanTween:cancel()
    self.poplistLeanTween = nil
  end)
  local skipStartCGGO = self:FindGO("SkipStartGameCG")
  skipStartCGGO:SetActive(false)
  self.AutoAudio.gameObject:SetActive(false)
  self:FindGO("GameLanguage").gameObject:SetActive(false)
end
local ChangeYuYinShouQuanToAllTrue = function()
end
local changeSetting = {}
local ChangeBGMVolume = function(vol)
  local setting = FunctionPerformanceSetting.Me()
  changeSetting.bgmVolume = vol
  setting:Apply(changeSetting)
end
local ChangeSoundVolume = function(vol)
  local setting = FunctionPerformanceSetting.Me()
  changeSetting.soundVolume = vol
  setting:Apply(changeSetting)
end
function SetViewSystemState:AddButtonEvt()
  EventDelegate.Set(self.bgmSlider.onChange, function()
    ChangeBGMVolume(self.bgmSlider.value)
  end)
  EventDelegate.Set(self.soundSlider.onChange, function()
    ChangeSoundVolume(self.soundSlider.value)
  end)
  EventDelegate.Add(self.npcSoundPoplist.onChange, function()
    voiceIndex = voiceLabTab[self.npcSoundPoplist.value]
  end)
  for i = 0, 4 do
    self:AddClickEvent(self.pushToggle[i].gameObject, function(obj)
      if not self.pushToggle[i].value or ExternalInterfaces.isUserNotificationEnable() then
      else
        ExternalInterfaces.ShowHintOpenPushView(ZhString.Push_title, ZhString.Push_message, ZhString.Push_cancelButtonTitle, ZhString.Push_otherButtonTitles)
        break
      end
    end)
    break
  end
  self:AddClickEvent(self.TeamGVoiceToggle_UIToggle.gameObject, function(obj)
    if self.TeamGVoiceToggle_UIToggle.value then
      GVoiceProxy.Instance:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
      if self.GuildGVoiceToggle_UIToggle.value then
        self.GuildGVoiceToggle_UIToggle.value = false
        GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
      end
    else
      GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
    end
  end)
  self:AddClickEvent(self.GuildGVoiceToggle_UIToggle.gameObject, function(obj)
    if self.GuildGVoiceToggle_UIToggle.value then
      if not GVoiceProxy.Instance:IsMySelfGongHuiJinYan() then
        GVoiceProxy.Instance:SetPlayerChooseToJoinGuildVoice(true)
        GVoiceProxy.Instance:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
      else
        MsgManager.FloatMsg(nil, "\229\189\147\229\137\141\229\183\178\231\187\143\232\162\171\228\188\154\233\149\191\231\166\129\232\168\128\239\188\140\230\151\160\230\179\149\229\188\128\229\144\175\233\186\166\229\133\139\233\163\142")
      end
      if self.TeamGVoiceToggle_UIToggle.value then
        self.TeamGVoiceToggle_UIToggle = false
        GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
      end
    else
      GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
    end
  end)
  self:AddClickEvent(self.OpenYangToggle_UIToggle.gameObject, function(obj)
    if self.OpenYangToggle_UIToggle.value then
    else
      self.OpenMaiToggle_UIToggle.value = false
    end
  end)
  self:AddClickEvent(self.OpenMaiToggle_UIToggle.gameObject, function(obj)
    if GVoiceProxy.Instance:IsMySelfGongHuiJinYan() then
      MsgManager.FloatMsg(nil, "\229\189\147\229\137\141\229\183\178\231\187\143\232\162\171\228\188\154\233\149\191\231\166\129\232\168\128\239\188\140\230\151\160\230\179\149\229\188\128\229\144\175\233\186\166\229\133\139\233\163\142")
      self.OpenMaiToggle_UIToggle.value = false
      return
    end
    if self.OpenMaiToggle_UIToggle.value then
    else
    end
  end)
  self:AddClickEvent(self.audioHdBtn, function(obj)
    if self.audioHD.status ~= AudioHD_Status.E_Done then
      local state = self.audioHD:SwitchHDDownload()
      if state == AudioBtn_Status.E_NewUpdate then
        self.audioHdBtnLabel.text = ZhString.AudioHD_start
      elseif state == AudioBtn_Status.E_Resume then
        self.audioHdBtnLabel.text = ZhString.AudioHD_resume
      elseif state == AudioBtn_Status.E_Pause then
        self.audioHdBtnLabel.text = ZhString.AudioHD_pause
      end
    end
  end)
end
function SetViewSystemState:AddViewEvts()
  self:AddListenEvt(PushEvent.OnJPushTagOperateResult, self.HandleJPushTagOperateResult)
  self:AddListenEvt(AudioHDEvent.OnReceiveAudioLabel1, self.HandleReceiveAudioHint1)
  self:AddListenEvt(AudioHDEvent.OnReceiveAudioLabel2, self.HandleReceiveAudioHint2)
  self:AddListenEvt(AudioHDEvent.OnReceiveAudioBtn3, self.HandleReceiveAudioBtn3)
end
function SetViewSystemState:Show()
  local setting = FunctionPerformanceSetting.Me()
  self.npcSoundPoplist:Clear()
  voiceLabTab = {}
  local tab = {
    ZhString.SetViewSystem_VoiceToggleChinese,
    ZhString.SetViewSystem_VoiceToggleJapanese
  }
  for i = 1, #tab do
    local str = tab[i]
    self.npcSoundPoplist:AddItem(str)
    voiceLabTab[str] = i
  end
  self.bgmSlider.value = setting:GetSetting().bgmVolume
  tempBGM = setting:GetSetting().bgmVolume
  self.soundSlider.value = setting:GetSetting().soundVolume
  tempSound = setting:GetSetting().soundVolume
  local showDetail = setting:GetSetting().showDetail
  if showDetail == SettingEnum.ShowDetailFriend then
    self.showDetailToggleFriend.value = true
    self.showDetailToggleClose.value = false
    self.showDetailToggleAll.value = false
  elseif showDetail == SettingEnum.ShowDetailClose then
    self.showDetailToggleFriend.value = false
    self.showDetailToggleClose.value = true
    self.showDetailToggleAll.value = false
  else
    self.showDetailToggleFriend.value = false
    self.showDetailToggleClose.value = false
    self.showDetailToggleAll.value = true
  end
  self.npcSoundPoplist.value = tab[setting:GetSetting().voiceLanguage]
  self.npcSoundPoplist.gameObject:SetActive(false)
  self.SavingModeToggle.value = setting:GetSetting().powerMode
  self.SavingMode:SetActive(not ApplicationInfo.IsRunOnWindowns())
  local showExterior = MyselfProxy.Instance:GetFashionHide()
  for i = 0, #self.showExterior do
    self.showExterior[i].value = self:GetBitByInt(showExterior, i)
  end
  if WeddingProxy.Instance:IsSelfSingle() then
    self.weddingSet:SetActive(false)
  else
    self.weddingSet:SetActive(true)
    local showWedding = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUERYWEDDINGTYPE) or 0
    if showWedding == SettingEnum.ShowWeddingFriend then
      self.showWeddingToggleFriend.value = true
    elseif showWedding == SettingEnum.ShowWeddingClose then
      self.showWeddingToggleClose.value = true
    else
      self.showWeddingToggleAll.value = true
    end
  end
  if BackwardCompatibilityUtil.CompatibilityMode_V19 or ApplicationInfo.IsRunOnWindowns() then
    self.pushSet:SetActive(false)
  else
    self.pushSet:SetActive(true)
    local push = setting:GetSetting().push
    for i = 0, #self.pushToggle do
      self.pushToggle[i].value = self:GetBitByInt(push, i)
    end
  end
  if ExternalInterfaces.isUserNotificationEnable() then
    LogUtility.Info("\230\142\168\233\128\129\229\138\159\232\131\189\229\188\128\229\144\175 \230\151\160\233\156\128\232\174\190\231\189\174")
  elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
  else
    for i = 0, 4 do
      LogUtility.Info("\230\142\168\233\128\129\229\138\159\232\131\189\229\133\179\233\151\173 \229\133\168\232\174\190\231\189\174\230\136\144false")
      self.pushToggle[i].value = false
    end
  end
  self.pushSet:SetActive(false)
  self.table:Reposition()
end
function SetViewSystemState:Save()
  local speech = {}
  local showDetail = 0
  if self.showDetailToggleAll.value then
    showDetail = SettingEnum.ShowDetailAll
  elseif self.showDetailToggleFriend.value then
    showDetail = SettingEnum.ShowDetailFriend
  elseif self.showDetailToggleClose.value then
    showDetail = SettingEnum.ShowDetailClose
  end
  local showWedding = 0
  if self.showWeddingToggleAll.value then
    showWedding = SettingEnum.ShowWeddingAll
  elseif self.showWeddingToggleFriend.value then
    showWedding = SettingEnum.ShowWeddingFriend
  elseif self.showWeddingToggleClose.value then
    showWedding = SettingEnum.ShowWeddingClose
  end
  local voiceLanguage = 0
  voiceLanguage = LanguageVoice.Chinese
  tempBGM = self.bgmSlider.value
  tempSound = self.soundSlider.value
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  setting:SetBgmVolume(self.bgmSlider.value)
  setting:SetSoundVolume(self.soundSlider.value)
  setting:SetAutoPlayChatChannel(speech)
  setting:SetShowDetail(showDetail)
  setting:SetShowWedding(showWedding)
  setting:SetVoiceLanguage(voiceIndex)
  if not BackwardCompatibilityUtil.CompatibilityMode_V9 then
    setting:SetPowerMode(self.SavingModeToggle.value)
  end
  setting:SetShowExterior(self:SetShowExterior())
  setting:SetPush(self:SetPush())
  setting:SetGVoice(self:SetGVoice())
  setting:SetEnd()
end
function SetViewSystemState:Exit()
  ChangeBGMVolume(tempBGM)
  ChangeSoundVolume(tempSound)
end
function SetViewSystemState:SetShowExterior()
  local showExterior = 0
  for i = 0, #self.showExterior do
    showExterior = self:GetIntByBit(showExterior, i, not self.showExterior[i].value)
  end
  return showExterior
end
function SetViewSystemState:SetPush()
  local push = 0
  for i = 0, #self.pushToggle do
    push = self:GetIntByBit(push, i, not self.pushToggle[i].value)
  end
  return push
end
function SetViewSystemState:SetGVoice()
  local gvoice = 0
  for i = 0, #self.gvoiceToggle do
    gvoice = self:GetIntByBit(gvoice, i, not self.gvoiceToggle[i].value)
  end
  return gvoice
end
function SetViewSystemState:GetBitByInt(num, index)
  return num >> index & 1 == 0
end
function SetViewSystemState:GetIntByBit(num, index, b)
  if b then
    num = num + (1 << index)
  end
  return num
end
function SetViewSystemState:SwitchOn()
end
function SetViewSystemState:SwitchOff()
end
function SetViewSystemState:HandleJPushTagOperateResult(note)
  local data = note.body
  if data then
  end
end
function SetViewSystemState:HandleReceiveAudioHint1(note)
  if note and note.body then
    self.audioDownloadLeft.text = note.body.info
  end
end
function SetViewSystemState:HandleReceiveAudioHint2(note)
  if note and note.body then
    self.audioDownloadHint.text = note.body.info
  end
end
function SetViewSystemState:HandleReceiveAudioBtn3(note)
  if note and note.body then
    self.audioHdBtnLabel.text = note.body.info
  end
  self.audioHdBtn.gameObject:SetActive(self.audioHdBtnLabel.text ~= ZhString.AudioHD_done)
end
function SetViewSystemState:OnEnter()
  self.super.OnEnter(self)
  if self.audioHD then
    self.audioHD:Destroy()
    self.audioHD = nil
  end
  self.audioHD = AudioHD.new()
  self.audioHD:InitInfo()
end
function SetViewSystemState:OnExit()
  self.super.OnExit(self)
  self.bgmSlider = nil
  self.soundSlider = nil
  self.npcSoundPoplist = nil
  self.audioHD:Destroy()
  self.audioHD = nil
end
