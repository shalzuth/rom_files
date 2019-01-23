LotteryRecoverData = class("LotteryRecoverData")

function LotteryRecoverData:ctor(data)
	self:SetData(data)
end

function LotteryRecoverData:SetData(data)
	if data then
		self.itemData = data

		self.cost = 0
		self.isChoose = false
		self.specialCost = 0
	end
end

function LotteryRecoverData:SetInfo(lotteryItemData, type)
	self.costItem = lotteryItemData.recoverItemid
	self.cost = lotteryItemData.recoverPrice

	if ShopMallProxy.Instance:JudgeSpecialEquip(self.itemData) then
		self.specialCost = CommonFun.calcRefineRecovery(self.itemData.id, self.itemData.equipInfo.refinelv, self.itemData.equipInfo.damage, type)
	end

	self.totalCost = self.cost + self.specialCost
end

function LotteryRecoverData:SetChoose()
	self.isChoose = not self.isChoose
end