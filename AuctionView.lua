autoImport("AuctionItemCell")
autoImport("AuctionEventCell")
autoImport("AuctionPriceCell")
autoImport("FuncZenyShop")
autoImport("ChatSimplifyView")
autoImport("AuctionChatGroup")

AuctionView = class("AuctionView", ContainerView)

AuctionView.ViewType = UIViewType.InterstitialLayer

local bgName = "auction_bg_background"
local bg2Name = "auction_bg_background2"
local girlBgName = "auction_bg_Corolla"

local rid = ResourcePathHelper.UICell("AuctionEventCell")
local eventClear = {}
local offerPriceInfo = {}
local DialogState = {
	AtAuction = 1,
	FinishCountdown = 2,
	NextAuction = 3,
	AuctionEnd = 4,
	Publicity = 5,	--?????????
}
local funkey = {
	"ShowDetail",
}
local tipData = {}

local GOCameraType = Game.GameObjectType.Camera

function AuctionView:OnEnter()
	AuctionView.super.OnEnter(self)
	local camera = Game.GameObjectManagers[GOCameraType]
	if camera ~= nil then
		camera:ActiveMainCamera(false)
	end
end

function AuctionView:OnExit()
	self:ClearTimeTick()
	self:ClearNextTimeTick()
	self:ClearShowPriceListLT()

	if self.isRunning and self.forceStay == nil then
		ServiceAuctionCCmdProxy.Instance:CallOpenAuctionPanelCCmd(false)
		AuctionProxy.Instance:ClearEventPool(self.batchid)
	end

	PictureManager.Instance:UnLoadAuction()
	MsgManager.CloseConfirmMsgByID(9515)

	local camera = Game.GameObjectManagers[GOCameraType]
	if camera ~= nil then
		camera:ActiveMainCamera(true)
	end

	AuctionView.super.OnExit(self)
end

function AuctionView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function AuctionView:FindObjs()
	self.money = self:FindGO("Money"):GetComponent(UILabel)
	self.recordBtn = self:FindGO("RecordBtn")
	self.itemName = self:FindGO("ItemName"):GetComponent(UILabel)
	self.itemGrid = self:FindGO("ItemGrid"):GetComponent(UIGrid)
	self.centerOnChild = self.itemGrid.gameObject:GetComponent("UICenterOnChild")
	self.currentPrice = self:FindGO("CurrentPrice"):GetComponent(UILabel)
	self.eventEmpty = self:FindGO("EventEmpty"):GetComponent(UILabel)
	self.eventScrollView = self:FindGO("EventScrollView"):GetComponent(UIScrollView)
	self.finish = self:FindGO("Finish")
	self.offerPriceRoot = self:FindGO("OfferPriceRoot")
	self.offerPrice = self:FindGO("OfferPrice"):GetComponent(UILabel)
	self.offerPriceTip = self:FindGO("OfferPriceTip")
	self.differenceRoot = self:FindGO("DifferenceRoot")
	self.differencePrice = self:FindGO("DifferencePrice"):GetComponent(UILabel)
	self.priceGrid = self:FindGO("PriceGrid"):GetComponent(UIGrid)
	self.nextCountdownRoot = self:FindGO("NextCountdownRoot")
	self.nextCountdown = self:FindGO("NextCountdown"):GetComponent(UILabel)
	self.dialogRoot = self:FindGO("DialogRoot"):GetComponent(UISprite)
	self.dialogTw = self.dialogRoot.gameObject:GetComponent(TweenAlpha)
	self.dialog = self:FindGO("Dialog"):GetComponent(UILabel)
	self.chatRoot = self:FindGO("ChatRoot")

	--todo xde
	self.nextCountdownRoot:GetComponent(UILabel).text = ""
	self.nextCountdown.color = Color(1,1,1);
	self.nextCountdown.fontSize = 24
	local tip = self:FindGO("Tip"):GetComponent(UILabel)
	OverseaHostHelper:FixLabelOverV1(tip,3,260)
	
	local differenceRootL = self.differenceRoot:GetComponent(UILabel)
	OverseaHostHelper:FixLabelOverV1(differenceRootL,3,200)
	differenceRootL.transform.localPosition = Vector3(118,-25,0)
	
	
