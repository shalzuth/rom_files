autoImport('UIListItemViewControllerZenyShopItem')

UISubViewControllerZenyList = class('UISubViewControllerZenyList', SubView)

local reusableArray = {}

function UISubViewControllerZenyList:Init()
	
end

function UISubViewControllerZenyList:OnExit()
	self:CancelListenServerResponse()
	if self.itemsController ~= nil then
		for i = 1, #self.itemsController do
			self.itemsController[i]:OnExit()
		end
	end
end

function UISubViewControllerZenyList:MyInit()
	self.gameObject = self:LoadPreferb('view/UISubViewZenyList', nil, true)
	self.gameObject.transform.localPosition = LuaVector3.New(-400, -74, 0)
	self:GetGameObjects()
	self:LoadView()
	self:RequestQueryChargeVirgin()
	self.isInit = true
end

function UISubViewControllerZenyList:GetGameObjects()
	self.goItemsList = self:FindGO('ShopItemsList', self.gameObject)
	self.goItemsRoot = self:FindGO('ItemsRoot', self.goItemsList)
end

function UISubViewControllerZenyList:LoadView()
	helplog("UISubViewControllerZenyList:LoadView")
	self.uiGridOfItems = self.goItemsRoot:GetComponent(UIGrid)
	if self.listControllerOfItems == nil then
		self.listControllerOfItems = UIGridListCtrl.new(self.uiGridOfItems, UIListItemViewControllerZenyShopItem, 'UIListItemZenyShopItem')
	end
	TableUtility.ArrayClear(reusableArray)
	for k, v in pairs(Table_Deposit) do
		if v.Type == 1 and v.Switch == 1 and v.ActivityDiscount ~= 1 then
			table.insert(reusableArray, k)
		end
	end

	--todo xde sort 
	table.sort(reusableArray, function (x, y)
		if(x~=nil and y ~=nil) then
			return x < y
		end
		return false
	end)

	self.listControllerOfItems:ResetDatas(reusableArray)
	self.itemsController = self.listControllerOfItems:GetCells()
end

function UISubViewControllerZenyList:ListenServerResponse()
	EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
end

function UISubViewControllerZenyList:CancelListenServerResponse()
	EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
end

function UISubViewControllerZenyList:RequestQueryChargeVirgin()
	ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
end

function UISubViewControllerZenyList:OnReceivePurchaseSuccess(message)
	local messageContent = message
	local confID = messageContent.dataid
	if confID and confID > 0 then
		if conf.Type == 1 then
			if self.itemsController then
				for _, v in pairs(self.itemsController) do
					local itemController = v
					if itemController.productID == confID or itemController.activityProductID == confID then
						if itemController.isActivity then
							itemController:OpenPurchaseSwitch()
							itemController.timerForPurchaseSwitch:StopTick()
						end
						-- LeanTween.delayedCall(0.7, function ()
						-- 	itemController:PlayZenyIconAnimation()
						-- end)
						self:CachePurchasedItem(confID)
						break
					end
				end
			end
		end
	end
end

function UISubViewControllerZenyList:CachePurchasedItem(shopItem)
	if self.purchasedItems == nil then
		self.purchasedItems = {}
	end
	table.insert(self.purchasedItems, shopItem)
end

function UISubViewControllerZenyList:GetCachedPurchaseItem()
	return self.purchasedItems
end