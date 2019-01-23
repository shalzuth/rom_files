autoImport("BaseAttributeCell")
XDECharBaseAttributeCell = class("XDEBaseAttributeCell",BaseAttributeCell)


function XDECharBaseAttributeCell:Init( )
	XDECharBaseAttributeCell.super.Init(self);
end


function XDECharBaseAttributeCell:SetData( data )
	XDECharBaseAttributeCell.super.SetData(self, data);
	self.value.transform.localPosition = Vector3(469,0,0)
end
