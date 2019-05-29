autoImport("ShopItemCell")
ExpRaidShopItemCell = class("ExpRaidShopItemCell", ShopItemCell)
function ExpRaidShopItemCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if data then
    ExpRaidShopItemCell.super.super.SetData(self, data)
    self:SetChildrenActive()
    local itemRemainingCount = ExpRaidProxy.Instance:GetRemainingCountOfShopItem(data.staticData.id)
    self.soldout:SetActive(itemRemainingCount <= 0)
    local costPointSprite = self.costMoneySprite[1]
    IconManager:SetUIIcon("exp_integral", costPointSprite)
    local costPointLocalPos = costPointSprite.gameObject.transform.localPosition
    costPointLocalPos.y = 0
    costPointSprite.gameObject.transform.localPosition = costPointLocalPos
    self.itemName.text = data.staticData.NameZh
    self.buyCondition.text = data.staticData.Desc
    self.costMoneyNums[1].text = ExpRaidProxy.Instance:GetPriceOfItem(data.staticData.id)
  end
  self.data = data
end
function ExpRaidShopItemCell:SetChildrenActive()
  self.costMoneySprite[1].gameObject:SetActive(true)
  self.costMoneySprite[2].gameObject:SetActive(false)
  self.choose:SetActive(false)
  self.lock:SetActive(false)
  self.primeCost.gameObject:SetActive(false)
  self.sellDiscount.gameObject:SetActive(false)
  self.exchangeButton:SetActive(false)
  self.fashionUnlock:SetActive(false)
end
