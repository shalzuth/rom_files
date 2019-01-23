local baseCell = autoImport("BaseCell")
ExchangeRecordDetailCell = class("ExchangeRecordDetailCell", baseCell)

function ExchangeRecordDetailCell:Init()
	ExchangeRecordDetailCell.super.Init(self)

	self:FindObjs()
end

function ExchangeRecordDetailCell:FindObjs()
	self.label = self.gameObject:GetComponent(UILabel)
end

function ExchangeRecordDetailCell:SetData(data)
	self.data = data

	if data then
		local logType = ShopMallProxy.Instance:GetExchangeRecordDetailType()
		if logType then
			local info
			if logType == ShopMallLogTypeEnum.NormalSell or logType == ShopMallLogTypeEnum.PublicitySellSuccess then
				info = ZhString.ShopMall_ExchangeRecordDetailSellDetail

			elseif logType == ShopMallLogTypeEnum.NormalBuy or logType == ShopMallLogTypeEnum.PublicityBuySuccess then
				info = ZhString.ShopMall_ExchangeRecordDetailBuyDetail

			end

			if info then
				self.label.text = string.format(info,data:GetName(),data:GetZoneString(),data:GetCount())
			end
		end
	end
end