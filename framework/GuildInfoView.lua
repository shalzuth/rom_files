GuildInfoView = class("GuildInfoView", ContainerView)
GuildInfoView.ViewType = UIViewType.NormalLayer
autoImport("GuildInfoPage")
autoImport("GuildMemberListPage")
autoImport("GuildFaithPage")
autoImport("GuildFindPage")
autoImport("GuildAssetPage")
GuildInfoView.TabName = {
  [1] = ZhString.GuildInfoView_TabName1,
  [2] = ZhString.GuildInfoView_TabName2,
  [3] = ZhString.GuildInfoView_TabName3,
  [4] = ZhString.GuildInfoView_TabName4,
  [5] = ZhString.GuildInfoView_TabName5
}
function GuildInfoView:Init()
  self:InitUI()
  self:DisableTog()
  self:MapListenEvt()
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  end
end
function GuildInfoView:InitUI()
  local togglesParentObj = self:FindGO("Toggles")
  local toggleList = {}
  local longPressList = {}
  for i = 1, 5 do
    do
      local toggleName = "Toggle" .. i
      local toggleObj = self:FindGO(toggleName, togglesParentObj)
      toggleList[#toggleList + 1] = toggleObj
      local toggleLongPress = toggleObj:GetComponent(UILongPress)
      function toggleLongPress.pressEvent(obj, state)
        self:PassEvent(TipLongPressEvent.GuildInfoView, {state, i})
      end
      longPressList[#longPressList + 1] = toggleLongPress
    end
    break
  end
  if toggleList[1] == nil then
    toggleList[1] = self:FindGO("Infomation", togglesParentObj)
    toggleList[2] = self:FindGO("Member", togglesParentObj)
    toggleList[3] = self:FindGO("Faith", togglesParentObj)
    toggleList[4] = self:FindGO("FindGuild", togglesParentObj)
    toggleList[5] = self:FindGO("Asset", togglesParentObj)
  end
  self.assetTog = toggleList[5]
  self:AddEventListener(TipLongPressEvent.GuildInfoView, self.HandleLongPress, self)
  local infoBord = self:FindGO("InfoBord")
  local memberBord = self:FindGO("MemberBord")
  local faithBord = self:FindGO("GAttriBord")
  local findBord = self:FindGO("FindBord")
  local assetBord = self:FindGO("AssetBord")
  if not GameConfig.SystemForbid.TabNameTip then
    for k, v in pairs(toggleList) do
      local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
      icon:SetActive(true)
      local nameLabel = GameObjectUtil.Instance:DeepFindChild(v, "NameLabel")
      nameLabel:SetActive(false)
    end
  else
    for k, v in pairs(toggleList) do
      local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
      icon:SetActive(false)
      local nameLabel = GameObjectUtil.Instance:DeepFindChild(v, "NameLabel")
      nameLabel:SetActive(true)
    end
  end
  local ihaveGuild = GuildProxy.Instance:IHaveGuild()
  if ihaveGuild then
    self:AddSubView("GuildInfoPage", GuildInfoPage)
    self:AddSubView("GuildMemberListPage", GuildMemberListPage)
    self.viewdata.view.tab = 1
  else
    self.disableTabs = {1, 2}
    self:AddSubView("GuildFindPage", GuildFindPage, findBord)
    toggleList[4]:SetActive(true)
    toggleList[1]:SetActive(false)
    local hasFaith = false
    local myfaithData = Game.Myself.data.guildPray
    for i = 1, #myfaithData do
      local fdata = myfaithData[i]
      if fdata.level > 0 then
        hasFaith = true
        break
      end
    end
    if not hasFaith then
      table.insert(self.disableTabs, 3)
    end
    self.viewdata.view.tab = 4
  end
  self:AddSubView("GuildFaithPage", GuildFaithPage)
  self:AddSubView("GuildAssetPage", GuildAssetPage)
  self:AddTabChangeEvent(toggleList[1], infoBord, PanelConfig.GuildInfoPage)
  self:AddTabChangeEvent(toggleList[2], memberBord, PanelConfig.GuildMemberListPage)
  self:AddTabChangeEvent(toggleList[3], faithBord, PanelConfig.GuildFaithPage)
  self:AddTabChangeEvent(toggleList[4], findBord, PanelConfig.GuildFindPage)
  self:AddTabChangeEvent(toggleList[5], assetBord, PanelConfig.GuildAssetPage)
  local applyListButton = self:FindGO("ApplyListButton")
  if toggleList[2] then
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GUILD_APPLY, UIUtil.GetAllComponentInChildren(toggleList[2], UISprite), 26)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GUILD_APPLY, UIUtil.GetAllComponentInChildren(applyListButton, UISprite), 26)
  end
