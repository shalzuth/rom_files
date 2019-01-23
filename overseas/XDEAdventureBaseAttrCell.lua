autoImport("AdventureBaseAttrCell")
XDEAdventureBaseAttrCell = class("XDEBaseAttributeCell",AdventureBaseAttrCell)


function XDEAdventureBaseAttrCell:Init( )
	XDEAdventureBaseAttrCell.super.Init(self);

	--todo xde
	self.value = self:FindGO("Value"):GetComponent(UILabel)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	OverseaHostHelper:FixLabelOverV1(self.value,3,130)
	OverseaHostHelper:FixLabelOverV1(self.name,3,200)
end


function XDEAdventureBaseAttrCell:SetData( data )
	XDEAdventureBaseAttrCell.super.SetData(self, data);
end
