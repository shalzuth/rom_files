local ShopView = class("ShopView", ContainerView)
autoImport("ShopViewExchangePage")
ShopView.ViewType = UIViewType.NormalLayer
function ShopView:Init()
  self:AddSubView("ShopViewExchangePage", ShopViewExchangePage)
end
function ShopView:CloseTip()
end
function ShopView:OnExit()
  self:CloseTip()
  self.super.OnExit(self)
end
return ShopView
