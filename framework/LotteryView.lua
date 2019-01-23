autoImport("FuncZenyShop")

LotteryView = class("LotteryView", ContainerView)

LotteryView.ViewType = UIViewType.NormalLayer

local _AEDiscountCoinTypeCoin = AELotteryDiscountData.CoinType.Coin
local _AEDiscountCoinTypeTicket = AELotteryDiscountData.CoinType.Ticket

function LotteryView:OnEnter()
	LotteryView.super.OnEnter(self)

	local _LotteryProxy = LotteryProxy.Instance
	_LotteryProxy:CallQueryLotteryInfo(self.lotteryType)
	_LotteryProxy:SetIsOpenView(true)

	self:NormalCameraFaceTo()
end

function LotteryView:OnExit()
	LotteryProxy.Instance:SetIsOpenView(false)
	self:CameraReset()
	LotteryView.super.OnExit(self)
end

function LotteryView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function LotteryView:FindObjs()
	self.money = self:FindGO("Money"):GetComponent(UILabel)
	self.cost = self:FindGO("Cost"):GetComponent(UILabel)
	self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
	self.lotteryDiscount = self:FindGO("LotteryDiscount"):GetComponent(UILabel)
	self.lotteryLimit = self:FindGO("LotteryLimit"):GetComponent(UILabel)
	self.lotteryLimitBg = self:FindGO("Bg1", self.lotteryLimit.gameObject):GetComponent(UISprite)

	self.ticketDiscount = self:FindGO("TicketDiscount")
	if self.ticketDiscount then
		self.ticketDiscount = self.ticketDiscount:GetComponent(UILabel)
	end
	self.ticketLimit = self:FindGO("TicketLimit")
	if self.ticketLimit then
		self.ticketLimit = self.ticketLimit:GetComponent(UILabel)
	end

	--todo xde 修改按钮label位置
	local lotteryBtn = self:FindGO("LotteryBtn")
	if (lotteryBtn ~= nil) then
		local tempLable = self:FindGO("Label",lotteryBtn)
		tempLable.transform.localPosition = LuaVector3(-55,4,0)
	end

	local ticketBtn = self:FindGO("TicketBtn")
	if (ticketBtn ~= nil) then
		local tempLable = self:FindGO("Label",ticketBtn)
		tempLable.transform.localPosition = LuaVector3(-55,4,0)
	end

	local toRecoverBtn = self:FindGO("ToRecoverBtn")
	if (toRecoverBtn ~= nil) then
		local toRecoverIcon = self:FindGO("ToRecoverIcon",toRecoverBtn)
		local tempLable = self:FindGO("Label",toRecoverBtn)
		tempLable.transform.localPosition = LuaVector3(-18,5,0)
		toRecoverIcon.transform.localPosition = LuaVector3(50,4,0)
	end
end

function LotteryView:AddEvts()
	local addMoney = self:FindGO("AddMoney")
	self:AddClickEvent(addMoney, function ()
		self:JumpZenyShop()
	end)

	self:AddClickEvent(self.skipBtn.gameObject, function ()
		self:Skip()
	end)

	local lotteryBtn = self:FindGO("LotteryBtn")
	self:AddClickEvent(lotteryBtn, function ()
		self:Lottery()
	end)
end

function LotteryView:AddViewEvts()
	self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
	self:AddListenEvt(ServiceEvent.ItemQueryLotteryInfo, self.InitView)
	self:AddListenEvt(LotteryEvent.EffectStart, self.HandleEffectStart)
	self:AddListenEvt(LotteryEvent.EffectEnd, self.HandleEffectEnd)
	self:AddListenEvt(ServiceEvent.ItemLotteryCmd, self.UpdateLimit)
	self:AddListenEvt(ServiceEvent.ActivityEventActivityEventNtf, self.HandleActivityEventNtf)
	self:AddListenEvt(ServiceEvent.ActivityEventActivityEventNtfEventCntCmd, self.HandleActivityEventNtfEventCnt)
end

function LotteryView:InitShow()
	self.tipData = {}
	self.tipData.funcConfig = {}
	self.npcId = self.viewdata.viewdata.npcdata.data.id

	--icon
	local moneyIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
	local lotteryIcon = self:FindGO("LotteryIcon"):GetComponent(UISprite)
	local money = Table_Item[GameConfig.MoneyId.Lottery]
	if money and money.Icon then
		IconManager:SetItemIcon(money.Icon, moneyIcon)
		IconManager:SetItemIcon(money.Icon, lotteryIcon)
	end

	self:UpdateMoney()
	self:UpdateSkip()
