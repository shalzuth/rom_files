autoImport("RecallItemCell")
autoImport("RecallFriendCell")
RecallView = class("RecallView", ContainerView)
RecallView.ViewType = UIViewType.NormalLayer
local _bgName = "recall_bg_cat"
local friendList = {}
local _tipData = {}
_tipData.funcConfig = {}
local _friendTipData = {}
_friendTipData.funckeys = {
  "SendMessage",
  "DeleteFriend",
  "ShowDetail",
  "AddBlacklist",
  "InviteEnterGuild"
}
function RecallView:OnEnter()
  RecallView.super.OnEnter(self)
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
end
function RecallView:OnExit()
  PictureManager.Instance:UnLoadRecall(_bgName, self.bg)
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
  RecallView.super.OnExit(self)
end
function RecallView:Init()
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
end
function RecallView:FindObj()
  self.bg = self:FindGO("BgTexture"):GetComponent(UITexture)
  self.recallTip = self:FindGO("RecallTip"):GetComponent(UILabel)
end
function RecallView:AddButtonEvt()
  local helpBtn = self:FindGO("HelpBtn")
  self:AddClickEvent(helpBtn, function()
    local data = Table_Help[20004]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc)
    end
  end)
end
function RecallView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateRecallFriend)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.UpdateRecallFriend)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.UpdateRecallFriend)
end
function RecallView:InitShow()
  TableUtility.ArrayClear(friendList)
  PictureManager.Instance:SetRecall(_bgName, self.bg)
  local rewardRoot = self:FindGO("RewardRoot", self.recallRoot):GetComponent(UIGrid)
  local rewardCtl = UIGridListCtrl.new(rewardRoot, RecallItemCell, "RecallItemCell")
  rewardCtl:AddEventListener(MouseEvent.MouseClick, self.ClickRecallItem, self)
  local rewardList = ItemUtil.GetRewardItemIdsByTeamId(GameConfig.Recall.ShowReward)
  if rewardList ~= nil then
    rewardCtl:ResetDatas(rewardList)
  end
  local recallContainer = self:FindGO("Container", self.recallRoot)
  self.recallFriendHelper = WrapListCtrl.new(recallContainer, RecallFriendCell, "RecallFriendCell", WrapListCtrl_Dir.Vertical, 2, 390)
  self.recallFriendHelper:AddEventListener(FriendEvent.SelectHead, self.ClickFriendHead, self)
  self:UpdateRecallFriend()
end
function RecallView:UpdateRecallFriend()
  local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData()
  local data = self:GetFriendData()
  if isQuerySocialData then
    self.recallFriendHelper:ResetDatas(data)
    local tip = ""
    if #data == 0 then
      local help = Table_Help[927]
      if help ~= nil then
        tip = help.Desc
      end
    end
    self.recallTip.text = tip
  end
end
function RecallView:GetFriendData()
  local data = FriendProxy.Instance:GetFriendData()
  TableUtility.ArrayClear(friendList)
  for i = 1, #data do
    if data[i]:CheckCanRecall() or data[i].waitRecall then
      friendList[#friendList + 1] = data[i].guid
    end
  end
  return friendList
end
function RecallView:ClickRecallItem(cell)
  local data = cell.data
  if data then
    _tipData.itemdata = data
    self:ShowItemTip(_tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
function RecallView:ClickFriendHead(cell)
  local data = cell.data
  if data then
    local playerData = PlayerTipData.new()
    playerData:SetByFriendData(data)
    FunctionPlayerTip.Me():CloseTip()
    _friendTipData.playerData = playerData
    FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380, 60}, _friendTipData)
  end
end
