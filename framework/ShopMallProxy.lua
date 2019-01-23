autoImport("ExchangeTypesData")
autoImport("ExchangeClassifyData")
autoImport("ExchangeLogData")
autoImport("ShopMallItemData")
autoImport("ExchangeExpressData")
autoImport("FinanceData")

ShopMallProxy = class('ShopMallProxy', pm.Proxy)
ShopMallProxy.Instance = nil;
ShopMallProxy.NAME = "ShopMallProxy"

ShopMallFilterEnum = {
	Level = "Level", 
	Fashion = "Fashion",
	Trade = "Trade",
	Record = "Record",
}

ShopMallExchangeEnum = {
	Buy = "Buy",
	Sell = "Sell",
	Record = "Record",
}

ShopMallExchangeSellEnum = {
	Sell = "Sell", 
	Cancel = "Cancel",
	Resell = "Resell"
}

ShopMallStateTypeEnum = {
	OverlapNormal = RecordTrade_pb.St_OverlapNormal,
	NonoverlapNormal = RecordTrade_pb.St_NonoverlapNormal,
	WillPublicity = RecordTrade_pb.St_WillPublicity,
	InPublicity = RecordTrade_pb.St_InPublicity,
}

ShopMallLogTypeEnum = {
	NormalSell = RecordTrade_pb.EOperType_NormalSell,	--普通出售
	NormalBuy = RecordTrade_pb.EOperType_NoramlBuy,		--普通购买
	Publicity = RecordTrade_pb.EOperType_Publicity,		--公示期
	PublicitySellSuccess = RecordTrade_pb.EOperType_PublicitySellSuccess,	--公示期出售成功
	PublicitySellFail = RecordTrade_pb.EOperType_PublicitySellFail,			--公示期出售失败
	PublicityBuySuccess = RecordTrade_pb.EOperType_PublicityBuySuccess,		--公示期购买成功
	PublicityBuyFail = RecordTrade_pb.EOperType_PublicityBuyFail,			--公示期购买失败
	PublicityBuying = RecordTrade_pb.EOperType_PublicityBuying,				--公示期正在购买
	AutoOff = RecordTrade_pb.EOperType_AutoOffTheShelf,						--自动下架
}

ShopMallLogReceiveEnum = {
	ReceiveGive = RecordTrade_pb.ETakeStatus_CanTakeGive,	--可领取可赠送
	Receive = RecordTrade_pb.ETakeStatus_Took,		--已领取
	Receiving = RecordTrade_pb.ETakeStatus_Taking,		--已领取
	Giving = RecordTrade_pb.ETakeStatus_Giving,	--正在赠送
	GiveAccepting = RecordTrade_pb.ETakeStatus_Give_Accepting,		--正在赠送
	Gived1 = RecordTrade_pb.ETakeStatus_Give_Accepted_1,	--已赠送
	Gived2 = RecordTrade_pb.ETakeStatus_Give_Accepted_2,	--已赠送
}

FinanceRankTypeEnum = {
	DealCount = RecordTrade_pb.EFINANCE_RANK_DEALCOUNT,		--交易量
	UpRatio = RecordTrade_pb.EFINANCE_RANK_UPRATIO,		--涨幅
	DownRatio = RecordTrade_pb.EFINANCE_RANK_DOWNRATIO,		--跌幅
}

FinanceDateTypeEnum = {
	Three = RecordTrade_pb.EFINANCE_DATE_THREE,
	Seven = RecordTrade_pb.EFINANCE_DATE_SEVEN,
}

function ShopMallProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ShopMallProxy.NAME
	if(ShopMallProxy.Instance == nil) then
		ShopMallProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function ShopMallProxy:Init()
	self.exchangeBuyClassify = {}
	self.exchangeBuyDetail = {}
	self.exchangePendingList = {}
	-- self.exchangeOtherSellingList = {}
	self.exchangeRecordList = {}
	self.exchangeRecordFilterList = {}
	self.exchangeRecordDetailList = {}
	self.exchangeRecordReceive = {}

	self.financeMap = {}
end

