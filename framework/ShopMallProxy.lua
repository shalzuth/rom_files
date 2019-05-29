autoImport("ExchangeTypesData")
autoImport("ExchangeClassifyData")
autoImport("ExchangeLogData")
autoImport("ShopMallItemData")
autoImport("ExchangeExpressData")
autoImport("FinanceData")
ShopMallProxy = class("ShopMallProxy", pm.Proxy)
ShopMallProxy.Instance = nil
ShopMallProxy.NAME = "ShopMallProxy"
ShopMallFilterEnum = {
  Level = "Level",
  Fashion = "Fashion",
  Trade = "Trade",
  Record = "Record"
}
ShopMallExchangeEnum = {
  Buy = "Buy",
  Sell = "Sell",
  Record = "Record"
}
ShopMallExchangeSellEnum = {
  Sell = "Sell",
  Cancel = "Cancel",
  Resell = "Resell"
}
ShopMallStateTypeEnum = {
  OverlapNormal = RecordTrade_pb.St_OverlapNormal,
  NonoverlapNormal = RecordTrade_pb.St_NonoverlapNormal,
  WillPublicity = RecordTrade_pb.St_WillPublicity,
  InPublicity = RecordTrade_pb.St_InPublicity
}
ShopMallLogTypeEnum = {
  NormalSell = RecordTrade_pb.EOperType_NormalSell,
  NormalBuy = RecordTrade_pb.EOperType_NoramlBuy,
  Publicity = RecordTrade_pb.EOperType_Publicity,
  PublicitySellSuccess = RecordTrade_pb.EOperType_PublicitySellSuccess,
  PublicitySellFail = RecordTrade_pb.EOperType_PublicitySellFail,
  PublicityBuySuccess = RecordTrade_pb.EOperType_PublicityBuySuccess,
  PublicityBuyFail = RecordTrade_pb.EOperType_PublicityBuyFail,
  PublicityBuying = RecordTrade_pb.EOperType_PublicityBuying,
  AutoOff = RecordTrade_pb.EOperType_AutoOffTheShelf
}
ShopMallLogReceiveEnum = {
  ReceiveGive = RecordTrade_pb.ETakeStatus_CanTakeGive,
  Receive = RecordTrade_pb.ETakeStatus_Took,
  Receiving = RecordTrade_pb.ETakeStatus_Taking,
  Giving = RecordTrade_pb.ETakeStatus_Giving,
  GiveAccepting = RecordTrade_pb.ETakeStatus_Give_Accepting,
  Gived1 = RecordTrade_pb.ETakeStatus_Give_Accepted_1,
  Gived2 = RecordTrade_pb.ETakeStatus_Give_Accepted_2
}
FinanceRankTypeEnum = {
  DealCount = RecordTrade_pb.EFINANCE_RANK_DEALCOUNT,
  UpRatio = RecordTrade_pb.EFINANCE_RANK_UPRATIO,
  DownRatio = RecordTrade_pb.EFINANCE_RANK_DOWNRATIO
}
FinanceDateTypeEnum = {
  Three = RecordTrade_pb.EFINANCE_DATE_THREE,
  Seven = RecordTrade_pb.EFINANCE_DATE_SEVEN
}
function ShopMallProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ShopMallProxy.NAME
  if ShopMallProxy.Instance == nil then
    ShopMallProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function ShopMallProxy:Init()
  self.exchangeBuyClassify = {}
  self.exchangeBuyDetail = {}
  self.exchangePendingList = {}
  self.exchangeRecordList = {}
  self.exchangeRecordFilterList = {}
  self.exchangeRecordDetailList = {}
  self.exchangeRecordReceive = {}
  self.financeMap = {}