end

function LotteryView:InitView()
	self:UpdateDiscount()
	self:UpdateLimit()
end

function LotteryView:JumpZenyShop()
	FuncZenyShop.Instance():OpenUI(PanelConfig.ZenyShopGachaCoin)
end

function LotteryView:Skip()
	local skipType = LotteryProxy.Instance:GetSkipType(self.lotteryType)
	TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn , NGUIUtil.AnchorSide.Top, {120 + 75,50}) --todo xde
end

function LotteryView:Lottery()
	
end

function LotteryView:ToRecover()
	self:ShowRecover(true)

	if self.isUpdateRecover then
		self:UpdateRecover()
		self.isUpdateRecover = false
	end
end

function LotteryView:Recover()
	if self.canRecover then
		local isExist, ticketCount = LotteryProxy.Instance:GetSpecialEquipCount(self.recoverSelect, self.lotteryType)
		if isExist then
			MsgManager.DontAgainConfirmMsgByID(3556, function ()
				helplog("CallLotteryRecoveryCmd")
				ServiceItemProxy.Instance:CallLotteryRecoveryCmd(self.recoverSelect, self.npcId, self.lotteryType)
			end, nil, nil, #self.recoverSelect, LotteryProxy.Instance:GetRecoverTotalPrice(self.recoverSelect, self.lotteryType), self.ticketName, ticketCount, self.ticketName)
		else
			MsgManager.ConfirmMsgByID(3552, function ()
				helplog("CallLotteryRecoveryCmd")
				ServiceItemProxy.Instance:CallLotteryRecoveryCmd(self.recoverSelect, self.npcId, self.lotteryType)
			end, nil, nil, #self.recoverSelect, LotteryProxy.Instance:GetRecoverTotalPrice(self.recoverSelect, self.lotteryType), self.ticketName)
		end
	end
end

function LotteryView:CallLottery(price, year, month)
	local discount
	price, discount = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin, price)
	if price ~= self.costValue and not discount:IsInActivity() then
		MsgManager.ConfirmMsgByID(25314, function ()
			self:UpdateCost()
			self:UpdateDiscount()
			self:UpdateLimit()
		end)
		return
	end
	if MyselfProxy.Instance:GetLottery() < price then
		MsgManager.ConfirmMsgByID(3551, function ()
			self:JumpZenyShop()
		end)
		return
	end

	local _LotteryProxy = LotteryProxy.Instance

	if not _LotteryProxy:CheckTodayCanBuy(self.lotteryType) then
		MsgManager.ShowMsgByID(3641)
		return
	end

	local skipType = _LotteryProxy:GetSkipType(self.lotteryType)
	local skipValue = _LotteryProxy:IsSkipGetEffect(skipType)
	ServiceItemProxy.Instance:CallLotteryCmd(year, month, self.npcId, skipValue, price, nil, self.lotteryType)	
end

function LotteryView:CallTicket(year, month, times)
	times = times or 1

	local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
	if Ticket then
		local cost, discount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket, Ticket.count * times)
		if cost ~= self.ticketCostValue and not discount:IsInActivity() then
			MsgManager.ConfirmMsgByID(25314, function ()
				self:UpdateTicketCost()
				self:UpdateDiscount()
				self:UpdateLimit()
			end)
			return
		end
		if BagProxy.Instance:GetItemNumByStaticID(Ticket.itemid) < cost then
			MsgManager.ShowMsgByID(3554, self.ticketName)
			return
		end
		local _LotteryProxy = LotteryProxy.Instance
		local skipType = _LotteryProxy:GetSkipType(self.lotteryType)
		local skipValue = _LotteryProxy:IsSkipGetEffect(skipType)
		ServiceItemProxy.Instance:CallLotteryCmd(year, month, self.npcId, skipValue, nil, Ticket.itemid, self.lotteryType, times)
	end
end

function LotteryView:InitTicket()
	local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
	if Ticket then
		local ticketIcon = self:FindGO("TicketIcon"):GetComponent(UISprite)
		local ticketCostIcon = self:FindGO("TicketCostIcon"):GetComponent(UISprite)
		local ticket = Table_Item[Ticket.itemid]
		if ticket then
			IconManager:SetItemIcon(ticket.Icon, ticketIcon)
			IconManager:SetItemIcon(ticket.Icon, ticketCostIcon)

			self.ticketName = ticket.NameZh
		end
	end