-- 交易所购买界面左侧购买类别，包括大类别和小类别
function ShopMallProxy:InitExchangeBuyTypes()

	local parentTypes = {}
	for k,v in pairs(Table_ItemTypeAdventureLog) do
		if v.ExchangeOrder then
			table.insert(parentTypes , v)
		end
	end
	table.sort(parentTypes ,function(l,r)
		return l.ExchangeOrder < r.ExchangeOrder
	end)

	self.exchangeBuyParentTypes = {}	--存储Table_ItemTypeAdventureLog中的data
	for i=1,#parentTypes do
		local typesData = ExchangeTypesData.new(parentTypes[i])
		table.insert(self.exchangeBuyParentTypes , typesData)
	end

	self.exchangeBuyChildTypes = {}	--self.exchangeBuyChildTypes[父类别id] = {子类别data}，存储Table_ItemTypeAdventureLog中的data
	for i=1,#self.exchangeBuyParentTypes do
		local parent = self.exchangeBuyParentTypes[i].id

		for k,v in pairs(Table_ItemTypeAdventureLog) do
			if v.ExchangeType and v.ExchangeType == parent then

				if self.exchangeBuyChildTypes[parent] == nil then
					self.exchangeBuyChildTypes[parent] = {}
				end
				local typesData = ExchangeTypesData.new(v)
				table.insert(self.exchangeBuyChildTypes[parent] , typesData)
			end
		end

		if self.exchangeBuyChildTypes[parent] ~= nil then
			table.sort(self.exchangeBuyChildTypes[parent] ,function(l,r)
				return l.id < r.id
			end)
		end
	end
end

-- 交易所购买界面右侧商品分类
function ShopMallProxy:InitExchangeBuyClassify()
	self.exchangeBuyClassify = {}	--self.exchangeBuyClassify[大类别id／子类别id] = {实际item id}，存储Table_ItemType中的id

	for k,v in pairs(Table_Exchange) do
		if v.Category then
			if self.exchangeBuyClassify[v.Category] == nil then
				self.exchangeBuyClassify[v.Category] = {}
			end

			table.insert(self.exchangeBuyClassify[v.Category] , v.id)
		end
	end

	for k,v in pairs(self.exchangeBuyClassify) do
		table.sort(self.exchangeBuyClassify[k] ,function(l,r)
			return l < r
		end)		
	end
	-- printOrange("InitExchangeBuyClassify")
	-- TableUtil.Print(self.exchangeBuyClassify)
end

-- 交易所购买界面右侧商品本职业分类
-- function ShopMallProxy:InitExchangeBuySelfProfessionClassify()
-- 	local selfProfessionClassify = {}

-- 	for k,v in pairs(self.exchangeBuyClassify) do
-- 		for i=1,#v do
-- 			if self:JudgeSelfProfession(v[i]) then
-- 				table.insert( self.selfProfessionClassify , v[i] )
-- 			end
-- 		end
-- 	end

-- 	for k,v in pairs(self.selfProfessionClassify) do
-- 		table.sort(self.selfProfessionClassify[k] ,function(l,r)
-- 			return l < r
-- 		end)		
-- 	end
-- end

function ShopMallProxy:InitExchangeSearchHistory()
	
	self.exchangeSearchHistory = {}

	local temp = LocalSaveProxy.Instance:GetExchangeSearchHistory()
	for i=1,#temp do
		if Table_Item[temp[i]] then
			table.insert(self.exchangeSearchHistory , temp[i])
		end
	end
end

function ShopMallProxy:AddExchangeSearchHistory(itemId)
	
end

function ShopMallProxy:ResetExchangeBuyClassify()
	self.exchangeBuyClassify = {}
end

function ShopMallProxy:ResetExchangeBuyDetail()
	self.exchangeBuyDetail = {}
end

-- function ShopMallProxy:ResetExchangeItemSellInfo()
-- 	self.exchangeOtherSellingList = {}
-- end

