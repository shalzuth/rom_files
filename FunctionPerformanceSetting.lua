using "UnityEngine"
using "RO"

autoImport("SetView");
autoImport("PushConfig")

FunctionPerformanceSetting = class("FunctionPerformanceSetting")
autoImport ("SetView")

FunctionPerformanceSetting.OriginalData = {}

function FunctionPerformanceSetting.Me()
	if nil == FunctionPerformanceSetting.me then
		FunctionPerformanceSetting.me = FunctionPerformanceSetting.new()
	end
	return FunctionPerformanceSetting.me
end

function FunctionPerformanceSetting:ctor()
	self.setting = {
		outLine = true,
		toonLight = true,
		toonLightManager = true,
		skillEffect = true,
		skillAudioEffect = true,
		effectLow = false,
		immediatelyDress = false,
		bgmVolume = 1,
		soundVolume = 1,
		autoPlayChatChannel = {ChatChannelEnum.Team , ChatChannelEnum.Zone , ChatChannelEnum.Private},
		screenCount = GameConfig.Setting.ScreenCountLow,
		isShowOtherName = true,
		showOtherChar = true,
		showDetail = SettingEnum.ShowDetailAll,
		showWedding = SettingEnum.ShowWeddingAll,
		voiceLanguage = LanguageVoice.Jananese, --todo xde ????????????
		powerMode = true,
		resolution = 1,
		showExterior = 0,
		selfPeak = true,
		otherPeak = true,
		push = 31, -- ?????????????????????31????????????0????????????????????????????????????????????????????????????????????????push?????????????????????????????????????????????????????????????????????push??????????????????????????????????????????????????????????????????
		gvoice = 0, -- 1????????????2????????????4?????????8?????????
	}

	EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene,self.OnSceneLoaded,self)
end

function FunctionPerformanceSetting:Load()
	-- self:SetBegin()
	-- -- TODO
	-- self:SetEnd()
	local isCall = pcall(function (i)
		local localSet = LocalSaveProxy.Instance:LoadSetting()
		if localSet then
			for k,v in pairs(localSet) do
				for k1,v1 in pairs(self.setting) do
					if k == k1 and nil ~= v then
						self.setting[k] = v
					end
				end
			end
		end
	end)
	self:Apply()
end

function FunctionPerformanceSetting:Save()
	LocalSaveProxy.Instance:SaveSetting(self.setting)
end

function FunctionPerformanceSetting:GetSetting()
	return self.setting
end

function FunctionPerformanceSetting:SetRunning()
	return nil ~= self.oldSetting
end

function FunctionPerformanceSetting:SetBegin()
	if self:SetRunning() then
		return
	end
	self.oldSetting = {}
	for k,v in pairs(self.setting) do
		self.oldSetting[k] = v
	end
end

function FunctionPerformanceSetting:SetOutLine(on)
	self.setting.outLine = on
end

function FunctionPerformanceSetting:SetToonLight(on, managerOn)
	self.setting.toonLight = on
	self.setting.toonLightManager = managerOn
end

function FunctionPerformanceSetting:SetSkillEffect(on)
	self.setting.skillEffect = on
end

function FunctionPerformanceSetting:SetSkillAudioEffect(on)
	self.setting.skillAudioEffect = on
end

function FunctionPerformanceSetting:SetEffectLow(on)
	self.setting.effectLow = on
end

function FunctionPerformanceSetting:SetSlim(on)
	self.setting.slim = on
end

function FunctionPerformanceSetting:SetSelfPeak(on)
	self.setting.selfPeak = on
end

function FunctionPerformanceSetting:SetOtherPeak(on)
	self.setting.otherPeak = on
end

function FunctionPerformanceSetting:SetImmediatelyDress(on)
	self.setting.immediatelyDress = on
end

function FunctionPerformanceSetting:SetBgmVolume(volume)
	self.setting.bgmVolume = volume
end

