autoImport("BoothData")
autoImport("ShopMallItemData")
autoImport("ExchangeLogData")
BoothProxy = class("BoothProxy", pm.Proxy)
BoothProxy.Instance = nil
BoothProxy.NAME = "BoothProxy"
BoothProxy.OperEnum = {
  Open = SceneUser2_pb.EBOOTHOPER_OPEN,
  Close = SceneUser2_pb.EBOOTHOPER_CLOSE,
  Update = SceneUser2_pb.EBOOTHOPER_UPDATE
}
BoothProxy.TradeType = {
  All = SceneItem_pb.ETRADETYPE_ALL,
  Exchange = SceneItem_pb.ETRADETYPE_TRADE,
  Booth = SceneItem_pb.ETRADETYPE_BOOTH
}
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear
function BoothProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BoothProxy.NAME
  if BoothProxy.Instance == nil then
    BoothProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function BoothProxy:Init()
  self.bagSell = {}
  self.itemPool = LuaLRUKeyTable.new(5, 50)
  self.boothSellRecordList = {}
  self.boothRecieveRecord = {}
  self.tableTakeLog = {}
end
function BoothProxy:RecvBoothReqUserCmd(serverData)
  if serverData.success == true then
    local oper = serverData.oper
    local myself = Game.Myself
    if oper == self.OperEnum.Open then
      FunctionSystem.InterruptMyselfAI()
      myself:Client_NoMove(true)
      self:SetSimulateMode()
    elseif oper == self.OperEnum.Close then
      myself:Client_NoMove(false)
      myself:DestroyBooth()
    end
  end
end
function BoothProxy:RecvBoothInfoSyncUserCmd(serverData)
  local oper = serverData.oper
  local player = NSceneUserProxy.Instance:Find(serverData.charid)
  if player ~= nil then
    if oper == self.OperEnum.Open or oper == self.OperEnum.Update then
      player:UpdateBooth(serverData.info)
      if oper == self.OperEnum.Open then
        EventManager.Me():DispatchEvent(BoothEvent.OpenBooth, player)
      end
    elseif oper == self.OperEnum.Close then
      player:DestroyBooth()
      EventManager.Me():DispatchEvent(BoothEvent.CloseBooth, player)
    end
  end
end
function BoothProxy:RecvBoothPlayerPendingListCmd(serverData)
  local charid = serverData.charid
  local element = self.itemPool:TryGetValueNoRemove(charid)
  if element == nil then
    element = {}
    self.itemPool:Add(charid, element)
  else
    _ArrayClear(element)
  end
  for i = 1, #serverData.lists do
    local itemData = ShopMallItemData.new(serverData.lists[i])
    _ArrayPushBack(element, itemData)
  end
end
function BoothProxy:RecvUpdateOrderTradeCmd(serverData)
  local charid = serverData.charid
  local element = self.itemPool:TryGetValueNoRemove(charid)
  if element ~= nil then
    local info = serverData.info
    local orderId = info.order_id
    local item
    for i = 1, #element do
      item = element[i]
      if item.orderId == orderId then
        item:SetData(info)
        break
      end
    end
    if item == nil then
      local itemData = ShopMallItemData.new(info)
      _ArrayPushBack(element, itemData)
    end
  end
end
function BoothProxy:ClearMyselfBooth()
  local _ServiceNUserProxy = ServiceNUserProxy.Instance
  local _OperClose = self.OperEnum.Close
  local data = ReusableTable.CreateTable()
  data.oper = _OperClose
  data.success = true
  _ServiceNUserProxy:RecvBoothReqUserCmd(data)
  ReusableTable.DestroyTable(data)
end
function BoothProxy:GetScoreLevel(score)
  local _ScoreConfig = GameConfig.Booth.score
  local index = 0
  for i = 0, #_ScoreConfig do
    if score >= _ScoreConfig[i].num then
      index = i
    else
      break
    end
  end
  return index
end
function BoothProxy:GetQuota(price, publicityId)
  if publicityId == nil then
    return 0
  end
  local _BoothConfig = GameConfig.Booth
  local quota
  if publicityId == 0 then
    quota = price / _BoothConfig.quota_exchange_rate
  else
    quota = price / _BoothConfig.quota_exchange_rate_pub
  end
  if quota > _BoothConfig.quota_cost_max then
    quota = _BoothConfig.quota_cost_max
  end
  return math.floor(quota)
end
function BoothProxy:GetValidQuota(quota)
  local lockQuota = MyselfProxy.Instance:GetQuotaLock()
  if quota > lockQuota then
    return lockQuota, true
  end
  return quota, false
end
function BoothProxy:GetDiscountMoney(money)
  return money - math.floor(money * 1 / GameConfig.Booth.quota_zeny_discount)
end
function BoothProxy:GetExchangeBagSell()
  TableUtility.ArrayClear(self.bagSell)
  self:GetExchangeBagSellByBagType(BagProxy.BagType.MainBag)
  self:GetExchangeBagSellByBagType(BagProxy.BagType.Barrow)
  self:GetExchangeBagSellByBagType(BagProxy.BagType.PersonalStorage)
  return self.bagSell
