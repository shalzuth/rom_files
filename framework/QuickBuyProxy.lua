autoImport("QuickBuyItemData")

QuickBuyProxy = class('QuickBuyProxy', pm.Proxy)
QuickBuyProxy.Instance = nil
QuickBuyProxy.NAME = "QuickBuyProxy"

QuickBuyReason = {
	NotExist = 1,
	Publicity = 2,
	NotEnough = 3,
	PriceHigher = 4,
	PriceLower = 5,
}

QuickBuyOrigin = {
	Exchange = 1,
	Shop = 2,
}

QuickBuyMoney = {
	Zeny = 100,
	Happy = 110,
	Lottery = 151,
}

local CreateArray = ReusableTable.CreateArray
local CreateTable = ReusableTable.CreateTable
local DestroyAndClearArray = ReusableTable.DestroyAndClearArray
local DestroyAndClearTable = ReusableTable.DestroyAndClearTable
local itemInfo = {}
local costlist = {}

function QuickBuyProxy:ctor(proxyName, data)
	self.proxyName = proxyName or QuickBuyProxy.NAME
	if QuickBuyProxy.Instance == nil then
		QuickBuyProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function QuickBuyProxy:Init()
	self.itemList = {}
	self.compareEquipList = {}
	self.buyItemList = {}
end

function QuickBuyProxy:TryOpenView(list)
	self:SetItemList(list)
	if #self.itemList > 0 then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.QuickBuyView})
		return true
	end

	return false
end

--id, count
function QuickBuyProxy:SetItemList(list)
	TableUtility.ArrayClear(self.itemList)
	for i=1,#list do
		local data = list[i]
		if ItemData.CheckIsEquip(data.id) then
			for j=1,data.count do
				local buyItemData = QuickBuyItemData.new(data)
				buyItemData:SetNeedCount(1)
				TableUtility.ArrayPushBack(self.itemList, buyItemData)				
			end
		else
			local buyItemData = QuickBuyItemData.new(data)
			TableUtility.ArrayPushBack(self.itemList, buyItemData)
		end
	end
end

--请求交易所
function QuickBuyProxy:CallItemInfo()
	local _CheckItemCanTrade = ItemData.CheckItemCanTrade
	local list = CreateArray()
	for i=1,#self.itemList do
		local item = self.itemList[i]
		if _CheckItemCanTrade(item.id) then
			local itemCount = self:TryGetItemCount(list, item.id)
			if itemCount == nil then
				local data = RecordTrade_pb.ItemCount()
				data.itemid = item.id
				data.count = item.needCount
				TableUtility.ArrayPushBack(list, data)
			else
				itemCount.count = itemCount.count + item.needCount
			end
		end
	end

	ServiceRecordTradeProxy.Instance:CallQueryItemCountTradeCmd(Game.Myself.data.id, list)

	DestroyAndClearArray(list)
end

--请求商店
function QuickBuyProxy:CallShopInfo()
	local list = CreateArray()
	for i=1,#self.itemList do
		local data = self.itemList[i]
		if data.origin == nil then
			TableUtility.ArrayPushBack(list, data.id)
		end
	end

	if #list > 0 then
		ServiceSessionShopProxy.Instance:CallQueryQuickBuyConfigCmd(list)
	else
		self:TryCompareEquipPrice()
	end
	DestroyAndClearArray(list)
end

function QuickBuyProxy:TryCompareEquipPrice()
	TableUtility.ArrayClear(self.compareEquipList)
	for i=1,#self.itemList do
		local data = self.itemList[i]
		local equip = data:GetCompareEquipPrice()
		if equip ~= nil and not self:CheckExist(self.compareEquipList, data.id) then
			TableUtility.ArrayPushBack(self.compareEquipList, equip)
		end
	end

	self.callCompareEquipPriceIndex = 1
	self:CallCompareEquipPrice()	
end

--对比身上的装备价格
function QuickBuyProxy:CallCompareEquipPrice()
	if self.callCompareEquipPriceIndex ~= nil then
		if #self.compareEquipList >= self.callCompareEquipPriceIndex then
			FunctionItemTrade.Me():GetTradePrice(self.compareEquipList[self.callCompareEquipPriceIndex], true)
		else
			self.callCompareEquipPriceIndex = nil
			self:sendNotification(QuickBuyEvent.Refresh)
		end
	end
