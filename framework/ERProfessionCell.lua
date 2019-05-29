local BaseCell = autoImport("BaseCell")
ERProfessionCell = class("ERProfessionCell", BaseCell)
function ERProfessionCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end
function ERProfessionCell:FindObjs()
  self.professionName = self:FindComponent("professionName", UILabel)
end
function ERProfessionCell:SetData(data)
  self.data = data
  self.professionName.text = data.genre
end
