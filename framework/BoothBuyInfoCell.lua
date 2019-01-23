autoImport("BoothInfoBaseCell")

BoothBuyInfoCell = class("BoothBuyInfoCell", BoothInfoBaseCell)

function BoothBuyInfoCell:Init()
	BoothBuyInfoCell.super.Init(self)
	self:FindObjs()
	self:AddEvts()
end

function BoothBuyInfoCell:FindObjs()
	BoothBuyInfoCell.super.FindObjs(self)
	self.own = self:FindGO("OwnCount")
	if self.own then
		self.own = self.own:GetComponent(UILabel)
	end
	self.sellCount = self:FindGO("SellCount")
	if self.sellCount then
		self.sellCount = self.sellCount:GetComponent(UILabel)
	end
	self.money = self:FindGO("Money")
	if self.money then
		self.money = self.money:GetComponent(UILabel)
	end
end

function BoothBuyInfoCell:SetData(data)
	BoothBuyInfoCell.super.SetData(self, data:GetItemData())
	
	self.boothItemData = data

	if data then
		self.count = 1
		self.maxCount = data.count

		self:UpdateSellCount()
		self:UpdateOwn()
		self:UpdateCount()
		self:UpdatePrice()
	end
end

function BoothBuyInfoCell:UpdateBuyPrice()
	if self.priceLabel ~= nil then
		self.priceLabel.text = StringUtil.NumThousandFormat(self.boothItemData:GetPrice())
	end
end

function BoothBuyInfoCell:UpdateMoney()
	if self.money ~= nil then
		self.money.text = StringUtil.NumThousandFormat(self.boothItemData:GetPrice() * self.count)
	end
end

function BoothBuyInfoCell:UpdateSellCount()
	if self.sellCount ~= nil then
		self.sellCount.text = self.boothItemData.count
	end
end

function BoothBuyInfoCell:UpdateOwn()
	if self.own ~= nil then
		self.own.text = BagProxy.Instance:GetItemNumByStaticID(self.boothItemData.itemid) or 0
	end
end

function BoothBuyInfoCell:UpdatePrice()
	self:UpdateBuyPrice()
	self:UpdateMoney()
end

function BoothBuyInfoCell:Confirm()
	self:PassEvent(BoothEvent.ConfirmInfo, self)
	self:Cancel()
end