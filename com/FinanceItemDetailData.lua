FinanceItemDetailData = class("FinanceItemDetailData")

function FinanceItemDetailData:ctor(data)
	self:SetData(data)
end

function FinanceItemDetailData:SetData(data)
	self.itemid = data.item_id
	self.ratio = data.ratio
end

function FinanceItemDetailData:SetRankType(rankType)
	self.rankType = rankType
end