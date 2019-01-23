BoothRecordCell = class("BoothRecordCell", BaseCell)

function BoothRecordCell:Init()
	BoothRecordCell.super.Init(self)

	self.tableTakeLog = {}
	self:FindObjs()
	self:AddEvts()
end

function BoothRecordCell:FindObjs()
	self.objInfo = self:FindGO("Info")
	self.labResult = self:FindGO("Result"):GetComponent(UILabel)
	self.objRecieveMoneyBtn = self:FindGO("ReceiveMoneyBtn")
	self.objRecieveBtn = self:FindGO("ReceiveBtn")
end

function BoothRecordCell:AddEvts()
	self:AddClickEvent(self.objRecieveMoneyBtn,function ()
		self:Receive()
	end)
	self:AddClickEvent(self.objRecieveBtn,function ()
		self:Receive()
	end)
end

function BoothRecordCell:SetData(data)
	self.data = data
	self.gameObject:SetActive(data ~= nil)

	if data then
		self.tradeType = data.tradeType

		local normalItemFormat = "%s%s%s"
		local damageItemFormat = "[c][cf1c0f]%s%s%s[-][/c]"
		local timeFormat = "[c][6c6c6c]%s[-][/c]    "

		local exchangeData
		local itemInfo = ""
		local info = ""

		if data.tradetime and data.tradetime ~= 0 then
			info = string.format(timeFormat, ClientTimeUtil.GetFormatTimeStr(data.tradetime))
		end

		if data.itemid then
			exchangeData = Table_Exchange[data.itemid]
			errorLog(string.format("BoothRecordCell Table_Exchange[%s] == nil",data.itemid))

			--商品 icon+精炼等级+道具名（破损变红色）
			local itemData = Table_Item[data.itemid]
			if itemData then
				local iconInfo = string.format("{itemicon=%s}",data.itemid)
				local refineLv = data:GetRefineLvString()
				local itemName = itemData.NameZh
				local format = normalItemFormat
				if data.damage then
					format = damageItemFormat
				end

				itemInfo = string.format(format,iconInfo,refineLv,itemName)
			else
				errorLog(string.format("BoothRecordCell Table_Item[%s] == nil",data.itemid))
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
						info = info .. string.format(ZhString.ShopMall_ExchangeRecordNormalSellNotOverLap ,
							itemInfo , firstName, zoneStr , tax , data:GetTotalQuota(), getmoney)
					--可堆叠
					elseif exchangeData.Overlap == 1 then
						info = info .. string.format(ZhString.ShopMall_ExchangeRecordNormalSellOverLap ,
							count , itemInfo , firstName, zoneStr , tax , data:GetTotalQuota(), getmoney)
					end
				--自动下架
				elseif data.type == ShopMallLogTypeEnum.AutoOff then
					info = info .. string.format(ZhString.ShopMall_ExchangeRecordAutoOff, itemInfo)
				else
					errorLog("Unsupport Data Type!")
					self.gameObject:SetActive(false)
				end
			end
		else
			errorLog(string.format("BoothRecordCell Table_Exchange[%s] == nil",data.itemid))
		end

		if data:CanReceive() then
			self:SetReceive()
		elseif data.status then
			self:SetResult(true)
			self.labResult.text = ZhString.ShopMall_ExchangeRecordReceived
			--若状态不是已领取
			if data.status ~= ShopMallLogReceiveEnum.Receive and data.status ~= ShopMallLogReceiveEnum.Receiving then
				errorLog("Wrong Data Status!")
			end
		end

		self.infoSL = SpriteLabel.new(self.objInfo,nil,36,36,true)
		self.infoSL:SetText(info,true)
	end
end

function BoothRecordCell:Receive()
	if self.data then
		TableUtility.TableClear(self.tableTakeLog)
		self.tableTakeLog.id = self.data.id
		self.tableTakeLog.logtype = self.data.type
		self.tableTakeLog.trade_type = self.tradeType or BoothProxy.TradeType.Booth
		ServiceRecordTradeProxy.Instance:CallTakeLogCmd(self.tableTakeLog)
	end
end
function BoothRecordCell:SetReceive()
	self.objRecieveMoneyBtn:SetActive(false)
	self.objRecieveBtn:SetActive(true)
	self.labResult.gameObject:SetActive(false)
end

function BoothRecordCell:SetResult(isActive)
	self.objRecieveMoneyBtn:SetActive(false)
	self.objRecieveBtn:SetActive(false)
	self.labResult.gameObject:SetActive(isActive)
end
