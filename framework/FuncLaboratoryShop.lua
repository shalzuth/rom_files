FuncLaboratoryShop = class("FuncLaboratoryShop")

function FuncLaboratoryShop:ctor()
	
end

function FuncLaboratoryShop.Instance()
	if FuncLaboratoryShop.instance == nil then
		FuncLaboratoryShop.instance = FuncLaboratoryShop.new()
	end
	return FuncLaboratoryShop.instance
end

function FuncLaboratoryShop:OpenUI(i_type, i_serial_number)
	if i_type ~= nil and i_type > 0 and i_serial_number ~= nil and i_serial_number > 0 then
		self:ListenQueryShopItemEventFromServer()
		ServiceSessionShopProxy.Instance:CallQueryShopItem(i_type, i_serial_number)
	end
end

function FuncLaboratoryShop:ListenQueryShopItemEventFromServer()
	EventManager.Me():AddEventListener(ServiceEvent.SessionShopQueryShopItem, self.OnReceiveQueryShopItem, self)
end

function FuncLaboratoryShop:CancelListenQueryShopItemEventFromServer()
	EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopQueryShopItem, self.OnReceiveQueryShopItem, self)
end

function FuncLaboratoryShop:OnReceiveQueryShopItem(data)
	self:CancelListenQueryShopItemEventFromServer()
	HappyShopProxy.Instance:SetIsScreen(data.screen)
	HappyShopProxy.Instance:SetShop(data.items)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.HappyShop})
end