autoImport("ItemCell")
DragCursorPanel = class("DragCursorPanel",BaseView)

DragCursorPanel.ViewType = UIViewType.DragLayer

DragCursorPanel.Instance = nil

function DragCursorPanel:Init()
	DragCursorPanel.Instance = self
	self.cursorContainer = UICursorWithTween.Instance.gameObject
	self.cell = nil
end

function DragCursorPanel:GetCell(cellClass,cellPrefab)
	if(self.cell==nil or self.cell.class ~= cellClass) then
		local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cellPrefab), self.cursorContainer);
		local cell = cellClass.new(cellpfb)
		self.cell = cell
	end
	return self.cell
end

function DragCursorPanel.ShowItemCell(dragitem)
	local cell = DragCursorPanel.Instance:GetCell(ItemCell,"ItemCell")
	local itemData = dragitem.data.itemdata;
	cell:SetData(itemData)
	UICursorWithTween.SetGameObject(cell.gameObject)
end

function DragCursorPanel.JustShowIcon(dragitem)
	 UICursorWithTween.Set(dragitem.icon.atlas, dragitem.icon.spriteName)
end