end
function GuildInfoView:TabChangeHandler(key)
  local ret = GuildInfoView.super.TabChangeHandler(self, key)
  if PanelConfig.GuildInfoPage.tab == key then
    FunctionGuild.Me():QueryGuildItemList()
  elseif PanelConfig.GuildAssetPage.tab == key then
  end
  if ret and not GameConfig.SystemForbid.TabNameTip then
    local tab = self.coreTabMap[key]
    if tab then
      if self.currentKey then
        local iconSp = GameObjectUtil.Instance:DeepFindChild(self.coreTabMap[self.currentKey].go, "Icon"):GetComponent(UISprite)
        iconSp.color = ColorUtil.TabColor_White
      end
      self.currentKey = key
      local iconSp = GameObjectUtil.Instance:DeepFindChild(tab.go, "Icon"):GetComponent(UISprite)
      iconSp.color = ColorUtil.TabColor_DeepBlue
    end
  end
end
function GuildInfoView:DisableTog()
  local disableTabs = self.disableTabs
  if disableTabs then
    for i = 1, #disableTabs do
      local tab = self.coreTabMap[disableTabs[i]]
      if tab and tab.go then
        self:SetTextureGrey(tab.go)
        tab.go:GetComponent(BoxCollider).enabled = false
      end
    end
  end
end
function GuildInfoView:MapListenEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.QueryGuildItemList)
  self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd, self.HandleExitGuild)
end
function GuildInfoView:QueryGuildItemList()
  FunctionGuild.Me():QueryGuildItemList()
end
function GuildInfoView:HandleClose()
  self:CloseSelf()
end
function GuildInfoView:HandleExitGuild()
  self:CloseSelf()
end
function GuildInfoView:PlayLvUpEffect()
  local myGuildMemberData = GuildProxy.Instance:GetMyGuildMemberData()
  if myGuildMemberData then
    local needShowEffect = myGuildMemberData:NeedPlayLevelUpEffect()
    if needShowEffect then
      FunctionGuild.Me():PlayUpgradeEffect()
    end
  end
end
function GuildInfoView:OnEnter()
  EventManager.Me():AddEventListener(GuildChallengeEvent.CloseUI, self.HandleClose, self)
  GuildInfoView.super.OnEnter(self)
  self:PlayLvUpEffect()
  ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(true)
end
function GuildInfoView:OnExit()
  EventManager.Me():RemoveEventListener(GuildChallengeEvent.CloseUI, self.HandleClose, self)
  ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(false)
  GuildInfoView.super.OnExit(self)
end
function GuildInfoView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  if not GameConfig.SystemForbid.TabNameTip then
    if isPressing then
      local backgroundSp = GameObjectUtil.Instance:DeepFindChild(self.coreTabMap[index].go, "Background"):GetComponent(UISprite)
      TipManager.Instance:TryShowHorizontalTabNameTip(GuildInfoView.TabName[index], backgroundSp, NGUIUtil.AnchorSide.Left)
    else
      TipManager.Instance:CloseTabNameTipWithFadeOut()
    end
  end
end
