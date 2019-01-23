autoImport("AuctionItemData")

AuctionData = class("AuctionData")

function AuctionData:ctor(data)
	self.itemList = {}
end

function AuctionData:SetData(serverData)
	if serverData then
		self.batchId = serverData.batchid

		TableUtility.ArrayClear(self.itemList)
		for i=1,#serverData.iteminfos do
			local data = AuctionItemData.new( serverData.iteminfos[i] )
			TableUtility.ArrayPushBack(self.itemList, data)
		end
	end
end

function AuctionData:UpdateItemInfo(serverData)
	for i=1,#self.itemList do
		local data = self.itemList[i]
		if data.orderid == serverData.signup_id then
			data:SetData(serverData)
			break
		end
	end
end

function AuctionData:SetNextInfo(serverData)
	self.nextStartTime = serverData.start_time
	self.lastOrderid = serverData.last_orderid
	self.nextOrderid = serverData.signup_id
end

function AuctionData:ClearNextInfo()
	self.lastOrderid = nil
	self.nextOrderid = nil
end

function AuctionData:SetFinishTime(time)
	self.finishTime = time
end

function AuctionData:CreateEventPool(keyLimit, containerLimit)
	if self.eventPool == nil then
		self.eventPool = LuaLRUKeyTable.new(keyLimit, 1)

		self.containerLimit = containerLimit
	end
end

function AuctionData:ClearEventPool()
	if self.eventPool then
		self.eventPool:Clear()
	end
end

function AuctionData:DestoryEventPool()
	self:ClearEventPool()
	self.eventPool = nil
end

function AuctionData:TryGetPage(itemid, pageIndex, orderid)
	local page, element = self:PureGetPage(orderid, pageIndex)
	if page == nil then
		ServiceAuctionCCmdProxy.Instance:CallReqAuctionFlowingWaterCCmd(self.batchId, itemid, pageIndex, nil , orderid)
	end
	return page, element
end

function AuctionData:PureGetPage(orderid, pageIndex, isAutoCreateElement)
	if self.eventPool then
		local element = self.eventPool:TryGetValueNoRemove(orderid)
		if element == nil then
			if isAutoCreateElement then
				--page pool
				element = SimpleLuaLRU.new(self.containerLimit)
				self.eventPool:Add(orderid, element)
			else
				return nil
			end
		end

		return self:GetPageData(element, pageIndex), element
	end

	return nil
end

function AuctionData:GetItemList()
	return self.itemList
end

function AuctionData:GetAuctionItemData(orderid)
	for i=1,#self.itemList do
		if self.itemList[i].orderid == orderid then
			return self.itemList[i]
		end
	end

	return nil
end

function AuctionData:GetPageData(pagePool, pageIndex)
	local objs = pagePool:GetObjs()
	for i=1,#objs do
		if objs[i].id == pageIndex then
			return objs[i]
		end
	end

	return nil
end

function AuctionData:GetNextStartTime()
	return self.nextStartTime or ServerTime.CurServerTime()/1000
end

function AuctionData:GetFinishTime()
	return self.finishTime
end