end

function QuickBuyProxy:CallBuyItem()
	if self.callBuyItemIndex ~= nil then
		if #self.buyItemList >= self.callBuyItemIndex then
			local data = self.buyItemList[self.callBuyItemIndex]
			if data.origin == QuickBuyOrigin.Exchange then
				TableUtility.TableClear(itemInfo)
				itemInfo.itemid = data.id
				itemInfo.price = data.price
				itemInfo.count = data.needCount
				itemInfo.publicity_id = data.publicityId
				itemInfo.order_id = data.orderId

				ShopMallProxy.Instance:CallBuyItemRecordTradeCmd(itemInfo)
			elseif data.origin == QuickBuyOrigin.Shop then
				HappyShopProxy.Instance:BuyItemByShopItemData(data.shopItemData, data:GetShopBuyCount())
			end
		else
			self.callBuyItemIndex = nil

			--飘字
			for i=1,3 do
				costlist[i] = 0
			end
			local failCount = 0
			for i=1,#self.buyItemList do
				local data = self.buyItemList[i]
				if data:IsBuySuccess() then
					if data.moneyType == QuickBuyMoney.Zeny then
						costlist[1] = costlist[1] + data:GetTotalCost()
					elseif data.moneyType == QuickBuyMoney.Happy then
						costlist[2] = costlist[2] + data:GetTotalCost()
					elseif data.moneyType == QuickBuyMoney.Lottery then
						costlist[3] = costlist[3] + data:GetTotalCost()
					end
				else
					failCount = failCount + 1
				end
			end
			MsgManager.ShowMsgByIDTable(2967, costlist)
			if failCount > 0 then
				MsgManager.ShowMsgByID(2968, failCount)
			end

			--剔除掉商店购买的商品
			for i = #self.buyItemList, 1, -1  do
				if self.buyItemList[i].origin == QuickBuyOrigin.Shop then
					table.remove(self.buyItemList, i)
				end
			end
			--请求日志
			if #self.buyItemList > 0 then
				self.callRecordIndex = 0
				self:CallRecord()
			else
				self:EndRecord()
			end
		end
	end
end

function QuickBuyProxy:CallRecord()
	if self.callRecordIndex ~= nil then
		ServiceRecordTradeProxy.Instance:CallMyTradeLogRecordTradeCmd(Game.Myself.data.id, self.callRecordIndex)
	end
end

function QuickBuyProxy:RecvQueryItemCountTradeCmd(serviceData)
	if #serviceData.res_items > 0 then
		local map = CreateTable()
		for i=1,#self.itemList do
			local data = self.itemList[i]
			if map[data.id] == nil then
				map[data.id] = CreateArray()
			end
			TableUtility.ArrayPushBack(map[data.id], data)
		end

		for i=1,#serviceData.res_items do
			local data = serviceData.res_items[i]
			if map[data.itemid] ~= nil then
				local length = #map[data.itemid]
				if length > data.count then
					length = data.count
				end
				for j=length, 1, -1 do
					local item = map[data.itemid][j]
					if item ~= nil then
						item:SetExchangeInfo(data)
						item:SetReason()
						table.remove(map[data.itemid], j)
					end
				end
			end
		end

		for k,v in pairs(map) do
			DestroyAndClearArray(v)
		end
		DestroyAndClearTable(map)
	end

	self:CallShopInfo()
end

function QuickBuyProxy:RecvQueryQuickBuyConfigCmd(serviceData)
	local goodsMap = CreateTable()
	for i=1,#serviceData.goods do
		local goods = serviceData.goods[i]
		goodsMap[goods.itemid] = goods
	end

	for i=1,#self.itemList do
		local data = self.itemList[i]
		if data.origin == nil then
			local goods = goodsMap[data.id]
			if goods ~= nil and goods.limittype == 0 and goods.moneyid2 == 0 then
				data:SetShopInfo(goods)
			end
			data:SetReason()
		end
	end

	DestroyAndClearTable(goodsMap)

	--对比身上已装备的装备价格
	self:TryCompareEquipPrice()
end

