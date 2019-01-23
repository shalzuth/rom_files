LotteryDetailCell = class("LotteryDetailCell", ItemCell)

function LotteryDetailCell:Init()

	self.itemContainer = self:FindGO("ItemContainer")
	local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
	obj.transform.localPosition = Vector3.zero

	LotteryDetailCell.super.Init(self)

	self:FindObjs()
	self:AddEvts()
	
	--todo xde
	local fashionUnlock = self:FindGO("FashionUnlock")
	if fashionUnlock ~= nil then
		fashionUnlock:SetActive(false)
	end
end

function LotteryDetailCell:FindObjs()
	self.rate = self:FindGO("Rate")
	if self.rate then
		self.rate = self.rate:GetComponent(UILabel)
	end
	self.up = self:FindGO("Up")
end

function LotteryDetailCell:AddEvts()
	self:AddClickEvent(self.itemContainer, function ()
		self:PassEvent(MouseEvent.MouseClick, self)
	end)
end

function LotteryDetailCell:SetData(data)
	self.gameObject:SetActive(data ~= nil)

	if data then
		LotteryDetailCell.super.SetData(self, data:GetItemData())
		self:UpdateMyselfInfo(data:GetItemData())

		if self.rate then
			self.rate.text = string.format(ZhString.Lottery_DetailRate, data:GetRate())
		end

		if self.up then
			self.up:SetActive(data.isCurBatch == true)
		end
	end

	self.data = data
end