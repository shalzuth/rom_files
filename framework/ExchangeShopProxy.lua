autoImport("ExchangeShopItemData")
autoImport("ExchangeItemData")
ExchangeShopProxy = class("ExchangeShopProxy", pm.Proxy)
ExchangeShopProxy.Instance = nil
ExchangeShopProxy.NAME = "ExchangeShopProxy"
ExchangeShopProxy.GoodsTYPE = {
  OK = SessionShop_pb.EEXCHANGESTATUSTYPE_OK,
  EMPTY = SessionShop_pb.EEXCHANGESTATUSTYPE_EMPTY
}
local SortType, exchangeType = 3, 4
ExchangeShopProxy.EnchangeType = {
  COINS = 1,
  FRESS = 2,
  PROGRESS = 3,
  NO_PROGRESS = 4,
  Limited_PROGRESS = 5,
  MEDAL_PROGRESS = 6
}
function ExchangeShopProxy:Test()
  local data = {
    items = {
      {
        id = 6,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 1,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 7,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 8,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 9,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 10,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 2,
        status = 2,
        progress = 0,
        exchange_count = 0,
        left_time = 31214
      },
      {
        id = 3,
        status = 2,
        progress = 1,
        exchange_count = 20,
        left_time = 4352332
      },
      {
        id = 4,
        status = 2,
        progress = 1,
        exchange_count = 10,
        left_time = 232
      },
      {
        id = 5,
        status = 2,
        progress = 0,
        exchange_count = 0,
        left_time = 32145
      }
    },
    del_items = {},
    menu_open = true
  }
  self:UpdateExchange(data)
end
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ClearArray = TableUtility.ArrayClear
function ExchangeShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ExchangeShopProxy.NAME
  if ExchangeShopProxy.Instance == nil then
    ExchangeShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function ExchangeShopProxy:InitStaticData()
  if self.init then
    return
  end
  if not Table_ExchangeWorth then
    return
  end
  local checkCfgMap = {}
  for k, v in pairs(Table_ExchangeWorth) do
    if ItemUtil.CheckDateValidByItemId(v.ItemID) then
      if v.ItemID and v.Worth and #v.Worth > 1 then
        self.goodsWorth[v.ItemID] = v
      end
      if not v.GoodsID then
        return
      end
      for i = 1, #v.GoodsID do
        local goodID = v.GoodsID[i]
        if nil == self.goodsMap[goodID] then
          self.goodsMap[goodID] = {}
        end
        local itemData = ExchangeItemData.new(v)
        _ArrayPushBack(self.goodsMap[goodID], itemData)
        for i = 1, #self.goodsMap[goodID] do
          local goods = self.goodsMap[goodID][i]
          if nil == checkCfgMap[goodID] then
            checkCfgMap[goodID] = goods.config.Worth[1]
          end
          if checkCfgMap[goodID] ~= goods.config.Worth[1] then
            redlog("Table_ExchangeWorth ID\239\188\154", goodID, "\233\133\141\231\189\174\228\186\134\228\184\141\229\144\140\231\154\132\229\165\150\229\138\177", goods.config.Worth[1])
            return
          end
        end
      end
    end
  end
  self.init = true
end
function ExchangeShopProxy:Init()
  self.shopDataMap = {}
  self.dataArray = {}
  self.chooseMap = {}
  self.goodsMap = {}
  self.goodsWorth = {}
end
function ExchangeShopProxy:UpdateExchange(server_data)
  self.shopDataChanged = true
  for i = 1, #server_data.items do
    self.shopDataMap[server_data.items[i].id] = ExchangeShopItemData.new(server_data.items[i])
  end
  for i = 1, #server_data.del_items do
    self.shopDataMap[server_data.del_items[i]] = nil
  end
end
function ExchangeShopProxy:CanOpen()
  for k, v in pairs(self.shopDataMap) do
    if v.staticData and v.staticData.Source == 1 and v.status ~= ExchangeShopProxy.GoodsTYPE.EMPTY then
      return true
    end
  end
  return false
end
function ExchangeShopProxy:HandleResetData(server_data)
  self.shopDataChanged = true
  self:ClearData()
  for i = 1, #server_data.items do
    self.shopDataMap[server_data.items[i].id] = ExchangeShopItemData.new(server_data.items[i])
  end
end
function ExchangeShopProxy:ClearData()
  TableUtility.TableClear(self.shopDataMap)
  self.shopDataChanged = true
  self:ResetChoose()
