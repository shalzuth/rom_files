local BaseCell = autoImport("BaseCell");
AstrolabeMaterilaCell = class("AstrolabeMaterilaCell", BaseCell)

function AstrolabeMaterilaCell:Init()
	AstrolabeMaterilaCell.super.Init()
	self:FindObjs()
end

function AstrolabeMaterilaCell:FindObjs()
	self.icon=self.gameObject:GetComponent(UISprite)
	self.label=self:FindComponent("label",UILabel)
end

function AstrolabeMaterilaCell:SetData(data)
	self.label.text=StringUtil.NumThousandFormat(data[2])
	local iconName = Table_Item[data[1]].Icon
	IconManager:SetItemIcon(iconName,self.icon)
end

function AstrolabeMaterilaCell:GetLabelWidth()
	return self.label.width+self.icon.width
end

function AstrolabeMaterilaCell:GetHeight()
	return self.icon.height
end