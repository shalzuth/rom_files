GuildMemberListPage = class("GuildMemberListPage", SubView)
autoImport("GuildMemberCell")
autoImport("PlayerTipData")
function GuildMemberListPage:Init()
  self:InitUI()
  self:UpdateMemberList()
  self:UpdateInfo()
  self:MapListenEvt()
  local Label = self.onlineNum.transform.parent:GetComponent(UILabel)
  Label.pivot = UIWidget.Pivot.Left
  OverseaHostHelper:FixLabelOverV1(Label, 3, 70)
  self.onlineNum.fontSize = 17
  self.onlineNum.transform.localPosition = Vector3(74, 0, 0)
end
function GuildMemberListPage:InitUI()
  local memberWrap = self:FindGO("MemberWrapContent")
  local wrapConfig = {
    wrapObj = memberWrap,
    cellName = "GuildMemberCell",
    control = GuildMemberCell
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.ClickGuildMember, self)
  self.onlineNum = self:FindComponent("OnLineMemberNum", UILabel)
  self.buttonGrid = self:FindComponent("ButtonGrid", UIGrid)
  self.guildTreasureButton = self:FindGO("GuildTreasureButton")
  self.guildEditButton = self:FindGO("GuildEditButton")
  self.applyListButton = self:FindGO("ApplyListButton")
  self.eventButton = self:FindGO("EventButton")
  self:AddClickEvent(self.guildTreasureButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildTreasurePopUp
    })
  end)
  self:AddClickEvent(self.guildEditButton, function(go)
    FunctionSecurity.Me():GuildControl(self.DoGuildJobEdit, self)
  end)
  self:AddClickEvent(self.applyListButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildApplyListPopUp
    })
  end)
  self:AddClickEvent(self.eventButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildEventPopUp
    })
  end)
  self.GuildVoiceButton = self:FindGO("GuildVoiceButton")
  if self.GuildVoiceButton then
    self.GuildVoiceButton.gameObject:SetActive(ApplicationInfo.NeedOpenVoiceRealtime())
  end
  self.GuildVoiceButtonBlackBG = self:FindGO("BlackBG", self.GuildVoiceButton)
  self.GuildVoiceButtonVoiceButtonGrid = self:FindGO("VoiceButtonGrid", self.GuildVoiceButton)
  self.GuildVoiceButtonVoiceButtonGridButton1 = self:FindGO("Button1", self.GuildVoiceButtonVoiceButtonGrid)
  self.GuildVoiceButtonVoiceButtonGridButton2 = self:FindGO("Button2", self.GuildVoiceButtonVoiceButtonGrid)
  self.GuildVoiceButtonVoiceButtonGridButton3 = self:FindGO("Button3", self.GuildVoiceButtonVoiceButtonGrid)
  if self.GuildVoiceButtonVoiceButtonGridButton3 then
    self.GuildVoiceButtonBlackBG.gameObject:SetActive(false)
    self.GuildVoiceButtonVoiceButtonGrid.gameObject:SetActive(false)
    self:AddClickEvent(self.GuildVoiceButton, function(go)
      self.ShowGuildVoicePanel.gameObject:SetActive(not self.ShowGuildVoicePanel.gameObject.activeInHierarchy)
    end)
    self.ShowGuildVoicePanel = self:FindGO("ShowGuildVoicePanel")
    self.ShowGuildVoicePanelView = self:FindGO("View", self.ShowGuildVoicePanel)
    self.ShowGuildVoicePanelViewCloseButton = self:FindGO("CloseButton", self.ShowGuildVoicePanelView)
    self.ShowGuildVoicePanelViewVoiceButtonGrid = self:FindGO("VoiceButtonGrid", self.ShowGuildVoicePanelView)
    self.ShowGuildVoicePanelViewVoiceButtonGridButton1 = self:FindGO("Button1", self.ShowGuildVoicePanelViewVoiceButtonGrid)
    self.ShowGuildVoicePanelViewVoiceButtonGridButton2 = self:FindGO("Button2", self.ShowGuildVoicePanelViewVoiceButtonGrid)
    self.ShowGuildVoicePanelViewVoiceButtonGridButton3 = self:FindGO("Button3", self.ShowGuildVoicePanelViewVoiceButtonGrid)
    if self.ShowGuildVoicePanel then
      self.ShowGuildVoicePanel.gameObject:SetActive(false)
      self:AddClickEvent(self.ShowGuildVoicePanelViewCloseButton, function(go)
        self.ShowGuildVoicePanel.gameObject:SetActive(not self.ShowGuildVoicePanel.gameObject.activeInHierarchy)
      end)
      self:AddClickEvent(self.ShowGuildVoicePanelViewVoiceButtonGridButton1, function(go)
        if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Voice) then
          self.ShowGuildVoicePanel.gameObject:SetActive(not self.ShowGuildVoicePanel.gameObject.activeInHierarchy)
        end
      end)
      self:AddClickEvent(self.ShowGuildVoicePanelViewVoiceButtonGridButton2, function(go)
        if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Voice) then
          self.ShowGuildVoicePanel.gameObject:SetActive(not self.ShowGuildVoicePanel.gameObject.activeInHierarchy)
          self:GuildOpenVoice()
        else
        end
      end)
      self:AddClickEvent(self.ShowGuildVoicePanelViewVoiceButtonGridButton3, function(go)
        local data = Table_Help[522]
        if data ~= nil then
          self:OpenHelpView(data)
        end
        self.ShowGuildVoicePanel.gameObject:SetActive(not self.ShowGuildVoicePanel.gameObject.activeInHierarchy)
      end)
      if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Voice) then
        self:SetThisButtonToBlue(self.ShowGuildVoicePanelViewVoiceButtonGridButton2)
        self:SetThisButtonToBlue(self.ShowGuildVoicePanelViewVoiceButtonGridButton1)
      else
        self:SetThisButtonToGray(self.ShowGuildVoicePanelViewVoiceButtonGridButton2)
        self:SetThisButtonToGray(self.ShowGuildVoicePanelViewVoiceButtonGridButton1)
      end
    end
  end
