autoImport("BaseCell")
AstrolabeView_SearchPointCell = class("AstrolabeView_SearchPointCell", BaseCell)
function AstrolabeView_SearchPointCell:Init()
  self.name = self:FindComponent("PointName", UILabel)
  self:AddCellClickEvent()
end
function AstrolabeView_SearchPointCell:SetData(data)
  if data == nil then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.data = data
  self.name.text = data:GetName() or ""
end
