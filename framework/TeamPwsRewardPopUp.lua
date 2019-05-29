autoImport("TeamPwsRewardCell")
TeamPwsRewardPopUp = class("TeamPwsRewardPopUp", BaseView)
TeamPwsRewardPopUp.ViewType = UIViewType.PopUpLayer
function TeamPwsRewardPopUp:Init()
  self:FindObjs()
  self:InitList()
  self:AddButtonEvt()
  self:SetData()
end
function TeamPwsRewardPopUp:FindObjs()
  self.labMyName = self:FindComponent("labMyName", UILabel)
  self.labMyScore = self:FindComponent("labMyScore", UILabel)
  self.labMyRank = self:FindComponent("labMyRank", UILabel)
  self.sprMyLevel = self:FindComponent("sprMyLevel", UISprite)
end
function TeamPwsRewardPopUp:InitList()
  self.listRewards = UIGridListCtrl.new(self:FindComponent("rewardContainer", UIGrid), TeamPwsRewardCell, "TeamPwsRewardCell")
  self.listRewards:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
end
function TeamPwsRewardPopUp:AddButtonEvt()
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self:FindGO("Mask"), function()
    self:ClickEmpty()
  end)
  self:AddClickEvent(self:FindGO("FindNpcButton"), function()
    local useless, config = next(GameConfig.PvpTeamRaid)
    FuncShortCutFunc.Me():CallByID(config.RewardNpcShortCut)
  end)
end
function TeamPwsRewardPopUp:SetData()
  if Table_TeamPwsRewards then
    self.listRewards:ResetDatas(Table_TeamPwsRewards)
  end
end
function TeamPwsRewardPopUp:ClickItem(item)
  local tab = ReusableTable.CreateTable()
  tab.itemdata = item.data
  function tab.callback()
    self.itemTipShow = false
  end
  self:ShowItemTip(tab, item.icon, NGUIUtil.AnchorSide.Left, {-168, -28})
  ReusableTable.DestroyAndClearTable(tab)
  self.itemTipShow = true
end
function TeamPwsRewardPopUp:ClickEmpty()
  if self.itemTipShow then
    self:ShowItemTip()
    self.itemTipShow = false
  else
    self:CloseSelf()
  end
end
