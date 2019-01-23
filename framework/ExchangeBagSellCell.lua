ExchangeBagSellCell = class("ExchangeBagSellCell", ItemCell)

function ExchangeBagSellCell:Init()

	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
	obj.transform.localPosition = Vector3.zero

	ExchangeBagSellCell.super.Init(self)

	self:FindObjs()
	self:AddCellClickEvent()
end

function ExchangeBagSellCell:FindObjs()
	self.choose = self:FindGO("Choose")
	self.sourceCt = self:FindGO("SourceCt")
	self.sourceIcon = self:FindComponent("icon",UISprite)
end

function ExchangeBagSellCell:SetData(data)
	self.data = data

	self.choose:SetActive(false)
	ExchangeBagSellCell.super.SetData(self,data)
	if(data)then
		if(self.data.bagtype == BagProxy.BagType.MainBag)then
			self:Hide(self.sourceCt)
		elseif(self.data.bagtype == BagProxy.BagType.PersonalStorage)then
			self.sourceIcon.spriteName = "com_icon_Corner_warehouse"
			self:Show(self.sourceCt)
		else
			self.sourceIcon.spriteName = "com_icon_Corner_wheelbarrow"
			self:Show(self.sourceCt)
		end		
	else
		self:Hide(self.sourceCt)
	end
end

function ExchangeBagSellCell:SetChoose(isChoose)
	if isChoose then
		self.choose:SetActive(true)
	else
		self.choose:SetActive(false)
	end
end