end
function BoothProxy:GetExchangeBagSellByBagType(bagType)
  bagType = bagType or BagProxy.BagType.MainBag
  local bagData = BagProxy.Instance.bagMap[bagType]
  if bagData then
    local items = bagData:GetItems()
    for i = 1, #items do
      local itemData = items[i]
      if self:CanItemBooth(itemData) then
        table.insert(self.bagSell, itemData)
      end
    end
  end
end
function BoothProxy:CanItemBooth(itemdata)
  if itemdata == nil then
    return false
  end
  if itemdata.enchantInfo and itemdata.enchantInfo:HasAttri() then
    return false
  end
  return itemdata:CanTrade()
end
function BoothProxy:CanMapBooth()
  local menuid = GameConfig.SystemOpen_MenuId and GameConfig.SystemOpen_MenuId.BoothShopping or 9
  local unlock = FunctionUnLockFunc.Me():CheckCanOpen(menuid)
  if not unlock then
    return false
  end
  local map = Game.MapManager:GetMapID()
  local allowMaps = GameConfig.Booth.map_ids
  for k, v in pairs(allowMaps) do
    if map == v then
      return true
    end
  end
  return false
end
function BoothProxy:GetItemList(charid)
  return self.itemPool:TryGetValueNoRemove(charid) or {}
end
function BoothProxy:FilterItemList(charid)
  local list = self:GetItemList(charid)
  for i = #list, 1, -1 do
    if list[i].count == 0 then
      table.remove(list, i)
    end
  end
end
function BoothProxy:IsMaintenance()
  return GameConfig.Booth.booth_maintenance == 1
end
function BoothProxy:SetSimulateMode(isSimulate, name)
  self.isSimulate = isSimulate
  self.simulateName = name
end
function BoothProxy:IsSimulateMode()
  return self.isSimulate
end
function BoothProxy:GetName(playerID)
  if playerID == nil then
    return nil
  end
  if self.isSimulate and playerID == Game.Myself.data.id then
    return self.simulateName
  else
    local player = NSceneUserProxy.Instance:Find(playerID)
    if player ~= nil then
      local boothData = player.data.boothData
      if boothData ~= nil then
        return boothData:GetName()
      end
    end
  end
end
function BoothProxy:RecvExchangeRecord(data)
  TableUtility.ArrayClear(self.boothSellRecordList)
  for i = 1, #data.log_list do
    local logData = data.log_list[i]
    if logData.itemid ~= 0 then
      local itemData = ExchangeLogData.new(logData)
      if BoothProxy.IsSell(itemData.type) then
        table.insert(self.boothSellRecordList, itemData)
        if itemData.type ~= ShopMallLogTypeEnum.PublicityBuying and itemData.status == ShopMallLogReceiveEnum.ReceiveGive and not self:IsExistLog(self.boothRecieveRecord, itemData.id, itemData.type) then
          TableUtility.ArrayPushBack(self.boothRecieveRecord, itemData)
        end
      end
    end
  end
  table.sort(self.boothSellRecordList, function(l, r)
    return l.tradetime > r.tradetime
  end)
end
function BoothProxy:RecvTakeLog(data)
  if data.success and data.log then
    local id = data.log.id
    local type = data.log.logtype
    if id and type then
      for i = 1, #self.boothSellRecordList do
        if self.boothSellRecordList[i].id == id and self.boothSellRecordList[i].type == type then
          self.boothSellRecordList[i]:SetStatus(ShopMallLogReceiveEnum.Receive)
          for j = #self.boothRecieveRecord, 1, -1 do
            local receiveData = self.boothRecieveRecord[j]
            if receiveData.id == id and receiveData.type == type then
              table.remove(self.boothRecieveRecord, j)
              break
            end
          end
          break
        end
      end
    end
  end
end
function BoothProxy:RecvAddNewLog(serverData)
  if serverData.log and serverData.log.id then
    local itemData = ExchangeLogData.new(serverData.log)
    if itemData:CanReceive() and itemData.type == ShopMallLogTypeEnum.NormalBuy then
      TableUtility.TableClear(self.tableTakeLog)
      self.tableTakeLog.id = itemData.id
      self.tableTakeLog.logtype = itemData.type
      self.tableTakeLog.trade_type = itemData.tradeType or BoothProxy.TradeType.Booth
      ServiceRecordTradeProxy.Instance:CallTakeLogCmd(self.tableTakeLog)
    end
    if BoothProxy.IsSell(itemData.type) and not self:IsExistLog(self.boothSellRecordList, data.log.id, data.log.type) then
      TableUtility.ArrayPushFront(self.boothSellRecordList, itemData)
    end
  end
  local count = #self.boothSellRecordList
  if count > GameConfig.Exchange.PageNumber then
    table.remove(self.boothSellRecordList, count)
  end
end
function BoothProxy:RecvCanTakeCount(data)
  if data and data.count then
    self.boothRecieveRecordCount = data.count
  end
end
function BoothProxy:GetBoothSellRecordReceiveCount()
  return self.boothRecieveRecordCount or 0
end
function BoothProxy:GetBoothSellRecordList()
  return self.boothSellRecordList
end
function BoothProxy.IsSell(itemType)
  return itemType and (itemType == ShopMallLogTypeEnum.NormalSell or itemType == ShopMallLogTypeEnum.PublicitySellSuccess)
end
function BoothProxy:IsExistLog(list, logId, type)
  for i = 1, #list do
    local data = list[i]
    if data.id == logId and data.type == type then
      return true
    end
  end
  return false
end
