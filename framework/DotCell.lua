local baseCell = autoImport("BaseCell")
DotCell = class("DotCell", baseCell)

local DotNormal = Color(175/255, 175/255, 175/255, 1)
local DotChoose = Color(1, 175/255, 30/255, 1)

function DotCell:Init()
	self:FindObjs()
end

function DotCell:FindObjs()
	self.dotSp = self.gameObject:GetComponent(UISprite)
end

function DotCell:SetChoose(isChoose)
	if isChoose then
		self.dotSp.color = DotChoose
	else
		self.dotSp.color = DotNormal
	end
end