autoImport("ItemData")
EquipComposeCellItemData = class("EquipComposeCellItemData", ItemData)
function EquipComposeCellItemData:ctor(id, staticId)
  EquipComposeCellItemData.super.ctor(self, id, staticId)
end
function EquipComposeCellItemData:SetEquipLv(v)
  self.equipLvLimited = v
end