function ShopMallProxy:CallBuyItemRecordTradeCmd(itemInfo, callback)
	FunctionSecurity.Me():Exchange_SellOrBuyItem(function (arg)
		ServiceRecordTradeProxy.Instance:CallBuyItemRecordTradeCmd(arg, Game.Myself.data.id, nil, arg.type)
		if callback ~= nil then
			callback()
		end
	end, itemInfo)
end

function ShopMallProxy:RecvExchangeBuyDetail(data)
	-- printOrange("RecvExchangeBuyDetail ~~~~~~~~~~")
	-- TableUtil.Print(data)

	self.exchangeBuyDetail = {}
	self.exchangeBuyDetailTotalPageCount = data.total_page_count
	if data.search_cond and data.search_cond.page_index then
		self.exchangeBuyDetailCurrentPageIndex = data.search_cond.page_index
	else
		errorLog(string.format("ShopMallProxy RecvExchangeBuyDetail : data.search_cond = %s",tostring(data.search_cond)))
	end

	for i=1,#data.lists do
		local itemData = ShopMallItemData.new(data.lists[i])
		table.insert( self.exchangeBuyDetail , itemData )
	end
end

function ShopMallProxy:RecvExchangePendingList(data)
	-- printOrange("RecvExchangePendingList ~~~~~~~~~~")
	-- TableUtil.Print(data)

	self.exchangePendingList = {}
	for i=1,#data.lists do
		local itemData = ShopMallItemData.new(data.lists[i])
		table.insert( self.exchangePendingList , itemData )
	end
end

-- function ShopMallProxy:RecvExchangeItemSellInfo(data)
-- 	-- printOrange("RecvExchangeItemSellInfo ~~~~~~~~~~")
-- 	-- TableUtil.Print(data)

-- 	self.exchangeOtherSellingList = {}
-- 	for i=1,#data.lists do
-- 		local itemData = ShopMallItemData.new(data.lists[i])
-- 		table.insert( self.exchangeOtherSellingList , itemData )		
-- 	end
-- end

function ShopMallProxy:RecvExchangeRecord(data)
	TableUtility.ArrayClear(self.exchangeRecordList)

	for i=1,#data.log_list do
		local logData = data.log_list[i]
		if logData.itemid ~= 0 then--and not self:IsExpirePublicityBuyingLog(logData) then
			local itemData = ExchangeLogData.new(logData)
			table.insert( self.exchangeRecordList , itemData )

			if itemData.type ~= ShopMallLogTypeEnum.PublicityBuying and itemData.status == ShopMallLogReceiveEnum.ReceiveGive then
				if not self:IsExistLog(self.exchangeRecordReceive , itemData.id , itemData.type) then
					TableUtility.ArrayPushBack(self.exchangeRecordReceive , itemData)

					self:AddExchangeRecordRedTip()
				end
			end
		end
	end

	table.sort(self.exchangeRecordList ,function(l,r)
		return l.tradetime > r.tradetime
	end)
end

function ShopMallProxy:RecvExchangeBuySellingClassify(data)
	TableUtility.ArrayClear(self.exchangeBuyClassify)

	if data.lists then
		for i=1,#data.pub_lists do
			local classifyData = ExchangeClassifyData.new()
			classifyData:SetId(data.pub_lists[i])
			classifyData:SetIsPublicity(true)
			TableUtility.ArrayPushBack(self.exchangeBuyClassify , classifyData)
		end
		for i=1,#data.lists do
			local classifyData = ExchangeClassifyData.new()
			classifyData:SetId(data.lists[i])
			classifyData:SetIsPublicity(false)
			TableUtility.ArrayPushBack(self.exchangeBuyClassify , classifyData)
		end
	end
end

function ShopMallProxy:RecvTakeLog(data)
	if data.success then
		if data.log then
			local id = data.log.id
			local type = data.log.logtype
			if id and type then
				for i=1,#self.exchangeRecordList do
					if self.exchangeRecordList[i].id == id and self.exchangeRecordList[i].type == type then
						self.exchangeRecordList[i]:SetStatus( ShopMallLogReceiveEnum.Receive )

						for j = #self.exchangeRecordReceive,1,-1 do
							local receiveData = self.exchangeRecordReceive[j]
							if receiveData.id == id and receiveData.type == type then
								table.remove(self.exchangeRecordReceive, j)

								self:RemoveExchangeRecordRedTip()
								break
							end
						end

						break
					end
				end
			end
		end
	end
