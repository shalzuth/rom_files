GuildFaithPage = class("GuildFaithPage", SubView)
autoImport("GFaithTypeCell")
autoImport("GAstrolabeAttriCell")
autoImport("GvGPvpAttrCell")
autoImport("GvGPvpPrayData")
GuildFaithPage.TabName = {
  faithTitle = ZhString.GuildFaithPage_FaithTabName,
  astroTitle = ZhString.GuildFaithPage_AstroTabName
}
local titleDeepColor = Color(0.2627450980392157, 0.30196078431372547, 0.5529411764705883, 1)
local titleNormalColor = Color(0.5450980392156862, 0.5450980392156862, 0.5450980392156862, 1)
function GuildFaithPage:Init()
  self:InitUI()
  self:MapEvent()
end
function GuildFaithPage:InitUI()
  local goPrayButton = self:FindGO("GoPrayButton")
  self:AddClickEvent(goPrayButton, function(go)
    self:TraceNpc(2)
  end)
  local goAstrolabeButton = self:FindGO("GoAstrolabeButton")
  self:AddClickEvent(goAstrolabeButton, function(go)
    self:TraceNpc(6270)
  end)
  local faithGrid = self:FindComponent("FaithTypeGrid", UIGrid)
  self.faithAttriCtl = UIGridListCtrl.new(faithGrid, GFaithTypeCell, "GFaithTypeCell")
  local astrolabeGrid = self:FindComponent("AstrolabeGrid", UIGrid)
  self.astrolabeCtl = UIGridListCtrl.new(astrolabeGrid, GAstrolabeAttriCell, "GAstrolabeAttriCell")
  local gvgPvpAttrGrid1 = self:FindComponent("gvgPvpAttrGrid1", UIGrid)
  local gvgPvpAttrGrid2 = self:FindComponent("gvgPvpAttrGrid2", UIGrid)
  local gvgPvpAttrGrid3 = self:FindComponent("gvgPvpAttrGrid3", UIGrid)
  self.gvgPvpAttrCtl1 = UIGridListCtrl.new(gvgPvpAttrGrid1, GvGPvpAttrCell, "GvGPvpAttrCell")
  self.gvgPvpAttrCtl2 = UIGridListCtrl.new(gvgPvpAttrGrid2, GvGPvpAttrCell, "GvGPvpAttrCell")
  self.gvgPvpAttrCtl3 = UIGridListCtrl.new(gvgPvpAttrGrid3, GvGPvpAttrCell, "GvGPvpAttrCell")
  self.gvgPvpAttrBord = self:FindGO("gvgPvpAttrBord")
  self.astrolabeBord = self:FindGO("AstrolabeBord")
  self.lockTip = self:FindGO("LockTip")
  self.gvgPvpLockTip = self:FindGO("gvgPvpLockTip")
  self.faithRoot = self:FindGO("faithRoot")
  self.astroRoot = self:FindGO("astroRoot")
  self.faithTitle = self:FindGO("faithTitle")
  self.faithTitleLabel = self:FindComponent("Label", UILabel, self.faithTitle)
  self.faithTitleImg = self:FindGO("ChooseImg", self.faithTitle)
  self.faithTitleIcon = self:FindComponent("Icon", UISprite, self.faithTitle)
  self:AddClickEvent(self.faithTitle, function()
    self:UpdateFaithGrid()
  end)
  self.astroTitle = self:FindGO("astroTitle")
  self.astroTitleLabel = self:FindComponent("Label", UILabel, self.astroTitle)
  self.astroTitleImg = self:FindGO("ChooseImg", self.astroTitle)
  self.astroTitleIcon = self:FindComponent("Icon", UISprite, self.astroTitle)
  self:AddClickEvent(self.astroTitle, function()
    self:UpdateAstrolabeGrid()
  end)
  self:InitFaithGrid()
  local tabList = {
    self.faithTitle,
    self.astroTitle
  }
  for i, v in ipairs(tabList) do
    local longPress = v:GetComponent(UILongPress)
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.GuildFaithPage, {
        state,
        obj.gameObject
      })
    end
  end
  self:AddEventListener(TipLongPressEvent.GuildFaithPage, self.HandleLongPress, self)
  local iconActive, nameLabelActive
  if not GameConfig.SystemForbid.TabNameTip then
    iconActive = true
    nameLabelActive = false
  else
    iconActive = false
    nameLabelActive = true
  end
  self.faithTitleIcon.gameObject:SetActive(iconActive)
  self.astroTitleIcon.gameObject:SetActive(iconActive)
  self.faithTitleLabel.gameObject:SetActive(nameLabelActive)
  self.astroTitleLabel.gameObject:SetActive(nameLabelActive)
