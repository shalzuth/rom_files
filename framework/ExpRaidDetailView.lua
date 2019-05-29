autoImport("ItemCell")
ExpRaidDetailView = class("ExpRaidDetailView", BaseView)
ExpRaidDetailView.ViewType = UIViewType.NormalLayer
function ExpRaidDetailView:Init()
  self:FindObjs()
  self:InitShow()
  self:AddEvents()
end
function ExpRaidDetailView:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.bannerTex = self:FindComponent("Banner", UITexture)
  self.leftLvLabel = self:FindComponent("LeftLvLabel", UILabel)
  self.rightLvLabel = self:FindComponent("RightLvLabel", UILabel)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.matchButton = self:FindGO("MatchButton")
  self.container = self:FindGO("Container")
  self.jobUp = self:FindGO("JobUp")
  self.baseUp = self:FindGO("BaseUp")
  self.tipStick = self:FindComponent("TipStick", UISprite)
  self.grid = self:FindComponent("Grid", UIGrid)
end
function ExpRaidDetailView:InitShow()
  local id = self.viewdata.viewdata
  self.raidData = Table_ExpRaid[id]
  self.titleLabel.text = Table_MapRaid[self.raidData.id].NameZh
  self.descLabel.text = self.raidData.Desc
  self.leftLvLabel.text = string.format(ZhString.ExpRaid_LeftLvLabel, self.raidData.Level)
  self.rightLvLabel.text = string.format(ZhString.ExpRaid_RightLvLabel, self.raidData.RecommendLv[1], self.raidData.RecommendLv[2] or 0)
  self.rewardCtl = UIGridListCtrl.new(self.grid, BagItemCell, "BagItemCell")
  self:UpdateRewards()
  self.tipData = {}
  self.tipData.funcConfig = {}
end
function ExpRaidDetailView:AddEvents()
  self:AddClickEvent(self.matchButton, function()
    self:OnMatchClick()
  end)
  self:AddClickEvent(self.jobUp, function()
    MsgManager.ShowMsg(nil, ZhString.ExpRaid_JobUpDesc, 1)
  end)
  self:AddClickEvent(self.baseUp, function()
    MsgManager.ShowMsg(nil, ZhString.ExpRaid_BaseUpDesc, 1)
  end)
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self:AddListenEvt(ExpRaidEvent.MapViewClose, self.CloseSelf)
end
function ExpRaidDetailView:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    self.tipData.itemdata = cellCtl.data
    self:ShowItemTip(self.tipData, self.tipStick, NGUIUtil.AnchorSide.Up)
  end
end
function ExpRaidDetailView:OnEnter()
  ExpRaidDetailView.super.OnEnter(self)
  PictureManager.Instance:SetExpRaid(self.raidData.Banner, self.bannerTex)
end
function ExpRaidDetailView:OnExit()
  if self.delayedEnableMatchClick then
    self.delayedEnableMatchClick:cancel()
    self.delayedEnableMatchClick = nil
  end
  ReusableTable.DestroyAndClearArray(self.rewardItemDataList)
  PictureManager.Instance:UnLoadExpRaid(self.raidData.Banner, self.bannerTex)
  ExpRaidDetailView.super.OnExit(self)
end
function ExpRaidDetailView:OnMatchClick()
  if self.matchClickDisabled then
    return
  end
  if ExpRaidProxy.Instance:GetExpRaidTimesLeft() <= 0 then
    MsgManager.ShowMsgByID(25902)
    return
  end
  local matchStatus = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus then
    MsgManager.ShowMsgByID(25917)
    return
  end
  if MyselfProxy.Instance:RoleLevel() < self.raidData.Level then
    MsgManager.ShowMsgByID(7301, self.raidData.Level)
    return
  end
  if TeamProxy.Instance:IHaveTeam() then
    if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      MsgManager.ShowMsgByID(25608)
      return
    end
    local list = TeamProxy.Instance.myTeam:GetPlayerMemberList(false, true)
    for _, v in pairs(list) do
      if v:IsOffline() then
        MsgManager.ShowMsgByID(25903)
        return
      end
    end
    local memberListExceptMe = TeamProxy.Instance.myTeam:GetMembersListExceptMe()
    for i = 1, #memberListExceptMe do
      if memberListExceptMe[i].baselv < self.raidData.Level then
        MsgManager.ShowMsgByID(7305, self.raidData.Level)
        return
      end
    end
  end
  self:CallMatch()
end
function ExpRaidDetailView:UpdateRewards()
  self.rewardItemDataList = ReusableTable.CreateArray()
  local jobItemData = ItemData.new("JobExp", 400)
  local baseItemData = ItemData.new("BaseExp", 300)
  table.insert(self.rewardItemDataList, jobItemData)
  table.insert(self.rewardItemDataList, baseItemData)
  self:UpdateRewardsByType("SpecReward", self.rewardItemDataList)
  self:UpdateRewardsByType("NormalReward", self.rewardItemDataList)
  self.rewardCtl:ResetDatas(self.rewardItemDataList)
end
function ExpRaidDetailView:UpdateRewardsByType(typeString, rewardItemDataList)
  local rewardTeamIds = self.raidData[typeString]
  if not rewardTeamIds or not next(rewardTeamIds) then
    return
  end
  for i = 1, #rewardTeamIds do
    local rewardItemIds = ItemUtil.GetRewardItemIdsByTeamId(rewardTeamIds[i])
    if rewardItemIds and next(rewardItemIds) then
      for _, data in pairs(rewardItemIds) do
        local item = ItemData.new("Reward", data.id)
        table.insert(rewardItemDataList, item)
      end
    end
  end
end
function ExpRaidDetailView:CallMatch()
  if self.matchClickDisabled then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.ExpRaid, self.raidData.id)
  self.matchClickDisabled = true
  MsgManager.ShowMsg(nil, ZhString.ExpRaid_CallMatch, 1)
  self.delayedEnableMatchClick = LeanTween.delayedCall(3, function()
    self.matchClickDisabled = false
    self.delayedEnableMatchClick = nil
  end)
end