end

function LotteryView:InitRecover()
	local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
	if Ticket then
		local recoverIcon = self:FindGO("RecoverIcon"):GetComponent(UISprite)
		local toRecoverIcon = self:FindGO("ToRecoverIcon"):GetComponent(UISprite)
		local recoverTitle = self:FindGO("RecoverTitle"):GetComponent(UILabel)
		local ticket = Table_Item[Ticket.itemid]
		if ticket then
			IconManager:SetItemIcon(ticket.Icon, recoverIcon)
			IconManager:SetItemIcon(ticket.Icon, toRecoverIcon)

			recoverTitle.text = string.format(ZhString.Lottery_RecoverTitle, ticket.NameZh)
		end
	end
end

function LotteryView:UpdateMoney()
	if self.money ~= nil then
		self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
	end
end

function LotteryView:UpdateCost()
	local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
	if data then
		self:UpdateCostValue(data.price)
	end
end

function LotteryView:UpdateCostValue(cost)
	self.costValue = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin, cost)
	if self.cost ~= nil then
			self.cost.text = self.costValue
	end
end

function LotteryView:UpdateTicket()
	local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
	if Ticket then
		self.ticket.text = StringUtil.NumThousandFormat(BagProxy.Instance:GetItemNumByStaticID(Ticket.itemid))
	end
end

function LotteryView:UpdateTicketCost()
	local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
	if Ticket then
		self.ticketCostValue = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket, Ticket.count)
		self.ticketCost.text = self.ticketCostValue
	end
end

function LotteryView:UpdateSkip()
	
end

function LotteryView:UpdateRecover()
	local data = LotteryProxy.Instance:GetRecover(self.lotteryType)
	if data then
		local newData = self:ReUniteCellData(data, 3)
		self.recoverHelper:UpdateInfo(newData)

		self.recoverEmpty:SetActive(#data == 0)
	end

	TableUtility.ArrayClear(self.recoverSelect)
	self:UpdateRecoverBtn()
end

function LotteryView:UpdateRecoverBtn()
	local total = LotteryProxy.Instance:GetRecoverTotalCost(self.recoverSelect, self.lotteryType)
	self.recoverTotalLabel.text = total

	self.canRecover = #self.recoverSelect > 0
	if self.canRecover then
		self.recoverBtn.CurrentState = 0
		self.recoverLabel.effectStyle = UILabel.Effect.Outline
	else
		self.recoverBtn.CurrentState = 1
		self.recoverLabel.effectStyle = UILabel.Effect.None
	end
end

function LotteryView:UpdateDiscount()
	local price, coinDiscount, ticketDiscount

	price, coinDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin)
	if coinDiscount ~= nil then
		local discountValue = coinDiscount:GetDiscount()
		local isShow = discountValue ~= 100

		self.lotteryDiscount.gameObject:SetActive(isShow)

		if isShow then
			self.lotteryDiscount.text = string.format(ZhString.Lottery_Discount, 100 - discountValue)
		end
	else
		-- todo xde
		if self.lotteryDiscount ~= nil then 
			self.lotteryDiscount.gameObject:SetActive(false)
		end
	end

	if self.ticketDiscount then
		price, ticketDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket)
		if ticketDiscount ~= nil then
			local discountValue = ticketDiscount:GetDiscount()
			local isShow = discountValue ~= 100

			self.ticketDiscount.gameObject:SetActive(isShow)

			if isShow then
				self.ticketDiscount.text = string.format(ZhString.Lottery_Discount, 100 - discountValue)
			end
		else
			self.ticketDiscount.gameObject:SetActive(false)
		end
	end
end