end
function ExchangeShopProxy:GetRewardByGoods(id)
  local array = self.goodsMap[id]
  if not array or 0 == #array or not array[1].config then
    return nil
  end
  return array[1].config.Worth[1]
end
function ExchangeShopProxy:ResetChoose()
  TableUtility.TableClear(self.chooseMap)
end
function ExchangeShopProxy:AddChooseItems(id)
  if self.chooseMap[id] then
    if self.chooseMap[id] < BagProxy.Instance:GetItemNumByStaticID(id) then
      self.chooseMap[id] = self.chooseMap[id] + 1
    end
  else
    self.chooseMap[id] = 1
  end
end
function ExchangeShopProxy:MinusChooseItem(id)
  if not self.chooseMap[id] then
    return
  end
  if self.chooseMap[id] > 1 then
    self.chooseMap[id] = self.chooseMap[id] - 1
  else
    self.chooseMap[id] = nil
  end
end
function ExchangeShopProxy:_getChooseItem()
  local chooseItem = {}
  for k, v in pairs(self.chooseMap) do
    local item = SessionShop_pb.ExchangeItemInfo()
    item.id = k
    item.num = v
    _ArrayPushBack(chooseItem, item)
  end
  return #chooseItem > 0 and chooseItem or nil
end
function ExchangeShopProxy:GetExchangeShopData()
  if #self.dataArray <= 0 or self.shopDataChanged then
    _ClearArray(self.dataArray)
    for _, v in pairs(self.shopDataMap) do
      if v:IsExchangeShop() then
        _ArrayPushBack(self.dataArray, v)
      end
    end
    table.sort(self.dataArray, function(l, r)
      return self:SortFunc(l, r)
    end)
    self.shopDataChanged = false
  end
  return self.dataArray
end
function ExchangeShopProxy:SortFunc(a, b)
  if a == nil or b == nil then
    return false
  end
  local aGift = a.isGift
  local bGift = b.isGift
  local aGoodID = a.goodsId
  local bGoodID = b.goodsId
  local aSpecialType = a.staticData.Type == SortType
  local bSpecialType = b.staticData.Type == SortType
  if a.status ~= b.status then
    return a.status < b.status
  else
    if aGift and bGift then
      return aGoodID < bGoodID
    end
    if aGift or bGift then
      return aGift == true
    end
    if a.staticData.Type == exchangeType and b.staticData.Type == exchangeType then
      return aGoodID < bGoodID
    end
    if a.staticData.Type == exchangeType or b.staticData.Type == exchangeType then
      return a.staticData.Type == exchangeType
    end
    if aSpecialType and bSpecialType then
      return aGoodID > bGoodID
    end
    if aSpecialType or bSpecialType then
      return aSpecialType
    end
    if aSpecialType == false and bSpecialType == false then
      return aGoodID < bGoodID
    end
  end
end
function ExchangeShopProxy:CalcPreviewWorth()
  local previewNum = 0
  local chooseItem = self:_getChooseItem()
  if chooseItem and #chooseItem > 0 then
    for i = 1, #chooseItem do
      local worth_cfg = self.goodsWorth[chooseItem[i].id].Worth
      local worthNum = worth_cfg and worth_cfg[2] or 1
      previewNum = chooseItem[i].num * worthNum + previewNum
    end
  end
  return previewNum
end
function ExchangeShopProxy:GetChooseNum()
  local chooseCount, rewardCount, extraCount = 0, 0, 0
  for k, v in pairs(self.chooseMap) do
    chooseCount = chooseCount + v
    if self.goodsWorth[k] then
      if self.goodsWorth[k].Worth then
        rewardCount = rewardCount + self.goodsWorth[k].Worth[2] * v
      end
      if type(self.goodsWorth[k].Extra) == "table" and #self.goodsWorth[k].Extra > 1 then
        extraCount = extraCount + self.goodsWorth[k].Extra[2] * v
      end
    end
  end
  return chooseCount, rewardCount, extraCount
end
function ExchangeShopProxy:CallExchange(id)
  local eType = Table_ExchangeShop[id] and Table_ExchangeShop[id].ExchangeType
  if not eType or eType == 1 or not self:_getChooseItem() then
    local chooseItem
  end
  ServiceSessionShopProxy.Instance:CallExchangeShopItemCmd(id, chooseItem)
end
function ExchangeShopProxy:GetShopDataByExchangeId(id)
  return self.shopDataMap[id]
end
