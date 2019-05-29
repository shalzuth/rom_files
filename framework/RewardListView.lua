autoImport("RewardListViewCell")
RewardListView = class("RewardListView", BaseView)
RewardListView.ViewType = UIViewType.PopUpLayer
function RewardListView:Init()
  self:GetGameObjects()
  self:InitView()
  self:addViewEventListener()
end
function RewardListView:OnExit()
end
function RewardListView:InitView()
  self.uiGridOfItems = self.goItemsRoot:GetComponent(UIGrid)
  if self.listControllerOfItems == nil then
    self.listControllerOfItems = UIGridListCtrl.new(self.uiGridOfItems, RewardListViewCell, "RewardListViewCell")
  end
  local rewardList = self.viewdata.rewardList
  if rewardList and #rewardList > 0 then
    self.listControllerOfItems:ResetDatas(rewardList)
    self.itemsController = self.listControllerOfItems:GetCells()
  end
end
function RewardListView:GetGameObjects()
  self.goItemsRoot = self:FindGO("ItemsRoot", self.gameObject)
end
function RewardListView:addViewEventListener()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
end
function RewardListView:addListEventListener()
end
function RewardListView:setContent(status, content)
end