end

function ShopMallProxy:RecvAddNewLog(data)
	if data.log and data.log.id then
		if not self:IsExistLog(self.exchangeRecordList, data.log.id, data.log.type) then
			local itemData = ExchangeLogData.new(data.log)
			TableUtility.ArrayPushFront(self.exchangeRecordList , itemData)
		end
	end

	local count = #self.exchangeRecordList
	if count > GameConfig.Exchange.PageNumber then
		table.remove(self.exchangeRecordList, count)
	end

	--过滤已过期的抢购中信息
	-- for i = #self.exchangeRecordList,1,-1 do
	-- 	if self:IsExpirePublicityBuyingLog(logData) then
	-- 		table.remove(self.exchangeRecordList, i)
	-- 	end
	-- end
end

function ShopMallProxy:RecvExchangeRecordDetail(data)
	if data and data.name_list and data.name_list.name_infos then
		self:ResetExchangeRecordDetailList()

		for i=1,#data.name_list.name_infos do
			local nameData = ExchangeLogNameData.new(data.name_list.name_infos[i])
			TableUtility.ArrayPushBack(self.exchangeRecordDetailList , nameData)
		end
	end
end

function ShopMallProxy:RecvCanTakeCount(data)
	if data and data.count then
		self.exchangeRecordReceiveCount = data.count

		if data.count < 1 then
			RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TRADE_RECORD)
		end
	end
end

function ShopMallProxy:JudgeSelfProfession(itemId)
	local equipData = Table_Equip[itemId]
	if equipData then
	 	if #equipData.CanEquip == 1 and equipData.CanEquip[1] == 0 then
	 	 	return true
	 	end
		for i=1,#equipData.CanEquip do
		 	if equipData.CanEquip[i] == MyselfProxy.Instance:GetMyProfession() then
		 		return true
		 	end
		end
	else
		errorLog(string.format("ShopMallProxy JudgeSelfProfession : Table_Equip[%s] == nil",tostring(itemId)))
	end
 	return false
end

--判断是否为强化、插卡、精炼过的装备（用于交易所出售、商店出售和扭蛋机装备回收）
function ShopMallProxy:JudgeSpecialEquip(data)
	if data then
		if data.equipInfo then
			if data.equipInfo.strengthlv>0 then
				return true
			end
			if data.equipInfo.refinelv>0 then
				return true
			end
			
			local cardSlotNum = data.cardSlotNum
			local equipedCardInfo = data.equipedCardInfo
			if cardSlotNum and cardSlotNum>0 and equipedCardInfo and #equipedCardInfo>0 then
				return true
			end
		end
	end

	return false	
end

function ShopMallProxy:IsExistLog(list,logId,type)
	for i=1,#list do
		local data = list[i]
		if data.id == logId and data.type == type then
			return true
		end
	end
	return false
end

-- function ShopMallProxy:IsExpirePublicityBuyingLog(data)
-- 	if data and data.endtime and data.endtime ~= 0 then
-- 		if data.endtime < ServerTime.CurServerTime()/1000 then
-- 			return true
-- 		end
-- 	end

-- 	return false
-- end

function ShopMallProxy:GetExchangeBuyParentTypes()
	if self.exchangeBuyParentTypes == nil then
		self:InitExchangeBuyTypes()
	end

	return self.exchangeBuyParentTypes
end

function ShopMallProxy:GetExchangeBuyChildTypes(parentId)
	if self.exchangeBuyChildTypes == nil then
		self:InitExchangeBuyTypes()
	end

	return self.exchangeBuyChildTypes[parentId]
end

function ShopMallProxy:GetExchangeBuyClassify(typeId)
	if self.exchangeBuyClassify == nil then
		self:InitExchangeBuyClassify()
	end

	return self.exchangeBuyClassify[typeId]
end

