DragDropCell = class("DragDropCell")
function DragDropCell:ctor(dragItemComponent, longPressTime)
  self.dragDropComponent = dragItemComponent
  longPressTime = longPressTime or 0.3
  if longPressTime and longPressTime > 0 then
    self.longPress = self.dragDropComponent.gameObject:GetComponent(UILongPress)
    if self.longPress == nil then
      self.longPress = self.dragDropComponent.gameObject:AddComponent(UILongPress)
    end
    if self.longPress then
      self.longPress.checkHoverSelf = false
      self.longPress.pressTime = longPressTime
      function self.longPress.pressEvent(obj, state)
        if state and self.dragScrollView then
          return
        end
        self.dragDropComponent.DragEnable = state and self.DragEnable
        if state and self.DragEnable then
          self.dragDropComponent:ManualStartDrag()
        else
          self.dragDropComponent:ManualEndDrag()
        end
      end
    end
  end
  self.dragDropComponent.OnCursor = DragCursorPanel.Instance.JustShowIcon
  self:SetDragEnable(false)
end
function DragDropCell:SetDragEnable(value)
  self.DragEnable = value
  if self.dragDropComponent and not value then
    self.dragDropComponent.DragEnable = false
  end
end
function DragDropCell:GetDragEnable()
  return self.DragEnable
end
function DragDropCell:SetScrollView(isDrag)
  self.dragScrollView = isDrag
end
