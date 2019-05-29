PvpHeadCell = class("PvpHeadCell", PlayerFaceCell)
function PvpHeadCell:Init()
  PvpHeadCell.super.Init(self)
  self:SetSize()
end
function PvpHeadCell:SetSize()
  self.headIconCell:SetScale(0.7)
  self.headIconCell:SetMinDepth(10)
end
function PvpHeadCell:SetData(data)
  if data == PvpHeadData_Empty then
    self.gameObject:SetActive(false)
  else
    self.gameObject:SetActive(true)
    PvpHeadCell.super.SetData(self, data)
    self.level.text = data.level
  end
end
