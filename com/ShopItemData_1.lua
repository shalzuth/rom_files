ShopItemData = class("ShopItemData")
ShopItemData.LockType = {
  Quest = SessionShop_pb.ESHOPLOCKTYPE_QUEST,
  GuildBuilding = SessionShop_pb.ESHOPLOCKTYPE_GUILDBUILDING
}
ShopItemData.PresentType = {
  Normal = SessionShop_pb.EPRESENTTYPE_NORMAL,
  Lock = SessionShop_pb.EPRESENTTYPE_LOCK
}
function ShopItemData:ctor(data)
  self:SetData(data)
end
function ShopItemData:SetData(data)
  self.id = data.id
  self.ShopOrder = data.shoporder
  if data.itemid ~= 0 then
    self.goodsID = data.itemid
  end
  if data.num ~= 0 then
    self.goodsCount = data.num
  end
  if data.skillid ~= 0 then
    self.SkillID = data.skillid
  end
  if data.haircolorid ~= 0 then
    self.hairColorID = data.haircolorid
  end
  if data.clothcolorid ~= 0 then
    self.clothColorID = data.clothcolorid
  end
  self.PreCost = data.precost
  self.ItemID = data.moneyid
  self.ItemCount = data.moneycount
  if data.moneyid2 ~= 0 then
    self.ItemID2 = data.moneyid2
    self.ItemCount2 = data.moneycount2
  end
  self.business = data.business
  self.des = data.des
  self.LevelDes = data.levdes
  self.BaseLv = data.lv
  self.Discount = data.discount
  self.discountMax = data.discountmax
  self.actDiscount = data.actdiscount
  self.LimitType = data.limittype
  self.LimitNum = data.maxcount
  if data.ifmsg ~= 0 then
    self.IfMsg = data.ifmsg
  end
  if data.removedate ~= 0 then
    self.RemoveDate = data.removedate
  end
  self.lockType = data.locktype
  self.lockArg = data.lockarg
  self.produceNum = data.producenum
  self.MenuID = data.menuid
  self.source = data.source
  self.itemtype = data.itemtype
  local presentation = data.presentation
  if presentation.presenttype == ShopItemData.PresentType.Normal then
    self.presentType = nil
    self.presentMsgid = nil
    self.presentMenuids = nil
  else
    self.presentType = presentation.presenttype
    if presentation.msgid ~= 0 then
      self.presentMsgid = presentation.msgid
    end
    if 0 < #presentation.menuid then
      local presentMenuids = self.presentMenuids
      if presentMenuids == nil then
        presentMenuids = {}
        self.presentMenuids = presentMenuids
      else
        TableUtility.ArrayClear(presentMenuids)
      end
      for i = 1, #presentation.menuid do
        presentMenuids[#presentMenuids + 1] = presentation.menuid[i]
      end
    end
  end
  self:_SetMenu(data.shoptype)
  self.tabid = data.tabid
  self.isGoodData = true
end
function ShopItemData:_SetMenu(shoptype)
  self.menuLockDesc = nil
  self.lockReasonDesc = nil
  if self.lockType == ShopItemData.LockType.GuildBuilding then
    self.lock = GuildBuildingProxy.Instance:ShopGoodsLocked(shoptype, self.id)
    if self.lock then
      self.lockReasonDesc = self.lockArg
    end
  elseif self.MenuID ~= 0 and not FunctionUnLockFunc.Me():CheckCanOpen(self.MenuID) then
    self.lock = true
    local data = Table_MenuUnclock[self.goodsID]
    if data ~= nil and 0 < #data.MenuDes then
      self.menuLockDesc = data.MenuDes
    end
    if self.lockType == ShopItemData.LockType.Quest then
      self.lockReasonDesc = string.format(ZhString.HappyShop_Lock, self.lockArg)
    elseif self.lockArg ~= "" then
      self.menuLockDesc = self.lockArg
    end
  else
    self.lock = false
  end
end
function ShopItemData:SetCurProduceNum(num)
  if num and self.produceNum and self.produceNum > 0 then
    local curNum = self.produceNum - num
    if curNum < 0 then
      curNum = 0
    end
    self.curProduceNum = curNum
  end
end
function ShopItemData:CheckCanRemove()
  if self.RemoveDate and ServerTime.CurServerTime() / 1000 >= self.RemoveDate then
    return true
  end
  return false
end
function ShopItemData:CheckLimitType(index)
  if self.LimitType then
    return self.LimitType & index > 0
  end
  return false
end
function ShopItemData:GetItemData()
  if self.goodsID and self.itemData == nil then
    self.itemData = ItemData.new("shop", self.goodsID)
  end
  return self.itemData
end
function ShopItemData:GetLock()
  return self.lock
end
function ShopItemData:GetMenuDes()
  local desc = self:GetLockDesc()
  if desc == nil then
    return self.lockReasonDesc
  end
  return desc
end
function ShopItemData:GetQuestLockDes()
  if self.lockType == ShopItemData.LockType.Quest then
    return self.lockReasonDesc
  end
  return nil
end
function ShopItemData:GetLockDesc()
  return self.menuLockDesc
end
function ShopItemData:GetLockType()
  return self.lockType
end
function ShopItemData:GetBuyDiscountPrice(price, count)
  local discount = self.Discount
  local actDiscount = self.actDiscount
  local leftCount = 0
  local discountPrice = 0
  if actDiscount ~= 0 then
    local canBuyCount = self.discountMax - HappyShopProxy.Instance:GetDiscountItemCount(self.id)
    if canBuyCount < 0 then
      canBuyCount = 0
    end
    leftCount = count - canBuyCount
    if leftCount > 0 then
      discountPrice = self:_GetPrice(price, actDiscount, canBuyCount)
    else
      return self:_GetPrice(price, actDiscount, count), actDiscount
    end
  end
  if leftCount > 0 then
    return discountPrice + self:_GetPrice(price, discount, leftCount), discount
  else
    return self:_GetPrice(price, discount, count), discount
  end
end
function ShopItemData:_GetPrice(price, discount, count)
  return math.floor(price * discount / 100) * count
end
function ShopItemData:GetTotalBuyDiscount(totalCost)
  if self.business == 1 then
    local buyDiscount = Game.Myself.data.props.BuyDiscount:GetValue() / 1000
    local discount = math.floor(totalCost * buyDiscount)
    return buyDiscount, discount, totalCost - discount
  else
    return 0, 0, totalCost
  end
end
function ShopItemData:GetBuyFinalPrice(price, count)
  local totalPrice = self:GetBuyDiscountPrice(price, count)
  local discount, discountCount
  discount, discountCount, totalPrice = self:GetTotalBuyDiscount(totalPrice)
  return totalPrice
end
function ShopItemData:SetSoldCount(server_soldCount)
  self.soldCount = server_soldCount
end
function ShopItemData:CheckPresentMenu()
  if self.presentMenuids ~= nil then
    local _FunctionUnLockFunc = FunctionUnLockFunc.Me()
    for i = 1, #self.presentMenuids do
      if _FunctionUnLockFunc:CheckCanOpen(self.presentMenuids[i]) then
        return true
      end
    end
  end
  return false
end
