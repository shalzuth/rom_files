local BaseCell = autoImport("BaseCell")
RecommendEquipCellForER = class("RecommendEquipCellForER", BaseCell)
autoImport("SetQuickItemCell")
function RecommendEquipCellForER:Init()
  self:FindObjs()
  self:AddCellClickEvent()
  self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
  self.dragDrop.dragDropComponent.OnCursor = DragCursorPanel.Instance.ShowItemCell
  self.dragDrop:SetDragEnable(true)
  function self.dragDrop.dragDropComponent.OnReplace(data)
    if data then
      self:PassEvent(SetQuickItemCell.SwapObj, {surce = data, target = self})
    end
  end
  function self.dragDrop.dragDropComponent.OnDropEmpty(data)
    self:RemoveQuickItem()
  end
  self.remove = self:FindGO("Remove")
  self:AddClickEvent(self.remove, function(go)
    self:RemoveQuickItem()
  end)
  self.Root_UIDragScrollView = self.gameObject:GetComponent(UIDragScrollView)
end
function RecommendEquipCellForER:CanDrag(value)
  self.dragDrop:SetDragEnable(value)
end
function RecommendEquipCellForER:RemoveUIDragScrollView()
  self.Root_UIDragScrollView.enabled = false
end
function RecommendEquipCellForER:SetQuickPos(pos)
  self.pos = pos
  if self.data then
    self.dragDrop.dragDropComponent.data = {
      itemdata = self.data,
      pos = self.pos
    }
    self.remove:SetActive(false)
  else
    self.remove:SetActive(false)
  end
end
function RecommendEquipCellForER:RemoveQuickItem()
  local data = self.data
  if data and self.pos then
    local key = {
      guid = nil,
      type = nil,
      pos = self.pos - 1
    }
  end
end
function RecommendEquipCellForER:FindObjs()
  self.item = self:FindGO("ItemCell")
  self.itemCell = ItemCell.new(self.item)
end
function RecommendEquipCellForER:GetEquipId()
  if self.data then
    return self.data.staticData.id
  else
    return nil
  end
end
function RecommendEquipCellForER:SetData(data)
  RecommendEquipCellForER.super.SetData(self, data)
  self.data = data
  self.itemCell:SetData(data)
  if data then
    self.dragDrop.dragDropComponent.data = {
      itemdata = data,
      pos = self.pos
    }
    self.remove:SetActive(false)
  else
    self.remove:SetActive(false)
  end
end