end

function AuctionView:AddEvts()
	local closeButton = self:FindGO("CloseButton")
	self:AddClickEvent(closeButton, function ()
		if AuctionProxy.Instance:CheckAuctionSignUp() then
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AuctionSignUpView})
		end

		self:CloseSelf()
	end)

	self:AddClickEvent(self.chatRoot, function ()
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ChatRoomPage, force = force})
	end)

	self:AddClickEvent(self.recordBtn, function ()
		self:Record()
	end)

	local addMoney = self:FindGO("AddMoney")
	self:AddClickEvent(addMoney, function ()
		self.forceStay = true
		FuncZenyShop.Instance():OpenUI(PanelConfig.ZenyShopGachaCoin)
	end)

	self.centerOnChild.onFinished = function ()
		--??????
		self:ResetEvent()
	end

	self.centerOnChild.onCenter = function (centeredObject)
		if self.centerTrans and self.centerTrans.gameObject ~= centeredObject then
			self:CenterOn(self.centerTrans)
			return
		end

		if self.lastCenteredObject == centeredObject then
			self.centerTrans = nil
			return
		end

		local cells = self.itemCtrl:GetCells()
		for i=1,#cells do
			local data = cells[i].data
			if data and cells[i].gameObject == centeredObject then
				if self.lastItem then
					self.lastItem:SetScale(false)
				end
			
				cells[i]:SetScale(true)

				self.dialogTw:ResetToBeginning()
				self.dialogTw:PlayForward()

				self.itemid = data.itemid
				self.orderid = data.orderid
				self.currentPage = 0
				
				if self.isRunning then
					--????????????
					if self.lastItem == nil or self.lastItem.data.result ~= data.result then
						if not data:CheckAtAuction() then
							local atAuctionCell = self:GetAtAuctionItem()
							if atAuctionCell then
								atAuctionCell:ShowRedDot(true)
							end
						else
							cells[i]:ShowRedDot(false)
						end
					end

					--??????????????????
					local isShowNextCountdown = self.lastOrderid == data.orderid
					self.nextCountdownRoot:SetActive(isShowNextCountdown)
					if isShowNextCountdown and self.nextTimeTick == nil then
						self.nextTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateNextCountdown, self, 1)
						self:UpdateDialog()
					end
				end

				--?????????
				self.itemName.text = data:GetItemData():GetName()
				--????????????
				self:ClearEvent()

				self:UpdateView(data)

				self.lastItem = cells[i]
				self.centerTrans = nil
				self.lastCenteredObject = centeredObject

				break
			end
		end
	end

	NGUIUtil.HelpChangePageByDrag(self.eventScrollView, function ()
		if not self.isRunning then
			local currentPage = self.currentPage - 1
			if currentPage >= 0 then
				self:ResetEvent(currentPage)
			end
		end
	end, function ()
		if not self.isRunning then
			self:ResetEvent(self.currentPage + 1)
		end
	end, 100)
end