end
function ShopMallProxy:InitExchangeBuyTypes()
  local parentTypes = {}
  for k, v in pairs(Table_ItemTypeAdventureLog) do
    if v.ExchangeOrder then
      table.insert(parentTypes, v)
    end
  end
  table.sort(parentTypes, function(l, r)
    return l.ExchangeOrder < r.ExchangeOrder
  end)
  self.exchangeBuyParentTypes = {}
  for i = 1, #parentTypes do
    local typesData = ExchangeTypesData.new(parentTypes[i])
    table.insert(self.exchangeBuyParentTypes, typesData)
  end
  self.exchangeBuyChildTypes = {}
  for i = 1, #self.exchangeBuyParentTypes do
    local parent = self.exchangeBuyParentTypes[i].id
    for k, v in pairs(Table_ItemTypeAdventureLog) do
      if v.ExchangeType and v.ExchangeType == parent then
        if self.exchangeBuyChildTypes[parent] == nil then
          self.exchangeBuyChildTypes[parent] = {}
        end
        local typesData = ExchangeTypesData.new(v)
        table.insert(self.exchangeBuyChildTypes[parent], typesData)
      end
    end
    if self.exchangeBuyChildTypes[parent] ~= nil then
      table.sort(self.exchangeBuyChildTypes[parent], function(l, r)
        return l.id < r.id
      end)
    end
  end
end
function ShopMallProxy:InitExchangeBuyClassify()
  self.exchangeBuyClassify = {}
  for k, v in pairs(Table_Exchange) do
    if v.Category then
      if self.exchangeBuyClassify[v.Category] == nil then
        self.exchangeBuyClassify[v.Category] = {}
      end
      table.insert(self.exchangeBuyClassify[v.Category], v.id)
    end
  end
  for k, v in pairs(self.exchangeBuyClassify) do
    table.sort(self.exchangeBuyClassify[k], function(l, r)
      return l < r
    end)
  end
end
function ShopMallProxy:InitExchangeSearchHistory()
  self.exchangeSearchHistory = {}
  local temp = LocalSaveProxy.Instance:GetExchangeSearchHistory()
  for i = 1, #temp do
    if Table_Item[temp[i]] then
      table.insert(self.exchangeSearchHistory, temp[i])
    end
  end
end
function ShopMallProxy:AddExchangeSearchHistory(itemId)
end
function ShopMallProxy:ResetExchangeBuyClassify()
  self.exchangeBuyClassify = {}
end
function ShopMallProxy:ResetExchangeBuyDetail()
  self.exchangeBuyDetail = {}
end
function ShopMallProxy:CallBuyItemRecordTradeCmd(itemInfo, callback)
  FunctionSecurity.Me():Exchange_SellOrBuyItem(function(arg)
    ServiceRecordTradeProxy.Instance:CallBuyItemRecordTradeCmd(arg, Game.Myself.data.id, nil, arg.type)
    if callback ~= nil then
      callback()
    end
  end, itemInfo)
end
function ShopMallProxy:RecvExchangeBuyDetail(data)
  self.exchangeBuyDetail = {}
  self.exchangeBuyDetailTotalPageCount = data.total_page_count
  if data.search_cond and data.search_cond.page_index then
    self.exchangeBuyDetailCurrentPageIndex = data.search_cond.page_index
  else
    errorLog(string.format("ShopMallProxy RecvExchangeBuyDetail : data.search_cond = %s", tostring(data.search_cond)))
  end
  for i = 1, #data.lists do
    local itemData = ShopMallItemData.new(data.lists[i])
    table.insert(self.exchangeBuyDetail, itemData)
  end
end
function ShopMallProxy:RecvExchangePendingList(data)
  self.exchangePendingList = {}
  for i = 1, #data.lists do
    local itemData = ShopMallItemData.new(data.lists[i])
    table.insert(self.exchangePendingList, itemData)
  end
end
function ShopMallProxy:RecvExchangeRecord(data)
  TableUtility.ArrayClear(self.exchangeRecordList)
  for i = 1, #data.log_list do
    local logData = data.log_list[i]
    if logData.itemid ~= 0 then
      local itemData = ExchangeLogData.new(logData)
      table.insert(self.exchangeRecordList, itemData)
      if itemData.type ~= ShopMallLogTypeEnum.PublicityBuying and itemData.status == ShopMallLogReceiveEnum.ReceiveGive and not self:IsExistLog(self.exchangeRecordReceive, itemData.id, itemData.type) then
        TableUtility.ArrayPushBack(self.exchangeRecordReceive, itemData)
        self:AddExchangeRecordRedTip()
      end
    end
  end
  table.sort(self.exchangeRecordList, function(l, r)
    return l.tradetime > r.tradetime
  end)
