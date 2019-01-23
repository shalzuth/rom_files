autoImport("BoothItemCell")
autoImport("ExchangeBagSellCell")

BoothExchangeView = class("BoothExchangeView", SubView)

function BoothExchangeView:OnEnter()
	if not self.isSelf then
		FunctionSystem.InterruptMyselfAI()
		Game.Myself:Client_NoMove(true)
	end
	BoothExchangeView.super.OnEnter(self)
end

function BoothExchangeView:OnExit()
	if not self.isSelf then
		Game.Myself:Client_NoMove(false)
	end

	local cells = self.itemWrapHelper:GetCells()
	for i=1,#cells do
		cells[i]:OnDestroy()
	end

	BoothExchangeView.super.OnExit(self)
end

function BoothExchangeView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function BoothExchangeView:FindObjs()
	self.sellingTip = self:FindGO("SellingTip"):GetComponent(UILabel)
	self.scoreTip = self:FindGO("ScoreTip"):GetComponent(UILabel)
	self.bagSellRoot = self:FindGO("BagSellRoot"):GetComponent(CloseWhenClickOtherPlace)
end

function BoothExchangeView:AddEvts()
	self.bagSellRoot.callBack = function (go)
		self.bagSellRoot.gameObject:SetActive(false)
	end
end

function BoothExchangeView:AddViewEvts()
	self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateBagSell)
	self:AddListenEvt(ItemEvent.BarrowUpdate, self.UpdateBagSell)
	self:AddListenEvt(ServiceEvent.RecordTradeBoothPlayerPendingListCmd, self.HandlePendingList)
	self:AddListenEvt(ServiceEvent.RecordTradeSellItemRecordTradeCmd, self.HandleChange)
	self:AddListenEvt(ServiceEvent.RecordTradeCancelItemRecordTrade, self.HandleCancel)
	self:AddListenEvt(ServiceEvent.RecordTradeResellPendingRecordTrade, self.HandleChange)
	self:AddListenEvt(ServiceEvent.RecordTradeBuyItemRecordTradeCmd, self.HandleChange)
	self:AddListenEvt(ServiceEvent.RecordTradeUpdateOrderTradeCmd, self.HandleUpdate)
end

function BoothExchangeView:InitShow()
	self.tipData = {}
	self.tipData.funcConfig = {}
	self.itemList = {}

	local exchangeContainer = self:FindGO("ExchangeContainer")
	self.itemWrapHelper = WrapListCtrl.new(exchangeContainer, BoothItemCell, "BoothItemCell", WrapListCtrl_Dir.Vertical, 3, 165)
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
	self.itemWrapHelper:AddEventListener(BoothEvent.AddItem, self.ClickAddItem, self)

	local bagSellContainer = self:FindGO("BagSellContainer")
	self.bagWrapHelper = WrapListCtrl.new(bagSellContainer, ExchangeBagSellCell, "ExchangeBagSellCell", WrapListCtrl_Dir.Vertical, 5, 100)
	self.bagWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickBagSell, self)

	self.isSelf = self.container.playerID == Game.Myself.data.id
	self.sellingTip.gameObject:SetActive(self.isSelf)
	self.scoreTip.gameObject:SetActive(self.isSelf)

	if self.isSelf then
		self:UpdateScore()
	end

	self:CallBoothPlayerPendingListCmd()
end

function BoothExchangeView:CallBoothPlayerPendingListCmd()
	ServiceRecordTradeProxy.Instance:CallBoothPlayerPendingListCmd(self.container.playerID)
end

function BoothExchangeView:UpdateShow()
	local data = BoothProxy.Instance:GetItemList(self.container.playerID)
	if data then
		TableUtility.ArrayClear(self.itemList)
		TableUtility.ArrayShallowCopy(self.itemList, data)
		
		if self.isSelf then
			local count = #self.itemList

			self:UpdateSelling(count)
			if count < CommonFun.calcBoothMaxPendingCout(Game.Myself.data) then
				TableUtility.ArrayPushBack(self.itemList, true)
			end
		end
		self.itemWrapHelper:ResetDatas(self.itemList)
	end
end

function BoothExchangeView:UpdateSelling(count)
	self.sellingTip.text = string.format(ZhString.Booth_Selling, count, CommonFun.calcBoothMaxPendingCout(Game.Myself.data))
end

function BoothExchangeView:UpdateScore()
	self.scoreTip.text = string.format(ZhString.Booth_Score, MyselfProxy.Instance:GetBoothScore())
end

function BoothExchangeView:UpdateBagSell()
	if not self.initBag then
		return
	end

	local data = BoothProxy.Instance:GetExchangeBagSell()
	if data then
		self.bagWrapHelper:ResetDatas(data)
	end
end

function BoothExchangeView:ClickItem(cell)
	local data = cell.data
	if data ~= nil then
		if self.isSelf then
			if data.count == 0 then
				self.tipData.itemdata = data:GetItemData()
				self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220,0})
			else
				local type
				if data:CanExchange() and data.isExpired then
					type = ShopMallExchangeSellEnum.Resell
				else
					type = ShopMallExchangeSellEnum.Cancel
				end
				self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.BoothSellInfoView,
					viewdata = {data = data:GetItemData(), type = type, boothItemData = data}})
			end
		else
			local player = NSceneUserProxy.Instance:Find(self.container.playerID)
			if player ~= nil and player:IsInBooth() then
				self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.BoothBuyInfoView, viewdata = {data = data, playerID = self.container.playerID}})
			else
				MsgManager.ShowMsgByID(25704)
				self.container:CloseSelf()
			end
		end
	end
end

function BoothExchangeView:ClickAddItem(cell)
	self:sendNotification(UIEvent.CloseUI, UIViewType.ChitchatLayer)
	self.bagSellRoot.gameObject:SetActive(true)
	if not self.initBag then
		self.initBag = true
		self:UpdateBagSell()
	end
end

function BoothExchangeView:ClickBagSell(cell)
	local data = cell.data
	if data ~= nil then
		if self.lastBagSell ~= nil then
			self.lastBagSell:SetChoose(false)
		end

		cell:SetChoose(true)
		self.lastBagSell = cell

		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.BoothSellInfoView, viewdata = {data = data, type = ShopMallExchangeSellEnum.Sell}})
	end
end

function BoothExchangeView:HandlePendingList(note)
	local data = note.body
	if data and data.charid == self.container.playerID then
		self:UpdateShow()
	end
end

function BoothExchangeView:HandleChange(note)
	local data = note.body
	if data and data.type == BoothProxy.TradeType.Booth and data.ret == ProtoCommon_pb.ETRADE_RET_CODE_SUCCESS then
		self:CallBoothPlayerPendingListCmd()
	end
end

function BoothExchangeView:HandleCancel(note)
	local data = note.body
	if data and data.charid == self.container.playerID and data.type == BoothProxy.TradeType.Booth then
		self:CallBoothPlayerPendingListCmd()
	end	
end

function BoothExchangeView:HandleUpdate(note)
	local data = note.body
	if data and data.charid == self.container.playerID and data.type == BoothProxy.TradeType.Booth then
		self:UpdateShow()
	end	
end