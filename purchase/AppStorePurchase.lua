autoImport('FuncZenyShop')

AppStorePurchase = class('AppStorePurchase')

function AppStorePurchase.Ins()
	if AppStorePurchase.ins == nil then
		AppStorePurchase.ins = AppStorePurchase.new()
	end
	return AppStorePurchase.ins
end

function AppStorePurchase:AddListener()
	self.listenerAdded = false
	EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnReceiveFinishLoadScene, self)
end

function AppStorePurchase:OnReceiveFinishLoadScene()
	if not self.listenerAdded then
		self.listenerAdded = true
		if not BackwardCompatibilityUtil.CompatibilityMode_V19 then
			self:SetCallbackAppStorePurchase()
		end
	end
end

function AppStorePurchase:SetCallbackAppStorePurchase()
	FunctionXDSDK.Ins:SetCallbackAppStorePurchase(function (x)
		self:ShowProduct(x)
		FunctionXDSDK.Ins:ClearPurchaseFromAppStore()
	end)
end

function AppStorePurchase:OpenZenyShopAndPurchase(product_id)
	local panel = self:GetPanelConfigFromProductID(product_id)
	FuncZenyShop.Instance():OpenUI(panel)
	if panel == PanelConfig.ZenyShopMonthlyVIP then
		self:ShowCardByProductID(product_id)
	end
	if not FuncZenyShop.Instance():TryPurchaseProduct(product_id) then
		EventManager.Me():AddEventListener(ZenyShopEvent.CanPurchase, self.OnReceiveCanPurchase, self)
		self.purchaseProductID = product_id
	end
end

function AppStorePurchase:ShowProduct(product_id)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AppStorePurchase, viewdata = product_id})
end

function AppStorePurchase:OnReceiveCanPurchase(product_id)
	if product_id == self.purchaseProductID then
		FuncZenyShop.Instance():TryPurchaseProduct(product_id)
		self.purchaseProductID = nil
	end
end

function AppStorePurchase:GetPanelConfigFromProductID(product_id)
	for k, v in pairs(Table_Deposit) do
		if v.ProductID == product_id then
			if v.Type == 1 then
				return PanelConfig.ZenyShop
			elseif v.Type == 2 or v.Type == 5 then
				return PanelConfig.ZenyShopMonthlyVIP
			elseif v.Type == 3 or v.Type == 4 then
				return PanelConfig.ZenyShopGachaCoin
			end
		end
	end
	return nil
end

function AppStorePurchase:ShowCardByProductID(product_id)
	local showCardIndex = nil
	local monthlyVIPController = FuncZenyShop.Instance():GetMonthlyVIPController()
	if monthlyVIPController.monthlyVIPShopItemConf == product_id then
		showCardIndex = 0
	else
		local epVIPCards = monthlyVIPController.epVIPCards
		for i = 1, #epVIPCards do
			local epVIPCard = epVIPCards[i]
			local productConfID = epVIPCard.id2
			if(productConfID == nil or productConfID == 0)then
				productConfID = epVIPCard.id1
			end
			local productID = Table_Deposit[productConfID].ProductID
			if productID == product_id then
				showCardIndex = i
				break
			end
		end
	end
	monthlyVIPController.showCardIndex = showCardIndex
	monthlyVIPController:ShowCard(monthlyVIPController.showCardIndex)
end

function AppStorePurchase:ClearCallbackAppStorePurchase()
	FunctionXDSDK.Ins:SetCallbackAppStorePurchase(nil)
end

-- test