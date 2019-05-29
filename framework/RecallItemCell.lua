RecallItemCell = class("RecallItemCell", ItemCell)
function RecallItemCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = Vector3.zero
  RecallItemCell.super.Init(self)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function RecallItemCell:SetData(data)
  self.data = data
  if data ~= nil then
    local itemData = ItemData.new("RecallItemCell", data.id)
    itemData.num = data.num
    RecallItemCell.super.SetData(self, itemData)
  end
end
