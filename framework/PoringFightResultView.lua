autoImport("BaseView")
PoringFightResultView = class("PoringFightResultView", BaseView)
PoringFightResultView.ViewType = UIViewType.NormalLayer
autoImport("HeadImageData")
autoImport("ColliderItemCell")
local headIconCell_Path = ResourcePathHelper.UICell("HeadIconCell")
function PoringFightResultView:Init()
  self.rankIndex = self:FindComponent("RankIndex", UILabel)
  self.noRank = self:FindGO("NoRank")
  local rGrid = self:FindComponent("RewardGrid", UIGrid)
  self.rewardCtl = UIGridListCtrl.new(rGrid, ColliderItemCell, "ColliderItemCell")
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItemCell, self)
  self.rewardCells = self.rewardCtl:GetCells()
  for i = 1, #self.rewardCells do
    self.rewardCells[i]:SetMinDepth(3)
  end
  local confirmButton = self:FindGO("ConfirmButton")
  self:AddClickEvent(confirmButton, function(go)
    self:DoGetReward()
  end)
  self.myHeadData = HeadImageData.new()
  self:MapEvent()
end
function PoringFightResultView:ClickItemCell(cell)
  local data = cell.data
  if data == nil then
    self:ShowItemTip()
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {},
    ignoreBounds = ignoreBounds,
    callback = callback,
    hideGetPath = true
  }
  self:ShowItemTip(sdata, cell.bg, NGUIUtil.AnchorSide.Left, {-212, 0})
end
function PoringFightResultView:DoGetReward()
  if self.confirmCall then
    self.confirmCall(self.confirmCallParam, self.confirButtonData)
  end
  ServiceNUserProxy.Instance:ReturnToHomeCity()
  self:CloseSelf()
end
function PoringFightResultView:UpdateInfo()
  local myRank = 1
  for i = 1, #self.rankInfos do
    local rankInfo = self.rankInfos[i]
    if rankInfo.charid == Game.Myself.data.id then
      myRank = rankInfo.rank
    end
  end
  self.rankIndex.gameObject:SetActive(self.myRank ~= 9999)
  self.noRank:SetActive(self.myRank == 9999)
  if self.myRank ~= 9999 then
    self.rankIndex.text = math.floor(self.myRank)
  end
  self.rewardCtl:ResetDatas(self.rewards)
  self.myHeadData:TransformByCreature(Game.Myself)
end
function PoringFightResultView:MapEvent()
  self:AddListenEvt(PlotStoryViewEvent.AddButton, self.HandleAddButton)
end
function PoringFightResultView:HandleAddButton(note)
  local buttonData = note.body
  if buttonData then
    self.confirmCall = buttonData.clickEvent
    self.confirmCallParam = buttonData.clickEventParam
    self.confirButtonData = buttonData
  end
end
function PoringFightResultView:OnEnter()
  PoringFightResultView.super.OnEnter(self)
  local viewdata = PvpProxy.Instance:GetPoringFight_viewdata()
  self.myRank = viewdata.myRank
  self.rankInfos = viewdata.rank
  self.rewards = viewdata.rewards
  self.rewardApple = viewdata.apple
  self:UpdateInfo()
end
function PoringFightResultView:OnExit()
  PoringFightResultView.super.OnExit(self)
  self.confirmCall = nil
  self.confirmCallParam = nil
  self.confirButtonData = nil
end
