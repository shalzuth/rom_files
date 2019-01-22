autoImport("ExchangeBagSellCell")
autoImport("ShopMallExchangeSellingCombineCell")

ShopMallExchangeSellView = class("ShopMallExchangeSellView",SubView)

function ShopMallExchangeSellView:OnExit()
	-- for i=1,#self.sellingWrapHelper:GetCellCtls() do
	-- 	self.sellingWrapHelper:GetCellCtls()[i]:OnDestroy()
	-- end
	local cells = self.sellingCombineList:GetCells()
	for i=1,#cells do
		cells[i]:OnDestroy()
	end
	
	ShopMallExchangeSellView.super.OnExit(self)
end

function ShopMallExchangeSellView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function ShopMallExchangeSellView:FindObjs()
	self.sellView = self:FindGO("SellView" , self.container.exchangeView)
	self.tipsLabel = self:FindGO("TipsLabel" , self.sellView):GetComponent(UILabel)
	self.sellingTitle = self:FindGO("SellingTitle" , self.sellView):GetComponent(UILabel)
	self.sellingScrollView = self:FindGO("SellingScrollView",self.sellView):GetComponent(UIScrollView)
	-- self.rateTitle = self:FindGO("RateTitle" , self.sellView):GetComponent(UILabel)
	self.bagSellContainer = self:FindGO("BagSellContainer" , self.sellView)
	self.sellingContainer = self:FindGO("SellingContainer" , self.sellView)

	self.sellingGrid = self.sellingContainer:GetComponent(UIGrid)
end

function ShopMallExchangeSellView:AddEvts()
	self:AddListenEvt(ServiceEvent.RecordTradeMyPendingListRecordTradeCmd , self.RecvPendingList)
	self:AddListenEvt(ServiceEvent.RecordTradeListNtfRecordTrade , self.RecvListNtf)
end

function ShopMallExchangeSellView:AddViewEvts()
	self:AddListenEvt(ItemEvent.ItemUpdate,self.UpdateBagSell)
	self:AddListenEvt(ItemEvent.BarrowUpdate,self.UpdateBagSell)
end

function ShopMallExchangeSellView:InitShow()
	self.maxPendingCount = CommonFun.calcTradeMaxPendingCout(Game.Myself.data)

	self.bagSellWrapHelper = WrapListCtrl.new(self.bagSellContainer, ExchangeBagSellCell, "ExchangeBagSellCell", WrapListCtrl_Dir.Vertical, 4, 100)
	self.bagSellWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickBagSell, self)

	self.sellingCombineList = ListCtrl.new(self.sellingGrid,ShopMallExchangeSellingCombineCell,"ShopMallExchangeSellingCombineCell")
	self.sellingCombineList:AddEventListener(MouseEvent.MouseClick, self.ClickSelling, self)

	self:UpdateBagSell()
	self:UpdateSelling()

	ServiceRecordTradeProxy.Instance:CallMyPendingListRecordTradeCmd( nil , Game.Myself.data.id)

	self.tipsLabel.text = ZhString.ShopMall_ExchangeSellTip
	-- self.rateTitle.text = string.format(ZhString.ShopMall_ExchangeRateTitle ,  tostring( GameConfig.Exchange.ExchangeRate * 100 ) )
end

function ShopMallExchangeSellView:UpdateBagSell()
	local bagSellData = ShopMallProxy.Instance:GetExchangeBagSell()
	self.bagSellWrapHelper:ResetDatas(bagSellData)
end

 function ShopMallExchangeSellView:UpdateSelling()
 	local sellingData = ShopMallProxy.Instance:GetExchangeSelfSelling()

 	self.sellingTitle.text = string.format(ZhString.ShopMall_ExchangeSellTitle,tostring(#sellingData),tostring(self.maxPendingCount))
	local newData = self:ReUniteCellData(sellingData, 2)
	-- self.sellingWrapHelper:UpdateInfo(newData)
	self.sellingCombineList:ResetDatas(newData)
 end

function ShopMallExchangeSellView:ClickBagSell(cellCtl)

	if cellCtl.data == nil then
		return
	end

	if self.currentBagSellCell and self.currentBagSellCell ~= cellCtl then
		self.currentBagSellCell:SetChoose(false)
	end

	cellCtl:SetChoose(true)
	self.currentBagSellCell = cellCtl

	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ShopMallExchangeSellInfoView, viewdata = { data = cellCtl.data , type = ShopMallExchangeSellEnum.Sell}})
end

function ShopMallExchangeSellView:ClickSelling(cellCtl)
	local data = cellCtl.data
	if data == nil then
		return
	end

	local type = nil
	if data:CanExchange() and data.isExpired then
		type = ShopMallExchangeSellEnum.Resell
	else
		type = ShopMallExchangeSellEnum.Cancel
	end

	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ShopMallExchangeSellInfoView, viewdata = { cell = cellCtl ,data = data:GetItemData() , type = type}})
end

function ShopMallExchangeSellView:RecvPendingList()
	self:UpdateSelling()
end

function ShopMallExchangeSellView:RecvListNtf(note)
	local data = note.body
	if data.trade_type == BoothProxy.TradeType.Exchange and data.type == RecordTrade_pb.ELIST_NTF_MY_PENDING then
		ServiceRecordTradeProxy.Instance:CallMyPendingListRecordTradeCmd( nil , Game.Myself.data.id)
	end
end

function ShopMallExchangeSellView:ReUniteCellData(datas, perRowNum)
	local newData = {}
	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/perRowNum)+1;
			local i2 = math.floor((i-1)%perRowNum)+1;
			newData[i1] = newData[i1] or {};
			if(datas[i] == nil)then
				newData[i1][i2] = nil;
			else
				newData[i1][i2] = datas[i];
			end
		end
	end
	return newData;
end