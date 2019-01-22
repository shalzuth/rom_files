autoImport("AuctionData")
autoImport("AuctionSignUpData")
autoImport("AuctionEventPageData")
autoImport("AuctionPriceData")
autoImport("AuctionRecordData")

AuctionProxy = class('AuctionProxy', pm.Proxy)
AuctionProxy.Instance = nil;
AuctionProxy.NAME = "AuctionProxy"

local HOURSEC = 60 * 60
local MINSEC = 60
local finishCountdown = {}

AuctionState = {
	Close = AuctionCCmd_pb.EAuctionState_Close,	--??????
	SignUp = AuctionCCmd_pb.EAuctionState_SignUp,	--??????
	SignUpVerify = AuctionCCmd_pb.EAuctionState_SignUpVerify,	--????????????
	Auction = AuctionCCmd_pb.EAuctionState_Auction,	--??????    
	AuctionEnd = AuctionCCmd_pb.EAuctionState_AuctionEnd,	--????????????
	AuctionPublicity = AuctionCCmd_pb.EAuctionState_AuctionPublicity	--???????????????
}

AuctionSignUpState = {
	Close = 1,	--??????
	SignUp = 2,	--??????
	Signed = 3,	--?????????
}

AuctionItemState = {
	None = AuctionCCmd_pb.EAuctionResult_None,	--?????????
	Fail = AuctionCCmd_pb.EAuctionResult_Fail,	--??????
	Sucess = AuctionCCmd_pb.EAuctionResult_Sucess,	--????????????
	AtAuction = AuctionCCmd_pb.EAuctionResult_AtAuction,	--????????????
}

AuctionEventState = {
	None = AuctionCCmd_pb.AuctionEvent_None,
	Start = AuctionCCmd_pb.AuctionEvent_Start,	--??????
	OfferPrice = AuctionCCmd_pb.AuctionEvent_OfferPrice,	--??????
	Result1 = AuctionCCmd_pb.AuctionEvent_Result1,	--30???
	Result2 = AuctionCCmd_pb.AuctionEvent_Result2,	--20???
	Result3 = AuctionCCmd_pb.AuctionEvent_Result3,	--10???
	ResultSuccess = AuctionCCmd_pb.AuctionEvent_ResultSuccess,	--??????
	ResultFail = AuctionCCmd_pb.AuctionEvent_ResultFail,	--??????
}

AuctionRecordState = {
	SignUp = AuctionCCmd_pb.ERecordType_SignUp,	--????????????
	SignUpSuccess = AuctionCCmd_pb.ERecordType_SignUpSuccess,	--??????????????????
	SignUpFail = AuctionCCmd_pb.ERecordType_SignUpFail,	--?????????????????????
	SellSucess = AuctionCCmd_pb.ERecordType_SellSucess,	--???????????????????????????
	SellFail = AuctionCCmd_pb.ERecordType_SellFail,	--??????
	SellSucessPass = AuctionCCmd_pb.ERecordType_SellSucessPass,	--??????????????????????????????
	SellSucessNoPass = AuctionCCmd_pb.ERecordType_SellSucessNoPass,	--?????????????????????????????????

	MaxOfferPrice = AuctionCCmd_pb.ERecordType_MaxOfferPrice,	--????????????
	OverTakePrice = AuctionCCmd_pb.ERecordType_OverTakePrice,	--???????????????
	BuySuccess = AuctionCCmd_pb.ERecordType_BuySuccess,	--???????????????????????????
	BuySuccessPass = AuctionCCmd_pb.ERecordType_BuySuccessPass,	--??????????????????????????????
	BuySuccessNoPass = AuctionCCmd_pb.ERecordType_BuySuccessNoPass,	--?????????????????????????????????
}

AuctionRecordTakeState = {
	None = AuctionCCmd_pb.EAuctionTakeStatus_None,	--????????????
	CanTake = AuctionCCmd_pb.EAuctionTakeStatus_CanTake,	--?????????
	Took = AuctionCCmd_pb.EAuctionTakeStatus_Took,	--?????????
}

function AuctionProxy:ctor(proxyName, data)
	self.proxyName = proxyName or AuctionProxy.NAME
	if AuctionProxy.Instance == nil then
		AuctionProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function AuctionProxy:Init()
	self.infoMap = {}
	self.signUpList = {}
	self.priceList = {}
	self.recordList = {}

	for i=1,3 do
		local data = AuctionPriceData.new(i)
		TableUtility.ArrayPushBack(self.priceList, data)
	end
end