function ShopMallProxy:GetExchangeBuySelfProfessionClassify(typeId)

	if self.exchangeBuySelfProfessionClassify == nil then
		self.exchangeBuySelfProfessionClassify = {}
	end

	if self.exchangeBuyClassify == nil then
		self:InitExchangeBuyClassify()
	end

	if self.exchangeBuySelfProfessionClassify[typeId] == nil then
		self.exchangeBuySelfProfessionClassify[typeId] = {}
		
		if self.exchangeBuyClassify[typeId] == nil then
			return
		end

		for i=1,#self.exchangeBuyClassify[typeId] do
			local data = self.exchangeBuyClassify[typeId][i]
			if self:JudgeSelfProfession(data) then
				table.insert( self.exchangeBuySelfProfessionClassify[typeId] , data )
			end
		end

		table.sort(self.exchangeBuySelfProfessionClassify[typeId] ,function(l,r)
			return l < r
		end)		

		-- printOrange("GetExchangeBuySelfProfessionClassify : "..typeId)
		-- TableUtil.Print(self.exchangeBuySelfProfessionClassify[typeId])
	end

	return self.exchangeBuySelfProfessionClassify[typeId]
end

-- function ShopMallProxy:GetExchangeBuyLevelFilterClassify(data,rangeIndex)

-- 	if data == nil or rangeIndex == nil then
-- 		return data
-- 	end

-- 	local result = {}

-- 	for i=1,#data do
-- 		local itemData = Table_Item[data[i]]
-- 		local rangeData = GameConfig.Exchange.ExchangeLevel[rangeIndex]
-- 		if itemData then
-- 			if itemData.Level then
-- 				if itemData.Level >= rangeData.minlv and itemData.Level <= rangeData.maxlv then
-- 					table.insert(result , data[i])
-- 				end
-- 			else
-- 				printOrange(string.format("ShopMallProxy GetExchangeBuyLevelFilterClassify : Table_Item[%s].Level == nil",tostring(data[i])))
-- 			end
-- 		else
-- 			errorLog(string.format("ShopMallProxy GetExchangeBuyLevelFilterClassify : Table_Item[%s] == nil",tostring(data[i])))
-- 		end
-- 	end

-- 	table.sort(result ,function(l,r)
-- 		return l < r
-- 	end)	

-- 	return result
-- end

-- function ShopMallProxy:GetExchangeBuyFashionFilterClassify(data,rangeIndex)
-- 	if rangeIndex == nil or rangeIndex == 0 then
-- 		return data
-- 	end

-- 	local result = {}

-- 	for i=1,#data do
-- 		local exchangeData = Table_Exchange[data[i]]
-- 		if exchangeData then
-- 			if exchangeData.FashionType then
-- 				if exchangeData.FashionType == rangeIndex then
-- 					table.insert(result , data[i])
-- 				end
-- 			end
-- 		else
-- 			errorLog(string.format("ShopMallProxy GetExchangeBuyFashionFilterClassify : Table_Exchange[%s] == nil",tostring(data[i])))
-- 		end
-- 	end

-- 	table.sort(result ,function(l,r)
-- 		return l < r
-- 	end)	

-- 	return result
-- end

-- function ShopMallProxy:GetExchangeBuyLevelFilter(data)

-- 	local minLevel = 1
-- 	local maxLevel = 1

-- 	for i=1,#data do
-- 		local itemData = Table_Item[data[i]]
-- 		if itemData then
-- 			if itemData.Level then
-- 				if itemData.Level < minLevel then
-- 					minLevel = itemData.Level
-- 				end
-- 				if itemData.Level > maxLevel then
-- 					maxLevel = itemData.Level
-- 				end
-- 			end
-- 		else
-- 			errorLog(string.format("ShopMallProxy GetExchangeBuyLevelFilter : Table_Item[%s] == nil",tostring(data[i])))
-- 		end
-- 	end
	
-- 	local minRangeIndex = self:GetExchangeBuyLevelFilterRangeIndex(minLevel)
-- 	local maxRangeIndex = self:GetExchangeBuyLevelFilterRangeIndex(maxLevel)
-- 	local rangeList = {}
-- 	for k,v in pairs(GameConfig.Exchange.ExchangeLevel) do
-- 		if k >= minRangeIndex and k <= maxRangeIndex then
-- 			table.insert(rangeList , k)
-- 		end
-- 	end

