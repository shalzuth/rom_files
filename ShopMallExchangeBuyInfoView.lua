autoImport("ExchangeIntroduceData")
autoImport("ShopMallExchangeBuyCell")
autoImport("ExchangeBuyIntroduceCell")

ShopMallExchangeBuyInfoView = class("ShopMallExchangeBuyInfoView",ContainerView)

ShopMallExchangeBuyInfoView.ViewType = UIViewType.PopUpLayer

function ShopMallExchangeBuyInfoView:OnExit()
	self.cell:Exit()
	if self.introCell then
		self.introCell:OnDestroy()
	end
	self:ShowItemTip()

	self:sendNotification(ShopMallEvent.ExchangeUpdateBuyView)

	ShopMallExchangeBuyInfoView.super.OnExit(self)
end

function ShopMallExchangeBuyInfoView:Init()
	self:FindObjs()
	self:InitShow()
	self:AddViewEvts()
end

function ShopMallExchangeBuyInfoView:FindObjs()
	self.title = self:FindGO("Title"):GetComponent(UILabel)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.buyScrollView = self:FindGO("ScrollView").transform
	self.helpButton = self:FindGO("HelpButton")
end

function ShopMallExchangeBuyInfoView:InitShow()
	if self.viewdata.viewdata and self.viewdata.viewdata.data then
		self.currentDetalData = self.viewdata.viewdata.data
		self.cell = nil	
		local offsetTip = nil		
		if self.currentDetalData.overlap then
			if self.buyOverLapCell == nil then
				local go = self:LoadPreferb("cell/BuyOverLapCell")
				self.buyOverLapCell = ShopMallExchangeBuyCell.new(go)
			end
			self.cell = self.buyOverLapCell
			offsetTip = {510, -208}
		else
			if self.buyNotOverLapCell == nil then
				local go = self:LoadPreferb("cell/BuyNotOverLapCell")
				self.buyNotOverLapCell = ShopMallExchangeBuyCell.new(go)
			end
			self.cell = self.buyNotOverLapCell
			offsetTip = {490, -155}
		end

		self.cell:SetData(self.currentDetalData)
		self.cell:AddEventListener(ShopMallEvent.ExchangeCloseBuyInfo, self.CloseSelf , self)

		-- local data = {itemdata = self.cell.data,--ItemData.new("",cell.data.itemid) , 
		-- 			funcConfig = {},
		-- 			noSelfClose = true}
		-- self:ShowItemTip(data , self.cell.icon , NGUIUtil.AnchorSide.Right, offsetTip)

		local staticData = Table_Item[self.currentDetalData.itemid]
		self.name.text = staticData and staticData.NameZh or ""
		self.helpButton:SetActive(false)

		ServiceRecordTradeProxy.Instance:CallItemSellInfoRecordTradeCmd(Game.Myself.data.id, self.currentDetalData.itemid, nil,
			self.currentDetalData.publicityId, nil, nil, nil, nil, self.currentDetalData.orderId, self.currentDetalData.type)
	else
		print(string.format("ShopMallExchangeBuyInfoView InitShow : viewdata : %s , viewdata.cell : %s , viewdata.cell.data : %s ",tostring(self.viewdata.viewdata),tostring(self.viewdata.viewdata.cell),tostring(self.viewdata.viewdata.cell.data)))
	end
end

function ShopMallExchangeBuyInfoView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.RecordTradeBuyItemRecordTradeCmd , self.RecvBuyItem)
	self:AddListenEvt(ServiceEvent.RecordTradeItemSellInfoRecordTradeCmd , self.RecvInfo)
end

function ShopMallExchangeBuyInfoView:RecvBuyItem(note)
	self.cell:SetBuyBtn(false)

	local data = note.body
	if data.ret == ProtoCommon_pb.ETRADE_RET_CODE_SUCCESS then
		self:CloseSelf()
	else

	end
end

function ShopMallExchangeBuyInfoView:RecvInfo(note)
	local data = note.body
	if data then
		local introData = ExchangeIntroduceData.new(data)
		introData.shopMallItemData = self.currentDetalData

		local go
		if data.statetype == ShopMallStateTypeEnum.InPublicity then
			--?????????????????????
			-- self.title.text = ZhString.ShopMall_ExchangePublicityTitle
			self.helpButton:SetActive(true)

			go = self:LoadPreferb("cell/BuyPublicityCell",self.buyScrollView)
		else
			--????????????
			-- self.title.text = ZhString.ShopMall_ExchangeNormalTitle

			go = self:LoadPreferb("cell/BuyNormalCell",self.buyScrollView)
		end
		self.introCell = ExchangeBuyIntroduceCell.new(go)
		self.introCell:SetData(introData)

		self.cell:SetCountChangeCallback(function (canExpress, isQuotaEnough)
			self.introCell:UpdateSend(canExpress, isQuotaEnough)
		end)
	end
end