end
function ShopMallProxy:RecvExchangeBuySellingClassify(data)
  TableUtility.ArrayClear(self.exchangeBuyClassify)
  if data.lists then
    for i = 1, #data.pub_lists do
      local classifyData = ExchangeClassifyData.new()
      classifyData:SetId(data.pub_lists[i])
      classifyData:SetIsPublicity(true)
      TableUtility.ArrayPushBack(self.exchangeBuyClassify, classifyData)
    end
    for i = 1, #data.lists do
      local classifyData = ExchangeClassifyData.new()
      classifyData:SetId(data.lists[i])
      classifyData:SetIsPublicity(false)
      TableUtility.ArrayPushBack(self.exchangeBuyClassify, classifyData)
    end
  end
end
function ShopMallProxy:RecvTakeLog(data)
  if data.success and data.log then
    local id = data.log.id
    local type = data.log.logtype
    if id and type then
      for i = 1, #self.exchangeRecordList do
        if self.exchangeRecordList[i].id == id and self.exchangeRecordList[i].type == type then
          self.exchangeRecordList[i]:SetStatus(ShopMallLogReceiveEnum.Receive)
          for j = #self.exchangeRecordReceive, 1, -1 do
            local receiveData = self.exchangeRecordReceive[j]
            if receiveData.id == id and receiveData.type == type then
              table.remove(self.exchangeRecordReceive, j)
              self:RemoveExchangeRecordRedTip()
              break
            end
          end
          break
        end
      end
    end
  end
end
function ShopMallProxy:RecvAddNewLog(data)
  if data.log and data.log.id and not self:IsExistLog(self.exchangeRecordList, data.log.id, data.log.type) then
    local itemData = ExchangeLogData.new(data.log)
    TableUtility.ArrayPushFront(self.exchangeRecordList, itemData)
  end
  local count = #self.exchangeRecordList
  if count > GameConfig.Exchange.PageNumber then
    table.remove(self.exchangeRecordList, count)
  end
end
function ShopMallProxy:RecvExchangeRecordDetail(data)
  if data and data.name_list and data.name_list.name_infos then
    self:ResetExchangeRecordDetailList()
    for i = 1, #data.name_list.name_infos do
      local nameData = ExchangeLogNameData.new(data.name_list.name_infos[i])
      TableUtility.ArrayPushBack(self.exchangeRecordDetailList, nameData)
    end
  end
end
function ShopMallProxy:RecvCanTakeCount(data)
  if data and data.count then
    self.exchangeRecordReceiveCount = data.count
    if data.count < 1 then
      RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TRADE_RECORD)
    end
  end
end
function ShopMallProxy:JudgeSelfProfession(itemId)
  local equipData = Table_Equip[itemId]
  if equipData then
    if #equipData.CanEquip == 1 and equipData.CanEquip[1] == 0 then
      return true
    end
    for i = 1, #equipData.CanEquip do
      if equipData.CanEquip[i] == MyselfProxy.Instance:GetMyProfession() then
        return true
      end
    end
  else
    errorLog(string.format("ShopMallProxy JudgeSelfProfession : Table_Equip[%s] == nil", tostring(itemId)))
  end
  return false
end
function ShopMallProxy:JudgeSpecialEquip(data)
  if data and data.equipInfo then
    if data.equipInfo.strengthlv > 0 then
      return true
    end
    if 0 < data.equipInfo.refinelv then
      return true
    end
    local cardSlotNum = data.cardSlotNum
    local equipedCardInfo = data.equipedCardInfo
    if cardSlotNum and cardSlotNum > 0 and equipedCardInfo and #equipedCardInfo > 0 then
      return true
    end
  end
  return false
end
function ShopMallProxy:IsExistLog(list, logId, type)
  for i = 1, #list do
    local data = list[i]
    if data.id == logId and data.type == type then
      return true
    end
  end
  return false
