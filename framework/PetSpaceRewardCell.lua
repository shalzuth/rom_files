local BaseCell = autoImport("BaseCell");
PetSpaceRewardCell = class("PetSpaceRewardCell", BaseCell);
local _numFormat = "×%s"

function PetSpaceRewardCell:Init()
	self:FindGo()
	self:AddEvn()
end

function PetSpaceRewardCell:FindGo()
	self.Icon = self:FindComponent("Icon", UISprite);
	self.Num = self:FindComponent("Num",UILabel);
	self.tip = self:FindGO("Tip")
end

function PetSpaceRewardCell:AddEvn()
	self:AddClickEvent(self.tip,function (g)
		self:OpenTip(g)
	end)
end

function PetSpaceRewardCell:SetData(data)
	self.data = data;
	if(data)then
		local icon = Table_Item[data.id] and Table_Item[data.id].Icon or ""
		IconManager:SetItemIcon(icon,self.Icon)
		self.Num.text = string.format(_numFormat,data.num)
		if(data.helpDesc)then
			self:Show(self.tip)
		else
			self:Hide(self.tip)
		end
	end
end

function PetSpaceRewardCell:OpenTip()
	local desc = self.data and self.data.helpDesc
	if(desc)then
		TipsView.Me():ShowGeneralHelp(desc)
	end
end
