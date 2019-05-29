GuildRewardPopUp = class("GuildRewardPopUp", SubView)
GuildRewardPopUp.ViewType = UIViewType.PopUpLayer
autoImport("GuildRewardCell")
function GuildRewardPopUp:Init()
  self:InitView()
  self:MapEvents()
end
function GuildRewardPopUp:InitView()
  self.score = self:FindComponent("Score", UILabel)
  local rewardGrid = self:FindComponent("Grid", UIGrid)
  self.rewardCtl = UIGridListCtrl.new(rewardGrid, GuildRewardCell, "GuildRewardCell")
  self.rewardCtl:AddEventListener(GuildRewardCellEvent.GetReward, self.GetReward, self)
end
function GuildRewardPopUp:GetReward(cell)
  local data = cell.data
  if data then
  end
end
function GuildRewardPopUp:UpdateRewardList()
  local list = {}
  self.rewardCtl:ResetDatas(list)
end
function GuildRewardPopUp:MapEvents()
end
function GuildRewardPopUp:OnEnter()
  GuildRewardPopUp.super.OnEnter(self)
end
