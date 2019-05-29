local baseCell = autoImport("BaseCell")
NewShopMultiplePriceCell = class("NewShopMultiplePriceCell", baseCell)
function NewShopMultiplePriceCell:Init()
  self:FindObjs()
end
function NewShopMultiplePriceCell:FindObjs()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.price = self:FindGO("Price"):GetComponent(UILabel)
  self.priceIcon = self:FindGO("PriceIcon"):GetComponent(UISprite)
  self.totalPrice = self:FindGO("TotalPrice"):GetComponent(UILabel)
  self.totalPriceIcon = self:FindGO("TotalPriceIcon"):GetComponent(UISprite)
end
function NewShopMultiplePriceCell:SetData(data)
  self.data = data
  if data ~= nil then
    local staticData = Table_Item[data]
    if staticData ~= nil then
      self.title.text = staticData.NameZh
      local icon = staticData.Icon
      IconManager:SetItemIcon(icon, self.priceIcon)
      IconManager:SetItemIcon(icon, self.totalPriceIcon)
    end
  end
end
function NewShopMultiplePriceCell:SetPrice(price)
  if price ~= nil then
    self.price.text = StringUtil.NumThousandFormat(price)
  end
end
function NewShopMultiplePriceCell:SetTotalPrice(price)
  if price ~= nil then
    self.totalPrice.text = StringUtil.NumThousandFormat(price)
  end
end