-- 	table.sort(rangeList ,function(l,r)
-- 		return l < r
-- 	end)

-- 	return rangeList
-- end

local buyFilter = {}
function ShopMallProxy:GetExchangeFilter(filterData)
	TableUtility.ArrayClear(buyFilter)
	for k,v in pairs(filterData) do
		table.insert(buyFilter,k)
	end
	table.sort( buyFilter, function (l,r)
		return l < r
	end )
	return buyFilter
end

function ShopMallProxy:GetExchangeBuyLevelFilterRangeIndex(level)
	for k,v in pairs(GameConfig.Exchange.ExchangeLevel) do
		if level >= v.minlv and level <= v.maxlv then
			return k
		end
	end
end

-- function ShopMallProxy:GetExchangeBuyFashionFilter(data)

-- 	local fashion = {}

-- 	for i=1,#data do
-- 		local exchangeData = Table_Exchange[data[i]]
-- 		if exchangeData then
-- 			if exchangeData.FashionType then
-- 				if fashion[exchangeData.FashionType] == nil then
-- 					fashion[exchangeData.FashionType] = exchangeData.FashionType
-- 				end
-- 			end
-- 		else
-- 			errorLog(string.format("ShopMallProxy GetExchangeBuyFashionFilter : Table_Exchange[%s] == nil",tostring(data[i])))
-- 		end
-- 	end

-- 	local rangeList = {}
-- 	for k,v in pairs(GameConfig.Exchange.ExchangeFashion) do
-- 		if fashion[k] ~= nil then
-- 			table.insert(rangeList , k)
-- 		end
-- 	end

-- 	table.sort(rangeList ,function(l,r)
-- 		return l < r
-- 	end)

-- 	return rangeList
-- end

function ShopMallProxy:GetExchangeBuyDetail()
	return self.exchangeBuyDetail
end

function ShopMallProxy:GetExchangeBuyDetailTotalPageCount()
	return self.exchangeBuyDetailTotalPageCount
end

function ShopMallProxy:GetExchangeBuyDetailCurrentPageIndex()
	return self.exchangeBuyDetailCurrentPageIndex
end

local bagSell = {}
function ShopMallProxy:GetExchangeBagSellByBagType(bagType,array)
	bagType = bagType or BagProxy.BagType.MainBag
	local bagData = BagProxy.Instance.bagMap[bagType]
	if(bagData)then
		local items = bagData:GetItems()
		for i=1,#items do
			local itemData = items[i]
			if itemData and itemData:CanTrade() then
				table.insert(array,itemData)
			end
		end
	end
end

function ShopMallProxy:GetExchangeBagSell()
	TableUtility.ArrayClear(bagSell)

	self:GetExchangeBagSellByBagType(BagProxy.BagType.MainBag,bagSell)
	self:GetExchangeBagSellByBagType(BagProxy.BagType.Barrow,bagSell)
	self:GetExchangeBagSellByBagType(BagProxy.BagType.PersonalStorage,bagSell)

	return bagSell
end

function ShopMallProxy:GetExchangeSelfSelling()
	return self.exchangePendingList
end

-- function ShopMallProxy:GetExchangeOtherSelling()
-- 	return self.exchangeOtherSellingList
-- end

function ShopMallProxy:GetExchangeRecordList()
	return self.exchangeRecordList
end

local searchHistory = {}
function ShopMallProxy:GetExchangeSearchHistory()

	TableUtility.ArrayClear(searchHistory)
	for i=#LocalSaveProxy.Instance:GetExchangeSearchHistory(),1,-1 do
		local history = LocalSaveProxy.Instance:GetExchangeSearchHistory()[i]
		table.insert(searchHistory,history)
	end

	return searchHistory
end

