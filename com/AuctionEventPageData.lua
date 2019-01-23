autoImport("AuctionEventData")

AuctionEventPageData = class("AuctionEventPageData")

function AuctionEventPageData:ctor(batchid, itemid, pageIndex)
	self.eventList = {}
	self.batchid = batchid
	self.itemid = itemid
	self.id = pageIndex
end

function AuctionEventPageData:AddEvent(data)
	if data then
		local length = #self.eventList
		if length >= GameConfig.Auction.FlowingWaterMaxCount then
			local event = TableUtility.ArrayPopFront(self.eventList)
			if event then
				event:Destroy()
			end
		end
		local event = AuctionEventData.CreateAsArray(data)
		event:SetInfo(self.batchid, self.itemid)
		TableUtility.ArrayPushBack(self.eventList, event)
	end
end

function AuctionEventPageData:GetEventList()
	return self.eventList
end

function AuctionEventPageData:Clear()
	for i=1,#self.eventList do
		self.eventList[i]:Destroy()
	end
	TableUtility.ArrayClear(self.eventList)
end