end
function ShopMallProxy:GetExchangeBuyParentTypes()
  if self.exchangeBuyParentTypes == nil then
    self:InitExchangeBuyTypes()
  end
  return self.exchangeBuyParentTypes
end
function ShopMallProxy:GetExchangeBuyChildTypes(parentId)
  if self.exchangeBuyChildTypes == nil then
    self:InitExchangeBuyTypes()
  end
  return self.exchangeBuyChildTypes[parentId]
end
function ShopMallProxy:GetExchangeBuyClassify(typeId)
  if self.exchangeBuyClassify == nil then
    self:InitExchangeBuyClassify()
  end
  return self.exchangeBuyClassify[typeId]
end
function ShopMallProxy:GetExchangeBuySelfProfessionClassify(typeId)
  if self.exchangeBuySelfProfessionClassify == nil then
    self.exchangeBuySelfProfessionClassify = {}
  end
  if self.exchangeBuyClassify == nil then
    self:InitExchangeBuyClassify()
  end
  if self.exchangeBuySelfProfessionClassify[typeId] == nil then
    self.exchangeBuySelfProfessionClassify[typeId] = {}
    if self.exchangeBuyClassify[typeId] == nil then
      return
    end
    for i = 1, #self.exchangeBuyClassify[typeId] do
      local data = self.exchangeBuyClassify[typeId][i]
      if self:JudgeSelfProfession(data) then
        table.insert(self.exchangeBuySelfProfessionClassify[typeId], data)
      end
    end
    table.sort(self.exchangeBuySelfProfessionClassify[typeId], function(l, r)
      return l < r
    end)
  end
  return self.exchangeBuySelfProfessionClassify[typeId]
end
local buyFilter = {}
function ShopMallProxy:GetExchangeFilter(filterData)
  TableUtility.ArrayClear(buyFilter)
  for k, v in pairs(filterData) do
    table.insert(buyFilter, k)
  end
  table.sort(buyFilter, function(l, r)
    return l < r
  end)
  return buyFilter
end
function ShopMallProxy:GetExchangeBuyLevelFilterRangeIndex(level)
  for k, v in pairs(GameConfig.Exchange.ExchangeLevel) do
    if level >= v.minlv and level <= v.maxlv then
      return k
    end
  end
end
function ShopMallProxy:GetExchangeBuyDetail()
  return self.exchangeBuyDetail
end
function ShopMallProxy:GetExchangeBuyDetailTotalPageCount()
  return self.exchangeBuyDetailTotalPageCount
end
function ShopMallProxy:GetExchangeBuyDetailCurrentPageIndex()
  return self.exchangeBuyDetailCurrentPageIndex
end
local bagSell = {}
function ShopMallProxy:GetExchangeBagSellByBagType(bagType, array)
  bagType = bagType or BagProxy.BagType.MainBag
  local bagData = BagProxy.Instance.bagMap[bagType]
  if bagData then
    local items = bagData:GetItems()
    for i = 1, #items do
      local itemData = items[i]
      if itemData and itemData:CanTrade() then
        table.insert(array, itemData)
      end
    end
  end
end
function ShopMallProxy:GetExchangeBagSell()
  TableUtility.ArrayClear(bagSell)
  self:GetExchangeBagSellByBagType(BagProxy.BagType.MainBag, bagSell)
  self:GetExchangeBagSellByBagType(BagProxy.BagType.Barrow, bagSell)
  self:GetExchangeBagSellByBagType(BagProxy.BagType.PersonalStorage, bagSell)
  return bagSell
end
function ShopMallProxy:GetExchangeSelfSelling()
  return self.exchangePendingList
end
function ShopMallProxy:GetExchangeRecordList()
  return self.exchangeRecordList
end
local searchHistory = {}
function ShopMallProxy:GetExchangeSearchHistory()
  TableUtility.ArrayClear(searchHistory)
  for i = #LocalSaveProxy.Instance:GetExchangeSearchHistory(), 1, -1 do
    local history = LocalSaveProxy.Instance:GetExchangeSearchHistory()[i]
    table.insert(searchHistory, history)
  end
  return searchHistory
