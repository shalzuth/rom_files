SetViewSystemState = class("SetViewSystemState",SubView)

local tempBGM = 1
local tempSound = 1

function SetViewSystemState:Init ()
    self:FindObj()
    self:AddButtonEvt()
    self:AddViewEvts()
    self:Show()
end

function SetViewSystemState:FindObj ()
	self.table = self:FindGO("Table"):GetComponent(UITable)
    self.bgmSlider = self:FindGO("BgmSet/BgmSlider"):GetComponent("UISlider")
    self.soundSlider = self:FindGO("SoundSet/SoundSlider"):GetComponent("UISlider")
    -- todo xde start 不显示自动播放语音相关选项
    -- self.speechTeamToggle = self:FindGO("SpeechTeamSet/SpeechTeamToggle"):GetComponent("UIToggle")
    -- self.speechGuildToggle = self:FindGO("SpeechGuildSet/SpeechGuildToggle"):GetComponent("UIToggle")
    -- self.speechChatZoneToggle = self:FindGO("SpeechChatZoneSet/SpeechChatZoneToggle"):GetComponent("UIToggle")
    -- self.speechPrivateChatToggle = self:FindGO("SpeechPrivateChatSet/SpeechPrivateChatToggle"):GetComponent("UIToggle")
    -- todo xde end
    -- todo xde start 不显示游戏语音切换
    self.ChineseVoiceToggle = self:FindGO("ChineseVoice/ChineseVoiceToggle"):GetComponent("UIToggle")
    self.JapaneseVoiceToggle = self:FindGO("JapaneseVoice/JapaneseVoiceToggle"):GetComponent("UIToggle")
	self.KoreanVoiceToggle = self:FindGO("KoreanVoice/KoreanVoiceToggle"):GetComponent("UIToggle")
    -- todo xde 不显示游戏语音切换

	self.GVoiceSet = self:FindGO("GVoiceSet")
	if self.GVoiceSet then
		self.GVoiceSet.gameObject:SetActive(false)
	end
	self.TeamGVoice = self:FindGO("TeamGVoice",self.GVoiceSet)
	self.GuildGVoice = self:FindGO("GuildGVoice",self.GVoiceSet)
	self.OpenYang = self:FindGO("OpenYang",self.GVoiceSet)
	self.OpenMai = self:FindGO("OpenMai",self.GVoiceSet)

	self.OpenMai_UILabel = self:FindGO("OpenMai",self.GVoiceSet):GetComponent(UILabel)
	self.OpenMai_UILabel.text = "开启麦克风"
	self.TeamGVoiceToggle_UIToggle = self:FindGO("Toggle",self.TeamGVoice):GetComponent(UIToggle)
	self.GuildGVoiceToggle_UIToggle = self:FindGO("Toggle",self.GuildGVoice):GetComponent(UIToggle)
	self.OpenYangToggle_UIToggle = self:FindGO("Toggle",self.OpenYang):GetComponent(UIToggle)
	self.OpenMaiToggle_UIToggle = self:FindGO("Toggle",self.OpenMai):GetComponent(UIToggle)

	self.TeamGVoiceToggle_UIToggle.optionCanBeNone = true

	self.gvoiceToggle = {}
	self.gvoiceToggle[0] = self.TeamGVoiceToggle_UIToggle
	self.gvoiceToggle[1] = self.GuildGVoiceToggle_UIToggle
	self.gvoiceToggle[2] = self.OpenYangToggle_UIToggle
	self.gvoiceToggle[3] = self.OpenMaiToggle_UIToggle

	if GuildProxy.Instance:IHaveGuild()  then
		self.GuildGVoice.gameObject:SetActive(true)
		--TODO:这个group需要管理起来
		self.GuildGVoiceToggle_UIToggle.group = 101
		self.TeamGVoiceToggle_UIToggle.group = 101
	else

	end

	self.TeamGVoiceToggle_UIToggle.optionCanBeNone = true
	self.GuildGVoiceToggle_UIToggle.optionCanBeNone = true

	self.gvoiceToggle[2].group = 102
	self.gvoiceToggle[3].group = 103

end

--TODO:玩家给与语音授权后，全部为勾选状态，
local function ChangeYuYinShouQuanToAllTrue()

end

local changeSetting = {}
local function ChangeBGMVolume (vol)
	local setting = FunctionPerformanceSetting.Me()
	changeSetting.bgmVolume = vol
	setting:Apply(changeSetting)
end

local function ChangeSoundVolume (vol)
	local setting = FunctionPerformanceSetting.Me()
	changeSetting.soundVolume = vol
	setting:Apply(changeSetting)
end

