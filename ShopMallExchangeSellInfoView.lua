autoImport("ExchangeIntroduceData")
autoImport("ShopMallExchangeSellInfoCell")
autoImport("ExchangeSellIntroduceCell")
-- autoImport("ShopMallExchangeDetailCell")

ShopMallExchangeSellInfoView = class("ShopMallExchangeSellInfoView",ContainerView)

ShopMallExchangeSellInfoView.ViewType = UIViewType.PopUpLayer

function ShopMallExchangeSellInfoView:OnExit()
	self.sellCell:Exit()
	if self.introCell then
		self.introCell:OnDestroy()
	end
	ShopMallExchangeSellInfoView.super.OnExit(self)
end

function ShopMallExchangeSellInfoView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function ShopMallExchangeSellInfoView:FindObjs()
	-- self.sellingContainer = self:FindGO("SellingContainer")
	-- self.empty = self:FindGO("Empty")
	self.title = self:FindGO("Title"):GetComponent(UILabel)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.sellingScrollView = self:FindGO("ScrollView").transform
	self.helpButton = self:FindGO("HelpButton")
end

function ShopMallExchangeSellInfoView:AddEvts()
	-- body
end

function ShopMallExchangeSellInfoView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.RecordTradeReqServerPriceRecordTradeCmd , self.RecvItemPrice)
	self:AddListenEvt(ServiceEvent.RecordTradeSellItemRecordTradeCmd , self.RecvSellItem)
	-- self:AddListenEvt(ServiceEvent.RecordTradeItemSellInfoRecordTradeCmd , self.UpdateSellingList)
	-- self:AddListenEvt(ServiceEvent.RecordTradeItemSellInfoRecordTradeCmd , self.RecvInfo)
	self:AddListenEvt(ServiceEvent.RecordTradeCancelItemRecordTrade , self.RecvCancel)
end

function ShopMallExchangeSellInfoView:InitShow()
	if self.viewdata.viewdata and self.viewdata.viewdata.data and self.viewdata.viewdata.type then
		self.itemData = self.viewdata.viewdata.data
		self.type = self.viewdata.viewdata.type
		local cell = self.viewdata.viewdata.cell
		local go = nil

		-- local refine_lv
		-- if data.equipInfo then
		-- 	refine_lv = data.equipInfo.refinelv
		-- end
		-- ServiceRecordTradeProxy.Instance:CallItemSellInfoRecordTradeCmd( Game.Myself.data.id , data.staticData.id , refine_lv)

		if self.type == ShopMallExchangeSellEnum.Sell then
			if self.itemData.staticData.MaxNum == 1 then
				go = self:LoadPreferb("cell/SellNotOverLapCell")
			else
				go = self:LoadPreferb("cell/SellOverLapCell")
			end
			-- ServiceRecordTradeProxy.Instance:CallReqServerPriceRecordTradeCmd( Game.Myself.data.id ,  self.itemData , nil , true )

		elseif self.type == ShopMallExchangeSellEnum.Resell then
			go = self:LoadPreferb("cell/ExchangeResellCell")
			-- ServiceRecordTradeProxy.Instance:CallItemSellInfoRecordTradeCmd( Game.Myself.data.id , self.itemData.staticData.id )

		elseif self.type == ShopMallExchangeSellEnum.Cancel then
  			if self.itemData.staticData.MaxNum == 1 then
				go = self:LoadPreferb("cell/CancelSellNotOverLapCell")
			else
				go = self:LoadPreferb("cell/CancelSellOverLapCell")
			end
			-- ServiceRecordTradeProxy.Instance:CallItemSellInfoRecordTradeCmd( Game.Myself.data.id , self.itemData.staticData.id )
		end
		FunctionItemTrade.Me():GetTradePrice(self.itemData, true , true)
		
		self.sellCell = ShopMallExchangeSellInfoCell.new(go)
		self.itemData.sellType = self.type
		if cell then
			self.itemData.shopMallItemData = cell.data
		end
		self.sellCell:SetData(self.itemData)
		self.sellCell:AddEventListener(ShopMallEvent.ExchangeCloseSellInfo, self.CloseSelf , self)

		-- local sellingWrapConfig = {
		-- 	wrapObj = self.sellingContainer, 
		-- 	pfbNum = 6, 
		-- 	cellName = "ShopMallExchangeSellingCell", 
		-- 	control = ShopMallExchangeDetailCell, 
		-- 	dir = 1,
		-- }
		-- self.sellingWrapHelper = WrapCellHelper.new(sellingWrapConfig)		

		-- self.empty:SetActive(false)

		-- ShopMallProxy.Instance:ResetExchangeItemSellInfo()
		-- self:UpdateSellingList(false)

		self.name.text = self.itemData.staticData.NameZh
		self.helpButton:SetActive(false)
	else
		print(string.format("viewdata : %s , viewdata.data : %s , viewdata.type : %s",tostring(self.viewdata.viewdata),tostring(self.viewdata.viewdata.data),tostring(self.viewdata.viewdata.type)))
	end
end

function ShopMallExchangeSellInfoView:RecvItemPrice(note)
	local data = note.body
	if data then
		if data.itemData and data.itemData.base and self.itemData.staticData.id ~= data.itemData.base.id then
			return
		end

		local introData = ExchangeIntroduceData.new(data)
		self.sellCell:SetPrice(data.price)
		self.sellCell:SetPublicity(data.statetype)

		local go
		if data.statetype == ShopMallStateTypeEnum.WillPublicity or data.statetype == ShopMallStateTypeEnum.InPublicity then
			self.title.text = ZhString.ShopMall_ExchangePublicityTitle
			self.helpButton:SetActive(true)

			if data.statetype == ShopMallStateTypeEnum.WillPublicity then
				--?????????????????????
				go = self:LoadPreferb("cell/SellFirstPublicityCell",self.sellingScrollView)
			else
				--?????????????????????
				go = self:LoadPreferb("cell/SellPublicityCell",self.sellingScrollView)
			end
		else
			--????????????
			self.title.text = ZhString.ShopMall_ExchangeNormalTitle

			if self.itemData.enchantInfo and #self.itemData.enchantInfo:GetEnchantAttrs() > 0 then
				--??????????????????
				go = self:LoadPreferb("cell/SellNormalEnchantCell",self.sellingScrollView)
			elseif self.itemData.staticData.MaxNum == 1 then
				--????????????
				go = self:LoadPreferb("cell/SellNormalNotOverLapCell",self.sellingScrollView)	
			else
				--?????????
				go = self:LoadPreferb("cell/SellNormalOverLapCell",self.sellingScrollView)
			end
		end

		self.introCell = ExchangeSellIntroduceCell.new(go)
		self.introCell:SetData(introData)
	end
end

function ShopMallExchangeSellInfoView:RecvSellItem(note)
	local data = note.body	
	if data.type == BoothProxy.TradeType.Exchange and data.ret == ProtoCommon_pb.ETRADE_RET_CODE_SUCCESS then
		self:CloseSelf()
		ServiceRecordTradeProxy.Instance:CallMyPendingListRecordTradeCmd( nil , Game.Myself.data.id)
	end
end

function ShopMallExchangeSellInfoView:RecvCancel(note)
	local data = note.body
	if data.type == BoothProxy.TradeType.Exchange and data.ret == ProtoCommon_pb.ETRADE_RET_CODE_SUCCESS then
		ServiceRecordTradeProxy.Instance:CallMyPendingListRecordTradeCmd( nil , Game.Myself.data.id)

		self:CloseSelf()
	end
end