function FunctionPerformanceSetting:SetSoundVolume(volume)
	self.setting.soundVolume = volume
end

function FunctionPerformanceSetting:SetAutoPlayChatChannel(channelList)
	self.setting.autoPlayChatChannel = channelList
end

function FunctionPerformanceSetting:SetScreenCount(count)
	self.setting.screenCount = count
end

function FunctionPerformanceSetting:SetShowOtherName(on)
	self.setting.isShowOtherName = on
end

function FunctionPerformanceSetting:SetShowOtherChar(on)
	self.setting.showOtherChar = on
end

function FunctionPerformanceSetting:SetShowDetail(showDetail)
	self.setting.showDetail = showDetail
end

function FunctionPerformanceSetting:SetShowWedding(showWedding)
	self.setting.showWedding = showWedding
end

function FunctionPerformanceSetting:SetVoiceLanguage(language)
	self.setting.voiceLanguage = language
end

function FunctionPerformanceSetting:SetPowerMode(on)
	self.setting.powerMode = on
end

function FunctionPerformanceSetting:SetResolution(index)
	self.setting.resolution = index
end

function FunctionPerformanceSetting:SetShowExterior(showExterior)
	self.setting.showExterior = showExterior
end

function FunctionPerformanceSetting:SetPush(push)
	self.setting.push = push
end

function FunctionPerformanceSetting:SetGVoice(value)
	self.setting.gvoice = value
end

function FunctionPerformanceSetting:SetEnd()
	if not self:SetRunning() then
		return
	end
	local changed = false
	local changedSetting = {}
	if self.oldSetting.outLine ~= self.setting.outLine then
		changedSetting.outLine = self.setting.outLine
		changed = true
	end
	if self.oldSetting.toonLight ~= self.setting.toonLight then
		changedSetting.toonLight = self.setting.toonLight
		changed = true
	end
	if self.oldSetting.toonLightManager ~= self.setting.toonLightManager then
		changedSetting.toonLightManager = self.setting.toonLightManager
		changed = true
	end
	if self.oldSetting.skillEffect ~= self.setting.skillEffect then
		changedSetting.skillEffect = self.setting.skillEffect
		changed = true
	end
	if self.oldSetting.skillAudioEffect ~= self.setting.skillAudioEffect then
		changedSetting.skillAudioEffect = self.setting.skillAudioEffect
		changed = true
	end
	if self.oldSetting.effectLow ~= self.setting.effectLow then
		changedSetting.effectLow = self.setting.effectLow
		changed = true
	end
	if self.oldSetting.slim ~= self.setting.slim then
		changedSetting.slim = self.setting.slim
		changed = true
	end
	if self.oldSetting.selfPeak ~= self.setting.selfPeak then
		changedSetting.selfPeak = self.setting.selfPeak
		changed = true
	end
	if self.oldSetting.otherPeak ~= self.setting.otherPeak then
		changedSetting.otherPeak = self.setting.otherPeak
		changed = true
	end
	if self.oldSetting.immediatelyDress ~= self.setting.immediatelyDress then
		changedSetting.immediatelyDress = self.setting.immediatelyDress
		changed = true
	end
	if self.oldSetting.bgmVolume ~= self.setting.bgmVolume then
		changedSetting.bgmVolume = self.setting.bgmVolume
		changed = true
	end
	if self.oldSetting.soundVolume ~= self.setting.soundVolume then
		changedSetting.soundVolume = self.setting.soundVolume
		changed = true
	end
	if self.oldSetting.autoPlayChatChannel ~= self.setting.autoPlayChatChannel then
		changedSetting.autoPlayChatChannel = self.setting.autoPlayChatChannel
		changed = true
	end
	if self.oldSetting.screenCount ~= self.setting.screenCount then
		changedSetting.screenCount = self.setting.screenCount
		changed = true
	end
	if self.oldSetting.isShowOtherName ~= self.setting.isShowOtherName then
		changedSetting.isShowOtherName = self.setting.isShowOtherName
		changed = true
	end
	if self.oldSetting.showOtherChar ~= self.setting.showOtherChar then
		changedSetting.showOtherChar = self.setting.showOtherChar
		changed = true
	end
	if self.oldSetting.showDetail ~= self.setting.showDetail then
		changedSetting.showDetail = self.setting.showDetail
		changed = true
	end
	if self.oldSetting.showWedding ~= self.setting.showWedding then
		changedSetting.showWedding = self.setting.showWedding
		changed = true
	end
	if self.oldSetting.voiceLanguage ~= self.setting.voiceLanguage then
		changedSetting.voiceLanguage = self.setting.voiceLanguage
		changed = true
	end
	if self.oldSetting.powerMode ~= self.setting.powerMode then
		changedSetting.powerMode = self.setting.powerMode
		changed = true
	end
	if self.oldSetting.resolution ~= self.setting.resolution then
		changedSetting.resolution = self.setting.resolution
		changed = true
	end
	if self.oldSetting.showExterior ~= self.setting.showExterior then
		changedSetting.showExterior = self.setting.showExterior
		changed = true
	end
	if self.oldSetting.push ~= self.setting.push then
		changedSetting.push = self.setting.push
		changed = true
	end

	if self.oldSetting.gvoice ~= self.setting.gvoice then
		changedSetting.gvoice = self.setting.gvoice
		changed = true
	end
	self.oldSetting = nil

	if changed then
		self:Save()
		self:Apply(changedSetting)
	end
