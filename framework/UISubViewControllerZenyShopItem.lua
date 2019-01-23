autoImport('UIModelZenyShop')
autoImport('UIListItemControllerItemSale')
autoImport('HappyShopBuyItemCell')

UISubViewControllerZenyShopItem = class('UISubViewControllerZenyShopItem', SubView)

UISubViewControllerZenyShopItem.instance = nil

function UISubViewControllerZenyShopItem:Init()
	
end

function UISubViewControllerZenyShopItem:OnExit()
	UISubViewControllerZenyShopItem.super.OnExit(self)

	UISubViewControllerZenyShopItem.instance = nil
	if self.puchaseDetailCtrl ~= nil then
		self.puchaseDetailCtrl:Exit()
	end
	self:CancelListenServerResponse()
end

function UISubViewControllerZenyShopItem:MyInit()
	UISubViewControllerZenyShopItem.instance = self

	self.gameObject = self:LoadPreferb('view/UISubViewZenyShopItem', nil, true)

	self:GetGameObjects()
	self:SetActivePurchaseDetail(false)
	self:GetModelSet()
	self:LoadView()
	self:ListenServerResponse()

	UIModelZenyShop.Ins():RequestQueryShopItem(UIModelZenyShop.ItemShopType, UIModelZenyShop.ItemShopID)

	HappyShopProxy.Instance:InitShop(nil, UIModelZenyShop.ItemShopID, UIModelZenyShop.ItemShopType)
	self.isInit = true
end

function UISubViewControllerZenyShopItem:ReInit()
	self:SetActivePurchaseDetail(false)
end

function UISubViewControllerZenyShopItem:GetGameObjects()
	self.goItemsList = self:FindGO('ItemsList')
	self.uiGridItem = self:FindGO('ItemsRoot', self.goItemsList):GetComponent(UIGrid)
	self.widgetTipRelative = self:FindGO('TipRelative'):GetComponent(UIWidget)
	self.goPurchaseDetail = self:LoadPreferb('cell/HappyShopBuyItemCell', self.gameObject, true)
end

function UISubViewControllerZenyShopItem:GetModelSet()
	self.shopItemDatas = UIModelZenyShop.Ins():GetItemShopConf()
	if self.arrShopItemData == nil then
		self.arrShopItemData = {}
	end
	TableUtility.ArrayClear(self.arrShopItemData)
	for k, v in pairs(self.shopItemDatas) do
		table.insert(self.arrShopItemData, v)
	end
	table.sort(self.arrShopItemData, function (x, y)
		return x.ShopOrder < y.ShopOrder
	end)
end

function UISubViewControllerZenyShopItem:LoadView()
	if self.itemListCtrl == nil then
		self.itemListCtrl = UIGridListCtrl.new(self.uiGridItem, UIListItemControllerItemSale, 'UIListItemItemSale')
	end
	self.itemListCtrl:ResetDatas(self.arrShopItemData)
end

function UISubViewControllerZenyShopItem:LoadPurchaseDetailView(shop_item_data)
	self:SetActivePurchaseDetail(true)
	if self.puchaseDetailCtrl == nil then
		self.puchaseDetailCtrl = HappyShopBuyItemCell.new(self.goPurchaseDetail)
	end
	self.puchaseDetailCtrl:SetData(shop_item_data)
end

function UISubViewControllerZenyShopItem:ListenServerResponse()
	EventManager.Me():AddEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
	EventManager.Me():AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.OnReceiveItemGetCount, self)
	EventManager.Me():AddEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
end

function UISubViewControllerZenyShopItem:CancelListenServerResponse()
	EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
	EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.OnReceiveItemGetCount, self)
	EventManager.Me():RemoveEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
end

function UISubViewControllerZenyShopItem:OnReceiveQueryShopConfigCmd(message)
	self:GetModelSet()
	self:LoadView()
end

function UISubViewControllerZenyShopItem:OnReceiveItemGetCount(data)
	if data then
		if self.puchaseDetailCtrl ~= nil then
			self.puchaseDetailCtrl:SetItemGetCount(data)
		end
	end
end


function UISubViewControllerZenyShopItem:OnReceiveUpdateShopGotItem(data)
	self:GetModelSet()
	self:LoadView()
end

function UISubViewControllerZenyShopItem:SetActivePurchaseDetail(b)
	self.goPurchaseDetail:SetActive(b)
end