ActivityDungeonView = class("ActivityDungeonView", ContainerView)
autoImport("ActivityDungeonInfo")
autoImport("ActivityDungeonRate")
autoImport("CostInfoCell")
autoImport("RaidEnterWaitView")
ActivityDungeonView.ViewType = UIViewType.NormalLayer
local EvaConfig = GameConfig.EVA
function ActivityDungeonView:Init()
  self:InitUI()
end
function ActivityDungeonView:OnEnter()
  ActivityDungeonView.super.OnEnter(self)
  self:CameraRotateToMe()
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  else
    self:TabChangeHandler(1)
  end
  self:AddButtonEvent("Enter", function()
    ServiceLoginUserCmdProxy.Instance:CallServerTimeUserCmd()
    self:Enter()
  end)
  self:AddListenEvt(ServiceEvent.NUserAltmanRewardUserCmd, self.UpdateRedtip)
  self:TabChangeHandler(1)
end
function ActivityDungeonView:InitUI()
  self.infoGO = self:FindGO("ActivityDungeonInfo")
  self.rateGO = self:FindGO("ActivityDungeonRate")
  self.shopGO = self:FindGO("ActivityDungeonShop")
  self.infoPage = self:AddSubView("ActivityDungeonInfo", ActivityDungeonInfo)
  self.ratePage = self:AddSubView("ActivityDungeonRate", ActivityDungeonRate)
  self.shopPage = self:AddSubView("ActivityDungeonShop", ActivityDungeonShop)
  local coinsGrid = self:FindComponent("TopCoins", UIGrid)
  self.coinsCtl = UIGridListCtrl.new(coinsGrid, CostInfoCell, "CoinInfoCell")
  if not Table_NpcFunction[EvaConfig.shopid].Parama.ItemID then
    local showCoins = {100, 151}
  end
  self.coinsCtl:ResetDatas(showCoins)
  local infoTab = self:FindGO("InfoTab")
  self:AddTabChangeEvent(infoTab, self.infoGO, PanelConfig.ActivityDungeonInfo)
  local ratingTab = self:FindGO("RatingTab")
  self:AddTabChangeEvent(ratingTab, self.rateGO, PanelConfig.ActivityDungeonRate)
  self.redtip = self:FindGO("redtip")
  local shopTab = self:FindGO("ShopTab")
  self:AddTabChangeEvent(shopTab, self.shopGO, PanelConfig.ActivityDungeonShop)
  local tabList = {
    infoTab,
    ratingTab,
    shopTab
  }
  self.tabIconSpList = {}
  for i, v in ipairs(tabList) do
    local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
  end
  ServiceNUserProxy.Instance:CallAltmanRewardUserCmd(nil, nil, 0)
end
local funcid = EvaConfig.shopid
local npcFunctionData = Table_NpcFunction[funcid]
function ActivityDungeonView:TabChangeHandler(key)
  xdlog("key")
  if ActivityDungeonView.super.TabChangeHandler(self, key) then
    if key == 1 then
    elseif key == 2 then
      ServiceNUserProxy.Instance:CallAltmanRewardUserCmd(nil, nil, 0)
    elseif key == 3 and npcFunctionData ~= nil then
      FunctionNpcFunc.Me():DoNpcFunc(npcFunctionData, Game.Myself, 1)
    end
    self:SetCurrentTabIconColor(self.coreTabMap[key].go)
  end
end
function ActivityDungeonView:OnExit()
  UIUtil.StopEightTypeMsg()
  self:CameraReset()
  ActivityDungeonView.super.OnExit(self)
end
function ActivityDungeonView:ResetTabIconColor()
  for i, v in ipairs(self.tabIconSpList) do
    v.color = ColorUtil.TabColor_White
  end
end
function ActivityDungeonView:SetCurrentTabIconColor(currentTabGo)
  self:ResetTabIconColor()
  if not currentTabGo then
    return
  end
  local iconSp = self:FindGO("Icon", currentTabGo):GetComponent(UISprite)
  if not iconSp then
    return
  end
  iconSp.color = ColorUtil.TabColor_DeepBlue
end
function ActivityDungeonView:Enter()
  if not TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByIDTable(332)
    return
  end
  local myTeam = TeamProxy.Instance.myTeam
  local memberlist = myTeam:GetMembersList()
  local hasMemberInRaid = false
  for i = 1, #memberlist do
    local raid = memberlist[i].raid
    local raidData = raid and Table_MapRaid[raid]
    if raidData and raidData.Type == FuBenCmd_pb.ERAIDTYPE_ALTMAN then
      hasMemberInRaid = true
      break
    end
  end
  if hasMemberInRaid then
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidEnterCmd(FuBenCmd_pb.ERAIDTYPE_ALTMAN)
    return
  end
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByIDTable(7303)
    return
  end
  RaidEnterWaitView.SetListenEvent(ServiceEvent.TeamRaidCmdTeamRaidReplyCmd, function(view, note)
    local charid, agree = note.body.charid, note.body.reply
    view:UpdateMemberEnterState(charid, agree)
    view:UpdateWaitList()
  end)
  RaidEnterWaitView.SetStartFunc(function(view)
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidEnterCmd(FuBenCmd_pb.ERAIDTYPE_ALTMAN)
    view:CloseSelf()
  end)
  RaidEnterWaitView.SetCancelFunc(function(view)
    view:CloseSelf()
  end)
  ServiceTeamRaidCmdProxy.Instance:CallTeamRaidInviteCmd(nil, FuBenCmd_pb.ERAIDTYPE_ALTMAN)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RaidEnterWaitView,
    viewdata = {}
  })
end
function ActivityDungeonView:UpdateRedtip()
  self.redtip:SetActive(DungeonProxy.Instance:CheckRedtip())
end