local searchContent = {}
function ShopMallProxy:GetExchangeSearchContent(keyword)

	TableUtility.ArrayClear(searchContent)

	keyword = string.lower(keyword);

	local tempName;
	local _CheckItemCanTrade = ItemData.CheckItemCanTrade
	for k,v in pairs(Table_Exchange) do
		if v.NameZh and _CheckItemCanTrade(v.id) then
			tempName = string.lower(v.NameZh);
			if string.find(tempName , keyword) then
				table.insert(searchContent,v.id)
			end
			-- todo xde 交易所的搜索支持韩文
			if string.find(OverSea.LangManager.Instance():GetLangByKey(v.NameZh) , keyword) then
				table.insert(searchContent,v.id)
			end
		else
			errorLog("ShopMallProxy GetExchangeSearchContent : NameZh = nil")
		end
	end

	return searchContent
end

function ShopMallProxy:GetExchangeBuyClassify()
	return self.exchangeBuyClassify
end

function ShopMallProxy:GetExchangeParentAndChildType(itemId)
	if itemId == nil then
		return nil,nil
	end

	local exchange = Table_Exchange[itemId]
	if exchange and ItemData.CheckItemCanTrade(itemId) then
		local category = exchange.Category
		if category then
			local typesData = Table_ItemTypeAdventureLog[category]
			if typesData.ExchangeType then
				return typesData.ExchangeType,category
			else
				return category,nil
			end
		else
			errorLog(string.format("ShopMallProxy GetExchangeFatherAndChildType : Table_Exchange[%s].Category == nil",tostring(itemId)))
		end
	else
		errorLog(string.format("ShopMallProxy GetExchangeFatherAndChildType : Table_Exchange[%s] == nil",tostring(itemId)))
	end

	return nil,nil
end

function ShopMallProxy:GetExchangeRecordReceiveCount()
	return self.exchangeRecordReceiveCount or 0
end

function ShopMallProxy:SetExchangeRecordDetailType(type)
	self.exchangeRecordDetailType = type
end

function ShopMallProxy:GetExchangeRecordDetailType()
	return self.exchangeRecordDetailType
end

function ShopMallProxy:GetExchangeRecordFilter(filterData)
	--全部
	if filterData == 0 then
		return self.exchangeRecordList

	--出售记录
	elseif filterData == 1 then
		TableUtility.ArrayClear(self.exchangeRecordFilterList)
		for i=1,#self.exchangeRecordList do
			local data = self.exchangeRecordList[i]
			local logType = data.type
			if logType then
				if logType == ShopMallLogTypeEnum.NormalSell 
					or logType == ShopMallLogTypeEnum.PublicitySellSuccess 
					or logType == ShopMallLogTypeEnum.PublicitySellFail then
					TableUtility.ArrayPushBack(self.exchangeRecordFilterList , data)
				end 
			end
		end
	--购买记录
	elseif filterData == 2 then
		TableUtility.ArrayClear(self.exchangeRecordFilterList)
		for i=1,#self.exchangeRecordList do
			local data = self.exchangeRecordList[i]
			local logType = data.type
			if logType then
				if logType == ShopMallLogTypeEnum.NormalBuy then
					TableUtility.ArrayPushBack(self.exchangeRecordFilterList , data)
				end 
			end
		end
	--抢购记录
	elseif filterData == 3 then
		TableUtility.ArrayClear(self.exchangeRecordFilterList)
		for i=1,#self.exchangeRecordList do
			local data = self.exchangeRecordList[i]
			local logType = data.type
			if logType then
				if logType == ShopMallLogTypeEnum.PublicityBuySuccess
					or logType == ShopMallLogTypeEnum.PublicityBuyFail 
					or logType == ShopMallLogTypeEnum.PublicityBuying then
					TableUtility.ArrayPushBack(self.exchangeRecordFilterList , data)
				end 
			end
		end
	--赠送记录
	elseif filterData == 4 then
		TableUtility.ArrayClear(self.exchangeRecordFilterList)
		for i=1,#self.exchangeRecordList do
			local data = self.exchangeRecordList[i]
			local status = data.status
			if status then
				if status == ShopMallLogReceiveEnum.Giving
					or status == ShopMallLogReceiveEnum.GiveAccepting
					or status == ShopMallLogReceiveEnum.Gived1
					or status == ShopMallLogReceiveEnum.Gived2 then
					TableUtility.ArrayPushBack(self.exchangeRecordFilterList , data)
				end 
			end
		end
	end

	return self.exchangeRecordFilterList