end

function FunctionPerformanceSetting:Apply(setting)
	setting = setting or self.setting
	
	if nil ~= setting.outLine then
		if setting.outLine then
			Game.RolePartMaterialManager:RestoreOutline()
		else
			Game.RolePartMaterialManager:DisableOutline()
		end
	end
	if nil ~= setting.toonLight then
		if setting.toonLight then
			Game.RolePartMaterialManager:RestoreToon()
		else
			Game.RolePartMaterialManager:DisableToon()
		end
	end
	if nil ~= setting.toonLightManager then
		Game.RolePartMaterialManager.enable = setting.toonLightManager
	end
	if nil ~= setting.slim then
		local flag = 0
		if self.setting.slim then
			flag = 1
		end
		ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(SceneUser2_pb.EOPTIONTYPE_USE_SLIM, flag)
	end
	if nil ~= setting.selfPeak then
		local myself = Game.Myself
		local peak = myself and myself.data.userdata:Get(UDEnum.PEAK_EFFECT) or 0
		if peak == 1 then
			if setting.selfPeak then
				myself:PlayPeakEffect()
			else
				myself:RemovePeakEffect()
			end
		end
	end
	if nil ~= setting.otherPeak then
		local allRole = NSceneUserProxy.Instance.userMap
		if allRole ~= nil then
			for k,v in pairs(allRole) do
				local peak = v and v.data.userdata:Get(UDEnum.PEAK_EFFECT) or 0
				if peak == 1 then
					if setting.otherPeak then
						v:PlayPeakEffect()
					else
						v:RemovePeakEffect()
					end
				end
			end
		end
	end
	-- if nil ~= setting.immediatelyDress then
	-- 	FunctionAvatarManager.Me():SetDelayDress(not setting.immediatelyDress)
	-- end
	if nil ~= setting.bgmVolume then
		FunctionBGMCmd.Me():SettingSetVolume(setting.bgmVolume)
	end
	if nil ~= setting.soundVolume then
		AudioUtility.SetVolume(setting.soundVolume)
	end
	if nil ~= setting.autoPlayChatChannel then
		ChatRoomProxy.Instance:ResetAutoSpeechChannel()
	end
	if nil ~= setting.screenCount then
		Game.LogicManager_RoleDress:SetLimitCount(setting.screenCount)
	end
	if nil ~= setting.showOtherChar then
		Game.LogicManager_RoleDress:SetDressDisable(not setting.showOtherChar)
	end
	if nil ~= setting.isShowOtherName then
		GameFacade.Instance:sendNotification(SetEvent.ShowOtherName)
	end
	if nil ~= setting.showDetail or nil ~= setting.showExterior or nil ~= setting.showWedding then
		ServiceNUserProxy.Instance:CallSetOptionUserCmd(self.setting.showDetail, self.setting.showExterior, self.setting.showWedding)
	end
	if nil ~= setting.powerMode then
		Game.HandUpManager:UpdateOpenState()
	end
	if nil ~= setting.resolution then
		Game.SetResolution(setting.resolution)
	end
	if nil ~= setting.push then
		local _PushEventConfig = PushConfig.EventConfig
		local list = LuaUtils.CreateStringList()
		for i=0,#_PushEventConfig do
			if ((setting.push >> i) & 1) == 0 then
				list:Add(_PushEventConfig[i])
			end
		end
		list:Add(PushConfig.Channel)

		if ApplicationInfo.IsRunOnEditor() then

		else
            -- todo xde ?????? JPUSH
			-- ROPush.SetTags(os.time(), list)
		end

	end

	if nil ~= setting.gvoice then
	end
