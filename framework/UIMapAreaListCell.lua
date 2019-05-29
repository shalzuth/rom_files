local baseCell = autoImport("BaseCell")
UIMapAreaListCell = class("UIMapAreaListCell", baseCell)
function UIMapAreaListCell:Init()
  self.labName = self:FindGO("Name"):GetComponent(UILabel)
  self.goCurrency = self:FindGO("Currency")
  self.goTransfer = self:FindGO("Transfer")
  self.goCurrency:SetActive(false)
  self.goTransfer:SetActive(false)
  self:AddCellClickEvent()
end
function UIMapAreaListCell:SetData(data)
  self.data = data
  self.labName.text = data.name
end
