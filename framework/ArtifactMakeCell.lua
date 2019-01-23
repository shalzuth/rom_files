ArtifactMakeCell = class("ArtifactMakeCell", ItemCell)

function ArtifactMakeCell:Init()
	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
	obj.transform.localPosition = Vector3.zero
	ArtifactMakeCell.super.Init(self)
	self:AddCellClickEvent()
	self:FindObjs()
end

function ArtifactMakeCell:FindObjs()
	self.choose = self:FindGO("Choose")
end

function ArtifactMakeCell:SetData(data)
	local makeData = ArtifactProxy.Instance:GetMakeData(data)
	if makeData then
		self.gameObject:SetActive(true)
		ArtifactMakeCell.super.SetData(self,makeData.itemData)
		self:SetChoose(makeData:IsChoose())
		self:SetActive(self.invalid, false);
	else
		self.gameObject:SetActive(false)
	end

	self.data = data
end

function ArtifactMakeCell:SetChoose(isChoose)
	self.choose:SetActive(isChoose)
end