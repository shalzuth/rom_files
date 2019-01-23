local baseCell = autoImport("BaseCell")
ExchangeRecordCell = class("ExchangeRecordCell", baseCell)

local normalItemColor = "%s%s%s"
local damageItemColor = "[c][cf1c0f]%s%s%s[-][/c]"

function ExchangeRecordCell:Init()
	ExchangeRecordCell.super.Init(self)

	self:FindObjs()
	self:AddEvts()
end

function ExchangeRecordCell:FindObjs()
	self.info = self:FindGO("Info")
	self.time = self:FindGO("Time"):GetComponent(UILabel)
	self.result = self:FindGO("Result"):GetComponent(UILabel)
	self.receiveMoney = self:FindGO("ReceiveMoneyBtn")
	self.receiveGoodsRoot = self:FindGO("ReceiveGoodsRoot")
	self.expressGoodsBtn = self:FindGO("ExpressGoodsBtn",self.receiveGoodsRoot)
	self.countDown = self:FindGO("CountDown"):GetComponent(UILabel)
	self.detailBtn = self:FindGO("DetailBtn")
	self.bgSp = self.gameObject:GetComponent(UIMultiSprite)
	self.boothIcon = self:FindGO("BoothIcon")
end

function ExchangeRecordCell:AddEvts()
	self:AddClickEvent(self.receiveMoney,function ()
		self:Receive()
	end)
	local receiveGoodsBtn = self:FindGO("ReceiveGoodsBtn",self.receiveGoodsRoot)
	self:AddClickEvent(receiveGoodsBtn,function ()
		self:Receive()
	end)
	self:AddClickEvent(self.expressGoodsBtn,function ()
		self:Express()
	end)
	self:AddClickEvent(self.gameObject,function ()
		if self.data and self.data:IsManyPeople() then
			self:Detail()
		end
	end)
end

