CardRandomMakeCell = class("CardRandomMakeCell", ItemCell)

function CardRandomMakeCell:Init()

	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
	obj.transform.localPosition = Vector3.zero

	CardRandomMakeCell.super.Init(self)

	self:FindObjs()
	self:AddEvts()
end

function CardRandomMakeCell:FindObjs()
	self.choose = self:FindGO("Choose")
	self.package = self:FindGO("Package")
	self.bagType = self:FindGO("BagType"):GetComponent(UIMultiSprite)
end

function CardRandomMakeCell:AddEvts()
	self:AddCellClickEvent()

	local longPress = self.gameObject:GetComponent(UILongPress)
	longPress.pressEvent = function ( obj,state )
		if state then
			self:PassEvent(CardMakeEvent.Select, self)
		end
	end
end

function CardRandomMakeCell:SetData(data)
	if data then
		self.choose:SetActive(data.isChoose)

		CardRandomMakeCell.super.SetData(self, data.itemData)

		local bagtype = data.itemData.bagtype
		if bagtype == BagProxy.BagType.Barrow then
			self.package:SetActive(true)
			self.bagType.CurrentState = 0
		elseif bagtype == BagProxy.BagType.PersonalStorage then
			self.package:SetActive(true)
			self.bagType.CurrentState = 1
		else
			self.package:SetActive(false)
		end
	else
		self.choose:SetActive(false)
		self.package:SetActive(false)
	end

	self.item:SetActive(data ~= nil)
	self.empty:SetActive(data == nil)

	self.data = data
end

function CardRandomMakeCell:SetChoose()
	self.data:SetChoose()
	self.choose:SetActive(self.data.isChoose)
end