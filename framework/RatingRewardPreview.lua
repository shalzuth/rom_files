RatingRewardPreview = class("RatingRewardPreview", BaseView)
RatingRewardPreview.ViewType = UIViewType.PopUpLayer
function RatingRewardPreview:Init()
  self:FindObjs()
  self:InitShow()
  self:AddEvents()
  self:AddCloseButtonEvent()
end
function RatingRewardPreview:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.tipStick = self:FindComponent("TipStick", UISprite)
  self.grid = self:FindComponent("Grid", UIGrid)
end
local ratinglist = GameConfig.EVA.time_rank_desc
function RatingRewardPreview:InitShow()
  local viewdata = self.viewdata.viewdata
  if viewdata and ratinglist[viewdata] then
    local config = ratinglist[viewdata]
    self.rewardCtl = UIGridListCtrl.new(self.grid, BagItemCell, "BagItemCell")
    local itemList = ItemUtil.GetRewardItemIdsByTeamId(config.reward)
    local itemDataList = {}
    if itemList and #itemList > 0 then
      for i = 1, #itemList do
        local itemInfo = itemList[i]
        local tempItem = ItemData.new("", itemInfo.id)
        tempItem.num = itemInfo.num
        itemDataList[#itemDataList + 1] = tempItem
      end
      self.rewardCtl:ResetDatas(itemDataList)
    end
    self.titleLabel.text = config.title
  end
end
function RatingRewardPreview:AddEvents()
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end
function RatingRewardPreview:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    local tipData = {}
    tipData.funcConfig = {}
    tipData.itemdata = cellCtl.data
    self:ShowItemTip(tipData, self.tipStick, NGUIUtil.AnchorSide.Up)
  end
end
function RatingRewardPreview:OnEnter()
  RatingRewardPreview.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
end
function RatingRewardPreview:OnExit()
  RatingRewardPreview.super.OnExit(self)
end
