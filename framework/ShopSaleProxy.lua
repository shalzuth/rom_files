ShopSaleProxy = class("ShopSaleProxy", pm.Proxy)
ShopSaleProxy.Instance = nil
ShopSaleProxy.NAME = "ShopSaleProxy"
function ShopSaleProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ShopSaleProxy.NAME
  if ShopSaleProxy.Instance == nil then
    ShopSaleProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
ShopSaleProxy.Operation = {AddToWaitSaleLst = 1, RemoveFromWaitSaleLst = 2}
function ShopSaleProxy:Init()
  self.bagItemDatas = {}
  self.waitSaleItems = {}
  self.waitSaleItemsDic = {}
  self.bagData = BagData.new({
    {
      data = GameConfig.ItemPage[1],
      class = BagEquipTab
    },
    {
      data = GameConfig.ItemPage[2]
    },
    {
      data = GameConfig.ItemPage[3]
    },
    {
      data = GameConfig.ItemPage[4]
    }
  }, nil, BagProxy.BagType.MainBag)
  self.foodBagData = BagData.new({
    {
      data = GameConfig.FoodPackPage[1]
    },
    {
      data = GameConfig.FoodPackPage[2]
    }
  }, nil, BagProxy.BagType.Food)
  if GameConfig.PetPackPage ~= nil then
    self.petBagData = BagData.new({
      {
        data = GameConfig.PetPackPage[1]
      }
    }, nil, BagProxy.BagType.Pet)
  end
  self.tempBagData = BagData.new({
    {
      data = GameConfig.ItemPage[1],
      class = BagEquipTab
    },
    {
      data = GameConfig.ItemPage[2]
    },
    {
      data = GameConfig.ItemPage[3]
    },
    {
      data = GameConfig.ItemPage[4]
    }
  }, nil, BagProxy.BagType.Temp)
  self.questBagData = BagData.new({
    {
      data = GameConfig.ItemPage[5]
    }
  }, nil, BagProxy.BagType.Quest)
end
function ShopSaleProxy:SetParams(params)
  self.params = params
end
function ShopSaleProxy:InitBagData()
  self.bagData:Reset()
  local items = BagProxy.Instance.bagData:GetItems()
  for i = 1, #items do
    self.bagData:AddItem(items[i]:Clone())
  end
  local wholeTab = self.bagData:GetTab()
  wholeTab.dirty = false
  wholeTab.parsedItems = {
    unpack(wholeTab.items)
  }
  self.foodBagData:Reset()
  local foodItems = BagProxy.Instance.foodBagData:GetItems()
  for i = 1, #foodItems do
    self.foodBagData:AddItem(foodItems[i]:Clone())
  end
  local foodWholeTab = self.bagData:GetTab()
  foodWholeTab.dirty = false
  foodWholeTab.parsedItems = {
    unpack(foodWholeTab.items)
  }
  self.petBagData:Reset()
  local petItems = BagProxy.Instance.petBagData:GetItems()
  for i = 1, #petItems do
    self.petBagData:AddItem(petItems[i]:Clone())
  end
  local petWholeTab = self.bagData:GetTab()
  petWholeTab.dirty = false
  petWholeTab.parsedItems = {
    unpack(petWholeTab.items)
  }
  self.tempBagData:Reset()
  local tempItems = BagProxy.Instance.tempBagData:GetItems()
  for i = 1, #tempItems do
    self.tempBagData:AddItem(tempItems[i]:Clone())
  end
  local tempWholeTab = self.bagData:GetTab()
  tempWholeTab.dirty = false
  tempWholeTab.parsedItems = {
    unpack(tempWholeTab.items)
  }
  self.questBagData:Reset()
  local questItems = BagProxy.Instance.questBagData:GetItems()
  for i = 1, #questItems do
    self.questBagData:AddItem(questItems[i]:Clone())
  end
  local questWholeTab = self.bagData:GetTab()
  questWholeTab.dirty = false
  questWholeTab.parsedItems = {
    unpack(questWholeTab.items)
  }
end
function ShopSaleProxy:GetBagItemDatas(tabConfig)
  local bagData = self:GetBagData()
  if bagData then
    self.bagItemDatas = {}
    local datas = bagData:GetItems(tabConfig)
    if datas then
      for k, v in pairs(datas) do
        if v.num > 0 then
          table.insert(self.bagItemDatas, v)
        end
      end
    end
  end
  return self.bagItemDatas
