autoImport("ShopMallExchangeView")
autoImport("ShopMallShopView")
autoImport("ShopMallRechargeView")
autoImport("ShopMallExchangeBuyView")
autoImport("ShopMallExchangeSellView")
autoImport("ShopMallExchangeRecordView")
ShopMallMainView = class("ShopMallMainView", ContainerView)
ShopMallMainView.ViewType = UIViewType.NormalLayer
function ShopMallMainView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function ShopMallMainView:FindObjs()
  self.exchangeView = self:FindGO("ExchangeView")
  self.shopView = self:FindGO("ShopView")
  self.rechargeView = self:FindGO("RechargeView")
  self.exchangeBtn = self:FindGO("ExchangeBtn")
  self.shopBtn = self:FindGO("ShopBtn")
  self.rechargeBtn = self:FindGO("RechargeBtn")
end
function ShopMallMainView:AddEvts()
  self:AddTabChangeEvent(self.exchangeBtn, self.exchangeView, PanelConfig.ShopMallExchangeView)
  self:AddTabChangeEvent(self.shopBtn, self.shopView, PanelConfig.ShopMallShopView)
  self:AddTabChangeEvent(self.rechargeBtn, self.rechargeView, PanelConfig.ShopMallRechargeView)
end
function ShopMallMainView:AddViewEvts()
end
function ShopMallMainView:InitShow()
  self.ShopMallExchangeView = self:AddSubView("ShopMallExchangeView", ShopMallExchangeView)
  self.ShopMallShopView = self:AddSubView("ShopMallShopView", ShopMallShopView)
  self.ShopMallRechargeView = self:AddSubView("ShopMallRechargeView", ShopMallRechargeView)
  self.ShopMallExchangeBuyView = self:AddSubView("ShopMallExchangeBuyView", ShopMallExchangeBuyView)
  self.ShopMallExchangeSellView = self:AddSubView("ShopMallExchangeSellView", ShopMallExchangeSellView)
  self.ShopMallExchangeRecordView = self:AddSubView("ShopMallExchangeRecordView", ShopMallExchangeRecordView)
  self:DisableTog()
end
function ShopMallMainView:OnEnter()
  ShopMallMainView.super.OnEnter(self)
  ServiceRecordTradeProxy.Instance:CallPanelRecordTrade(Game.Myself.data.id, RecordTrade_pb.EPANEL_OPEN)
end
function ShopMallMainView:OnExit()
  ShopMallMainView.super.OnExit(self)
  ServiceRecordTradeProxy.Instance:CallPanelRecordTrade(Game.Myself.data.id, RecordTrade_pb.EPANEL_CLOSE)
end
function ShopMallMainView:DisableTog()
  if not FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.ShopMallExchangeView.id) then
    self:SetTextureGrey(self.exchangeBtn)
  end
  if not FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.ShopMallShopView.id) then
    self:SetTextureGrey(self.shopBtn)
  end
  if not FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.ShopMallRechargeView.id) then
    self:SetTextureGrey(self.rechargeBtn)
  end
end
