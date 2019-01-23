CardMakeCell = class("CardMakeCell", ItemCell)

function CardMakeCell:Init()

	self.itemContainer = self:FindGO("ItemContainer")
	local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
	obj.transform.localPosition = Vector3.zero

	CardMakeCell.super.Init(self)

	self:FindObjs()
	self:AddEvts()
	
	--todo xde
	OverseaHostHelper:FixLabelOverV1(self.nameLab,3,216)
end

function CardMakeCell:FindObjs()
	self.choose = self:FindGO("Choose")
	self.lock = self:FindGO("Lock")
end

function CardMakeCell:AddEvts()
	self:AddCellClickEvent()

	self:AddClickEvent(self.itemContainer, function ()
		self:PassEvent(CardMakeEvent.Select, self)
	end)
end

function CardMakeCell:SetData(data)
	self.gameObject:SetActive(data ~= nil)

	if data then
		CardMakeCell.super.SetData(self, data.itemData)

		self.choose:SetActive(data.isChoose)

		local isLock = data:IsLock()
		self.lock:SetActive(isLock)
		self:SetCardGrey(isLock)
	end

	self.data = data
end

function CardMakeCell:SetChoose(isChoose)
	if self.data then
		self.data:SetChoose(isChoose)
		self.choose:SetActive(isChoose)
	end
end