function AuctionView:AddViewEvts()
	self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
	self:AddListenEvt(ServiceEvent.AuctionCCmdNtfAuctionInfoCCmd, self.HandleNtfAuctionInfo)
	self:AddListenEvt(ServiceEvent.AuctionCCmdUpdateAuctionInfoCCmd, self.HandleUpdateAuctionInfo)
	self:AddListenEvt(ServiceEvent.AuctionCCmdReqAuctionFlowingWaterCCmd, self.HandleAuctionEvent)
	self:AddListenEvt(ServiceEvent.AuctionCCmdUpdateAuctionFlowingWaterCCmd, self.HandleUpdateAuctionEvent)
	self:AddListenEvt(ServiceEvent.AuctionCCmdNtfMyOfferPriceCCmd, self.HandleMyOfferPrice)
	self:AddListenEvt(ServiceEvent.AuctionCCmdNtfNextAuctionInfoCCmd, self.HandleNextAuction)
	self:AddListenEvt(AuctionEvent.FinishCountdown, self.HandleFinishCountdown)
	self:AddListenEvt(ServiceEvent.AuctionCCmdReqMyTradedPriceCCmd, self.HandleMyTradedPrice)
	self:AddListenEvt(ServiceEvent.AuctionCCmdNtfMaskPriceCCmd, self.HandleMaskPrice)
	self:AddListenEvt(ServiceEvent.SessionSocialityQueryUserInfoCmd, self.HandleQueryUserInfo)
	self:AddListenEvt(SecurityEvent.Close, self.HandleSecurityClose)
	self:AddListenEvt(ServiceUserProxy.RecvLogin , self.HandleLogin)
end

function AuctionView:InitShow()
	self.currentPage = 0

	self.tipData = {}
	self.tipData.funcConfig = {}

	local initParama = ReusableTable.CreateTable()
	initParama.gameObject = self.chatRoot
	initParama.chatCellCtrl = AuctionChatGroup
	initParama.chatCellPfb = "AuctionChatGroup"
	self:AddSubView("ChatSimplifyView", ChatSimplifyView, initParama)
	ReusableTable.DestroyAndClearTable(initParama)

	local _PictureManager = PictureManager.Instance
	local bg = self:FindGO("Background"):GetComponent(UITexture)
	local bg1 = self:FindGO("Background1"):GetComponent(UITexture)
	local bg2 = self:FindGO("Background2"):GetComponent(UITexture)
	local girlBg = self:FindGO("GirlBg"):GetComponent(UITexture)
	_PictureManager:SetAuction(bgName, bg)
	_PictureManager:SetAuction(bgName, bg1)
	_PictureManager:SetAuction(bg2Name, bg2)
	_PictureManager:SetAuction(girlBgName, girlBg)

	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_AUCTION_RECORD, self.recordBtn, 3, {-5,-5})

	self.itemCtrl = UIGridListCtrl.new(self.itemGrid, AuctionItemCell, "AuctionItemCell")
	self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)

	self.priceCtrl = UIGridListCtrl.new(self.priceGrid, AuctionPriceCell, "AuctionPriceCell")
	self.priceCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickPrice, self)

	local eventTable = self:FindGO("EventTable")
	self.eventHelper = WrapScrollViewHelper.new(AuctionEventCell, rid, 
		self.eventScrollView.gameObject, eventTable, 20)

	self:UpdateMoney()
	self:ClearEvent()

	local _AuctionProxy = AuctionProxy.Instance
	local batchid = _AuctionProxy:GetJumpPanelBatchid()
	if batchid ~= nil then
		self.batchid = batchid
		self.isRunning = _AuctionProxy:CheckAuctionRunning(self.batchid)

		self:UpdateItem()
		self:SelectAtAuctionItem()
		self:UpdateDialog()

		local data = _AuctionProxy:GetInfoByBatchId(self.batchid)
		if data then
			self.lastOrderid = data.lastOrderid
			self.nextOrderid = data.nextOrderid
		end
	end
end

function AuctionView:UpdateMoney()
	self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
end

function AuctionView:UpdateItem()
	local data = AuctionProxy.Instance:GetInfoByBatchId(self.batchid)
	if data then
		self.itemCtrl:ResetDatas(data:GetItemList())
	end
end

function AuctionView:ResetEvent(page)
	page = page or self.currentPage
	local data = AuctionProxy.Instance:GetEventList(self.batchid, self.itemid, page, self.orderid)
	if data then
		self.currentPage = page
		self.eventHelper:ResetPosition(data)
	end
end

function AuctionView:ClearEvent()
	self.eventHelper:ResetPosition(eventClear)
end

