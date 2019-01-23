autoImport("BaseItemCell");
SetQuickItemCell = class(SetQuickItemCell, BaseItemCell);

SetQuickItemCell.SwapObj = "SetQuickItemCell_SwapObj";

function SetQuickItemCell:Init()
	SetQuickItemCell.super.Init(self);
	self:InitCell();
end

function SetQuickItemCell:InitCell()
	
	self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
	self.dragDrop.dragDropComponent.OnCursor = DragCursorPanel.Instance.ShowItemCell
	self.dragDrop:SetDragEnable(true);
	self.dragDrop.dragDropComponent.OnReplace = function(data)
		if(data)then
			self:PassEvent(SetQuickItemCell.SwapObj, {surce = data, target = self});
		end
	end
	self.dragDrop.dragDropComponent.OnDropEmpty = function(data)
		self:RemoveQuickItem();
	end

	self.remove = self:FindGO("Remove");
	self:AddClickEvent(self.remove, function (go)
		self:RemoveQuickItem();
	end);
end

function SetQuickItemCell:SetQuickPos(pos)
	self.pos = pos;
end

function SetQuickItemCell:RemoveQuickItem()
	local data = self.data;
	if(data and self.pos)then
		local key = {
			guid = nil,
			type = nil,
			pos = self.pos-1,
		};
		ServiceNUserProxy.Instance:CallPutShortcut(key);
	end
end

function SetQuickItemCell:SetData(data)
	SetQuickItemCell.super.SetData(self, data);

	if(data)then
		self:SetIconGrey(data.id == "Shadow");
		if(data.id~="Shadow")then
			self.dragDrop.dragDropComponent.data = {itemdata = data, pos = self.pos};
		end
		self.remove:SetActive(true);
	else
		self.remove:SetActive(false);
	end
end