BusinessmanMakeCell = class("BusinessmanMakeCell", ItemCell)

function BusinessmanMakeCell:Init()

	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
	obj.transform.localPosition = Vector3.zero

	BusinessmanMakeCell.super.Init(self)

	self:FindObjs()
	self:AddCellClickEvent()
end

function BusinessmanMakeCell:FindObjs()
	self.choose = self:FindGO("Choose")
end

function BusinessmanMakeCell:SetData(data)
	if data then
		BusinessmanMakeCell.super.SetData(self, data.itemData)

		self:SetCanMakeNum(data)

		self:SetChoose(false)

		self:SetIconGrey( data:IsLock() )
	end

	self.data = data
end

function BusinessmanMakeCell:SetChoose(isChoose)
	self.choose:SetActive(isChoose)
end

function BusinessmanMakeCell:SetCanMakeNum(data)
	if data == nil then
		data = self.data
	end
	local canMakeNum = data:GetCanMakeNum()
	if canMakeNum > 0 then
		self.numLab.gameObject:SetActive(true)
		self.numLab.text = canMakeNum
	else
		self.numLab.gameObject:SetActive(false)
	end
end