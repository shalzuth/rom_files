autoImport("ItemCell")
EquipComposeBagItemCell = class("EquipComposeBagItemCell", ItemCell)
function EquipComposeBagItemCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = Vector3.zero
  EquipComposeBagItemCell.super.Init(self)
  self:AddCellClickEvent()
  self.chooseSymbol = self:FindGO("ChooseSymbol")
end
function EquipComposeBagItemCell:SetData(data)
  self.data = data
  EquipComposeBagItemCell.super.SetData(self, data)
  self:UpdateChoose()
end
function EquipComposeBagItemCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end
function EquipComposeBagItemCell:UpdateChoose()
  if self.data and self.chooseId and self.data.id == self.chooseId then
    self.chooseSymbol:SetActive(true)
  else
    self.chooseSymbol:SetActive(false)
  end
end