end
local searchContent = {}
function ShopMallProxy:GetExchangeSearchContent(keyword)
  TableUtility.ArrayClear(searchContent)
  keyword = string.lower(keyword)
  local tempName
  local _CheckItemCanTrade = ItemData.CheckItemCanTrade
  for k, v in pairs(Table_Exchange) do
    if v.NameZh and _CheckItemCanTrade(v.id) then
      tempName = string.lower(v.NameZh)
      if string.find(tempName, keyword) then
        table.insert(searchContent, v.id)
      end
      kr_str = OverSea.LangManager.Instance():GetLangByKey(v.NameZh)
      if kr_str and string.find(string.lower(kr_str), keyword) then
        table.insert(searchContent, v.id)
      end
    else
      errorLog("ShopMallProxy GetExchangeSearchContent : NameZh = nil")
    end
  end
  return searchContent
end
function ShopMallProxy:GetExchangeBuyClassify()
  return self.exchangeBuyClassify
end
function ShopMallProxy:GetExchangeParentAndChildType(itemId)
  if itemId == nil then
    return nil, nil
  end
  local exchange = Table_Exchange[itemId]
  if exchange and ItemData.CheckItemCanTrade(itemId) then
    local category = exchange.Category
    if category then
      local typesData = Table_ItemTypeAdventureLog[category]
      if typesData.ExchangeType then
        return typesData.ExchangeType, category
      else
        return category, nil
      end
    else
      errorLog(string.format("ShopMallProxy GetExchangeFatherAndChildType : Table_Exchange[%s].Category == nil", tostring(itemId)))
    end
  else
    errorLog(string.format("ShopMallProxy GetExchangeFatherAndChildType : Table_Exchange[%s] == nil", tostring(itemId)))
  end
  return nil, nil
end
function ShopMallProxy:GetExchangeRecordReceiveCount()
  return self.exchangeRecordReceiveCount or 0
end
function ShopMallProxy:SetExchangeRecordDetailType(type)
  self.exchangeRecordDetailType = type
end
function ShopMallProxy:GetExchangeRecordDetailType()
  return self.exchangeRecordDetailType
end
function ShopMallProxy:GetExchangeRecordFilter(filterData)
  if filterData == 0 then
    return self.exchangeRecordList
  elseif filterData == 1 then
    TableUtility.ArrayClear(self.exchangeRecordFilterList)
    for i = 1, #self.exchangeRecordList do
      local data = self.exchangeRecordList[i]
      local logType = data.type
      if logType and (logType == ShopMallLogTypeEnum.NormalSell or logType == ShopMallLogTypeEnum.PublicitySellSuccess or logType == ShopMallLogTypeEnum.PublicitySellFail) then
        TableUtility.ArrayPushBack(self.exchangeRecordFilterList, data)
      end
    end
  elseif filterData == 2 then
    TableUtility.ArrayClear(self.exchangeRecordFilterList)
    for i = 1, #self.exchangeRecordList do
      local data = self.exchangeRecordList[i]
      local logType = data.type
      if logType and logType == ShopMallLogTypeEnum.NormalBuy then
        TableUtility.ArrayPushBack(self.exchangeRecordFilterList, data)
      end
    end
  elseif filterData == 3 then
    TableUtility.ArrayClear(self.exchangeRecordFilterList)
    for i = 1, #self.exchangeRecordList do
      local data = self.exchangeRecordList[i]
      local logType = data.type
      if logType and (logType == ShopMallLogTypeEnum.PublicityBuySuccess or logType == ShopMallLogTypeEnum.PublicityBuyFail or logType == ShopMallLogTypeEnum.PublicityBuying) then
        TableUtility.ArrayPushBack(self.exchangeRecordFilterList, data)
      end
    end
  elseif filterData == 4 then
    TableUtility.ArrayClear(self.exchangeRecordFilterList)
    for i = 1, #self.exchangeRecordList do
      local data = self.exchangeRecordList[i]
      local status = data.status
      if status and (status == ShopMallLogReceiveEnum.Giving or status == ShopMallLogReceiveEnum.GiveAccepting or status == ShopMallLogReceiveEnum.Gived1 or status == ShopMallLogReceiveEnum.Gived2) then
        TableUtility.ArrayPushBack(self.exchangeRecordFilterList, data)
      end
    end
  end
  return self.exchangeRecordFilterList