end
local tempArgs = {}
function GuildFaithPage:TraceNpc(uniqueid)
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
  elseif GuildProxy.Instance:IHaveGuild() then
    local currentRaidID = SceneProxy.Instance:GetCurRaidID()
    local raidData = currentRaidID and Table_MapRaid[currentRaidID]
    if raidData and raidData.Type == 10 then
      TableUtility.TableClear(tempArgs)
      tempArgs.npcUID = uniqueid
      local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandVisitNpc)
      if cmd then
        Game.Myself:Client_SetMissionCommand(cmd)
      end
      self.container:CloseSelf()
    else
      ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
    end
  else
    MsgManager.ShowMsgByIDTable(2620)
  end
end
function GuildFaithPage:_setTitleToggleState(isFaith)
  if isFaith then
    self.faithTitleLabel.color = titleDeepColor
    self.astroTitleLabel.color = titleNormalColor
    self.faithTitleIcon.color = titleDeepColor
    self.astroTitleIcon.color = titleNormalColor
    self:Hide(self.astroTitleImg)
    self:Show(self.faithTitleImg)
    self:Show(self.faithRoot)
    self:Hide(self.astroRoot)
  else
    self.faithTitleLabel.color = titleNormalColor
    self.astroTitleLabel.color = titleDeepColor
    self.faithTitleIcon.color = titleNormalColor
    self.astroTitleIcon.color = titleDeepColor
    self:Show(self.astroTitleImg)
    self:Hide(self.faithTitleImg)
    self:Show(self.astroRoot)
    self:Hide(self.faithRoot)
  end
end
function GuildFaithPage:InitFaithGrid()
  self.faithDatas = {}
  local myfaithData = Game.Myself.data.guildPray
  for _, data in pairs(myfaithData) do
    table.insert(self.faithDatas, data)
  end
  table.sort(self.faithDatas, function(a, b)
    return a.staticData.id < b.staticData.id
  end)
end
function GuildFaithPage:UpdateFaithGrid()
  self:_setTitleToggleState(true)
  self.faithAttriCtl:ResetDatas(self.faithDatas)
  if not GameConfig.SystemForbid.GvGPvP_Pray then
    self:UpdateGvgPvpGrid()
    self:Hide(self.gvgPvpLockTip)
  else
    self:Show(self.gvgPvpLockTip)
  end
end
function GuildFaithPage.SortRule(a, b)
  return a[1] < b[1]
end
function GuildFaithPage:UpdateGvgPvpGrid()
  local gvgPvpPray = Game.Myself.data.gvgPvpPray
  local datas = {
    [1] = {},
    [2] = {},
    [3] = {}
  }
  for i = 1, #gvgPvpPray do
    local typeData = gvgPvpPray[i]
    for j = 1, #typeData do
      local attr = typeData[j]:GetAddAttrValue()
      local cellData = {
        attr[2],
        attr[3],
        attr[7]
      }
      table.insert(datas[i], cellData)
    end
  end
  self.gvgPvpAttrCtl1:ResetDatas(datas[1])
  self.gvgPvpAttrCtl2:ResetDatas(datas[2])
  self.gvgPvpAttrCtl3:ResetDatas(datas[3])
end
function GuildFaithPage:UpdateAstrolabeGrid()
  self:_setTitleToggleState(false)
  local attriMap = AstrolabeProxy.Instance:GetEffectMap()
  local datas = {}
  for key, value in pairs(attriMap) do
    local cdata = {key, value}
    table.insert(datas, cdata)
  end
  if #datas > 0 then
    self.astrolabeBord:SetActive(true)
    self.lockTip:SetActive(false)
    self.astrolabeBord:SetActive(#datas > 0)
    table.sort(datas, GuildFaithPage.SortRule)
    self.astrolabeCtl:ResetDatas(datas)
  else
    self.astrolabeBord:SetActive(false)
    self.lockTip:SetActive(true)
  end
end
function GuildFaithPage:MapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.UpdateFaithGrid)
end
function GuildFaithPage:OnEnter()
  GuildFaithPage.super.OnEnter(self)
  self:UpdateFaithGrid()
end
function GuildFaithPage:OnExit()
  GuildFaithPage.super.OnExit(self)
end
function GuildFaithPage:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  if not GameConfig.SystemForbid.TabNameTip then
    if isPressing then
      local sp = self:FindComponent("ChooseImg", UISprite, go)
      TipManager.Instance:TryShowVerticalTabNameTip(GuildFaithPage.TabName[go.name], sp, NGUIUtil.AnchorSide.Down, {133, -58})
    else
      TipManager.Instance:CloseTabNameTipWithFadeOut()
    end
  end
end
