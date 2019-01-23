
local baseCell = autoImport("BaseCell")
PetSpecialMonsterCell = class("PetSpecialMonsterCell", baseCell)

local allMonster = 'pet_icon_all'
PetSpecChooseEvent = {
	OnClickMonster = "PetSpecChooseEvent_OnClickMonster",
}

function PetSpecialMonsterCell:Init()
	self:FindObjs()
	self:AddEvts()
end

function PetSpecialMonsterCell:FindObjs()
	self.icon = self:FindComponent("Icon", UISprite)
	self.frame = self:FindComponent("frame",UISprite)
end

function PetSpecialMonsterCell:AddEvts()
	self:AddClickEvent(self.frame.gameObject, function ()
		self:PassEvent(PetSpecChooseEvent.OnClickMonster, self)
	end)
	self:AddCellClickEvent()
end

function PetSpecialMonsterCell:SetData(data)
	self.monsterID = data
	self.gameObject:SetActive(nil~=data)
	if(data)then
		if(0==data)then
			IconManager:SetUIIcon(allMonster,self.icon)
		else
			IconManager:SetFaceIcon(Table_Monster[data].Icon, self.icon)
		end
	end
end