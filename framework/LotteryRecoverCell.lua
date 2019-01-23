LotteryRecoverCell = class("LotteryRecoverCell", ItemCell)

function LotteryRecoverCell:Init()

	self.itemContainer = self:FindGO("ItemContainer")
	local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
	obj.transform.localPosition = Vector3.zero

	LotteryRecoverCell.super.Init(self)

	self:FindObjs()
	self:AddEvts()
end

function LotteryRecoverCell:FindObjs()
	self.choose = self:FindGO("Choose")
	self.money = self:FindGO("Money"):GetComponent(UILabel)
	self.moneyIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
end

function LotteryRecoverCell:AddEvts()
	self:AddClickEvent(self.itemContainer, function ()
		self:PassEvent(MouseEvent.MouseClick, self)
	end)

	local chooseRoot = self:FindGO("ChooseRoot")
	self:AddClickEvent(chooseRoot, function ()
		self:PassEvent(LotteryEvent.Select, self)
	end)
end

function LotteryRecoverCell:SetData(data)
	if data then
		LotteryRecoverCell.super.SetData(self, data.itemData)

		self:ActiveNewTag(false)
		self.choose:SetActive(data.isChoose)

		self.money.text = data.totalCost

		local money = Table_Item[data.costItem]
		if money and money.Icon then
			IconManager:SetItemIcon(money.Icon, self.moneyIcon)
		end
	end

	self.data = data
end

function LotteryRecoverCell:SetChoose()
	self.data:SetChoose()
	self.choose:SetActive(self.data.isChoose)
end

function LotteryRecoverCell:GetChoose()
	return self.data.isChoose
end