autoImport("ShopItemData")
ShopData = class("ShopData")
local tempTable = {}
function ShopData:ctor(data)
  self.goods = {}
  self:SetData(data)
end
function ShopData:SetData(data)
  if data then
    self.type = data.shoptype
    self.shopID = data.shopid
    self.screen = data.screen
    self.tab = data.tab
    TableUtility.TableClear(tempTable)
    for i = 1, #data.goods do
      local goods = data.goods[i]
      self:AddShopItemData(goods)
      local id = goods.id
      tempTable[id] = id
    end
    for k, v in pairs(self.goods) do
      if tempTable[k] == nil then
        self.goods[k] = nil
      end
    end
  end
end
function ShopData:SetNextValidTime(time)
  self.callTime = Time.unscaledTime + time
end
function ShopData:AddShopItemData(data)
  local id = data.id
  if id ~= nil then
    if self.goods[id] == nil then
      self.goods[id] = ShopItemData.new(data)
    else
      self.goods[id]:SetData(data)
    end
  end
end
function ShopData:RemoveShopItemData(id)
  if id ~= nil then
    self.goods[id] = nil
  end
end
function ShopData:GetNextValidTime()
  return self.callTime
end
function ShopData:GetGoods()
  return self.goods
end
function ShopData:CheckScreen()
  return self.screen == 1
end
function ShopData:CheckTab()
  return self.tab
end
