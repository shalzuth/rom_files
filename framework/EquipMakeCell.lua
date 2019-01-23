EquipMakeCell = class("EquipMakeCell", ItemCell)

function EquipMakeCell:Init()

	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
	obj.transform.localPosition = Vector3.zero

	EquipMakeCell.super.Init(self)

	self:AddCellClickEvent()

	self:FindObjs()
end

function EquipMakeCell:FindObjs()
	self.lockBg = self:FindGO("LockBg")
	self.choose = self:FindGO("Choose")
end

function EquipMakeCell:SetData(data)
	local makeData = EquipMakeProxy.Instance:GetMakeData(data)
	if makeData then
		self.gameObject:SetActive(true)

		EquipMakeCell.super.SetData(self,makeData.itemData)
		self:UpdateMyselfInfo();

		self.lockBg:SetActive(makeData:IsLock())
		self:SetChoose(makeData:IsChoose())

	else
		self.gameObject:SetActive(false)
	end

	self.data = data
end

function EquipMakeCell:SetChoose(isChoose)
	self.choose:SetActive(isChoose)
end