function AuctionView:UpdateCurrentPrice(data)
	if data.result == AuctionItemState.None then
		self.currentPrice.text = data:GetPriceString()

	elseif data:CheckAuctionEnd() then
		self.currentPrice.text = data:GetTradePriceString()

	elseif data:CheckAtAuction() then
		self.currentPrice.text = data:GetCurrentPriceString()
	end
end

function AuctionView:UpdatePrice(data)
	local isUpdate = data:CheckAtAuction()
	self.priceGrid.gameObject:SetActive(isUpdate)
	if isUpdate then
		local data = AuctionProxy.Instance:GetPriceList(data)
		if data then
			self.priceCtrl:ResetDatas(data)
		end
	end
end

function AuctionView:UpdateMyOfferPrice(state, price, currentPrice)
	if price > 0 then
		self.offerPriceRoot:SetActive(true)
		self.offerPrice.text = StringUtil.NumThousandFormat(price)

		if state == AuctionItemState.AtAuction then
			self.offerPriceTip:SetActive(false)
			self.differenceRoot:SetActive(true)

			local difference = 0
			if currentPrice == nil then
				if self.lastItem.data ~= nil then
					currentPrice = self.lastItem.data.currentPrice
				else
					currentPrice = 0
				end
			end
			difference = currentPrice - price
			if difference < 0 then
				difference = 0
			end
			self.differencePrice.text = StringUtil.NumThousandFormat(difference)

		else
			self.offerPriceTip:SetActive(true)
			self.differenceRoot:SetActive(false)
		end
	else
		self.offerPriceRoot:SetActive(false)
	end
end

function AuctionView:UpdateNextCountdown()
	local info = AuctionProxy.Instance:GetInfoByBatchId(self.batchid)
	if info then
		local sec = info:GetNextStartTime() - ServerTime.CurServerTime()/1000
		if sec > 0 then
			--todo xde
			self.nextCountdown.text = string.format(ZhString.AuctionNext,math.floor(sec))
		else
			if self.nextOrderid then
				local cells = self.itemCtrl:GetCells()
				for i=1,#cells do
					local data = cells[i].data
					if data and data.orderid == self.nextOrderid then
						self:CenterOn(cells[i].trans)
						break
					end
				end
			end

			self.lastOrderid = nil
			self.nextOrderid = nil
			info:ClearNextInfo()
			self:ClearNextTimeTick()
			self.nextCountdownRoot:SetActive(false)
		end
	end
end

function AuctionView:UpdateCountdown()
	local info = AuctionProxy.Instance:GetInfoByBatchId(self.batchid)
	if info then
		local finishTime = info:GetFinishTime() or 0
		local sec = finishTime - ServerTime.CurServerTime()/1000
		if sec > 0 then
			self:SetDialog(DialogState.FinishCountdown, math.floor(sec))
		else
			self:ClearFinishCountdown()
			self:SetDialog(DialogState.FinishCountdown, 0)
		end
	end
end

function AuctionView:UpdateEventEmpty(data)
	local tip = ""
	local isShow = false
	local _AuctionProxy = AuctionProxy.Instance
	if _AuctionProxy:CheckAuctionPublicity(self.batchid) then
		tip = string.format(ZhString.Auction_EventPublicityTip, _AuctionProxy:GetItemIndex(self.batchid, data.orderid))
		isShow = true
	elseif data.result == AuctionItemState.None then
		tip = ZhString.Auction_EventNextTip
		isShow = true
	end

	if isShow then
		self.eventEmpty.text = tip
	end
	self.eventEmpty.gameObject:SetActive(isShow)
end

function AuctionView:UpdateFinish(data)
	if data.result == AuctionItemState.None then
		self.finish:SetActive(false)

	elseif data:CheckAuctionEnd() then
		self.finish:SetActive(data.result == AuctionItemState.Sucess)

	elseif data:CheckAtAuction() then
		self.finish:SetActive(false)
	end
end

