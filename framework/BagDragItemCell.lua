autoImport("BagItemCell");
autoImport("DragDropCell")
BagDragItemCell = class("BagDragItemCell", BagItemCell);

function BagDragItemCell:Init()
	BagDragItemCell.super.Init(self);

	self:InitDragEvent();
end

function BagDragItemCell:InitDragEvent()
	self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
	self.dragDrop.dragDropComponent.OnCursor = DragCursorPanel.Instance.ShowItemCell
end

function BagDragItemCell:SetData(data)
	BagDragItemCell.super.SetData(self, data);
	if(data and data~="Grey" and data~="Empty")then
		self.dragDrop.dragDropComponent.data = {itemdata = data};
	else
		self.dragDrop.dragDropComponent.data = nil;
	end
end

function BagDragItemCell:CanDrag(value)
	self.dragDrop:SetDragEnable(value)
end