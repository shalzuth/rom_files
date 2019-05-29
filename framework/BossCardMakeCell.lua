BossCardMakeCell = class("BossCardMakeCell", ItemCell)
function BossCardMakeCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = Vector3.zero
  BossCardMakeCell.super.Init(self)
  self:FindObjs()
  self:AddClickEvent(self.itemContainer, function()
    self:PassEvent(CardMakeEvent.Select_BossCard, self)
  end)
end
function BossCardMakeCell:FindObjs()
  self.rate = self:FindGO("weight"):GetComponent(UILabel)
end
local totalweight = GameConfig.Card.TotalWeight
function BossCardMakeCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if data and totalweight and totalweight ~= 0 then
    BossCardMakeCell.super.SetData(self, data)
    self.rate.text = string.format(ZhString.BossCard_Rate, data.cardInfo.WeightShow / totalweight * 100)
  end
  self.data = data
end