function ExchangeRecordCell:SetData(data)
	self.data = data
	self.gameObject:SetActive(data ~= nil)

	if data then
		if data.tradetime and data.tradetime ~= 0 then
			self.time.text = ClientTimeUtil.GetFormatTimeStr(data.tradetime)
		else
			self.time.text = ""
		end

		local exchangeData
		local itemInfo = ""
		local info = ""
		local giveInfo = ""

		if data.itemid then
			exchangeData = Table_Exchange[data.itemid]
			errorLog(string.format("ExchangeRecordCell Table_Exchange[%s] == nil",data.itemid))

			--商品 icon+精炼等级+道具名（破损变红色）
			local itemData = Table_Item[data.itemid]
			if itemData then
				local iconInfo = string.format("{itemicon=%s}",data.itemid)
				local refineLv = data:GetRefineLvString()
				local itemName = itemData.NameZh
				local color = normalItemColor
				if data.damage then
					color = damageItemColor
				end

				itemInfo = string.format(color,iconInfo,refineLv,itemName)
			else
				errorLog(string.format("ExchangeRecordCell Table_Item[%s] == nil",data.itemid))
			end
		end

		if exchangeData then
			if data.type then
				--普通出售+公示期出售成功
				if data.type == ShopMallLogTypeEnum.NormalSell or data.type == ShopMallLogTypeEnum.PublicitySellSuccess then

					local firstNameData = data:GetExchangeFirstNameData()
					local count = data:GetCount()
					local tax = data:GetTax()
					local getmoney = data:GetGetmoney()

					local firstName = ""
					local zoneStr = ""
					if firstNameData then
						firstName = firstNameData:GetName()	--出售给xxx
						zoneStr = firstNameData:GetZoneString()	--xxx的世界线
					end
					--不可堆叠
					if exchangeData.Overlap == 0 then
						info = string.format(ZhString.ShopMall_ExchangeRecordNormalSellNotOverLap,
							itemInfo, firstName, zoneStr, tax, getmoney)
					--可堆叠
					elseif exchangeData.Overlap == 1 then
						info = string.format(ZhString.ShopMall_ExchangeRecordNormalSellOverLap,
							count, itemInfo, firstName, zoneStr, tax, getmoney)
					end

				--普通购买
				elseif data.type == ShopMallLogTypeEnum.NormalBuy then

					local firstNameData = data:GetExchangeFirstNameData()
					local costmoney = data:GetCostmoney()	--购买花费

					local firstName = ""
					local zoneStr = ""
					if firstNameData then
						firstName = firstNameData:GetName()	--从xxx购买
						zoneStr = firstNameData:GetZoneString()	--xxx的世界线
					end

					--不可堆叠
					if exchangeData.Overlap == 0 then
						info = string.format(ZhString.ShopMall_ExchangeRecordNormalBuyNotOverLap , 
							firstName, zoneStr , itemInfo , costmoney)								
					--可堆叠
					elseif exchangeData.Overlap == 1 then
						info = string.format(ZhString.ShopMall_ExchangeRecordNormalBuyOverLap , 
							firstName, zoneStr , data:GetCount() ,itemInfo , costmoney)
					end

				--公示期购买成功
				elseif data.type == ShopMallLogTypeEnum.PublicityBuySuccess then

					local costmoney = data:GetCostmoney()	--购买花费
					local firstNameData = data:GetExchangeFirstNameData()

					local firstName = ""
					local zoneStr = ""
					if firstNameData then
						firstName = firstNameData:GetName()	--从xxx购买
						zoneStr = firstNameData:GetZoneString()	--xxx的世界线
					end

					--不可堆叠
					if exchangeData.Overlap == 0 then
						info = string.format(ZhString.ShopMall_ExchangeRecordPublicityBuySuccessNotOverLap , 
							itemInfo , firstName , zoneStr , costmoney)
					--可堆叠
					elseif exchangeData.Overlap == 1 then

						local count = data:GetTotalcount()	--抢购总个数
						local successCount = data:GetCount()	--成功个数

						info = string.format(ZhString.ShopMall_ExchangeRecordPublicityBuySuccessOverLap , 
							count , itemInfo , successCount ,  firstName, zoneStr, costmoney)					
					end

				--公示期购买失败
				elseif data.type == ShopMallLogTypeEnum.PublicityBuyFail then

					local count = data:GetTotalcount()	--抢购总个数
					local failcount = data:GetFailcount()	--失败个数
					local retmoney = data:GetRetmoney()	--退款

					info = string.format(ZhString.ShopMall_ExchangeRecordPublicityBuyFail , 
						count , itemInfo , failcount , retmoney)

				--公示期正在购买
				elseif data.type == ShopMallLogTypeEnum.PublicityBuying then

					local costmoney = data:GetCostmoney()	--购买花费

					--不可堆叠
					if exchangeData.Overlap == 0 then

						info = string.format(ZhString.ShopMall_ExchangeRecordPublicityBuyingNotOverLap , 
							itemInfo , costmoney)
					--可堆叠
					elseif exchangeData.Overlap == 1 then

						local count = data:GetCount()	--抢购个数

						info = string.format(ZhString.ShopMall_ExchangeRecordPublicityBuyingOverLap , 
							count , itemInfo , costmoney)

					end

				--自动下架
				elseif data.type == ShopMallLogTypeEnum.AutoOff then
					info = string.format(ZhString.ShopMall_ExchangeRecordAutoOff, itemInfo)
				end
			end
		else
			errorLog(string.format("ExchangeRecordCell Table_Exchange[%s] == nil",data.itemid))
		end

		if data:CanReceive() then
			self:SetReceive()

			--赠送被拒绝
			if data.receiveEnum == ExchangeLogData.ReceiveEnum.Goods and
				data.receiverid ~= 0 then
				giveInfo = string.format(ZhString.ShopMall_ExchangeRecordExpressRefuse, data:GetReceiverName(), data:GetReceiverZoneid() )
			end

		elseif data.status then
			--已领取
			if data.status == ShopMallLogReceiveEnum.Receive or data.status == ShopMallLogReceiveEnum.Receiving then
				self:SetResult(true)
				self.result.text = ZhString.ShopMall_ExchangeRecordReceived

			--正在赠送
			elseif data.status == ShopMallLogReceiveEnum.Giving or data.status == ShopMallLogReceiveEnum.GiveAccepting then
				self:SetResult(true)
				self.result.text = ZhString.ShopMall_ExchangeRecordGiving
				if data.receiverid ~= 0 then
					giveInfo = string.format(ZhString.ShopMall_ExchangeRecordExpressGiving, data:GetReceiverName(), data:GetReceiverZoneid() )
				end

			--已赠送
			elseif data.status == ShopMallLogReceiveEnum.Gived1 or data.status == ShopMallLogReceiveEnum.Gived2 then
				self:SetResult(true)
				self.result.text = ZhString.ShopMall_ExchangeRecordGived
				if data.receiverid ~= 0 then
					giveInfo = string.format(ZhString.ShopMall_ExchangeRecordExpressGived, data:GetReceiverName(), data:GetReceiverZoneid() )
				end

			else
				--抢购中倒计时
				self:SetResult(false)
				if self.timeTick == nil then
					self.timeTick = TimeTickManager.Me():CreateTick(0,1000,self.UpdateCountDown,self)
				end
			end
		end

		info = info..giveInfo
		self.infoSL = SpriteLabel.new(self.info,nil,36,36,true)
		self.infoSL:SetText(info,true)

		self.detailBtn:SetActive( data:IsManyPeople() )

		local isBooth = data.tradeType == BoothProxy.TradeType.Booth
		if self.bgSp then
			self.bgSp.CurrentState = isBooth and 1 or 0
		end

		if self.boothIcon then
			self.boothIcon:SetActive(isBooth)
		end
	end
