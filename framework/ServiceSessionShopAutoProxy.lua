ServiceSessionShopAutoProxy = class("ServiceSessionShopAutoProxy", ServiceProxy)
ServiceSessionShopAutoProxy.Instance = nil
ServiceSessionShopAutoProxy.NAME = "ServiceSessionShopAutoProxy"
function ServiceSessionShopAutoProxy:ctor(proxyName)
  if ServiceSessionShopAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionShopAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionShopAutoProxy.Instance = self
  end
end
function ServiceSessionShopAutoProxy:Init()
end
function ServiceSessionShopAutoProxy:onRegister()
  self:Listen(52, 1, function(data)
    self:RecvBuyShopItem(data)
  end)
  self:Listen(52, 2, function(data)
    self:RecvQueryShopConfigCmd(data)
  end)
  self:Listen(52, 3, function(data)
    self:RecvQueryQuickBuyConfigCmd(data)
  end)
  self:Listen(52, 4, function(data)
    self:RecvQueryShopSoldCountCmd(data)
  end)
  self:Listen(52, 5, function(data)
    self:RecvShopDataUpdateCmd(data)
  end)
  self:Listen(52, 6, function(data)
    self:RecvUpdateShopConfigCmd(data)
  end)
  self:Listen(52, 7, function(data)
    self:RecvUpdateExchangeShopData(data)
  end)
  self:Listen(52, 8, function(data)
    self:RecvExchangeShopItemCmd(data)
  end)
  self:Listen(52, 9, function(data)
    self:RecvResetExchangeShopDataShopCmd(data)
  end)
end
callBuyShopItem = nil
receiveBuyShopItem = nil
function ServiceSessionShopAutoProxy:CallBuyShopItem(id, count, price, price2, success)
  xdlog("CallBuyShopItem", self, callBuyShopItem, receiveBuyShopItem)
  local now = Time.unscaledTime
  if callBuyShopItem ~= nil and receiveBuyShopItem == nil then
    Debug.LogError("\230\178\161\230\156\137\230\148\182\229\136\176\230\156\141\229\138\161\229\153\168\229\155\158\229\164\141\239\188\140\229\136\164\230\150\173\228\184\186\230\150\173\231\186\191\239\188\140\228\184\141\229\164\132\231\144\134\232\180\173\228\185\176\232\175\183\230\177\130")
    return
  end
  callBuyShopItem = now
  receiveBuyShopItem = nil
  xdlog("CallBuyShopItem", self, callBuyShopItem, receiveBuyShopItem)
  local msg = SessionShop_pb.BuyShopItem()
  if id ~= nil then
    msg.id = id
  end
  if count ~= nil then
    msg.count = count
  end
  if price ~= nil then
    msg.price = price
  end
  if price2 ~= nil then
    msg.price2 = price2
  end
  if success ~= nil then
    msg.success = success
  end
  self:SendProto(msg)
end
function ServiceSessionShopAutoProxy:CallQueryShopConfigCmd(type, shopid, goods, screen, tab)
  local msg = SessionShop_pb.QueryShopConfigCmd()
  if type ~= nil then
    msg.type = type
  end
  if shopid ~= nil then
    msg.shopid = shopid
  end
  if goods ~= nil then
    for i = 1, #goods do
      table.insert(msg.goods, goods[i])
    end
  end
  if screen ~= nil then
    msg.screen = screen
  end
  if tab ~= nil then
    msg.tab = tab
  end
  self:SendProto(msg)