end
function ShopSaleProxy:FilterBagItemDatas(operation, bagData)
  local datas = bagData:GetItems()
  if datas then
    for i = 1, #datas do
      if operation == ShopSaleProxy.Operation.AddToWaitSaleLst then
        if self.addToGuid == datas[i].id then
          datas[i].num = datas[i].num - self.addToNums
          if datas[i].num > 0 then
            table.insert(self.bagItemDatas, datas[i])
          else
            self:RemoveBagItemDatas(self.addToGuid)
          end
          self.addToGuid = 0
          self.addToNums = 0
          break
        end
      elseif self.removeGuid == datas[i].id then
        datas[i].num = datas[i].num + self.removeNums
        if datas[i].num > 0 then
          table.insert(self.bagItemDatas, datas[i])
        end
        self.removeGuid = 0
        self.removeNums = 0
        break
      end
    end
  end
end
function ShopSaleProxy:RemoveBagItemDatas(itemGuid)
  local index
  for i = 1, #self.bagItemDatas do
    if self.bagItemDatas[i].id == itemGuid then
      index = i
      break
    end
  end
  if index then
    table.remove(self.bagItemDatas, index)
  end
end
function ShopSaleProxy:IsThisItemCanSale(guid)
  local data = self:GetItemByGuid(guid)
  if data then
    if data.staticData.NoSale == 1 then
      return false
    end
    if data.staticData.Type == 65 then
      return false
    end
    if not data:IsCodeCanSell() then
      return false
    end
    if BagProxy.Instance:CheckIsFavorite(data, self:GetBagType()) then
      return false
    end
    if self.params then
      local equipInfo = data.equipInfo
      if self.params == 2 then
        if equipInfo then
          if equipInfo.refinelv > GameConfig.Item.sell_equip_max_refine_lv then
            return true
          else
            return false
          end
        else
          return false
        end
      elseif equipInfo and equipInfo.refinelv > GameConfig.Item.sell_equip_max_refine_lv then
        return false
      end
    end
  end
  return true
end
function ShopSaleProxy:IsCanSaleItemNums(guid, saleNums)
  local totalNums = self:CanSaleNums(guid) - saleNums
  if totalNums >= 0 then
    return true
  else
    return false
  end
end
function ShopSaleProxy:CanSaleNums(guid)
  local data = self:GetItemByGuid(guid)
  if data then
    local nums = data.num
    return nums
  end
end
function ShopSaleProxy:GetTotalPrice()
  local price = 0
  local purePrice = 0
  local data, item
  for i = 1, #self.waitSaleItems do
    item = self.waitSaleItems[i]
    data = self:GetItemByGuid(item.guid)
    if data then
      purePrice = purePrice + self:GetPurePrice(data) * item.nums
    end
    price = price + item.price
  end
  return price, purePrice
end
function ShopSaleProxy:IsHaveHighQualityItem()
  for i = 1, #self.waitSaleItems do
    local data = self:GetItemByGuid(self.waitSaleItems[i].guid)
    if data and data.staticData.Quality >= 4 then
      return true
    end
  end
  return false
end
function ShopSaleProxy:IsHaveSpecialEquip()
  for i = 1, #self.waitSaleItems do
    local data = self:GetItemByGuid(self.waitSaleItems[i].guid)
    if ShopMallProxy.Instance:JudgeSpecialEquip(data) then
      return true
    end
  end
  return false
end
function ShopSaleProxy:IsSaleConfirmMsg()
  for i = 1, #self.waitSaleItems do
    local data = self:GetItemByGuid(self.waitSaleItems[i].guid)
    if data then
      local feature = data.staticData.Feature
      if feature and feature & 1 > 0 then
        return true
      end
    end
  end
  return false
end
function ShopSaleProxy:AddToWaitSaleItems(guid, nums, price)
  local data = {}
  if guid and nums and price then
    data.guid = guid
    data.nums = nums
    data.price = price
    TableUtility.ArrayPushFront(self.waitSaleItems, data)
    self:AddToWaitSaleItemsDic(guid, nums)
  end
  self.addToGuid = guid
  self.addToNums = nums
  self:FilterBagItemDatas(ShopSaleProxy.Operation.AddToWaitSaleLst, self.bagData)
  self:FilterBagItemDatas(ShopSaleProxy.Operation.AddToWaitSaleLst, self.foodBagData)
  self:FilterBagItemDatas(ShopSaleProxy.Operation.AddToWaitSaleLst, self.petBagData)
  self:FilterBagItemDatas(ShopSaleProxy.Operation.AddToWaitSaleLst, self.tempBagData)
  self:FilterBagItemDatas(ShopSaleProxy.Operation.AddToWaitSaleLst, self.questBagData)