end

local takeLogTemp = {}
function ExchangeRecordCell:Receive()
	if self.data then
		TableUtility.TableClear(takeLogTemp)
		takeLogTemp.id = self.data.id
		takeLogTemp.logtype = self.data.type
		takeLogTemp.trade_type = self.data.tradeType
		ServiceRecordTradeProxy.Instance:CallTakeLogCmd(takeLogTemp)
	end
end

function ExchangeRecordCell:Express()
	if self.data then
		local giveLvLimit = GameConfig.Exchange.GiveLvLimit
		if giveLvLimit ~= nil and MyselfProxy.Instance:RoleLevel() < giveLvLimit then
			MsgManager.ShowMsgByID(28003)
			return
		end
		
		if ServerTime.CurServerTime()/1000 - self.data.tradetime > GameConfig.Exchange.CantSendTime then
			MsgManager.ShowMsgByID(25004)
		else
			if not BackwardCompatibilityUtil.CompatibilityMode_V11 then	--客户端版本含安全设备检测功能
				if Game.isSecurityDevice then	--当前设备是安全设备
					FunctionSecurity.Me():Exchange_Give(function (arg)
						self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ExchangeExpressView, 
							viewdata = arg})
					end, self.data)
				else
					MsgManager.ConfirmMsgByID(25202, function ()
						Game.Me():BackToLogo()
					end)
				end
			else
				MsgManager.ConfirmMsgByID(25201, function ()
					AppBundleConfig.JumpToAppStore()
				end)
			end
		end
	end
end

function ExchangeRecordCell:Detail()
	if self.data then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ExchangeRecordDetailView, viewdata = self.data})
	end
end

function ExchangeRecordCell:SetReceive()
	self.result.gameObject:SetActive(false)
	self.countDown.gameObject:SetActive(false)

	if self.data.receiveEnum == ExchangeLogData.ReceiveEnum.Money then
		self.receiveMoney:SetActive(true)
		self.receiveGoodsRoot:SetActive(false)

	elseif self.data.receiveEnum == ExchangeLogData.ReceiveEnum.Goods then
		self.receiveMoney:SetActive(false)
		self.receiveGoodsRoot:SetActive(true)
		
		if GameConfig.SystemForbid.Send then
			self.expressGoodsBtn:SetActive(false)
		else
			local sec = ServerTime.CurServerTime()/1000 - self.data.tradetime
			self.expressGoodsBtn:SetActive( (sec <= GameConfig.Exchange.SendButtonTime) and self.data.cangive)			
		end

	elseif self.data.receiveEnum == ExchangeLogData.ReceiveEnum.All then
		self.receiveMoney:SetActive(false)
		self.receiveGoodsRoot:SetActive(true)
		self.expressGoodsBtn:SetActive(false)

	end

	local userData = Game.Myself.data.userdata
	local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL);
	--todo xde 30
	if nowRoleLevel < 30 then
		self.expressGoodsBtn:SetActive(false)
	end
end

function ExchangeRecordCell:SetResult(isActive)
	self.receiveMoney:SetActive(false)
	self.receiveGoodsRoot:SetActive(false)

	self.result.gameObject:SetActive(isActive)
	self.countDown.gameObject:SetActive(not isActive)
end

function ExchangeRecordCell:UpdateCountDown()
	if self.data and self.data.endtime then
		local time = self.data.endtime - ServerTime.CurServerTime()/1000
		local min,sec
		if time > 0 then
			min,sec = ClientTimeUtil.GetFormatSecTimeStr( time )
		else
			min = 0
			sec = 0
		end
		self.countDown.text = string.format("%02d:%02d", min , sec)
	end
end

function ExchangeRecordCell:OnDestroy()
	if self.timeTick then
		TimeTickManager.Me():ClearTick(self)
	end
end