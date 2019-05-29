local BaseCell = autoImport("BaseCell")
GuildMemberCell = class("GuildMemberCell", BaseCell)
local MAXARTIFACT = 6
function GuildMemberCell:Init()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.name = self:FindComponent("Name", UILabel)
  self.lv = self:FindComponent("Lv", UILabel)
  self.pro = self:FindComponent("Pro", UILabel)
  self.job = self:FindComponent("Job", UILabel)
  self.weekContri = self:FindComponent("WeekContri", UILabel)
  self.contribution = self:FindComponent("Contribution", UILabel)
  self.offlineTime = self:FindComponent("OffTime", UILabel)
  self.sex = self:FindComponent("Sex", UISprite)
  self.currentline = self:FindComponent("CurrentLine", UILabel)
  self.artifactPos = self:FindGO("ArtifactPos")
  self.Voice = self:FindGO("Voice")
  self.Voice.gameObject:SetActive(ApplicationInfo.NeedOpenVoiceRealtime())
  self.VoiceSwitch = self:FindGO("VoiceSwitch")
  self.VoiceSwitchOpen = self:FindGO("Open", self.VoiceSwitch)
  self.Voice_UISpirte = self:FindGO("Voice"):GetComponent(UISprite)
  if self:FindGO("VoiceSwitch") then
    self.VoiceSwitch_UISprite = self:FindGO("VoiceSwitch"):GetComponent(UISprite)
    self.VoiceSwitchOpen_UISprite = self:FindGO("Open", self.VoiceSwitch):GetComponent(UISprite)
    self:AddClickEvent(self.VoiceSwitch.gameObject, function()
      if GVoiceProxy.Instance:GetCurGuildRealTimeVoiceCount() + 1 > GameConfig.Guild.realtime_voice_limit and self.curVoiceSwitchState == false then
        MsgManager.ShowMsgByID(25860)
      elseif self.curVoiceSwitchState == true then
        helplog("if curVoiceSwitchState == true then")
        ServiceGuildCmdProxy.Instance:CallOpenRealtimeVoiceGuildCmd(self.data.id, false)
      else
        helplog("if curVoiceSwitchState == false then")
        ServiceGuildCmdProxy.Instance:CallOpenRealtimeVoiceGuildCmd(self.data.id, true)
      end
    end)
    self.Voice.gameObject:SetActive(false)
    self.VoiceSwitch.gameObject:SetActive(false)
    self.VoiceSwitchOpen.gameObject:SetActive(false)
  end
  self:AddCellClickEvent()
end
function GuildMemberCell:ShowVoiceSwitch()
  self.VoiceSwitch.gameObject:SetActive(true)
end
local tempVector3 = LuaVector3.zero
function GuildMemberCell:SetVoiceSwitchState(b)
  if self.VoiceSwitchOpen_UISprite then
    self.VoiceSwitchOpen_UISprite.height = 40
    self.VoiceSwitchOpen_UISprite.width = 40
    if b then
      self.VoiceSwitchOpen_UISprite.spriteName = "main_bg_hp02"
      tempVector3:Set(-19, 0, 0)
      self.VoiceSwitchOpen.gameObject.transform.localPosition = tempVector3
    else
      self.VoiceSwitchOpen_UISprite.spriteName = "exchange_bg_2"
      tempVector3:Set(19, 0, 0)
      self.VoiceSwitchOpen.gameObject.transform.localPosition = tempVector3
    end
    self.curVoiceSwitchState = b
  end
end
function GuildMemberCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    self.artiData = ArtifactProxy.Instance:GetMemberArti(data.id)
    if self.artiData then
      self:Show(self.artifactPos)
      self:SetMemberArtifact(self.artiData)
    else
      self:Hide(self.artifactPos)
    end
    self.name.text = data.name
    self.lv.text = data.baselevel
    self.pro.text = data.profession and Table_Class[data.profession] and Table_Class[data.profession].NameZh
    self.job.text = data:GetJobName()
    self.contribution.text = data.totalcontribution or 0
    self.weekContri.text = data.weekcontribution
    self.sex.spriteName = data:IsBoy() and "friend_icon_man" or "friend_icon_woman"
    self.widget.alpha = data:IsOffline() and 0.7 or 1
    self:UpdateTimeSymbol()
    if GVoiceProxy.Instance:IsThisCharIdRealtimeVoiceAvailable(data.id) then
      self:SetVoiceSwitchState(true)
      self.Voice.gameObject:SetActive(true)
      self.Voice.gameObject:SetActive(ApplicationInfo.NeedOpenVoiceRealtime())
    else
      self:SetVoiceSwitchState(false)
    end
  else
    self.gameObject:SetActive(false)
  end
end
local baseDepth = 9
function GuildMemberCell:SetMemberArtifact(artiData)
  if not self.artifacts then
    self.artifacts = {}
    for i = 1, MAXARTIFACT do
      self.artifacts[i] = self:FindComponent("arti" .. i, UISprite)
    end
  end
  for i = 1, MAXARTIFACT do
    if self.artifacts[i] and i <= #artiData then
      self:Show(self.artifacts[i].gameObject)
      if artiData[i] and artiData[i].itemID then
        local icon = artiData[i].itemStaticData and artiData[i].itemStaticData.Icon or ""
        IconManager:SetItemIcon(icon, self.artifacts[i])
      end
    else
      self:Hide(self.artifacts[i].gameObject)
    end
  end
end
function GuildMemberCell:UpdateTimeSymbol()
  local data = self.data
  self.offlineTime.text = ClientTimeUtil.GetFormatOfflineTimeStr(data.offlinetime)
  if not data:IsOffline() and data.zoneid ~= MyselfProxy.Instance:GetZoneId() then
    self.currentline.gameObject:SetActive(true)
    self.offlineTime.gameObject:SetActive(false)
    self.currentline.text = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid)
  else
    self.offlineTime.gameObject:SetActive(true)
    self.currentline.gameObject:SetActive(false)
  end
end