end
function GuildMemberListPage:SetThisButtonToGray(go)
  local button_Sprite = go:GetComponent(UISprite)
  button_Sprite.spriteName = "com_btn_13"
end
function GuildMemberListPage:SetThisButtonToBlue(go)
  local button_Sprite = go:GetComponent(UISprite)
  button_Sprite.spriteName = "com_btn_1"
end
function GuildMemberListPage:DoGuildJobEdit()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GuildJobEditPopUp
  })
end
function GuildMemberListPage:ClickGuildMember(cellCtl)
  local guildData = cellCtl.data
  local myid = Game.Myself.data.id
  local bg = self:FindComponent("Bg", UISprite, cellCtl.gameObject)
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(bg, NGUIUtil.AnchorSide.Center, {-180, 45})
  local ptdata = PlayerTipData.new()
  ptdata:SetByGuildMemberData(guildData)
  local funckeys = {
    "SendMessage",
    "AddFriend",
    "InviteMember",
    "ChangeGuildJob",
    "KickGuildMember",
    "ShowDetail",
    "Tutor_InviteBeStudent",
    "Tutor_InviteBeTutor",
    "AddBlacklist",
    "DistributeArtifact",
    "TalkAuthorization"
  }
  local myFunckeys = {
    "DistributeArtifact"
  }
  local tipData = {
    playerData = ptdata,
    funckeys = guildData.id ~= myid and funckeys or myFunckeys
  }
  function tipData.clickcallback(funcData)
    if funcData and funcData.key == "SendMessage" then
      self.container:CloseSelf()
    end
  end
  playerTip:SetData(tipData)
end
function GuildMemberListPage:GuildOpenVoice(cellCtl)
  if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Voice) then
    helplog("====\230\136\145\230\156\137\230\157\131\233\153\144===" .. GVoiceProxy.Instance:GetCurGuildRealTimeVoiceCount())
    for k, v in pairs(self.wraplist:GetCellCtls()) do
      v:ShowVoiceSwitch()
    end
  else
    helplog("====\230\136\145\230\178\161\230\156\137\230\157\131\233\153\144===")
  end
end
function GuildMemberListPage:UpdateInfo()
  local guildData = GuildProxy.Instance.myGuildData
  local onlineMembers = guildData:GetOnlineMembers()
  self.onlineNum.text = string.format("%s/%s", tostring(#onlineMembers), tostring(guildData.memberNum))
  local myGuildMemberInfo = GuildProxy.Instance:GetMyGuildMemberData()
  if not myGuildMemberInfo then
    errorLog("Cannot Find myGuildMemberInfo")
    return
  end
  local canLetIn = GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.PermitJoin)
  self.applyListButton:SetActive(canLetIn)
  local editauth_value = guildData:GetJobEditAuth(myGuildMemberInfo.job)
  self.guildEditButton:SetActive(editauth_value > 0)
  self.buttonGrid:Reposition()
end
function GuildMemberListPage:UpdateMemberList()
  local memberList = GuildProxy.Instance.myGuildData:GetMemberList()
  table.sort(memberList, function(a, b)
    local aOffline, bOffline = a:IsOffline(), b:IsOffline()
    if aOffline ~= bOffline then
      return not aOffline
    end
    if a.job ~= b.job then
      return a.job < b.job
    end
    if a.contribution ~= b.contribution then
      return a.contribution > b.contribution
    end
    return a.id < b.id
  end)
  self.wraplist:ResetDatas(memberList)
end
function GuildMemberListPage:MapListenEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.HandleMemberDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd, self.HandleMemberDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.HandleMemberDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdJobUpdateGuildCmd, self.HandleMemberDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd, self.UpdateMemberList)
  self:AddListenEvt(ServiceEvent.GuildCmdArtifactOptGuildCmd, self.UpdateMemberList)
end
function GuildMemberListPage:HandleMemberDataUpdate(note)
  self:UpdateInfo()
  self:UpdateMemberList()
end
function GuildMemberListPage:OnEnter()
  GuildMemberListPage.super.OnEnter(self)
  ArtifactProxy.Instance:SetDistributeActiveFlag(true)
end
function GuildMemberListPage:OnExit()
  GuildMemberListPage.super.OnExit(self)
  ArtifactProxy.Instance:SetDistributeActiveFlag(false)
end