function QuickBuyProxy:RecvCompareEquipPrice(serviceData)
	if self.callCompareEquipPriceIndex ~= nil and #self.compareEquipList >= self.callCompareEquipPriceIndex then
		local id = self.compareEquipList[self.callCompareEquipPriceIndex].staticData.id

		if serviceData.itemData.base.id == id then
			for i=1,#self.itemList do
				local data = self.itemList[i]
				if data.id == id then
					data:SetCompareEquipPrice(serviceData.price)
				end
			end
		end

		self.callCompareEquipPriceIndex = self.callCompareEquipPriceIndex + 1
		self:CallCompareEquipPrice()
	end
end

--交易所购买
function QuickBuyProxy:RecvBuyItem(serviceData)
	if self.callBuyItemIndex ~= nil and #self.buyItemList >= self.callBuyItemIndex then
		local buyItemData = self.buyItemList[self.callBuyItemIndex]

		if serviceData.item_info.itemid == buyItemData.id then
			buyItemData:SetBuyResult(serviceData.ret == ProtoCommon_pb.ETRADE_RET_CODE_SUCCESS)
		end

		--下一个item
		self.callBuyItemIndex = self.callBuyItemIndex + 1
		self:CallBuyItem()
	end
end

--商店购买
function QuickBuyProxy:RecvBuyShopItem(serviceData)
	if self.callBuyItemIndex ~= nil and #self.buyItemList >= self.callBuyItemIndex then
		local buyItemData = self.buyItemList[self.callBuyItemIndex]

		if buyItemData.shopItemData ~= nil and serviceData.id == buyItemData.shopItemData.id then
			buyItemData:SetShopBuyCount(serviceData.count)

			local leftCount = buyItemData:GetShopBuyCount()
			if leftCount == 0 then
				buyItemData:SetBuyResult(serviceData.success)

				--下一个item
				self.callBuyItemIndex = self.callBuyItemIndex + 1
			end
		end

		self:CallBuyItem()
	end	
end

function QuickBuyProxy:RecvRecord(serviceData)
	if self.callRecordIndex ~= nil then
		for i=1,#serviceData.log_list do
			if #self.buyItemList == 0 then
				break
			end

			local data = serviceData.log_list[i]
			if data.status == ShopMallLogReceiveEnum.ReceiveGive and data.logtype == ShopMallLogTypeEnum.NormalBuy then
				for j=1,#self.buyItemList do
					local buyItemData = self.buyItemList[j]
					if data.itemid == buyItemData.id then
						ServiceRecordTradeProxy.Instance:CallTakeLogCmd(data)
						table.remove(self.buyItemList, j)
						break
					end
				end
			end
		end

		if #self.buyItemList > 0 then
			self.callRecordIndex = self.callRecordIndex + 1
			self:CallRecord()
		else
			self:EndRecord()
		end
	end
end

function QuickBuyProxy:StartBuyItem()
	TableUtility.ArrayClear(self.buyItemList)

	for i=1,#self.itemList do
		local data = self.itemList[i]
		if data.isChoose then
			TableUtility.ArrayPushBack(self.buyItemList, data)
		end
	end

	self.callBuyItemIndex = 1
	self:CallBuyItem()
end

function QuickBuyProxy:EndRecord()
	self.callRecordIndex = nil
	self:sendNotification(QuickBuyEvent.Close)
end

function QuickBuyProxy:Clear()
	self.callItemInfoIndex = nil
	self.callBuyItemIndex = nil
	self.callRecordIndex = nil
end

function QuickBuyProxy:TryGetItemCount(list, itemid)
	for i=1,#list do
		if list[i].itemid == itemid then
			return list[i]
		end
	end
end

function QuickBuyProxy:CheckExist(list, itemid)
	for i=1,#list do
		if list[i].staticData.id == itemid then
			return true
		end
	end

	return false
end

function QuickBuyProxy:GetItemList()
	return self.itemList
end

function QuickBuyProxy:GetTotalCost()
	local zenyCost = 0
	local happyCost = 0
	local lotteryCost = 0
	for i=1,#self.itemList do
		local data = self.itemList[i]
		if data.isChoose then
			if data.moneyType == QuickBuyMoney.Zeny then
				zenyCost = zenyCost + data:GetTotalCost()
			elseif data.moneyType == QuickBuyMoney.Happy then
				happyCost = happyCost + data:GetTotalCost()
			elseif data.moneyType == QuickBuyMoney.Lottery then
				lotteryCost = lotteryCost + data:GetTotalCost()
			end
		end
	end
	return zenyCost, happyCost, lotteryCost
end