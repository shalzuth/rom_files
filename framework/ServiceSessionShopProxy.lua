autoImport("ServiceSessionShopAutoProxy")
ServiceSessionShopProxy = class("ServiceSessionShopProxy", ServiceSessionShopAutoProxy)
ServiceSessionShopProxy.Instance = nil
ServiceSessionShopProxy.NAME = "ServiceSessionShopProxy"
function ServiceSessionShopProxy:ctor(proxyName)
  if ServiceSessionShopProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionShopProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionShopProxy.Instance = self
  end
end
function ServiceSessionShopProxy:CallQueryShopItem(type, items)
  ServiceSessionShopProxy.super.CallQueryShopItem(self, type, items)
end
function ServiceSessionShopProxy:RecvBuyShopItem(data)
  xdlog("RecvBuyShopItem", ServiceSessionShopProxy.super, ServiceSessionShopProxy.super.__cname)
  receiveBuyShopItem = Time.unscaledTime
  QuickBuyProxy.Instance:RecvBuyShopItem(data)
  self:Notify(ServiceEvent.SessionShopBuyShopItem, data)
  EventManager.Me():PassEvent(ServiceEvent.SessionShopBuyShopItem, data)
end
function ServiceSessionShopProxy:RecvQueryShopConfigCmd(data)
  ShopProxy.Instance:RecvQueryShopConfig(data)
  HappyShopProxy.Instance:RecvQueryShopConfig(data)
  self:Notify(ServiceEvent.SessionShopQueryShopConfigCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.SessionShopQueryShopConfigCmd, data)
  self:Notify(GuideEvent.SessionShopQueryShopConfigCmd)
end
function ServiceSessionShopProxy:RecvQueryQuickBuyConfigCmd(data)
  QuickBuyProxy.Instance:RecvQueryQuickBuyConfigCmd(data)
  self:Notify(ServiceEvent.SessionShopQueryQuickBuyConfigCmd, data)
end
function ServiceSessionShopProxy:RecvServerLimitSellCountCmd(data)
  ShopProxy.Instance:RecvServerLimitSellCountCmd(data)
  self:Notify(ServiceEvent.SessionShopServerLimitSellCountCmd, data)
end
function ServiceSessionShopProxy:RecvQueryShopSoldCountCmd(data)
  ShopProxy.Instance:Server_SetShopSoldCountCmdInfo(data.items)
  self:Notify(ServiceEvent.SessionShopQueryShopSoldCountCmd, data)
end
function ServiceSessionShopProxy:RecvShopDataUpdateCmd(data)
  ShopProxy.Instance:RecvShopDataUpdateCmd(data)
  self:Notify(ServiceEvent.SessionShopShopDataUpdateCmd, data)
end
function ServiceSessionShopProxy:RecvUpdateShopConfigCmd(data)
  ShopProxy.Instance:RecvUpdateShopConfigCmd(data)
  HappyShopProxy.Instance:RecvUpdateShopConfigCmd(data)
  self:Notify(ServiceEvent.SessionShopUpdateShopConfigCmd, data)
end
function ServiceSessionShopProxy:RecvUpdateExchangeShopData(data)
  ExchangeShopProxy.Instance:UpdateExchange(data)
  self:Notify(ServiceEvent.SessionShopUpdateExchangeShopData, data)
end
function ServiceSessionShopProxy:RecvResetExchangeShopDataShopCmd(data)
  ExchangeShopProxy.Instance:HandleResetData(data)
  self:Notify(ServiceEvent.SessionShopResetExchangeShopDataShopCmd, data)
end
function ServiceSessionShopProxy:RecvExchangeShopItemCmd(data)
  ExchangeShopProxy.Instance:ResetChoose()
  self:Notify(ServiceEvent.SessionShopExchangeShopItemCmd, data)
end