function LotteryView:UpdateLimit()
	local sb = LuaStringBuilder.CreateAsTable()
	local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
	if data ~= nil then
		if data.maxCount ~= 0 then
			sb:Append(string.format(ZhString.Lottery_TodayLimit, data.todayCount, data.maxCount))
		end
	end

	local price, coinDiscount, ticketDiscount

	price, coinDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin)
	if coinDiscount ~= nil then
		local isShow = coinDiscount:IsInActivity() and coinDiscount.count ~= 0

		if isShow then
			if #sb.content > 0 then
				sb:Append("  ")
			end
			sb:Append(string.format(ZhString.Lottery_DiscountLimit, coinDiscount.usedCount, coinDiscount.count))
		end
	end

	if self.ticketLimit then
		price, ticketDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket)
		if ticketDiscount ~= nil then
			local isShow = ticketDiscount:IsInActivity() and ticketDiscount.count ~= 0
			self.ticketLimit.gameObject:SetActive(isShow)

			if isShow then
				self.ticketLimit.text = string.format(ZhString.Lottery_DiscountLimit, ticketDiscount.usedCount, ticketDiscount.count)
			end
		else
			self.ticketLimit.gameObject:SetActive(false)
		end
	end

	local isShow = #sb.content > 0
	-- todo xde 关闭数量
	if(self.lotteryLimit and self.lotteryLimitBg)then
		self.lotteryLimit.gameObject:SetActive(false)
		if isShow then
			self.lotteryLimit.text = sb:ToString()
			self.lotteryLimitBg.width = self.lotteryLimit.localSize.x + 26
		end
	end
	sb:Destroy()
end

function LotteryView:GetDiscountByCoinType(cointype, price)
	local discount = ActivityEventProxy.Instance:GetLotteryDiscountByCoinType(self.lotteryType, cointype)
	if discount ~= nil and price ~= nil then
		price = math.floor(price * (discount:GetDiscount() / 100))
	end

	return price, discount
end

function LotteryView:ClickRecover(cell)
	local data = cell.data
	if data then
		self.tipData.itemdata = data.itemData
		self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220,0})
	end	
end

function LotteryView:ClickDetail(cell)
	local data = cell.data
	if data then
		self.tipData.itemdata = data:GetItemData()
		self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220,0})
	end	
end

function LotteryView:SelectRecover(cell)
	local data = cell.data
	if data then
		cell:SetChoose()
		local isChoose = cell:GetChoose()
		if isChoose then
			TableUtility.ArrayPushBack(self.recoverSelect, data.itemData.id)
		else
			TableUtility.ArrayRemove(self.recoverSelect, data.itemData.id)
		end

		self:UpdateRecoverBtn()
	end
end

function LotteryView:HandleEffectStart()
	self.gameObject:SetActive(false)

	self:CameraReset()
	local npcdata = self.viewdata.viewdata.npcdata
	if npcdata then
		local viewPort = CameraConfig.Lottery_Effect_ViewPort
		local rotation = CameraConfig.Lottery_Rotation
		self:CameraFaceTo(npcdata.assetRole.completeTransform,viewPort,rotation)
	end
end

function LotteryView:HandleEffectEnd()
	self.gameObject:SetActive(true)

	self:CameraReset()
	self:NormalCameraFaceTo()
end

function LotteryView:HandleActivityEventNtf(note)
	local data = note.body
	if data then
		self:UpdateDiscount()
		self:UpdateLimit()
		self:UpdateCost()
		self:UpdateTicketCost()
	end
end

function LotteryView:HandleActivityEventNtfEventCnt(note)
	local data = note.body
	if data then
		self:UpdateDiscount()
		self:UpdateLimit()
		self:UpdateCost()
		self:UpdateTicketCost()
	end
end

function LotteryView:NormalCameraFaceTo()
	local npcdata = self.viewdata.viewdata.npcdata
	if npcdata then
		local viewPort = CameraConfig.Lottery_ViewPort
		local rotation = CameraConfig.Lottery_Rotation
		self:CameraFaceTo(npcdata.assetRole.completeTransform,viewPort,rotation)
	end
end

function LotteryView:ReUniteCellData(datas, perRowNum)
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
end

function LotteryView:InitRecover()
	local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
	if Ticket then
		local recoverIcon = self:FindGO("RecoverIcon"):GetComponent(UISprite)
		local toRecoverIcon = self:FindGO("ToRecoverIcon"):GetComponent(UISprite)
		local recoverTitle = self:FindGO("RecoverTitle"):GetComponent(UILabel)
		local ticket = Table_Item[Ticket.itemid]
		if ticket then
			IconManager:SetItemIcon(ticket.Icon, recoverIcon)
			IconManager:SetItemIcon(ticket.Icon, toRecoverIcon)

			recoverTitle.text = string.format(ZhString.Lottery_RecoverTitle, ticket.NameZh)
		end
	end
end