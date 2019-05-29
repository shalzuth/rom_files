autoImport("ItemData")
autoImport("ColliderItemCell")
TeamPwsRewardCell = class("TeamPwsRewardCell", BaseCell)
function TeamPwsRewardCell:Init()
  self:FindObjs()
end
function TeamPwsRewardCell:FindObjs()
  self.labName = self:FindComponent("labName", UILabel)
  self.labDesc = self:FindComponent("labDesc", UILabel)
  self.sprLevel = self:FindComponent("sprLevel", UISprite)
  self.objRewardsParent = self:FindGO("Rewards")
end
function TeamPwsRewardCell:SetData(data)
  self.gameObject:SetActive(data and true or false)
  if not data then
    return
  end
  self.labName.text = data.NameZh
  self.labDesc.text = data.Desc
  IconManager:SetUIIcon(data.Icon, self.sprLevel)
  if not data.Items then
    return
  end
  for i = 1, math.min(#data.Items, 2) do
    local itemObj = self:LoadPreferb("cell/ColliderItemCell", self.objRewardsParent)
    if #data.Items > 1 then
    else
    end
    itemObj.transform.localPosition = Vector3(46 * (i > 1 and 1 or -1), 0, 0) or Vector3.zero
    itemObj.name = tostring(i)
    local item = ColliderItemCell.new(itemObj)
    item:SetData(ItemData.new(nil, data.Items[i]))
    item:SetMinDepth(15)
    item:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  end
end
function TeamPwsRewardCell:ClickItem(item)
  self:PassEvent(MouseEvent.MouseClick, item)
end