--??????????????????
function AuctionProxy:RecvNtfAuctionStateCCmd(serverData)
	self.currentState = serverData.state
	self.currentBatchId = serverData.batchid
	self.auctionTime = serverData.auctiontime
	self.delay = serverData.delay

	self:SetSignUpClose()

	--?????????????????????????????????????????????
	if serverData.state == AuctionState.SignUp then
		for k,v in pairs(self.infoMap) do
			v:DestoryEventPool()
		end
	end
	--??????????????????????????????
	if serverData.state == AuctionState.AuctionEnd then
		self:sendNotification(MyselfEvent.AddWeakDialog, DialogUtil.GetDialogData(94))
	end
end

--????????????
function AuctionProxy:RecvNtfSignUpInfoCCmd(serverData)
	TableUtility.ArrayClear(self.signUpList)

	for i=1,#serverData.iteminfos do
		local data = AuctionSignUpData.new(serverData.iteminfos[i])
		TableUtility.ArrayPushBack(self.signUpList, data)
	end
end

--???????????????
function AuctionProxy:RecvNtfMySignUpInfoCCmd(serverData)
	for i=1,#serverData.signuped do
		for j=1,#self.signUpList do
			local data = self.signUpList[j]
			if serverData.signuped[i] == data.itemid then
				data:SetState(AuctionSignUpState.Signed)
				break
			end
		end
	end

	self:SetSignUpClose()
end

--????????????
function AuctionProxy:RecvSignUpItemCCmd(serverData)
	if serverData.ret then
		for i=1,#self.signUpList do
			local data = self.signUpList[i]
			if serverData.iteminfo.itemid == data.itemid then
				data:SetState(AuctionSignUpState.Signed)
				break
			end
		end
	end
end

--??????????????????
function AuctionProxy:RecvNtfAuctionInfoCCmd(serverData)
	local batchid = serverData.batchid
	local data = self.infoMap[batchid]

	if data == nil then
		data = AuctionData.new()
		self.infoMap[batchid] = data
	end
	data:SetData(serverData)

	local keyLimit, containerLimit = self:GetEventPoolLimit(data)
	data:CreateEventPool(keyLimit, containerLimit)

	self.jumpPanelBatchid = batchid
end

--????????????????????????
function AuctionProxy:RecvUpdateAuctionInfoCCmd(serverData)
	local batchid = serverData.batchid
	local data = self.infoMap[batchid]
	if data then
		data:UpdateItemInfo(serverData.iteminfo)
	end
end

--????????????????????????
function AuctionProxy:RecvReqAuctionFlowingWaterCCmd(serverData)
	local batchid = serverData.batchid
	local orderid = serverData.signup_id
	local itemid = serverData.itemid
	local pageIndex = serverData.page_index
	local page, element = self:GetPureEventPageData(batchid, orderid, pageIndex)
	if page == nil then
		if element then
			page = AuctionEventPageData.new(batchid, itemid, pageIndex, orderid)	
			local remove = element:Add(page)
			if remove then
				remove:Clear()
			end
		end
	end

	if page then
		page:Clear()
		local count = #serverData.flowingwater
		for i = count, 1, -1  do
			local event = serverData.flowingwater[i]
			page:AddEvent(event)

			if i == count then
				self:SetFinishCountdown(batchid, orderid, pageIndex, event)
			end
		end
	end
end

--??????????????????????????????
function AuctionProxy:RecvUpdateAuctionFlowingWaterCCmd(serverData)
	local batchid = serverData.batchid
	local orderid = serverData.signup_id
	local page = self:GetPureEventPageData(batchid, orderid, 0)
	if page then
		local event = serverData.flowingwater
		page:AddEvent(event)
		self:SetFinishCountdown(batchid, orderid, 0, event)
	end
end

--????????????
function AuctionProxy:RecvNtfMyOfferPriceCCmd(serverData)
	local info = self.infoMap[serverData.batchid]
	if info then
		local itemList = info:GetItemList()
		for i=1,#itemList do
			local data = itemList[i]
			if data.orderid == serverData.signup_id then
				data:SetMyPrice(serverData.my_price)
				break
			end
		end
	end
end

--?????????????????????
function AuctionProxy:RecvNtfNextAuctionInfoCCmd(serverData)
	local info = self.infoMap[serverData.batchid]
	if info then
		info:SetNextInfo(serverData)
	end
end

--????????????
function AuctionProxy:RecvReqAuctionRecordCCmd(serverData)
	TableUtility.ArrayClear(self.recordList)

	for i=1,#serverData.records do
		local record = serverData.records[i]
		if record.type ~= AuctionRecordState.MaxOfferPrice then
			local data = AuctionRecordData.new(record)
			TableUtility.ArrayPushBack(self.recordList, data)
		end
	end

	table.sort(self.recordList ,function(l,r)
		return l.time > r.time
	end)