function AuctionView:UpdateOverTakePrice(isShow)
	if isShow then
		ColorUtil.RedLabel(self.offerPrice)
	else
		ColorUtil.WhiteUIWidget(self.offerPrice)
	end
end

function AuctionView:UpdateDialog(args)
	local dialogState
	local _AuctionProxy = AuctionProxy.Instance
	if self.isRunning then
		local info = _AuctionProxy:GetInfoByBatchId(self.batchid)
		local index = _AuctionProxy:GetAtAuctionIndex(self.batchid)
		if info and info:GetFinishTime() ~= nil then
			self:CreateTimeTick()
			dialogState = DialogState.FinishCountdown

		elseif self.lastOrderid ~= nil then
			dialogState = DialogState.NextAuction
			args = _AuctionProxy:GetItemIndex(self.batchid, self.nextOrderid)

		elseif index ~= nil then
			dialogState = DialogState.AtAuction
			args = index
		end
	elseif _AuctionProxy:CheckAuctionPublicity(self.batchid) then
		dialogState = DialogState.Publicity
	else
		dialogState = DialogState.AuctionEnd
	end

	if self.dialogState ~= dialogState then
		self:SetDialog(dialogState, args)
	end
end

function AuctionView:SetDialog(state, args)
	if state == DialogState.AtAuction then
		self.dialog.text = string.format(ZhString.Auction_DialogAtAuction, args, StringUtil.NumThousandFormat(GameConfig.Auction.MaxPrice))

	elseif state == DialogState.FinishCountdown then
		self.dialog.text = string.format(ZhString.Auction_DialogCountdown, args)

	elseif state == DialogState.NextAuction then
		self.dialog.text = string.format(ZhString.Auction_DialogNextAuction, args)

	elseif state == DialogState.AuctionEnd then
		self.dialog.text = ZhString.Auction_DialogEndTip

	elseif state == DialogState.Publicity then
		self.dialog.text = ZhString.Auction_DialogPublicity

	end

	if self.dialogState ~= state then
		self.dialogRoot.gameObject:SetActive(state ~= nil)
		self:UpdateDialogBg()
	end

	self.dialogState = state
end

function AuctionView:UpdateDialogBg()
	self.dialogRoot.height = self.dialog.localSize.y + 70
end

function AuctionView:UpdateView(data)
	if self.isRunning then
		--??????
		self:UpdatePrice(data)
		--???????????????
		self:UpdateOverTakePrice(data:CheckAtAuction() and data:CheckOverTakePrice())
	end

	--?????????
	self:UpdateEventEmpty(data)

	--????????????
	local myPrice = data:GetMyPrice()
	if myPrice == nil then
		if data:CheckAuctionEnd() then
			ServiceAuctionCCmdProxy.Instance:CallReqMyTradedPriceCCmd(self.batchid, data.itemid, nil, self.orderid)
		end
		myPrice = 0
	end
	self:UpdateMyOfferPrice(data.result, myPrice, data.currentPrice)
	--????????????
	self:UpdateCurrentPrice(data)
	--???????????????
	self:UpdateFinish(data)
end

function AuctionView:Record()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AuctionRecordView})
end

function AuctionView:ClickItem(cell)
	local data = cell.data
	if data then
		self.tipData.itemdata = data.itemData
		local itemTipBaseCell = self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220,0})
		if itemTipBaseCell then
			itemTipBaseCell:GetCell(1):SetReplaceInfo(string.format(ZhString.Auction_ItemTip, data.seller))
		end
	end	
end

