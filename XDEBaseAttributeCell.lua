autoImport("BaseAttributeCell")
XDEBaseAttributeCell = class("XDEBaseAttributeCell",BaseAttributeCell)


function XDEBaseAttributeCell:Init( )
	XDEBaseAttributeCell.super.Init(self);
end


function XDEBaseAttributeCell:SetData( data )
	XDEBaseAttributeCell.super.SetData(self, data);

	self.name.pivot = UIWidget.Pivot.Left
	self.name.transform.localPosition = Vector3(0,0,0)
--
--	self.value.pivot = UIWidget.Pivot.Left
--	self.value.transform.localPosition = Vector3(0,0,0)
end
