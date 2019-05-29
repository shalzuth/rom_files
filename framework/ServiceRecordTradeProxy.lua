autoImport("ServiceRecordTradeAutoProxy")
ServiceRecordTradeProxy = class("ServiceRecordTradeProxy", ServiceRecordTradeAutoProxy)
ServiceRecordTradeProxy.Instance = nil
ServiceRecordTradeProxy.NAME = "ServiceRecordTradeProxy"
function ServiceRecordTradeProxy:ctor(proxyName)
  if ServiceRecordTradeProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRecordTradeProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRecordTradeProxy.Instance = self
  end
end
function ServiceRecordTradeProxy:RecvBriefPendingListRecordTradeCmd(data)
  ShopMallProxy.Instance:RecvExchangeBuySellingClassify(data)
  self:Notify(ServiceEvent.RecordTradeBriefPendingListRecordTradeCmd, data)
end
function ServiceRecordTradeProxy:RecvDetailPendingListRecordTradeCmd(data)
  ShopMallProxy.Instance:RecvExchangeBuyDetail(data)
  self:Notify(ServiceEvent.RecordTradeDetailPendingListRecordTradeCmd, data)
end
function ServiceRecordTradeProxy:RecvMyPendingListRecordTradeCmd(data)
  ShopMallProxy.Instance:RecvExchangePendingList(data)
  self:Notify(ServiceEvent.RecordTradeMyPendingListRecordTradeCmd, data)
end
function ServiceRecordTradeProxy:RecvItemSellInfoRecordTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradeItemSellInfoRecordTradeCmd, data)
end
function ServiceRecordTradeProxy:RecvMyTradeLogRecordTradeCmd(data)
  if data.trade_type == BoothProxy.TradeType.Exchange then
    QuickBuyProxy.Instance:RecvRecord(data)
    ShopMallProxy.Instance:RecvExchangeRecord(data)
  else
    BoothProxy.Instance:RecvExchangeRecord(data)
  end
  self:Notify(ServiceEvent.RecordTradeMyTradeLogRecordTradeCmd, data)
end
function ServiceRecordTradeProxy:CallReqServerPriceRecordTradeCmd(charid, itemData, price, issell, statetype, count, buyer_count, end_time, trade_type)
  if not itemData or not itemData:ExportServerItem() then
    local serverItem
  end
  ServiceRecordTradeProxy.super.CallReqServerPriceRecordTradeCmd(self, charid, serverItem, price, issell, statetype, count, buyer_count, end_time, trade_type)
end
function ServiceRecordTradeProxy:RecvReqServerPriceRecordTradeCmd(data)
  FunctionItemTrade.Me():SetTradePrice(data.itemData, data.price)
  QuickBuyProxy.Instance:RecvCompareEquipPrice(data)
  self:Notify(ServiceEvent.RecordTradeReqServerPriceRecordTradeCmd, data)
end
function ServiceRecordTradeProxy:RecvHotItemidRecordTrade(data)
  ShopMallProxy.Instance:RecvExchangeBuySellingClassify(data)
  self:Notify(ServiceEvent.RecordTradeHotItemidRecordTrade, data)
end
function ServiceRecordTradeProxy:RecvTakeLogCmd(data)
  ShopMallProxy.Instance:RecvTakeLog(data)
  if data.log and data.log.trade_type == BoothProxy.TradeType.Booth then
    BoothProxy.Instance:RecvTakeLog(data)
  end
  self:Notify(ServiceEvent.RecordTradeTakeLogCmd, data)
end
function ServiceRecordTradeProxy:RecvAddNewLog(data)
  ShopMallProxy.Instance:RecvAddNewLog(data)
  if data.log and data.log.trade_type == BoothProxy.TradeType.Booth then
    BoothProxy.Instance:RecvAddNewLog(data)
  end
  self:Notify(ServiceEvent.RecordTradeAddNewLog, data)
end
function ServiceRecordTradeProxy:RecvFetchNameInfoCmd(data)
  ShopMallProxy.Instance:RecvExchangeRecordDetail(data)
  self:Notify(ServiceEvent.RecordTradeFetchNameInfoCmd, data)
end
function ServiceRecordTradeProxy:RecvNtfCanTakeCountTradeCmd(data)
  if data.trade_type == BoothProxy.TradeType.Exchange then
    ShopMallProxy.Instance:RecvCanTakeCount(data)
  else
    BoothProxy.Instance:RecvCanTakeCount(data)
  end
  self:Notify(ServiceEvent.RecordTradeNtfCanTakeCountTradeCmd, data)
end
function ServiceRecordTradeProxy:RecvReqGiveItemInfoCmd(data)
  ShopMallProxy.Instance:RecvReqGiveItemInfoCmd(data.iteminfo)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ExchangeSignExpressView
  })
  self:Notify(ServiceEvent.RecordTradeReqGiveItemInfoCmd, data)