function AuctionView:ClickPrice(cell)
	local data = cell.data
	if data then
		if data.disable then
			MsgManager.ShowMsgByID(9503)
			return
		end
		if data.mask then
			MsgManager.ShowMsgByID(9516, math.floor(data.mask / 60))
			return
		end
		if self.lastPriceCell ~= nil and self.lastPriceCell ~= cell then
			MsgManager.ShowMsgByID(9514)
			return
		end

		self.lastPriceCell = cell

		cell:PlayForward(function ()
			local auctionItemData = self.lastItem.data
			if AuctionProxy.Instance:GetDontShowAgain() then
				self:CallOfferPriceCCmd(auctionItemData.currentPrice, data.price, data.level)
			else
				local myPrice = auctionItemData:GetMyPrice() or 0
				local viewData = {
					viewname = "ToggleConfirmView", 
					content = string.format(ZhString.Auction_DontShowAgainContent, auctionItemData.currentPrice, data.price, auctionItemData.currentPrice + data.price - myPrice),
					checkLabel = ZhString.Auction_DontShowAgain,
					confirmtext = ZhString.UniqueConfirmView_Confirm,
					canceltext = ZhString.UniqueConfirmView_CanCel,
					confirmHandler = function (isToggle)
						AuctionProxy.Instance:SetDontShowAgain(isToggle)

						self:CallOfferPriceCCmd(auctionItemData.currentPrice, data.price, data.level)
					end,
					cancelHandler = function ()
						self:ResetPrice()
					end,
				}
				self:sendNotification(UIEvent.ShowUI, viewData)
			end
		end)
	end
end

function AuctionView:CallOfferPriceCCmd(max_price, add_price, level)

	TableUtility.TableClear(offerPriceInfo)
	offerPriceInfo.max_price = max_price
	offerPriceInfo.add_price = add_price
	offerPriceInfo.level = level
	offerPriceInfo.failureAct = function ()
		self:ResetPrice()
	end

	FunctionSecurity.Me():NormalOperation(function (arg)
		helplog("CallOfferPriceCCmd",self.itemid, arg.max_price, arg.add_price, arg.level)
		ServiceAuctionCCmdProxy.Instance:CallOfferPriceCCmd(self.itemid, arg.max_price, arg.add_price, arg.level, self.orderid)

		self:ShowPrice(false)

		self:ClearShowPriceListLT()
		self.showPriceListLT = LeanTween.delayedCall(2, function ()
			self:ShowPrice(true)
			self:ClearShowPriceListLT()
		end)
	end, offerPriceInfo)
end

function AuctionView:ShowPrice(isShow)
	if self.isShowPrice ~= isShow then
		self.isShowPrice = isShow

		if self.lastPriceCell then
			self.lastPriceCell.gameObject:SetActive(isShow)

			if isShow == true then
				self.lastPriceCell:Reset()
				self.lastPriceCell = nil
			end
		end
	end
end

function AuctionView:CenterOn(trans)
	self.centerTrans = trans
	self.centerOnChild:CenterOn(trans)
end

--?????????????????????????????????
function AuctionView:SelectAtAuctionItem()
	local cell = self:GetSelectItem()
	if cell then
		self:CenterOn(cell.trans)
	end
end

function AuctionView:GetAtAuctionItem()
	local cells = self.itemCtrl:GetCells()
	for i=1,#cells do
		local data = cells[i].data
		if data then
			if data:CheckAtAuction() then
				return cells[i]
			end
		end
	end

	return nil
end

function AuctionView:GetSelectItem()
	local cells = self.itemCtrl:GetCells()
	local finishAuction
	for i=1,#cells do
		local data = cells[i].data
		if data then
			if data:CheckAtAuction() then
				return cells[i]
			elseif self.isRunning and data:CheckAuctionEnd() then
				finishAuction = cells[i]
			end
		end
	end

	return finishAuction
end

function AuctionView:HandleNtfAuctionInfo(note)
	if self.isRunning then
		ServiceAuctionCCmdProxy.Instance:CallOpenAuctionPanelCCmd(true)
	end
end

function AuctionView:HandleUpdateAuctionInfo(note)
	local data = note.body
	if data and self.batchid == data.batchid then
		self:UpdateItem()
		self:UpdateDialog()

		if data.iteminfo.signup_id == self.orderid then
			local auctionItemData = self.lastItem.data
			self:UpdateView(auctionItemData)
		end
	end