end

function FunctionPerformanceSetting:OnSceneLoaded()
	local setting = self:GetSetting()
end

function FunctionPerformanceSetting:IsAutoPlayChatChannel(channel)
	if channel == nil then
		return false
	end

	for k,v in pairs(self.setting.autoPlayChatChannel) do
		if v == channel then
			return true
		end
	end
	return false
end

function FunctionPerformanceSetting:IsShowOtherName ()
	return self.setting.isShowOtherName == true
end

function FunctionPerformanceSetting:GetLanguangeVoice()
	return self.setting.voiceLanguage
end

function FunctionPerformanceSetting:GetPowerMode()
	return self.setting.powerMode
end

function FunctionPerformanceSetting:GetPush()
	return self.setting.push
end

function FunctionPerformanceSetting:GetGvoice()
	return self.setting.gvoice
end

local changedSetting = {}
function FunctionPerformanceSetting.EnterSavingMode()
	local tab = Game.GetResolutionNames()

	changedSetting.outLine = false
	changedSetting.toonLight = false
	changedSetting.effectLow = true
	changedSetting.screenCount = GameConfig.Setting.ScreenCountLow
	changedSetting.isShowOtherName = false
	-- changedSetting.showOtherChar = false
	changedSetting.resolution = #tab

    FunctionPerformanceSetting.Me():Apply(changedSetting)
end

function FunctionPerformanceSetting.ExitSavingMode()
	local me = FunctionPerformanceSetting.Me()

	changedSetting.outLine = me:GetSetting().outLine
	changedSetting.toonLight = me:GetSetting().toonLight
	changedSetting.effectLow = me:GetSetting().effectLow
	changedSetting.screenCount = me:GetSetting().screenCount
	changedSetting.isShowOtherName = me:GetSetting().isShowOtherName
	-- changedSetting.showOtherChar = me:GetSetting().showOtherChar
	changedSetting.resolution = me:GetSetting().resolution

    FunctionPerformanceSetting.Me():Apply(changedSetting)
end

SettingEnum = 
{
	ShowDetailAll = SceneUser2_pb.EQUERYTYPE_ALL, 
	ShowDetailFriend = SceneUser2_pb.EQUERYTYPE_FRIEND,
	ShowDetailClose = SceneUser2_pb.EQUERYTYPE_CLOSE,
	ShowWeddingAll = SceneUser2_pb.EQUERYTYPE_WEDDING_ALL, 
	ShowWeddingFriend = SceneUser2_pb.EQUERYTYPE_WEDDING_FRIEND,
	ShowWeddingClose = SceneUser2_pb.EQUERYTYPE_WEDDING_CLOSE,
}

LanguageVoice = 
{
	Chinese = 1,
	Jananese = 2,
	Korean = 3 --todo xde
}