end
function ShopSaleProxy:RemoveOutWaitSaleItems(guid, nums)
  if guid and nums then
    for i = 1, #self.waitSaleItems do
      if self.waitSaleItems[i].guid == guid and self.waitSaleItems[i].nums == nums then
        table.remove(self.waitSaleItems, i)
        self:RemoveOutWaitSaleItemsDic(guid, nums)
        break
      end
    end
  end
  self.removeGuid = guid
  self.removeNums = nums
  self:FilterBagItemDatas(ShopSaleProxy.Operation.RemoveFromWaitSaleLst, self.bagData)
  self:FilterBagItemDatas(ShopSaleProxy.Operation.RemoveFromWaitSaleLst, self.foodBagData)
  self:FilterBagItemDatas(ShopSaleProxy.Operation.RemoveFromWaitSaleLst, self.petBagData)
  self:FilterBagItemDatas(ShopSaleProxy.Operation.RemoveFromWaitSaleLst, self.tempBagData)
  self:FilterBagItemDatas(ShopSaleProxy.Operation.RemoveFromWaitSaleLst, self.questBagData)
end
function ShopSaleProxy:AddToWaitSaleItemsDic(guid, nums)
  if guid and nums then
    local temp = self.waitSaleItemsDic[guid]
    if temp then
      self.waitSaleItemsDic[guid] = temp + nums
    else
      self.waitSaleItemsDic[guid] = nums
    end
  end
end
function ShopSaleProxy:RemoveOutWaitSaleItemsDic(guid, nums)
  if guid and nums and self.waitSaleItemsDic[guid] then
    local num = self.waitSaleItemsDic[guid] - nums
    if num < 0 then
      num = 0
    end
    if num == 0 then
      self.waitSaleItemsDic[guid] = nil
    else
      self.waitSaleItemsDic[guid] = num
    end
  end
end
function ShopSaleProxy:GetPrice(data)
  local price = 0
  if data then
    price = self:GetPurePrice(data)
    local equipInfo = data.equipInfo
    if equipInfo and 0 < equipInfo.refinelv then
      local staticType = data.staticData.Type
      local quality = data.staticData.Quality
      local refineData = BlackSmithProxy.Instance:GetRefineData(staticType, quality, equipInfo.refinelv)
      if refineData then
        local refineZenyReturn = refineData.RefineZenyReturn
        if refineZenyReturn then
          for i = 1, #refineZenyReturn do
            local returnData = refineZenyReturn[i]
            if returnData.color == quality then
              price = price + returnData.num * equipInfo.refinelv
            end
          end
        end
      end
    end
  end
  return price
end
function ShopSaleProxy:GetPurePrice(data)
  if data then
    return data.staticData.SellPrice or 0
  end
  return 0
end
function ShopSaleProxy:SetBagType(bagType)
  self.bagType = bagType
end
function ShopSaleProxy:GetBagType()
  if self.bagType == nil then
    self.bagType = BagProxy.BagType.MainBag
  end
  return self.bagType
end
function ShopSaleProxy:GetBagData()
  local bagType = self:GetBagType()
  if bagType then
    if bagType == BagProxy.BagType.MainBag then
      return self.bagData
    elseif bagType == BagProxy.BagType.Food then
      return self.foodBagData
    elseif bagType == BagProxy.BagType.Pet then
      return self.petBagData
    elseif bagType == BagProxy.BagType.Temp then
      return self.tempBagData
    elseif bagType == BagProxy.BagType.Quest then
      return self.questBagData
    end
  end
  return nil
end
function ShopSaleProxy:GetItemByGuid(guid)
  local data = self.bagData:GetItemByGuid(guid)
  if data == nil then
    data = self.foodBagData:GetItemByGuid(guid)
  end
  if data == nil then
    data = self.petBagData:GetItemByGuid(guid)
  end
  if data == nil then
    data = self.tempBagData:GetItemByGuid(guid)
  end
  if data == nil then
    data = self.questBagData:GetItemByGuid(guid)
  end
  return data
end
function ShopSaleProxy:GetTotalSellDiscount(totalCost)
  local sellDiscount = Game.Myself.data.props.SellDiscount:GetValue() / 1000
  local discount = math.floor(totalCost * sellDiscount)
  return sellDiscount, discount, totalCost + discount
end