end

function AuctionView:HandleAuctionEvent(note)
	local data = note.body
	if data and self.batchid == data.batchid and self.orderid == data.signup_id then
		self:ResetEvent(data.page_index)
	end
end

function AuctionView:HandleUpdateAuctionEvent(note)
	local data = note.body
	if data and self.batchid == data.batchid and self.orderid == data.signup_id then
		if self.dialogState == DialogState.FinishCountdown then
			self:ClearFinishCountdown()
			self:SetDialog()
		end
		self:ResetEvent(0)
	end
end

function AuctionView:HandleMyOfferPrice(note)
	local data = note.body
	if data and self.batchid == data.batchid and self.orderid == data.signup_id then
		self:UpdateMyOfferPrice(AuctionItemState.AtAuction, data.my_price)

		self:ShowPrice(true)
	end
end

function AuctionView:HandleMyTradedPrice(note)
	local data = note.body
	if data and self.batchid == data.batchid and self.orderid == data.signup_id then
		self:UpdateMyOfferPrice(nil, data.my_price)
	end
end

function AuctionView:HandleNextAuction(note)
	local data = note.body
	self.lastOrderid = data.last_signup_id
	self.nextOrderid = data.signup_id

	if data and self.batchid == data.batchid then
		self:UpdateDialog()

		self:UpdateOverTakePrice(false)

		self:ClearNextTimeTick()
		self.nextTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateNextCountdown, self, 1)
		self.nextCountdownRoot:SetActive(self.orderid == data.last_signup_id)
	end
end

function AuctionView:HandleFinishCountdown(note)
	local data = note.body
	if data then
		if self.batchid == data.batchid then
			self:ClearTimeTick()
			self:CreateTimeTick()
		end
	end
end

function AuctionView:HandleMaskPrice(note)
	local data = note.body
	if data and self.batchid == data.batchid and self.orderid == data.signup_id then
		local auctionItemData = self.lastItem.data
		if auctionItemData ~= nil then
			self:UpdatePrice(auctionItemData)
		end
	end
end

function AuctionView:HandleQueryUserInfo(note)
	local data = note.body
	if data then
		if self.playerTipData == nil then
			self.playerTipData = PlayerTipData.new()
		end
		self.playerTipData:SetBySocialData(data.data)

		local _FunctionPlayerTip = FunctionPlayerTip.Me()
		_FunctionPlayerTip:CloseTip()

		local playerTip = _FunctionPlayerTip:GetPlayerTip(self.dialogRoot, NGUIUtil.AnchorSide.Right, {-280,-200})

		tipData.playerData = self.playerTipData
		tipData.funckeys = funkey

		playerTip:SetData(tipData)
	end
end

function AuctionView:HandleSecurityClose(note)
	self:ResetPrice()
end

function AuctionView:HandleLogin(note)
	self:CloseSelf()
end

function AuctionView:ClearFinishCountdown()
	local info = AuctionProxy.Instance:GetInfoByBatchId(self.batchid)
	if info then
		info:SetFinishTime()
	end
	self:ClearTimeTick()
end

function AuctionView:ClearNextTimeTick()
	if self.nextTimeTick then
		TimeTickManager.Me():ClearTick(self, 1)
		self.nextTimeTick = nil
	end
end

function AuctionView:CreateTimeTick()
	if self.timeTick == nil then
		self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountdown, self, 2)
	end
end

function AuctionView:ClearTimeTick()
	if self.timeTick then
		TimeTickManager.Me():ClearTick(self, 2)
		self.timeTick = nil
	end
end

function AuctionView:ClearShowPriceListLT()
	if self.showPriceListLT then
		self.showPriceListLT:cancel()
		self.showPriceListLT = nil
	end
end

function AuctionView:ResetPrice()
	if self.lastPriceCell ~= nil then
		self.lastPriceCell:Reset()
		self.lastPriceCell = nil
	end	
end