function SetViewSystemState:AddButtonEvt ()
    EventDelegate.Set(self.bgmSlider.onChange , function ()
		ChangeBGMVolume(self.bgmSlider.value)
	end)
	EventDelegate.Set(self.soundSlider.onChange , function ()
		ChangeSoundVolume(self.soundSlider.value)
	end)

	self:AddClickEvent(self.TeamGVoiceToggle_UIToggle.gameObject,function(obj)
		if(self.TeamGVoiceToggle_UIToggle.value) then
			GVoiceProxy.Instance:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index )
			if self.GuildGVoiceToggle_UIToggle.value then
				self.GuildGVoiceToggle_UIToggle.value = false
				GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
			end
		else
			GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
		end
	end)

	self:AddClickEvent(self.GuildGVoiceToggle_UIToggle.gameObject,function(obj)
		if(self.GuildGVoiceToggle_UIToggle.value) then
			if  not GVoiceProxy.Instance:IsMySelfGongHuiJinYan() then
				GVoiceProxy.Instance:SetPlayerChooseToJoinGuildVoice(true)
				GVoiceProxy.Instance:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
			else
				MsgManager.FloatMsg(nil, "当前已经被会长禁言，无法开启麦克风")
			end

			if self.TeamGVoiceToggle_UIToggle.value then
				--互斥
				self.TeamGVoiceToggle_UIToggle =false
				GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
			end
		else
			GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
		end
	end)


	self:AddClickEvent(self.OpenYangToggle_UIToggle.gameObject,function(obj)
		if(self.OpenYangToggle_UIToggle.value) then

		else
			self.OpenMaiToggle_UIToggle.value = false
		end
	end)

	self:AddClickEvent(self.OpenMaiToggle_UIToggle.gameObject,function(obj)

		if GVoiceProxy.Instance:IsMySelfGongHuiJinYan() then
			MsgManager.FloatMsg(nil, "当前已经被会长禁言，无法开启麦克风")
			self.OpenMaiToggle_UIToggle.value = false
			do return end
		end

		if(self.OpenMaiToggle_UIToggle.value) then

		else

		end
	end)

end

function SetViewSystemState:AddViewEvts()
	self:AddListenEvt(PushEvent.OnJPushTagOperateResult, self.HandleJPushTagOperateResult)


end

function SetViewSystemState:Show ()
    local setting = FunctionPerformanceSetting.Me()

    self.bgmSlider.value = setting:GetSetting().bgmVolume
	tempBGM = setting:GetSetting().bgmVolume
    self.soundSlider.value = setting:GetSetting().soundVolume
	tempSound = setting:GetSetting().soundVolume
	-- todo xde start 不显示自动播放语音相关选项
 --    self.speechTeamToggle.value = setting:IsAutoPlayChatChannel(ChatChannelEnum.Team)
	-- self.speechGuildToggle.value = setting:IsAutoPlayChatChannel(ChatChannelEnum.Guild)
	-- self.speechChatZoneToggle.value = setting:IsAutoPlayChatChannel(ChatChannelEnum.Zone)
	-- self.speechPrivateChatToggle.value = setting:IsAutoPlayChatChannel(ChatChannelEnum.Private)
	-- todo xde end

	local voiceLanguage = setting:GetSetting().voiceLanguage
    -- todo xde 不显示游戏语音切换
	self.JapaneseVoiceToggle.value = false
	self.ChineseVoiceToggle.value = false
	self.KoreanVoiceToggle.value = false
	if voiceLanguage == LanguageVoice.Chinese then
		self.ChineseVoiceToggle.value = true
	elseif voiceLanguage == LanguageVoice.Jananese then
		self.JapaneseVoiceToggle.value = true
	elseif voiceLanguage == LanguageVoice.Korean then
		self.KoreanVoiceToggle.value = true
	end


	self.table:Reposition()
end

function SetViewSystemState:Save ()
    local speech = {}
    -- todo xde start 不显示自动播放语音相关选项
	-- if self.speechTeamToggle.value then
	-- 	table.insert(speech , ChatChannelEnum.Team)
	-- end
	-- if self.speechGuildToggle.value then
	-- 	table.insert(speech , ChatChannelEnum.Guild)
	-- end
	-- if self.speechChatZoneToggle.value then
	-- 	table.insert(speech , ChatChannelEnum.Zone)
	-- end
	-- if self.speechPrivateChatToggle.value then
	-- 	table.insert(speech , ChatChannelEnum.Private)
	-- end
	-- todo xde end

	local voiceLanguage = 0
	-- todo xde start 强制使用日语语音
--	voiceLanguage = LanguageVoice.Jananese
	 if self.ChineseVoiceToggle.value then
	 	voiceLanguage = LanguageVoice.Chinese
	 elseif self.JapaneseVoiceToggle.value then
	 	voiceLanguage = LanguageVoice.Jananese
	 elseif self.KoreanVoiceToggle.value then
		 voiceLanguage = LanguageVoice.Korean
	 end
	-- todo xde 不显示游戏语音切换

	tempBGM = self.bgmSlider.value
	tempSound = self.soundSlider.value

    local setting = FunctionPerformanceSetting.Me()
    setting:SetBegin()
    setting:SetBgmVolume(self.bgmSlider.value)
	setting:SetSoundVolume(self.soundSlider.value)
    setting:SetAutoPlayChatChannel(speech)
    setting:SetShowWedding(showWedding)
    setting:SetVoiceLanguage(voiceLanguage)
	setting:SetGVoice(self:SetGVoice())
    setting:SetEnd()
end

function SetViewSystemState:Exit ()
    ChangeBGMVolume(tempBGM)
	ChangeSoundVolume(tempSound)
end

function SetViewSystemState:SetGVoice()
	local gvoice = 0
	for i=0,#self.gvoiceToggle do
		gvoice = self:GetIntByBit(gvoice, i, not self.gvoiceToggle[i].value)
	end
	return gvoice
end

function SetViewSystemState:GetBitByInt(num, index)
    return ((num >> index) & 1) == 0
end

function SetViewSystemState:GetIntByBit(num, index, b)
	if b then
		num = num + (1<<index)
	end
	return num
end

function SetViewSystemState:SwitchOn ()
    
end

function SetViewSystemState:SwitchOff ()
    
end

function SetViewSystemState:HandleJPushTagOperateResult(note)
	local data = note.body
	if data then

	end
end