end
function ServiceRecordTradeProxy:RecvBuyItemRecordTradeCmd(data)
  if data.type == BoothProxy.TradeType.Exchange then
    QuickBuyProxy.Instance:RecvBuyItem(data)
  end
  self:Notify(ServiceEvent.RecordTradeBuyItemRecordTradeCmd, data)
end
function ServiceRecordTradeProxy:RecvQueryItemCountTradeCmd(data)
  QuickBuyProxy.Instance:RecvQueryItemCountTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradeQueryItemCountTradeCmd, data)
end
function ServiceRecordTradeProxy:RecvTodayFinanceRank(data)
  ShopMallProxy.Instance:RecvTodayFinanceRank(data)
  self:Notify(ServiceEvent.RecordTradeTodayFinanceRank, data)
end
function ServiceRecordTradeProxy:RecvTodayFinanceDetail(data)
  ShopMallProxy.Instance:RecvTodayFinanceDetail(data)
  self:Notify(ServiceEvent.RecordTradeTodayFinanceDetail, data)
end
function ServiceRecordTradeProxy:RecvBoothPlayerPendingListCmd(data)
  BoothProxy.Instance:RecvBoothPlayerPendingListCmd(data)
  self:Notify(ServiceEvent.RecordTradeBoothPlayerPendingListCmd, data)
end
function ServiceRecordTradeProxy:RecvUpdateOrderTradeCmd(data)
  if data.type == BoothProxy.TradeType.Booth then
    BoothProxy.Instance:RecvUpdateOrderTradeCmd(data)
  end
  self:Notify(ServiceEvent.RecordTradeUpdateOrderTradeCmd, data)
end
function ServiceRecordTradeProxy:CallCancelItemRecordTrade(item_info, charid, ret, order_id, type)
  local msg = RecordTrade_pb.CancelItemRecordTrade()
  if item_info ~= nil then
    msg.item_info = item_info
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if ret ~= nil then
    msg.ret = ret
  end
  if order_id ~= nil then
    msg.order_id = order_id
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceRecordTradeProxy:CallResellPendingRecordTrade(item_info, charid, ret, order_id, type)
  local msg = RecordTrade_pb.ResellPendingRecordTrade()
  if item_info ~= nil and item_info.itemid ~= nil then
    msg.item_info.itemid = item_info.itemid
  end
  if item_info ~= nil and item_info.price ~= nil then
    msg.item_info.price = item_info.price
  end
  if item_info ~= nil and item_info.publicity_id ~= nil then
    msg.item_info.publicity_id = item_info.publicity_id
  end
  if item_info ~= nil and item_info.up_rate ~= nil then
    msg.item_info.up_rate = item_info.up_rate
  end
  if item_info ~= nil and item_info.down_rate ~= nil then
    msg.item_info.down_rate = item_info.down_rate
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if ret ~= nil then
    msg.ret = ret
  end
  if order_id ~= nil then
    msg.order_id = order_id
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceRecordTradeProxy:CallBuyItemRecordTradeCmd(item_info, charid, ret, type)
  local msg = RecordTrade_pb.BuyItemRecordTradeCmd()
  if item_info ~= nil and item_info.itemid ~= nil then
    msg.item_info.itemid = item_info.itemid
  end
  if item_info ~= nil and item_info.price ~= nil then
    msg.item_info.price = item_info.price
  end
  if item_info ~= nil and item_info.count ~= nil then
    msg.item_info.count = item_info.count
  end
  if item_info ~= nil and item_info.order_id ~= nil then
    msg.item_info.order_id = item_info.order_id
  end
  if item_info ~= nil and item_info.publicity_id ~= nil then
    msg.item_info.publicity_id = item_info.publicity_id
  end
  if item_info ~= nil and item_info.charid ~= nil then
    msg.item_info.charid = item_info.charid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if ret ~= nil then
    msg.ret = ret
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceRecordTradeProxy:CallTakeLogCmd(log, success)
  local msg = RecordTrade_pb.TakeLogCmd()
  if log ~= nil then
    if log.id ~= nil then
      msg.log.id = log.id
    end
    if log.logtype ~= nil then
      msg.log.logtype = log.logtype
    end
    if log.trade_type ~= nil then
      msg.log.trade_type = log.trade_type
    end
  end
  if log ~= nil and log.trade_type ~= nil then
    msg.log.trade_type = log.trade_type
  end
  self:SendProto(msg)
end
function ServiceRecordTradeProxy:CallReqGiveItemInfoCmd(id, iteminfo)
  local msg = RecordTrade_pb.ReqGiveItemInfoCmd()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
