AuctionSignUpData = class("AuctionSignUpData")
function AuctionSignUpData:ctor(data)
  self:SetData(data)
end
function AuctionSignUpData:SetData(data)
  if data then
    self.itemid = data.itemid
    self.price = data.price
    self.state = AuctionSignUpState.SignUp
    self.needEnchant = data.auction
  end
end
function AuctionSignUpData:SetCloseState()
  if self.state ~= AuctionSignUpState.Signed then
    self.state = AuctionSignUpState.Close
  end
end
function AuctionSignUpData:SetState(state)
  self.state = state
end
function AuctionSignUpData:GetItemData()
  if self.itemData == nil then
    self.itemData = ItemData.new("Auction", self.itemid)
  end
  return self.itemData
end
function AuctionSignUpData:GetSignUpItemList()
  if self.signUpItemList == nil then
    self.signUpItemList = {}
    local items = BagProxy.Instance:GetMainBag():GetItems()
    local ArrayPushBack = TableUtility.ArrayPushBack
    for i = 1, #items do
      local item = items[i]
      if item.staticData.id == self.itemid and self:_CheckItemSignUp(item) then
        ArrayPushBack(self.signUpItemList, item.id)
      end
    end
  end
  return self.signUpItemList
end
function AuctionSignUpData:_CheckItemSignUp(itemData)
  local enchantInfo = itemData.enchantInfo
  if enchantInfo ~= nil then
    local attrs = enchantInfo:GetEnchantAttrs()
    local attrsCount = #attrs
    local valuableCount = 0
    for i = 1, attrsCount do
      if attrs[i].Quality == EnchantAttriQuality.Good then
        valuableCount = valuableCount + 1
      end
    end
    local _ConfigAuction = GameConfig.Auction
    return attrsCount >= _ConfigAuction.EnchantAttrCount and (valuableCount >= _ConfigAuction.EnchantAttrValuableCount or #enchantInfo:GetCombineEffects() >= _ConfigAuction.EnchantBuffExtraCount)
  end
  return false
end
function AuctionSignUpData:CanSignUp()
  if self:IsNeedEnchant() then
    local list = self:GetSignUpItemList()
    if #list == 0 then
      return false
    end
  end
  return 0 < AuctionProxy.Instance:GetItemNumByStaticIDExceptNonMaterialFavorite(self.itemid)
end
function AuctionSignUpData:IsNeedEnchant()
  return self.needEnchant == 2
end
function AuctionSignUpData:IsSigned()
  return self.state == AuctionSignUpState.Signed
end