end

function AuctionProxy:RecvTakeAuctionRecordCCmd(serverData)
	if serverData.ret then
		local id = serverData.id
		local type = serverData.type
		for i=1,#self.recordList do
			local record = self.recordList[i]
			if record.id == id and record.type == type then
				record:SetStatus(AuctionRecordTakeState.Took)
				self:SetRecordReceiveCount(self.recordReceiveCount - 1)
				break
			end
		end
	end
end

function AuctionProxy:RecvNtfCanTakeCntCCmd(serverData)
	self:SetRecordReceiveCount(serverData.count)
end

--??????????????????
function AuctionProxy:RecvReqMyTradedPriceCCmd(serverData)
	local info = self.infoMap[serverData.batchid]
	if info then
		local itemList = info:GetItemList()
		for i=1,#itemList do
			local data = itemList[i]
			if data.orderid == serverData.signup_id then
				data:SetMyPrice(serverData.my_price)
				break
			end
		end
	end	
end

--?????????????????????
function AuctionProxy:RecvNtfMaskPriceCCmd(serverData)
	local info = self.infoMap[serverData.batchid]
	if info then
		local itemList = info:GetItemList()
		for i=1,#itemList do
			local data = itemList[i]
			if data.orderid == serverData.signup_id then
				data:SetMaskPrice(serverData.mask_price)
				break
			end
		end
	end
end

--????????????
function AuctionProxy:SetSignUpClose()
	if self.currentState == AuctionState.SignUpVerify then
		for i=1,#self.signUpList do
			self.signUpList[i]:SetCloseState()
		end
	end
end

function AuctionProxy:SetDontShowAgain(isShowAgain)
	self.dontShowAgain = isShowAgain
end

function AuctionProxy:SetFinishCountdown(batchid, orderid, pageIndex, event)
	--?????????10???
	if self.currentBatchId == batchid and pageIndex == 0 and event.event == AuctionEventState.Result3 then
		local info = self.infoMap[batchid]
		if info then
			local iteminfo = info:GetAuctionItemData(orderid)
			if iteminfo and iteminfo:CheckAtAuction() then
				info:SetFinishTime(event.time + 10)

				TableUtility.TableClear(finishCountdown)
				finishCountdown.batchid = batchid
				finishCountdown.orderid = orderid
				self:sendNotification(AuctionEvent.FinishCountdown, finishCountdown)
			end
		end
	end
end

function AuctionProxy:SetRecordReceiveCount(count)
	self.recordReceiveCount = count

	self:CheckRedTip()
end

function AuctionProxy:CheckAuctionSignUp()
	return self.currentState == AuctionState.SignUp or self.currentState == AuctionState.SignUpVerify
end

function AuctionProxy:CheckAuctionRunning(batchid)
	return batchid == self.currentBatchId and self.currentState == AuctionState.Auction
end

function AuctionProxy:CheckAuctionPublicity(batchid)
	return batchid == self.currentBatchId and self.currentState == AuctionState.AuctionPublicity
end

function AuctionProxy:CheckRedTip()
	if self:GetRecordReceiveCount() <= 0 then
		RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_AUCTION_RECORD)
	end
end