end
function ServiceSessionShopAutoProxy:CallQueryQuickBuyConfigCmd(itemids, goods)
  local msg = SessionShop_pb.QueryQuickBuyConfigCmd()
  if itemids ~= nil then
    for i = 1, #itemids do
      table.insert(msg.itemids, itemids[i])
    end
  end
  if goods ~= nil then
    for i = 1, #goods do
      table.insert(msg.goods, goods[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionShopAutoProxy:CallQueryShopSoldCountCmd(items)
  local msg = SessionShop_pb.QueryShopSoldCountCmd()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionShopAutoProxy:CallShopDataUpdateCmd(type, shopid)
  local msg = SessionShop_pb.ShopDataUpdateCmd()
  if type ~= nil then
    msg.type = type
  end
  if shopid ~= nil then
    msg.shopid = shopid
  end
  self:SendProto(msg)
end
function ServiceSessionShopAutoProxy:CallUpdateShopConfigCmd(type, shopid, del_goods_id, add_goods)
  local msg = SessionShop_pb.UpdateShopConfigCmd()
  if type ~= nil then
    msg.type = type
  end
  if shopid ~= nil then
    msg.shopid = shopid
  end
  if del_goods_id ~= nil then
    for i = 1, #del_goods_id do
      table.insert(msg.del_goods_id, del_goods_id[i])
    end
  end
  if add_goods ~= nil then
    for i = 1, #add_goods do
      table.insert(msg.add_goods, add_goods[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionShopAutoProxy:CallUpdateExchangeShopData(items, del_items, menu_open, reset)
  local msg = SessionShop_pb.UpdateExchangeShopData()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  if del_items ~= nil then
    for i = 1, #del_items do
      table.insert(msg.del_items, del_items[i])
    end
  end
  if menu_open ~= nil then
    msg.menu_open = menu_open
  end
  if reset ~= nil then
    msg.reset = reset
  end
  self:SendProto(msg)
end
function ServiceSessionShopAutoProxy:CallExchangeShopItemCmd(id, items)
  local msg = SessionShop_pb.ExchangeShopItemCmd()
  if id ~= nil then
    msg.id = id
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionShopAutoProxy:CallResetExchangeShopDataShopCmd(items)
  local msg = SessionShop_pb.ResetExchangeShopDataShopCmd()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionShopAutoProxy:RecvBuyShopItem(data)
  self:Notify(ServiceEvent.SessionShopBuyShopItem, data)
end
function ServiceSessionShopAutoProxy:RecvQueryShopConfigCmd(data)
  self:Notify(ServiceEvent.SessionShopQueryShopConfigCmd, data)
end
function ServiceSessionShopAutoProxy:RecvQueryQuickBuyConfigCmd(data)
  self:Notify(ServiceEvent.SessionShopQueryQuickBuyConfigCmd, data)
end
function ServiceSessionShopAutoProxy:RecvQueryShopSoldCountCmd(data)
  self:Notify(ServiceEvent.SessionShopQueryShopSoldCountCmd, data)
end
function ServiceSessionShopAutoProxy:RecvShopDataUpdateCmd(data)
  self:Notify(ServiceEvent.SessionShopShopDataUpdateCmd, data)
end
function ServiceSessionShopAutoProxy:RecvUpdateShopConfigCmd(data)
  self:Notify(ServiceEvent.SessionShopUpdateShopConfigCmd, data)
end
function ServiceSessionShopAutoProxy:RecvUpdateExchangeShopData(data)
  self:Notify(ServiceEvent.SessionShopUpdateExchangeShopData, data)
end
function ServiceSessionShopAutoProxy:RecvExchangeShopItemCmd(data)
  self:Notify(ServiceEvent.SessionShopExchangeShopItemCmd, data)
end
function ServiceSessionShopAutoProxy:RecvResetExchangeShopDataShopCmd(data)
  self:Notify(ServiceEvent.SessionShopResetExchangeShopDataShopCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SessionShopBuyShopItem = "ServiceEvent_SessionShopBuyShopItem"
ServiceEvent.SessionShopQueryShopConfigCmd = "ServiceEvent_SessionShopQueryShopConfigCmd"
ServiceEvent.SessionShopQueryQuickBuyConfigCmd = "ServiceEvent_SessionShopQueryQuickBuyConfigCmd"
ServiceEvent.SessionShopQueryShopSoldCountCmd = "ServiceEvent_SessionShopQueryShopSoldCountCmd"
ServiceEvent.SessionShopShopDataUpdateCmd = "ServiceEvent_SessionShopShopDataUpdateCmd"
ServiceEvent.SessionShopUpdateShopConfigCmd = "ServiceEvent_SessionShopUpdateShopConfigCmd"
ServiceEvent.SessionShopUpdateExchangeShopData = "ServiceEvent_SessionShopUpdateExchangeShopData"
ServiceEvent.SessionShopExchangeShopItemCmd = "ServiceEvent_SessionShopExchangeShopItemCmd"
ServiceEvent.SessionShopResetExchangeShopDataShopCmd = "ServiceEvent_SessionShopResetExchangeShopDataShopCmd"
