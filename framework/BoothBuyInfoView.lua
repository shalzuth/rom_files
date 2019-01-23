autoImport("BoothBuyInfoCell")
autoImport("BoothIntroduceCell")
autoImport("ExchangeIntroduceData")

BoothBuyInfoView = class("BoothBuyInfoView",ContainerView)

BoothBuyInfoView.ViewType = UIViewType.PopUpLayer

local _itemInfo = {}

function BoothBuyInfoView:OnExit()
	if self.infoCell then
		self.infoCell:Exit()
	end
	if self.introCell then
		self.introCell:OnDestroy()
	end
	BoothBuyInfoView.super.OnExit(self)
end

function BoothBuyInfoView:Init()
	self:FindObjs()
	self:AddViewEvts()
	self:InitShow()
end

function BoothBuyInfoView:FindObjs()
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.scrollView = self:FindGO("ScrollView").transform
end

function BoothBuyInfoView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.RecordTradeItemSellInfoRecordTradeCmd , self.RecvInfo)
end

function BoothBuyInfoView:InitShow()
	local viewdata = self.viewdata.viewdata
	if viewdata then
		local boothItemData = viewdata.data
		local itemdata = boothItemData:GetItemData()

		self.name.text = itemdata.staticData.NameZh

		local go
		if boothItemData.overlap then
			go = self:LoadPreferb("cell/BuyOverLapCell")
		else
			go = self:LoadPreferb("cell/BuyNotOverLapCell")
		end
		self.infoCell = BoothBuyInfoCell.new(go)
		self.infoCell:SetData(boothItemData)
		self.infoCell:AddEventListener(BoothEvent.CloseInfo, self.CloseSelf, self)
		self.infoCell:AddEventListener(BoothEvent.ConfirmInfo, self.ConfirmInfo, self)

		ServiceRecordTradeProxy.Instance:CallItemSellInfoRecordTradeCmd(nil, nil, nil, nil, nil, nil, nil, nil,
			boothItemData.orderId, BoothProxy.TradeType.Booth)
	end
end

function BoothBuyInfoView:RecvInfo(note)
	local data = note.body
	local viewdata = self.viewdata.viewdata
	if viewdata and data and data.type == BoothProxy.TradeType.Booth then
		local boothItemData = viewdata.data
		if boothItemData.orderId == data.order_id then

			if self.introData == nil then
				self.introData = ExchangeIntroduceData.new(data)
			else
				self.introData:SetData(data)
			end
			self.introData:SetBoothInfo(boothItemData)

			local go
			if data.statetype == ShopMallStateTypeEnum.InPublicity then
				go = self:LoadPreferb("cell/BuyPublicityCell", self.scrollView)
			else
				go = self:LoadPreferb("cell/BuyNormalCell", self.scrollView)
			end
			self.introCell = BoothIntroduceCell.new(go)
			self.introCell:SetData(self.introData)
		end
	end
end

function BoothBuyInfoView:ConfirmInfo(cell)
	local viewdata = self.viewdata.viewdata
	if viewdata then
		local playerID = viewdata.playerID
		if playerID ~= nil then
			local player = NSceneUserProxy.Instance:Find(playerID)
			if player == nil or not player:IsInBooth() then
				MsgManager.ShowMsgByID(25704)
				self:CloseSelf()
				return
			end
		end
	end

	local boothData = cell.boothItemData
	if boothData ~= nil then
		local _MyselfProxy = MyselfProxy.Instance
		if _MyselfProxy:GetROB() < boothData.price * cell.count then
			MsgManager.ShowMsgByID(10154)
			return
		end

		TableUtility.TableClear(_itemInfo)
		_itemInfo.itemid = boothData.itemid
		_itemInfo.price = boothData.price
		_itemInfo.count = cell.countInput and tonumber(cell.countInput.value) or 1
		_itemInfo.publicity_id = boothData.publicityId
		if not overlap then
			_itemInfo.order_id = boothData.orderId
		end
		_itemInfo.charid = boothData.charid

		local itemData = boothData:GetItemData()
		if itemData.equipInfo and itemData.equipInfo.damage then
			MsgManager.ConfirmMsgByID(10155,function ()
				self:CallBuyItemRecordTradeCmd()
			end)
		else
			self:CallBuyItemRecordTradeCmd()
		end
	end
end

function BoothBuyInfoView:CallBuyItemRecordTradeCmd()
	FunctionSecurity.Me():Exchange_SellOrBuyItem(function (arg)
		ServiceRecordTradeProxy.Instance:CallBuyItemRecordTradeCmd(arg, Game.Myself.data.id, nil, BoothProxy.TradeType.Booth)
	end, _itemInfo)
end