function AuctionProxy:CheckEndItem(batchid, orderid)
	local info = self.infoMap[batchid]
	if info then
		local itemList = info:GetItemList()
		return itemList[#itemList].orderid == orderid
	end

	return false
end

function AuctionProxy:_CheckItemSignUp(itemData)
	if itemData == nil then
		return false
	end

	local enchantInfo = itemData.enchantInfo
	if enchantInfo ~= nil then
		local attrs = enchantInfo:GetEnchantAttrs()
		local attrsCount = #attrs
		local valuableCount = 0
		for i=1,attrsCount do
			if attrs[i].Quality == EnchantAttriQuality.Good then
				valuableCount = valuableCount + 1
			end
		end
		local _ConfigAuction = GameConfig.Auction
		return attrsCount >= _ConfigAuction.EnchantAttrCount and 
			(valuableCount >= _ConfigAuction.EnchantAttrValuableCount or #enchantInfo:GetCombineEffects() >= _ConfigAuction.EnchantBuffExtraCount)
	end
	return false
end

function AuctionProxy:ClearEventPool(batchid)
	local info = self.infoMap[batchid]
	if info then
		info:ClearEventPool()
	end	
end

function AuctionProxy:GetAuctionFormatTime()
	if self.auctionTime == nil or self.auctionTime == 0 then
		return nil
	end

	local totalSec = self.auctionTime - ServerTime.CurServerTime()/1000
	if totalSec > 0 then
		local hour = math.floor( totalSec / HOURSEC )
		local min = math.floor( (totalSec - hour * HOURSEC) / MINSEC )
		local sec = math.floor( totalSec - hour * HOURSEC - min * MINSEC )

		return totalSec, hour, min, sec
	end

	return totalSec
end

function AuctionProxy:GetCurrentState()
	return self.currentState
end

function AuctionProxy:GetAuctionTime()
	return self.auctionTime
end

function AuctionProxy:GetDelay()
	return self.delay
end

function AuctionProxy:GetSignUpList()
	return self.signUpList
end

function AuctionProxy:GetInfoByBatchId(batchid)
	return self.infoMap[batchid]
end

function AuctionProxy:GetEventPoolLimit(auctionData)
	local keyLimit, containerLimit = 5, 5
	if auctionData.batchId == self.currentBatchId then
		keyLimit, containerLimit = #auctionData:GetItemList(), 1
	end

	return keyLimit, containerLimit
end

function AuctionProxy:GetEventPageData(batchid, itemid, pageIndex, orderid)
	local info = self.infoMap[batchid]
	if info then
		return info:TryGetPage(itemid, pageIndex, orderid)
	end

	return nil
end

function AuctionProxy:GetPureEventPageData(batchid, orderid, pageIndex)
	local info = self.infoMap[batchid]
	if info then
		return info:PureGetPage(orderid, pageIndex, true)
	end

	return nil	
end

function AuctionProxy:GetEventList(batchid, itemid, pageIndex, orderid)
	local page = self:GetEventPageData(batchid, itemid, pageIndex, orderid)
	if page then
		return page:GetEventList()
	end

	return nil
end

function AuctionProxy:GetPriceList(auctionItemData)
	for i=1,#self.priceList do
		local data = self.priceList[i]
		local price = CommonFun.calcAuctionPrice(auctionItemData.currentPrice, data.level)	
		data:SetPrice(price)
		data:SetDisable(auctionItemData.sellerid == Game.Myself.data.id)

		local mask
		if auctionItemData:CheckMask(i) then
			mask = GameConfig.Auction.MaskPrice[i]
		end
		data:SetMask(mask)
	end

	return self.priceList
end

function AuctionProxy:GetClosestReceiveIndex()
	for i=1,#self.recordList do
	 	local data = self.recordList[i]
	 	if data and data:CanReceive() then
	 		return i
	 	end
	end	
end

function AuctionProxy:GetRecordList()
	return self.recordList
end

function AuctionProxy:GetRecordReceiveCount()
	return self.recordReceiveCount or 0
end

function AuctionProxy:GetDontShowAgain()
	return self.dontShowAgain
end

function AuctionProxy:GetItemIndex(batchid, orderid)
	local info = self.infoMap[batchid]
	if info then
		for i=1,#info:GetItemList() do
			local data = info:GetItemList()[i]
			if data.orderid == orderid then
				return i
			end
		end
	end

	return 0
end

function AuctionProxy:GetMyItemIndex(batchid, orderid)
	local info = self.infoMap[batchid]
	if info then
		for i=1,#info:GetItemList() do
			local data = info:GetItemList()[i]
			if data.orderid == orderid and data.sellerid == Game.Myself.data.id then
				return i
			end
		end
	end

	return 0
end

function AuctionProxy:GetAtAuctionIndex(batchid)
	local info = self.infoMap[batchid]
	if info then
		for i=1,#info:GetItemList() do
			if info:GetItemList()[i]:CheckAtAuction() then
				return i
			end
		end
	end

	return nil
end

function AuctionProxy:GetAtAuctionData(batchid)
	local info = self.infoMap[batchid]
	if info then
		for i=1,#info:GetItemList() do
			local data = info:GetItemList()[i]
			if data:CheckAtAuction() then
				return data
			end
		end
	end

	return nil
end

function AuctionProxy:GetJumpPanelBatchid()
	return self.jumpPanelBatchid
end
function AuctionProxy:GetSignUpItemList(itemid)
	if self.signUpItemList == nil then
		self.signUpItemList = {}
	else
		TableUtility.ArrayClear(self.signUpItemList)
	end

	local items = BagProxy.Instance:GetMainBag():GetItems()
	for i=1,#items do
		local item = items[i]
		if item.staticData.id == itemid and self:_CheckItemSignUp(item) then
			TableUtility.ArrayPushBack(self.signUpItemList, item)
		end
	end

	return self.signUpItemList
end