end


function ShopMallProxy:GetClosestReceiveIndex(filterData)
	local list = self:GetExchangeRecordFilter(filterData)
	for i=1,#list do
	 	local data = list[i]
	 	if data and data:CanReceive() then
	 		return i
	 	end
	end	
end

function ShopMallProxy:GetExchangeRecordDetailList()
	return self.exchangeRecordDetailList
end

function ShopMallProxy:ResetExchangeRecordDetailList()
	TableUtility.ArrayClear( self.exchangeRecordDetailList )
end

function ShopMallProxy:AddExchangeRecordRedTip()
	if #self.exchangeRecordReceive >= 1 then
		RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_TRADE_RECORD)
	end
end

function ShopMallProxy:RemoveExchangeRecordRedTip()
	if #self.exchangeRecordReceive < 1 then
		RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TRADE_RECORD)
	end
end

--赠送
function ShopMallProxy:CheckItemType(itemData)
	if itemData.staticData then
		if BagProxy.CheckIs3DTypeItem(itemData.staticData.Type) then
			return FloatAwardView.ShowType.ModelType
		else
			return nil
		end
	end
	return nil
end

function ShopMallProxy:RecvReqGiveItemInfoCmd(data)
	self.expressData = ExchangeExpressData.new(data)
end

function ShopMallProxy:GetExpressData()
	return self.expressData
end

--今日财经
function ShopMallProxy:CallTodayFinanceRank(rankType, dateType)
	local map = self.financeMap[rankType]
	if map ~= nil then
		local data = map[dateType]
		if data ~= nil then
			if not data:CheckCanCall() then
				return false
			end
		end
	end

	ServiceRecordTradeProxy.Instance:CallTodayFinanceRank(rankType, dateType)
	return true
end

function ShopMallProxy:CallTodayFinanceDetail(itemid, rankType, dateType)
	local map = self.financeMap[rankType]
	if map ~= nil then
		local data = map[dateType]
		if data ~= nil then
			local item = data:GetItemById(itemid)
			if item ~= nil then
				if item:CheckCanCall() then
					ServiceRecordTradeProxy.Instance:CallTodayFinanceDetail(itemid, rankType, dateType)
					return true
				end
			end
		end
	end

	return false
end

function ShopMallProxy:RecvTodayFinanceRank(serviceData)
	local rankType = serviceData.rank_type
	local map = self.financeMap[rankType]
	if map == nil then
		map = {}
		self.financeMap[rankType] = map
	end
	local data = map[serviceData.date_type]
	if data == nil then
		data = FinanceData.new()
		map[serviceData.date_type] = data
	end
	data:SetData(serviceData)
	data:SetNextValidTime(60)
end

function ShopMallProxy:RecvTodayFinanceDetail(serviceData)
	local map = self.financeMap[serviceData.rank_type]
	if map ~= nil then
		local data = map[serviceData.date_type]
		if data ~= nil then
			local item = data:GetItemById(serviceData.item_id)
			if item ~= nil then
				item:SetDetail(serviceData.lists)
				item:SetNextValidTime(60)
			end
		end
	end
end

function ShopMallProxy:GetFinanceData(rankType, dateType)
	local map = self.financeMap[rankType]
	if map ~= nil then
		return map[dateType]
	end
end

function ShopMallProxy:GetFinanceItemData(rankType, dateType, itemid)
	local map = self.financeMap[rankType]
	if map ~= nil then
		local data = map[dateType]
		if data ~= nil then
			return data:GetItemById(itemid)
		end
	end
end

function ShopMallProxy:GetBoothfee(price, count)
	local boothfee = math.ceil(price * GameConfig.Exchange.SellCost)
	if boothfee > GameConfig.Exchange.MaxBoothfee then
		return GameConfig.Exchange.MaxBoothfee * count
	end

	return boothfee * count
end