end
function ShopMallProxy:GetClosestReceiveIndex(filterData)
  local list = self:GetExchangeRecordFilter(filterData)
  for i = 1, #list do
    local data = list[i]
    if data and data:CanReceive() then
      return i
    end
  end
end
function ShopMallProxy:GetExchangeRecordDetailList()
  return self.exchangeRecordDetailList
end
function ShopMallProxy:ResetExchangeRecordDetailList()
  TableUtility.ArrayClear(self.exchangeRecordDetailList)
end
function ShopMallProxy:AddExchangeRecordRedTip()
  if #self.exchangeRecordReceive >= 1 then
    RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_TRADE_RECORD)
  end
end
function ShopMallProxy:RemoveExchangeRecordRedTip()
  if #self.exchangeRecordReceive < 1 then
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TRADE_RECORD)
  end
end
function ShopMallProxy:CheckItemType(itemData)
  if itemData.staticData then
    if BagProxy.CheckIs3DTypeItem(itemData.staticData.Type) then
      return FloatAwardView.ShowType.ModelType
    else
      return nil
    end
  end
  return nil
end
function ShopMallProxy:RecvReqGiveItemInfoCmd(data)
  self.expressData = ExchangeExpressData.new(data)
end
function ShopMallProxy:GetExpressData()
  return self.expressData
end
function ShopMallProxy:CallTodayFinanceRank(rankType, dateType)
  local map = self.financeMap[rankType]
  if map ~= nil then
    local data = map[dateType]
    if data ~= nil and not data:CheckCanCall() then
      return false
    end
  end
  ServiceRecordTradeProxy.Instance:CallTodayFinanceRank(rankType, dateType)
  return true
end
function ShopMallProxy:CallTodayFinanceDetail(itemid, rankType, dateType)
  local map = self.financeMap[rankType]
  if map ~= nil then
    local data = map[dateType]
    if data ~= nil then
      local item = data:GetItemById(itemid)
      if item ~= nil and item:CheckCanCall() then
        ServiceRecordTradeProxy.Instance:CallTodayFinanceDetail(itemid, rankType, dateType)
        return true
      end
    end
  end
  return false
end
function ShopMallProxy:RecvTodayFinanceRank(serviceData)
  local rankType = serviceData.rank_type
  local map = self.financeMap[rankType]
  if map == nil then
    map = {}
    self.financeMap[rankType] = map
  end
  local data = map[serviceData.date_type]
  if data == nil then
    data = FinanceData.new()
    map[serviceData.date_type] = data
  end
  data:SetData(serviceData)
  data:SetNextValidTime(60)
end
function ShopMallProxy:RecvTodayFinanceDetail(serviceData)
  local map = self.financeMap[serviceData.rank_type]
  if map ~= nil then
    local data = map[serviceData.date_type]
    if data ~= nil then
      local item = data:GetItemById(serviceData.item_id)
      if item ~= nil then
        item:SetDetail(serviceData.lists)
        item:SetNextValidTime(60)
      end
    end
  end
end
function ShopMallProxy:GetFinanceData(rankType, dateType)
  local map = self.financeMap[rankType]
  if map ~= nil then
    return map[dateType]
  end
end
function ShopMallProxy:GetFinanceItemData(rankType, dateType, itemid)
  local map = self.financeMap[rankType]
  if map ~= nil then
    local data = map[dateType]
    if data ~= nil then
      return data:GetItemById(itemid)
    end
  end
end
function ShopMallProxy:GetBoothfee(price, count)
  local boothfee = math.ceil(price * GameConfig.Exchange.SellCost)
  if boothfee > GameConfig.Exchange.MaxBoothfee then
    return GameConfig.Exchange.MaxBoothfee * count
  end
  return boothfee * count
end
