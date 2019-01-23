local ShopView = class("ShopView", ContainerView)

autoImport("ShopViewExchangePage")

ShopView.ViewType = UIViewType.NormalLayer

function ShopView:Init()
	self:AddSubView("ShopViewExchangePage", ShopViewExchangePage)	
end

function ShopView:CloseTip()
	-- self:sendNotification(UIEvent.CloseUI, UIViewType.ItemTip);
end

function ShopView:OnExit()
	self:CloseTip()
	self.super.OnExit(self)
end

return ShopView