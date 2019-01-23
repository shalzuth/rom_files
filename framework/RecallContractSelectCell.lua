local baseCell = autoImport("BaseCell")
RecallContractSelectCell = class("RecallContractSelectCell", baseCell)

function RecallContractSelectCell:Init()
	self:FindObjs()
	self:AddCellClickEvent()
end

function RecallContractSelectCell:FindObjs()
	self.name = self:FindGO("Name"):GetComponent(UILabel)
end

function RecallContractSelectCell:SetData(data)
	self.data = data
	self.gameObject:SetActive(data ~= nil)

	if data then
		self.name.text = data:GetName()
	end
end